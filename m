Return-Path: <kvm+bounces-34158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 390FD9F7D6A
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E805D18953F5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 14:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0495B22576E;
	Thu, 19 Dec 2024 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0ykVjOd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889C978F54
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734620189; cv=none; b=gl6EiJ12Vudt6kw36e57WROl7ZtU+FFJ6cBoAvCNwO+96QU0JuZe9nOezHm+k1UCNOvg87Qzjwx9NwH9PmsmE38tAgQ3sKQZ4GNFeEJdB5ASokmrIggP3iotdyQ8Me4skmxft0v5HKmN/mUliQhBSAwimMyxid6kHWv/Tar/+hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734620189; c=relaxed/simple;
	bh=ZRDleHAVW1mKCjwbI6Ub45Ua0mOgo6ERx9e9r3VclVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V3Cf35EC0pkyrQuxhcvME3UghaycJdMhyoCB/E7a4q40RKlVq1VZpP7URTbnQqfOlrHt6Y2rXRQhdsHUUkc427i+Darhq0uOP9lylL6zuEvxY6BHvpbv7gKo4W+9/kBYNXZYoOJDhcdkenxOxnyh9vyMv8wLI+fffquz2ctvGjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0ykVjOd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734620186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ujfvfbm3kg5MvzbyJqh9UR78ec5m4Y1ok3TzMScw3Oo=;
	b=N0ykVjOd9O89yRi8T6/S4uvhYrhK7UVQ2TdMMvMXqPC8l5ZeDFL0t4RvkJc4Dh/KCRw11/
	zOhqTlUle2Un+o0pvcJ1eTNkhJKfRJsz6sByXVR/rb3tnMApg7ez1QFw4EVW0BuGzUvuRJ
	XirxibVpJ4+7KgJqZVrwR20pArMqB9g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-Fw9e2EW2M2OTG_E9e76agg-1; Thu, 19 Dec 2024 09:56:24 -0500
X-MC-Unique: Fw9e2EW2M2OTG_E9e76agg-1
X-Mimecast-MFC-AGG-ID: Fw9e2EW2M2OTG_E9e76agg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa66bc3b46dso68904466b.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 06:56:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734620183; x=1735224983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujfvfbm3kg5MvzbyJqh9UR78ec5m4Y1ok3TzMScw3Oo=;
        b=N12z7FsnckvagU8zOTt6nA4a6ComlOIJ/9s6bDq+QhI9bzb7q3kST8LwxbCh0hZZDc
         Lrg3a39Wvd+lWltSISHBR6xxooDvGoERJ6YGQMbkueD93kQOIDTymzliPyM+b58A+eaH
         dnpGLbzjtoC8/1GhG1Tskln/5vvsXYXCeq5NIDqz5qIYGEoiXVBlezM6T3KNPMalVBDN
         b8VQU6ABTe6ICF7SJ1QfYhwFzonXWG9pv3t+4Xlt3oyFWGMz2W89ynD/PT7iV3AGqz2e
         yD7ZL2/dFkAmVNs7xlgtfijWfxhV+YLNlOKgSorYPkPlriD1Cp48wCjs9jCZqgQbdjah
         l5bg==
X-Forwarded-Encrypted: i=1; AJvYcCU+CYIJmAbc93QvPIiDiL8Ii9U/Wfkwt8fwxmivYErhoAsQ5OewywJTS0DQkPCNqhld2GQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYm4R3OsRXDxKmVptHcRpbOTDeKXjH7eBgngFLMYP28zhpB2EJ
	t5LEumwLEIGn3U3W9G4WXMxOD4n3DGCFFe0Jl5ttmwtXyOlz/J+p1QxBXMluKDxipJ152mk2nXv
	Ukky+F3noQdn07milVTIWOKDoPC1WNcQlT7SDsj28AZIljl/23A/jvI5fxvugXWdWuuzsLKKJ0B
	hSd0Wecc4TceD4FPOOKIZHkHsg
X-Gm-Gg: ASbGncvvhjxAib9ByLUn8cI1cJNQxwbLsKjorUlIB+1Lzb4JY8I3tGx8OvaP4yZPeM9
	nYXHQIn89LTE+mQ0cEuIiVjecrdTQIWL0gQG0XIg=
X-Received: by 2002:a05:6402:1ed1:b0:5d0:c7a7:ac13 with SMTP id 4fb4d7f45d1cf-5d802642c94mr7937492a12.34.1734620182868;
        Thu, 19 Dec 2024 06:56:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbFaWXs3uyCvMe4yYFEtLJ+a4fBF1mvZ5QRD2QBRADFglJP2zvKbWpU8mP710dQ9Si3qV6v3BQTWZ56vZ+Bdk=
X-Received: by 2002:a05:6402:1ed1:b0:5d0:c7a7:ac13 with SMTP id
 4fb4d7f45d1cf-5d802642c94mr7937378a12.34.1734620182521; Thu, 19 Dec 2024
 06:56:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218213611.3181643-1-seanjc@google.com> <173457570836.3297396.12144430815948289089.b4-ty@google.com>
In-Reply-To: <173457570836.3297396.12144430815948289089.b4-ty@google.com>
From: Lei Yang <leiyang@redhat.com>
Date: Thu, 19 Dec 2024 22:55:45 +0800
Message-ID: <CAPpAL=zkBpqKYQp4-n-E+Ky9KBkqXN_Sw17GA-FRDLmJtVp+KA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access
 is already allowed
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this patch with the bug's reproducer, the problem has gone.

Tested-by: Lei Yang <leiyang@redhat.com>

On Thu, Dec 19, 2024 at 10:41=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, 18 Dec 2024 13:36:11 -0800, Sean Christopherson wrote:
> > Treat slow-path TDP MMU faults as spurious if the access is allowed giv=
en
> > the existing SPTE to fix a benign warning (other than the WARN itself)
> > due to replacing a writable SPTE with a read-only SPTE, and to avoid th=
e
> > unnecessary LOCK CMPXCHG and subsequent TLB flush.
> >
> > If a read fault races with a write fault, fast GUP fails for any reason
> > when trying to "promote" the read fault to a writable mapping, and KVM
> > resolves the write fault first, then KVM will end up trying to install =
a
> > read-only SPTE (for a !map_writable fault) overtop a writable SPTE.
> >
> > [...]
>
> Applied very quickly to kvm-x86 fixes, so that it can get at least one da=
y in
> -next before I send it to Paolo.
>
> [1/1] KVM: x86/mmu: Treat TDP MMU faults as spurious if access is already=
 allowed
>       https://github.com/kvm-x86/linux/commit/55f60a6498e7
>
> --
> https://github.com/kvm-x86/linux/tree/next
>


