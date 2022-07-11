Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB72570614
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiGKOrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 10:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiGKOrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 10:47:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C316E883
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:47:15 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id bh13so4919900pgb.4
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4chYHKGMXvFRAL0720LnjWx1zElGjVyxHR36HOxWZ70=;
        b=m36etuUJx0HQcE5/Pqbd+7RhmxNhM0wdYBGcdQB9kFYMZ8vl2+DHoICoYTNvO35rJu
         uH+YoxZh4O4EvgzA0XJjwTK47tTew2Mp5yF1nPsrm+EjvolweI3zLx3I60tHIGl5ZfD5
         VqUwnGXfYyq9JtwJ9RxEIDB7NGJxnIyNv5MQA6H/8QLjopH81hbDV8Oq4Rc34V0ZVqd9
         VyvIY7Y/LRFwa3WFOzsFJI7ESh9YUVoUfp5VhFfU/yOgAmk+AS9UTD5GDbimOwGRZfeM
         1OUjekj8gaOHnKrCeT9P1FoYq5nLhEFr7s5z/nsa7dAfDIrpunwl4dl2alsyJb9BYd00
         GVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4chYHKGMXvFRAL0720LnjWx1zElGjVyxHR36HOxWZ70=;
        b=OWYanMtMn3KR0qlEE6x+SSHVd56u/k3h09ylRwyvcJplHH6XrTt5i0By+aOKC0UISL
         ModneYlMIIfDxrk1gpDW8GiHZtMqRZ7XgMU7PxRDCQbo0lszVsri+WDlXsgAcfkU0Bog
         7CPZKw1jv6obyM0MUe0p1i6gYe2yB/2CaFtNRVyyyDpYPkjzwc3aWOhNRKQmwmNuWA0y
         yTh5yWVuXyc1QXnb/JYUsbcWUktNt2rVi9IsSeOgg8v9aKKYi1kvjcGIVgEAxKG4W8jS
         AmKlCNqwTgcFkCedlzExfNmFbWJhaO9hETJaNrZJFC7i+2CEp8ORcn5QEvTRXhLSK/7G
         alJA==
X-Gm-Message-State: AJIora/i2GHOLb4eYw2zTYSPhHW61VeHRAl6ob1A91owuDu++I95j6rQ
        fDV3kVHs24t2G/T3vs4xDSdKYg==
X-Google-Smtp-Source: AGRyM1utSQECH7YtW8EID41EIDngA1PLq1OgACcwd3SKdmeAOLthVOoXe5oNFC+dWM+sqrKYYgJ9CQ==
X-Received: by 2002:a63:d54c:0:b0:412:562e:6964 with SMTP id v12-20020a63d54c000000b00412562e6964mr16043982pgi.528.1657550835031;
        Mon, 11 Jul 2022 07:47:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id q11-20020aa7982b000000b005289fad1bbesm5004033pfl.94.2022.07.11.07.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 07:47:14 -0700 (PDT)
Date:   Mon, 11 Jul 2022 14:47:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <Ysw3778RNiEwuezX@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
 <20220708051847.prn254ukwvgkdl3c@yy-desk-7060>
 <YshNjy5RsxYuFxOo@google.com>
 <20220711070510.dm4am2miy5lcwlzq@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711070510.dm4am2miy5lcwlzq@yy-desk-7060>
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

On Mon, Jul 11, 2022, Yuan Yao wrote:
> On Fri, Jul 08, 2022 at 03:30:23PM +0000, Sean Christopherson wrote:
> > Please trim replies.
> > > I'm not sure why skip this for TDX, arch.mmu_shadow_page_cache is
> > > still used for allocating sp->spt which used to track the S-EPT in kvm
> > > for tdx guest.  Anything I missed for this ?
> >
> > Shared EPTEs need to be initialized with SUPPRESS_VE=1, otherwise not-present
> > EPT violations would be reflected into the guest by hardware as #VE exceptions.
> > This is handled by initializing page allocations via kvm_init_shadow_page() during
> > cache topup if shadow_nonpresent_value is non-zero.  In that case, telling the
> > page allocation to zero-initialize the page would be wasted effort.
> >
> > The initialization is harmless for S-EPT entries because KVM's copy of the S-EPT
> > isn't consumed by hardware, and because under the hood S-EPT entries should never
> > #VE (I forget if this is enforced by hardware or if the TDX module sets SUPPRESS_VE).
> 
> Ah I see, you're right, thanks for the explanation! I think with
> changes you suggested above the __GFP_ZERO can be removed from
> mmu_shadow_page_cache for VMs which is_tdp_mmu_enabled() is true:

Yep.

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8de26cbde295..0b412f3eb0c5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6483,8 +6483,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> 
> -	if (!(tdp_enabled && shadow_nonpresent_value))
> -		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	if (!(is_tdp_mmu_enabled(vcpu->kvm))
> +	    vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> 
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
