Return-Path: <kvm+bounces-14966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18A6F8A838E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD7361F21DB1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B8A13D892;
	Wed, 17 Apr 2024 12:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3zNNnme"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEEE84DF6
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358704; cv=none; b=XQ4xs+HTzAAr9l1ycaNXYmmGWXdTQpJFpYtKOG9v+Ib7YCV+3OPX+IDPR2IiXYbcwImI2c2TZjnggiJAhM+PVDHJNwQ/OF1b08nnh7ePZ4vvmiw4OC4SZw+XpZWducUvmD3BQLrFQISj+jUw1loOg5g4HUhzyY1CClctuT8YcFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358704; c=relaxed/simple;
	bh=odBinATsxiv0QntS3vmmZ+hwTGfp9CbUJ8OWIdv7zD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N2kgXezmt+c0yf4TaaOfBvPR0WzaWeZKsffWivCspXAUMPYkwRBV3sGrmyUOVn0BQZvXeyGb4+/olMRl2UcWH+ZDM0XX4+91O5r8qk6gxGuQT2RJXzHvhjSr1gMgNZrOcK7VVGq0rDtH7lUeZ6gj2/3+LgSDoMCUUd/VHHc+FCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3zNNnme; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Yf7QCrWbLl6GzRDJkeqCAapOLNVCTZM435GPN2S7N8=;
	b=P3zNNnmeD3jBzhjtrxvSjwToDxYlCHS44TZEWcNewZ4+/PXwBCd4N8HtqAU+l29eO62tY+
	8txLuAtllFe7M1dtd3W1xp8OPDHv8IAtOJfcAyoXo3wJhAzxg9qq7eDItoFq7x+jCybIGL
	9u+PkcJyhSTICvbTgXCtrRp/nk6SXxM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-rFWfzS2KOo2Mqix_e13qJQ-1; Wed, 17 Apr 2024 08:58:20 -0400
X-MC-Unique: rFWfzS2KOo2Mqix_e13qJQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2a4fc4cf54dso5667299a91.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 05:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358698; x=1713963498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Yf7QCrWbLl6GzRDJkeqCAapOLNVCTZM435GPN2S7N8=;
        b=gyH1uFXZhIdwYXqN24hdm7E2G0kyV1z8NrUT5mwZMAd9xS64/IR8zpkxziJr209KNb
         ftg7Qk0j8djCI9hmP+TRZdrfRFFx2pmKMEYdn35JykNGUMV3zBo/XDPXDmpfzHSYj8jT
         U26ThcYp61LjUbpQlHgdyVdw4VBHQWj8qRuiRapDSwm1s50zKpppaSeuxB15vttJYKrA
         FmRXGpxJ+qB1QTgEsrcvaQ+Gibf0/m/LjtBujl9yQ3t5Wxgm/kxuS12CsplNSW5TnX7y
         oXVtPY/oh303DlDuKFo307DEte1qCYXixym1Sh7B+dn8Iqp9QljOdLSYqKu1agFmlwC8
         1KlA==
X-Gm-Message-State: AOJu0YyLkcueP6GiljsruY9OI7L8FtA1c1PsUCDmCuNlCw7goINzejQD
	JETwwB3W5S5wpFGcNCS89Nc67ecoeDIchmBhIkDyRql6FbQiI207TIsNSLx/HwePOJkC4f7T5kM
	ebLcp1/G9JpOBSZnPw3hOOpRrPznv8CVweMyWbqksq+5jl4qAa0Au+AgQnl70xNNQdy9ScIN0z7
	kVmAYiiBvfCEQ9JIw0NZHgdYg1C0U5Rt9U
X-Received: by 2002:a17:90b:3c3:b0:2a6:db3:1aa5 with SMTP id go3-20020a17090b03c300b002a60db31aa5mr16000804pjb.18.1713358698436;
        Wed, 17 Apr 2024 05:58:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeusKXHozTa59pxGQzEfxCvxThXecAwYhUkuqOmc1hiPkPd4IGoLD9R12W5ib2l84GuAmF5uPenTcpb+y/FQ4=
X-Received: by 2002:a17:90b:3c3:b0:2a6:db3:1aa5 with SMTP id
 go3-20020a17090b03c300b002a60db31aa5mr16000792pjb.18.1713358698142; Wed, 17
 Apr 2024 05:58:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com> <171270505394.1590014.8020716629474398619.b4-ty@google.com>
In-Reply-To: <171270505394.1590014.8020716629474398619.b4-ty@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 14:58:04 +0200
Message-ID: <CABgObfYHbsb9hySxXbwCTP_mhuKUVdRDFs71XotEB5FAaPeEpQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] KVM: SVM: Clean up VMRUN=>#VMEXIT assembly
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 2:23=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Applied to kvm-x86 svm, thanks!
>
> [1/8] KVM: SVM: Create a stack frame in __svm_vcpu_run() for unwinding
>       https://github.com/kvm-x86/linux/commit/19597a71a0c8
> [2/8] KVM: SVM: Wrap __svm_sev_es_vcpu_run() with #ifdef CONFIG_KVM_AMD_S=
EV
>       https://github.com/kvm-x86/linux/commit/7774c8f32e99
> [3/8] KVM: SVM: Drop 32-bit "support" from __svm_sev_es_vcpu_run()
>       https://github.com/kvm-x86/linux/commit/331282fdb15e
> [4/8] KVM: SVM: Clobber RAX instead of RBX when discarding spec_ctrl_inte=
rcepted
>       https://github.com/kvm-x86/linux/commit/87e8e360a05f
> [5/8] KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host s=
ave area
>       https://github.com/kvm-x86/linux/commit/c92be2fd8edf
> [6/8] KVM: SVM: Save/restore args across SEV-ES VMRUN via host save area
>       https://github.com/kvm-x86/linux/commit/adac42bf42c1
> [7/8] KVM: SVM: Create a stack frame in __svm_sev_es_vcpu_run()
>       https://github.com/kvm-x86/linux/commit/4367a75887ec
> [8/8] KVM: x86: Stop compiling vmenter.S with OBJECT_FILES_NON_STANDARD
>       https://github.com/kvm-x86/linux/commit/27ca867042af

Do we perhaps want this in 6.9 because of the issues that was reported
with objtool?

Paolo


