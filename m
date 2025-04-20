Return-Path: <kvm+bounces-43700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 825C1A94809
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 16:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 785CF3AE1AC
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 14:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355911EB196;
	Sun, 20 Apr 2025 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJuB2D9z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0655C96
	for <kvm@vger.kernel.org>; Sun, 20 Apr 2025 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745159141; cv=none; b=QfLMPKUI5u8h0YA4IfQ/pAgxxAKjLpqKyTHiRNn/bjSoo5ss4ntvfg5tKhjKl75it+syKvkp/VkWdlVQDyY6TR+A2r7IdaChSiiWRQFTH5KDcWsuweplgK6hTAcZsOvpEUc6z2OiK6HTitq5Tu6tYKk7NigwVzGZJ7KvGrTmkV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745159141; c=relaxed/simple;
	bh=3FZD7Et6wJsmt1RAR5uSHJNoM9XMBPRANuhBEKdyiJU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GAryRkiw3Hv3umxatCxvMUcbHDjYql1ENeFUZd9t+Xr8zldfiVi4+oUbCxmYwQSbs5E4AurLOqrJ71IwUfVTnEnwJNuW+lKyu8OWJEYo8BO8bXWye4nEXUuG0viIrroKB6Gs1dDFusnXyA1qw2PTtwJy2Oa1gMDjWMIpdC1Vp60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJuB2D9z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6074FC4CEE2;
	Sun, 20 Apr 2025 14:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745159139;
	bh=3FZD7Et6wJsmt1RAR5uSHJNoM9XMBPRANuhBEKdyiJU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BJuB2D9zDDcPzuOvIf4ZE+CfLU0EpctHdXWrTZ6GVXRUbnAjWPXT5Gb0Q/f60C4Cn
	 /oEbJ0s7bXU5PdPFvRRoLdnDV9gd4LTRLUO/hfHnM5L41IJPczDUxjjpQVVaovnUYb
	 Ty3kHLupB2WIgwIv65t66k0n5B125xfXWX2oqCJdJ93oTFMelxm7Z1HYhQW56Zyivu
	 PDkwygdh+jqFYLKB86grlIXyTI2SG6f7umFTZl/JiNX86VpgrbH1bRc72bmMWmSmGV
	 RWLpfkD7cQShNPlBSl5Tu4tekjl5uEB2U3K73imQqmjxNJZG9dApc7VHN+/8DKQJDk
	 lrPdUhPIMtI4Q==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
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
Date: Sun, 20 Apr 2025 19:55:33 +0530
Message-ID: <yq5a4iyikizm.fsf@kernel.org>
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

I can recreate this with distro kernel as the guest kernel but not with
CONFIG_SMP enabled with kvm_guest.config. I will have to find out what
is causing that KVM_EXIT_UNKNOWN on the secondary cpu boot.

-aneesh

