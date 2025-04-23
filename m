Return-Path: <kvm+bounces-43918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C606A987E7
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 12:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 021DF7A75D4
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8316726B96A;
	Wed, 23 Apr 2025 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4S/NzTs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EA910A1F
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405677; cv=none; b=qshoQQHIjqmuINcdInQdkeBSNtOsacmzSmkjpHPIRpBAvl1iuFzQfPXsPL/ibWMgTI7wm4Xp+oxPIFYabSKs6n+UsWWyWe2BRjDYZFk4inoZH99cc8n2iXArz4N0vGQwM/90EpGCh2Fy/gcPidQa1/gDe6rg42aA6mB/5FdpK8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405677; c=relaxed/simple;
	bh=aHDn6ge4cRBqqSuItsEuM+6K5lzg1tcbbcPgl6BmAqU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=q51Fi9Q9YymWBFnl13fyuZrGUmE3cMlZ/GD6E+6QimUCB8FbjAHXyqZMUcmxv0MQ2fZ7y4h5pSmbs08iO5/jOuBraEjdIl6tKKvmbbgh/oRMSEej2jen++iC1uFc4GOx+NRVlrxHBLBnvPB32sy/iGMaJPR+rbl8ofa6amAknPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4S/NzTs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC334C4CEEB;
	Wed, 23 Apr 2025 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745405677;
	bh=aHDn6ge4cRBqqSuItsEuM+6K5lzg1tcbbcPgl6BmAqU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=X4S/NzTsdED0aV243qNsPRLS3sb2IJy5mVDOiVNhWW/9geXHddeB68yl/i/1znY7E
	 9u1ru6W3l1W48rO1Veqrkubu6gZirHiSqL5TZSGuq8LP8Ka2wZ3jQWWPkRgVuwMt/d
	 jiJ8wOtPZ2HvJbTZp4qcSn8MQuhsqM7GsWiQ1mVVJT9M1CltQF6IomNZFLHFuLeKa+
	 cVUPIr3TeOWyJr5Jxsj0P53f4jVjAPZYJ810Bav1fiSA5Kh1DVBrINDHLAKDv8A3MV
	 8rjDSnxoXnR/830yXaKPr6iNrVeOA9v4ZCQXeC4T4ZGMsiwVKDsVEIvX1JonlSC8db
	 EofnD9ZILsu+g==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 Q)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN
 exit reason correctly
In-Reply-To: <20250417120701.GA12773@willie-the-truck>
References: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
 <20250417120701.GA12773@willie-the-truck>
Date: Wed, 23 Apr 2025 16:23:38 +0530
Message-ID: <yq5a4iyfdu8d.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Will Deacon <will@kernel.org> writes:

> On Mon, Feb 24, 2025 at 02:39:59PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> The return value for kernel VM exit handlers is confusing and has led to
>> errors in different kernel exit handlers. A return value of 0 indicates
>> a return to the VMM, whereas a return value of 1 indicates resuming
>> execution in the guest. Some handlers mistakenly return 0 to force a
>> return to the guest.
>> 
>> This worked in kvmtool because the exit_reason defaulted to
>> 0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
>> reason. However, forcing a VMM exit with error on KVM_EXIT_UNKNOWN
>> exit_reson would help catch these bugs early.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  kvm-cpu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/kvm-cpu.c b/kvm-cpu.c
>> index f66dcd07220c..7c62bfc56679 100644
>> --- a/kvm-cpu.c
>> +++ b/kvm-cpu.c
>> @@ -170,7 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>>  
>>  		switch (cpu->kvm_run->exit_reason) {
>>  		case KVM_EXIT_UNKNOWN:
>> -			break;
>> +			goto panic_kvm;
>>  		case KVM_EXIT_DEBUG:
>>  			kvm_cpu__show_registers(cpu);
>>  			kvm_cpu__show_code(cpu);
>> -- 
>> 2.43.0
>
> This breaks SMP boot on my x86 machine:
>
> # ./lkvm run
> ...
> [    0.628472] smp: Bringing up secondary CPUs ...
> [    0.630401] smpboot: x86: Booting SMP configuration:
>   Error: KVM exit reason: 0 ("KVM_EXIT_UNKNOWN")
>   Error: KVM exit code: 0
>

Turns out we should handle EINTR and EAGAIN as special such that we do
an retry of KVM_RUN ioctl without checking the exit_reason.
I can send a v3 if you are ok with the change below.

@@ -16,7 +16,7 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu);
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu);
 void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu);
 void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu);
-void kvm_cpu__run(struct kvm_cpu *vcpu);
+int kvm_cpu__run(struct kvm_cpu *vcpu);
 int kvm_cpu__start(struct kvm_cpu *cpu);
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
modified   kvm-cpu.c
@@ -35,27 +35,32 @@ void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
 		pr_warning("KVM_SET_GUEST_DEBUG failed");
 }
 
-void kvm_cpu__run(struct kvm_cpu *vcpu)
+/*
+ * return value -1 if we need to call the kvm_cpu__run again without checking
+ * exit_reason. return value 0 results in taking action based on exit_reason.
+ */
+int kvm_cpu__run(struct kvm_cpu *vcpu)
 {
 	int err;
 
 	if (!vcpu->is_running)
-		return;
+		return -1;
 
 	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
 	if (err < 0) {
 		switch (errno) {
 		case EINTR:
 		case EAGAIN:
-			return;
+			return -1;
 		case EFAULT:
 			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
-				return;
+				return 0;
 			/* faullthrough */
 		default:
 			die_perror("KVM_RUN failed");
 		}
 	}
+	return 0;
 }
 
 static void kvm_cpu_signal_handler(int signum)
@@ -179,11 +184,13 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 		if (cpu->task)
 			kvm_cpu__run_task(cpu);
 
-		kvm_cpu__run(cpu);
+		if (kvm_cpu__run(cpu) == -1)
+			/* retry without an exit_reason check */
+			continue;
 


-aneesh

