Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E6A666E36
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 10:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbjALJ3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 04:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbjALJ2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 04:28:49 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83BF4D72A
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 01:21:44 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u19so43161387ejm.8
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 01:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kqb6Iris8XWiiMxft3j9JHa7v06d0Pz4gSRMhwJTQx0=;
        b=n/F6PNUGVNPoZrDebVKmVpiZJ+hGLnh9tTOom2GkMxmVqhiyluaHAS2mBeZ+cssrXK
         bLQjy0nWfHpIxez+jYZWgkjA6OiUnTKL9YEYoI+7cP76G0AvRrsmQ6wjpXoccCUStBP4
         0csRTNp5wI1csOg0vSp1k0usXDWeatgNKt9JkZu3PIUlq14P4jCWeYU5bG9GnOsazUu4
         QVEtXP5nka4fCPL3IId1dI4rA43UPGnDlpgPPN+StdxX1bn1GEK7MMAof+79Yt3iU1zM
         jcokevDrio0CVEdvkfLF9M8n9gAW8KKaXiQTLBNrINIAJ4SDfUoH5IwDkpkGi1+jcQP8
         ee3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kqb6Iris8XWiiMxft3j9JHa7v06d0Pz4gSRMhwJTQx0=;
        b=v6kQ9EVAaTRmtX95vx3P6NcWTnDBN8H6AEX2xPEmLPperGbPMGO7VwB6HjS0+0+i/I
         34ZWXHrHLLmu9IuUyzM4QK2Di9WXs+cETWEZIRaGPT74FYuBuXE0omYKwOTYiV11Moe4
         cpwXmSRe8AUX8rL5/4OD16m5IgBXNrgC+8DDNDLv8XIY4/YKtMnpdA3XwVcefL5CMq+0
         eLbILGeJkKrZcen6xdiHbYjdGte6EGiVeX9C1jnYd6f+TrFMvhUmp1Hxmg46FX+KaBGx
         PXDSHwrVSfPj60SE781FlHxtu/KSUMiu8BwvSoeP6pWKXiFTFraKwtpA2b+n0CRkC1lz
         i0Xg==
X-Gm-Message-State: AFqh2krsYuKKBmCiTSvkZqfayEaYVyXuZrvIGjkVNC+PhTy3AG4BAePv
        mWeLXwIT7WtO+D8rTHU517bc7Q==
X-Google-Smtp-Source: AMrXdXtlLbGsD7vOfKM14h8N4DFizPIig28V7mzUwlWavZAZ0XBiIpC8ynNkF7zMf6Uiq65IATUG/w==
X-Received: by 2002:a17:906:34db:b0:842:3920:df75 with SMTP id h27-20020a17090634db00b008423920df75mr66807232ejb.33.1673515303467;
        Thu, 12 Jan 2023 01:21:43 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id y16-20020a1709063a9000b0084ce5d5d21bsm7189751ejd.22.2023.01.12.01.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 01:21:43 -0800 (PST)
Date:   Thu, 12 Jan 2023 10:21:36 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <20230112092136.f2g43hrhmrqouy4y@orel>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2398293.3Lj2Plt8kZ@diego>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 12:29:57AM +0100, Heiko Stübner wrote:
> Hi Jisheng.
> 
> Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> > riscv_cpufeature_patch_func() currently only scans a limited set of
> > cpufeatures, explicitly defined with macros. Extend it to probe for all
> > ISA extensions.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> >  arch/riscv/include/asm/errata_list.h |  9 ++--
> >  arch/riscv/kernel/cpufeature.c       | 63 ++++------------------------
> >  2 files changed, 11 insertions(+), 61 deletions(-)
> 
> hmmm ... I do see a somewhat big caveat for this.
> and would like to take back my Reviewed-by for now
> 
> 
> With this change we would limit the patchable cpufeatures to actual
> riscv extensions. But cpufeatures can also be soft features like
> how performant the core handles unaligned accesses.

I agree that this needs to be addressed and Jisheng also raised this
yesterday here [*]. It seems we need the concept of cpufeatures, which
may be extensions or non-extensions.

[*] https://lore.kernel.org/all/Y77xyNPNqnFQUqAx@xhacker/

> 
> See Palmer's series [0].
> 
> 
> Also this essentially codifies that each ALTERNATIVE can only ever
> be attached to exactly one extension.
> 
> But contrary to vendor-errata, it is very likely that we will need
> combinations of different extensions for some alternatives in the future.

One possible approach may be to combine extensions/non-extensions at boot
time into pseudo-cpufeatures. Then, alternatives can continue attaching to
a single "feature". (I'm not saying that's a better approach than the
bitmap, I'm just suggesting it as something else to consider.)

Thanks,
drew

> 
> In my optimization quest, I found that it's actually pretty neat to
> convert the errata-id for cpufeatures to a bitfield [1], because then it's
> possible to just combine extensions into said bitfield [2]:
> 
> 	ALTERNATIVE_2("nop",
> 		      "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | CPUFEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
> 		      "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_FAST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)
> 
> [the additional field there models a "not" component]
> 
> So I really feel this would limit us quite a bit.
> 
> 
> Heiko
> 
> 
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git/commit/?h=riscv-hwprobe-v1&id=510c491cb9d87dcbdc91c63558dc704968723240
> [1] https://github.com/mmind/linux-riscv/commit/f57a896122ee7e666692079320fc35829434cf96
> [2] https://github.com/mmind/linux-riscv/commit/8cef615dab0c00ad68af2651ee5b93d06be17f27#diff-194cb8a86f9fb9b03683295f21c8f46b456a9f94737f01726ddbcbb9e3aace2cR12
> 
> 
