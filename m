Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4701F7CF195
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 09:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344894AbjJSHqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 03:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbjJSHqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 03:46:07 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8DF109
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:46:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-32dc918d454so1777202f8f.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697701564; x=1698306364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PeyvUx1rVja27wirLq4XcNrRcR3eqmAH3gyz1hpKoZo=;
        b=TeA3laCK5G8lAJK0lDsaFjO2SwnDGjxX8LMx1390kXjkA1oBXhJq35IH3t8+gcDcVg
         sAwzXKkkeGtrutPaF/WwmiXcOp0sLfdyvK/Yllay7SQb3J+v5Ux8CFFpnw2YLExq3qnR
         SkOcAdLLzZunSmAB/zn9fNhr4I57kPFa2PO4m+RWMdSr+fo/IRPBsrSGmjNT5QJEO3kG
         7p8T+cPg/VoRwmmdkwKKVsmRSXpgmY3HAF6pQsLsJyTVnv+HnChuufUrWWaHquq8XW+n
         yVMig0k3bWi1FldSN0yzOBvU2rzIqaXdx/FuK0iHUHdvFrK7fV9Vl1B6aN7dyyQeo7vr
         FoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697701564; x=1698306364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeyvUx1rVja27wirLq4XcNrRcR3eqmAH3gyz1hpKoZo=;
        b=IZv4lwP0/cGxS0zKR06KvpxFA0GJdUndySWlmQRNrTwHNg9KlJ2DEaiIHQzGumNf8+
         2AcjzGIKEbtd2s4KZ36nLfu3idT26pFZyqESioQqUDltOp/2Ug9kipBFS17Xegk35jYh
         h3zkpEAGJ7+3KV2CVfStnQsQyZLBtZtVxGh0wwqUtHHE781GkQz3Yq3+wMyQvhccMF4n
         p6DujpseH/a0pGADmLpmlETThYtMYWmcNbSguEh7TOlLOUSFcbGgyiM8MGIS97+A8XDq
         HVr9vHWUGsbMNCNUJOEnZ+vBxWOYCDAFbcYK5B+WPkhV4O2dSf12hkLlZPZDYJmgp0KV
         EWVg==
X-Gm-Message-State: AOJu0YyUhaOMDwqbX9mZ7kaWa0aLJZnhyqTMeBInsDWQhLoDZH39+CZ3
        S1cFVz9/d0/fbCYgw15JXswn6g==
X-Google-Smtp-Source: AGHT+IGLUlcDD7K55509EI9MCn7Lj/SluH9GT9R5OrexuSg3htFw/XSGrzpIAwUrw57WzavQkmaRxw==
X-Received: by 2002:a05:6000:1815:b0:32d:82f7:e76 with SMTP id m21-20020a056000181500b0032d82f70e76mr906073wrh.34.1697701563248;
        Thu, 19 Oct 2023 00:46:03 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id q15-20020adff78f000000b0032da6f17ffdsm3846942wrp.38.2023.10.19.00.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 00:46:02 -0700 (PDT)
Date:   Thu, 19 Oct 2023 09:46:01 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] RISC-V: KVM: Change the SBI specification version
 to v2.0
Message-ID: <20231019-d6386d58125da87f5e4c5ff2@orel>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051509.738750-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 10:45:03AM +0530, Anup Patel wrote:
> We will be implementing SBI DBCN extension for KVM RISC-V so let
> us change the KVM RISC-V SBI specification version to v2.0.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index cdcf0ff07be7..8d6d4dce8a5e 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -11,7 +11,7 @@
>  
>  #define KVM_SBI_IMPID 3
>  
> -#define KVM_SBI_VERSION_MAJOR 1
> +#define KVM_SBI_VERSION_MAJOR 2
>  #define KVM_SBI_VERSION_MINOR 0
>  
>  enum kvm_riscv_sbi_ext_status {
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
