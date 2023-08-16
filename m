Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E481C77DAC2
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 08:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242227AbjHPG7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 02:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242226AbjHPG7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 02:59:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4461FD0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 23:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692169099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=coMx+qrk3+nAFJq/8MLLAKSoS+skVzUmoa64bBG+3v8=;
        b=DK1bTv5j0PmS/Z/f3eitGYNzUnW6Gb7+dHVxM3oYmJUPFwGwmeJ7u0NpuYGSf3LV3kKGrN
        0n4QcoygYKp0I040nShANji/dzWL/1tEcpmFf9Yr2lkFlYkYYeIe+WPxuapzQ52cBBJgA3
        2FIG4XbdbMe+WHB47xB7FkXyxmg6DWU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-fYqvA-DKO1KT-tUW6fyFww-1; Wed, 16 Aug 2023 02:58:18 -0400
X-MC-Unique: fYqvA-DKO1KT-tUW6fyFww-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-26b4befaf7cso882420a91.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 23:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692169097; x=1692773897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=coMx+qrk3+nAFJq/8MLLAKSoS+skVzUmoa64bBG+3v8=;
        b=Il+PtvT/2j1DtDLNsaMiLFE9mSdkhhzA3oRnih3VXe1gEdrCwxIVpkEcCjOwoK5MQp
         ui5AxiLI5sMoOjSRZcqpMAzgxcU17AOop8OmyQOdPzpsAjTDPet6yo5c956N298RQ3DU
         FZ2+vu4ReIHs8dECSQjqBmRM3xSEVnYfZl7NPOqXa4jFEIEiUT0/zhpBi1oopAakYTLx
         vqs9CV/qy10OKnfJyMO2npSxuhDQdgoO6Q0Ovm7M7634AVZ/CY/Zyl5F+GRsfyNEYRMs
         Zi0MhoMPQrJAxNX/Y3yc2e4uNrheusy97GzrjCCeBJyeoEiQ+djJMY4WM+4owPJOgmvX
         HgYA==
X-Gm-Message-State: AOJu0YwzWVxS9IKaqIDCDwc5GuKUel5BYaHnJlLVg13eUMZoymtqtjdI
        tKG/uDhJ7Xr7iNqCfteemWo9dYfR+9FMQIjD7/3L9vsITAmiwMvPBIgOHx+HL61IfWW+y5VYYwZ
        SXs/Kg8ABPSvZ
X-Received: by 2002:a17:902:d2c1:b0:1bb:9e6e:a9f3 with SMTP id n1-20020a170902d2c100b001bb9e6ea9f3mr1275670plc.4.1692169097050;
        Tue, 15 Aug 2023 23:58:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkQ6TEk2n+Vw3400DfBNV4tQEKHqCod2o55k2tbJS/5J/3qoq6lE5clV2Y5xNar/cYRPaAng==
X-Received: by 2002:a17:902:d2c1:b0:1bb:9e6e:a9f3 with SMTP id n1-20020a170902d2c100b001bb9e6ea9f3mr1275646plc.4.1692169096760;
        Tue, 15 Aug 2023 23:58:16 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b001bb9bc8d232sm12229560plg.61.2023.08.15.23.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 23:58:16 -0700 (PDT)
Message-ID: <268054f7-e2f5-37fb-187c-3b2cca41b31a@redhat.com>
Date:   Wed, 16 Aug 2023 14:58:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 11/11] KVM: arm64: selftests: Test for setting ID
 register from usersapce
Content-Language: en-US
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-12-jingzhangos@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230807162210.2528230-12-jingzhangos@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On 8/8/23 00:22, Jing Zhang wrote:
> Add tests to verify setting ID registers from userapce is handled
> correctly by KVM. Also add a test case to use ioctl
> KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/aarch64/set_id_regs.c       | 453 ++++++++++++++++++
>   2 files changed, 454 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
> 
> +
> +static void test_guest_reg_read(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +	bool done = false;
> +
> +	while (!done) {
> +		vcpu_run(vcpu);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_SYNC:
> +			uint64_t val;
aarch64/set_id_regs.c:408:4: error: a label can only be part of a 
statement and a declaration is not a statement.

I can encounter a compiler error at this line. Why not just put the 
uint64_t at the beginning of the function.

Thanks,
Shaoqin

> +
> +			/* Make sure the written values are seen by guest */
> +			vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(uc.args[2]), &val);
> +			ASSERT_EQ(val, uc.args[3]);
> +			break;
> +		case UCALL_DONE:
> +			done = true;
> +			break;
> +		default:
> +			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> +		}
> +	}
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	bool aarch64_only;
> +	uint64_t val, el0;
> +	int ftr_cnt;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	/* Check for AARCH64 only system */
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> +	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
> +	aarch64_only = (el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
> +
> +	ksft_print_header();
> +
> +	ftr_cnt = ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_dfr0_el1)
> +		  + ARRAY_SIZE(ftr_id_aa64pfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr0_el1)
> +		  + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr2_el1)
> +		  + ARRAY_SIZE(ftr_id_aa64mmfr3_el1) - ARRAY_SIZE(test_regs);
> +
> +	ksft_set_plan(ftr_cnt);
> +
> +	test_user_set_reg(vcpu, aarch64_only);
> +	test_guest_reg_read(vcpu);
> +
> +	kvm_vm_free(vm);
> +
> +	ksft_finished();
> +}

-- 
Shaoqin

