Return-Path: <kvm+bounces-50423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E660AE55AA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C77CB3AC4B5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7FB22A4DB;
	Mon, 23 Jun 2025 22:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGB61CYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57499226865
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 22:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716680; cv=none; b=sFOAAD/F3O8iOsrcjbY97kJa4hIqwSQ3UFoZNAkqb09fXskxQqcE9qkw+WTWOehlpm2pc2XZHHPZsuFpuJYL0/ZE4/IYbru5pifZNAa49HxJSUQiYlxe+hXmgsVTjZxMl3sOq9uf0WYoVVg9z7LkcfFLcVIK7HE45HU9L+dIz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716680; c=relaxed/simple;
	bh=D7atcKrsikBtKn+dkIVbHfHd96Aa/xzh+Jcn54xGazo=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ugkIT3/ExJKnazI0KwqsG/dSqpHvOTUu6FXm/mufW4POciEW6OaN210KiMjTiQxuSOgJp9cOqIkH3NewDTa8AvfHOoXRdcao2OC1xCpmn0Rr/N/W1aHy/8TF/j5LzQnQqEq5VDNi/2woQjFMEePVYnbS9+Q3l4fJlT5M5ExWSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bGB61CYI; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3de3b5b7703so17390115ab.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750716676; x=1751321476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tGQz+pPj9rguv78Mk1DG88zZ+C5YYmZS8y1NwOe8IHE=;
        b=bGB61CYIjxiMMk7ExweFZl8ed1XFA+qc2eVHDL3x5ZRWn1R1Un/K0VgUbQBLoJdVIp
         n6Avm+KftNSah/p6+BgsIU2/B0gqwcJ6QUvKoAVWaOKSaLJEiyQmvW+hRlMjdjk45n2z
         mnQUCqmNQweTCMH7v2qKRig7xCPJLbZoYQUrlE/V7bDXIgCo36WTTkymnWE6qvlRpftg
         6g+LdfgYQ5idNPutdjrTEsVMclwjWNJ+PnXpllN+/wUzUItACTtd1Q7p4NAYm2tdl/ru
         j/vpp+TsWHfWohs2h/FviZz6AC2kmRP4KhV3KCmNFlmTH9UIfxcN7b9n6SApFthdiD4C
         8tCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750716676; x=1751321476;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tGQz+pPj9rguv78Mk1DG88zZ+C5YYmZS8y1NwOe8IHE=;
        b=cjap0Dk79jalHgqAl6xrp5tZIzhDYqVnPl+ZLNo3OzfjcWHuo+tWIhGsvLlfOweKZK
         C3zQYB42jcQsMf8TwLxvKn3r3ibwTmt86S4ocbz/ZTCPIJZ+RB3bdPDH/4nFjuXYRtmV
         qaHlei3GR+Vn8aw5MV7Cpeb4Jy53u7vbDO9vxZN2AXe46IFuiQP6fcK49k17dtywRwpG
         rOjsxC73W8TW0gXYMmUVtOW4/dkJx64izfONiVKzARigKL7rld8Wt8WXGyTDaDUqVKn6
         DH/uWW4Vg4+TPn5HAZ8fzXRPI4OmBR5sRTyywy0gStWjrek6KjbrqTsw02vYXweYpO4N
         im+g==
X-Gm-Message-State: AOJu0Yx/4SgwZltmiJTDzlfXxG3pHgH9fLBroriPD4nJsEZS3/u49SNX
	Zk13UJWPz6D67rjQyvjTwf0XMeqpNaHIvzQPtqYaXNdzxrqVWUB0sqhy9JOrsaEPozAVTU+N8HN
	CzcOcJej3NBIqdyDa4/qU3WMwHg==
X-Google-Smtp-Source: AGHT+IFROh/q8Un43k3KAN6/Y7TN0oBqMJ1o65GnORb3dUVRyme5Qfos+kVCSSkafOZNJv6Ve5iTj9GtWD2hqiOqYQ==
X-Received: from ilbdr12.prod.google.com ([2002:a05:6e02:3f0c:b0:3dd:b580:4100])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3499:b0:3de:119f:5261 with SMTP id e9e14a558f8ab-3de38c1c019mr212245545ab.3.1750716676655;
 Mon, 23 Jun 2025 15:11:16 -0700 (PDT)
Date: Mon, 23 Jun 2025 22:11:15 +0000
In-Reply-To: <202506221711.tFNGpzj4-lkp@intel.com> (message from kernel test
 robot on Sun, 22 Jun 2025 17:32:31 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntikkm9kho.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 17/23] KVM: arm64: Account for partitioning in PMCR_EL0 access
From: Colton Lewis <coltonlewis@google.com>
To: kernel test robot <lkp@intel.com>
Cc: kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

kernel test robot <lkp@intel.com> writes:

>     In file included from arch/arm64/include/asm/kvm_host.h:32,
>                      from include/linux/kvm_host.h:45,
>                      from arch/arm64/kvm/sys_regs.c:16:
>     arch/arm64/include/asm/kvm_pmu.h:236:50: warning: 'struct arm_pmu'  
> declared inside parameter list will not be visible outside of this  
> definition or declaration
>      static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>                                                       ^~~~~~~
>     arch/arm64/include/asm/kvm_pmu.h:241:52: warning: 'struct arm_pmu'  
> declared inside parameter list will not be visible outside of this  
> definition or declaration
>      static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
>                                                         ^~~~~~~
>     arch/arm64/include/asm/kvm_pmu.h:246:53: warning: 'struct arm_pmu'  
> declared inside parameter list will not be visible outside of this  
> definition or declaration
>      static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
>                                                          ^~~~~~~
>     arch/arm64/kvm/sys_regs.c:856:6: warning: no previous prototype  
> for 'pmu_access_el0_disabled' [-Wmissing-prototypes]
>      bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
>           ^~~~~~~~~~~~~~~~~~~~~~~
>     arch/arm64/kvm/sys_regs.c: In function 'access_pmu_evtyper':
>     arch/arm64/kvm/sys_regs.c:1076:7: error: implicit declaration of  
> function 'kvm_vcpu_pmu_is_partitioned'; did you  
> mean 'kvm_pmu_is_partitioned'? [-Werror=implicit-function-declaration]
>        if (kvm_vcpu_pmu_is_partitioned(vcpu))
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>            kvm_pmu_is_partitioned
>     arch/arm64/kvm/sys_regs.c: In function 'set_pmcr':
>>> arch/arm64/kvm/sys_regs.c:1271:33: error: dereferencing pointer to  
>>> incomplete type 'struct arm_pmu'
>            new_n <= kvm->arch.arm_pmu->hpmn_max))
>                                      ^~
>     cc1: some warnings being treated as errors

Looks like the main problem here is struct arm_pmu is not defined if we
don't have CONFIG_ARM_PMU. I'll provide a dummy definition for that case
and swap out the field reference for a function call.

Secondary problem is making sure there is a prototype for
pmu_access_el0_disabled in that instance.

> vim +1271 arch/arm64/kvm/sys_regs.c

>    1253
>    1254	static int set_pmcr(struct kvm_vcpu *vcpu, const struct  
> sys_reg_desc *r,
>    1255			    u64 val)
>    1256	{
>    1257		u8 new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
>    1258		struct kvm *kvm = vcpu->kvm;
>    1259
>    1260		mutex_lock(&kvm->arch.config_lock);
>    1261
>    1262		/*
>    1263		 * The vCPU can't have more counters than the PMU hardware
>    1264		 * implements. Ignore this error to maintain compatibility
>    1265		 * with the existing KVM behavior.
>    1266		 */
>    1267		if (!kvm_vm_has_ran_once(kvm) &&
>    1268		    !vcpu_has_nv(vcpu)	      &&
>    1269		    new_n <= kvm_arm_pmu_get_max_counters(kvm) &&
>    1270		    (!kvm_vcpu_pmu_is_partitioned(vcpu) ||
>> 1271		     new_n <= kvm->arch.arm_pmu->hpmn_max))
>    1272			kvm->arch.nr_pmu_counters = new_n;
>    1273
>    1274		mutex_unlock(&kvm->arch.config_lock);
>    1275
>    1276		/*
>    1277		 * Ignore writes to RES0 bits, read only bits that are cleared on
>    1278		 * vCPU reset, and writable bits that KVM doesn't support yet.
>    1279		 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
>    1280		 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the  
> vCPU.
>    1281		 * But, we leave the bit as it is here, as the vCPU's PMUver might
>    1282		 * be changed later (NOTE: the bit will be cleared on first vCPU  
> run
>    1283		 * if necessary).
>    1284		 */
>    1285		val &= ARMV8_PMU_PMCR_MASK;
>    1286
>    1287		/* The LC bit is RES1 when AArch32 is not supported */
>    1288		if (!kvm_supports_32bit_el0())
>    1289			val |= ARMV8_PMU_PMCR_LC;
>    1290
>    1291		__vcpu_assign_sys_reg(vcpu, r->reg, val);
>    1292		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>    1293
>    1294		return 0;
>    1295	}
>    1296

> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

