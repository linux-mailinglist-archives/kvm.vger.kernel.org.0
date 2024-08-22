Return-Path: <kvm+bounces-24804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FBCF95AC44
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 05:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DF35281CF1
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 03:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB17136AFE;
	Thu, 22 Aug 2024 03:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huLp39pL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6323433C0;
	Thu, 22 Aug 2024 03:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724298799; cv=none; b=KL0OssDg0P+61zVWbXDO5qTcA5Ke3iz8tPPRYu8zS7B/UB5aYKYfCvdcBUypJNh58Bs/kzZf1b3K77lEhXXkHtcO8h/e6PIPDvssfXd8vS9QRZcmssnu/M+QPxtONR4wRK8HDDt7ww4YrUSxqIirGnhkD/z/+lK1PVLUujJtvaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724298799; c=relaxed/simple;
	bh=lQkngNsxmX1RosieqOuwNFWeXUOJ8jXJeC0eLMrePwE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Sn7NRdnXmZLLLfJsSNdwDIoxA7wWgyLz6CM647gHV5+kPtPmmyMWJqHr11DQBOKibFunZGHDPN+GqsySnXYwK+28E44aIBFS0S7Jr9wUvqTpGxQ8JgrMBagBKG62kC1pGubXs3duBYMcEZepYS9bKRLEAcUlx4831fcXHH6pw3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huLp39pL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B71BC4AF09;
	Thu, 22 Aug 2024 03:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724298799;
	bh=lQkngNsxmX1RosieqOuwNFWeXUOJ8jXJeC0eLMrePwE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=huLp39pLmt+ag3odDw/P4H9LBhorXwgCcr53HUzIaWgRD+DjFLiOSPqPWXg5cHXYv
	 +2KpDKpZq6sAiql+luhHtCqJjCXL1XWHTGvQNo7Vt5fhzhPaRX7QZ3qx4CIPU9mRIh
	 oLoI1xyRnF6DvT+TqDVJe5rPaNITdxHyWh0TOV7M6c5KlsICuThy/SFIVguIiIFYRS
	 6Nrz8P/bOPGNKPo3JOpU+/7fPwoU5lXQ+FX696mS+NsTqm+d3Gx5WhmKDHtsxTt03U
	 OGHH04cOa4EN0wmcFJUTqUWQjAwY5rhUxex6rH4lrtbV/YLs/ubEI/iEZ+uNDT0m/y
	 tqo/9W3olcjZQ==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
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
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
In-Reply-To: <20240821153844.60084-19-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-19-steven.price@arm.com>
Date: Thu, 22 Aug 2024 09:23:07 +0530
Message-ID: <yq5aa5h52oyk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>  * realm_set_ipa_state() now provides an output parameter for the
>    top_iap that was changed. Use this to signal the VMM with the correct
>    range that has been transitioned.
>  * Adapt to previous patch changes.
> ---
>  arch/arm64/include/asm/kvm_rme.h |   3 +
>  arch/arm64/kvm/Makefile          |   2 +-
>  arch/arm64/kvm/arm.c             |  19 +++-
>  arch/arm64/kvm/rme-exit.c        | 181 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/rme.c             |  11 ++
>  5 files changed, 210 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm64/kvm/rme-exit.c
>
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index c064bfb080ad..0e44b20cfa48 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -96,6 +96,9 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>  int kvm_create_rec(struct kvm_vcpu *vcpu);
>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>  
> +int kvm_rec_enter(struct kvm_vcpu *vcpu);
> +int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
> +
>  void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
>  			   u64 size,
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 5e79e5eee88d..9f893e86cac9 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -21,7 +21,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o \
> -	 rme.o
> +	 rme.o rme-exit.o
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 568e9e6e5a4e..e8dabb996705 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1282,7 +1282,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		trace_kvm_entry(*vcpu_pc(vcpu));
>  		guest_timing_enter_irqoff();
>  
> -		ret = kvm_arm_vcpu_enter_exit(vcpu);
> +		if (vcpu_is_rec(vcpu))
> +			ret = kvm_rec_enter(vcpu);
> +		else
> +			ret = kvm_arm_vcpu_enter_exit(vcpu);
>  
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>  		vcpu->stat.exits++;
> @@ -1336,10 +1339,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  		local_irq_enable();
>  
> -		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> -
>  		/* Exit types that need handling before we can be preempted */
> -		handle_exit_early(vcpu, ret);
> +		if (!vcpu_is_rec(vcpu)) {
> +			trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
> +				       *vcpu_pc(vcpu));
> +
> +			handle_exit_early(vcpu, ret);
> +		}
>  
>  		preempt_enable();
>  
> @@ -1362,7 +1368,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			ret = ARM_EXCEPTION_IL;
>  		}
>  
> -		ret = handle_exit(vcpu, ret);
> +		if (vcpu_is_rec(vcpu))
> +			ret = handle_rme_exit(vcpu, ret);
> +		else
> +			ret = handle_exit(vcpu, ret);
>  	}
>

like kvm_rec_enter, should we name this as handle_rec_exit()?

 arch/arm64/include/asm/kvm_rme.h | 2 +-
 arch/arm64/kvm/arm.c             | 2 +-
 arch/arm64/kvm/rme-exit.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index a72e06cf4ea6..cd42c19ca21d 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -102,7 +102,7 @@ int kvm_create_rec(struct kvm_vcpu *vcpu);
 void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
 int kvm_rec_enter(struct kvm_vcpu *vcpu);
-int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
+int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 05d9062470c2..1e34541d88db 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1391,7 +1391,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 
 		if (vcpu_is_rec(vcpu))
-			ret = handle_rme_exit(vcpu, ret);
+			ret = handle_rec_exit(vcpu, ret);
 		else
 			ret = handle_exit(vcpu, ret);
 	}
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index 0940575b0a14..f888cfe72dfa 100644
--- a/arch/arm64/kvm/rme-exit.c
+++ b/arch/arm64/kvm/rme-exit.c
@@ -156,7 +156,7 @@ static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
  */
-int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
+int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
 	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
-- 


