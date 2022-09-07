Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CD65B0B9D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiIGRk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIGRkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:40:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5E74CA26
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 10:40:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so11650302pjl.0
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 10:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ivGeHU+iK+QNj39TtA8dNEWOqgS/ClEDHBRwSPl15bc=;
        b=OUZN0rztVa7Vg8juOl5Mff6QvYKUvRAXTpGQihy/IBMHctfrM0gYKRkQMc3+lk+nLO
         OfYh/KOYX3pt5q+l8rUE2e/waLHNUnY3D0J5xjFWjKd8UHnTYSUaAqMM5LQ4rj9i1PN4
         yc+e/71TQnn/f8lD1IWCLm20uvfx8+17KqCQ63JtBKEocOHmwiKiRNKU/mhdtifZ6osA
         SVsPznJNvqAwWWnYz0a0OT2oFQC0hcH9qpaEAkj2ZEuqfhnPUliEhoDcUG3D23PWsc/q
         awLGawm9LeilIwg6pExOylRwho474qqus+30pTkKtPWWjQ6bBDpPc6HNH9XUUTfU4oqD
         FKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ivGeHU+iK+QNj39TtA8dNEWOqgS/ClEDHBRwSPl15bc=;
        b=aRn7mGSoKtunmBl31uhw/NFRgKRfhOIBWG/ZSUtIb6WbxgP0tHTyuEc8GZFj+PD3Rp
         qUbsr0jhTVEQcsZXdP2sTSULbttowoA8jfocCEW6I0e4orzhfOL07NlJFWN/k5neoFXa
         ezgIXIXanyCq0xkl2J+QAb37z20hOAQqNPAnH9QyuwcCM4YuonklJWD56yTp9dQ1CGcP
         hR60MpQxYxRXJfexSzmkKGM9sOsUjlOxc+Sus9Z3kQIkVHafqQfyrNRow6rAqHgLSRTZ
         6yz/2aJaFiRoTamaK+F1HncSBLVZ9HsqpKQL7vMqQeM3isLTqzQt+r+e8rINs0cArfEx
         vI5A==
X-Gm-Message-State: ACgBeo1V8lJS/gXT3XqpoH4LZ8NL2kSd8eJwwsnxSSJBmmXo2F97La9p
        2A8fzN3RwKOE5hmjD4qJMVpong==
X-Google-Smtp-Source: AA6agR4wN5Gt3TbzrAwzSMzOr8h3mRywpT3dUMj/hLLm+oMehhz/AuxoGmbm6pW2Bnh4CBo/nvtpEQ==
X-Received: by 2002:a17:902:9887:b0:172:7090:6485 with SMTP id s7-20020a170902988700b0017270906485mr5133597plp.63.1662572422171;
        Wed, 07 Sep 2022 10:40:22 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902654900b00172ba718ed4sm7687631pln.138.2022.09.07.10.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:40:20 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:40:16 -0700
From:   David Matlack <dmatlack@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] KVM: x86/mmu: Use 1 as the size of gfn range for
 tlb flushing in FNAME(invlpg)()
Message-ID: <YxjXgERSNIk4ZaN+@google.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <8baa40dad8496abb2adb1096e0cf50dcc5f66802.1661331396.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8baa40dad8496abb2adb1096e0cf50dcc5f66802.1661331396.git.houwenlong.hwl@antgroup.com>
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

On Wed, Aug 24, 2022 at 05:29:23PM +0800, Hou Wenlong wrote:
> Only SP with PG_LEVLE_4K level could be unsync, so the size of gfn range
> must be 1.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 04149c704d5b..486a3163b1e4 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -937,7 +937,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>  
>  			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
>  			if (is_shadow_present_pte(old_spte))
> -				kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
> +				kvm_flush_remote_tlbs_gfn(vcpu->kvm,
> +					kvm_mmu_page_get_gfn(sp, sptep - sp->spt), 1);

The third argument to kvm_flush_remote_tlbs_gfn() is the level, not the
number of pages. But that aside, I don't understand why this patch is
necessary. kvm_flush_remote_tlbs_sptep() should already do the right
thing.

>  
>  			if (!rmap_can_add(vcpu))
>  				break;
> -- 
> 2.31.1
> 
