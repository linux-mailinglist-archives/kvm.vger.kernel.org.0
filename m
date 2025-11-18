Return-Path: <kvm+bounces-63607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF38C6BE13
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 14015355277
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673812D9EF6;
	Tue, 18 Nov 2025 22:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKQ7Vvnh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFDD2D0C78
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763505375; cv=none; b=IpQBYeaf0EMLAu7J/BAEd9FLll6JURlv9mFw1k4HZ0BjI9JDmANe/V/3ioJxNAmwiU4sz1W3XkaYJaXdH8/7njBWZtWDG0c78ZVhl+wdpNaOFj50UW2qbxsgd3D6Ol5Q8JYRcnb2g6aAMN2rH30DNMp7KtLm4HMv5JZ5k2q2a78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763505375; c=relaxed/simple;
	bh=iqP/Me/Vja+5cARCCWyYUjJOMTSLfH9Zdnuij0DjYqo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZNB9hxdJczcnAa+ks2f3bbMZVh/WDx1Hap+qavLQyadMxPbjyxfhSZh3DKj+MmJm9LZ6wANCacW+h/DhLcozYJCv6xs5xPUaW8g6ZBjdRdwwplQ4hMXGj0mjw26K/8OSkgDAPfERZ6xvvM3UsJY3+srKE7b/iMmdJ7YFrLtKHcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKQ7Vvnh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34566e62f16so4966954a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763505371; x=1764110171; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2TmQM+dD1VGyC974wQ1Lx1w9G4pCOJSVZXPPJZ8J4DE=;
        b=SKQ7VvnhSgpDRM233UOsob+gZ3rQZWu/rnGkXNAAtaFCfBky4pCZz3WRI4kVtNlabB
         7ljUvCehGbIAHzVPr7IQIL0/dvfw/GkNE4IeHscwZnA/fIciIk2Rea3/oWy7+6TC8hM9
         Nwrp32H4BB1qw9sQO3XzGIoF7ODTej33RXSFvQO28sc1RpkUOQ2zLb9WrL0bwfSDwVE6
         /M581jL7/cS7bSxFeWCqwht0Vp0M32Xkcj7hjwAKUHsX6FfLSsnF7stJrOn2ZMsM5HPs
         15az5ORws3r3JpuZK0QHwEvYD8FL4lFUhPqfMJkSFsfSo+x4ZW2+hH9gTfsQ3rYZwr/k
         Paww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763505371; x=1764110171;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2TmQM+dD1VGyC974wQ1Lx1w9G4pCOJSVZXPPJZ8J4DE=;
        b=ssDorgowsUzTCDznVo+o+G2OTBWhYBxlsw+sb3KMdjdFPoM3Bs5glz6PlalWPEYnGC
         J3y7ddCOuAOcR9Mpcoje99wSsA6JHOhIJ4AadeHokYVkmdKlA6zciMddfsAcpaDqvO91
         WwS/mtRAa5nW2+SMgjas8Qu4oWj8VVzWJVe2NjSuEh9eyeataVIGn6k4TfitTjhGRDOY
         mWXN2eT8Cjwrm/Q6euPKa/Plm06t6aOGR/23AQdouFdS9ukyzEyn4e6/qq4C/GuKOvst
         Dn68AyG39mKXyz9b6+J/RcKzVELiMu11e3CqTtRX9A+/tRsPEMyiL2iDhj3YwhFIr6eS
         fFnw==
X-Forwarded-Encrypted: i=1; AJvYcCU89HvzCRKOKObqCJA/NrCEYg63AaYTnvtnHg6P/8PL+neezo8dQu6SaRR7b1BAptfpAaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPT79PzaGQtWs+8tfS+ujr02uSR7reJTBy4LWozmX0rs6clQtj
	PNRMeTuLTJMGbVNTweqK/ymAJkIh6uN1reqyD4bL+RZ0qdxw8/0o9r6UpQbdKZNR1JgulOmyHnh
	NMi1DdA==
X-Google-Smtp-Source: AGHT+IGtlOq6pOju2r1gUZ7dCyvXjA4z6S1/t7im8qkd5ef/at2gUpeA+6a0vJMPTU5B6JDm+TvpMPR1SdI=
X-Received: from pjbdb8.prod.google.com ([2002:a17:90a:d648:b0:343:5c2:dd74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164a:b0:340:b501:7b7d
 with SMTP id 98e67ed59e1d1-343f9e9f39emr19578596a91.14.1763505371396; Tue, 18
 Nov 2025 14:36:11 -0800 (PST)
Date: Tue, 18 Nov 2025 14:36:09 -0800
In-Reply-To: <20250714095614.30657-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714095614.30657-1-maqianga@uniontech.com>
Message-ID: <aRz02cYzWRnBKoPX@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Fix exit_info_2 check error of npt_rw_pfwalk_check()
From: Sean Christopherson <seanjc@google.com>
To: Qiang Ma <maqianga@uniontech.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025, Qiang Ma wrote:
> The testcase log:
>=20
> kvm-unit-tests]# TESTNAME=3Dsvm_npt TIMEOUT=3D90s MACHINE=3D ACCEL=3D ./x=
86/run x86/svm_npt.flat -smp 2 -cpu max,+svm -m 4g
> ...
> enabling apic
> smp: waiting for 1 APs
> enabling apic
> setup: CPU 1 online
> paging enabled
> cr0 =3D 80010011
> cr3 =3D 10bf000
> cr4 =3D 20
> NPT detected - running all tests with NPT enabled
> PASS: npt_nx
> PASS: npt_np
> PASS: npt_us
> PASS: npt_rw
> npt_rw_pfwalk_check: CR3: 10bf000 EXIT_INFO_2: 10bf5f8
> FAIL: npt_rw_pfwalk
> ...
>=20
> CR4=3D0x20, PAE is enabled, CR3 is PDPT base address, aligned on a 32-byt=
e
> boundary, looking at the above test results, it is still 4k alignment in =
reality,

No, the nested SVM tests only support 64-bit mode.  I.e. they're using 64-b=
it
paging, not PAE paging.

Can you provide instructions on how to repro the failure?  This could be an
actual KVM bug (or maybe a test bug?), and masking the reported GPA will pa=
per
over such a bug.

> exit_info_2 in vmcb stores the falut address of GPA.
>=20
> So, after aligning the GPA to PAGE_SIZE, compare the CR3 and GPA.
>=20
> PAE Paging (CR4.PAE=3D1)=E2=80=94This field is 27 bits and occupies bits =
31:5.
> The CR3 register points to the base address of the page-directory-pointer
> table. The page-directory-pointer table is aligned on a 32-byte boundary,
> with the low 5 address bits 4:0 assumed to be 0.
>=20
> Table C-1. SVM Intercept Codes (continued):
> Code Name       Cause
> 400h VMEXIT_NPF EXITINFO2 contains the guest physical address causing the=
 fault.
>=20
> This is described in the AMD64 Architecture Programmers Manual Volume
> 2, Order Number 24593.
>=20
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>
> ---
>  x86/svm_npt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> index bd5e8f35..08614d84 100644
> --- a/x86/svm_npt.c
> +++ b/x86/svm_npt.c
> @@ -132,7 +132,7 @@ static bool npt_rw_pfwalk_check(struct svm_test *test=
)
> =20
>  	return (vmcb->control.exit_code =3D=3D SVM_EXIT_NPF)
>  	    && (vmcb->control.exit_info_1 =3D=3D 0x200000007ULL)
> -	    && (vmcb->control.exit_info_2 =3D=3D read_cr3());
> +	    && ((vmcb->control.exit_info_2 & PAGE_MASK) =3D=3D read_cr3());
>  }
> =20
>  static bool was_x2apic;
> --=20
> 2.20.1
>=20

