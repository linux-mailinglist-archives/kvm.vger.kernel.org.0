Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9FA753E05
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbjGNOsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbjGNOsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:48:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4692686
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 07:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689346074;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yeAVZWo1nWpXTxx8uqutMR7qyb06BZkClmdEo5RsCo=;
        b=CP7C0yUFDqa6mw/h8X5F/Dw6UpexKux0cG+ZrPke7s5YOItVhva4sSdvKjPl7e+B+fjkvf
        HZjehFGgXRimFVFvlHlq5MMtm0A1o1F2dbDVcEioap9q3SY5F6afOWq+WTI/qeWvYDdZFW
        bimp52QGtVwEWOQa+j1W5t3qMzV/0iM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-ZU6rwOoZPRabKyBTGMVbZg-1; Fri, 14 Jul 2023 10:47:53 -0400
X-MC-Unique: ZU6rwOoZPRabKyBTGMVbZg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7677e58c1bfso258175685a.0
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 07:47:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689346067; x=1689950867;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0yeAVZWo1nWpXTxx8uqutMR7qyb06BZkClmdEo5RsCo=;
        b=A7WkbJnMYWjbeIBklCmK59EtECjQuZL1iwiKprQWtt42TvY+M+kB3pgDa3U17Fx3nL
         DjqyOhq2wFJ5tZalFZK2OZ0nXkclOxW8X5vmDAx2cRBzlxZIJeZHSNf5KJAt6741nbmA
         dBFeelVZpZp1hQu4DOtL9kVd28XGUFoZSNnnqGjwuRQBhvsiT/zG6qUF+bHtyxG3d1Du
         UnUy+95HB28kayPAI5iRWUo4emV6iIYtjxuKKma08DjOnF0ebD6CwtZrYdrce1xG+YFK
         2a0PE1kYTgP2MCCD7fY0ETeDYsyTImaFw6fQrx95Ww0xmn8fqiwu4jdNnSC9hYtWiTyI
         +Iww==
X-Gm-Message-State: ABy/qLYCq3gN89KKQPCswB/IGIvHVnKCc4aboSexlNa33AyyPaXoyGuK
        F8U+PA14NhooKnKaTULdEYHyiHVKJze9QPJLEJkPMg2yHElNJ6H/C9oLSHnt46mb4Vdd1qgFyU3
        pn8ymh624c6UU9s/BE7Uj
X-Received: by 2002:a05:620a:b5a:b0:767:8084:5302 with SMTP id x26-20020a05620a0b5a00b0076780845302mr5147393qkg.61.1689346067479;
        Fri, 14 Jul 2023 07:47:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFPiwN0coRoVEHSHclkiGDuZAE9bXk7/SQzfTkLjYV51VKaJ8eGxttE5jlHnNJx6ctJJ5EcmQ==
X-Received: by 2002:a05:622a:1647:b0:403:2966:8fc8 with SMTP id y7-20020a05622a164700b0040329668fc8mr5837668qtj.2.1689346046486;
        Fri, 14 Jul 2023 07:47:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a8-20020ac84348000000b003e69c51cf53sm4015856qtn.72.2023.07.14.07.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 07:47:25 -0700 (PDT)
Message-ID: <a69eda3e-d255-1eb4-c6d2-7ba02ba02468@redhat.com>
Date:   Fri, 14 Jul 2023 16:47:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-7-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-7-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/12/23 16:57, Marc Zyngier wrote:
> The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
> related registers. Add their encodings (and only that, because
> we really don't care about what these registers actually do at
> this stage).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 78 +++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 76289339b43b..9dfd127be55a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -194,6 +194,84 @@
>  #define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)*
>  #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)*
>  
> +#define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))*
> +#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)*
> +#define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))*
> +#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)*
> +#define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))*
> +#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)*
> +#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)*
> +
> +#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)*
> +#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)*
> +#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)*
> +
> +#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
> +#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
I cannot find this one - which is duplicated by the way - in DDI0487Jaa
> +#define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))*
> +#define SYS_TRCACVR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (0 | (m >> 3)))*
> +#define SYS_TRCAUTHSTATUS		sys_reg(2, 1, 7, 14, 6)*
> +#define SYS_TRCAUXCTLR			sys_reg(2, 1, 0, 6, 0)*
> +#define SYS_TRCBBCTLR			sys_reg(2, 1, 0, 15, 0)*
> +#define SYS_TRCCCCTLR			sys_reg(2, 1, 0, 14, 0)*
> +#define SYS_TRCCIDCCTLR0		sys_reg(2, 1, 3, 0, 2)*
> +#define SYS_TRCCIDCCTLR1		sys_reg(2, 1, 3, 1, 2)*
> +#define SYS_TRCCIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 0)*
> +#define SYS_TRCCLAIMCLR			sys_reg(2, 1, 7, 9, 6)*
> +#define SYS_TRCCLAIMSET			sys_reg(2, 1, 7, 8, 6)*
> +#define SYS_TRCCNTCTLR(m)		sys_reg(2, 1, 0, (4 | (m & 3)), 5)*
> +#define SYS_TRCCNTRLDVR(m)		sys_reg(2, 1, 0, (0 | (m & 3)), 5)*
> +#define SYS_TRCCNTVR(m)			sys_reg(2, 1, 0, (8 | (m & 3)), 5)*
> +#define SYS_TRCCONFIGR			sys_reg(2, 1, 0, 4, 0)*
> +#define SYS_TRCDEVARCH			sys_reg(2, 1, 7, 15, 6)*
> +#define SYS_TRCDEVID			sys_reg(2, 1, 7, 2, 7)*
> +#define SYS_TRCEVENTCTL0R		sys_reg(2, 1, 0, 8, 0)*
> +#define SYS_TRCEVENTCTL1R		sys_reg(2, 1, 0, 9, 0)*
> +#define SYS_TRCEXTINSELR(m)		sys_reg(2, 1, 0, (8 | (m & 3)), 4)*
> +#define SYS_TRCIDR0			sys_reg(2, 1, 0, 8, 7)*
> +#define SYS_TRCIDR10			sys_reg(2, 1, 0, 2, 6)*
> +#define SYS_TRCIDR11			sys_reg(2, 1, 0, 3, 6)*
> +#define SYS_TRCIDR12			sys_reg(2, 1, 0, 4, 6)*
> +#define SYS_TRCIDR13			sys_reg(2, 1, 0, 5, 6)*
> +#define SYS_TRCIDR1			sys_reg(2, 1, 0, 9, 7)*
> +#define SYS_TRCIDR2			sys_reg(2, 1, 0, 10, 7)*
> +#define SYS_TRCIDR3			sys_reg(2, 1, 0, 11, 7)*
> +#define SYS_TRCIDR4			sys_reg(2, 1, 0, 12, 7)*
> +#define SYS_TRCIDR5			sys_reg(2, 1, 0, 13, 7)*
> +#define SYS_TRCIDR6			sys_reg(2, 1, 0, 14, 7)*
> +#define SYS_TRCIDR7			sys_reg(2, 1, 0, 15, 7)*
> +#define SYS_TRCIDR8			sys_reg(2, 1, 0, 0, 6)*
> +#define SYS_TRCIDR9			sys_reg(2, 1, 0, 1, 6)*
> +#define SYS_TRCIMSPEC0			sys_reg(2, 1, 0, 0, 7)*
> +#define SYS_TRCIMSPEC(m)		sys_reg(2, 1, 0, (m & 7), 7)*
> +#define SYS_TRCITEEDCR			sys_reg(2, 1, 0, 2, 1)
I cannot find this one in D18-1 or elsewhere in DDI0487Jaa
> +#define SYS_TRCOSLSR			sys_reg(2, 1, 1, 1, 4)*
> +#define SYS_TRCPRGCTLR			sys_reg(2, 1, 0, 1, 0)*
> +#define SYS_TRCQCTLR			sys_reg(2, 1, 0, 1, 1)*
> +#define SYS_TRCRSCTLR(m)		sys_reg(2, 1, 1, (m & 15), (0 | (m >> 4)))*
> +#define SYS_TRCRSR			sys_reg(2, 1, 0, 10, 0)*
> +#define SYS_TRCSEQEVR(m)		sys_reg(2, 1, 0, (m & 3), 4)*
> +#define SYS_TRCSEQRSTEVR		sys_reg(2, 1, 0, 6, 4)*
> +#define SYS_TRCSEQSTR			sys_reg(2, 1, 0, 7, 4)*
> +#define SYS_TRCSSCCR(m)			sys_reg(2, 1, 1, (m & 7), 2)*
> +#define SYS_TRCSSCSR(m)			sys_reg(2, 1, 1, (8 | (m & 7)), 2)*
> +#define SYS_TRCSSPCICR(m)		sys_reg(2, 1, 1, (m & 7), 3)*
> +#define SYS_TRCSTALLCTLR		sys_reg(2, 1, 0, 11, 0)*
> +#define SYS_TRCSTATR			sys_reg(2, 1, 0, 3, 0)*
> +#define SYS_TRCSYNCPR			sys_reg(2, 1, 0, 13, 0)*
> +#define SYS_TRCTRACEIDR			sys_reg(2, 1, 0, 0, 1)*
> +#define SYS_TRCTSCTLR			sys_reg(2, 1, 0, 12, 0)*
> +#define SYS_TRCVICTLR			sys_reg(2, 1, 0, 0, 2)*
> +#define SYS_TRCVIIECTLR			sys_reg(2, 1, 0, 1, 2)*
> +#define SYS_TRCVIPCSSCTLR		sys_reg(2, 1, 0, 3, 2)*
> +#define SYS_TRCVISSCTLR			sys_reg(2, 1, 0, 2, 2)*
> +#define SYS_TRCVMIDCCTLR0		sys_reg(2, 1, 3, 2, 2)*
> +#define SYS_TRCVMIDCCTLR1		sys_reg(2, 1, 3, 3, 2)*
> +#define SYS_TRCVMIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 1)*
> +
> +/* ETM */
> +#define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
not able to locate this one either. I see the bit of HDFGWTR_EL2 though

Eric
> +
>  #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
>  #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
>  #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)

