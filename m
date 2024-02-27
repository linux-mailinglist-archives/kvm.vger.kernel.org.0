Return-Path: <kvm+bounces-10015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A928686DA
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 03:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9760228F4BA
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 02:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260F02E622;
	Tue, 27 Feb 2024 02:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OqMZU+1i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF738387
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 02:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000502; cv=none; b=bGJ4a30MP367PocRobO8KlbrueUI7Dz0Rfd9fFiSGb8TolVGIwkTXLmSdcE/s5LQ/FSbYFtz9nYyqgkeLluN97KCdl6qr3TPXHTM+3i8fwGrm0ABub0ekNg2Fs6Lm9moc1scROmyiLMzxw0U2lIg8WHA+JoktOYusx4bpcaLRRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000502; c=relaxed/simple;
	bh=AJavhWKrBehCz7d+YW7b+29aWJ1wgMQjIIWm/3TmNUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ei76+mVxLyLrF5fAypSpBhJp1QpffGoNV8Aw/+5Zt3z9wOtLu1m6+LgDW3VYU98SgNCyulKanW0d2HQwyklQAnx7hxf4Vjm/FzqHUUqayqfxOdl2jVCYsF4/izA9BiDkAlVADQwOgkDR8WSTv8yPmrQ3aMVoH+guhL2C9v0Aawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OqMZU+1i; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b267bf11so4228462276.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 18:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709000500; x=1709605300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ghn/tsXt4bBeTaeh+x2q+YtPRUVSTzvBJxsTub2q9Gk=;
        b=OqMZU+1iOHJMr7DJDWExKqie+yZ6TrUgQmJssAgYPh5qJDb+KAqMT5sFjVZQH7DKnF
         tLHNh4EJg5ykW/AqIf7IHbCdt8GzhgIGExYAciRjm5ViB9aT2PeWeIqi8eU/LqYQr4Ql
         cXpVpmF0kaiEmrqBIror8Bt2ChMUrbTA+adZwKKpg5dcf8b9b+yLrkuDj8NkulhI0WqE
         KiXNWFQ3+UaKF4dlpxr8uU5qWHb0bqXOwHL5xM9ekS91xUMCAre06OPahY2twyiV4uih
         74rQFZF6NUC/cwX2P5SswnJ47gz+AW5HPxtuN/v6mFD9MkXlPx9jfaijSKsBCA6yAx9f
         r6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709000500; x=1709605300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ghn/tsXt4bBeTaeh+x2q+YtPRUVSTzvBJxsTub2q9Gk=;
        b=kaBUAapFHBpv7RjiYge+Zka0wMrr3ce4mwzp9WD34M8wvefuZpD8/NzjhlYGCrKFl7
         9kwfb13KCdtAhNypE7gN10oD1RCDPCYEr97C+XR2LnKn2OjIm9s0iTlbSHYkVOvwqFPi
         EFBcQh10+LSZ7y3W1jZc9xhc1IL9gDjf/Bh1VoqLRbrpqGviofmIWqpIOP/3WOpsHNH3
         rehr5bSvvHzyhAplq2qrgmNwDCvpbiquB9SVbHH1U2PA0JcDgGwqisBhYHKcrBtJbep4
         1yum9v8c4VH9gqWmvB0TuR3wLCS1DsHK8e9F0TsFrU/dwyh90X6ckaxszd8HSDD/jR5k
         dfmQ==
X-Gm-Message-State: AOJu0YyIiGoLL9OHn5nydA6+WxlF15QciQKI3gIFucIvxEViAswZv363
	kU3kjoFb3ke/9D0b/AQSPbwB1HnxaYE2QXIA+Ku5pxUILJst+wHMc8Cl4vCuY1ZE1jYIal/4Fki
	S0w==
X-Google-Smtp-Source: AGHT+IFOi9/tmN8AF5ckfIwhjyqA6w0EovzljiE14qM4BRVcycQBgccSndGNhkATEmtZADwvG8qyMKYgWso=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a89:b0:dcd:2f3e:4d18 with SMTP id
 cd9-20020a0569020a8900b00dcd2f3e4d18mr49885ybb.12.1709000499927; Mon, 26 Feb
 2024 18:21:39 -0800 (PST)
Date: Mon, 26 Feb 2024 18:21:10 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170900037528.3692126.18029642068469384283.b4-ty@google.com>
Subject: Re: [PATCH v9 00/11] KVM: selftests: Add SEV and SEV-ES smoke tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 Feb 2024 16:42:47 -0800, Sean Christopherson wrote:
> Add basic SEV and SEV-ES smoke tests.  Unlike the intra-host migration tests,
> this one actually runs a small chunk of code in the guest.
> 
> Unless anyone strongly objects to the quick and dirty approach I've taken for
> SEV-ES, I'll get all of this queued for 6.9 soon-ish.
> 
> As for _why_ I added the quick-and-dirty SEV-ES testcase, I have a series to
> cleanup __svm_sev_es_vcpu_run(), and found out that apparently I have a version
> of OVMF that doesn't quite have to the right <something> for SEV-ES, and so I
> could even get a "real" VM to reach KVM_RUN.  I assumed (correctly, yay!) that
> hacking together a selftest would be faster than figuring out what firmware
> magic I am missing.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[01/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
        https://github.com/kvm-x86/linux/commit/309d1ad7b6ff
[02/11] KVM: selftests: Make sparsebit structs const where appropriate
        https://github.com/kvm-x86/linux/commit/6077c3ce4021
[03/11] KVM: selftests: Add a macro to iterate over a sparsebit range
        https://github.com/kvm-x86/linux/commit/8811565ff68e
[04/11] KVM: selftests: Add support for allocating/managing protected guest memory
        https://github.com/kvm-x86/linux/commit/29e749e8faff
[05/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
        https://github.com/kvm-x86/linux/commit/1e3af7cf984a
[06/11] KVM: selftests: Explicitly ucall pool from shared memory
        https://github.com/kvm-x86/linux/commit/5ef7196273b6
[07/11] KVM: selftests: Allow tagging protected memory in guest page tables
        https://github.com/kvm-x86/linux/commit/a8446cd81de8
[08/11] KVM: selftests: Add library for creating and interacting with SEV guests
        https://github.com/kvm-x86/linux/commit/f3ff1e9b2f9c
[09/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
        https://github.com/kvm-x86/linux/commit/0837ddb51f9b
[10/11] KVM: selftests: Add a basic SEV smoke test
        https://github.com/kvm-x86/linux/commit/5101f1e27683
[11/11] KVM: selftests: Add a basic SEV-ES smoke test
        https://github.com/kvm-x86/linux/commit/f3750b0c7f6e

--
https://github.com/kvm-x86/linux/tree/next

