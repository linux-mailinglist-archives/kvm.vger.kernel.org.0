Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81E879FF96
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbjINJHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbjINJHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:07:18 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C661FC7;
        Thu, 14 Sep 2023 02:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=BiwMgQGY2JFvget57tuuYB87rQmZEJZVNSqu4ha4SDA=; b=rs0LqA
        fxERVgwCdNrEmy5exr1sg3XV55Rmw/aK/2Hf6sP2+/9i/i3n/rUm7eW1EAIA+v7IFy49dw/ayqohq
        xfriMtmYPHZ4B8EYEeVyozaZsDpF6VLjpxF3JIfEBpIv2fERgE8JBMWnJ9XfrqnbihzD/dLbKO0Zs
        FPBqHcqiQ2k=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi35-0001iL-QQ; Thu, 14 Sep 2023 08:50:07 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi35-0002T9-FU; Thu, 14 Sep 2023 08:50:07 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH 0/8] KVM: xen: update shared_info and vcpu_info handling
Date:   Thu, 14 Sep 2023 08:49:38 +0000
Message-Id: <20230914084946.200043-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Currently we treat the shared_info page as guest memory and the VMM informs
KVM of its location using a GFN. However it is not guest memory as such;
it's an overlay page. So we pointlessly invalidate and re-cache a mapping
to the *same page* of memory every time the guest requests that shared_info
be mapped into its address space. Let's avoid doing that by modifying the
pfncache code to allow activation using a fixed userspace HVA as well as
a GPA.

Also, if the guest does not hypercall to explicitly set a pointer to a
vcpu_info in its own memory, the default vcpu_info embedded in the
shared_info page should be used. At the moment the VMM has to set up a
pointer to the structure explicitly (again treating it like it's in
guest memory, despite being in an overlay page). Let's also avoid the
need for that. We already have a cached mapping for the shared_info
page so just use that directly by default.

Paul Durrant (8):
  KVM: pfncache: add a map helper function
  KVM: pfncache: add a mark-dirty helper
  KVM: pfncache: add a helper to get the gpa
  KVM: pfncache: base offset check on khva rather than gpa
  KVM: pfncache: allow a cache to be activated with a fixed (userspace)
    HVA
  KVM: xen: allow shared_info to be mapped by fixed HVA
  KVM: xen: prepare for using 'default' vcpu_info
  KVM: xen: automatically use the vcpu_info embedded in shared_info

 arch/x86/include/asm/kvm_host.h |   4 +
 arch/x86/kvm/x86.c              |  18 ++---
 arch/x86/kvm/xen.c              | 121 ++++++++++++++++++++++--------
 arch/x86/kvm/xen.h              |   6 +-
 include/linux/kvm_host.h        |  43 +++++++++++
 include/linux/kvm_types.h       |   3 +-
 include/uapi/linux/kvm.h        |   7 +-
 virt/kvm/pfncache.c             | 129 +++++++++++++++++++++++---------
 8 files changed, 251 insertions(+), 80 deletions(-)
---
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
-- 
2.39.2

