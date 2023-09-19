Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C1F7A657B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjISNmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 09:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjISNmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 09:42:09 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC07F4;
        Tue, 19 Sep 2023 06:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=y2odupsqdyYFtVH01DAeQQ9s6gOIdXVgvjaA8jYAyJA=; b=2HQaQ7
        VwhLGYJXBUiEDE+j6Q7JaqFyo0KyAbGPnsmYH5mwmJYy/xNoEMlYAHgbsAAePat2ouQMrV6aH9o/s
        K5FZjS65RjuiELBu3rHJFSoGgYN9TJ5PT4cUvQ+0JoPbUphUlZebTG2QS4s228eWheMikD9061c+t
        WllJZ6ZKOSM=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazD-00045Z-OI; Tue, 19 Sep 2023 13:41:55 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazD-0005jy-Ce; Tue, 19 Sep 2023 13:41:55 +0000
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
Subject: [PATCH v4 00/13] KVM: xen: update shared_info and vcpu_info handling
Date:   Tue, 19 Sep 2023 13:41:36 +0000
Message-Id: <20230919134149.6091-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Changed in v4:
 - The offset into the cache returned from get_vcpu_info_cache() was not
   being factored into kvm_gpc_check() or kvm_gpc_refresh() calls. Fix
   this.
 - When transitioning from a default vcpu_info to an explicit one, copy
   the content across. This was previously the responsibility of the
   VMM.

Changed in v3:
 - Patch added to make sure Xen vcpu_id is immutable once shared_info is
   set.
 - Adjust the xen_shinfo_test selftest accordingly.
 - Also have the selftest use both mechanisms to set shared_info.
 - Add text to API documentation discussing copying of vcpu_info. This
   has been removed in v4.
 - Adjust the selftest to switch from default to explicit vcpu_info
   part way through.

Changed in v2:
 - Defer advertizement of KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA to a patch
   at the end of the series.
 - Remove the KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO capability.
 - Add selftests and API documentation.

Original text:

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

Paul Durrant (13):
  KVM: pfncache: add a map helper function
  KVM: pfncache: add a mark-dirty helper
  KVM: pfncache: add a helper to get the gpa
  KVM: pfncache: base offset check on khva rather than gpa
  KVM: pfncache: allow a cache to be activated with a fixed (userspace)
    HVA
  KVM: xen: allow shared_info to be mapped by fixed HVA
  KVM: xen: prepare for using 'default' vcpu_info
  KVM: xen: prevent vcpu_id from changing whilst shared_info is valid
  KVM: xen: automatically use the vcpu_info embedded in shared_info
  KVM: selftests / xen: set KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
  KVM: selftests / xen: map shared_info using HVA rather than GFN
  KVM: selftests / xen: don't explicitly set the vcpu_info address
  KVM: xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA capability

 Documentation/virt/kvm/api.rst                |  52 ++--
 arch/x86/include/asm/kvm_host.h               |   4 +
 arch/x86/kvm/x86.c                            |  17 +-
 arch/x86/kvm/xen.c                            | 244 ++++++++++++++----
 arch/x86/kvm/xen.h                            |   6 +-
 include/linux/kvm_host.h                      |  43 +++
 include/linux/kvm_types.h                     |   3 +-
 include/uapi/linux/kvm.h                      |   6 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  75 +++++-
 virt/kvm/pfncache.c                           | 129 ++++++---
 10 files changed, 454 insertions(+), 125 deletions(-)
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

