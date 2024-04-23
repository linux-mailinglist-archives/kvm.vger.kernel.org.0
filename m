Return-Path: <kvm+bounces-15668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DC68AE9A9
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A3E01C2348D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEAE86252;
	Tue, 23 Apr 2024 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nBqLQe3w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F0633993
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713883056; cv=none; b=OeBHmLD3ocsr4rhXbvWrqyvwkkkxGiR/JOP0JfWqPRwzAkf5EQctSBcb2Dv5Q7OMoZn2bm9UHGqDx5WaGSGvGbUTcC9saKDzeDLYpreL+fbn8WCQKqgy1JDw8r407IvPquH7TVI8UFn53uyaqWqUWU8cckXsXB4w5Vw3XciyARc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713883056; c=relaxed/simple;
	bh=TzVxxxnhXUpErncAvixlFLQfPBbMkc/vQy/pNhpvvAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S+hWISqQrhT4HDgUMlObuet402TYXeXZC171nb+VK2jv0h/85eN+UMdvMnLiBvFtS9EZ247zu1r34fjqA0tBN1WJHuQ6V31lvR5R4pBzjS2rBvhJdb+KVYmLd5NWvWjmmhSPnOF0gyZzkm6LNJeOAguw4+4dk88t1bfmUs+PyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nBqLQe3w; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed2a12e50aso4275092b3a.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 07:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713883054; x=1714487854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ef79AtPbDUqF3MZJcmRd4oE98+tnINkkuVDxoX/B5Ko=;
        b=nBqLQe3wuutcULTpo7+0srs2V6MyNbFZIqjwkIDqR2cqLy5qTB0Z/DmdUPP66W4ruN
         6GX6K9xHD3wo2dDXv4hoa2ZvU634TG68f3SUZBz/K1o/6/4VZIL7FoJFq2j8iArfbRY6
         QoMvbpR5lXRadXpWXv4PjA89E8oy6cQVjTCKW6FA0LkXxRsCu8dtrAXfPlyZZ7G5EttD
         XwR8OwnofFDXJ93XHPO7YRi7mbRTHzdzhWINflnWzXSXzyJaxj3pEmjGoImZdklfWGuA
         yeoEzJZDCfOAlR7Sxx9Hg8rjYWbl7IwKap+hnMRaf+uYFIUbGFsEGPHdjvcW//0u8za5
         Zzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713883054; x=1714487854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ef79AtPbDUqF3MZJcmRd4oE98+tnINkkuVDxoX/B5Ko=;
        b=nA4+S9GXVujRpOSixtm+sCmIIWeXcYM6rPEAFxd4xujzdK9/2K9o25d7qkP2+A8tUH
         cMvH5nWgFnoNuws/3D1RV++KrJQlV5NegywJl1ytgSOZ8bphwWZhNSM+nSfvfmuJUokl
         uPqFSQeV3HflPjbUJra6PB0COEbR3k6PLKUnLKQtRy0e0I0zGlP603gwtofeAkeK4GlN
         4soLmMzOCHhJyVGpWekK0ceFXDX31rY/RXsNkPCglOjqZ2Wts2HENhM+hHmZpvTc8S/R
         MqIuL+X6PvjcEN1OqPoFjPofJEgoIFklazv9ubTx2oMQifcvHFEeiwjfo0FuAGVCjVB/
         G3UA==
X-Forwarded-Encrypted: i=1; AJvYcCWxuFdWunsO0VEH/PYfH8H2ehUNODLzwmnpeST3OId9GgN4msvYjpZPEOX1UQm1vSVWpYxjnxeNS3GhqQUIh3+Comz5
X-Gm-Message-State: AOJu0YyKAj4MVSxFnLsU6ROAfkJbozMytTnIAeXli06XOZyt3XtP+Wge
	q+syEgrfP4BPyHLb/tdbD4z/t+pRtIK4Lq1mWZ5DysEpbnQEDwt0JXKW2OM8QqTEooimH3REAU5
	uQA==
X-Google-Smtp-Source: AGHT+IH4W/C9atd40MoHyfe0RJCn5ngnCJCFSa5lLyNmxi4QYZYc4F9wSJwQ/HoPbJ1+/FR3ExY8l/rfcSc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:92a1:b0:6ed:36e2:9d0c with SMTP id
 jw33-20020a056a0092a100b006ed36e29d0cmr42406pfb.0.1713883054061; Tue, 23 Apr
 2024 07:37:34 -0700 (PDT)
Date: Tue, 23 Apr 2024 07:37:32 -0700
In-Reply-To: <DS0PR11MB6373118F72C9013C96718660DC112@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240422130558.86965-1-wei.w.wang@intel.com> <Zia94vbLD-DF1GEw@google.com>
 <DS0PR11MB6373118F72C9013C96718660DC112@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZifHrET_AAlWxFYC@google.com>
Subject: Re: [PATCH v1] KVM: x86: Validate values set to guest's MSR_IA32_ARCH_CAPABILITIES
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 23, 2024, Wei W Wang wrote:
> On Tuesday, April 23, 2024 3:44 AM, Sean Christopherson wrote:
> > On Mon, Apr 22, 2024, Wei Wang wrote:
> > > If the bits set by userspace to the guest's MSR_IA32_ARCH_CAPABILITIES
> > > are not supported by KVM, fails the write. This safeguards against the
> > > launch of a guest with a feature set, enumerated via
> > > MSR_IA32_ARCH_CAPABILITIES, that surpasses the capabilities supported
> > > by KVM.
> > 
> > I'm not entirely certain KVM cares.  Similar to guest CPUID, advertising
> > features to the guest that are unbeknownst may actually make sense in some
> > scenarios, e.g.  if userspace learns of yet another "NO" bit that says a
> > CPU isn't vulnerable to some flaw.
> 
> I think it might be more appropriate for the guest to see the "NO" bit only when
> the host, such as the hardware (i.e., host_arch_capabilities), already supports it.
> Otherwise, the guest could be misled by a false "NO" bit. For instance, the guest
> might assume it's not vulnerable to a certain flaw as it sees the "NO" bit from the
> MSR, even though the enhancement feature isn't actually supported by the host,
> and thus bypass a workaround (to the vulnerability) it should have used. This could
> arise with a faulty or compromised userspace.
> Another scenario pertains to guest live migration: the source platform physically
> supports the "NO" bit, but the destination platform does not. If KVM fails the MSR
> write here, it could prevent such a live migration from proceeding.
> 
> So I think it might be prudent for KVM to perform this check. This is similar to the
> MSR_IA32_PERF_CAPABILITIES case that we have implemented.

PERF_CAPABILITIES is a bad example.  KVM ended up enforcing the incoming value
through a series of fixes, not because of a concious design choice.  Though to be
fair, we might still have decided to enforce the supported capabilities since KVM
heavily consumes PERF_CAPABILITIES.

> > ARCH_CAPABILITIES is read-only, i.e. KVM _can't_ shove it into hardware.  So
> > as long as KVM treats the value as "untrusted", like KVM does for guest CPUID,
> > I think the current behavior is actually ok.
> 
> Yes, the value coming from userspace could be considered "untrusted", but should
> KVM ensure to expose a trusted/reliable value to the guest?

No, the VMM is firmly in the guest's TCB.  We have general consensus that KVM
should enforce an architecturally consistent model[1] (there was a deeper PUCK
discussion on this, I think, but I can't find the notes offhand).  But even in
that case the reasoning isn't that userspace isn't trusted, it's that trying to
allow userspace to do MSR writes that architecturally should fail, while disallowing
the same writes from the guest is unnecessarily complex and not maintainable.
And, there is no use case for inconsistent setups that is remotely plausible.

ARCH_CAPABILITIES is different.  Like CPUID, KVM itself isn't negatively affected
by userspace enumerating unsupported bits.  And like CPUID[2], there are plausible
scenarios where enumerating unsupported bits would actually make sense, e.g. if
userspace is enumerating a FMS that is not the actual hardware FMS, and based on
FMS the guest may incorrectly think it needs to a mitigate a vulnerability that
isn't actually relevant.

All that said, I'm not completely opposed to enforcing ARCH_CAPABILITIES, but I
would prefer to do so if and only if there's an actual benefit/need to do so.

[1] https://lore.kernel.org/all/ZfDdS8rtVtyEr0UR@google.com
[2] https://lore.kernel.org/all/ZC4qF90l77m3X1Ir@google.com

