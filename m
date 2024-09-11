Return-Path: <kvm+bounces-26490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A92A9974EDE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE69D1C216F7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 09:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF16D15B153;
	Wed, 11 Sep 2024 09:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="J/vsi7Kc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C6A45C18
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047669; cv=none; b=IeZx6IvM1dOwLc4B+w6/xk3fSm6OQr61oPME13HAcCmozgOvPW8W3jGJQUkOecc6YgNJsBXKhErSAF9NHoFjP+/iwtPG6FTyWyM+nD5h55eiSUk2KXAOt0HLgY2fSNzZiuE9K8ePE77DhHkIiwVzfIsDBcADwVfDdB4dDhK4Ryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047669; c=relaxed/simple;
	bh=D8fV2+h3E/nEK1It6iezm1Hg9oMMDhCzJ5T5q6VIi4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4TYNIRc+3XY6N+I4piOPa2SguS2lptF2FQLdF4efppxaKfuxi/j8O/NSaKcWysQEbcYsEJeTJ16+3Ya95M/L709jaqpwUYE46sElmHwDd8HwDq7YOLQpc8pOPeKap+Q2yw8g1dMfc3DLMDirZWrNZNOmh3gtN+1l5H8k267rgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=J/vsi7Kc; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2054feabfc3so57717525ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 02:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726047667; x=1726652467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZH76peFaXLdICfPd8UUu5baYGOKW8r9xCr4PXI8Nk/M=;
        b=J/vsi7KcbXxRKMAHNS1WF7eZZ3Qm8mm9BbVp9Ai4zc96PKl5n4ULseDInnzaScEPBD
         0tmtxFNJf0T3SJ+d6m/FrT422rVEhw/QScBuchVJ5dtXRPe5wq8tTU9aEOUkjBiFFb6W
         F791I1T0xYgFw4VCoNNsb1iqOhRu7o0QcvSVXBGEYS8k+/QL5xoRoD24INflBTKOUmzM
         Zk3/QZr4nMmeUXtYfE+CTcXAPHcBe0z1iZH9Eg3eN2vzE7xOC/GBLeeajgjjBDNw/pc1
         7A/vWTdVBNtfWey4dDJVBiHX8zwN8pYlvnfjDG+n+Vm+J+lAEuav2sEcWTr17OIf1tGV
         NtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047667; x=1726652467;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZH76peFaXLdICfPd8UUu5baYGOKW8r9xCr4PXI8Nk/M=;
        b=O972/bjZdUWlmIqvHcoeMv54W4IdMQzKgcSd/wF7uqcwmYP2tJg4R6MdvLCorji3Uh
         cwsccKxFOM11o15F+XMKvWLVf6TxzK6XDHdyHCvKDdS6lV24d7VEp/lGDaQC31mZ1dBf
         TFKbL503jliDOqujmqxOz2tfK+ENiDFGuHJ73/NMtkDyVhDEP4h4IJuCbV7M7jAvU7nL
         YEsKWL1TsjmkqJJyJTEhHBurb9Un8oCa9xku8/sO58UxgzW72nHsDrYEUtJSkLw1bAFV
         RFYAW9+Ulx7o09bu0AOGGDuV2qgA4C9EEZx6GUhvXGTKWknJ1tqDKe+YpGTPNCIzB75o
         FT5g==
X-Forwarded-Encrypted: i=1; AJvYcCUPH+csehiScfowvenrHioqGImC7iAlzCc8ehCOIGwiAf6/RJgyq/kBxv98VwSfPSrv8do=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYnJmrrYCg4WlCiG5lP1UME5lwESd9FzWtYljfzfwcajAdI/1q
	S2/2iBE+QZuXNmkkFJKwV/80rw7poOI7IbIoSjtSOCacOn3Z/ap3PHn9Fntheug=
X-Google-Smtp-Source: AGHT+IEhfhfwdLuRZa1ZT7Igq8vngKhwD8/HCRKJeSNTq/lbR3wSLZkiib03oBLW6DRrs0H9qvc3sA==
X-Received: by 2002:a17:902:db01:b0:206:88fa:54a6 with SMTP id d9443c01a7336-2074c5e5c4emr43558915ad.21.1726047667021;
        Wed, 11 Sep 2024 02:41:07 -0700 (PDT)
Received: from [192.168.68.110] (201-68-240-198.dsl.telesp.net.br. [201.68.240.198])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710eef1e7sm59845355ad.120.2024.09.11.02.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 02:41:06 -0700 (PDT)
Message-ID: <b0b9f930-ac79-4710-ac43-6a26bb9dd0df@ventanamicro.com>
Date: Wed, 11 Sep 2024 06:40:51 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/39] target/ppc: replace assert(0) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-12-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20240910221606.1817478-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/10/24 7:15 PM, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/ppc/dfp_helper.c | 8 ++++----
>   target/ppc/mmu_helper.c | 2 +-
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/target/ppc/dfp_helper.c b/target/ppc/dfp_helper.c
> index 5967ea07a92..6ef31a480b7 100644
> --- a/target/ppc/dfp_helper.c
> +++ b/target/ppc/dfp_helper.c
> @@ -249,7 +249,7 @@ static void dfp_set_FPRF_from_FRT_with_context(struct PPC_DFP *dfp,
>           fprf = 0x05;
>           break;
>       default:
> -        assert(0); /* should never get here */
> +        g_assert_not_reached(); /* should never get here */
>       }
>       dfp->env->fpscr &= ~FP_FPRF;
>       dfp->env->fpscr |= (fprf << FPSCR_FPRF);
> @@ -1243,7 +1243,7 @@ void helper_##op(CPUPPCState *env, ppc_fprp_t *t, ppc_fprp_t *b) \
>           } else if (decNumberIsQNaN(&dfp.b)) {                  \
>               vt.VsrD(1) = -2;                                   \
>           } else {                                               \
> -            assert(0);                                         \
> +            g_assert_not_reached();                                         \

Need to realign the '\'. Same thing with the other 2 instances below.

>           }                                                      \
>           set_dfp64(t, &vt);                                     \
>       } else {                                                   \
> @@ -1252,7 +1252,7 @@ void helper_##op(CPUPPCState *env, ppc_fprp_t *t, ppc_fprp_t *b) \
>           } else if ((size) == 128) {                            \
>               vt.VsrD(1) = dfp.b.exponent + 6176;                \
>           } else {                                               \
> -            assert(0);                                         \
> +            g_assert_not_reached();                                         \
>           }                                                      \
>           set_dfp64(t, &vt);                                     \
>       }                                                          \
> @@ -1300,7 +1300,7 @@ void helper_##op(CPUPPCState *env, ppc_fprp_t *t, ppc_fprp_t *a,          \
>           raw_inf = 0x1e000;                                                \
>           bias = 6176;                                                      \
>       } else {                                                              \
> -        assert(0);                                                        \
> +        g_assert_not_reached();                                                        \
>       }                                                                     \
>                                                                             \
>       if (unlikely((exp < 0) || (exp > max_exp))) {                         \

Otherwise,

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

> diff --git a/target/ppc/mmu_helper.c b/target/ppc/mmu_helper.c
> index b0a0676beba..b167b37e0ab 100644
> --- a/target/ppc/mmu_helper.c
> +++ b/target/ppc/mmu_helper.c
> @@ -316,7 +316,7 @@ void ppc_tlb_invalidate_one(CPUPPCState *env, target_ulong addr)
>           break;
>       default:
>           /* Should never reach here with other MMU models */
> -        assert(0);
> +        g_assert_not_reached();
>       }
>   #else
>       ppc_tlb_invalidate_all(env);

