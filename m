Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10375D0C7
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 19:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjGURlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 13:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjGURla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 13:41:30 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309D930F0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:41:21 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fbc77e76abso18828205e9.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689961279; x=1690566079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oWngwrMo9tfYsDEwETiHHjHUDWaHKjCLtIZQ2VnXF7c=;
        b=aTqIdTpVZIP4IVD51tOsAm0tR92i26ku0QRdMxib75xiGv1WuDJToy9b7LZrUOyuWs
         ug3ZVQs0v1TonuQR2lcsV2mO46xdshqUBhttSnBH7Rrb3XgEEL+nF691T8oB9Z/p7g+Y
         AAMeANAszmpY1NlEbJPZwpRtpA37I27sbLny0PlZD7HmZHG8bLpB79BpLuV1ukSJVcH5
         y+gv0xZl7RRfxTHin5Ewyz2/48Hu6+QdHEbqcygrYQXw2d3QR3K0TRSxgMYbs+UmA4d7
         myGSY6a1NPABafYZVSdxPJPcTrHpkcEO6gmjUqLKlvTu7eZqPpQ7N+4AstkSKRNJTaO2
         RajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961279; x=1690566079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWngwrMo9tfYsDEwETiHHjHUDWaHKjCLtIZQ2VnXF7c=;
        b=d8QVKhdxySzcRblNctAq6RNvHXB7QgMITg6a1e1ygVb95zSNSQnZx5X/iAPFjdyoZq
         qhpOFYScsk0j45e0QC0tftX8be8ekK9Z5EsCJxeqxDGIiZi++jjRfTQNA0Ma+0OLT9DE
         LgGFq9kqIbzplHwYel99QUGcOvUM8oOyZH1v7f0kuFTRV/qKn6mFhs+U5efuqsRJ3tG5
         XLh7UZYhx2t+MuTh9pg5AhT7X6Ng28eyTA5ALBKTwK7tcS4OR3pldpPSRt4ytWJFhmwF
         5Ytlfcu3jqqtRpOA2B3VHgA9PcCQxfctWqVz52kGk4MymJSw/ZZSQmeDXHeN3EtJ9dkh
         76uw==
X-Gm-Message-State: ABy/qLZZq2CoMimfG1ePZx4zjpH6HUa+hQxFJxDpugfx/3yuXKXD0fiz
        NCEW8/2l+dc02Md66hSaKpwr7A==
X-Google-Smtp-Source: APBJJlG69RYuLgM+byfVXHJKxwKW8uCOZZnRcc5dSXYdEn2ESNpecR5PiRno3VUFKC9534g612t9Ug==
X-Received: by 2002:a05:600c:2102:b0:3fb:d1db:545a with SMTP id u2-20020a05600c210200b003fbd1db545amr1950667wml.15.1689961279465;
        Fri, 21 Jul 2023 10:41:19 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003fbcdba1a52sm6476865wml.3.2023.07.21.10.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 10:41:18 -0700 (PDT)
Date:   Fri, 21 Jul 2023 19:41:18 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/5] target/riscv: Create an KVM AIA irqchip
Message-ID: <20230721-72cb5810011b0a676b359d36@orel>
References: <20230714084429.22349-1-yongxuan.wang@sifive.com>
 <20230714084429.22349-4-yongxuan.wang@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714084429.22349-4-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023 at 08:44:25AM +0000, Yong-Xuan Wang wrote:
> We create a vAIA chip by using the KVM_DEV_TYPE_RISCV_AIA and then set up
> the chip with the KVM_DEV_RISCV_AIA_GRP_* APIs.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Jim Shu <jim.shu@sifive.com>
> Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  target/riscv/kvm.c       | 160 +++++++++++++++++++++++++++++++++++++++
>  target/riscv/kvm_riscv.h |   6 ++
>  2 files changed, 166 insertions(+)
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 005e054604..9bc92cedff 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -36,6 +36,7 @@
>  #include "exec/address-spaces.h"
>  #include "hw/boards.h"
>  #include "hw/irq.h"
> +#include "hw/intc/riscv_imsic.h"
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>  #include "kvm_riscv.h"
> @@ -43,6 +44,7 @@
>  #include "chardev/char-fe.h"
>  #include "migration/migration.h"
>  #include "sysemu/runstate.h"
> +#include "hw/riscv/numa.h"
>  
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
>                                   uint64_t idx)
> @@ -1026,3 +1028,161 @@ bool kvm_arch_cpu_check_are_resettable(void)
>  void kvm_arch_accel_class_init(ObjectClass *oc)
>  {
>  }
> +
> +char *kvm_aia_mode_str(uint64_t aia_mode)
> +{
> +    const char *val;

I just tried compiling this series and see it doesn't with -Werror.
kvm_aia_mode_str() should return 'const char *' and this 'val' variable
is unused.

Thanks,
drew
