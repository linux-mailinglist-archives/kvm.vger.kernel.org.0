Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9896A7CC7EC
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344144AbjJQPtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbjJQPtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:49:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ACD9E
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697557713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rakr0vS7xpMkHkymSTKEpL4VGLpPuEArnF01cq9l1Gs=;
        b=ClTx9TlZgas7U9lM1xZP7SIxAKPnPP5KRNi+jw+KfTICto8SPh79S/wJH5LpMDiIkmmO+0
        wspo1Ve8q7N4yS0PPT2NuVTeojbUmEhIzd53OjmKFMTmwNjwilv81vQiHIwFcXlFIJi941
        xC150za7ldX40M/mDysfprYwR6Y7geM=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-qDqZC8PxNe6zhtMJrrhwjA-1; Tue, 17 Oct 2023 11:48:16 -0400
X-MC-Unique: qDqZC8PxNe6zhtMJrrhwjA-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3b2b1af964eso6897878b6e.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697557696; x=1698162496;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rakr0vS7xpMkHkymSTKEpL4VGLpPuEArnF01cq9l1Gs=;
        b=OLmrc2Js2fN08zqocPgRBuj1+MDfgQebPbUPj5PZdu9y7j+6trmE7CJGEisG2ro9Q0
         MqIBVKCJk7ytbMuFqTwzQ1cSliMTr9I0aNpOTFGPGE+nC14kkyQrOX+Cxzw+z7Fptb1z
         lXYxf+BCXbKB7qxdYTbJu8Tyg8XZ8QA6gfAopCGKDmy1RU5rzfNTBLRb9MuYYzhoJiXD
         YuwdD5K/q6maBGYh1TYfSVzk1RTmNyYLwgiFNbZ/FgPCcRZ4i8S9boiZvcLjFymtcVs4
         wtuT9N4W07nKpCZ7SD2TdOJvnSEfVHvTd+NOTRSIKcdnrLBycfqjJpW+odf9Y4HXgtOR
         RNug==
X-Gm-Message-State: AOJu0YwRLm90wz737JuTfluw8CfmeEr2llfpC6WTmQczBZTeYZGajvBH
        9EN6ackIuKVNauXA2n2Es2g1At4YayCwST9KF25vg/phrXYKaBBjfgpXzGlmPu//DgTUBNcOtPd
        aqFsKxig7+lmp
X-Received: by 2002:a05:6808:178e:b0:3af:9851:4d32 with SMTP id bg14-20020a056808178e00b003af98514d32mr3308975oib.7.1697557696061;
        Tue, 17 Oct 2023 08:48:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj5Zx5Gy8DmigS+K6YA2nZSBjYa71w34REhv1lOtWsOhC2mMlp35j9iNTJ82axlaS6tHkBcQ==
X-Received: by 2002:a05:6808:178e:b0:3af:9851:4d32 with SMTP id bg14-20020a056808178e00b003af98514d32mr3308965oib.7.1697557695835;
        Tue, 17 Oct 2023 08:48:15 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id x11-20020a0cfe0b000000b0065b1f90ff8csm653839qvr.40.2023.10.17.08.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 08:48:15 -0700 (PDT)
Date:   Tue, 17 Oct 2023 17:48:11 +0200 (CEST)
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
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce vpmu_counter_access
 test
In-Reply-To: <20231009230858.3444834-11-rananta@google.com>
Message-ID: <e0fdb0ea-2f08-6343-1765-afe32510f3a7@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> +static void guest_code(uint64_t expected_pmcr_n)
> +{
> +	uint64_t pmcr, pmcr_n;
> +
> +	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
> +			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
> +			expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
> +
> +	pmcr = read_sysreg(pmcr_el0);
> +	pmcr_n = get_pmcr_n(pmcr);
> +
> +	/* Make sure that PMCR_EL0.N indicates the value userspace set */
> +	__GUEST_ASSERT(pmcr_n == expected_pmcr_n,
> +			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> +			pmcr_n, expected_pmcr_n);

Expected vs read value is swapped.


Also, since the kernel has special handling for this, should we add a
test like below?

+static void immutable_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	uint64_t sp, pmcr, pmcr_n;
+	struct kvm_vcpu_init init;
+
+	create_vpmu_vm(guest_code);
+
+	vcpu = vpmu_vm.vcpu;
+
+	/* Save the initial sp to restore them later to run the guest again */
+	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	pmcr_n = get_pmcr_n(pmcr);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_init_descriptor_tables(vcpu);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	/* Update the PMCR_EL0.N after the VM ran once */
+	set_pmcr_n(&pmcr, 0);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+
+	/* Verify that the guest still gets the unmodified value */
+	run_vcpu(vcpu, pmcr_n);
+
+	destroy_vpmu_vm();
+}

