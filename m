Return-Path: <kvm+bounces-37898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 868E4A31242
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8601C7A350B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3708F25EFAA;
	Tue, 11 Feb 2025 16:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEj8xtK8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D65F260A47
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739293143; cv=none; b=fZf4jLbb6TtSITg4exqHiHxolDI/cU5S7tkifmRyY5/eIOSWocsNte4UdTl89hV1KsATTB1niQyc9f+fQzdy/QyrPrJbQIVooDsigoikbfQQd8A94IMquWa5DbD9jxvJNYg/0SWciV3anWHloyYy410rNSNNJzKQ03CC059fTjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739293143; c=relaxed/simple;
	bh=JQA1ZjBbMig6m4l8yPGiWj4x8bKWBoAZdxf1nTQk12A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YgceQ2YP69ItXC/sCoMCqgcVmY5rnTgOurLIGaJsvWPcSESHxnZNHXqCN6QxpSqNhevI1X/EZSylJB4jEYGuYXUjpG7Z2V9VdiVrchqxlfPjrz1Fhr797KseQepYWTSVwqMjuDmVqcIVsMMxLsuDkA21D6ZMvFPeNjIHmoDXjpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEj8xtK8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17ACC4CEE5;
	Tue, 11 Feb 2025 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739293142;
	bh=JQA1ZjBbMig6m4l8yPGiWj4x8bKWBoAZdxf1nTQk12A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NEj8xtK8TNeiRfoxOGkHey0B2xnQJB/yJbXx+Fsls8qcXVVCVfFaxEbP2HxkyBOFa
	 tocIPNS+f9Li1qZw+bwQpBzTl7MEpIxLu1zgBsXX79NcNBCDA8p3dh4RJoZsqlxMEf
	 YY0pZYWe62VLZSUaPkRgbU2G2KezAGvImDQ9CjKbeskF1zh8ctvQvYN2lGpWgMaf6q
	 a2mcXgNzZRO4tZDbhf8UmZJ5zY+xugzxAdTtNixh7XPzK5x+GcAacFgqobvJaJpkkX
	 Fr1vleom9aOZZkGDZo38zVujBpE/9McPfWhRVjYw6sRrNL0R+FjGV0041AGeYhX2cU
	 zRcYdXuBfDAxg==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit
 reason correctly
In-Reply-To: <20250211114756.GC8965@willie-the-truck>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
 <20250211114756.GC8965@willie-the-truck>
Date: Tue, 11 Feb 2025 22:28:57 +0530
Message-ID: <yq5ar044wh7y.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Will Deacon <will@kernel.org> writes:

> On Tue, Feb 11, 2025 at 01:08:51PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> The return value for the KVM_RUN ioctl is confusing and has led to
>> errors in different kernel exit handlers. A return value of 0 indicates
>> a return to the VMM, whereas a return value of 1 indicates resuming
>> execution in the guest. Some handlers mistakenly return 0 to force a
>> return to the guest.
>
> Oops. Did any of those broken handlers reach mainline?
>

Not that I noticed. We do have patches in review.

https://lore.kernel.org/all/20241212155610.76522-18-steven.price@arm.com


>> This worked in kvmtool because the exit_reason defaulted to
>> 0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
>> reason. However, forcing a KVM panic on an unknown exit reason would
>> help catch these bugs early.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  kvm-cpu.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/kvm-cpu.c b/kvm-cpu.c
>> index f66dcd07220c..66e30ba54e26 100644
>> --- a/kvm-cpu.c
>> +++ b/kvm-cpu.c
>> @@ -170,6 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>>  
>>  		switch (cpu->kvm_run->exit_reason) {
>>  		case KVM_EXIT_UNKNOWN:
>> +			goto panic_kvm;
>>  			break;
>
> The break is no longer needed.
>

ok.

-aneesh

