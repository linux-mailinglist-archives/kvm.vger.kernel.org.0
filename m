Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1C97CB375
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbjJPTsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjJPTsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:48:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A318F
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697485650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hIrxwAD379HWttBABnirV+Sle9T8jRy9iSXJzz/TC4U=;
        b=QdY+FI6r7C5FVetDCc8Gi4cbVJONdtCMfbnN/o7rnz6cJNSMXb5Q+AozZ816b9wzapOy3q
        LnDXsZepkKu9tZmqDGwv1L9NvgTBAQ9ckkjIoEfFAWemGLRIgNfczmB/ZqeECSoYvANPPL
        OfppXmyeN7lGPgsZ1f+7GUZfI1tteFM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-eWOABiYcN6KqJHwG5hvA_g-1; Mon, 16 Oct 2023 15:47:29 -0400
X-MC-Unique: eWOABiYcN6KqJHwG5hvA_g-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7770bfcbdc6so605479185a.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485648; x=1698090448;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIrxwAD379HWttBABnirV+Sle9T8jRy9iSXJzz/TC4U=;
        b=KdFdXFEG0F8VZSQLfSEQomJVSfcA6OHklJ059rDCtV5CnF6l7kb7Mc5WE/9v0wF8dG
         hgu6deJsnBjX1gWiw6E/YVbtKnuILGuS+/f+PAmLKzLxrAQSIJJ1PD8vrxLiMUdUnXOM
         LNAkbSLmtaN1CEvYr159cEwxxt2ofyBiMuBcug2nFY0jCfhrVSNmnoCDK4pqRnbn5awl
         0H/wCElHEsKp8hukIAn2AOenoT92mTsd/xDvDcr4uVMzG6U3+CKa3ZQAgV0MwYXRDhlx
         SqxJV84TK3QM3y/lUNh+iDFe6Dqjw+4F/BvydjF0Y71MgNHEQ9FTVXMgwiqg/vYubmY8
         hNgg==
X-Gm-Message-State: AOJu0YyDyBMUK1Z5dByeSiR5hkXl+r6qrPJptopJF3BLb5mUCA68T8S9
        wv8MxGjo3b1U3N+HlUStjadv9Tmfv0PhcgemZclgLBwdF4gfsW8NUrs23L+tGkItEpNduffJI0R
        sjDGF6fKsYgED
X-Received: by 2002:a05:620a:25ce:b0:777:7240:8de with SMTP id y14-20020a05620a25ce00b00777724008demr147000qko.8.1697485648708;
        Mon, 16 Oct 2023 12:47:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3u6I00hayIaOImQeZghUxCl82gdoyvt4Nd2uprPCzUlhJB397PjkrSk4Pvd5jxnjH++cZDQ==
X-Received: by 2002:a05:620a:25ce:b0:777:7240:8de with SMTP id y14-20020a05620a25ce00b00777724008demr146985qko.8.1697485648421;
        Mon, 16 Oct 2023 12:47:28 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id k27-20020a05620a143b00b007742c6823a3sm3226478qkj.108.2023.10.16.12.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 12:47:27 -0700 (PDT)
Message-ID: <20bdc913-57d2-abe9-d222-d77647281b43@redhat.com>
Date:   Mon, 16 Oct 2023 21:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 04/12] KVM: arm64: PMU: Don't define the sysreg reset()
 for PM{USERENR,CCFILTR}_EL0
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-5-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-5-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> The default reset function for PMU registers (defined by PMU_SYS_REG)
> now simply clears a specified register. Use the default one for
> PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
> registers on vCPU reset (NOTE: All non-RES0 fields of those
> registers have UNKNOWN reset values, and the same fields of
> their AArch32 registers have 0 reset values).
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3dbb7d276b0e..08af7824e9d8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2180,7 +2180,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	 * in 32bit mode. Here we choose to reset it as zero for consistency.
>  	 */
>  	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
> -	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
> +	  .reg = PMUSERENR_EL0, },
>  	{ PMU_SYS_REG(PMOVSSET_EL0),
>  	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
>  
> @@ -2338,7 +2338,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	 * in 32bit mode. Here we choose to reset it as zero for consistency.
>  	 */
>  	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
> -	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
> +	  .reg = PMCCFILTR_EL0, },
>  
>  	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
>  	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

