Return-Path: <kvm+bounces-14304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3766E8A1DF3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE3E628DDDD
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04F783CC1;
	Thu, 11 Apr 2024 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEfCD2hM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C0C81AB2
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856968; cv=none; b=Utm5n3H9qm4pT9WC7EKynAevOpZS3OzMvQ4Is//gWwnklh2E+bBafxXuZj8UpzDDQUFTv8pWBPatfz4blkSMu34ttSULAM+TL3IjZgVyq2HwrlwbT/rZSaVQ3BQw6Js8E4bo7g4T3rrGKKihOnaebx9vTS43j3ihdm0YZpg2QqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856968; c=relaxed/simple;
	bh=bt+GqKfcY9V5WbyskS+tvgvsLYb/5AmqA3IzgkS0aVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HDIq5Oh/epADMNuOaSHKjAatzQVMTGSoh4wDcVJ0Mxnd4B/6Wf/IXWK4nyLR7A54xxGotge4zjpa8pJ1h/YMLmp/V3Eml8KQbxVH9We/lIDfUO9YFo6HwkwCJIGDvok3o0mNGhN1ygLbxcXtG40BfUuA8Wxk1Dou6PO9qJSv1fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NEfCD2hM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712856965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DIjk4c/fhszzcZMfpPvu4kpyLOz8FnjlJrXNssLnszo=;
	b=NEfCD2hM9yg2Lfs6K8dAVeapbR43mbj0sI76gtM3AZw2m3nyKsLvAZC2uhcGFp0UVgo0NL
	elxbcAL5PJtAsQmAvfcJmzbfkC82N/VGZ98zEoTQT5wXU5I5AKMbto/E2DWNo03N21mxok
	t+AHIgz8qlEs62lQKI6jkoiMMXwefKA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-E1o1EQkCMmCfPmROqNEVxg-1; Thu, 11 Apr 2024 13:36:03 -0400
X-MC-Unique: E1o1EQkCMmCfPmROqNEVxg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-346c08df987so64167f8f.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856962; x=1713461762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DIjk4c/fhszzcZMfpPvu4kpyLOz8FnjlJrXNssLnszo=;
        b=xTU8wpVfwA4RoS0WVHPZwiQ+/S4oYQ9/igW07CaPRV88fGiTUAhW1irooooqzBgZUc
         yZatF4Vt9KL7GvexDgeMtOVIMQ0QgFoK0PFSGflxRlk2ZbADSv0ERbu07mipXYjxCUR1
         UeH4RDeToUDlqRCJ9WAS1goNMji4DSxCxa9mznygxeE83S6LjFwEGF1DLkQG07YdcXsN
         r5PTfEXJkqSlhbvaLZJgEgRtSo9eDeM2s51GMXbsCQXagVa+nU+baxGWB2k12nQW/Wc9
         4WGpSadJ8jylj2PDXugj6S5J+ib0O2oiaCY4XYKXIgUyTZQaqoPTSuwvgDZEZjHMJ691
         3NRg==
X-Forwarded-Encrypted: i=1; AJvYcCVgUcOLNbv3dguekQfACrnSoVDo+MX0cQ97ZJx8D6JCNAPR4OtSeNNwxfQ8T3JgAJK3TYaTv0Zjb3N2QWUSXLigQUqE
X-Gm-Message-State: AOJu0Yz61ONMfFmkkDJG78RiZ+0yTsa9zk21gWTzavJ8hKLbk3ZwRRyM
	/+gVUJE69jzZ5sPSoiDQdOXHu9D3UQpQuP/SmRi5ukgkGWFrKQV8Wekp9+zALcITY7hPOpBjovm
	cwtEAaCAshIItu22ums2wy3GFrWhdsOwORs+GjZINeFR1H8XbpOD6D9Cb2JpT/W5YyA/0SnGZlL
	G0u7rlQuKNRLnEFJCAztdCVlJTXuceYjC7
X-Received: by 2002:a5d:4e0e:0:b0:342:d5ac:c712 with SMTP id p14-20020a5d4e0e000000b00342d5acc712mr357863wrt.7.1712856961651;
        Thu, 11 Apr 2024 10:36:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHH7zr7ewwqQvkgoFs4I1YGBqw7RyH4tb4i7r/FkTNp3vbt7t8CroLWOTHf82u+iLBZS0JoMV+Ji4RpTKtTANg=
X-Received: by 2002:a5d:4e0e:0:b0:342:d5ac:c712 with SMTP id
 p14-20020a5d4e0e000000b00342d5acc712mr357846wrt.7.1712856961295; Thu, 11 Apr
 2024 10:36:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240409230743.962513-1-michael.roth@amd.com>
In-Reply-To: <20240409230743.962513-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Apr 2024 19:35:49 +0200
Message-ID: <CABgObfYZTocoZJ9PHgfZYZg2k8cwNtmbciOs_HwBpGmsZ-wbJg@mail.gmail.com>
Subject: Re: [PATCH for-9.1 v1 0/3] Add SEV/SEV-ES machine compat options for KVM_SEV_INIT2
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, 
	Larry Dewey <Larry.Dewey@amd.com>, Roy Hopkins <roy.hopkins@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 1:08=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> These patches are also available at:
>
>   https://github.com/amdese/qemu/commits/sev-init-legacy-v1
>
> and are based on top Paolo's qemu-coco-queue branch containing the
> following patches:

A more complete version of patch 2 was already on the list, so I
queued 1 and 3 to qemu-coco-queue.

Thanks!

Paolo

>
>   [PATCH for-9.1 00/26] x86, kvm: common confidential computing subset
>   https://lore.kernel.org/all/20240322181116.1228416-1-pbonzini@redhat.co=
m/T/
>
> Overview
> --------
>
> With the following patches applied from qemu-coco-queue:
>
>   https://lore.kernel.org/all/20240319140000.1014247-1-pbonzini@redhat.co=
m/
>
> QEMU version 9.1+ will begin automatically making use of the new
> KVM_SEV_INIT2 API for initializing SEV and SEV-ES (and eventually, SEV-SN=
P)
> guests verses the older KVM_SEV_INIT/KVM_SEV_ES_INIT interfaces.
>
> However, the older interfaces would silently avoid sync'ing FPU/XSAVE sta=
te
> set by QEMU to each vCPU's VMSA prior to encryption. With KVM_SEV_INIT2,
> this state will now be synced into the VMSA, resulting in measurements
> changes and, theoretically, behaviorial changes, though the latter are
> unlikely to be seen in practice. The specific VMSA changes are documented
> in the section below for reference.
>
> This series implements machine compatibility options for SEV/SEV-ES so th=
at
> only VMs created with QEMU 9.1+ will make use of KVM_SEV_INIT2 so that VM=
SA
> differences can be accounted for beforehand, and older machine types will
> continue using the older interfaces to avoid unexpected measurement
> changes.
>
> Specific VMSA changes
> ---------------------
>
> With KVM_SEV_INIT2, rather than 0, QEMU/KVM will instead begin setting th=
e
> following fields in the VMSA before measurement/encryption:
>
>   VMSA byte offset [1032:1033] =3D 80 1f (MXCSR, Multimedia Control Statu=
s
>                                         Register)
>   VMSA byte offset [1040:1041] =3D 7f 03 (FCW, FPU/x86 Control Word)
>
> Setting FCW (FPU/x86 Control Word) to 0x37f is consistent with 11.5.7 of
> APM Volume 2. MXCSR reset state is not defined for XSAVE, but QEMU's 0x1f=
80
> value is consistent with machine reset state documented in APM Volume 2
> 4.2.2. As such, it is reasonable to begin including these in the VMSA
> measurement calculations.
>
> NOTE: section 11.5.7 also documents that FTW should be all 1's, whereas
>       QEMU currently sets all zeroes. Should that be changed as part of
>       this, or are there other reasons for setting 0?
>
> Thanks,
>
> Mike
>
> ----------------------------------------------------------------
> Michael Roth (3):
>       i386/sev: Add 'legacy-vm-type' parameter for SEV guest objects
>       hw/i386: Add 9.1 machine types for i440fx/q35
>       hw/i386/sev: Use legacy SEV VM types for older machine types
>
>  hw/i386/pc.c         |  5 +++++
>  hw/i386/pc_piix.c    | 13 ++++++++++++-
>  hw/i386/pc_q35.c     | 12 +++++++++++-
>  include/hw/i386/pc.h |  3 +++
>  qapi/qom.json        | 11 ++++++++++-
>  target/i386/sev.c    | 19 ++++++++++++++++++-
>  6 files changed, 59 insertions(+), 4 deletions(-)
>
>
>


