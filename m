Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415C2752053
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbjGMLpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjGMLpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:45:45 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A745E5C
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 04:45:44 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f96d680399so1046860e87.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 04:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689248743; x=1691840743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XF/kJz3Mtl7rTr+akrMPMh7NT9a+W113nDrHXX3tyKU=;
        b=R5yEz0bJN9gmil0RBmK/5K/6osL2cjmTbVypi/ixxdHDr+fckuz2XAGrqudFi1VC1Z
         4RJtgmfNZl9TSinagOTcj+6eUBz1qqIVsfrxCM9PSod8PJ6h4yJHUfg34fLWFOfTIsSd
         kYqmezpxW5QDbSpA481Gity5AC9HV/Os0Rjj3Mxoy5bHPvkjP8RzNtoBJ6QOQzYPUXw3
         uVJ3XJRKy/g/Lh4g/Hfrnh91XVaTKY8ZpvCOApinYjTO7KJFL5f3dwYRjKQAeX6qYBZ+
         Zrk2GYOCxOrDeYSdAPtG7w2+jAoM7dwu6WDoGcbcTegv1GUS7OayypoCL7keJH5+pMoc
         b1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689248743; x=1691840743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XF/kJz3Mtl7rTr+akrMPMh7NT9a+W113nDrHXX3tyKU=;
        b=FTGjyqQWpYEvILjZisd1bMhdPMGtcwQDxY3eK+GNJmSr1FBcExLuDrGAzrRG2hyf9p
         YGRkDTxp0q+rgom8EB+o5kh2GEQRocnEOhBmZPg9B1N7RRiDlf5JBoKSI1vcBJDDx39J
         z+soteD10tnX8+sxcXKyA+9eJ/nuND6+CFcMJnbIKSyIMPHmhYvPgR8HojvP2VF43vgD
         bjpZv3std0bprQSUiTWMQeUXPrI4tOCmpxA/J43/VU8wKdZeyZOGCEYRqW2khQ3/6hiC
         BmDseJBCYyXXF5X2lvXY7y8ILaGtMzndjpNpIEzDQxA5aMoWeSsFYHdcHGZbwhcngSn1
         vkUw==
X-Gm-Message-State: ABy/qLZdi2Z7Rb2Dd66lOyQDvEaV5HbsYJxdtyvK8AYWfiowY0kATfFF
        qHOjqWy2rHj59WdQH7J81XUxje0m1qqWTdKVLQg=
X-Google-Smtp-Source: APBJJlHrI74GavTFgops6Qf4pMDH7uzQ3B0ogVSZ1CL2UfyrxjxfYcZKoLD65agt1/cFOKsyv7zzMw==
X-Received: by 2002:a19:5016:0:b0:4f7:3ee8:eede with SMTP id e22-20020a195016000000b004f73ee8eedemr1215430lfb.61.1689248742691;
        Thu, 13 Jul 2023 04:45:42 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n7-20020aa7c447000000b0051e22660835sm4193594edr.46.2023.07.13.04.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 04:45:42 -0700 (PDT)
Date:   Thu, 13 Jul 2023 13:45:41 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Samuel Ortiz <sameo@rivosinc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] RISC-V: KVM: Allow Zicntr, Zicsr, Zifencei, and
 Zihpm for Guest/VM
Message-ID: <20230713-0a6b8a76803c70d3fe92f77c@orel>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
 <20230712161047.1764756-5-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712161047.1764756-5-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:40:44PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zicntr, Zicsr, Zifencei, and Zihpm
> extensions for Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 4 ++++
>  arch/riscv/kvm/vcpu_onereg.c      | 8 ++++++++
>  2 files changed, 12 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
