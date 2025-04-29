Return-Path: <kvm+bounces-44654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F354AA00A6
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E5B97AA7A6
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEEC26FA77;
	Tue, 29 Apr 2025 03:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c15ONdA8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9801327735
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897860; cv=none; b=CIwAIjIecLh2jjJu2jgP6/CvOAvRfrOJ2PS7ZgVH6YbLeWN2bfx/8FLePW5J8AaSmwJyhZPew0gzKbdWdhkRlMeSaSuc+IWxrIJghqqIzTkhby9bIJMQ/g5Itnu9n/e+uNqzRZaLmAcINLSw4W4d2CErnIoBC6KpvJt7znG32e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897860; c=relaxed/simple;
	bh=/dh99NuHQWKdSVFdfmdWdeyGsF4OxWd3FXFH2UZgg/8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UKc955dtgkqDmn2hfRy6A7TOnEw+eX51gWmEc846cCStNTGn2fPaj3anbonJTkSkYG5NrjIRCYmQHvDeLbOshzZbaGH0XZ3aD3axD503FM/niR89rm+VbtPtY64cml/1Izlolzo9PRxBDAufxx/OeisgdP6/1w6vLn1A/AcK6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c15ONdA8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29031C4CEE3;
	Tue, 29 Apr 2025 03:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745897860;
	bh=/dh99NuHQWKdSVFdfmdWdeyGsF4OxWd3FXFH2UZgg/8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=c15ONdA8SZbsSUYcX/D5QnhzZf/F4PCctN0x9R93/TD8zzzUh/p4kz+xGjUO8bdId
	 fm+PgsXRuhaBPJFjQWoV9EUf3q04CxGqxxOxAFUvBNnqUlXr8FOWIkVlGsSH5V9oxt
	 fReRefkCUCRHRsHvHiNxkxWfbW7PuawfDwIppsGd7rPFf6AohwHwvswrAE2CQwF0Jn
	 JKLCTNiCOVHOoRaEgGxUaXbWAQKJOIusfdFym/xYq//YjHqZ9h2xGaXwIPzOcE0mle
	 3UCm+m5hwpt9Z3WyYb7ebMRRD/cXrKMOQBpeJty4Gz52P5PXju2/Tslx19tIYSBi/+
	 3U3PFEE4NWOHg==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 Q)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org
Cc: Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v3 2/3] cpu: vmexit: Retry KVM_RUN ioctl on
 EINTR and EAGAIN
In-Reply-To: <9e2fe85c-f3ad-4e13-b635-78a80c115499@arm.com>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
 <20250428115745.70832-3-aneesh.kumar@kernel.org>
 <9e2fe85c-f3ad-4e13-b635-78a80c115499@arm.com>
Date: Tue, 29 Apr 2025 09:01:08 +0530
Message-ID: <yq5aecxbve2r.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> Hi Aneesh
>
> On 28/04/2025 12:57, Aneesh Kumar K.V (Arm) wrote:
>> When KVM_RUN fails with EINTR or EAGAIN, we should retry the ioctl
>> without checking kvm_run->exit_reason. These errors don't indicate a
>> valid VM exit, hence exit_reason may contain stale or undefined values.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>   include/kvm/kvm-cpu.h |  2 +-
>>   kvm-cpu.c             | 17 ++++++++++++-----
>>   2 files changed, 13 insertions(+), 6 deletions(-)
>> 
>> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
>> index 8f76f8a1123a..72cbb86e6cef 100644
>> --- a/include/kvm/kvm-cpu.h
>> +++ b/include/kvm/kvm-cpu.h
>> @@ -16,7 +16,7 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu);
>>   void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu);
>>   void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu);
>>   void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu);
>> -void kvm_cpu__run(struct kvm_cpu *vcpu);
>> +int kvm_cpu__run(struct kvm_cpu *vcpu);
>>   int kvm_cpu__start(struct kvm_cpu *cpu);
>>   bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
>>   int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
>> diff --git a/kvm-cpu.c b/kvm-cpu.c
>> index 40041a22b3fe..7abbdcebf075 100644
>> --- a/kvm-cpu.c
>> +++ b/kvm-cpu.c
>> @@ -35,27 +35,32 @@ void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
>>   		pr_warning("KVM_SET_GUEST_DEBUG failed");
>>   }
>>   
>> -void kvm_cpu__run(struct kvm_cpu *vcpu)
>> +/*
>> + * return value -1 if we need to call the kvm_cpu__run again without checking
>> + * exit_reason. return value 0 results in taking action based on exit_reason.
>> + */
>
> minor nit: Should we make the return value meaningful, say -EAGAIN 
> instead of -1 ?
>

I was not sure. Having both EINTR and EAGAIN map to just EAGAIN is
confusing IMHO. Instead having a proper return value (-1) which is
documented to imply a retry is better?

>> +int kvm_cpu__run(struct kvm_cpu *vcpu)
>>   {
>>   	int err;
>>   
>>   	if (!vcpu->is_running)
>> -		return;
>> +		return -1;
>>   
>>   	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
>>   	if (err < 0) {
>>   		switch (errno) {
>>   		case EINTR:
>>   		case EAGAIN:
>> -			return;
>> +			return -1;
>>   		case EFAULT:
>>   			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
>> -				return;
>> +				return 0;
>>   			/* fallthrough */
>>   		default:
>>   			die_perror("KVM_RUN failed");
>>   		}
>>   	}
>> +	return 0;
>>   }
>>   
>>   static void kvm_cpu_signal_handler(int signum)
>> @@ -179,7 +184,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>>   		if (cpu->task)
>>   			kvm_cpu__run_task(cpu);
>>   
>> -		kvm_cpu__run(cpu);
>> +		if (kvm_cpu__run(cpu) == -1)
>
> and this could be :
> 		if (kvm_cpu__run(cpu) == -EAGAIN)
>
>> +			/* retry without an exit_reason check */
>> +			continue;
>>   
>>   		switch (cpu->kvm_run->exit_reason) {
>>   		case KVM_EXIT_UNKNOWN:
>
>
> Suzuki

