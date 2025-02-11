Return-Path: <kvm+bounces-37836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6641A308DD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:41:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B0DA165606
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 10:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1918E1FA856;
	Tue, 11 Feb 2025 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ErD4E/RU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FDC1F942D
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 10:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739270448; cv=none; b=JsVqW29yhKYg4NCjgjRKCwvUbOebwHfcEV6dALvGDDR+4BQXNSb32yqgmhDvbq3hBN0YOtcvIUpxANC8qQKZDxoYIp7huhpmJluIyQH+mDK7UO3Zanaqn3R6xZHfTG+49hrOOXwYRWJ/MKM/8LSODkDMCzgM+tSq995OG782atw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739270448; c=relaxed/simple;
	bh=btgsMkB+KatSBhW2xvQ/HbfeImWKcXqMZC5wzTOtkqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QteYQI7H1ZNK8a0m/og106FvKmzqmUVa+f7u3hMh5nafwNP/bvEz665aXEr0wGyVS/+5P7zumpPbld0jJbiRJvhGChf0h0HVmnx0hYMnk/AglOSBZc4UzYQfxUOAhG1mkwoa3DP6tnZ7XESlR5PYJxaYsGPq/sIsUYqZibnRWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ErD4E/RU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739270445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btgsMkB+KatSBhW2xvQ/HbfeImWKcXqMZC5wzTOtkqg=;
	b=ErD4E/RU1arsLGEYQdfZ5+w7z/KhLH5ynMEcM7nlnSg49gRVbMJ5bVJLxhKKzUhWjPdQ31
	qA4+ym/KEkSn2Upjl9Jg0XI//z6gsZ9F15PM5BEPR3eRih1QPpKa53z1/4P7S7QFtqcCdo
	JnUDqPkyb5rr3n4YS7qtP7byxiDV1z0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-6vxxCcr9P-uNijcdmrsbnw-1; Tue, 11 Feb 2025 05:40:44 -0500
X-MC-Unique: 6vxxCcr9P-uNijcdmrsbnw-1
X-Mimecast-MFC-AGG-ID: 6vxxCcr9P-uNijcdmrsbnw_1739270443
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-438e4e9a53fso39964965e9.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 02:40:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739270443; x=1739875243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btgsMkB+KatSBhW2xvQ/HbfeImWKcXqMZC5wzTOtkqg=;
        b=T3lcCUv0YmVrf5d0/n7Qgwc3y7hiHPtPkgLhseabUB94FWBmAKvFgc7IE9g8KPVW6K
         srC0dp9l4P47nAAt+rz+tPT5YpTYkqkW8hyhgKjKfw5cr8zGW8ahHZcDBRF7iMvihFzB
         khUyYIj8KYYvoA8qRmAgQJgudq9wXff0UucEJfL47I9c/ehOWKtyNHj/JaJpa3A1nZlc
         76gMbE2B/pjVTS1kR6qbeZwrquph8dpPVqrgbcmPHO0H0eOZrUdDQl3yJJCh0eO2Xc56
         Euw5RGEVfiQU++o5bZVmrafCvSrR7TyGtd2CS1TehnnhteJsXYGym4l5X/RHgOvBYl+v
         5+sQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7yXr7uiUT5lWueFXKlWSOZ5qQLZzmiGSqgbnHH2vqgUpIphRAMwLQTx945ySkEGLGkNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgh7jP7BFmpJ2WTcQNZPG4uPx0Xv0bpGYdS1nN9KmK5vXwlQgN
	yb6clYUmHcTnEsyaoTefsd7G653kiQoShkkQUyFWFrt4sIe2Y1pJn0G6cXvI729EJsUE38BE96U
	r3mQeT9XSCvol1fGDNRP6nILufxlZYviYOcM2gx01/8kQ/azQhl0a1RNP70T8GiIo7fNApJJ9lU
	sx4Imft+H6hksm/S1fHUzBFFb4
X-Gm-Gg: ASbGncvLMK2Vx5KqHtJOs9Sf8L6PawXcUAAILs5k5Ez5JgCKj8L5cAI/vO+LlJO2GNK
	m5e663M78oEs/+mKWcWPBcNO7SW0oIzwDJWVSpH3Nn30UT4G6JgH2Hzhvq6bW
X-Received: by 2002:a05:600c:c07:b0:439:4832:325f with SMTP id 5b1f17b1804b1-43948323427mr44529335e9.1.1739270442749;
        Tue, 11 Feb 2025 02:40:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbumiPynQJLdfXR/hK61jc+qEpAs+mRfIkPjt8BvK5dw/XkyvYRl2OENNVY4nN2HiUviGg5p2QXMZIr5RQ2vU=
X-Received: by 2002:a05:600c:c07:b0:439:4832:325f with SMTP id
 5b1f17b1804b1-43948323427mr44528985e9.1.1739270442437; Tue, 11 Feb 2025
 02:40:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211000917.166856-1-mlevitsk@redhat.com> <20250211000917.166856-3-mlevitsk@redhat.com>
 <87seok25qx.wl-maz@kernel.org>
In-Reply-To: <87seok25qx.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 11 Feb 2025 11:40:29 +0100
X-Gm-Features: AWEUYZnT1g0RdyJqMZtSUMcVn2SB8z3GSQjhvL_omNqa0pSFmSAU_EQ9poyWn3Q
Message-ID: <CABgObfa6DGM4X5HKb6FHoeiitTp4ddVaUGLRqK+Z=a-JLc9Bzw@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: switch to using kvm_lock/unlock_all_vcpus
To: Marc Zyngier <maz@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Jing Zhang <jingzhangos@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Randy Dunlap <rdunlap@infradead.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	Ingo Molnar <mingo@redhat.com>, linux-riscv@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev, 
	Alexander Potapenko <glider@google.com>, x86@kernel.org, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Kunkun Jiang <jiangkunkun@huawei.com>, 
	Atish Patra <atishp@atishpatra.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 10:25=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
> > No functional change intended.
>
> Actually plenty of it.

Yes, definitely. That's not "no functional change intended", it's "no
breakage of sane userspace intended" which is pretty much the
opposite.

> Yet the new helper returns -EINTR, which you blindly forward to userspace=
.

It won't quite reach userspace, since the task won't survive
mutex_lock_killable(). With your current code the kill will arrive
just after the ioctl returns to userspace, so there's no change in
behavior there. The -EBUSY change is the one that matters.

> At the end of the day, the x86 locking serves completely different
> purposes. It wants to gracefully wait for vcpus to exit and is happy
> to replay things, because migration (which is what x86 seems to be
> using this for) is a stupidly long process.

No, it's not using it for the whole length of migration. It serves the
same exact purpose as ARM: do some stuff on something that spans a
whole struct kvm. The only difference is the behavior on contended
mutex, where x86 simply says don't do it.

> Our locking is designed to
> either succeed or fail quickly, because some of the lock paths are on
> the critical path for VM startup and configuration.

The only long-running vCPU ioctl is KVM_RUN and you don't have that
during VM startup and configuration. The interesting case is
snapshotting, i.e. reading attributes.

Failing quickly when reading attributes makes sense, and I'd be
rightly wary of changing it. I know that QEMU is doing them only when
it knows CPUs are stopped, but it does seem to affect crosvm and
Firecracker more, for snapshotting more than startup/configuration.
The GIC snapshotting code in crosvm returns an anyhow::Result and ends
up logging an error with println!, Firecracker is similar as it also
propagates the error. So neither crosvm nor Firecracker have
particularly sophisticated error handling but they do seem to want to
fail their RPCs quickly.

Failing quickly when creating the device or setting attributes makes
less sense (Firecracker for one does an unwrap() there). But anyhow
the change would have to be a separate patch, certainly not one
applied through the generic KVM tree; and if you decide that you're
stuck with it, that would be more than understandable.

> So for this series to be acceptable, you'd have to provide the same
> semantics. It is probably doable with a bit of macro magic, at the
> expense of readability.

Or it can be just an extra bool argument, plus wrappers.

For RISC-V it's only used at device creation time, and the ioctl fails
if the vCPU ran at least once. Removing the "try" in trylock is
totally feasible there, however it must be documented in the commit
message.

Thanks,

Paolo

> What I would also like to see is for this primitive to be usable with
> scoped_cond_guard(), which would make the code much more readable.


