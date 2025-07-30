Return-Path: <kvm+bounces-53745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C961B165DB
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E42C5489D4
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 17:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478F02E2661;
	Wed, 30 Jul 2025 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJO/pgd+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE8B2E093A
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753898169; cv=none; b=IGAF8hQSjXzgdNghydyVuafGLsDQLF4TLLUzEJ8DUy3+YEPb9jrktfebfcLpuQEI/G0jsFECeHxvs2LvMV+LRnM+rmqaauEfoGOjTbVZB7lLGw0ckWy1BoEVhZaq/Akun5kFcQiDlehgSCxNZXy616+b5Rd+oJktTCRfpsNXFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753898169; c=relaxed/simple;
	bh=7OLCRCNR5V/AlevOyvlK6totQukmEA5jV8LJEeHMwaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kAV1YsFiYFTOjrMZ6ca7/xTgF5n3ugqXX1HgGwiRiJ4XfxZg59ppsvHwaF+oJCvpCiKvkgKuXWXgRZmNmXgIk+Unw3ZWSZK0ycv+ejDyb981WMN3Ak1t2q+WMeNS0uAg2xFLw/wopJhkaKQBKnuFHb2KveQZCJ6+VsIJzODB1Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJO/pgd+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753898166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tmJpoYYb7eLSC9wRAB/Bqt5vsUFjB2nvCjuXfmwYWc=;
	b=cJO/pgd+U9cRDcFchxgpoG/cES3umbjpL4YszkjNeSBjnmaNJaj4hCqAzEoR7j/y18cgoH
	qX1Ya6L9nIXorEgLEve2kclUo86x0yIb+iZqeVnKO+BCIJCtHxw9lb90IzXqAUFOLUkWwQ
	ESkFBCS9b/tqzClaXZ5fVtVp8I1fCOw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-VawnGuT2PUqvzQYWMV8_cw-1; Wed, 30 Jul 2025 13:56:04 -0400
X-MC-Unique: VawnGuT2PUqvzQYWMV8_cw-1
X-Mimecast-MFC-AGG-ID: VawnGuT2PUqvzQYWMV8_cw_1753898163
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7889c8d2bso23368f8f.3
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 10:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753898162; x=1754502962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tmJpoYYb7eLSC9wRAB/Bqt5vsUFjB2nvCjuXfmwYWc=;
        b=WOXSZ3C1xQkI8yIFU6GIsRdvnCUUsD3vc2tVJVNI7QGrQqVVb1oc0d4SiW1FHVyqjt
         FoOJtfLF1S2PDZFkR7Tem1vUJujwYjD6mhYTSHRdLR1VlFqte6JTk/2yClap0X0bxKsY
         eQ5/V15r2JirRRUySooVYqeZtqsxC1Jj9+DmOROlFnfANWA7SH3M1Hgz1iuDeEPPzyZ9
         cVEGy9uRBcNHwRRBdMHHJhRpvUi/z/dfEfq/rsFD13GqJToVNTAlv1T0kGVjkvxdg1n6
         m771hQLYFLPP6Q7M20LUUz8WKiNIXuj4LqsrSZBCGnKIoyw4TXFD+28sajCK3ocvUDlh
         dUuQ==
X-Gm-Message-State: AOJu0YwpMLAisKtdA3y2RJchUAtq53BOVcuekuTUOdBl3xNSo3LXXUzX
	D7O8x8m5lXYTOa69aW63O/dxa0/3wHQhxZfPDgXo4/yWbjB5GcHyLRf4HHiDbv1lLLQ4eri0stQ
	PSxwU3BYvcef+hNnIsQQ0fouDZwYr8JqTHhog341ALg7YTWhSvd95uuHF5ZEf+i5bHRA16VK+vK
	i833mNnJi2lt+fguOE6tu42dOqeH7k
X-Gm-Gg: ASbGncubVin8YFD6s57I1GwOIbx9RxnvvVQb6Y5Pl/s73I/keMZLPAvQs8Fjs+d2gZq
	eYwFkTCnD+v0dCqG1Xhn20cAcgAGZjJhhGHgZbC65DpnoOJ3uNWb+wpCKbCzT0EJt62Nl9CS6br
	IpC2vVUCF/IA5Sp+K2/7uQZA==
X-Received: by 2002:a05:6000:1888:b0:3b7:7910:2159 with SMTP id ffacd0b85a97d-3b7950109c1mr3505053f8f.55.1753898162187;
        Wed, 30 Jul 2025 10:56:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG26N0I19mW9eRY7Eb0OU1Cm5tjgJLaTMjcvx2EQY3LNoUffveVDZiQLM5Ba2OV+n+7p+edjzfMVLPdiokAYvg=
X-Received: by 2002:a05:6000:1888:b0:3b7:7910:2159 with SMTP id
 ffacd0b85a97d-3b7950109c1mr3505038f8f.55.1753898161649; Wed, 30 Jul 2025
 10:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com> <20250725220713.264711-13-seanjc@google.com>
 <CABgObfZWvtskg-m94LRHqN=_FtJpFtTzOi3sEhiAKZx1rzr=ng@mail.gmail.com> <aIkkkaqTbc9vG_x3@google.com>
In-Reply-To: <aIkkkaqTbc9vG_x3@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 30 Jul 2025 19:55:48 +0200
X-Gm-Features: Ac12FXypMCtriNdkn1LbM5S5k_2ZX491ZBTz9QXKmema-A7BqPYwU9xq0s1CzGU
Message-ID: <CABgObfZmn03eQU9XYnFRKfHWNUx006z_4x8Z91hapVHZupUYwA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.17
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 9:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> As for this pull request, I vote to drop it for 6.17 and give ourselves t=
ime to
> figure out what we want to do with vm_dead.

Ah ok, so my spidey sense wasn't right for the wrong reasons. :)

> I want to land "terminate VM" in
> some form by 6.18 (as the next LTS), but AFAIK there's no rush to get it =
into
> 6.17.

As you prefer! I had already rewritten slightly the commit log, so
here it is for
your reference and future consumption:

Add a TDX sub-ioctl, KVM_TDX_TERMINATE_VM, to solve a performance
issue in TDX VM cleanup. A guest_memfd keeps a reference to the
virtual machine, which means the VM cannot be fully destroyed until
the guest_memfd is released. However, to release the guest_memfd the
TDX module must first destroy the Secure EPT, which is a slow
operation if
performed while the VM is still valid.  KVM_TDX_TERMINATE_VM allows
userspace to initiate the transition to the TEARDOWN state before file
descriptors are closed (either by hand or on process exit). The TDX
module then releases the HKID and S-EPT destruction can runup to 10x
faster.

Thanks,

Paolo


