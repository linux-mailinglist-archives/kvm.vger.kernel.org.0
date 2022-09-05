Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C635AD479
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbiIEOF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 10:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiIEOFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 10:05:24 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413EE1D0C8
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 07:05:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c11so7284051wrp.11
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=EWYn0J7WPavaTgTTHsAJLPPLXm3IrDBQA3Am2N9LKbc=;
        b=RREVlJgowp20xJl611CUIlXXcHWKHX81piHaUH+iNRrbmdAxBqM+mRvPyqsTrJOVm5
         rAEBj0DBvmLHM0bCNrTXZMo1uFl03j6iM4LnXnn/M+xhk3cP/UP5xBjm5bmyvy75ka2z
         VN2iC1WjhEHAfV5axu40Bp1qqpewT5iQOrVTQK6JP9NxOsg23/IffVgW7Zwky3zHWhs7
         MN4FqO632/rzrmpMcZXWux2L19LA5YhViqB+L+sObj3ICsQWSezoGIO9QW7zuzR9dy/H
         tdSjzdfubmcwkvrSKY5dtDY+6LMhlw4RXXjrExSJOKqkzvxboDsV3tt/mmZLrXe0Bp1U
         GA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EWYn0J7WPavaTgTTHsAJLPPLXm3IrDBQA3Am2N9LKbc=;
        b=RzDOya1NfJl2Dc4Ak2LWLFDabJw5IGvChQ/YFQ4LukDCvD56Cx3tZrg79cpOU+Y9DR
         A08Bvf7dal2GfI0b6Jcnd35DoSUxPBwSYxHlgjYyhpYztnjlV+A+1zZCbHW3PWD0hTD2
         NfJ0uShUQYMxawfQ/hidATYEZ7ygoyjNVU/KIcz0dXTbp11OMLgMLrDwugQyb9trTGBN
         Xxmc+YxjwV15Y6SvirXDzeM/kc3mi3R0do3GeJ4DTx6/Kcbo1wLpet/uNWMve/i2KpwW
         q/Xvpq2X2rkfCB7uSzgCk2MhE4Bu4yyey4HiNQN+/7joHJ26K9EaVmaQS2OErMlff5Rb
         AJ8w==
X-Gm-Message-State: ACgBeo0rlAdDrmFMPJuZX82pndBd2L7TT1V/99uNHzZyFrVA08fq3PN0
        wRrD/fEhJaN4D3P6HfBpLFz/Og==
X-Google-Smtp-Source: AA6agR5n8mXcPAFDTtcz/LoCzBHOCGeMxpW/ITe1Ff6sdYJh6aJoz+VcFowQp3QZJds50a5RRueKrw==
X-Received: by 2002:a05:6000:1d81:b0:226:fa3a:8721 with SMTP id bk1-20020a0560001d8100b00226fa3a8721mr11351511wrb.475.1662386721837;
        Mon, 05 Sep 2022 07:05:21 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d5588000000b002258956f373sm9021634wrv.95.2022.09.05.07.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 07:05:21 -0700 (PDT)
Date:   Mon, 5 Sep 2022 16:05:20 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Svinval support for KVM RISC-V
Message-ID: <20220905140520.dmpbbh5fkk634leg@kamzik>
References: <20220902170131.32334-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902170131.32334-1-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 10:31:28PM +0530, Anup Patel wrote:
> This series adds Svinval extension support for both Host hypervisor
> and Guest.
> 
> These patches can also be found in riscv_kvm_svinval_v1 branch at:
> https://github.com/avpatel/linux.git
> 
> The corresponding KVMTOOL patches are available in riscv_svinval_v1
> branch at: https://github.com/avpatel/kvmtool.git
> 
> Anup Patel (2):
>   RISC-V: KVM: Use Svinval for local TLB maintenance when available
>   RISC-V: KVM: Allow Guest use Svinval extension
> 
> Mayuresh Chitale (1):
>   RISC-V: Probe Svinval extension form ISA string
> 
>  arch/riscv/include/asm/hwcap.h    |  4 +++
>  arch/riscv/include/asm/insn-def.h | 20 +++++++++++
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kernel/cpu.c           |  1 +
>  arch/riscv/kernel/cpufeature.c    |  1 +
>  arch/riscv/kvm/tlb.c              | 60 ++++++++++++++++++++++++-------
>  arch/riscv/kvm/vcpu.c             |  2 ++
>  7 files changed, 77 insertions(+), 12 deletions(-)
> 
> -- 
> 2.34.1

For the series,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
