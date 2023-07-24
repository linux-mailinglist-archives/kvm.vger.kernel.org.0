Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7675F9A4
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 16:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjGXOUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 10:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjGXOUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 10:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96996E74
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 07:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690208362;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aYb22kh8alG5LlKzDg2tPXggiu0mwrnQvKEj35bhOe0=;
        b=NC1/qpRxijL2lhj3g1lx3IiIjQep10fo15nMC9DUFyr6qodByyv6w+uY6SgtDQkQsh0+ac
        rO2E3UsXNhXA39e4LRzWC58M0ZZGHUR7s3S4Bn7W1QPp9K4CyCNs5kNj+SDQgYxGx3ZgRH
        Ud229e430h8Z4h16kzYoUfgk/ZHC9Kk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-M7R0RBnpM1OHDdQ-uiIZnw-1; Mon, 24 Jul 2023 10:19:20 -0400
X-MC-Unique: M7R0RBnpM1OHDdQ-uiIZnw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-315926005c9so2079981f8f.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 07:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208358; x=1690813158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYb22kh8alG5LlKzDg2tPXggiu0mwrnQvKEj35bhOe0=;
        b=dZDdJB3cFhM0D1KMegD9CHNmpNAej0bky2JZ41eO3o6VyG+Nff5x7Uxmu8rwKnKttM
         qw8+gy6BwUd6+AX2k0+stvRUck7fmuAlNP2fWVDJpwFWDisgw7oGnvPc/+IyJkaaQQCp
         YifvUyjsth+2mcO/EUe2kAezYX9n8GfCAerLKSZsL5NubsvXdSFjNXPBjtGNjsJ5OXXN
         OgcoyeZs/UQGWYTA4oTfyBITrz6uu0ShxFu1EJY/l4BEVyeIeidqLtJXsIJ5NiuPamxt
         ZeoQ4SA4KC+RSwza+SyjBnC/niECl1/oBc71W9FuhLONzg46zqLAi3r6oK1OTJGrutm3
         a9sw==
X-Gm-Message-State: ABy/qLbuFcvbmZ9Awdydemr0iEla/2m86eUSjEl/7akItaxliJTTcq+p
        4o/PyNjO0jOKHisEkrJFbjFWkxgCTlbq/u9w8Fu0uRTMcMAFwmK1JHClOILz2SU8r6v0N6rnnJm
        e4O1Q8/cR+/6ei1q30v9u
X-Received: by 2002:adf:fec8:0:b0:313:f86f:2851 with SMTP id q8-20020adffec8000000b00313f86f2851mr8405335wrs.3.1690208358604;
        Mon, 24 Jul 2023 07:19:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHiN6PfAHm+REFxXPgyrCMH7IJrGgE0MY5oSex6+ZDc0enUBoZlnmj7g2oP/jjonWtKKrjNLA==
X-Received: by 2002:adf:fec8:0:b0:313:f86f:2851 with SMTP id q8-20020adffec8000000b00313f86f2851mr8405329wrs.3.1690208358308;
        Mon, 24 Jul 2023 07:19:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id j5-20020adff005000000b0031764e85b91sm1394262wro.68.2023.07.24.07.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 07:19:17 -0700 (PDT)
Message-ID: <84951ac4-fe2c-e181-9beb-223d360b87ef@redhat.com>
Date:   Mon, 24 Jul 2023 16:19:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 11/27] KVM: arm64: Correctly handle ACCDATA_EL1 traps
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
 <20230712145810.3864793-12-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-12-maz@kernel.org>
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
> As we blindly reset some HFGxTR_EL2 bits to 0, we also randomly trap
> unsuspecting sysregs that have their trap bits with a negative
> polarity.
>
> ACCDATA_EL1 is one such register that can be accessed by the guest,
> causing a splat on the host as we don't have a proper handler for
> it.
>
> Adding such handler addresses the issue, though there are a number
> of other registers missing as the current architecture documentation
> doesn't describe them yet.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  arch/arm64/kvm/sys_regs.c       | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6d3d16fac227..d528a79417a0 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -389,6 +389,8 @@
>  #define SYS_ICC_IGRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
>  #define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
>  
> +#define SYS_ACCDATA_EL1			sys_reg(3, 0, 13, 0, 5)
> +
>  #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
>  
>  #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bd3431823ec5..3a6f678ca67d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2151,6 +2151,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
>  	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
>  
> +	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access },
> +
>  	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
>  
>  	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

