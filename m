Return-Path: <kvm+bounces-21415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 668E492EB6F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 17:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 227C72843C1
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 15:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DF016C877;
	Thu, 11 Jul 2024 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bs4wEg3D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB9915B12C
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720710982; cv=none; b=R4Wt4865BBsj7eiIWZgSAXEbtIRJhUQPiGmLrd9c0cvlvZn7hrU6iRrMagfV7B297q357j7RgHubcWS6cS/vWruJZFq4qjcD1VurvwcSzjTGQuldM8xMDNJ4rZFTS7OOZ56iyR6QQu0QIqkKsK26/DJWOtCa7BTt3TCCP1QLKXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720710982; c=relaxed/simple;
	bh=ZT8r4jHQhDaBCzN3+aEtNsWoK9MhYoqizNljs+w6bDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Csql8u2vuSK5fwdYuMUWdTHtDdvbA3kcSq2aw0LXdqmO6t5jH/idXyB8gSE+HJZxPT/judisTRPOGVIlyVmgFQ7of4c8lXPFXrCASFCNwCXBTfLoPSwoWdGVzcucISBuEkpMeAWcS0lMGuSdaEYsLYHsCLXeppqrk3QOEhb2F1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bs4wEg3D; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42666b89057so83965e9.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 08:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720710979; x=1721315779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyJDEQBIS7qTi/nDqfXrdBXWCR7i7ojFDGlwfpekfoI=;
        b=Bs4wEg3D5q2c6efrE96XH59oUsQzUXWnGYsfurUc8IHesEIkg6C85dCiyRTlXKlbVp
         31TlqHuKoFOXiEG3j+RluCKJmpme2HlHJ6VhssnWb0E4IW/Gq9RSkcXkAzHlM/ONtwX4
         IfXegvkGre495sO8ysF9oOuKRVC+j8waID5RZRy+Vq6kNwvp02P0Spc6Lxf9pLGb21yQ
         5EAGz8OMForknCb8qWeDaxSuOMIFkmUxvSSRQhhSr9OQARsEV7S9kO2praMCnTvHUks7
         KNW80hLDs+IoNLkHHTiQKLzYVodEhSSwtOLNLFyD3CCaTIDwkJNIeUzx0cYFKHpfV+GB
         zXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720710979; x=1721315779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fyJDEQBIS7qTi/nDqfXrdBXWCR7i7ojFDGlwfpekfoI=;
        b=QW/eMI0eQuPztPk1g/OJyXOJt65CC7lgVDBpbRUDULJF17LzYYd64qE3UHU5cWpcdc
         vzckJihe5GiMGgrdjRNIJ1JVZfVufK42GXHdCJYd0BWs6IyISKWCY76UJAEMUb94Yt52
         td0bPKFfKeirWxnKSO/bFb7SCLTyIr0G9iJ+58bv2bTlxJoqAVJDflqhrmvfVK6IwfFb
         /4XtaRH3WDORmAsUvCanPQLG+vWvuS8PIZEDQY+vejWQNKvJ49OegXQyXOhrBV+FEoRG
         F0tUuFiqootF+0f3UEzNmieRpKE2MY92dRA4RJyOcJBXhpgnXYVSBTIDmKQM1nMpz7ca
         NjXA==
X-Gm-Message-State: AOJu0YwwozNCXZ41/KZw5xrOVg9wj3jvCG5yHI4D82kXl76pFMLhEns0
	1LxAJ8HHiEeu7YhnUkT1RQopTX7ieafpQ0uVurTdsIys2eSJ8gOLT6wflTOFeXjJq74nRNQ5FDr
	W2UGtuWjZO9uxkIyPF0XfcAMOtBSXXLjaT4zc
X-Google-Smtp-Source: AGHT+IGyYy3GyAeAwJ7v4rMOuRzUatN1QEIvXg15T5400EWs8XL5YxyUZKvT+dfB4f5AwJxjdXJ5KxKcif0r6hYufcg=
X-Received: by 2002:a7b:cd95:0:b0:426:6e95:6ea7 with SMTP id
 5b1f17b1804b1-427986dc130mr2064645e9.0.1720710978801; Thu, 11 Jul 2024
 08:16:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com> <20240710220540.188239-2-pratikrajesh.sampat@amd.com>
In-Reply-To: <20240710220540.188239-2-pratikrajesh.sampat@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 11 Jul 2024 09:16:05 -0600
Message-ID: <CAMkAt6oc5YC8oLpvFDeCOrEH6Hm88M_U_eMBPXpQWvcqjL7nzg@mail.gmail.com>
Subject: Re: [RFC 1/5] selftests: KVM: Add a basic SNP smoke test
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, shuah@kernel.org, thomas.lendacky@amd.com, 
	michael.roth@amd.com, seanjc@google.com, pbonzini@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:06=E2=80=AFPM Pratik R. Sampat
<pratikrajesh.sampat@amd.com> wrote:
>
> Extend sev_smoke_test to also run a minimal SEV-SNP smoke test that
> initializes and sets up private memory regions required to run a simple
> SEV-SNP guest.
>
> Similar to it's SEV-ES smoke test counterpart, this also does not support
> GHCB and ucall yet and uses the GHCB MSR protocol to trigger an exit of
> the type KVM_EXIT_SYSTEM_EVENT.
>
> Also, decouple policy and type and require functions to provide both
> such that there is no assumption regarding the type using policy.
>
> Signed-off-by: Pratik R. Sampat <pratikrajesh.sampat@amd.com>

Tested-by: Peter Gonda <pgonda@google.com>

>
> -       test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
> -       test_sev(guest_sev_code, 0);
> +       test_sev(guest_sev_code, KVM_X86_SEV_VM, SEV_POLICY_NO_DBG);
> +       test_sev(guest_sev_code, KVM_X86_SEV_VM, 0);
>
>         if (kvm_cpu_has(X86_FEATURE_SEV_ES)) {
> -               test_sev(guest_sev_es_code, SEV_POLICY_ES | SEV_POLICY_NO=
_DBG);
> -               test_sev(guest_sev_es_code, SEV_POLICY_ES);
> +               test_sev(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY=
_ES | SEV_POLICY_NO_DBG);
> +               test_sev(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY=
_ES);
> +
> +               if (kvm_has_cap(KVM_CAP_XCRS) &&
> +                   (xgetbv(0) & XFEATURE_MASK_X87_AVX) =3D=3D XFEATURE_M=
ASK_X87_AVX) {
> +                       test_sync_vmsa(KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
> +                       test_sync_vmsa(KVM_X86_SEV_ES_VM, SEV_POLICY_ES |=
 SEV_POLICY_NO_DBG);
> +               }
> +       }
> +
> +       if (kvm_cpu_has(X86_FEATURE_SNP) && is_kvm_snp_supported()) {
> +               test_sev(guest_snp_code, KVM_X86_SNP_VM, SNP_POLICY_SMT |=
 SNP_POLICY_RSVD_MBO);

I'd guess most systems have SMT enabled, but is there a way we can
check and toggle the SNP_POLICY_SMT policy bit programmatically?

Also should we have a base SNP policy so we don't have to read
`SNP_POLICY_SMT | SNP_POLICY_RSVD_MBO` every time? Not sure I think
selftests prefer more verbosity.

