Return-Path: <kvm+bounces-55852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B30B37D68
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0E5C1BA34FF
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5EF335BBF;
	Wed, 27 Aug 2025 08:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1Lg8flF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8A8192B84
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 08:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756282727; cv=none; b=l1BPuiPkTZFW84ZG2K4tlM5vazFXaPjpr6EA/W/dNfkexNhglowzLPGzSY0r8O6+iDD+7MUvRF/UxEY2MDCT+HER0+g9fBc3qmPtRjHv+Yp+8zW4oJA1zH0l+7ID/g+vEmYiKTpYfkIhPSaNZ/eDGmuhMo6jb5ko1VkFBvGkK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756282727; c=relaxed/simple;
	bh=xK7XXS6dlLGTreCj7lDc3VdpvM4B4vA0eXDYAmnYe4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pNS8qblhuz3boqtKMKcIRJ9pSBwVeIEaxx5pzWvMlSN5UWdawk3HF42D4ogN00KjOxzGJtf7jhtNvPl/J3OfoGP/3xr8Oa1NmIVEr3LsgcJ+PY8248LEGz6JcklX+bx5HK1OrtM9eNYIdGn8Ge70W2+o0Oy2SrZuDadzCZT5nWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d1Lg8flF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756282724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpYXMFv3OLBuc46eBmboMhIN1N7DksJ0Aq0rU5afc3w=;
	b=d1Lg8flFkVpEY1v57/BJiWZECJfXP+BTnlscIocctkfkCdrGKem5wEGyM7nLV08UnJpCrB
	QzCTvA1fpFM/WnE3hBkM3aFtygjGdASDToZyZlvRkKuIH/rUgi6fvwfgZL5h9JnysBAhyY
	eINrUIIhTElzmQ+2jgAMHgmSd/L/jrk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-_T1SFl5wMUO4XUzkOIr37w-1; Wed, 27 Aug 2025 04:18:40 -0400
X-MC-Unique: _T1SFl5wMUO4XUzkOIr37w-1
X-Mimecast-MFC-AGG-ID: _T1SFl5wMUO4XUzkOIr37w_1756282719
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b51411839so33106705e9.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 01:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756282718; x=1756887518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpYXMFv3OLBuc46eBmboMhIN1N7DksJ0Aq0rU5afc3w=;
        b=ARJw/U3PnlmQOxG9B8mYQx2PFzUjpSiE/1zQXNpDz0FOxMpOtG4Lb966SX3xAt+T0P
         zbldKzKl0OlOSepzWbTHEOaEDl+/JCWy/9EqioQf/NRMTKg0IKgjmct+fNPFNF34GKFy
         YIv4gAEs+HPqNVs4ZdPSr+x6BP4j3IO3dNIFSwRKMSu9zJjhd/nSzELp1m1Z1kDNZBII
         6AroRkK3Ry5nVyUAe/SS+xBHKzRCLiGHOLW3wzuXzQG1j1sRvLQ0Fs8AhBCjN9e1Bm+E
         MLIUM1aYJqI6LbZyJJWr381YH/5LU/qC2ffLT3Uyt1WpGJOao3dXPBhPsRQJLc9pL9b+
         t1IA==
X-Gm-Message-State: AOJu0YwG4mfMy978jTyFLMoUILAqqkEpo4rblyLFyMnWk0KZLJSphQYW
	lth0oSeTcxilf4EHLU8HghgQVQbqQpBaHlHW2JuIyze6q+J3sZFo9+waK2CczpQZl/2T/5cA0+U
	pUIKw4qEo11BF0ubk65We4wqSZgV+t+oT07K/nN+QraUjZv8bxZYBKCX9CFcIbCBOUuxdZarmkw
	QBwIKJ6JNiAzN3tRbHhbXo0/Yz/5kybnLSRSun
X-Gm-Gg: ASbGncuJYZxIT45a0GBWpm+APjIT5ATAfucewCcYFrwEI8G5DPLzaED+pQR1gt5O1ZH
	Mcq/tj7RDMH9HfnoZJEzj0kjN5jDPamBdSn7zaa0UDvrWMCBF/UhWJODUsp8XYe3uizpPQizswq
	gkfoqTYYoIYT0s8YSJI2AVEUDKi94010ZUOJcY8wNGXHmLzsPn6s7AiiMn2GAVcWrA7wN7TcVSQ
	7opbX/LrN47+/qJVAGIjPLS
X-Received: by 2002:a05:6000:401f:b0:3cb:50f6:35da with SMTP id ffacd0b85a97d-3cb50f639f1mr3333853f8f.29.1756282718447;
        Wed, 27 Aug 2025 01:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOBYIU4e1hPC6Vt8ISO44pX2KQYI86Oiq8xuW1iLVhTH6GAM09vnq09S6YknGGrdTxKt7RGbKysN3ZPJ5A0MI=
X-Received: by 2002:a05:6000:401f:b0:3cb:50f6:35da with SMTP id
 ffacd0b85a97d-3cb50f639f1mr3333825f8f.29.1756282717945; Wed, 27 Aug 2025
 01:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821213051.3459190-1-seanjc@google.com>
In-Reply-To: <20250821213051.3459190-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Aug 2025 10:18:26 +0200
X-Gm-Features: Ac12FXwRz0Br8B68OVtxnvOOJpnjHEu659wzC7dPDYR-jEgOUR6eW_KoP95i8ME
Message-ID: <CABgObfZcSrnUb5+dhm5C38B2u56JTVh5w9-LvHMSKZNk7DzYNA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Two KVM fixes and a selftest fix
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 11:31=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Please pull a few small KVM x86 fixes, along with a rather ugly selftest
> fix to resolve a collision with linux/overflow.h.  Sadly, my attempt at a
> less ugly fix fell flat, as trying to share linux/overflow.h's definition
> doesn't work since not all selftests add tools/include to their include p=
ath.

Yes, I saw that from afar.

> Unrelated to this pull request, shameless plug for the guest_memfd mmap()
> series[1].  We'd like to get it merged sooner than later as there's a bit=
 of a
> logjam of guest_memfd code piling up.  And I've promised others I'll yolo=
 it
> into kvm-x86 at the end of next week if necessary :-)

Will pull it right after this one. Thanks!

Paolo

> Thanks!
>
> P.S. the guest_memfd mmap() series needs one minor fixup in patch 23[2]:
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index b86bf89a71e0..b3ca6737f304 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -372,7 +372,7 @@ int main(int argc, char *argv[])
>          */
>         vm_types =3D kvm_check_cap(KVM_CAP_VM_TYPES);
>         if (!vm_types)
> -               vm_types =3D VM_TYPE_DEFAULT;
> +               vm_types =3D BIT(VM_TYPE_DEFAULT);
>
>         for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>                 test_guest_memfd(vm_type);
>
> [1] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com
> [2] https://lore.kernel.org/all/aIoWosN3UiPe2qQK@google.com
>
>
> The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d5=
85:
>
>   Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.17-rc7
>
> for you to fetch changes up to dce1b33ed7430c7189b8cc1567498f9e6bf12731:
>
>   selftests: harness: Rename is_signed_type() to avoid collision with ove=
rflow.h (2025-08-20 08:04:09 -0700)
>
> ----------------------------------------------------------------
> KVM x86 fixes and a selftest fix for 6.17-rcN
>
>  - Use array_index_nospec() to sanitize the target vCPU ID when handling =
PV
>    IPIs and yields as the ID is guest-controlled.
>
>  - Drop a superfluous cpumask_empty() check when reclaiming SEV memory, a=
s
>    the common case, by far, is that at least one CPU will have entered th=
e
>    VM, and wbnoinvd_on_cpus_mask() will naturally handle the rare case wh=
ere
>    the set of have_run_cpus is empty.
>
>  - Rename the is_signed_type() macro in kselftest_harness.h to is_signed_=
var()
>    to fix a collision with linux/overflow.h.  The collision generates com=
piler
>    warnings due to the two macros having different implementations.
>
> ----------------------------------------------------------------
> Sean Christopherson (1):
>       selftests: harness: Rename is_signed_type() to avoid collision with=
 overflow.h
>
> Thijs Raymakers (1):
>       KVM: x86: use array_index_nospec with indices that come from guest
>
> Yury Norov (1):
>       KVM: SEV: don't check have_run_cpus in sev_writeback_caches()
>
>  arch/x86/kvm/lapic.c                        |  2 ++
>  arch/x86/kvm/svm/sev.c                      | 10 +++-------
>  arch/x86/kvm/x86.c                          |  7 +++++--
>  tools/testing/selftests/kselftest_harness.h |  4 ++--
>  4 files changed, 12 insertions(+), 11 deletions(-)
>


