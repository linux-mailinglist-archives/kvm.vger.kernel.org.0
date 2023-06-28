Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F589741B4E
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjF1V7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjF1V7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:59:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F77210B
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:59:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-262c488c1d3so10312a91.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687989541; x=1690581541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibnfIbYLuJprbyc7sn5N3Pf0TgkraQ9Zv5pFLImKpVg=;
        b=Ge6+GmIzvDZU7Zw141Rx/LRC7h8S4S5RBarecs/PvpTQhQ+pdIj1ek6PydxAGs4wrF
         t2iVRrxbJeLRxCv5mN6fJU4t8uqOR87OO9YpWLyftShqUPn1OHvyHYfWhENz336KFZK+
         ex6254kwUAza1RlM9ZxY4VUmZjOktvGfcPN9SFnW29aABIBBWxlDrcV4D+eRzFUu9jTG
         pb2AHu2xbpBh28I56EFcG+v3AeGVEYahO29wIfow2sCSCpcMKR+lzI4jclPJdO40qk3S
         PjamQtKwbZlti7ku32Du9kxnZLrrQ6rpe6ApbCKiPBkicKaFDxLl6HdnTyR7aqPila4O
         cwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687989541; x=1690581541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibnfIbYLuJprbyc7sn5N3Pf0TgkraQ9Zv5pFLImKpVg=;
        b=i5IC++hXS7yqR7VbFF+orWpAupC8u/2brEMJWz4fVEaxK/umDi6MydmSkLzzi0OMw6
         VEdjNBT8geeijxU5W3Owj6hQPMosN9dsT+V7fe+c9FV8MRK5BPs6s8VA50uT+ZCcdaZw
         7IHKCBxsXIFU1sQLy33125mEkImGP5asxsLaavk9KHNu2d+TKjaV363bt895WstexB01
         cAhgzhR0YIje0lHXzYnMa2mD6W29kocHN8XwHtxOuPGgGxBFgl5HeMLHxLHlVhhK1NOZ
         v9ySd5PmZOrgJYmie5ZYEsbwFe2brbtVYWXUQmkKC+y5uo55zVwJrl/tcjMQTxJjmUEh
         0tiA==
X-Gm-Message-State: AC+VfDzPjgVbyZmp5FY/REQDUMTv5DVGZqd6trkRpWq3ls2nXzRNAfJB
        bqCMd84ZFLp+p7J4n5CgIyy2dAL6SpA=
X-Google-Smtp-Source: ACHHUZ4rvDnUAz5eHaI/CZWx4/4PhYzzJqS4OnxZCidRNr69vjsJoOjv5M+IT/B0vTJKM2dRyV7PAIysIKQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8049:b0:263:39c1:d0b2 with SMTP id
 e9-20020a17090a804900b0026339c1d0b2mr661352pjw.5.1687989541371; Wed, 28 Jun
 2023 14:59:01 -0700 (PDT)
Date:   Wed, 28 Jun 2023 14:59:00 -0700
In-Reply-To: <20230616023524.7203-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230616023101.7019-1-yan.y.zhao@intel.com> <20230616023524.7203-1-yan.y.zhao@intel.com>
Message-ID: <ZJytJB+mwdU6v/XJ@google.com>
Subject: Re: [PATCH v3 03/11] KVM: x86/mmu: Use KVM honors guest MTRRs helper
 when CR0.CD toggles
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Yan Zhao wrote:
> Call helper to check if guest MTRRs are honored by KVM MMU before zapping,

Nit, state the effect, not what the code literally does.  The important part is
that the end result is that KVM will zap if and only if guest MTRRs are being
honored, e.g.

  Zap SPTEs when CR0.CD is toggled if and only if KVM's MMU is honoring
  guest MTRRs, which is the only time that KVM incorporates the guest's
  CR0.CD into the final memtype.

> as values of guest CR0.CD will only affect memory types of KVM TDP when
> guest MTRRs are honored.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9e7186864542..6693daeb5686 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -942,7 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  		kvm_mmu_reset_context(vcpu);
>  
>  	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> -	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
> +	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
>  	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>  		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
>  }
> -- 
> 2.17.1
> 
