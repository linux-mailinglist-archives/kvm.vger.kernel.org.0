Return-Path: <kvm+bounces-37895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 227F4A31219
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5B3D165A89
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B160F261375;
	Tue, 11 Feb 2025 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b13OwOVp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34F4260A38
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739292716; cv=none; b=M0/OlZkcsiEl0nvuW85jaUGHXyjAC9lbQ/5Q9YVbSDt7sEVXwKgvDl1LDAJ5GLKquptKXtc9QMS0y8UW1CADCif4EKzyXf6onfyyEYOrQ7e6m22RtecyvgaloCeMlX9t62bd0okwkIZFSzSxqa8aLtCYJ4lz3ffVN5jcLJnhcGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739292716; c=relaxed/simple;
	bh=p1jIrdNaAKbwrkYO+BN2AFWGdahN5RdtA54pCJsjDGo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gtDumhP4spR2MF1CDsk/r2Nt+5Z9o7PxUnuGNoR8PcvcBqG2IOzJIGkvNKSDSzP8kg+UYoGYoJsLErBN1Aa46C2Dr6SFD5b/zIXBI2RkjK+hQpFjonDPZCBlhA/rr1yj4oXwpunaE69Yi1SC427uxORY5d6rwcSk+KBYUl8pCH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b13OwOVp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DAAC4CEDD;
	Tue, 11 Feb 2025 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739292716;
	bh=p1jIrdNaAKbwrkYO+BN2AFWGdahN5RdtA54pCJsjDGo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=b13OwOVp5nOD3OK0Q5AH/6oYh9n5TGBJeYW1vToG7C54wvgnRQtmMSF1ILMszGUcQ
	 yAMNTYKMYUQ42YZdYhltbM7F1ObvBu4xVuCQmuoHk/6ZPQSwVyuoPrtEUJFyE624it
	 9TdOUhrBZgFLEKT8i3/jTlGytSrtS82LQ9H49NyxRpekvZvMrDYT5GTPZ9kblDLvP+
	 oCZf7a/xbOdbNQiloUQ3CTqC1iIjEZHlACUi1H5edZxONxeSftIua1xezdye2SJEmH
	 saPNpob6rE4dB9Uy3PkbhHFcl1cWaKqBg0rYcWy48Irkt2LBndQ+/BKPxAUUdkxbiN
	 FuZTRon0jVNAg==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT
 correctly
In-Reply-To: <Z6s+67ICINiO96US@arm.com>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
 <20250211073852.571625-2-aneesh.kumar@kernel.org>
 <Z6s+67ICINiO96US@arm.com>
Date: Tue, 11 Feb 2025 22:21:50 +0530
Message-ID: <yq5awmdwwhjt.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Hi,
>
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
>
> I've tried to follow how kvmtool handles KVM_EXIT_MEMORY_FAULT before and after
> this patch.
>
> Before: calls die_perror().
> After: prints more information about the error, in kvm_cpu_thread().
>
> Is that what you want? Because "correctly handle KVM_EXIT_MEMORY_FAULT" can be
> interpreted as kvmtool resolving the memory fault, which is something that
> kvmtool does not do.
>

That is correct. The changes to enable the handling of
KVM_EXIT_MEMORY_FAULT is not yet part of upstream [1]. But then the
return value for KVM_RUN ioctl() is defined as part of
Documentation/virt/kvm/api.rst in the Linux kernel.

[1] https://gitlab.arm.com/linux-arm/kvmtool-cca/-/blob/cca/v4/arm/kvm-cpu.c?ref_type=heads#L247

>
> Also, can you update kvm_exit_reasons with KVM_EXIT_MEMORY_FAULT, because
> otherwise kvm_cpu_thread() will segfault when it tries to access
> kvm_exit_reasons[KVM_EXIT_MEMORY_FAULT].
>

Will update.

-aneesh

