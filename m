Return-Path: <kvm+bounces-14801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 873F18A71D5
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB51B1C22525
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793481327FD;
	Tue, 16 Apr 2024 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4ow/zGY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC7131BC0
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286875; cv=none; b=cWeYRMxHKNOX8JypcJ/9uPYoDzGhbAxFmon4eu24Vt+tKJlbNP8MC97iaEDtU9xpkY60Dx+8g/SATm+4WQqjbQvRFbWAXdZXu9vEg9Qs3acVfCj+Wy+UGVIWHYigWa8SbmfzPcBuzHNJoI+ZUAXfVLQhlSGhMLoN3+C1UBCor3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286875; c=relaxed/simple;
	bh=d8yfNDlD2slCnTX5YrNTAPoVtr6kE/Nqrv0NiCbczaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SmVSBuWPtAZCOzb7KyRpU1t4BdMWxEAE5ySzsjOuYK2Yf8CujWpEWYTrzsDNfvjCMsrYpKCnn5Sj6IqsWtxuI3awoMGzVZYWYKuopBEg8X5hG2jIPcQ1TYobXw5357xt+bCUAWzGk7qumZlF/4cuhI7tpPiuB+gjzbWvoxTgykk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4ow/zGY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713286873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YV3huxxwV4cNX30vuhj/67sfqzzrbon2fJPguOJkhQA=;
	b=O4ow/zGYxRNU6q6pIMtwYnFdMfYWeQfKH74uFs+mqCSjtRFCcEzmO6DFCteaDJ8+FEgxqx
	LM7PfpThookmC8wW1hqPbaE4IfZeW0C2vdAvhLfZ97su13Fd2fQ68u/ZcrEG/09PR/h3fy
	0rohKtZ7kAKRiiuP3Um/QsVdOgUeD8g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-hyJneFtHM1ibYwC3fcx7Aw-1; Tue, 16 Apr 2024 13:01:11 -0400
X-MC-Unique: hyJneFtHM1ibYwC3fcx7Aw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-343f8b51910so2625203f8f.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713286870; x=1713891670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YV3huxxwV4cNX30vuhj/67sfqzzrbon2fJPguOJkhQA=;
        b=N+m/g7bWaGQgj1yk5R3lqA6eo8Qdlwq7wfMsBfOQCxZ9ebYDXE+eNbXKRK7XK4bl/u
         INIa45MickZQoiq7hn/KJ1IS3GpPRyc5528a7OK1F9r146SXkqF637TaDSMtpSljewZg
         iFOcyw7sMMBY2U0A63YFFqtFPKzR0c/AnVT1WIEoYHm5HdMGoF2oiRvBEb6DEQMdi4vo
         KlkBCyxtFNTfK4aWJYm6ribzi0vS3Bi6w333+dSiUXzkFd4VcwCRW1CRNJFiM3guPm+A
         SWa/szI1N/RskfRmzYrAZqcdMd7ps55yFoNbBsAECYVLyY4uKkJJ2w3qNQsibicPfIkT
         HxSA==
X-Forwarded-Encrypted: i=1; AJvYcCWLJAgb1FIDwAQj5mQo1bfsH10uwqERg1NB18M5EskDKOSlS0D0+nUOloNHm5QsDpoCAucpKkdwOKTtUwJ3sCoAiDPa
X-Gm-Message-State: AOJu0Yyyg0V4vA9TC88KrHv1cmCgAvsX9VMVq1hADtmeGXfM/415EOc7
	4iOG5cVH01q3addXs9G9xkmLJZ+uSh1zO7ZTO+rfD2EljhYCYkaZX4LHzEgiwrM+onVaOCoWiZk
	aRTjr7ADUAkK64aYkCQRGySevcyxmdHZu4vfG9UHBxRfiD0Gso5MneTbiPIwXLYDNhWRUEQXf0l
	foZcYfmSTuw23YRg3+wEdXWyQV
X-Received: by 2002:a5d:6247:0:b0:348:5e40:62aa with SMTP id m7-20020a5d6247000000b003485e4062aamr2053441wrv.2.1713286870097;
        Tue, 16 Apr 2024 10:01:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6fYFk6xl1nuI2T7KirzQuQyw/sEuJB0A3gheWB+RJwuSGwFc7r4/2ReNv9v/wLow5jcYtNYlNsRKa11DX2JM=
X-Received: by 2002:a5d:6247:0:b0:348:5e40:62aa with SMTP id
 m7-20020a5d6247000000b003485e4062aamr2053410wrv.2.1713286869755; Tue, 16 Apr
 2024 10:01:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240329225835.400662-1-michael.roth@amd.com> <20240329225835.400662-19-michael.roth@amd.com>
 <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com> <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
 <758c876d-ff77-0633-7b3e-965d863d5a93@amd.com>
In-Reply-To: <758c876d-ff77-0633-7b3e-965d863d5a93@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 19:00:58 +0200
Message-ID: <CABgObfbhNce22iuqjS3bF9V4aD1vpBg3oUcV6SLVHgvL+-UUmA@mail.gmail.com>
Subject: Re: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable
 for populating VMCB
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 4:25=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
> On 4/16/24 06:53, Paolo Bonzini wrote:
> > On Sat, Mar 30, 2024 at 10:01=E2=80=AFPM Paolo Bonzini <pbonzini@redhat=
.com> wrote:
> >>
> >> On 3/29/24 23:58, Michael Roth wrote:
> >>> From: Tom Lendacky<thomas.lendacky@amd.com>
> >>>
> >>> In preparation to support SEV-SNP AP Creation, use a variable that ho=
lds
> >>> the VMSA physical address rather than converting the virtual address.
> >>> This will allow SEV-SNP AP Creation to set the new physical address t=
hat
> >>> will be used should the vCPU reset path be taken.
> >>>
> >>> Signed-off-by: Tom Lendacky<thomas.lendacky@amd.com>
> >>> Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
> >>> Signed-off-by: Michael Roth<michael.roth@amd.com>
> >>> ---
> >>
> >> I'll get back to this one after Easter, but it looks like Sean had som=
e
> >> objections at https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com=
/.
> >
>
> Note that AP create is called multiple times per vCPU under OVMF with
> and added call by the kernel when booting the APs.

Oooh, I somehow thought that

+ target_svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
+ target_svm->sev_es.snp_ap_create =3D true;

was in svm_create_vcpu().

So there should be separate "snp_ap_waiting_for_reset" and
"snp_has_guest_vmsa" flags. The latter is set once in
__sev_snp_update_protected_guest_state and is what governs whether the
VMSA page was allocated or just refcounted.

> But I believe that Sean wants a separate KVM object per VMPL level, so
> that would disappear anyway (Joerg and I want to get on the PUCK
> schedule to talk about multi-VMPL level support soon.)

Yes, agreed on both counts.

> >     /*
> >      * gmem pages aren't currently migratable, but if this ever
> >      * changes then care should be taken to ensure
> >      * svm->sev_es.vmsa_pa is pinned through some other means.
> >      */
> >     kvm_release_pfn_clean(pfn);
>
> Removing this here will cause any previous guest VMSA page(s) to remain
> pinned, that's the reason for unpinning here. OVMF re-uses the VMSA, but
> that isn't a requirement for a firmware, and the kernel will create a
> new VMSA page.

Yes, and once you understand that I was thinking of a set-once flag
"snp_has_guest_vmsa" it should all make a lot more sense.

Paolo


