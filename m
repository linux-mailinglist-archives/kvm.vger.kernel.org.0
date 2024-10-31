Return-Path: <kvm+bounces-30135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE9B9B713E
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DF67B21699
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A832110E;
	Thu, 31 Oct 2024 00:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PxX1AMZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45E11EB48
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 00:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730335417; cv=none; b=XK3IZBnTyRx5syaD0IBVk5W4K8/nEQczR7cBMQKMUUT0OnjXr6KZjIJjYkMcn2yLLAQAqE+itkA6ZrGlrAc8sKkPpfPLAh7Gl/7ijU+5g4c/3QIcXFMCfiKEh8ieqyWCXuni4LHxwAHZKP+yEreT7ThHSn10KZUWQb+Fu50wp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730335417; c=relaxed/simple;
	bh=mQwaKkURbifMZiDHraDc/5oFkvSgynWluwX7GIK9IV0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JnbcGzjMzimr+bsSjEmuq13wHhBYI/nnjBYQN90ezhZABTtXIyA6KY7CLz8nSGSwt6WSAMiM2s1WKjO2nD8Tr2X7755zeUPdqaZHphztV/uv7FbuAObFQhTeAojSDrV0f3Kv/iE05/MHxDJ5Ik9ENaprIW/X3sxWAb/UC8ZgDKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PxX1AMZx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e370d76c15so7073997b3.2
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 17:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730335415; x=1730940215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lc9Ko3rusE2y1usfYJVqx+IQsEW0RdfxueyJA1MxufY=;
        b=PxX1AMZxqDqKmcfpXTv2cz7P86pNe/hXtXI55ZzMYmX/MGFHGNrYWTMtvEAlF3dsls
         J54gUbwPRKAlF5aIOzB5kmtLnSDTr/wa7JWH4epeF98JEo8D5na0i2hRWyTcueByXkg5
         y83yNp6P8M838388rAvXkRsE5qZrxvmxzY77iOZPrdg6aulGbJzY2iI6S+S2S0PgyNzC
         Q6DcwBcOQlaIqLSA3ReMm4QKFycik3oz7xRGTzjrPGXcq9ESz1blEbHfa3g3wC9SzdqG
         AJd/93DcyiMCmXqv9ZJdv4pQG93rY1Y2EKoqBZCzRmRhvCdvRGXrhBaSy3aAe/TTqPkZ
         uvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730335415; x=1730940215;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lc9Ko3rusE2y1usfYJVqx+IQsEW0RdfxueyJA1MxufY=;
        b=vANkO0RUZ4jakaX5VTiE1Iu/35y2Ky8JrBRqKIt+ghXaI0uV+VRyoWTAr2sjEodfoa
         GCns3sbg5mlSZxsvlAn2cdqRSZc/T4ZqHws7tBe709j8DNjLWvO3Sji7R2FR1Jf+lt79
         x9gyxFqq268ehJMRMHwWusplIQkI7vfjIiFcnOXukH2pIMeajyiQkInFGRJlUr3bApDZ
         3MvWBZUYSQ1TnM1DiUiR0MEmnAglEtEmipWJ7acYjKWqq5DRFiAUZrYATqIg1pY1EWwv
         s4bzE6IlEctyRTUN4MoClXOzRfl5ZTAtu53oAaSFRBRfWN0W+/m5bkSrk3eBXRDRPtHr
         HN+A==
X-Gm-Message-State: AOJu0YzvTIHu/Q+K/sjIuuZpSZAkwPWSl7dUPMptAFYMv2mZ0GtQXSv2
	8GjKaUumLuZoTjBcPgP+WEBAMBKPDbOuS3w5CqKY1SusdUj1Yl0keNuzLBKOuhIfY0OjNJvpIYs
	gZw==
X-Google-Smtp-Source: AGHT+IE5CV6w7aHkdUCJhDlcvvVHFUDLTLIJOE4n078/KB1R9SLnbLrJSAMahhcc96u9kY1YecUcK67MDbo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3808:b0:6e2:12e5:356f with SMTP id
 00721157ae682-6e9d8b214c0mr13625677b3.3.1730335414769; Wed, 30 Oct 2024
 17:43:34 -0700 (PDT)
Date: Wed, 30 Oct 2024 17:43:33 -0700
In-Reply-To: <20240906221824.491834-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906221824.491834-1-mlevitsk@redhat.com> <20240906221824.491834-2-mlevitsk@redhat.com>
Message-ID: <ZyLStWMyar0D8PY3@google.com>
Subject: Re: [PATCH v4 1/4] KVM: x86: drop x86.h include from cpuid.h
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2024, Maxim Levitsky wrote:
> Drop x86.h include from cpuid.h to allow the x86.h to include the cpuid.h
> instead.
>=20
> Also fix various places where x86.h was implicitly included via cpuid.h
>=20
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/cpuid.h      | 1 -
>  arch/x86/kvm/mmu.h        | 1 +
>  arch/x86/kvm/vmx/hyperv.c | 1 +
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  arch/x86/kvm/vmx/sgx.c    | 3 +--
>  5 files changed, 4 insertions(+), 4 deletions(-)

This missed a necessary include in mtrr.c (maybe only for W=3D1 builds?)

arch/x86/kvm/mtrr.c:95:5: error: no previous prototype for =E2=80=98kvm_mtr=
r_set_msr=E2=80=99 [-Werror=3Dmissing-prototypes]
   95 | int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
      |     ^~~~~~~~~~~~~~~~
arch/x86/kvm/mtrr.c:110:5: error: no previous prototype for =E2=80=98kvm_mt=
rr_get_msr=E2=80=99 [-Werror=3Dmissing-prototypes]
  110 | int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
      |     ^~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

