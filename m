Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6348175F8DF
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 15:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjGXNuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 09:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjGXNuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 09:50:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A63422C
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 06:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690206412;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xn9gPQjRRb0V1QRm23HnyLiUiGqmHFZ2cvUJktxsWk=;
        b=adNxMYI5mThzWxqK8oQvYCp8lq5VmIqAKadMPzKGnOCDMSaB5JJlEMJH2u3D4Kt5pftnNE
        8pV7qatEmXNJ5nqBS0nWBax6auu8633utgkcEsKLe5FXxRqg6svttxiMO7B7CB+wsL9MZV
        e73BosVa7Ampw+bDl7qNgDQhw1x+CMI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-V3FYVvSGNt-Lj0TQHi_HBw-1; Mon, 24 Jul 2023 09:46:51 -0400
X-MC-Unique: V3FYVvSGNt-Lj0TQHi_HBw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-63cfe1c2d35so9812436d6.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 06:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690206411; x=1690811211;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xn9gPQjRRb0V1QRm23HnyLiUiGqmHFZ2cvUJktxsWk=;
        b=VIU3AoJkLa2p9fvNMQM9Gm3VI6Afbf2z/PO66jxqDOnX6ptTWd7AxnwEihcB2J5D+X
         p/sw8YOyAEiPT1LgBnwz8S8Cd8iz+5EFRFlrU91Dp811qvIc96wejQt9grmIzf/0iTnT
         qJsL3KTwE1afika3D7rUjWQkX0JELDWx98K4XQSvu7Gw52GlUrmjis7sp56OlumxGD0g
         FiURaJWtyd/WYx5CktX1UVopCdzzRfYXIew/u1syDbOSAaxPWA2J84qIlzMMY5hGOg67
         KffoVW6aSNJqVvJARmNwXA7vti2tJK+g16v4wz0ILsAt1jQf2sl/UmbsOAb3Q4uLLPQH
         k7SQ==
X-Gm-Message-State: ABy/qLbYOhwUoulHddUHFD2fErnXlPuloXb8+dm5vdmioJ8ebh1fr06X
        3geTc+cbMoCCqPWIj5bnSThd7jt8IiU71qAc7VI4eoOe8WbTd8Yq8MccqJClb/oW/9br0MkUEOU
        eDxEvHBqRqZJ3
X-Received: by 2002:a0c:f4cf:0:b0:630:21a6:bb44 with SMTP id o15-20020a0cf4cf000000b0063021a6bb44mr7270327qvm.56.1690206411079;
        Mon, 24 Jul 2023 06:46:51 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG26No1QqlAVxxmnZeRTHRWyhZarVbTKQTqaWhvG6qsLSi8NvGKBb2EOxzJM6QcQZEwT16xWw==
X-Received: by 2002:a0c:f4cf:0:b0:630:21a6:bb44 with SMTP id o15-20020a0cf4cf000000b0063021a6bb44mr7270310qvm.56.1690206410831;
        Mon, 24 Jul 2023 06:46:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id n13-20020a0ce54d000000b00637873ff0f3sm3595004qvm.15.2023.07.24.06.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 06:46:50 -0700 (PDT)
Message-ID: <236a8b03-673e-b242-88c3-4a97fbaf937a@redhat.com>
Date:   Mon, 24 Jul 2023 15:46:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 07/27] arm64: Add missing BRB/CFP/DVP/CPP instructions
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
 <20230712145810.3864793-8-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-8-maz@kernel.org>
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
> HFGITR_EL2 traps a bunch of instructions for which we don't have
> encodings yet. Add them.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9dfd127be55a..e2357529c633 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -737,6 +737,13 @@
>  #define OP_TLBI_VALE2NXS		sys_insn(1, 4, 9, 7, 5)
>  #define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
>  
> +/* Misc instructions */
> +#define OP_BRB_IALL			sys_insn(1, 1, 7, 2, 4)
> +#define OP_BRB_INJ			sys_insn(1, 1, 7, 2, 5)
> +#define OP_CFP_RCTX			sys_insn(1, 3, 7, 3, 4)
> +#define OP_DVP_RCTX			sys_insn(1, 3, 7, 3, 5)
> +#define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_ENTP2	(BIT(60))
>  #define SCTLR_ELx_DSSBS	(BIT(44))
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

