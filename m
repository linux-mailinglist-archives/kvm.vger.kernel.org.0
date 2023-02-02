Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B2868817D
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 16:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjBBPQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 10:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjBBPQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 10:16:45 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EDA92C2D
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 07:16:44 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id o18so2027220wrj.3
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 07:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFKtikxweyiapl+IexctfEvOemBJ00V0d++S9NjR+cA=;
        b=Xxoh56A0bGbr6ATBS+F/o7XGC9BVns5iYvUq1bgY1JH3FFR2ms2tOlDI/KrPgl6x1/
         CtUjKGWTSzFfyzOyDbToAsSzXeThYgu6/Sg5uH60HUXXpVx+tGj6993mBkC9ch9FL/cZ
         lCj4mPFpEV6XvuV4Jd1c2n7eeKvgwml3FjysuBGFh4N3q8cNhGQ4oFlpx9ObLO3BZ8Di
         WV8d2+WzrxtJYPSs+gU6wxiLUbbh/K2pno3etTmUnQTF1fFaFLxwFSk3/cZka4uYoMtB
         DKPFEoHS45dhjS9NsQSRMTBPR3NEjmY/eWBZk9uPu1rNllZpEh5PN+kTZoPJZIS1PUqQ
         8lJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFKtikxweyiapl+IexctfEvOemBJ00V0d++S9NjR+cA=;
        b=nGxPU697R9wq9tpmphnL9BXypmEol2pyNP7gmVIAv3bM/A+b3CQ/nj11PpoSXHC0bO
         j5y/cn7/XrJsO73o0g2NZsMovbpIW5LcZk7iL6TgSHjCj6GQ2lU4r1ZB0ZozI7o3ngDf
         ajMUAEo5NQVHp/TV00d0uFc0Q2Wb/BjNyidZzIa2SktKkBAhOfLtuvIwt/QJ7TDqvUO1
         MPo/OglYL+PXyfAyGHhEM8hzD5Fh0I61Yex1TeoLNqBPvzdDfzvAisxRPpRZQKCiVJH1
         FbGAtei14fdY6pXEhju1UAOKG0wzRrKK8h1H4ZgY/E4gP7Um2zcjpE8EkgdgOCQn3Iwx
         13Kg==
X-Gm-Message-State: AO0yUKUWHrPGPmkSTDVLuQ6whDe+0LrnerSiDtQN/ypEeVM5Wz9MHcyW
        vTrQArIjIZYStNmHR/wv/hNb+A==
X-Google-Smtp-Source: AK7set9YcrVZ/I2ivVOBp6ZoJ4SQrCDwR3cYdEI9FCeixtQZ93JzJvaZ6A2Tfoc6K8O9v/+aSTjmzw==
X-Received: by 2002:a5d:4d85:0:b0:2be:3ccd:7f37 with SMTP id b5-20020a5d4d85000000b002be3ccd7f37mr5600723wru.52.1675351002561;
        Thu, 02 Feb 2023 07:16:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a13-20020adfeecd000000b002bbedd60a9asm19927404wrp.77.2023.02.02.07.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:16:42 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:16:41 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 04/14] RISC-V: KVM: Define a probe function for SBI
 extension data structures
Message-ID: <20230202151641.6edhtlf7fz7xsmdy@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-5-atishp@rivosinc.com>
 <20230202151433.kspo2g7cqsccoqsq@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202151433.kspo2g7cqsccoqsq@orel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02, 2023 at 04:14:35PM +0100, Andrew Jones wrote:
> On Wed, Feb 01, 2023 at 03:12:40PM -0800, Atish Patra wrote:
> > Currently the probe function just checks if an SBI extension is
> > registered or not. However, the extension may not want to advertise
> > itself depending on some other condition.
> > An additional extension specific probe function will allow
> > extensions to decide if they want to be advertised to the caller or
> > not. Any extension that does not require additional dependency checks
> > can avoid implementing this function.
> > 
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
> >  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > index f79478a..45ba341 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -29,6 +29,9 @@ struct kvm_vcpu_sbi_extension {
> >  	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >  		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
> >  		       bool *exit);
> > +
> > +	/* Extension specific probe function */
> > +	unsigned long (*probe)(struct kvm_vcpu *vcpu);
> >  };
> >  
> >  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> > diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> > index 5d65c63..846d518 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_base.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> > @@ -19,6 +19,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >  {
> >  	int ret = 0;
> >  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > +	const struct kvm_vcpu_sbi_extension *sbi_ext;
> >  
> >  	switch (cp->a6) {
> >  	case SBI_EXT_BASE_GET_SPEC_VERSION:
> > @@ -43,8 +44,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >  			 */
> >  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
> >  			*exit = true;
> > -		} else
> > -			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> > +		} else {
> > +			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> > +			if (sbi_ext) {
> > +				if (sbi_ext->probe)
> > +					*out_val = sbi_ext->probe(vcpu);
> > +				else
> > +					*out_val = 1;
> > +			} else
> > +				*out_val = 0;
> 
> Conor points out elsewhere that we need {} on both arms if one arm needs
> it. We actually don't need {} on either arm, though, or even the if, if
> we rewrite as
> 
>  *out_val = sbi_ext && sbi_ext->probe ? sbi_ext->probe(vcpu) : !!sbi_ext;

I sent too soon, I meant to add

In any case,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew


> 
> Thanks,
> drew
> 
> > +		}
> >  		break;
> >  	case SBI_EXT_BASE_GET_MVENDORID:
> >  		*out_val = vcpu->arch.mvendorid;
> > -- 
> > 2.25.1
> > 
