Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690056D4388
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjDCLbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 07:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjDCLbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 07:31:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A0A2D4A
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 04:31:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t10so115825766edd.12
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 04:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680521479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YcQcHVUeSM2zYODLoqIXNbDNYCp1LquQUGBod5NxxrU=;
        b=MUH+FkWmhAqp+d3dxhf5ilxC49HG89GtfiPt2fXx77t1/qlF2PBIozQ2Xscb9oA9NU
         4OhAXKGsLYPeCr8ROMQncNiUKbgXDYYheKx4FNRAJ9fjScAtvGqcPqHry8IWwCQGC3nd
         dlKxn1D1iD39GAHilOpgg4xWPpYAiymSjoiF9NxP2UbqPmVWNN75O6JEawXhRdmfXX8z
         RTvzQj/GHdXGJkDx6/kSS3ZzFAZFlW+zMTFKFrGoW8gJiR3sBZqhBlEDz/EAYd+MDIP8
         fN8Gqfk9gK5RavABiGawEBeMY9X4SRXQGUVEyaEz8pzfN770Nst4eUT/qmX9uruuirZI
         8nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680521479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcQcHVUeSM2zYODLoqIXNbDNYCp1LquQUGBod5NxxrU=;
        b=NG76qeG+nIO7SG9KlCgWSHQBlYsyvdfUE5jdE4dfBC8YlGhGmi3VIsqmyAcg9+2k4Z
         4HA+lokhkk9QPtSGZAcefcMW9ZYLi05F95rlvFNa4fRuItqlZ+0zlxfFDriHplZJN5Ix
         piPW8sq2zJIHzs24fpds0fSc3Upn8exIhrlaQBwv0fI18F1GttCdh+Xw5Sy5yjl797qz
         IkAjt5xI2EBcHuFrNlHFN/gkL2aFz67iHjepl3/86FylqGzP24RQQrSMFbLf3iDWjbmt
         tKIt88/x9P7XiDTJZ3402WIQVSfHf5EED+ez2575vbDiT+MO1R4b45GhPm5tISkpOUwY
         c0iA==
X-Gm-Message-State: AAQBX9fs9ypFr6kIxTDHxMiI02TjVs+7+CVG6782XKopmp1hfUohUZuu
        q0eLu2Z/1DpMO+TZscY0W3WAEw==
X-Google-Smtp-Source: AKy350bks61W66k0lSbPXddI6pPorUDq+Ko8KS9lP2tr7b73279KTPnmSiWqrjFY+j5WQFvL71DmGQ==
X-Received: by 2002:a17:906:8a41:b0:92b:6f92:7705 with SMTP id gx1-20020a1709068a4100b0092b6f927705mr31534625ejc.40.1680521479131;
        Mon, 03 Apr 2023 04:31:19 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id b17-20020a170906491100b008e57b5e0ce9sm4387728ejq.108.2023.04.03.04.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:31:18 -0700 (PDT)
Date:   Mon, 3 Apr 2023 13:31:18 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
Message-ID: <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403093310.2271142-7-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 03:03:08PM +0530, Anup Patel wrote:
> We implement ONE_REG interface for AIA CSRs as a separate subtype
> under the CSR ONE_REG interface.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
>  arch/riscv/kvm/vcpu.c             | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 182023dc9a51..cbc3e74fa670 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -79,6 +79,10 @@ struct kvm_riscv_csr {
>  	unsigned long scounteren;
>  };
>  
> +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_aia_csr {
> +};
> +
>  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>  struct kvm_riscv_timer {
>  	__u64 frequency;
> @@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>  	KVM_RISCV_ISA_EXT_ZICBOM,
>  	KVM_RISCV_ISA_EXT_ZBB,

Looks like this patch is also based on "[PATCH] RISC-V: KVM: Allow Zbb
extension for Guest/VM"

Thanks,
drew
