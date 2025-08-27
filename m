Return-Path: <kvm+bounces-55850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3513B37CB4
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4F911B278E5
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25358320CD3;
	Wed, 27 Aug 2025 08:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYZ7/7ru"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5C31A55C
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 08:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756281787; cv=none; b=PKfrb1WAfVIUdvdFl/Yp/M2uuW4VaHf1AMveHhI/+hwd1lt3Y4GawALoZzBGAOEGrdSNTpNdt2fAaQAYX+9iK2ULVPPyYB8WRiCR6a/hKwdqRihkq/4sojuUGKDb7I9z5frQMQyVHGdF4hN9JXQk59Zp7xqN1O00Sr9H9PKfdYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756281787; c=relaxed/simple;
	bh=+cWNGTvnh/5fkiLN4FuEELA625ti0us2JSPnrePnR38=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlmO+LJQDbWa+ubNioZd7gzYyGqV/VkOHuYpaqpODVfU9VYAc+5EI44Q1DySOKy0UMfg7U1WqnWWfbLsOGlpy/woCPK++afoP7XDbTKFzmClKd4tWLMzscpHw1OJR2UtwWgojqXqGGuOlYAjZZv8OU4L9dRHl3cNMBS59k1aEOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYZ7/7ru; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756281784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enLp0vSBb+0c5x5/f1QRe0OEzIP0CKokhxei+hbso8Q=;
	b=cYZ7/7ruM5TZ8V4mTamQfXi3WrdgBIpAIeKVzSOrGpc4qjVo/kHejQ0OYf6gqj+eSDI8Co
	VgLEu5JHT92UjlgqlOCVIR9HIz8r92ca6iWustgJGby0TtS1XKMM1vbsYWYiHu5y/oiU8W
	oMEdlYsPRPRGsavzdqKSkKwgl2UIvQg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-7mrHWTJfPX6rq_vCJfR8Vg-1; Wed, 27 Aug 2025 04:03:01 -0400
X-MC-Unique: 7mrHWTJfPX6rq_vCJfR8Vg-1
X-Mimecast-MFC-AGG-ID: 7mrHWTJfPX6rq_vCJfR8Vg_1756281781
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b10946ab41so20695291cf.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 01:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756281781; x=1756886581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enLp0vSBb+0c5x5/f1QRe0OEzIP0CKokhxei+hbso8Q=;
        b=LHXNaqtoSJ438xWnxVu8ckoKepegCTvEUz1QPFe8XRjLXMEPTiNK5sRPL8H589Yeum
         2yNaljpWzqVIIfkEDp9gFw4kbp5Rf2Xh4h6UdS4b/fBfXS0dXV8/2zO2qEmMSprnGnh+
         WcHbUlD0iX0+aS97DT2Wzuz4lh7wQYsdn8/duy91w0y7C2fMKpDEPs3kIgav//m/VnSS
         E1LvutBpvx4JO+atZo1IFEMpIK4oZySxyvf7y22SrUwmZ3mqlW9517ewKkyq6Sgf7s9+
         7Ilj/PiWjv7SWwK8vWgdEHdxCjbMniNcz5r2KWl9CH3bN9JFHPwzHBBxJztFMJrWhlL0
         Iing==
X-Forwarded-Encrypted: i=1; AJvYcCUZ4dwsfl1ikm1FZ3EWWtpH49vJxxM8O5PjYysE23udHOVSeVS0Br51B8eD32ssONVKmQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzde/qjBxl91wDjnh9O40HkHk/vXptIzJvZVuZg8iHUaYFH8SKe
	Y9DE3RwGwLTrwGD4KXGAGkW9pLD/mXnHocO0Pauc+beq3mygGlX81n/zv/r7Ya8jRVDfWmki65b
	HTTm0ZZccIEgDx3m2tPMgP5vA2UHZT2mXUq0ynubWPikQ8jB7XQll+A==
X-Gm-Gg: ASbGnctnlbcxfC8jJSoYLNvhU+Y5ux6dCNK22OrgHHW5qZG4btby7fVE99RsVRoriMn
	vqsHD7pDZ59XJwgVVQxqXICZdnaY0NjegxKlsPqZ9yRf3Wuv2Ng9rxM1bgUNGAceNZUSNZXhsya
	BSx/A97EWdg9g+PurSdOKB43YZDo403RYKkw14UHZyHEbTRjCLp45nZuONEtRtfLdoZZ7zW99HQ
	drgvFBArXv8/952MZF9ilyoFmNNgUomMqhaELbfoXb0FioFAxJEUZbT9TkPiZMaKX5FtzckNCZT
	apJLdyBkrikSRqtyYl0rFFvreG8VGw==
X-Received: by 2002:ac8:5701:0:b0:4ab:6101:51e2 with SMTP id d75a77b69052e-4b2e76f6c03mr57981091cf.9.1756281781275;
        Wed, 27 Aug 2025 01:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjdumMzp2Z+l6swklN4j5aUb2EpfFgXL9S5vFwcN5HdoqwTKpet5B8nF8HXyN0MZxdlb9lrA==
X-Received: by 2002:ac8:5701:0:b0:4ab:6101:51e2 with SMTP id d75a77b69052e-4b2e76f6c03mr57980831cf.9.1756281780814;
        Wed, 27 Aug 2025 01:03:00 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e1cd7esm88574151cf.39.2025.08.27.01.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 01:03:00 -0700 (PDT)
Date: Wed, 27 Aug 2025 10:02:56 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 richard.henderson@linaro.org, kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to
 kvm-all.c
Message-ID: <20250827100256.64694a52@fedora>
In-Reply-To: <d109215c-2b3c-46e4-9fb2-49fe70076a5c@linaro.org>
References: <20250815065445.8978-1-anisinha@redhat.com>
	<20250826132322.7571b918@fedora>
	<d109215c-2b3c-46e4-9fb2-49fe70076a5c@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Aug 2025 17:09:27 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> On 26/8/25 13:23, Igor Mammedov wrote:
> > On Fri, 15 Aug 2025 12:24:45 +0530
> > Ani Sinha <anisinha@redhat.com> wrote:
> >  =20
> >> kvm_park_vcpu() and kvm_unpark_vcpu() is only used in kvm-all.c. Decla=
re it
> >> static, remove it from common header file and make it local to kvm-all=
.c
> >>
> >> Signed-off-by: Ani Sinha <anisinha@redhat.com> =20
> >=20
> > Reviewed-by: Ani Sinha <anisinha@redhat.com> =20
>=20
> Do you mean Igor Mammedov <imammedo@redhat.com>?

sorry for mistake,
I've surely meant myself

>=20
> >  =20
> >> ---
> >>   accel/kvm/kvm-all.c  |  4 ++--
> >>   include/system/kvm.h | 17 -----------------
> >>   2 files changed, 2 insertions(+), 19 deletions(-)
> >>
> >> changelog:
> >> unexport  kvm_unpark_vcpu() as well and remove unnecessary forward
> >> declarations.
> >>
> >> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> >> index 890d5ea9f8..f36dfe3349 100644
> >> --- a/accel/kvm/kvm-all.c
> >> +++ b/accel/kvm/kvm-all.c
> >> @@ -414,7 +414,7 @@ err:
> >>       return ret;
> >>   }
> >>  =20
> >> -void kvm_park_vcpu(CPUState *cpu)
> >> +static void kvm_park_vcpu(CPUState *cpu)
> >>   {
> >>       struct KVMParkedVcpu *vcpu;
> >>  =20
> >> @@ -426,7 +426,7 @@ void kvm_park_vcpu(CPUState *cpu)
> >>       QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
> >>   }
> >>  =20
> >> -int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
> >> +static int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
> >>   {
> >>       struct KVMParkedVcpu *cpu;
> >>       int kvm_fd =3D -ENOENT;
> >> diff --git a/include/system/kvm.h b/include/system/kvm.h
> >> index 3c7d314736..4fc09e3891 100644
> >> --- a/include/system/kvm.h
> >> +++ b/include/system/kvm.h
> >> @@ -317,23 +317,6 @@ int kvm_create_device(KVMState *s, uint64_t type,=
 bool test);
> >>    */
> >>   bool kvm_device_supported(int vmfd, uint64_t type);
> >>  =20
> >> -/**
> >> - * kvm_park_vcpu - Park QEMU KVM vCPU context
> >> - * @cpu: QOM CPUState object for which QEMU KVM vCPU context has to b=
e parked.
> >> - *
> >> - * @returns: none
> >> - */
> >> -void kvm_park_vcpu(CPUState *cpu);
> >> -
> >> -/**
> >> - * kvm_unpark_vcpu - unpark QEMU KVM vCPU context
> >> - * @s: KVM State
> >> - * @vcpu_id: Architecture vCPU ID of the parked vCPU
> >> - *
> >> - * @returns: KVM fd
> >> - */
> >> -int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id);
> >> -
> >>   /**
> >>    * kvm_create_and_park_vcpu - Create and park a KVM vCPU
> >>    * @cpu: QOM CPUState object for which KVM vCPU has to be created an=
d parked. =20
> >=20
> >  =20
>=20


