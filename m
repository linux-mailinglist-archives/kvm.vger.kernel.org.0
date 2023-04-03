Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149586D3F53
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 10:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjDCIom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 04:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjDCIo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 04:44:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274968695
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 01:44:16 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b20so114167575edd.1
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 01:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680511454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bo4Kh55NPoZNDEs55iiMa2VaQMiKh1GEZppniETDTdQ=;
        b=DeVMQ+mqOgyHAFdWNlxlUKRQbmaWxS4oHLa0DNQNDHcuB9Aznlh6j73OLWloGV9bPy
         pH0HpKuvlzcTYF6wQXpfVJC2svpyUt7AFdCJF1MMoFSsvrr4TsEX/e3Z590Y1A8gOt4E
         Cr1YOVNR9ZA0ov5swgOWYbyKzoKmt1XJyGPMvX3p5RoF01aebn9R9AamX869Bm/+czTn
         qjUZz0UDun8aA633TUMSITrP3GWMMi51jVMunoHpnUZ99aBm6cxemR5Q5Zifc3LSsQjp
         abHJ9+ldNFn9bffRw03hxOs3t3yXETGXW9qN39qzpTXZqJWQX/TLm6GoslOePacVxKmc
         perw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680511454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bo4Kh55NPoZNDEs55iiMa2VaQMiKh1GEZppniETDTdQ=;
        b=s1s7ZpGX+lUsBkfqoPQKPFxBM+KMTME4nXhDLPgo0HmgEG2pujLYr1K58Wyi62XJke
         DSu8Gau1N28iwjEdT6W+CAoShQF001Rpa8mupp+T8mxKUqhS4RG8tKG9SfpCLZg4NdZr
         39Jgrugk+dgQV8LJ1j6p49xvJXzgGNBnaCZ7blgUTJosbGuefcEn9iw5dPPgTqcZDMOO
         gwmX09NaD2vQeI5bogfQjM978bf9AUxb5juKWTtOkgq0afl7oNFT7IRRc1dym+qaJB7T
         dSHEXSVG8byxgUBRYycyQviIZDstDxxujS8Z+//62+/t1OqE/lKuJ+ePjyImKj6JBMqG
         2Lbw==
X-Gm-Message-State: AAQBX9dzCaYRR5HbH9vS3HFtKK5SjdEXouxVhPd/IIh7ywEvnJ2Nn6u9
        rEfrRB3cgeeXG01bXk/w3w3PdA==
X-Google-Smtp-Source: AKy350aPFP36tSb/JUFTn4VSgkNpFvPQudYJMIYMT+Ui1cBMS3QuLwI4zlUJxHho1zodmQ2/OgzrLw==
X-Received: by 2002:a17:906:5d14:b0:92f:e7e2:b7b3 with SMTP id g20-20020a1709065d1400b0092fe7e2b7b3mr43452702ejt.5.1680511454672;
        Mon, 03 Apr 2023 01:44:14 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id y20-20020a170906519400b00930569e6910sm4308835ejk.16.2023.04.03.01.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 01:44:14 -0700 (PDT)
Date:   Mon, 3 Apr 2023 10:44:13 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Allow Zbb extension for Guest/VM
Message-ID: <mhrkfb5qtqlmzvivljo4y4o2ii4r6ucjdyeq4orn2gxpbrxzel@eemujnzws5xt>
References: <20230401112730.2105240-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401112730.2105240-1-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 01, 2023 at 04:57:30PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zbb extension for Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 2 ++
>  2 files changed, 3 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
