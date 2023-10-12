Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0577C70E3
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379176AbjJLPC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378304AbjJLPCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32DB90
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697122924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NqKWWi4N1dQcUV0pCxNw2tgDBfyOJnn+/IdI3vL5BCQ=;
        b=inCkd4cYvj9SIJvVGJRueB+n4Y4XdXMWGxe0r7wjxr1ByTWESRf96HxZFajIgIWdbAHgmZ
        /stWSUPz6g33p5DPMhrq/yMD4thVI12f1XsXOrKNqLBxUO/vyq6RbIvNMcHGV/rJj8mmHy
        v3bozQHtbpVJL99K3lwvStbyzV5OTas=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-f46oJHoMOiOQzMflrV8SZw-1; Thu, 12 Oct 2023 11:02:02 -0400
X-MC-Unique: f46oJHoMOiOQzMflrV8SZw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-65b13c48253so11813556d6.3
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697122922; x=1697727722;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqKWWi4N1dQcUV0pCxNw2tgDBfyOJnn+/IdI3vL5BCQ=;
        b=fkWTdp+1R8da4ViHA+v7YfkT4N4RuYgoQGaiDED1MHq0kN77MCHkrqWUu0Fgv5S6w5
         qrBOy+Zk2ppeobwl/sbjf3Q3eZLMJdTh95tY3joI9qSiJUHJkM1E0iQ60+B1CSnR0l7y
         PS32PxieB/XKf9Kccyijc8rnSVbyf9O11JuTYo9+793czLGBDiLghYh+pMo9cM2viudS
         7g3W2wLAWI8xqOzhBncaOdp4mkyH8Sb//pdaABRFaOTnl7RlqZKYyKR80jPNHrsQnrjT
         TkQgFRjkUBJ6qhgVRHyzfthp8ndfEk54m6/M/sk7MYGML7ta8WBZQU0Jt4evLXJQOUXr
         5oFA==
X-Gm-Message-State: AOJu0YwbyXDQETbWakn9spDKMEBbXA5SAX4xVao2TOEoOP4jiGwzxhwj
        qpX3/8ZJc/dtNRf7SbgvUBrWzWc5Y3hlqwfFhqmeS7q0yVMy9nrSlfSfIE3SXRXHATClbIUjOpL
        CQae4WbIMv8Ci
X-Received: by 2002:a05:6214:5b03:b0:65d:1265:48c5 with SMTP id ma3-20020a0562145b0300b0065d126548c5mr25316340qvb.33.1697122921967;
        Thu, 12 Oct 2023 08:02:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjRHnSSwx/haWRgrBki1YsFkWJjXmdjCoMi0wMoPVGd/LNcVTz7v5WLv1JGQct9yRT+ZM1Mw==
X-Received: by 2002:a05:6214:5b03:b0:65d:1265:48c5 with SMTP id ma3-20020a0562145b0300b0065d126548c5mr25316134qvb.33.1697122919236;
        Thu, 12 Oct 2023 08:01:59 -0700 (PDT)
Received: from rh (p200300c93f266600211746b64b43cdf8.dip0.t-ipconnect.de. [2003:c9:3f26:6600:2117:46b6:4b43:cdf8])
        by smtp.gmail.com with ESMTPSA id o15-20020a0cfa8f000000b0066cfbe4e0f4sm2140112qvn.26.2023.10.12.08.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 08:01:58 -0700 (PDT)
Date:   Thu, 12 Oct 2023 17:01:54 +0200 (CEST)
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
In-Reply-To: <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com>
Message-ID: <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com> <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463795790-346822177-1697122918=:6347"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795790-346822177-1697122918=:6347
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 12 Oct 2023, Sebastian Ott wrote:
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
>>  +/* Create a VM that has one vCPU with PMUv3 configured. */
>>  +static void create_vpmu_vm(void *guest_code)
>>  +{
>>  +	struct kvm_vcpu_init init;
>>  +	uint8_t pmuver, ec;
>>  +	uint64_t dfr0, irq = 23;
>>  +	struct kvm_device_attr irq_attr = {
>>  +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>  +		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
>>  +		.addr = (uint64_t)&irq,
>>  +	};
>>  +	struct kvm_device_attr init_attr = {
>>  +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>  +		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
>>  +	};
>>  +
>>  +	/* The test creates the vpmu_vm multiple times. Ensure a clean state
>>  */
>>  +	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
>>  +
>>  +	vpmu_vm.vm = vm_create(1);
>>  +	vm_init_descriptor_tables(vpmu_vm.vm);
>>  +	for (ec = 0; ec < ESR_EC_NUM; ec++) {
>>  +		vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, ec,
>>  +					guest_sync_handler);
>>  +	}
>>  +
>>  +	/* Create vCPU with PMUv3 */
>>  +	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
>>  +	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>>  +	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
>>  +	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
>>  +	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
>>  +					GICD_BASE_GPA, GICR_BASE_GPA);
>>  +
>>  +	/* Make sure that PMUv3 support is indicated in the ID register */
>>  +	vcpu_get_reg(vpmu_vm.vcpu,
>>  +		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
>>  +	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
>>  +	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
>>  +		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
>>  +		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3",
>>  pmuver);
>>  +
>>  +	/* Initialize vPMU */
>>  +	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
>>  +	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
>>  +}
>
> This one fails to build for me:
> aarch64/vpmu_counter_access.c: In function ¡create_vpmu_vm¢:
> aarch64/vpmu_counter_access.c:456:47: error: ¡ID_AA64DFR0_PMUVER_MASK¢ 
> undeclared (first use in this function); did you mean 
> ¡ID_AA64DFR0_EL1_PMUVer_MASK¢?
>   456 |         pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
>   dfr0);

Looks like there's a clash with
"KVM: arm64: selftests: Import automatic generation of sysreg defs"
from:
 	https://lore.kernel.org/r/20231003230408.3405722-12-oliver.upton@linux.dev
---1463795790-346822177-1697122918=:6347--

