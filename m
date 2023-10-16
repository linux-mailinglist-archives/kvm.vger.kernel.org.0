Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AAB7CA9AF
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbjJPNhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbjJPNgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A8F116
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 06:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697463355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yy1/cgxKgJiMUa1SJT7ozjNtxww425JfDJ39NondDok=;
        b=EVzT4OuYMdODm733IxECwggQ2BR1zNVYKuw/JespnbHR5sng1L0A4+Tq8V3kNEtVP5g4EH
        ZBF7uh1jjRReQJ7ULJlJjel2Ngbk0UCpviU3j6PHqQr6JUPqghyUN6gbGHuwe2CvXtlSKK
        UdGIFWLVZ/RnoHp9o22jCbv6GBTlS6w=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-P8VSaKkFPP-G6PdzmX58EQ-1; Mon, 16 Oct 2023 09:35:44 -0400
X-MC-Unique: P8VSaKkFPP-G6PdzmX58EQ-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b2b1ade9deso5233868b6e.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 06:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697463343; x=1698068143;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yy1/cgxKgJiMUa1SJT7ozjNtxww425JfDJ39NondDok=;
        b=fHQKd3LjqN0EJVJEtr69YK+HtMhNaveuCLd892OPt/ugArli0I8wSOBTTqK8dwf4rq
         A2t3LhtLE6RfkJ9Q7yVfYofMvqRbQsxHw10mScYEjPNKclmAQRVMuvFO74tZ0l0a6G3n
         oXj1v2IoJJ2rRnURXw9kLstQ9R4RcH0mnqMx4z+nqHTa6s25O8ZuWPX00FKKE2iAPnmj
         t6rLmdHp2PUx8H1dklF5BL4dJ2nKv8civkIv+u51KxlYMUMypg6xLem14uabFlBRM5Qi
         G9qTn3zqu9SOdUdvKsPDdKVr/YBGCXsOE7kGDik9Y8/DCg5Y9hjcuX/9IanFt3ub970c
         lCbA==
X-Gm-Message-State: AOJu0Yy9WOuaCA/Usso0GGOEFymaAd08LevKp1PANUibVAaQ4ySoNfuG
        VNaia3hy6NKcOMbDivOY+XrmgpCCBI/fGLmJQDVybMYh2U4zi/RtQKgfZe6+hn+KLwL4k5J3tHL
        KgVJhik3g2uLZ
X-Received: by 2002:a05:6808:2112:b0:3af:6634:49b9 with SMTP id r18-20020a056808211200b003af663449b9mr45234738oiw.30.1697463343622;
        Mon, 16 Oct 2023 06:35:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE77paMQjv1E0tWECLik6rtZ5xsUdcoZNEFSPtcpxvsM02M0fanwTqgfdfIspb/jqxNklUPGQ==
X-Received: by 2002:a05:6808:2112:b0:3af:6634:49b9 with SMTP id r18-20020a056808211200b003af663449b9mr45234711oiw.30.1697463343313;
        Mon, 16 Oct 2023 06:35:43 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id dl15-20020ad44e0f000000b0066d1540f9ecsm3437870qvb.77.2023.10.16.06.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 06:35:43 -0700 (PDT)
Date:   Mon, 16 Oct 2023 15:35:38 +0200 (CEST)
From:   Sebastian Ott <sebott@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
In-Reply-To: <20231009230858.3444834-8-rananta@google.com>
Message-ID: <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> {
> -	return __vcpu_sys_reg(vcpu, PMCR_EL0);
> +	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) &
> +			~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +
> +	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ff0f7095eaca..c750722fbe4a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> {
> 	u64 pmcr;
>
> -	/* No PMU available, PMCR_EL0 may UNDEF... */
> -	if (!kvm_arm_support_pmu_v3())
> -		return 0;
> -
> 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +	pmcr = kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);

pmcr = ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
Would that maybe make it more clear what is done here?

