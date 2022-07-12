Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF5457122A
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 08:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiGLGPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 02:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLGPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 02:15:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5356381482;
        Mon, 11 Jul 2022 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657606506; x=1689142506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e8t4m3KSkmOMZJqJPmnwIUB4x8PWpY13C+jIK4OpPdk=;
  b=Bj4lOYyS8/pHcS3o6u0RNabm8fWNib0glCPlLCyC/20bkyxhzQk9q7pj
   C3ipmiJZqC7Y74N2j7sG2lUV0v7pvfCH0bVhy6/wDE/5UiNaQC0FPfn/U
   JofedWty7gdu59OR+Yu5NPe1rY/wbaummpn09NHJ92ySX0vFUzo2eocIN
   0Sm2ZppPFGV0hR4a+Ob4+2fLfVnFGxqR6OyB0+uv9V+hNLwjvjPm+saFT
   ZKmi7k0xezKJDQV17FJ2C8jcNfCEdW+FkjgLTwBzXQuR1UfvQE5owqcVY
   FRc+rG3g4hWLQqgWwfCEpApnZBIlxpcxcvJhMjS5jPjMxI/EjGmYKk6wc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="371157329"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="371157329"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 23:15:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="622378386"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 23:15:03 -0700
Date:   Tue, 12 Jul 2022 14:14:45 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 053/102] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Message-ID: <20220712061439.GA28707@gao-cwp>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <bcdcc4175321ff570a198aa55f8ac035de2add1f.1656366338.git.isaku.yamahata@intel.com>
 <20220712034743.glrfvpx54ja6jrzg@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712034743.glrfvpx54ja6jrzg@yy-desk-7060>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 11:47:43AM +0800, Yuan Yao wrote:
>On Mon, Jun 27, 2022 at 02:53:45PM -0700, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TDX doesn't need APIC page depending on vapic and its callback is
>> WARN_ON_ONCE(is_tdx).  To avoid unnecessary overhead and WARN_ON_ONCE(),
>> skip requesting KVM_REQ_APIC_PAGE_RELOAD when TD.

!kvm_gfn_shared_mask() doesn't ensure the VM is a TD. Right?

>>
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>  arch/x86/kvm/x86.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8f57dfb2a8c9..c90ec611de2f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10042,7 +10042,8 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>>  	 * Update it when it becomes invalid.
>>  	 */
>>  	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
>> -	if (start <= apic_address && apic_address < end)
>> +	if (start <= apic_address && apic_address < end &&
>> +	    !kvm_gfn_shared_mask(kvm))
>
>Minor: please condier to check kvm_gfn_shared_mask(kvm) before range,
>means firstly check is or not, then suitable or not.
>
>>  		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>>  }
>>
>> --
>> 2.25.1
>>
