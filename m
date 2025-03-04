Return-Path: <kvm+bounces-39962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD4AA4D2B1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4993168C29
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A25D1EF0BC;
	Tue,  4 Mar 2025 04:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dF+MnH2I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18A11EC00F
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 04:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063985; cv=none; b=kLErK20xEl4/rENTsEEL1ce8UevOiaKh6Gx+y2fCfvFCqqpF4wplnXLTOlF9NPrxoSo8H9purMrD+A4M4FXLDK6AZrynuOGVEP4imN4IBbXAW7bhKmN264TQTa9uNNBBPaneoG2SRgjhM3OumvnnbRJv+yVNBW9Gw1zTKM59M3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063985; c=relaxed/simple;
	bh=zfjVZcx2cE/z0JCBIXKs0CNEtspZuks9Gv3CVhRkmYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P2UgajVtqn9AMU//RUGjWR5MqqEC2lIp9wHxRUlc45LoJYFW3/PZv9EthgLQBc0pdnqBvA65aCw3fsmFafwUy9eqeSgTCB7IruNcmBs+r3/f7TaaYa2op2axJJeFIDIO9ZIllw5CfVbv7x/bzEHgneuCKS8oadW9JtACz13S/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dF+MnH2I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741063982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AxELm9JZG3yKkBZZ33qtCi2pLAO/qCPDSQRXT6O3LAA=;
	b=dF+MnH2IOCvjEsWgyxtqjg7/YHHOd1bTS5MKPNvmmLOOTaJzeKGRIGuCRcfwWCehSlD1yL
	rCqaby13Eec2V3HJBLNbTeaB5BT6Qzx1mJwhBZRK1AHZgC5DYOjqL7pv+KoN0J6EN22ASW
	ZyVM4eKjuQZNl9odSmHXqpoTrxt7jf0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-5KHWyTPhNTKD4O3Pw62Q9A-1; Mon, 03 Mar 2025 23:53:01 -0500
X-MC-Unique: 5KHWyTPhNTKD4O3Pw62Q9A-1
X-Mimecast-MFC-AGG-ID: 5KHWyTPhNTKD4O3Pw62Q9A_1741063981
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22379af38e0so51114525ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 20:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741063981; x=1741668781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxELm9JZG3yKkBZZ33qtCi2pLAO/qCPDSQRXT6O3LAA=;
        b=YPydO0iIN1ovh3MkXgCq31sC+kAxAaTWpbJplD5pR8jrZVpowloqmI67GyhNCFnhvo
         R4sIOLZPrp0/IGAq7aa9U6kLZB8HeeSw+rTEZ1HSWbsYfAdmLnEN3eGIJCvUGJZAcH+m
         wQ/J26DEyKPHh4RJhtbv34zvw16Dx5D19jAssfnq1doxtxXx+93/7WWCzRlTlOfNv8b1
         0K0MiSXMpksVawx5Kxicufc7RPQ8n+7mX5omF+kXu9J0udqj0AW4f4ATjaXPkdvSAO2z
         Hawu0s+IRlX0+Mra8sbPp2i9U2eRWNMVxjEKFPEfmAmqnFTRg5ZE8I8e943c4wmwEYRL
         lNbg==
X-Forwarded-Encrypted: i=1; AJvYcCWgS1vNi/QWQpSlTctx06LmLTeJIaq3hJ5pQNHLr2tgnsMTZm9joxclFDX3vt5H4lqz6PI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGwc5yt4et0anXBS5QdmXjo3iYlFED9HTmjuNhgBo4uCTv3moD
	jLpqjPiG0u9JebyjGegwX39Kna0WH4tODJN8CkjeEwmdCgP7L92jsdwlMQkV30vMPNQYj5mrIjA
	tjmXdWaYSSn+OCUrKYAy1RZryA0ZiKSVagTEQRoTgN4s7iXIYcg==
X-Gm-Gg: ASbGncuP1iU5prhK0eIyVFIvXyqXLI0cxyYKekMlHq9x78zzESmpIo+lDZLi+nt+ldH
	WeHVMTBm88fJ01mvbYwuSnEOUA5RskufUrQgp+LyDP1t4Gh9ckyuubsAwMO+BhmrZ3sWWRuqhg+
	X/Bn2InI1hNKtpuA2I2gNyK7/8Ku/vl9H+3V7SDyqEM9olUiOUzuPOTre+9pjCPv0GtwlRh8ylK
	nmPHAK04VnHdnAtTh7wsnbc/rrA9asFWEhukcoXjC6raPeqUqKO9fPm8ylm5cscNbyBz1iYJP/E
	doXd0AU0KZhWcHdR+Q==
X-Received: by 2002:a05:6a00:3916:b0:730:79bf:c893 with SMTP id d2e1a72fcca58-734ac33818amr25659486b3a.4.1741063980686;
        Mon, 03 Mar 2025 20:53:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrKK12tR3N+mbAAVfdfQ2dTRLheKip2yCmHrOCAijBgggtR8kRt8J5JVYj+IuDCpb/96NhUg==
X-Received: by 2002:a05:6a00:3916:b0:730:79bf:c893 with SMTP id d2e1a72fcca58-734ac33818amr25659458b3a.4.1741063980378;
        Mon, 03 Mar 2025 20:53:00 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7362dbde43bsm6584335b3a.25.2025.03.03.20.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 20:52:59 -0800 (PST)
Message-ID: <abec92a5-0158-4d97-bfdc-03e805a4c96b@redhat.com>
Date: Tue, 4 Mar 2025 14:52:51 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/45] KVM: arm64: Handle realm MMIO emulation
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-20-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-20-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> MMIO emulation for a realm cannot be done directly with the VM's
> registers as they are protected from the host. However, for emulatable
> data aborts, the RMM uses GPRS[0] to provide the read/written value.
> We can transfer this from/to the equivalent VCPU's register entry and
> then depend on the generic MMIO handling code in KVM.
> 
> For a MMIO read, the value is placed in the shared RecExit structure
> during kvm_handle_mmio_return() rather than in the VCPU's register
> entry.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Inject SEA to the guest is an emulatable MMIO access triggers a data
>     abort.
>   * kvm_handle_mmio_return() - disable kvm_incr_pc() for a REC (as the PC
>     isn't under the host's control) and move the REC_ENTER_EMULATED_MMIO
>     flag setting to this location (as that tells the RMM to skip the
>     instruction).
> ---
>   arch/arm64/kvm/inject_fault.c |  4 +++-
>   arch/arm64/kvm/mmio.c         | 16 ++++++++++++----
>   arch/arm64/kvm/rme-exit.c     |  6 ++++++
>   3 files changed, 21 insertions(+), 5 deletions(-)
> 

One nitpick below, with it addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index a640e839848e..2a9682b9834f 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -165,7 +165,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>    */
>   void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
>   {
> -	if (vcpu_el1_is_32bit(vcpu))
> +	if (unlikely(vcpu_is_rec(vcpu)))
> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
> +	else if (vcpu_el1_is_32bit(vcpu))
>   		inject_abt32(vcpu, false, addr);
>   	else
>   		inject_abt64(vcpu, false, addr);
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index ab365e839874..bff89d47a4d5 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -6,6 +6,7 @@
>   
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/rmi_smc.h>
>   #include <trace/events/kvm.h>
>   
>   #include "trace.h"
> @@ -136,14 +137,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>   		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>   			       &data);
>   		data = vcpu_data_host_to_guest(vcpu, data, len);
> -		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> +
> +		if (vcpu_is_rec(vcpu))
> +			vcpu->arch.rec.run->enter.gprs[0] = data;
> +		else
> +			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>   	}
>   
>   	/*
>   	 * The MMIO instruction is emulated and should not be re-executed
>   	 * in the guest.
>   	 */
> -	kvm_incr_pc(vcpu);
> +	if (vcpu_is_rec(vcpu))
> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_EMULATED_MMIO;
> +	else
> +		kvm_incr_pc(vcpu);
>   
>   	return 1;
>   }
> @@ -162,14 +170,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   	 * No valid syndrome? Ask userspace for help if it has
>   	 * volunteered to do so, and bail out otherwise.
>   	 *
> -	 * In the protected VM case, there isn't much userspace can do
> +	 * In the protected/realm VM case, there isn't much userspace can do
>   	 * though, so directly deliver an exception to the guest.
>   	 */
>   	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
>   		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
>   				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
>   
> -		if (vcpu_is_protected(vcpu)) {
> +		if (vcpu_is_protected(vcpu) || vcpu_is_rec(vcpu)) {
>   			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>   			return 1;
>   		}
> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index aae1adefe1a3..c785005f821f 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -25,6 +25,12 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>   
>   static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>   {
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
> +		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
> +			     rec->run->exit.gprs[0]);
> +

A comment may be needed to explain why GPR[0] has to be copied over. The contexnt
in GPR[0] isn't needed by all cases, being handled by kvm_handle_guest_abort().
Something like below.

	/*
	 * Copy over GPR[0] to the target GPR, preparing to handle MMIO write
	 * fault. The content to be written has been saved to GPR[0] by RMM.
	 * It's overhead to other cases like fault due to MMIO read, shared
	 * or private space access.
	 */

>   	return kvm_handle_guest_abort(vcpu);
>   }
>   

Thanks,
Gavin


