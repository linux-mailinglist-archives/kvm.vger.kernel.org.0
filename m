Return-Path: <kvm+bounces-44655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9013CAA00A9
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10F8B1B630FD
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9EE270ED6;
	Tue, 29 Apr 2025 03:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNH2/yEu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE56270EA7
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 03:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897870; cv=none; b=HsTMkDfp35djJcl5ydB2U7vmcSEvzqK5O8D27IryntFw0C3FyjiZwmWXL+mun2X7mvDSfXMJAHXbIrMUP5dr6DRzsczS8/sMqL81KkMyK5H6P0/IM/zIqKIksDKuKBaAHHF1o2iJ5ydIYJ1UQ6iH8JTtnYvCJ3DezG3aTk/jeic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897870; c=relaxed/simple;
	bh=o0Bsyt7FrbTQfBgId6i0wm7Wph0D2g6CxMizX1LW4V0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ktsbTJhFXmH9Y12gMUw86zOyWnwQ3IJU8OYK4gRgy3ZnRw1JlFfRWGnmxbPuX7QSnUehwuDWvGcccagEteEO5OYsZqtYEO9XrnbRMKbUtcF6swA7OFpkxpLnuuhsZJQS4kG1IUtTskmLq7UijmUbuVeUZZK98ADbehuQE3z+Gr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNH2/yEu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654ECC4CEEB;
	Tue, 29 Apr 2025 03:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745897869;
	bh=o0Bsyt7FrbTQfBgId6i0wm7Wph0D2g6CxMizX1LW4V0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FNH2/yEuwhUksTGtHTEl8lZBWxi0kKElKEoJtS5lNF1XiM6YXm6+bpvm4g6ETLRdm
	 9vOAnmKfZBPjZcJnZV41JT780Buu2/o7GBGlUMnH+YQDCAFKglEYzjSY41Cxc00tuD
	 HmHKM2ZMNW955iKH3OP48RN2MjUFu4a4eJJjhD8Q8tkIvkfKn5CGA+O5yG8yj5SOK8
	 B19AQVNwin+EX9HYW0V4IyyBAD9qPbY/aEmEn3uk/QsEeip84+n53o9ufuXagqPs7G
	 9DRBd2aV9tluav4CpRyV0iCnUze2RV15umtqm11JacPfSNc+vdWpocX7Ar5MHTW0ts
	 2EVz4F1LJYTEg==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 Q)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v3 2/3] cpu: vmexit: Retry KVM_RUN ioctl on
 EINTR and EAGAIN
In-Reply-To: <aA+dIAof4faNGjCf@arm.com>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
 <20250428115745.70832-3-aneesh.kumar@kernel.org>
 <aA+dIAof4faNGjCf@arm.com>
Date: Tue, 29 Apr 2025 09:07:02 +0530
Message-ID: <yq5abjsfvdsx.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Hi Aneesh,
>
> Is this to fix Will's report that the series breaks boot on x86?
>

Yes.

> On Mon, Apr 28, 2025 at 05:27:44PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> When KVM_RUN fails with EINTR or EAGAIN, we should retry the ioctl
>> without checking kvm_run->exit_reason. These errors don't indicate a
>> valid VM exit, hence exit_reason may contain stale or undefined values.
>
> EAGAIN is not documented in Documentation/virt/kvm/api.rst. So I'm going to
> assume it's this code path that is causing the -EAGAIN return value [1].
>

IIUC, EAGAIN and EINTR are syscall return errno that indicates a system
call need to be retried. Documentation/virt/kvm/api.rst do mention that
exit_reason is value only with return value 0.

	__u32 exit_reason;

When KVM_RUN has returned successfully (return value 0), this informs
application code why KVM_RUN has returned.

>
> If that's the case, how does retrying KVM_RUN solve the issue? Just trying to
> get to the bottom of it, because there's not much detail in the docs.
>
> [1] https://elixir.bootlin.com/linux/v6.15-rc3/source/arch/x86/kvm/x86.c#L11532
>
>

So in that code path vcpu will be in kvm_vcpu_block(vcpu) waiting for
the IPI. On IPI kvm_apic_accept_events() will return 0 after setting the
vcpu->arch.mp_state. Hence a KVM_RUN ioctl again will find the mp_state
correctly updated. 

-aneesh

