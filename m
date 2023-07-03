Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D05274568D
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 09:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjGCH4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 03:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjGCH4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 03:56:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6368EC4;
        Mon,  3 Jul 2023 00:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688370991; x=1719906991;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=msbhNTf/G7th43CRx3Cr0z8TUl3KRarlnGHXBxmCHLA=;
  b=axM8aaVS+esx5wWCjb2m8TMX+5g+wKt9qA/r8UnDEfyP2gNAolzA62Y4
   WvK5Ytk4+J9an6xXFerNZ+kO9uCcNI+cyuVhXXZEiTXG/881YBT5LXZvs
   Ka1LPFeOJxHg0GE6DYZYDPUruWTxuKA9qJdG4NCaoKeXYAYKrD9AY8yD/
   67FyOBamr+fd45nscP1XrMQHf8XtG+pbbu6jVg9LjAowmzeubWXLXCn5s
   Hm84QBDzdaNx/nhmDHVKm/Uvjex0fA6sNWujl2xIPJs/MwnFGhKu0Iikm
   veDv5C8M2YIhl64ay8H84+PXcTPKnVtALBrte4eloYa6nGUVRDV7GuWrc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="347603896"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="347603896"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 00:56:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="831723497"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="831723497"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 00:56:27 -0700
Message-ID: <5caef6bf-c3da-5928-32c9-54d6e42511ec@linux.intel.com>
Date:   Mon, 3 Jul 2023 15:56:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v9 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-4-binbin.wu@linux.intel.com>
 <ZJtzdftocuwTvp67@google.com>
 <e11e348c-3763-8eda-281d-c8d965cd52b6@linux.intel.com>
 <ZJxwgCx3YatyH9or@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZJxwgCx3YatyH9or@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/29/2023 1:40 AM, Sean Christopherson wrote:
> On Wed, Jun 28, 2023, Binbin Wu wrote:
>>
>> On 6/28/2023 7:40 AM, Sean Christopherson wrote:
>>> I think I'd prefer to drop this field and avoid bikeshedding the name entirely.  The
>>> only reason to effectively cache "X86_CR3_LAM_U48 | X86_CR3_LAM_U57" is because
>>> guest_cpuid_has() is slow, and I'd rather solve that problem with the "governed
>>> feature" framework.
>> Thanks for the suggestion.
>>
>> Is the below patch the lastest patch of "governed feature" framework
>> support?
>> https://lore.kernel.org/kvm/20230217231022.816138-2-seanjc@google.com/
> Yes, I haven't refreshed it since the original posting.
>
>> Do you have plan to apply it to kvm-x86 repo?
> I'm leaning more and more towards pushing it through sooner than later as this
> isn't the first time in recent memory that a patch/series has done somewhat odd
> things to workaround guest_cpuid_has() being slow.  I was hoping to get feedback
> before applying, but that's not looking likely at this point.
Hi Sean,

I plan to adopt the "KVM-governed feature framework" to track whether 
the guest can use LAM feature.
Because your patchset is not applied yet, there are two ways to do it. 
Which one do you prefer?

Option 1:
Make KVM LAM patchset base on your "KVM-governed feature framework" 
patchset.

Option 2:
Temporarily add a bool in kvm_vcpu_arch as following, and use the bool 
"can_use_lam" instead of guest_can_use(vcpu, X86_FEATURE_LAM).
And provide a cleanup patch to use "KVM-governed feature framework", 
which can be applied along with or after your patchset.

index fb9d1f2d6136..74c0c70b0a44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ struct kvm_vcpu_arch {
         bool tpr_access_reporting;
         bool xsaves_enabled;
         bool xfd_no_write_intercept;
+       bool can_use_lam;
         u64 ia32_xss;
         u64 microcode_version;
         u64 arch_capabilities;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d9d155691a7..5b2db5daebb3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7737,6 +7737,9 @@ static void vmx_vcpu_after_set_cpuid(struct 
kvm_vcpu *vcpu)
                 vmx->msr_ia32_feature_control_valid_bits &=
                         ~FEAT_CTL_SGX_LC_ENABLED;

+       vcpu->arch.can_use_lam = boot_cpu_has(X86_FEATURE_LAM) &&
+                                guest_cpuid_has(vcpu, X86_FEATURE_LAM);
+
         /* Refresh #PF interception to account for MAXPHYADDR changes. */
         vmx_update_exception_bitmap(vcpu);
  }

[...]
