Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4C7AB44F
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjIVPAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjIVPAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:00:34 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232E192;
        Fri, 22 Sep 2023 08:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=veyuo/TIb+MJoFHcP9P3h4NJnq8iJPlYSXkc4ngQJJ0=; b=c5+N52
        CyYGcHSGOmitfNtvJwqlwSRLYP5KWFJy05PPN9qKzVeDBlbRFTBggvJzOGxoIpCk8ojaRSltbyz+i
        Ag0DdZ/7WXEle4e0bpNZUrnKAYs/MBGaiwNahNnZ7a15+/fZs6UqAsHcIrk7sO613i+TzjxwLM8bZ
        9Y8yvahNOY0=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qjhdl-00044Z-CN; Fri, 22 Sep 2023 15:00:21 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qjhdl-0005y2-3R; Fri, 22 Sep 2023 15:00:21 +0000
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
Subject: [PATCH v5 00/10] KVM: xen: update shared_info and vcpu_info handling
Date:   Fri, 22 Sep 2023 14:59:59 +0000
Message-Id: <20230922150009.3319-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

The following part of the original cover letter still applies...

"Currently we treat the shared_info page as guest memory and the VMM
informs KVM of its location using a GFN. However it is not guest memory as
such; it's an overlay page. So we pointlessly invalidate and re-cache a
mapping to the *same page* of memory every time the guest requests that
shared_info be mapped into its address space. Let's avoid doing that by
modifying the pfncache code to allow activation using a fixed userspace
HVA as well as a GPA."

However, this version of the series has dropped the other changes to try
to handle the default vcpu_info location directly in KVM. With all the
corner cases, it was getting sufficiently complex the functionality is
better off staying in the VMM. So, instead of that code, two new patches
have been added:

"xen: allow vcpu_info to be mapped by fixed HVA" is analogous to the
"xen: allow shared_info to be mapped by fixed HVA" patch that has been
present from the original version of the series and simply provides an
attribute to that vcpu_info can be mapped using a fixed userspace HVA,
which is desirable when using one embedded in the shared_info page (since
we similarly avoid pointless cache invalidations).

"selftests / xen: re-map vcpu_info using HVA rather than GPA" is just a
small addition to the 'xen_shinfo_test' selftest to swizzle the vcpu_info
mapping to show that there's no functional change.

Paul Durrant (10):
  KVM: pfncache: add a map helper function
  KVM: pfncache: add a mark-dirty helper
  KVM: pfncache: add a helper to get the gpa
  KVM: pfncache: base offset check on khva rather than gpa
  KVM: pfncache: allow a cache to be activated with a fixed (userspace)
    HVA
  KVM: xen: allow shared_info to be mapped by fixed HVA
  KVM: xen: allow vcpu_info to be mapped by fixed HVA
  KVM: selftests / xen: map shared_info using HVA rather than GFN
  KVM: selftests / xen: re-map vcpu_info using HVA rather than GPA
  KVM: xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA capability

 Documentation/virt/kvm/api.rst                |  53 +++++--
 arch/x86/kvm/x86.c                            |   5 +-
 arch/x86/kvm/xen.c                            |  89 ++++++++----
 include/linux/kvm_host.h                      |  43 ++++++
 include/linux/kvm_types.h                     |   3 +-
 include/uapi/linux/kvm.h                      |   9 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  59 ++++++--
 virt/kvm/pfncache.c                           | 129 +++++++++++++-----
 8 files changed, 302 insertions(+), 88 deletions(-)
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

