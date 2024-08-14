Return-Path: <kvm+bounces-24113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B2595160A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C84211F21CE5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FF313D635;
	Wed, 14 Aug 2024 08:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZkB4oc5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017C213D52F;
	Wed, 14 Aug 2024 08:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622582; cv=none; b=dRazm/KlbLYA+8pp5JCDJz+jbEtAig/0ptXkXgfXK+k53BVQFxTH43IDxRzEmFdLW949KkxTvXBkavxtOdjrFLrfVYHqQhictm9r+PWp9zuKlBsQ20Wxtq3U/NH8MpQ+ofmR+bb8Vikfe9GtzP1DHK5sZRQxBPmv4n9iiesvuz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622582; c=relaxed/simple;
	bh=25E5kitv9sYS9/weg7WZ4WQn27ejAhVnqXHuS1uqRT8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nXTDrGhHfSuO1xsY8uVn59AmcJEom4iFG137b5+fw98QcNtMTbpRIYVYV5VElwD6Bgj6dPbMNSR29zNdmpu+6fn2+gqcMTqA46nFXM3SZUZWETTTkv2Om1M5KqvSHBJ87aKiYzL1c5OnNgaBz3ZyK5SQUC1Fj6qSKze8Zu5lduM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZkB4oc5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27964C32786;
	Wed, 14 Aug 2024 08:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723622581;
	bh=25E5kitv9sYS9/weg7WZ4WQn27ejAhVnqXHuS1uqRT8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CZkB4oc5ssGZ9IQxWELOoQaYqg69SjAzMl2N/jT9EIE7zPDoMjtBJTKuqfH3VX7B6
	 EaSd5Is6FNoqCCdOf7rGhrRPGyXnxPpmtvvnEvlyhiWakcrbZSP9KwVvi/723AnLIU
	 qiOqAnP+5h4vwxiztd+FTO80T/DbriW9DJd0BFrzm5PJqLuDJbgPEndAZK7uiavEC/
	 A0i+eebEDQtYXI6ApyR3iY6ynRw4fv7E96bWY09btPuVTuVsXznB7x2jeDhFLoBxl7
	 Ei/SXt1Jxv+rMlBQosdMnTk+SA0ekSCpa6M0ft9Xvn8KHMDGy6XKDe+N/4eHthtadX
	 m0qeff23PomSA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com,
	rananta@google.com
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
In-Reply-To: <ZrtskXJ6jH90pqB2@google.com>
References: <20240809205158.1340255-1-amoorthy@google.com>
 <20240809205158.1340255-4-amoorthy@google.com>
 <yq5aikw6ji14.fsf@kernel.org> <ZrtskXJ6jH90pqB2@google.com>
Date: Wed, 14 Aug 2024 13:32:50 +0530
Message-ID: <yq5ajzgjy1jp.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Aug 12, 2024, Aneesh Kumar K.V wrote:
>> Anish Moorthy <amoorthy@google.com> writes:
>>
>> > Right now userspace just gets a bare EFAULT when the stage-2 fault
>> > handler fails to fault in the relevant page. Set up a
>> > KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
>> > eases debugging and might also let userspace decide on/take some
>> > specific action other than crashing the VM.
>> >
>> > In some cases, user_mem_abort() EFAULTs before the size of the fault is
>> > calculated: return 0 in these cases to indicate that the fault is of
>> > unknown size.
>> >
>>
>> VMMs are now converting private memory to shared or vice-versa on vcpu
>> exit due to memory fault. This change will require VMM track each page's
>> private/shared state so that they can now handle an exit fault on a
>> shared memory where the fault happened due to reasons other than
>> conversion.
>
> I don't see how filling kvm_run.memory_fault in more locations changes anything.
> The userspace exits are inherently racy, e.g. userspace may have already converted
> the page to the appropriate state, thus making KVM's exit spurious.  So either
> the VMM already tracks state, or the VMM blindly converts to shared/private.
>

I might be missing some details here. The change is adding exit_reason =
KVM_EXIT_MEMORY_FAULT to code path which would earlier result in VMM
panics?

For ex:

@@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
	if (unlikely(!vma)) {
		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
		mmap_read_unlock(current->mm);
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
+					      write_fault, exec_fault, false);
		return -EFAULT;
	}


VMMs handle this with code as below

static bool handle_memoryfault(struct kvm_cpu *vcpu)
{
....
        return true;
}

bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
{
	switch (vcpu->kvm_run->exit_reason) {
        ...
	case KVM_EXIT_MEMORY_FAULT:
		return handle_memoryfault(vcpu);
	}

	return false;
}

and the caller did

		ret = kvm_cpu__handle_exit(cpu);
		if (!ret)
			goto panic_kvm;
		break;


This change will break those VMMs isn't? ie, we will not panic after
this change?

-aneesh

