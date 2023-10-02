Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0994F7B4FAA
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 11:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbjJBJ57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 05:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbjJBJ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 05:57:57 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172E9A7;
        Mon,  2 Oct 2023 02:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=nDcMECDXAxc3Yrl3Jp44BBQI/ASgsDkZDKNgpLmcJiE=; b=hl7wLQ
        Ycn5Rmnfeig1ImPI8wakjB8coQiDXmmsx1CzJeSrO8oLeSZRuLBeIG2VEqU5krY1qb8YCHn89CJGe
        42ud+yym9CFHgfsSarmAtbywdbqRK67OknwxtG2l0NZyAvn2KMHvHw+LREf40C/XxlzqmZvpX2xJM
        Tx8xxVZ7Ve0=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qnFgS-0000v4-R8; Mon, 02 Oct 2023 09:57:48 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qnFgS-0000Ft-DL; Mon, 02 Oct 2023 09:57:48 +0000
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
Subject: [PATCH v7 00/11] KVM: xen: update shared_info and vcpu_info handling
Date:   Mon,  2 Oct 2023 09:57:29 +0000
Message-Id: <20231002095740.1472907-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

The following text from the original cover letter still serves as an
introduction to the series:

"Currently we treat the shared_info page as guest memory and the VMM
informs KVM of its location using a GFN. However it is not guest memory as
such; it's an overlay page. So we pointlessly invalidate and re-cache a
mapping to the *same page* of memory every time the guest requests that
shared_info be mapped into its address space. Let's avoid doing that by
modifying the pfncache code to allow activation using a fixed userspace HVA
as well as a GPA."

This version of the series is functionally the same as version 6. I have
simply added David Woodhouse's R-b to patch 11 to indicate that he has
now fully reviewed the series.

Paul Durrant (11):
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
  KVM: xen: allow vcpu_info content to be 'safely' copied

 Documentation/virt/kvm/api.rst                |  53 +++++--
 arch/x86/kvm/x86.c                            |   5 +-
 arch/x86/kvm/xen.c                            |  92 +++++++++----
 include/linux/kvm_host.h                      |  43 ++++++
 include/linux/kvm_types.h                     |   3 +-
 include/uapi/linux/kvm.h                      |   9 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  59 ++++++--
 virt/kvm/pfncache.c                           | 129 +++++++++++++-----
 8 files changed, 302 insertions(+), 91 deletions(-)
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

