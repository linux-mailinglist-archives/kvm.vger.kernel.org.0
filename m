Return-Path: <kvm+bounces-39415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 416C4A46FC0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:59:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1E93188B239
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 23:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC7625F985;
	Wed, 26 Feb 2025 23:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eI8+EgUN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD26025D21E
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 23:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740614328; cv=none; b=DcphADktgc8mUfNf0E67e7jFCrc3FueAyvsAN+/D638IDiWx8HxE+KNVPFb/a2sXcstOBWpQw6OSlYj0CYjdLiMxt6YYuS3IRISqnUIwi35vQQxzxll9UxM3WE3gvIwHrTmGM7mZkqmdrwjphZfM3ddmuQBbVfRhSu42q8NNx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740614328; c=relaxed/simple;
	bh=75MlHAogdi4G/er2NuLXXCYJoqzhZpKplVo3Igd90nk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Au7LZZZX6bjTVYXBvnzMWU3MkH6KlfAsN+Ge0dqqLDOi6EKVTg2YfLDcO/N5wXrXEZB/pRMHNnCWVjVpfkXRA62Yt8oq1KdYnj2MLm/G77GDjzSSblKsMQgozF9Old793NSUSH2elLc3Kbg0ktKsORzpBtt4Nwxr/0sS/VIHQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eI8+EgUN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05b36so1146312a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 15:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740614326; x=1741219126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OnlUCxIdxaFoq3G8qhOnJZWi/ObIsgWKmCedksCsaLA=;
        b=eI8+EgUN88LzgWexavGoAb04G+IFGj5lhvqTb/NfczZsPBZ2dc4xvXF3ObmboAtsJ7
         FapIdWZDzaVNkmzq7bExV12w8j4udd1pdFiZuVCf2iKBRTB926Mr0YabumFTJdx95Xxy
         YI5Tv6xBmEC5jkYJlxJ8lU+IfILfjRxduPgIeF2nxe/1dLGGi8hv7mfs7nvgG/lJawwU
         8S13gjnMPkUAxdCE9Pm9AmXv6EZKhcN6aeo84GfIH8V5Tq0vW9ytN/WwpptDelFYpitm
         5tsZ0lZ4y9Cj1xDNVhBU8/R9owYfnN/iiQbCB6+LCzPtaaIch4F+KaTV+R8ldpWCTQHF
         vv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740614326; x=1741219126;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OnlUCxIdxaFoq3G8qhOnJZWi/ObIsgWKmCedksCsaLA=;
        b=INfqKDS4ysSor7N59XcyFdr/s61bSwODpeZI7fNA1DBYgR+JfxrXiip4ep+wjcYRCR
         H1WynQd7Ep1zLmMFlcRAz1LM2N3YdlUigFiRsrhZyQiwOJszeJT8hUQIpqczcGVIPdgG
         Q2fOLfGdi+pw2L1Z/X6o0gB6Rx/J15OHwWXeMT8PSQEl6CmNOOAFZ+8xckCcpsCdwtFM
         S8LOGCI2xyGSG3uCtsa5s3AgSl0RWKrzEOGpILoNNf+/fRZ6x8R1x999PP0LO5Sj2M4x
         BCsDPt0PWS37RPPOcUYchD6D9EhHmIgY/uM3soJpJU2t3whgbJLbPQCH3PsN/3+Q0Bn+
         yD3A==
X-Forwarded-Encrypted: i=1; AJvYcCVMUz9GFW73WGSl89nmqTDzia4+z5Uj1wpMTMjTOlxGBNXR6pgEXk4GBFrYkFpVxxvSk0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpSM6wqUkNY9rFqOajj52jD42rajYRCpTb/XVkOGyiEbMFFu4k
	hrCHDdIxUApknGqOj/uCG1WHSmGTVRntmjUdBdoWNhpoNNXPNhVOz7Ky+bmgYIOi9y1/STT8V6f
	M8A==
X-Google-Smtp-Source: AGHT+IH2OlbsT3yolFz9xzkEi4jQ+m0DWhYCrQXGCUPa1I1gqVveiOu+6xLfX4ZnjY7h+08+hCX9ALedZgc=
X-Received: from pjbpx7.prod.google.com ([2002:a17:90b:2707:b0:2fc:1e77:d6b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268d:b0:2ee:59af:a432
 with SMTP id 98e67ed59e1d1-2fce874088emr34548024a91.31.1740614325987; Wed, 26
 Feb 2025 15:58:45 -0800 (PST)
Date: Wed, 26 Feb 2025 23:58:44 +0000
In-Reply-To: <D32EF18F-7C4D-466B-9058-1EBD4C378EFC@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn> <20250128015345.7929-4-szy0127@sjtu.edu.cn>
 <Z75se_OZQvaeQE-4@google.com> <D32EF18F-7C4D-466B-9058-1EBD4C378EFC@sjtu.edu.cn>
Message-ID: <Z7-qtIjS0bdc5J0r@google.com>
Subject: Re: [PATCH v7 3/3] KVM: SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	Kevin Loughlin <kevinloughlin@google.com>, mingo@redhat.com, bp@alien8.de, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025, Zheyun Shen wrote:
> I'm very sorry that the formatting of my previous email was messed up due=
 to
> an issue with the email client. I am sending a new email with the same
> content.

Something is still not quite right, as your mails aren't hitting lore.kerne=
l.org,
i.e. are getting dropped by the lists.

> > Sean Christopherson <seanjc@google.com> wrote=EF=BC=9A
> >=20
> > On Tue, Jan 28, 2025, Zheyun Shen wrote:
> > Changed the time of recording the CPUs from pre_sev_run() to vcpu_load(=
).
> >=20
> > Why?  If there's a good reason, then that absolutely, positively belong=
s in the
> > changelog and in the code as a comment.  If there's no good reason, the=
n...
> >=20
> The reason I moved the timing of CPU recording from pre_sev_run(=EF=BC=89=
 to
> vcpu_load() is that I found vcpu_load() is always present in the call pat=
h of
> kvm_arch_vcpu_ioctl_run(). Moreover, whenever a vCPU migration occurs, th=
e
> control flow will reach vcpu_load() again to ensure the correctness of CP=
U
> recording. On the other hand, recording information in pre_sev_run() woul=
d
> result in recording the CPU number every time before entering the guest.
> Without vCPU migration, only the first time to record is effective and th=
e
> subsequent records are redundant and thus waste time. This would result i=
n
> each VM exit taking longer (although the additional time may be very shor=
t).

So long as KVM performs a lockless test to see if the CPU, the cost should =
be
minimal.  This:

	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);

Generates a bt+jb to guard the locked bts, i.e. *should* only add 1-2 uops =
to the
entry flow, once CPU's predictors warmed up enough to not prefetch the RMW =
and
bound the cache line.

   0x0000000000016603 <+67>:	bt     %r8,0xa428(%rdx)
   0x000000000001660b <+75>:	jb     0x16616 <pre_sev_run+86>
   0x000000000001660d <+77>:	lock bts %r8,0xa428(%rdx)

If it turns out that marking a CPU as having run that ASID becomes a hot sp=
ot,
then I'm definitely open to moving things around.  But for a first go at th=
is,
and especially without evidence that it's problematic, I want to go with th=
e
approach that's most obviously correct.

> > Unless I hear otherwise, my plan is to move this back to pre_sev_run().
> >=20
>=20
> Another issue in the v3 version is that I incorrectly cleared the recorde=
d
> mask after each cache flushing. The mask bits should be cleared and chang=
ed
> at the time of vCPU migration rather than after a cache flushing.

The bits can't be cleared at vCPU migration, they can only be cleared when =
a
flush is issued.  A vCPU that did VMRUN with an ASID in the past could stil=
l
have dirty data cached for that ASID.

KVM could send an IPI to the previous CPU to do a cache flush on migration,
similar to what KVM already does on VMX to VMCLEAR the VMCS.  But the math =
and
usage for WB(NO)INVD is wildly different.  For VMCLEAR, the IPI approach is=
 the
lazy approach; KVM *must* VMCLEAR the VMCS if the CPU changes, using an IPI=
 to
defer VMCLEAR allows KVM to skip doing VMCLEAR whenever a vCPU is scheduled=
 out.

For WB(NO)INVD, the IPI approach would be an eager approach.  Deferring WB(=
NO)INVD
until it's necessary allows KVM to skip the WB(NO)INVD when a vCPU is migra=
ted.

In short, no optimization is obviously better than another at this point.  =
E.g.
if a VM is not hard pinned 1:1, but vCPUs are affined to certain cores, the=
n
flushing on migration is a terrible idea because the total set of CPUs that=
 need
to flush caches is more or less static.

Anyways, as above, I definitely want to go with the simplest implementation
(make the bitmap "sticky"), and then iterate, optimize, and add complexity =
if and
only if it's truly justified.

