Return-Path: <kvm+bounces-20180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C35799115BF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 00:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17EAFB20CDB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 22:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822C9140E30;
	Thu, 20 Jun 2024 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldaDGIyB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DC964A98
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718922634; cv=none; b=UaEoRdSvxKa0JUqZcHtKYHyQYbgoD2sYspLUXLk6kEdyZAFPCb+yo0z+tmEbRD6ZjGH70hUrNgEGTEusVjFkNjqFTYp8B2Bd0UGF/OHzYRPwDU72YnWEx0Ik//0qus19u8hx6lcsSrTn0akUDsJguJFEBTJLbje3tVcI/b9/XWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718922634; c=relaxed/simple;
	bh=qU/CK7cK2ztIubEiOnDLG3FhSQGWI8q05/wnLRMya7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UinFUfYzkiFrRh8WPdqaUlAValQ2KMBjyWcnnre/bT6Dg4IYxF1m1Jlk9iukiUFPvJ+fxbdgJUz5z8KnOQi1cuqNOk95a8DYwRcyU2OMyHZ5hnLY2xSWTFy0eT4HfLfKUiExQ8Nfht6HWDfIICfIU7gbZN0CIBI4VtljbspakmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ldaDGIyB; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-37624917c2dso22635ab.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718922631; x=1719527431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHREBPCUIs8n+I6KtcDeDKXi3C09zaSei5HzCaoQhXU=;
        b=ldaDGIyBvF6wDNkosaJ+hgro8FvJeadsCQP3rIOCRZ9OZ36+IkbsIKQpOdnwh3ou8G
         syTScZJIW/zBzuSHM3SGawhMcpw8+f0ppw8zLQ+gbFWFFJPNz627hT/dq/nuA+d5eGs7
         +93+UDvrEbbRqx/bWooE0skUu9ENoFEsIqlH7+JkABeb9t9VXhtRjCpqjUyxu82f/Y1D
         02erSUOoki57n3Yk/pYxqUXb55Ine+PnZnxeUuEB6+DqoHdQnt6a6/xHcV6pJ9HbBM9r
         jBzuAX+ZghWUtK3bpYdO/rfAn3t7xS/fe9luRyb1oEDsNhAue5aX6Z6+3GQ6hH2PYHKi
         vPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718922631; x=1719527431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHREBPCUIs8n+I6KtcDeDKXi3C09zaSei5HzCaoQhXU=;
        b=c+aYgE2t7aD3z+wHMJaA0Fm78RCbzzlCocbvpCJ1f9Z576NPwVGO/6LbuFABI2CSy/
         HY49Hd/QxR24or2dXuUmhGDaAOSYJM6oYzpAy+bpQy2wY0winCAbmAeOPpRdf/D8VK5E
         6+DKQPDKKI9ntiK2JOi8E317NYZVns4ifVcv1YvjPLtZptmWf5sEqVPA7SMpVtMc9ybu
         enrj63w9ZOgKMRyrHVa3n8tPNwWLsJj9YkoO8cPgPko/hT7Dt9ODXajViZUGJYbUj3Rr
         wrbpCrc+UB4bOxaqbIDrWorASfR0YqVXByZUV99tZmj9CP6VdBfabiqCcJFdKKSjE0o0
         5lYg==
X-Forwarded-Encrypted: i=1; AJvYcCUFByD+ZAQyxV7b8M5dpzjXH2LpXLc9RjIPUx7sLHp4Fu2yaNzb53+325MQvPIcn9yW+eRN82dFrfHpjTSfHAV4JZFe
X-Gm-Message-State: AOJu0Yxy33BAnWdP3CnMQoVRDmlc5yLxuZRuSZK7y/f2G24JsXG7ThiX
	fxp2pwRmU8cOvjZ/hDvwiudK6joqR+Q4TMmCDkVjfJcXVjA1B5ShQWhM+6P4x8BWmS8oYRoOhhJ
	YXpf2dYdMMbJmwvjVEozRlrDaHM0aESgJAbE7
X-Google-Smtp-Source: AGHT+IG3QZzSrTWr7FqOD3AtuM1SKP3sfyODhN7mg13aomMD50DF/jtHQSYwrOACQW7sSeuYOA45Mb+PEMZtdzwhpq8=
X-Received: by 2002:a92:dc10:0:b0:375:9e2b:a832 with SMTP id
 e9e14a558f8ab-3762f4f3869mr453635ab.21.1718922630941; Thu, 20 Jun 2024
 15:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619083200.1047073-1-shahuang@redhat.com> <20240619083200.1047073-2-shahuang@redhat.com>
In-Reply-To: <20240619083200.1047073-2-shahuang@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 20 Jun 2024 15:30:18 -0700
Message-ID: <CAJHc60zNNsaALEV6XPdwuTZo1_0y2dT--MLMad0ar5Htt8jCtQ@mail.gmail.com>
Subject: Re: [PATCH v10 1/3] KVM: selftests: aarch64: Add helper function for
 the vpmu vcpu creation
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin

On Wed, Jun 19, 2024 at 1:32=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
> Create a vcpu with vpmu would be a common requirement for the vpmu test,
> so add the helper function for the vpmu vcpu creation. And use those
> helper function in the vpmu_counter_access.c test.
>
> Use this chance to delete the meaningless ASSERT about the pmuver,
> because KVM does not advertise an IMP_DEF PMU to guests.
>
> No functional changes intended.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  .../kvm/aarch64/vpmu_counter_access.c         | 32 ++++---------------
>  .../selftests/kvm/include/aarch64/vpmu.h      | 28 ++++++++++++++++
>  2 files changed, 34 insertions(+), 26 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vpmu.h
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/=
tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index d31b9f64ba14..68da44198719 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -16,6 +16,7 @@
>  #include <processor.h>
>  #include <test_util.h>
>  #include <vgic.h>
> +#include <vpmu.h>
>  #include <perf/arm_pmuv3.h>
>  #include <linux/bitfield.h>
>
> @@ -407,18 +408,8 @@ static void guest_code(uint64_t expected_pmcr_n)
>  /* Create a VM that has one vCPU with PMUv3 configured. */
>  static void create_vpmu_vm(void *guest_code)
>  {
> -       struct kvm_vcpu_init init;
> -       uint8_t pmuver, ec;
> -       uint64_t dfr0, irq =3D 23;
> -       struct kvm_device_attr irq_attr =3D {
> -               .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> -               .attr =3D KVM_ARM_VCPU_PMU_V3_IRQ,
> -               .addr =3D (uint64_t)&irq,
> -       };
> -       struct kvm_device_attr init_attr =3D {
> -               .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> -               .attr =3D KVM_ARM_VCPU_PMU_V3_INIT,
> -       };
> +       uint8_t ec;
> +       uint64_t irq =3D 23;
>
>         /* The test creates the vpmu_vm multiple times. Ensure a clean st=
ate */
>         memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> @@ -430,26 +421,15 @@ static void create_vpmu_vm(void *guest_code)
>                                         guest_sync_handler);
>         }
>
> -       /* Create vCPU with PMUv3 */
> -       vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> -       init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> -       vpmu_vm.vcpu =3D aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_cod=
e);
> +       vpmu_vm.vcpu =3D vm_vcpu_add_with_vpmu(vpmu_vm.vm, 0, guest_code)=
;
>         vcpu_init_descriptor_tables(vpmu_vm.vcpu);
>         vpmu_vm.gic_fd =3D vgic_v3_setup(vpmu_vm.vm, 1, 64);
>         __TEST_REQUIRE(vpmu_vm.gic_fd >=3D 0,
>                        "Failed to create vgic-v3, skipping");
>
> -       /* Make sure that PMUv3 support is indicated in the ID register *=
/
> -       vcpu_get_reg(vpmu_vm.vcpu,
> -                    KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
> -       pmuver =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), =
dfr0);
> -       TEST_ASSERT(pmuver !=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
> -                   pmuver >=3D ID_AA64DFR0_EL1_PMUVer_IMP,
> -                   "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pm=
uver);
> -
>         /* Initialize vPMU */
> -       vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
> -       vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
> +       vpmu_set_irq(vpmu_vm.vcpu, irq);
> +       vpmu_init(vpmu_vm.vcpu);
>  }
>
>  static void destroy_vpmu_vm(void)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/t=
esting/selftests/kvm/include/aarch64/vpmu.h
> new file mode 100644
> index 000000000000..5ef6cb011e41
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <kvm_util.h>
> +
> +static inline struct kvm_vcpu *vm_vcpu_add_with_vpmu(struct kvm_vm *vm,
> +                                                    uint32_t vcpu_id,
> +                                                    void *guest_code)
> +{
> +       struct kvm_vcpu_init init;
> +
> +       /* Create vCPU with PMUv3 */
> +       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +       init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> +
> +       return aarch64_vcpu_add(vm, 0, &init, guest_code);
> +}
> +
> +static void vpmu_set_irq(struct kvm_vcpu *vcpu, int irq)
> +{
> +       kvm_device_attr_set(vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                           KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +}
> +
> +static void vpmu_init(struct kvm_vcpu *vcpu)
> +{
> +       kvm_device_attr_set(vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                           KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> +}
> --
> 2.40.1
>
>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>

- Raghavendra

