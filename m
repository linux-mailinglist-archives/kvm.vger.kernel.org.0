Return-Path: <kvm+bounces-3693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D0D807106
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 894851F215D0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 13:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AB93A8D8;
	Wed,  6 Dec 2023 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IBj8EMkJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EE8C7
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 05:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701870088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GZjGNK8/DC3s6qdUCadE3q9dujctUbyOyDNt2HX170=;
	b=IBj8EMkJCfD2kMuRfT1cMJs/+5dtsUwIgeE0AsdUTweYAmYvRXd1lat+dhMHxkNriPeouf
	dyNbpnMZdgfLEa16EgAZ3i/PbzgJ7m4KRv/p3LRPmB86WA0QvPB/PjZbma7i/yX5kI+b9R
	Ry5Rd5doNvB8kGzLwl3FQwa3P0MiWJE=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-Dyeo0AveMoG2Tv4E0_svnw-1; Wed, 06 Dec 2023 08:41:27 -0500
X-MC-Unique: Dyeo0AveMoG2Tv4E0_svnw-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4b24730bfefso2215649e0c.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 05:41:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701870086; x=1702474886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GZjGNK8/DC3s6qdUCadE3q9dujctUbyOyDNt2HX170=;
        b=flpNASCTfk7Yv59hUCVoII99hDOB/WQENVqG6W+MUnbwxY1cvcDQMBefnj9JArNI64
         LJpu4kNfbJLAx6j7pQf2rD7T7lB2jAe7Z7DY8gcewE1e1spJv4pxorVPsraeN0RBK5ww
         zIVu0REAdTlTAtFlw1QUT6ipASnHGOjpmyg3l4wlyYL6xknFaFdmQvewl73UCTljiu46
         yMRkWZp3irKYWCWBVaJpPSkYs8cBsaBY3ZqhOpqW5zYmG1hIsQmAnDU5+SDP6ILwvfsY
         HKjzQhKAvcSNnbFchtAg/+RxcpdPDJCfBopdKgXVlvxVQVv4hq8mQNdTG56j/CJ+LkRM
         4yjA==
X-Gm-Message-State: AOJu0YwCYQn5rOZqX6X1LIzjXe5CXMFo19Ke5+puvL5DplJ+mxHjVIMm
	aaOPUSWd+Spo8jRArqL6NTbNTSVMkaI8OYB97els9aqVQZq66UiI+UvlFgc4OQhW2hB7KPzjDP+
	QRGD0/ULfVPItCc6s0hwXdquRNJL2
X-Received: by 2002:a05:6122:2001:b0:4b2:8e2a:4c2 with SMTP id l1-20020a056122200100b004b28e2a04c2mr951304vkd.3.1701870086651;
        Wed, 06 Dec 2023 05:41:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMIdluJ65K5e+nf0OBCTBEj1801D04ARu3sY9ieE5OU9sLovvMyZGzWqcks9pKUkwpoQQx8b9elR3/fAOcZlI=
X-Received: by 2002:a05:6122:2001:b0:4b2:8e2a:4c2 with SMTP id
 l1-20020a056122200100b004b28e2a04c2mr951298vkd.3.1701870086456; Wed, 06 Dec
 2023 05:41:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205222816.1152720-1-michael.roth@amd.com>
In-Reply-To: <20231205222816.1152720-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 6 Dec 2023 14:41:13 +0100
Message-ID: <CABgObfb0YmHuw6v9AGK6FpsYA1F3eV2=4RKaxkmVrp97QCDM3A@mail.gmail.com>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 11:28=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> @@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
>      env->gdt.limit =3D sregs.gdt.limit;
>      env->gdt.base =3D sregs.gdt.base;
>
> +    cr0_old =3D env->cr[0];
>      env->cr[0] =3D sregs.cr0;
>      env->cr[2] =3D sregs.cr2;
>      env->cr[3] =3D sregs.cr3;
>      env->cr[4] =3D sregs.cr4;
>
>      env->efer =3D sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |=3D MSR_EFER_LMA;
> +        }
> +    }

There is no need to check cr0_old or sev_es_enabled(); EFER.LMA is
simply EFER.LME && CR0.PG.

Alternatively, sev_es_enabled() could be an assertion, that is:

    if ((env->efer & MSR_EFER_LME) && (env->cr[0] & CR0_PG_MASK) &&
       !(env->efer & MSR_EFER_LMA)) {
        /* Workaround for... */
        assert(sev_es_enabled());
        env->efer |=3D MSR_EFER_LMA;
    }

What do you think?

Thanks,

Paolo

>      /* changes to apic base and cr8/tpr are read back via kvm_arch_post_=
run */
>      x86_update_hflags(env);
> @@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
>  {
>      CPUX86State *env =3D &cpu->env;
>      struct kvm_sregs2 sregs;
> +    target_ulong cr0_old;
>      int i, ret;
>
>      ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> @@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
>      env->gdt.limit =3D sregs.gdt.limit;
>      env->gdt.base =3D sregs.gdt.base;
>
> +    cr0_old =3D env->cr[0];
>      env->cr[0] =3D sregs.cr0;
>      env->cr[2] =3D sregs.cr2;
>      env->cr[3] =3D sregs.cr3;
>      env->cr[4] =3D sregs.cr4;
>
>      env->efer =3D sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |=3D MSR_EFER_LMA;
> +        }
> +    }
>
>      env->pdptrs_valid =3D sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>
> --
> 2.25.1
>


