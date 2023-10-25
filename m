Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E287A7D6C6A
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 14:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344191AbjJYMyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbjJYMyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 08:54:23 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE875AC
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 05:54:20 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-507975d34e8so8335808e87.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 05:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698238459; x=1698843259; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9OdR1fLrJ6RI6ICv8IQKa+FrktkYty5NlWTPHZ7X8aA=;
        b=EosF5rusUC19b9YEBBSGknYylwNLyduIcoCWAKH/fmSprgZaKjJ7zLYCfmXKNV0bXd
         oB/PO627npC+QJE8HslQnrCS0Z7gg+y5m04YbNyLSIrY0gCJL+0U5yDkE5r6/8JuzQLM
         0IC+vT/eF8xRJkFSMfHZrOD/aN8mxc55TZNhvGWqwuO3UarJ2VZgwMjgjML3hNAkX/Ik
         60htzDjJgJ74MF07lcNbDQFXnALb6ZAzqQDL13FhYcIaTlxd1LUqOjjhyHoE/REWNe7S
         46h22Tq19SsATy88lje2EklQG+S4SaOpVpWjNrNk4u4LhX0B9ORrmU2oquI8auKhM7zQ
         DuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698238459; x=1698843259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9OdR1fLrJ6RI6ICv8IQKa+FrktkYty5NlWTPHZ7X8aA=;
        b=WEDeAa6/tL3hDe89MfLNAsJEhd6nJ6ioxVxaWMBYoRvtYWUQ8t0RlPj5tiPzGXO31w
         wO2YMWZIfi7gPgZJLG3+8n3ZhPX0KD1D5n5vRAMX1l9SN9MQ+n/iXTdPkbvh6Z1fE+Nu
         K1LKzUSLpf3oetkA7qgvtCAVQTYF9RPJ2rmzRzlurKfW4aJesUh9ZTGRVlW4XpGmNByF
         abxPhE3T7mDjCtiakKT7S5xFP8QPx7StEVLbDJ+JGoog1g6ir18q8SMwuBmk47gzWrgZ
         5k04zXiKyYh6g7F+ahBwqtEbEOlbDnAaxvuAFyPzES7MKLoR5Kf0J8cGEckISrFMiBox
         VvEQ==
X-Gm-Message-State: AOJu0YxhVBLqZqG/b5P8O0ELuqPhiGAuvlyufvp9c6b2L5o1zgBTaa9E
        w3udVQhvJWf0QmgXA41bB/FWJQ==
X-Google-Smtp-Source: AGHT+IFFL9Z9LltXMeXVdkfEpyWapdDFBrLwTTUt97hqb3SIMGTVGmIiXOtfZb8jaTS1WAfNdG2wOw==
X-Received: by 2002:ac2:5bcd:0:b0:500:b553:c09e with SMTP id u13-20020ac25bcd000000b00500b553c09emr9847173lfn.32.1698238458788;
        Wed, 25 Oct 2023 05:54:18 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id t11-20020a1709066bcb00b009be14e5cd54sm9809154ejs.57.2023.10.25.05.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 05:54:18 -0700 (PDT)
Date:   Wed, 25 Oct 2023 14:54:16 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 2/6] riscv: Add Svnapot extension support
Message-ID: <20231025-ede83c6b800daa82237e7fcf@orel>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918125730.1371985-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 06:27:26PM +0530, Anup Patel wrote:
> When the Svnapot extension is available expose it to the guest via
> device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index df71ed4..2724c6e 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
>  	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
>  	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
> +	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
>  	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index b0a7e25..863baea 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -34,6 +34,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-svinval",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
>  		    "Disable Svinval Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-svnapot",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVNAPOT],	\
> +		    "Disable Svnapot Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-svpbmt",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
>  		    "Disable Svpbmt Extension"),			\
> -- 
> 2.34.1
>


Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
