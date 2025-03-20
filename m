Return-Path: <kvm+bounces-41578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C449AA6AAB8
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8D6A3B2260
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420D72066DC;
	Thu, 20 Mar 2025 16:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hu8NO9Ax"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B011E32C3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742486927; cv=none; b=lHMHtiiC/1dc0JNyWLzMODIVbwelr8XMrwthphimxZ5X0LtZCsEb7nifTYH6w+NAWFWLfJ8z+uZ/XLEWHHckQxh27h0sbfG5ZrfyX9rUEyem6Qc1wS5qDbDTB0lHuP6VIs6Rc2zXbo4GhKwtvcD52+U0Mk9r3FKnn9Kq5vX8u4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742486927; c=relaxed/simple;
	bh=vgTVWZExgzh2bDuvAIpu+5f+q3zFr/HZLt45hek77bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JhwisjtwGRShHnbT5TQ29zwf1VgStMqmzgfS7Obc0Ndi5VbQuqzy+bUth1DDyJQrlLmpcOiJgFwydADbSk9ORJ+BH2Ase0jfvPBLgA7n9QHkE9ANa3WfjZHBlYe7PAlfHJVG4AQFIaQ8KgnmTGz6rLiNtqwpsjWOhihUlIwckgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hu8NO9Ax; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e789411187so10393a12.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 09:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742486922; x=1743091722; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qRVFPk38Y5kn7eWiVNM8nEIsgCgvVcbpOFN7/4VSFsU=;
        b=Hu8NO9AxsnTpysHEZJ+BstYXvxfcMq6QExTO7zCa3enjXwVAh0dhcMp+GlT1tkD0ED
         7Qq64sRiI7oXajksQU7pKemR1uq3f9x3nuD7tqPthSvcq9nNPUSIweh4yQttHYQfXnMI
         PqhA3RTWpwRM1TCNTvaW1AFRNOfSNY2pqu/NVng2VHSEIbR2GUSphcZseFJ1DRKUu9l7
         pvk8dCesJCwdR852GvUh4k/0EeOiFwKHRILkV4LC1CPBcK6CIdTOMgm6SuYmegRzQZ1r
         Bw5JIZZCWe3Zkg6D3d1sCFuTcWcPLaOzDK2SULorLWsQCqSEzL7ZpEoeSrOv5WATiIDT
         iHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742486922; x=1743091722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRVFPk38Y5kn7eWiVNM8nEIsgCgvVcbpOFN7/4VSFsU=;
        b=E2tUNwJ3k+KS0EaVa+daHoMTt9hpo5pwJPZLX3T4r0IyFmeXa3dFn3QP3xDeJNiESU
         J5yrEHPg1Z18NJ00e9Uh2mmJzdGc/7L1T6fKOZ/90camU15ioJY0qbuTzQpmzP2Zl/La
         kHMIYp532itNM3NChCBRZJ4YA92txv+PGSQTW4u74JuuOrCZkcDDrjNcQ8dkE9TPrRZd
         NLqfCjoa69A+XCFAghW++9tQII+OIrb0mdepIFiFDo8I1GtADkeC+r7K6pQV6NCCr5c4
         73G9N1etObfsteCDvw+MnCcI5aXMW6CzacK37hBDDbv4mW/Yo+W7/mGjLPYlEoou+Fm9
         wClw==
X-Forwarded-Encrypted: i=1; AJvYcCX1crQsvZ+yprx9V2G7bs8au1uzYoFkkVHNoxMmbX6Cf+BRdM9Wadgfcg3lnkETSFrtURk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUrZr7aA0mQnoQKrdIM+6chA8LTqCHdahSYVD+qepo9VS7mQbi
	P20mW9wcbDFKOAI0ZAcc0krKCOwJ/vM7onH7ONwUnZsIQceGQNGUsNatUNWTsS5BzF38M2evPG6
	vwpZe7UVKXWxyFDIbTSQZkkjDPLFa/EV2KDYiMrI72r+DZw+azDY/
X-Gm-Gg: ASbGnct2rRJV0NIqjXbuQzwHKXDX52FMfCAP35xlExs3SQ/Pt73Zbfd35iNpiMzpSUj
	SrTrIdi7+lR+FoN/06ipzTxD3l2EO6hkzEj05sbR3NOnkFT5C18OnQYaLN7KG48jUY/Qd4ximDU
	g7G/mUpo5xnHEIS8XyDNTeybJtJg==
X-Google-Smtp-Source: AGHT+IE2aF5ixYpsQmX8/liYervWjAj9+pCyKD1dnGB+hzETkfkk5YMebmJT6OByqdUKnt9rJeWGSoBC9gxDw952qN8=
X-Received: by 2002:aa7:de95:0:b0:5eb:5d50:4fec with SMTP id
 4fb4d7f45d1cf-5eba06cb25cmr128016a12.0.1742486922293; Thu, 20 Mar 2025
 09:08:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com> <20250320142022.766201-3-seanjc@google.com>
In-Reply-To: <20250320142022.766201-3-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 20 Mar 2025 09:08:30 -0700
X-Gm-Features: AQ5f1JraSCplyBobxoJA5D_xbOTr5CidJpGQNxGU8uqxS7nrp3COJ0vxcJBnlLg
Message-ID: <CALMp9eTQovt83qgB1pM3NTYaNNRU+wrRhNA9NfsRO4RDnbVU3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: SVM: Don't update IRTEs if APICv/AVIC is disable
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Skip IRTE updates if AVIC is disabled/unsupported, as forcing the IRTE
> into remapped mode (kvm_vcpu_apicv_active() will never be true) is
> unnecessary and wasteful.  The IOMMU driver is responsible for putting
> IRTEs into remapped mode when an IRQ is allocated by a device, long befor=
e
> that device is assigned to a VM.  I.e. the kernel as a whole has major
> issues if the IRTE isn't already in remapped mode.
>
> Opportunsitically kvm_arch_has_irq_bypass() to query for APICv/AVIC, so
> so that all checks in KVM x86 incorporate the same information.
>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nit: "disable" -> "disabled" in the shortlog.

