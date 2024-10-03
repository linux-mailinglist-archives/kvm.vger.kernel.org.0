Return-Path: <kvm+bounces-27848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DE898F116
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 16:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 819B228469C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 14:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ED519F101;
	Thu,  3 Oct 2024 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="raJMaz15"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B940719E7ED
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727964302; cv=none; b=YuOfYG9eR1L2NfaS9PteXNtm2Tn0MfCiRt1tPKV6atzoZYbo8AxVKvWo6QVMHfbbVVUdEX8vRcYf/4eBPy0Aae3Kicp+MpVHr/gcAkjfivupKAwakchia9MiCHH70kl1/Vi5XOH+q7MyHxwF2xawkr7CCBIm0V4JskKtDmc9eWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727964302; c=relaxed/simple;
	bh=6UYDcvYBFo7bse1eNkiSx9sfPfs445QzxMV1Apy/jqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fdeAj3aUneFsF3RNDuhsdYDFRM6w43Px39w2mFVRPI/JBOzPE7diyzfCAeu+De1M9PU7p3CfxMJqhnsI4BrJBWteE7t513GzUnKJua9pyF5LgD+Wr8rEBxZ3dD57F960XVPRVpYH03vJeVNc7x8/eiKGCo//g/0cqBgt+1wcnYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=raJMaz15; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2fad100dd9eso12052921fa.3
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727964299; x=1728569099; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tx5oPoUn5anZwJRYXD1zf/fnqWWX40jtN18OT3B7mk=;
        b=raJMaz15JLPGl7mYKDwIzJjq1l1oDSz6Bf74Fzgpd2AS0Esgqo05g0D8HSFjUzMZWA
         jZ6dZz5SMFllLlMSmy5rtojeO0rJzpgPvE+wuo/uUyaO3PM+BiZaL5lZEWvQ2kYBCQc5
         PRx2pqKgcxzESHGHGVAB8lMPm+Hp+Zztd2Tw6N9DzYYHNyqXc7WEvtY7fpZDqA0SWUYR
         1zF/+XbIqsPsKd15j6uPnFqLs+QeXyLv6BH3k7v7iPwbNuE0m8XXeK8JkTk9bhoh968n
         WhFkYvzfORiu7Q+W+i62a/R036xTj1Ve9Q6syFEuz5Mw6H97dp8csBjNlldxr4cGUptF
         KQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727964299; x=1728569099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tx5oPoUn5anZwJRYXD1zf/fnqWWX40jtN18OT3B7mk=;
        b=QF3H7Sbnp4Tvo7QkOAfgu0Hav0cBPVd35BrZSVihYFdfXzmlHb6Gl2ivNWNwnWeSw6
         JKJzSkWemEkwR7nmeGBZ9jWmgH6G/Dsx+TSDJpy71JxNAnh9ISL2/n7CtMPOfsJUgf33
         vHL9dsj48ghCpGdwsy4V8/lZezZwyKe6m10PvMqUVEqccXo1md9f01YQn8riji+VoQRq
         DY1lk/BiJTnyI9igGBs0K300r1d84xHVnesf3CWBGDehPJElkuMIjVQYL79mAc3hJxy3
         ppoJyqcuPXIqZ6mIEI2XeASu8ehDbTBSa6j77NBJKTiXrKlx2AK7rn7UgXqCN4Lx46b4
         IhCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWO+JNJDxJhaTgxwCXWXZLnUL6+NHyneARda2xqg/SErnvHhssb4iqtAtxIGd6WQFIhRZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQn/CLgw/nryKjWUrcpf5sC2izdOqKq7fkiuQLRA1aVTF6Ngul
	Peh0Rh+gFcdA/h6DJ4V7wWHtGiOkSHb4N5SFg7qxdMHnDnkuIZ++IQkkThW71Ys8bOXGYPVzxyZ
	CQMyoMN+A/o2m9x+3L8p/z9DVgfO/Ncn2+yWA
X-Google-Smtp-Source: AGHT+IGgzXdAa7k/k8qWOeb3a60DbipETGQWRCUSmq7GDnHFuqPbeefrwqYaAVUjcZXWCy2XU7w40S12qYMwu7v3GyI=
X-Received: by 2002:a05:651c:1502:b0:2fa:ddb5:77f4 with SMTP id
 38308e7fff4ca-2fae109929cmr44735491fa.38.1727964298159; Thu, 03 Oct 2024
 07:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com> <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
In-Reply-To: <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 3 Oct 2024 08:04:44 -0600
Message-ID: <CAMkAt6qP+kuzsXYtnE4MRDUVx4sVpFoa+YwBtBRArMcnAfadkw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> >> +static int max_snp_asid;
> >> +module_param(max_snp_asid, int, 0444);
> >> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Te=
xt Hiding");
> > My read of the spec is if Ciphertext hiding is not enabled there is no
> > additional split in the ASID space. Am I understanding that correctly?
> Yes that is correct.
> > If so, I don't think we want to enable ciphertext hiding by default
> > because it might break whatever management of ASIDs systems already
> > have. For instance right now we have to split SEV-ES and SEV ASIDS,
> > and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
> > enable ASIDs on a system.
>
> My thought here is that we probably want to enable Ciphertext hiding by d=
efault as that should fix any security issues and concerns around SNP encry=
ption as .Ciphertext hiding prevents host accesses from reading the ciphert=
ext of SNP guest private memory.
>
> This patch does add a new CCP module parameter, max_snp_asid, which can b=
e used to dedicate all SEV-ES ASIDs to SNP guests.
>
> >
> > Also should we move the ASID splitting code to be all in one place?
> > Right now KVM handles it in sev_hardware_setup().
>
> Yes, but there is going to be a separate set of patches to move all ASID =
handling code to CCP module.
>
> This refactoring won't be part of the SNP ciphertext hiding support patch=
es.

Makes sense. I see Tom has asked you to split this patch into ccp and KVM.

Maybe add a line to the description so more are aware of the impending
changes to asids?

I tested these patches a bit with the selftests / manually by
backporting to 6.11-rc7. When you send a V3 I'll redo for a tag. BTW
for some reason 6.12-rc1 and kvm/queue both fail to init SNP for me,
then the kernel segfaults. Not sure whats going on there...

