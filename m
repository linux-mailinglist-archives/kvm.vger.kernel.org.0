Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778B569E2C8
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 15:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjBUO4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 09:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjBUO4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 09:56:39 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6B22A143;
        Tue, 21 Feb 2023 06:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676991397; x=1708527397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VE7TJfrm4RZ6eDfArZktuMj3vWfcIklvlSsBd6+oiXY=;
  b=g6MfmMNvmil6qhPlX9QVLQZ+22eI5xKbogpSrOmRrLHsjIFIIPscsx3e
   Bg0U9aWRUAnRCkjeJHo2bVULY0tG8lp2SJBVRSdnxtiz+T+IWhVWtn6qI
   uEDelhDwEvZqa0kFx4MQyCiLilm4kzE/hGPioyxNWhPbG/HezzByDNO82
   GhmSAz8wbQINXMQMC3wGk1OFP6a6sukhRRFI/I9v1s1RIJlBXeVCqrAqz
   RPj8LlIM2Ub9/A+59DfeWZVgVg8eu7ATa0NZxqErbvaYrbhb0K+FV1IlO
   ZwoKK3rZQD1F3ttr4I7pGXUuJSd+7jprZDDjScTNgrRJ5Cb4VDzf6gZ2s
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="418870401"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="418870401"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 06:56:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="704058316"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="704058316"
Received: from yichaohu-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.208.83])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 06:56:13 -0800
Date:   Tue, 21 Feb 2023 22:56:10 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] KVM: x86: Use KVM-governed feature framework to
 track "XSAVES enabled"
Message-ID: <20230221145610.ytlj5nkqsscc2yxo@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217231022.816138-6-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 03:10:15PM -0800, Sean Christopherson wrote:
> Use the governed feature framework to track if XSAVES is "enabled", i.e.
> if XSAVES can be used by the guest.  Add a comment in the SVM code to
> explain the very unintuitive logic of deliberately NOT checking if XSAVES
> is enumerated in the guest CPUID model.
> 
> No functional change intended.

xsaves_enabled in struct kvm_vcpu_arch is no longer used. But instead of
just deleting it, maybe we could move 'bool load_eoi_exitmap_pending' to
its place, so 7 bytes can be saved for each struct kvm_vcpu_arch:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd660de02f7b..0eef5469c165 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -740,7 +740,6 @@ struct kvm_vcpu_arch {
        u64 efer;
        u64 apic_base;
        struct kvm_lapic *apic;    /* kernel irqchip context */
-       bool load_eoi_exitmap_pending;
        DECLARE_BITMAP(ioapic_handled_vectors, 256);
        unsigned long apic_attention;
        int32_t apic_arb_prio;
@@ -750,7 +749,7 @@ struct kvm_vcpu_arch {
        u64 smi_count;
        bool at_instruction_boundary;
        bool tpr_access_reporting;
-       bool xsaves_enabled;
+       bool load_eoi_exitmap_pending;
        bool xfd_no_write_intercept;
        u64 ia32_xss;
        u64 microcode_version;

B.R.
Yu
