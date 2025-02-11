Return-Path: <kvm+bounces-37896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A6CA3122B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47D787A049F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F15260A57;
	Tue, 11 Feb 2025 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZr8NvxJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD894260A30
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739292974; cv=none; b=HkojgD8W/0hBzDafjvsZd2TN+wQJb6fFoA8pIrbnJ9M4tm8DrdZBfBaQkgoNpW3Lao4yUV8yBgcndoZ44F9ZeZ+s0eEvLxCFXYsCHvTtRJQiIPKoLiPNwxtaceK9PqhZMkmCUrucvm0Biog7TZCkZihtUt1ITGvl4sfTQuP4GyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739292974; c=relaxed/simple;
	bh=o9ip2gqZhd0xWo4DIa77rdAvzY616OX7OjtJIkIrKp0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bN09IPCu/JS3XuwTShdaYerHQZjReWU08UPqJ4+fvHhNagEC78dD+BTuNlhq0dFw/zQk3l97xzM89wrW5SlxNhgq72LwWaP/veH8lSvkQ34K/toolwTvqRRIhk43vS2six3fMYeFJYal4Ze/4cIaM8GpFu6qf5iaeSPV3/g3cd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZr8NvxJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96313C4CEDD;
	Tue, 11 Feb 2025 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739292974;
	bh=o9ip2gqZhd0xWo4DIa77rdAvzY616OX7OjtJIkIrKp0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nZr8NvxJ6mziz6Q6fMKIFsClEJ2b20Alq3gvqdlxAnRAkTwPG5D6z4jhDXt1yfjzv
	 wAeCOxQAyR53AeGuc4J//Ah3XexfF9j+n/E/Rjxz9mQ/77Sxr6SZC4mKbv8RNasmjC
	 olfYITgVULz97AriqWWw5mU70oOnUyQ7gXNxFycSa79FXXaGPQBaE0/YL9/IBQYcYV
	 u8SEZ0IR6XeB5ah6GpiA3JmHDIEAvz0cBmq0+Zt7KBS/Ub8fQqWYjyY8D42MGU1kSY
	 Y6hEYYapNlOKdYBoPsd2+Y84eLdRiruKLHiRKUvPmFUVJrPndtcvC/UIDSr+edGLdF
	 0mPUMwaWSIL4w==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT
 correctly
In-Reply-To: <20250211114848.GD8965@willie-the-truck>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
 <20250211073852.571625-2-aneesh.kumar@kernel.org>
 <20250211114848.GD8965@willie-the-truck>
Date: Tue, 11 Feb 2025 22:26:08 +0530
Message-ID: <yq5att90whcn.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Will Deacon <will@kernel.org> writes:

> On Tue, Feb 11, 2025 at 01:08:52PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Linux kernel documentation states:
>>
>> "Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in
>> that it accompanies a return code of '-1', not '0'! errno will always be
>> set to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
>> userspace should assume kvm_run.exit_reason is stale/undefined for all
>> other error numbers." "
>>
>> Update the KVM_RUN ioctl error handling to correctly handle
>> KVM_EXIT_MEMORY_FAULT.
>>
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  kvm-cpu.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/kvm-cpu.c b/kvm-cpu.c
>> index 66e30ba54e26..40e4efc33a1d 100644
>> --- a/kvm-cpu.c
>> +++ b/kvm-cpu.c
>> @@ -41,8 +41,15 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
>>  		return;
>>
>>  	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
>> -	if (err < 0 && (errno != EINTR && errno != EAGAIN))
>> -		die_perror("KVM_RUN failed");
>> +	if (err < 0) {
>> +		if (errno == EINTR || errno == EAGAIN)
>> +			return;
>> +		else if (errno == EFAULT &&
>> +			 vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
>> +			return;
>> +		else
>> +			die_perror("KVM_RUN failed");
>> +	}
>
> Probably cleaner to switch on errno?

This? . I will update.

	if (err < 0) {
		switch (errno) {
		case EINTR:
		case EAGAIN:
			return;
		case EFAULT:
			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
				return;
			/* fallthrough */
		default:
			die_perror("KVM_RUN failed");
		}
	}

-aneesh

