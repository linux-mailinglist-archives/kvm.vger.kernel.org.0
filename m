Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D996D5FEC
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbjDDMKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbjDDMJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:09:01 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB0D448C
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:03:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l27so32549169wrb.2
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 05:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680609837;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H2I56WrDZlwIyTwZv99JWrXVc0DEeAqRMvCpScLvpPM=;
        b=F3sVftBT1QGr7zDiPp6MLlWECDJLKeCxMjdAHa9LvbwfH23ZJoySJejSFzYUWQSWkM
         1KNuZ3Gn38+p9Fn9lpr0ce0HGXzeOLeb63rUS9Ashpg2I0fMLVuC6BMXWSvcuyAlIFzV
         EvohsGoRHux8Jl5droMXr+TmE+upVwgkZh3o3I4kP8eLsF1Y8kPHjzNvyQf6T+XHi9+x
         0dTNfHj/0etbmjOcrU6wbnd3OZiAaQcy6sKnaaHqRK1MC3ISEJ4a28TZCA0puV7Fxwxd
         twdvHBFDirCURjGXnAKlCqa54/hJA2B94Sy9NhUxN3O36U+R2J+5xjpu4dTtb5hjF2km
         V8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680609837;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H2I56WrDZlwIyTwZv99JWrXVc0DEeAqRMvCpScLvpPM=;
        b=qN+goLrkNnLZryK0M3C0G3SxX1IuJVrdRfxFOq69uWknkrEztLLW6xey2T2mdIb0t4
         j2pn5KLot38olHpKtOYkMN+AnBkV/E94g4NII9nIMqwqezGO7EJ1nxz8ezcelpHWuKSB
         Rek2VwyL0/d1nFzPk4UoF6/7WfoiAhGLs7+7O9gQgrfb8oFPrfgKVKKbuxQapDNSg8lG
         J2sTUtTDZNGzKU2pWhiRx9BxfNFU7wSoQoOinz+LXTrsDqYRGUSoSBlKWbqiJhCLq5oU
         l//MmjO/ljOjNmm7jD07WJXGR7IqUUrBmrIjNT2LH3kl/RIC9jY3rhSf9QVbXZb4M2Zt
         w4xA==
X-Gm-Message-State: AAQBX9ePJ8dqEHWkD9sK8N7LDqQrf49TseO6KJthAQzqEWJTz8d+I0w5
        oTbuB+2Xhlo1kfY/JoRqPvfT5A==
X-Google-Smtp-Source: AKy350b7Ly63qP2Zz28vd6eldPQmdJJlgZViuOREMlTV8zIkN2q/Jzc2kuKF2MYFmZ5YqYfvGOfhDQ==
X-Received: by 2002:a05:6000:51:b0:2dc:2431:67d0 with SMTP id k17-20020a056000005100b002dc243167d0mr1383808wrx.19.1680609836931;
        Tue, 04 Apr 2023 05:03:56 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id e38-20020a5d5966000000b002d78a96cf5fsm12259781wri.70.2023.04.04.05.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:03:56 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:03:55 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
Message-ID: <p3ifmb3r7g3soolhapkzlqyt5nq7ivb53w5fb5pp3274dd4ohp@whtjluacebeo>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com>
 <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
 <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
 <ejt3x4p7xhxfvwiafnogfwdn5dzd4qyowlht22utnbvzefsbyh@7dch4mebwckm>
 <uogikq56rf7jytuufhsutdedb73b3rh67biwpzsz6ngg5rudco@qcwt7plumwpb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <uogikq56rf7jytuufhsutdedb73b3rh67biwpzsz6ngg5rudco@qcwt7plumwpb>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 01:52:43PM +0200, Andrew Jones wrote:
> On Mon, Apr 03, 2023 at 02:23:01PM +0200, Andrew Jones wrote:
> > On Mon, Apr 03, 2023 at 05:34:57PM +0530, Anup Patel wrote:
> > > On Mon, Apr 3, 2023 at 5:01 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> > > >
> > > > On Mon, Apr 03, 2023 at 03:03:08PM +0530, Anup Patel wrote:
> > > > > We implement ONE_REG interface for AIA CSRs as a separate subtype
> > > > > under the CSR ONE_REG interface.
> > > > >
> > > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > > ---
> > > > >  arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
> > > > >  arch/riscv/kvm/vcpu.c             | 8 ++++++++
> > > > >  2 files changed, 16 insertions(+)
> > > > >
> > > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > > > > index 182023dc9a51..cbc3e74fa670 100644
> > > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > > @@ -79,6 +79,10 @@ struct kvm_riscv_csr {
> > > > >       unsigned long scounteren;
> > > > >  };
> > > > >
> > > > > +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > > > > +struct kvm_riscv_aia_csr {
> > > > > +};
> > > > > +
> > > > >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > > > >  struct kvm_riscv_timer {
> > > > >       __u64 frequency;
> > > > > @@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> > > > >       KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
> > > > >       KVM_RISCV_ISA_EXT_ZICBOM,
> > > > >       KVM_RISCV_ISA_EXT_ZBB,
> > > >
> > > > Looks like this patch is also based on "[PATCH] RISC-V: KVM: Allow Zbb
> > > > extension for Guest/VM"
> > > 
> > > Yes, do you want me to change the order of dependency?
> > 
> > It's probably best if neither depend on each other, since they're
> > independent, but otherwise the order doesn't matter. It'd be nice to call
> > the order out in the cover letter to give patchwork a chance at automatic
> > build testing, though. To call it out, I believe adding
> > 
> > Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
> > 
> > to the cover letter should work.
> 
> I also just noticed that this based on "RISC-V: KVM: Add ONE_REG
> interface to enable/disable SBI extensions"[1] and it needs to be
> in order to pick up the KVM_REG_RISCV_SUBTYPE_MASK and
> KVM_REG_RISCV_SUBTYPE_SHIFT defines. It'd be good to call that
> patch out with Based-on.
> 
> [1]: 20230331174542.2067560-2-apatel@ventanamicro.com

And "RISC-V IPI Improvements",
20230328035223.1480939-1-apatel@ventanamicro.com, which is required
for riscv_get_intc_hwnode()

Thanks,
drew
