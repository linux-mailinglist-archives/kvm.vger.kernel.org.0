Return-Path: <kvm+bounces-40300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EC5A55D54
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 02:53:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6967016F967
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 01:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1709D1624E0;
	Fri,  7 Mar 2025 01:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GJsnaG9H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0E92F32
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 01:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741312420; cv=none; b=k4VYM5iEDfsBLxcbH+QydSUh1GpAk5RpKLvkQ6sj4QGJ5EN4TBj2p5p60YqhgRt7o5MZAHyQ6Iu++MmpyNeimc4wH3kTVQmxeT31gzZP5waI+m9goBziKq98wGjx5SuZzRs127fgSH1m/xeOV+amJlyFsafoVMogUB0nkff0x/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741312420; c=relaxed/simple;
	bh=XnKYclYppJMRA9DFHu/pNYSpK/EG2IzbSQM3Hu9jSwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UI3/QIK8/6EKDLp+iFC1mYRE/N5j1XFMdZS1OcxtcbrjKOCgsfRkLck/JJ33E5J5YFP/IFNBQ6IY3KXcZ0Bs/hXqY8NGC8VLQrfZmKMTMb66fRIBdHEkFBVFgVZq7dNhiz/CQgg4vCRGRY58Zbny8faj3Gz95XVNbSM8YOt36kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GJsnaG9H; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6f74b78df93so14259197b3.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 17:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741312417; x=1741917217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCUWTnZ3pjMxXxrtYneWY/ixjpdncKxk56nrINlFuLI=;
        b=GJsnaG9Hrs+RDgkFYpzgBDFXPJmDylRebmNu5cyGdovExd7iJmW/ts3gPs6Tw+KqGt
         2ToHSHFL4iC5s7RV/1LYQ5IdvqQKwWeeDN0sJTCvLOh5h9VqApo4A7MeBe0DdFWr/m/8
         fTlQBqOitXgEa9m5+2GzV2mUtzZaOe1Iu9x0iM3rNjo32xJLXxRETRHZVUcSvp+0YPqe
         Wpemdj+MApPt6BsmyahSJgozC2kDNgG1SD5RmVKEJpfo7kBkjux5F87f6rnlnC0mIvnH
         GI+yh/dXeKRAe6ySZJdLIDSQNq8S97LeaJYOMaWKTCuIxbzwTlUu1m2vGhV+c04Ja7/F
         sC+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741312417; x=1741917217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCUWTnZ3pjMxXxrtYneWY/ixjpdncKxk56nrINlFuLI=;
        b=bs9zWhOSuusEMa40+wVMFBgQsQtkpP9bKBpsRUWZEIRgWBefi0T06LR7IXQ104HG+P
         xY9pt0W5dC2eG7LzB8Iq2vIUxoiSgZFyxjWfyn2FBrqHVzlXP49nF0qp8bMLd4SIlLvl
         UV4tv1U+lbJ14bbIBl5CnARwKFDdEIBQBXMwlVBtg9pQkIsEe5DYNCyaPLAwK7KBx51v
         9FQVQ1Hw/kodNmanyitTy/RTt9OkMMG/ra2olBPB56KaoSaYZw+/RZoSKM/9MioH027+
         3djYrGSfkOZqKyfN7pyhyW3kA8T4MrwKwMZT8YsmK02UDQ2QnqEEyETSoJbt7GZTczvr
         FRKA==
X-Gm-Message-State: AOJu0YzVcbgpDS4T7JmqlHApSUNumWOQhJvZJOpzZNd4h7WMdoQZ4dsc
	qfTkK0Y10cr11IRRDl57hV1UG76qrPt8qVbrdmq0FvHpqIpvmkgASS/p0qDSf1TMrIurd6tD4aS
	7pNc0AfrQYSPHeywAb/Ny++EFm21EeNGjV2HA
X-Gm-Gg: ASbGncvWwGqoTYOqeLOK8M4CXU1jsE01t4gpG9EIjFCf67tmSa1znFgqj+jTdI0aw9x
	8qOTW+/gjrr3mvP+0r4JgPomSqXaGLkyvjixKlFe7T2BpozYWiq6pUNdH5xUDJCIkL6QT+XxjWC
	X74PdXpfH8RTpFyG/Up8TTBhptFfZk0b4q09TmAPCD8hlkOv7DvxKIivC5
X-Google-Smtp-Source: AGHT+IEtSS+mpRhJKleMpaB3DbpAHfO3E4j/SkeoZwuqMVYrLHLfF7wB8kyvYfYSwwJ3d+GpQSCY5aetuJOZKgzlNfo=
X-Received: by 2002:a05:6902:983:b0:e5e:700:92f5 with SMTP id
 3f1490d57ef6-e635c1008c7mr2547657276.2.1741312417396; Thu, 06 Mar 2025
 17:53:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com> <20250303171013.3548775-4-tabba@google.com>
In-Reply-To: <20250303171013.3548775-4-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 6 Mar 2025 17:53:01 -0800
X-Gm-Features: AQ5f1JrvF2iBlwi15PAxAXyxJXz24tpZUppjb6AWgrXV7KSzTqTZn53OQRuxcas
Message-ID: <CADrL8HUAkzUdZEunCXgdECD+cNZi_O+HBdQZdN=EGiX_OuQJOg@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 9:10=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote:
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +       struct inode *inode =3D file_inode(vmf->vma->vm_file);
> +       struct folio *folio;
> +       vm_fault_t ret =3D VM_FAULT_LOCKED;
> +
> +       filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +       folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);
> +       if (IS_ERR(folio)) {
> +               switch (PTR_ERR(folio)) {
> +               case -EAGAIN:
> +                       ret =3D VM_FAULT_RETRY;
> +                       break;
> +               case -ENOMEM:
> +                       ret =3D VM_FAULT_OOM;
> +                       break;
> +               default:
> +                       ret =3D VM_FAULT_SIGBUS;
> +                       break;

Tiny nit-pick: This smells almost like an open-coded vmf_error(). For
the non-EAGAIN case, can we just call vmf_error()?

> +               }
> +               goto out_filemap;
> +       }
> +
> +       if (folio_test_hwpoison(folio)) {
> +               ret =3D VM_FAULT_HWPOISON;
> +               goto out_folio;
> +       }
> +
> +       /* Must be called with folio lock held, i.e., after kvm_gmem_get_=
folio() */
> +       if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> +               ret =3D VM_FAULT_SIGBUS;
> +               goto out_folio;
> +       }

