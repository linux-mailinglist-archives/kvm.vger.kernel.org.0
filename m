Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BFC694D19
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjBMQno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMQnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:43:43 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC807EF9;
        Mon, 13 Feb 2023 08:43:41 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id j4so4654117iog.8;
        Mon, 13 Feb 2023 08:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/cV7+uN5DOlTqY06NHqC0N/yUfZmJu1nhPWEtUUSQU=;
        b=R9/tuAfwfNdxMtocyIKsCn3o6dgkMH//wp6vIGcTnj+dT9S+haQq5JDRlzdbSPeOlY
         OvsKg3cu410tPtU+IXwHMEJ+mNrS0gQvP4cLfJ3Y9GPorH9X5Np0eZf7K4jhzujERVJp
         fwPjnKcg9B7NEHR8R6ZQnCu+nM9hVuDBdRZXIs/FBLRUS7sBKBSFbiXr4bYVT8svM8yp
         sm1JQQf8Xk0a8qyuIMQSBDSmKS6aDjzbeRlKAwLcQ/28s4Q7f2pRb/9t8/2zE5iMDKZ+
         4lRUHxKRKQalHQgkNUCD1dtu1+EvKYsSgYcIlsX0tX2KNfSiKSCVFAwSZsp/tdbKQUdU
         DWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/cV7+uN5DOlTqY06NHqC0N/yUfZmJu1nhPWEtUUSQU=;
        b=E6tl2gPlnqqUMa93b2fArZkDMFmZ7lbUytdjtoSaDifXeE1KESeEPSIPUSTC3kT0mS
         kPBDWrlAnE2UstXvtwyz9fRnG1zflZQCzWWf4v3Roe0SuxGZ7GQ/xZl534HGlrtCYfCT
         IOAqvmIRokCzkciSoTYFuZ87GrlRCAIhP87bifW/ZFRuUzvtVir8Z5KV6VfetcLgih3x
         6khQSpiyNYV+Wl2e29/gwgDtcM/Kic9nUOakkSSJlZ7IScLnLOkpXF4kd1szwG3kmc+S
         wbpMVAL/Cx4HF2w+7DbovKomdLYxflnG4bWHEfV3xkzUlkVNUBYk0B8MEgrFBbQoqvJg
         qdlw==
X-Gm-Message-State: AO0yUKVkjDNFw4jVmm1cSkDSHHKxCogAmu+w7Pw5QwKadXDOqQ1HQR8R
        PEFM2HLCBg+O4tfvBauWsNc=
X-Google-Smtp-Source: AK7set92g8u0mkrant/iz85vjRdrLOyeBFys9VLdxblB3o4cFam52zSGpnDTFrnTCoRhCqiJWPXbow==
X-Received: by 2002:a05:6602:3429:b0:73a:6c75:5a85 with SMTP id n41-20020a056602342900b0073a6c755a85mr11375804ioz.0.1676306621158;
        Mon, 13 Feb 2023 08:43:41 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id h18-20020a02c732000000b00363d6918540sm4033880jao.171.2023.02.13.08.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:43:40 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:43:34 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 03/28] arm64: RME: Add wrappers for RMI calls
Message-ID: <20230213184334.00007111@gmail.com>
In-Reply-To: <20230127112932.38045-4-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-4-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 11:29:07 +0000
Steven Price <steven.price@arm.com> wrote:

> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/rmi_cmds.h | 259 ++++++++++++++++++++++++++++++
>  1 file changed, 259 insertions(+)
>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..d5468ee46f35
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#include <asm/rmi_smc.h>
> +
> +struct rtt_entry {
> +	unsigned long walk_level;
> +	unsigned long desc;
> +	int state;
> +	bool ripas;
> +};
> +

It would be nice to have some information of the follwoing wrappers. E.g.
meaning of the return value. They will be quite helpful in the later patch
review.

> +static inline int rmi_data_create(unsigned long data, unsigned long rd,
> +				  unsigned long map_addr, unsigned long src,
> +				  unsigned long flags)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE, data, rd, map_addr, src,
> +			     flags, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_data_create_unknown(unsigned long data,
> +					  unsigned long rd,
> +					  unsigned long map_addr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE_UNKNOWN, data, rd, map_addr,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_data_destroy(unsigned long rd, unsigned long map_addr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, map_addr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_features(unsigned long index, unsigned long *out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
> +
> +	*out = res.a1;
> +	return res.a0;
> +}
> +
> +static inline int rmi_granule_delegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_DELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_granule_undelegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_UNDELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_psci_complete(unsigned long calling_rec,
> +				    unsigned long target_rec)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_realm_activate(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_realm_create(unsigned long rd, unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_realm_destroy(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
> +
> +	*aux_count = res.a1;
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_create(unsigned long rec, unsigned long rd,
> +				 unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rec, rd, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_destroy(unsigned long rec)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_create(unsigned long rtt, unsigned long rd,
> +				 unsigned long map_addr, unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rtt, rd, map_addr, level,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_destroy(unsigned long rtt, unsigned long rd,
> +				  unsigned long map_addr, unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rtt, rd, map_addr, level,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_fold(unsigned long rtt, unsigned long rd,
> +			       unsigned long map_addr, unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rtt, rd, map_addr, level, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long map_addr,
> +				     unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, map_addr, level, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_map_unprotected(unsigned long rd,
> +					  unsigned long map_addr,
> +					  unsigned long level,
> +					  unsigned long desc)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, map_addr, level,
> +			     desc, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long map_addr,
> +				     unsigned long level, struct rtt_entry *rtt)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_RTT_READ_ENTRY,
> +		rd, map_addr, level
> +	};
> +
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	rtt->walk_level = regs.a1;
> +	rtt->state = regs.a2 & 0xFF;
> +	rtt->desc = regs.a3;
> +	rtt->ripas = regs.a4 & 1;
> +
> +	return regs.a0;
> +}
> +
> +static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
> +				    unsigned long map_addr, unsigned long level,
> +				    unsigned long ripas)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, map_addr, level,
> +			     ripas, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
> +					    unsigned long map_addr,
> +					    unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, map_addr,
> +			     level, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline phys_addr_t rmi_rtt_get_phys(struct rtt_entry *rtt)
> +{
> +	return rtt->desc & GENMASK(47, 12);
> +}
> +
> +#endif

