Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6658E4D221B
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 21:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349816AbiCHUDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 15:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiCHUD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 15:03:28 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CA0636F
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 12:02:30 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bx5so328216pjb.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 12:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BQc9qf7Jvr1scII8R10TwmoX8GBVxNzjAKC9tzRHQJw=;
        b=j1Vw88ktDAfHqoj70X1xbgvDOWX76yic7J8vvqFuJQBkx2U/WRnmXK0hVpiQg/+dYI
         rF7/AEzyVQl76IMfpOGDsmHBTSGBWmLc8TxHeQlHklPZAvEGvskagQ4stLGskbvQGo58
         WnFBpPqTerNDJllxf+BI8exCnH7bM6nJJfP4DHgchQj0bxRTf7lM3pXcJXRhC5WvL5WF
         WX9hXBwlG4Faz/2RK3FuUu2Jp/hHc3BhUm22lk6fUH2s+0t9yiyfUvzaoRykpjJ1joZA
         42+A2V10LI5AoYj6wRE/pi2xw25e3HO5tf4Ht4IP4YFLciZguKgzd8b+AasW2WWu8Nkb
         +pfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQc9qf7Jvr1scII8R10TwmoX8GBVxNzjAKC9tzRHQJw=;
        b=m16D55GuPwNyw19x5aKJKGKy/YEIGgLESb7Xd0+UrLy6aXBoQIQfUJpqmk8GWpdhvx
         XixKoQYG8qInAmBR/JK0mLPtViVqZmGHytFsWLg+vLGIc74Q/vnvo1p/oB2hmDIWIuSV
         CzROqzu7dsoNd7flQd43FDz/B8yJ4KAj2XLMWNVf9wfXAlOyOQBKZOSdcfXV2Acq4jpr
         OB79a8Kd84xZRxhshfapakZQvZ128jqvIZhv2MBnEPEj4ywynaZRZAyt1CDEdly/6m4+
         MeVkU1dECfIfZDGicsuNmbKNcF2xk6NaEXQbsjGtLFYMj9QBICNYlnQcFu5y8x/1fkxQ
         +MJQ==
X-Gm-Message-State: AOAM532yh/HAWeIrYC3ieGILh0UDH3zJ1Ve/sOkOmmq6MqVgMz9F9WrV
        HMcMohS8NIKS/QmbzyVI/eQ9Zg==
X-Google-Smtp-Source: ABdhPJx0DErx4byKNhlX+0jvcUmeDNga+OsQwZ/c3bjRyuUiARmCZ70+I7Qs5s8pCYg23pJwHMYdlA==
X-Received: by 2002:a17:902:714b:b0:151:d8fa:fd98 with SMTP id u11-20020a170902714b00b00151d8fafd98mr16662243plm.146.1646769750140;
        Tue, 08 Mar 2022 12:02:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mp10-20020a17090b190a00b001bf8453aea8sm3562863pjb.42.2022.03.08.12.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 12:02:29 -0800 (PST)
Date:   Tue, 8 Mar 2022 20:02:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 25/25] KVM: x86/mmu: extract initialization of the
 page walking data
Message-ID: <Yie2UmdzumoVNWGA@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-26-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-26-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> +static void kvm_vcpu_init_walker(struct kvm_vcpu *vcpu,
> +				 struct kvm_mmu *mmu,
> +				 union kvm_mmu_paging_mode new_mode)

kvm_vcpu_init_walker() is a rather odd and almost maliciously obtuse.  We're not
short on space for this one, so how about?

static void kvm_mmu_init_guest_walker(struct kvm_vcpu *vcpu,
				      struct kvm_mmu *mmu,
				      union kvm_mmu_paging_mode new_mode)
>  void kvm_init_mmu(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
>  	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
>  
> +	kvm_vcpu_init_walker(vcpu, vcpu->arch.walk_mmu, cpu_mode);
>  	if (mmu_is_nested(vcpu))
> -		init_kvm_nested_mmu(vcpu, cpu_mode);
> -	else if (tdp_enabled)
> +		return;

Nice!  I really like that this highlights that the nested_mmu crud is just for
the walker.  Can you also add a comment here explaining that part?

> +
> +	if (tdp_enabled)
>  		init_kvm_tdp_mmu(vcpu, cpu_mode);
>  	else
>  		init_kvm_softmmu(vcpu, cpu_mode);
> -- 
> 2.31.1
> 
