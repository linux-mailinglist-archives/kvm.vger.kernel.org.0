Return-Path: <kvm+bounces-31241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D66EF9C18BD
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F03D1F255E2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6AB1E0DD6;
	Fri,  8 Nov 2024 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dyTmE3Ni"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5690028EB
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056728; cv=none; b=Icddx30bXNevSWTKcFx6NpxK17SxbeGk1Bu7Ljw1s6GeBVAKKN5u1/EzBq+EtD64i+FnNwhNvnlbY6OU1u6ja6PsUTQlm2gus9fK/1uOgu+kR62M6zlarisLXL3QCW+/2+Aqgvh3bKL5dd3WTtb7bZizR5nqVqhzD1jrpalJKGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056728; c=relaxed/simple;
	bh=/9i+bLZW6te/f0iYhWbjrbhg4l3hVSSUfE4orLqvC38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QgRe8viqxHDeO1i5dB1qO774wE+Pykag1yJ57LXymOI47TYgW6RotdAi18lHJhPfes5UggQKPHXZE9WQLinoDFCESWh2w+ta4BXt5VeGa8yQbAu+WFYmOo7QgnFTdM0oxKFFiKXxGYcxlLNIm4w7lU6UvgqaHLtKeW3ivRkWiQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dyTmE3Ni; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LrElxwqnJR5DH5QdMVYz2iwh68nuYwJL/C3mT8YyNoM=;
	b=dyTmE3NiWWWdTF6966940Og/Lqo2a5eG4Q6hKWqPmOA2XSZ10isjs3A1OgmTlJ1vefr402
	vFcrFkRabKTp9AvmIomdhP84i7vXUY2YWm2W1lyJAkQgbTqFbA0/kO7QVy1mnCX4KSDwkL
	R79a/H3A9nLaVDJEBX+UWomeGN9C0r8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-SK9EzM0qP5GT2Abd4VSHoQ-1; Fri, 08 Nov 2024 04:05:23 -0500
X-MC-Unique: SK9EzM0qP5GT2Abd4VSHoQ-1
X-Mimecast-MFC-AGG-ID: SK9EzM0qP5GT2Abd4VSHoQ
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d589138a9so996378f8f.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 01:05:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056722; x=1731661522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrElxwqnJR5DH5QdMVYz2iwh68nuYwJL/C3mT8YyNoM=;
        b=HPcamCNHkldfZQSzMJd73st+ApgvJzi17Y2ZWlRHzeqgeG0Dt2/fjtUM+YKVNmJVg5
         yRpFM3EVdYw1aPZ+XuHEv0dPxg2XyECDHgEikumTiBS6NnB6jZau5RcNjHyYfhGFkcAl
         MjALyE0Y2goFt4jD6HdnI5c7YtadYD/tSjZGhUhnZtqeuBUZek084+hDvmMzLjUn970N
         TloypVNIKWH7WlR3EHNMoHvzLp5VB6skZaHq5jXjRXqmjdiA3aVQ8xsaiSMMcQ50TdNF
         dxfPWlGZoVe1isy5xVJmjQC/pqdNklUdIwWBaRCsaU7yOcWdVexeGSVv5K44PefWU+5u
         LfMA==
X-Gm-Message-State: AOJu0YyG/NRKvZshmpUt/Hj61BwycYQrJwYtbjxGN1fz0yWwKR73nB32
	fQFSRwsadmVCIo6n6amLU9Kg5J5wk7FNgec3Y3MKraZ8SSl04JmSXs1eImz+dHcqLbJqzDdxUeA
	1d4bK7j4q3bZloesHeXDaz8ocsF0prDQDX5KVb7GifYgppLCibDj74LOylt7tHb+NmA3sLk8sim
	bPbJIS2fJAIn1K0jPv73FKHwA7
X-Received: by 2002:a05:6000:480b:b0:37d:45f0:dd08 with SMTP id ffacd0b85a97d-381f186731amr1816415f8f.11.1731056722535;
        Fri, 08 Nov 2024 01:05:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAUqJcQr+bA/27fCCgGUP2nub60cseB08K8/4GgQUbkE5m0tGGw43rxa/0FGBd1Ft3SGpNzTEYfwcvTxp7t40=
X-Received: by 2002:a05:6000:480b:b0:37d:45f0:dd08 with SMTP id
 ffacd0b85a97d-381f186731amr1816400f8f.11.1731056722162; Fri, 08 Nov 2024
 01:05:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106160425.2622481-1-seanjc@google.com>
In-Reply-To: <20241106160425.2622481-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Nov 2024 10:05:10 +0100
Message-ID: <CABgObfb5E2WTt50eCx8R6TWD+o+CnOhx3zHGmeB9Xd3EA+sgUw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 and selftests fixes for 6.12-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 5:12=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please pull several fixes for 6.12, and to save us both effort, please al=
so
> apply several fixes that should probably go into 6.12 (the selftest fix
> definitely needs to land in 6.12).
>
>   https://lore.kernel.org/all/20241106034031.503291-1-jsperbeck@google.co=
m
>   https://lore.kernel.org/all/20241105010558.1266699-2-dionnaglaze@google=
.com
>   https://lore.kernel.org/all/20241106015135.2462147-1-seanjc@google.com

Done.

> And while I have your attention, I'd also like your input on a proposed "=
fix"
> for Intel PT virtualization, which is probably belongs in 6.12 too, if yo=
u
> agree with the direction.
>
>   https://lore.kernel.org/all/20241101185031.1799556-2-seanjc@google.com

Yep, pulled it as well.

Paolo

> Note, this is based on v6.12-rc5 in order to pull in the necessary base f=
or
> the -march=3Dx86-64-v2 fix.
>
> The following changes since commit 81983758430957d9a5cb3333fe324fd70cf63e=
7e:
>
>   Linux 6.12-rc5 (2024-10-27 12:52:02 -1000)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.12-rcN
>
> for you to fetch changes up to e5d253c60e9627a22940e00a05a6115d722f07ed:
>
>   KVM: SVM: Propagate error from snp_guest_req_init() to userspace (2024-=
11-04 22:03:04 -0800)
>
> ----------------------------------------------------------------
> KVM x86 and selftests fixes for 6.12:
>
>  - Increase the timeout for the memslot performance selftest to avoid fal=
se
>    failures on arm64 and nested x86 platforms.
>
>  - Fix a goof in the guest_memfd selftest where a for-loop initialized a
>    bit mask to zero instead of BIT(0).
>
>  - Disable strict aliasing when building KVM selftests to prevent the
>    compiler from treating things like "u64 *" to "uint64_t *" cases as
>    undefined behavior, which can lead to nasty, hard to debug failures.
>
>  - Force -march=3Dx86-64-v2 for KVM x86 selftests if and only if the uarc=
h
>    is supported by the compiler.
>
>  - When emulating a guest TLB flush for a nested guest, flush vpid01, not
>    vpid02, if L2 is active but VPID is disabled in vmcs12, i.e. if L2 and
>    L1 are sharing VPID '0' (from L1's perspective).
>
>  - Fix a bug in the SNP initialization flow where KVM would return '0' to
>    userspace instead of -errno on failure.
>
> ----------------------------------------------------------------
> Maxim Levitsky (1):
>       KVM: selftests: memslot_perf_test: increase guest sync timeout
>
> Patrick Roy (1):
>       KVM: selftests: fix unintentional noop test in guest_memfd_test.c
>
> Sean Christopherson (4):
>       KVM: selftests: Disable strict aliasing
>       KVM: selftests: Don't force -march=3Dx86-64-v2 if it's unsupported
>       KVM: nVMX: Treat vpid01 as current if L2 is active, but with VPID d=
isabled
>       KVM: SVM: Propagate error from snp_guest_req_init() to userspace
>
>  arch/x86/kvm/svm/sev.c                          |  7 ++++--
>  arch/x86/kvm/vmx/nested.c                       | 30 +++++++++++++++++++=
+-----
>  arch/x86/kvm/vmx/vmx.c                          |  2 +-
>  tools/testing/selftests/kvm/Makefile            | 10 +++++----
>  tools/testing/selftests/kvm/guest_memfd_test.c  |  2 +-
>  tools/testing/selftests/kvm/memslot_perf_test.c |  2 +-
>  6 files changed, 39 insertions(+), 14 deletions(-)
>


