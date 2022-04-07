Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3914F867B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346550AbiDGRqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346546AbiDGRqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:46:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD0A22C8D7
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 10:44:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r66so5567781pgr.3
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 10:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qtoCtjXmVQ0hZo+pdgUMIKZ+OC7BYRWQN9tD6eVQtks=;
        b=Ev+c+8F1X8VSZoYa+u+L7bRSkLtSGbgtXQMchuEWerfAy2WqXdaO4e7p28uSMMtQgm
         pDR0dADnMTGQo9FfSSyJnIzwK0HUiHup+PIVo4DZ+9RHdkJ/CJuJ5oOU+jL9mYIUn/1O
         DG1Pc7TDGx35uQZx8en4XtMgq2PaZvKjP1Qkq2WqDUuaROtkdhl6WNRe5GMPm/4Z5qdI
         42QrrKeAzAS/UtpN0G0OQZ2GG+Ah2MGybWoH7cuGo/wEnPyJeo0/IFMppHHGsu6w6e3j
         At3TAzfOxOs3r1wCZK6eaw2NPU53IOz5maScWNTiw7PapkK7/zSMaeTuKG8eEgSr1HGN
         YRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qtoCtjXmVQ0hZo+pdgUMIKZ+OC7BYRWQN9tD6eVQtks=;
        b=vhK9J560CVpyRLLwCz+S31iJHcTEv7+JmhMCD/S5so4muK6tvIUkd4R4DOI7X8VKBw
         6l+1Ae+WfvUh6dE7skdkr63RcBlsfSZPjQdIMAeAzZ3tYfYvvrt/7ugDPeFNkfMLpneA
         Siy0AXF8Iqs5Ifbaab4Dg1YcJo85dql0M13RJHyOctn0EvAZBTskkvScCps76C9eBbz6
         qe+8yM+cGfCv4ikfJEsEKqo4npdkjfvsDhc0YF8+X2srzLKjgqRYqxCrMeE0QuK7cgCY
         NUfJhKQngRAS0zkrb1muhqEtM/7JjQyJGnHxvo0jyyLQgEd245mi5Z2y5gY09gbpKoDt
         Digg==
X-Gm-Message-State: AOAM532G/ENkr9LyNDhYgsQUxoqm70aFstLpbeLqot15eHnn/v14Ntpi
        Dqp0Wtgi3p7WTRCbelPcpX4WFA==
X-Google-Smtp-Source: ABdhPJy7qfGblefp8sNr9ibdBDFyvIk0blXRzO3MeBDTAHyb8i0bLadwNu//+AOg4gqqmwUjNPEHww==
X-Received: by 2002:a63:338e:0:b0:398:4302:c503 with SMTP id z136-20020a63338e000000b003984302c503mr12329013pgz.217.1649353469205;
        Thu, 07 Apr 2022 10:44:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k187-20020a636fc4000000b003983a01b896sm19417131pgc.90.2022.04.07.10.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:44:28 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:44:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/31] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <Yk8i+A3E9/JL96A2@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-4-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> @@ -1840,15 +1891,47 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> -
> -	kvm_vcpu_flush_tlb_guest(vcpu);
> -
> -	if (!hv_vcpu)
> +	struct kvm_vcpu_hv_tlbflush_entry *entry;
> +	int read_idx, write_idx;
> +	u64 address;
> +	u32 count;
> +	int i, j;
> +
> +	if (!tdp_enabled || !hv_vcpu) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
>  		return;
> +	}
>  
>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> +	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
> +
> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
> +	smp_rmb();
>  
> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
> +	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
> +		entry = &tlb_flush_ring->entries[i];
> +
> +		if (entry->flush_all)
> +			goto out_flush_all;
> +
> +		/*
> +		 * Lower 12 bits of 'address' encode the number of additional
> +		 * pages to flush.
> +		 */
> +		address = entry->addr & PAGE_MASK;
> +		count = (entry->addr & ~PAGE_MASK) + 1;
> +		for (j = 0; j < count; j++)
> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
> +	}
> +	++vcpu->stat.tlb_flush;
> +	goto out_empty_ring;
> +
> +out_flush_all:
> +	kvm_vcpu_flush_tlb_guest(vcpu);
> +
> +out_empty_ring:
> +	tlb_flush_ring->read_idx = write_idx;

Does this need WRITE_ONCE?  My usual "I suck at memory ordering" disclaimer applies.
