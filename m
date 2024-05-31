Return-Path: <kvm+bounces-18548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 272EE8D6892
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 19:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1482283F6E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 17:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0815D17D352;
	Fri, 31 May 2024 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqLkRtyT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1DB17D349
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717178009; cv=none; b=OZTqCR7VLMsaFm5BL0MHRq5wTHpfdWwqEnl1tSmEwYf8ahHbNebDQYmjbknSJRSvUzY2v6r++fFdtvYdnVZ/48R4XzuURG05J2nEml04syLHs2OFmaUmwuXfN9RWcN4nYdHAYYx6Dw4k9g1RnYu7uhWQWKfDLCgibhbwnSLrcx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717178009; c=relaxed/simple;
	bh=/WHl1UhjHzu6oRX6xGx25v4wbxHfCNKSxA+cK6RqVgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W2RVI/adVsGM9P39QZ6dT/FRWN7h8y0qLWU7sVMG6+mzYN69CB5ZOrh4ibNpC/V5zJ9Ohx4v3PLeCZqhBcaF9W+tglgHcAJb59wxQUsMEAN7z6A5vmLc/zNDch1509h4ikfuWf1hB+WEqXpH4hgIntiGjOB2soJPJJEuYGElV1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fqLkRtyT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717178006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2o6F1Dc2l7bB8BlqlMqsKWJyXsVc7vftxsgjVAHDhno=;
	b=fqLkRtyTWSh00Bd0JAKd7Wa99Ds5lYOijgYOdQkrBqfvRlmdW5JscKUmzqPOhwgqQuj/sA
	VLhyaExduLnVo+bBFhiipkz2lPV+mOOCUfm2gfrX4jpqaFGh/DNo1XQk1aN4w91zNT6ZCx
	hY76TawC02Xl42CNOKJO/BhroRo9THI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-yPf7qVImPt-zE7vG8DxoFw-1; Fri, 31 May 2024 13:53:24 -0400
X-MC-Unique: yPf7qVImPt-zE7vG8DxoFw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-35dcb9dcc3bso1302561f8f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 10:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717178003; x=1717782803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2o6F1Dc2l7bB8BlqlMqsKWJyXsVc7vftxsgjVAHDhno=;
        b=WqSAxhg3b6WolUW63SU+l/Uw6ELV0Znhx4EXG/7jSXR2gKgPNLOgHAfUFzOxZ/JshV
         Pgqf93M1gnHazAJZCW+oyncqp3OLQIKvkfFYYcgWLxBtoSVGIdUmRUoKlxuL6WI1HaaA
         Ijy07CHygCRNVK4MvQxgT3btdME97f1hqTkOpSLF53FQnKjn+V1/hmv6LNXzftzzn/1e
         meG8wmocP/nbRN7Wzdff0ti9eqPwuEb7edHL9bm7JRPNNLjbDF956WQxmKy8GRpAjDmq
         bxJx4jvenL72hpL2sBZLGu1Ee6sQHupUKjVyJ7L5J+P2S0DnK7q/+CItH8bMFUK2MwmL
         R+Ig==
X-Forwarded-Encrypted: i=1; AJvYcCVd/2gXksZwayVAIGv192x2sGL+6/0WdCb9y3kGupezc9qf9T0fV5wwAIf2hmodJEk9xlg83UJDE6oroKJWm9U2KA8z
X-Gm-Message-State: AOJu0YzVloz4DfBmjWidotmO52d+LW0uS8PnpGaPH/qmVplr6mgF2wW0
	iWqfH0TByPSf63u5vl2AQItP/q9Q7vj0tb5ocShMjfwVwFcKYVADZ5hMil1r1dlIgpImBkJeSwx
	OJJ+hfgqqWFkV92dd8KLHxhxZo2E5TeS2VesRAHbBkT1ti+KmLr+5chp+QqubK39iurw232bISa
	YW3OYZfCX5Riw+yWOPdBetiHEe
X-Received: by 2002:a5d:6986:0:b0:354:d773:60f3 with SMTP id ffacd0b85a97d-35e0f3633d4mr1994932f8f.71.1717178003528;
        Fri, 31 May 2024 10:53:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUvQqcyiIkwtnOP7/4Ts5GzZAhN3CWLl+H/JLDGqzfx/fyaJ12bWqKoeI3fh+g+da9P7IIA4lAnJO7gs4gvR0=
X-Received: by 2002:a5d:6986:0:b0:354:d773:60f3 with SMTP id
 ffacd0b85a97d-35e0f3633d4mr1994901f8f.71.1717178002821; Fri, 31 May 2024
 10:53:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
 <CABgObfbwr6CJK1XCmmVhp83AsC2YcQfSsfuPFWDuxzCB_R4GoQ@mail.gmail.com> <621a8792-5b19-0861-0356-fb2d05caffa1@amd.com>
In-Reply-To: <621a8792-5b19-0861-0356-fb2d05caffa1@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 19:53:10 +0200
Message-ID: <CABgObfbrWNB4-UzHURF-iO9dTTS4CkJXODE0wNEKOA_fk790_w@mail.gmail.com>
Subject: Re: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 7:41=E2=80=AFPM Gupta, Pankaj <pankaj.gupta@amd.com=
> wrote:
> > please check if branch qemu-coco-queue of
> > https://gitlab.com/bonzini/qemu works for you!
>
> Getting compilation error here: Hope I am looking at correct branch.

Oops, sorry:

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 96dc41d355c..ede3ef1225f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -168,7 +168,7 @@ static const char *vm_type_name[] =3D {
     [KVM_X86_DEFAULT_VM] =3D "default",
     [KVM_X86_SEV_VM] =3D "SEV",
     [KVM_X86_SEV_ES_VM] =3D "SEV-ES",
-    [KVM_X86_SEV_SNP_VM] =3D "SEV-SNP",
+    [KVM_X86_SNP_VM] =3D "SEV-SNP",
 };

 bool kvm_is_vm_type_supported(int type)

Tested the above builds, and pushed!

Paolo

> softmmu.fa.p/target_i386_kvm_kvm.c.o.d -o
> libqemu-x86_64-softmmu.fa.p/target_i386_kvm_kvm.c.o -c
> ../target/i386/kvm/kvm.c
> ../target/i386/kvm/kvm.c:171:6: error: =E2=80=98KVM_X86_SEV_SNP_VM=E2=80=
=99 undeclared
> here (not in a function); did you mean =E2=80=98KVM_X86_SEV_ES_VM=E2=80=
=99?
>    171 |     [KVM_X86_SEV_SNP_VM] =3D "SEV-SNP",
>        |      ^~~~~~~~~~~~~~~~~~
>        |      KVM_X86_SEV_ES_VM
>
> Thanks,
> Pankaj
>
> >
> > I tested it successfully on CentOS 9 Stream with kernel from kvm/next
> > and firmware from edk2-ovmf-20240524-1.fc41.noarch.
> >
> > Paolo
> >
> >> i386/sev: Replace error_report with error_setg
> >> linux-headers: Update to current kvm/next
> >> i386/sev: Introduce "sev-common" type to encapsulate common SEV state
> >> i386/sev: Move sev_launch_update to separate class method
> >> i386/sev: Move sev_launch_finish to separate class method
> >> i386/sev: Introduce 'sev-snp-guest' object
> >> i386/sev: Add a sev_snp_enabled() helper
> >> i386/sev: Add sev_kvm_init() override for SEV class
> >> i386/sev: Add snp_kvm_init() override for SNP class
> >> i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
> >> i386/sev: Don't return launch measurements for SEV-SNP guests
> >> i386/sev: Add a class method to determine KVM VM type for SNP guests
> >> i386/sev: Update query-sev QAPI format to handle SEV-SNP
> >> i386/sev: Add the SNP launch start context
> >> i386/sev: Add handling to encrypt/finalize guest launch data
> >> i386/sev: Set CPU state to protected once SNP guest payload is finaliz=
ed
> >> hw/i386/sev: Add function to get SEV metadata from OVMF header
> >> i386/sev: Add support for populating OVMF metadata pages
> >> i386/sev: Add support for SNP CPUID validation
> >> i386/sev: Invoke launch_updata_data() for SEV class
> >> i386/sev: Invoke launch_updata_data() for SNP class
> >> i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
> >> i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests
> >> i386/sev: Extract build_kernel_loader_hashes
> >> i386/sev: Reorder struct declarations
> >> i386/sev: Allow measured direct kernel boot on SNP
> >> hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
> >> memory: Introduce memory_region_init_ram_guest_memfd()
> >>
> >> These patches need a small prerequisite that I'll post soon:
> >>
> >> hw/i386/sev: Use guest_memfd for legacy ROMs
> >> hw/i386: Add support for loading BIOS using guest_memfd
> >>
> >> This one definitely requires more work:
> >>
> >> hw/i386/sev: Allow use of pflash in conjunction with -bios
> >>
> >>
> >> Paolo
> >
>


