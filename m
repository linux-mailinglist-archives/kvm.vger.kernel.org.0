Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05D5E54C6
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 22:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiIUUyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 16:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiIUUyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 16:54:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E9113E21
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:54:39 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e67so1002151pgc.12
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=dWgCHmwtaVMOWvPLiLtxN+wSpQ47L+GlwZ+oGbBWrIU=;
        b=h0k/7QwmM22p54PBBDL8qRy1KTjPPLxqBedhbVOanackvYMabGMnri/tUPnROymwvM
         iHpMKiYzJGE4aMfljcWn8WMM1t5HMvQG50pnBOcsVnQ9rbvffEueJij6KXJO/3TT+cwL
         Hkv02ifJTmsklbkqgyJ0Fyp3UOLJ9QNH9kBKWgM7rYaYtw4F82S/N675quiS85RmbiGs
         khEbgeABCUe4MLi7kdCHpqTS46IkeItpqSbwoG2g2Xb1tNBIK7+TUNIv7MpTADbeWqaz
         HpSF+WZF0FCBbuorBMCi5kkff6hcGl92JHYd8USQsKcXGWPARb0qN+b8kOneJWQb0wDS
         vMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dWgCHmwtaVMOWvPLiLtxN+wSpQ47L+GlwZ+oGbBWrIU=;
        b=sR4PjYxL8EQIjOwnH/1tC/D015stIsFfaQZg6cJoas6HtTJkiZMh0iLmCAubVr6137
         Pcg5sXNrmcvB4OGWao2WHyaL7R0yDOkV52Mmcd817OCqkX8b2joDsFt2i5xDZ3vgly1u
         rRbzJAVGGSExzId5axjIHhZGy5IX9TyQkMIvw3BkT1Cs8jftoEGmMs0MNeGDnG/Zd30L
         4WCNP89hwNRKfULflHjJVHQpWwXw/tqnPVbenBrkqR9yDftEel5zyL40W3s26p1w/t1/
         IEZ+boNhkVFrQPyCuD03ziBSIKUZr54yr/v1J0CGliSebwYcBV5snDdda45O5qLdQ0dX
         7M1w==
X-Gm-Message-State: ACrzQf37yzRjwiQzP7tGMr9wDv+7USnXAmzaCsfJ5kmd5/aVaLHgsTRH
        MoIUQFaO73bBVKKqiiIf5lL/nw==
X-Google-Smtp-Source: AMsMyM6mhqVCjpzRVWzQWBhmm1HNoRW7irLWmFzWydShPHcqk2sZTzcAY1nF0dQc06rr6XF57bn99w==
X-Received: by 2002:a63:ff50:0:b0:439:ae51:503c with SMTP id s16-20020a63ff50000000b00439ae51503cmr67639pgk.158.1663793679088;
        Wed, 21 Sep 2022 13:54:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ay11-20020a17090b030b00b001fdcb792181sm2297408pjb.43.2022.09.21.13.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 13:54:38 -0700 (PDT)
Date:   Wed, 21 Sep 2022 20:54:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 10/39] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Message-ID: <Yyt6Clofhg7u+bI+@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-11-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-11-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> Get rid of on-stack allocation of vcpu_mask and optimize kvm_hv_send_ipi()
> for a smaller number of vCPUs in the request. When Hyper-V TLB flush
> is in  use, HvSendSyntheticClusterIpi{,Ex} calls are not commonly used to
> send IPIs to a large number of vCPUs (and are rarely used in general).
> 
> Introduce hv_is_vp_in_sparse_set() to directly check if the specified
> VP_ID is present in sparse vCPU set.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 69891c48c12a..9764ebb7fd5f 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1741,6 +1741,25 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
>  	}
>  }
>  
> +static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_banks[])
> +{
> +	int bank, sbank = 0;
> +
> +	if (!test_bit(vp_id / HV_VCPUS_PER_SPARSE_BANK,
> +		      (unsigned long *)&valid_bank_mask))
> +		return false;
> +
> +	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
> +			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS) {
> +		if (bank == vp_id / HV_VCPUS_PER_SPARSE_BANK)
> +			break;
> +		sbank++;

At the risk of being too clever, this can be heavily optimized, which given what
this helper is used for is probably worth doing.  The index into sparse_banks is
the number of bits preceding the target bit, and POPCNT can determine the number
of bits.  So, to get the index, simply strip off the upper bits and do hweight64().

And to avoid bugs while also optimizing for "small" VMs, the math can be skipped
if vp_id < 64, i.e. if bank==0, because in that case there can't possibly be
preceding bits.

Compile tested only...

	int valid_bit_nr = vp_id / HV_VCPUS_PER_SPARSE_BANK;
	unsigned long sbank;

	if (!test_bit(valid_bit_nr, (unsigned long *)&valid_bank_mask))
		return false;

	/*
	 * The index into the sparse bank is the number of preceding bits in
	 * the valid mask.  Optimize for VMs with <64 vCPUs by skipping the
	 * fancy math if there can't possibly be preceding bits.
	 */
	if (valid_bit_nr)
		sbank = hweight64(valid_bank_mask & GENMASK_ULL(valid_bit_nr - 1, 0));
	else
		sbank = 0;

	return test_bit(vp_id % HV_VCPUS_PER_SPARSE_BANK,
			(unsigned long *)&sparse_banks[sbank]);

yields this, where the "call __sw_hweight64" will be patched to POPCNT on 64-bit
hosts (POPCNT has been around for a long time).

   	call   0xffffffff810c3ea0 <__fentry__>
   	push   %rbp
   	mov    %edi,%eax
   	mov    %rsp,%rbp
   	shr    $0x6,%eax
   	sub    $0x8,%rsp
   	mov    %rsi,-0x8(%rbp)
   	mov    %eax,%ecx
   	bt     %rcx,-0x8(%rbp)
   	setb   %cl
   	jae    0xffffffff81064784 <hv_is_vp_in_sparse_set+52>
   	test   %eax,%eax
   	mov    %edi,%r8d
   	jne    0xffffffff8106478c <hv_is_vp_in_sparse_set+60>
   	and    $0x3f,%r8d
   	bt     %r8,(%rdx)
   	setb   %cl
   	leave  
   	mov    %ecx,%eax
   	jmp    0xffffffff81c02200 <__x86_return_thunk>
   	mov    $0x40,%ecx
   	mov    $0xffffffffffffffff,%rdi
   	sub    %eax,%ecx
   	shr    %cl,%rdi
   	and    -0x8(%rbp),%rdi
   	call   0xffffffff815beea0 <__sw_hweight64>
   	lea    (%rdx,%rax,8),%rdx
   	jmp    0xffffffff81064779 <hv_is_vp_in_sparse_set+41>

Alternatively, we could choose not to optimize bit==0 and just do:

	sbank = hweight64(valid_bank_mask & GENMASK_ULL(valid_bit_nr, 0)) - 1;

but there's enough prep work needed for hweight64() that I think it's worth
opimtizing because "small" VMs are probably very common.
