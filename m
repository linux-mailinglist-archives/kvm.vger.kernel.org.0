Return-Path: <kvm+bounces-50123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CFACAE1FF0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1734C7B2E2D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2292E610B;
	Fri, 20 Jun 2025 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5qwWUjU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA7B2BD5AB
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750436071; cv=none; b=Fr88pnYneVxKXZXavxgx02L+dS4eWjrWm6Ay33nGzi6bZ+vRgkMmM2njBYZdgEnoHZSdVeAJc/x1VxpAnnLT+sQqzvYqJnazAF9yBDC68AijOitGtET0IVy+GjxgkcgmtRI4y6ASd78Sqcu4dpaTlZx9chPxpqT6RhIeLAt3f4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750436071; c=relaxed/simple;
	bh=p5D8/aW27kbX0p2wRhLgeswwER2pm71Y7qToCZROLbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fj6uf6SYjT0T62Zhp2huz7kxP2FCfnS4/Z7MhWoBK3GvJ6X9LcLnAwwRpSzMnXzsT9y2zVycTXbu8At4P96zl+zdG3zZXCJZg0BvQfEo5oPFCTwPz0eEYAJKsaIkrXDoE+i1Bin7MhJ95iVuJ8yAxz7etFzh0VsNMs5Te/apaiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5qwWUjU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-235ca5eba8cso342555ad.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750436069; x=1751040869; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZsIAdGa11vtA1TG+jbx7sf0e6kFWPgdhscMjBBcNVA=;
        b=Z5qwWUjU1qpnU22ZkHXGYAKtZW/3yXhrHjep8DKADf30X2Sy9igBzriuXl6ZbPPbLE
         omcu0fW2cVVoOtT8MJL/5NAZOmzHclD2PQAE/ATe+LV3Enevny7IAMBJ/c7bCYd30kQS
         iycjwcpJJt8E165Aib9SZHfEsYxJJ+W4RYrX65KEdoYw7pAoJax5ub2BmcR478pX6BSx
         Sofa7qU6vNiARSFJYK2QzzVqLSNVjxyIh/wTH9xRg3MHvrTQAf7+CEKDZ1NnZfVdztNX
         TEv6ly9AUOLTAaK2GymLxyd8ePMl0agkxlzLvK8cvpdWi2Wzi7do5Ab1uosaa+6FrBnn
         AWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750436069; x=1751040869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZsIAdGa11vtA1TG+jbx7sf0e6kFWPgdhscMjBBcNVA=;
        b=nSEUNQqMQSo74W0eW0WV7tr7DjDFBSujKKyah61z1m5FkrWUAKDBH2lIeez/aLKNY+
         54CwYWcJp0/ji1yr5G3cvVlk72BB6YlxsMptwQrA63cn9Uph96u5w7x8ZsdSgMgg3Vds
         UK5FaiILw4qwVDz0V24luhsRikTjRHOPt8SP30W+mF5JmeTAIzeUHJKOqYi3jA/MAAY+
         QYFaNrtmR01I1U3uS0Ai7VpnXxcFU1X9iCuMbBsdEXXSPwcvpDQH2wPrBZO15nXdSdox
         0L0lGz3gfhPBxvv/I+GCezj7hfTo/G/crFKedilx1ivDGINlXnXX+MNmavdA+WhDD5XX
         bVUA==
X-Forwarded-Encrypted: i=1; AJvYcCVOASSeaIvtdx04PMuy36HeAxN+co9xIX+29s4RS2mWr6A+lqKktQxOCMjrWffGR5H/LR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCqH0QnXZnKfPa2pjXudrR2dCmx6CEfEMllvHN5+UYocC66zy8
	Qmdp5QNEwf8x18HwaCusiKDq4ydbEKbD6RjnpLrMuP0QfHt4OT90t78TiCA42ReCnaEpq+5RSn9
	DKhI5wuOiN0pSTf86Jr10yovfz8vjMM2i7tdjnao2
X-Gm-Gg: ASbGncuAwDA682UEMBThBlA03HT5XN8njQfrL4Z2X6nvpCF8dN6ikihgnNJ58Mz932h
	b6DC6bse0hW5nml5qvLk5o/P/jWtfFCLghiKSfYLauJzuEosn0RgNCFhPNAcX5KjnYn0rPDVVTR
	iqliuD9HKNmM4WxgPo/c/PQ8a9mxg4YL7UJq/Ok1lzwqyrojVlF1086ryBzKw3m3ZsC+r8ap6gJ
	e4=
X-Google-Smtp-Source: AGHT+IFwztnWYZyWskuMZ6QePnr2u2gub9rQqxv7fvGCN7Q2KpBipT2yB0bHqaW9hS41LIkES2H8hNQKyVacSC/6WGg=
X-Received: by 2002:a17:902:dac3:b0:22e:766f:d66e with SMTP id
 d9443c01a7336-237cc9d9a42mr5651145ad.12.1750436068202; Fri, 20 Jun 2025
 09:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com> <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com> <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com> <aFNa7L74tjztduT-@google.com>
 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com> <aFVvDh7tTTXhX13f@google.com>
In-Reply-To: <aFVvDh7tTTXhX13f@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 20 Jun 2025 09:14:16 -0700
X-Gm-Features: AX0GCFvQU5heU-EA5hAAaoycralLiOtD4dbHf5_JljOFwLfRVDkvPnZlUFri348
Message-ID: <CAGtprH-an308biSmM=c=W2FS2XeOWM9CxB3vWu9D=LD__baWUQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Sean Christopherson <seanjc@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025 at 7:24=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jun 19, 2025, Adrian Hunter wrote:
> > On 19/06/2025 03:33, Sean Christopherson wrote:
> > > On Wed, Jun 18, 2025, Adrian Hunter wrote:
> > >> On 18/06/2025 09:00, Vishal Annapurve wrote:
> > >>> On Tue, Jun 17, 2025 at 10:50=E2=80=AFPM Adrian Hunter <adrian.hunt=
er@intel.com> wrote:
> > >>>>> Ability to clean up memslots from userspace without closing
> > >>>>> VM/guest_memfd handles is useful to keep reusing the same guest_m=
emfds
> > >>>>> for the next boot iteration of the VM in case of reboot.
> > >>>>
> > >>>> TD lifecycle does not include reboot.  In other words, reboot is
> > >>>> done by shutting down the TD and then starting again with a new TD=
.
> > >>>>
> > >>>> AFAIK it is not currently possible to shut down without closing
> > >>>> guest_memfds since the guest_memfd holds a reference (users_count)
> > >>>> to struct kvm, and destruction begins when users_count hits zero.
> > >>>>
> > >>>
> > >>> gmem link support[1] allows associating existing guest_memfds with =
new
> > >>> VM instances.
> > >>>
> > >>> Breakdown of the userspace VMM flow:
> > >>> 1) Create a new VM instance before closing guest_memfd files.
> > >>> 2) Link existing guest_memfd files with the new VM instance. -> Thi=
s
> > >>> creates new set of files backed by the same inode but associated wi=
th
> > >>> the new VM instance.
> > >>
> > >> So what about:
> > >>
> > >> 2.5) Call KVM_TDX_TERMINATE_VM IOCTL
> > >>
> > >> Memory reclaimed after KVM_TDX_TERMINATE_VM will be done efficiently=
,
> > >> so avoid causing it to be reclaimed earlier.
> > >
> > > The problem is that setting kvm->vm_dead will prevent (3) from succee=
ding.  If
> > > kvm->vm_dead is set, KVM will reject all vCPU, VM, and device (not /d=
ev/kvm the
> > > device, but rather devices bound to the VM) ioctls.
> >
> > (3) is "Close the older guest memfd handles -> results in older VM inst=
ance cleanup."
> >
> > close() is not an IOCTL, so I do not understand.
>
> Sorry, I misread that as "Close the older guest memfd handles by deleting=
 the
> memslots".
>
> > > I intended that behavior, e.g. to guard against userspace blowing up =
KVM because
> > > the hkid was released, I just didn't consider the memslots angle.
> >
> > The patch was tested with QEMU which AFAICT does not touch  memslots wh=
en
> > shutting down.  Is there a reason to?
>
> In this case, the VMM process is not shutting down.  To emulate a reboot,=
 the
> VMM destroys the VM, but reuses the guest_memfd files for the "new" VM.  =
Because
> guest_memfd takes a reference to "struct kvm", through memslot bindings, =
memslots

guest_memfd takes a reference on the "struct kvm" only on
creation/linking, currently memslot binding doesn't add additional
references.

Adrian's suggestion makes sense and it should be functional but I am
running into some issues which likely need to be resolved on the
userspace side. I will keep this thread updated.

Currently testing this reboot flow:
1) Issue KVM_TDX_TERMINATE_VM on the old VM.
2) Close the VM fd.
3) Create a new VM fd.
4) Link the old guest_memfd handles to the new VM fd.
5) Close the old guest_memfd handles.
6) Register memslots on the new VM using the linked guest_memfd handles.

That being said, I still see the value in what Sean suggested.
" Remove vm_dead and instead reject ioctls based on vm_bugged, and simply r=
ely
    on KVM_REQ_VM_DEAD to prevent running the guest."

This will help with:
1) Keeping the cleanup sequence as close as possible to the normal VM
cleanup sequence.
2) Actual VM destruction happens at step 5 from the above mentioned
flow, if there is any cleanup that happens asynchronously, userspace
can enforce synchronous cleanup by executing graceful VM shutdown
stages before step 2 above.

And IIUC the goal here is to achieve exactly what Sean suggested above
i.e. prevent running the guest after KVM_TDX_TERMINATE_VM is issued.

> need to be manually destroyed so that all references are put and the VM i=
s freed
> by the kernel.  E.g. otherwise multiple reboots would manifest as memory =
leakds
> and eventually OOM the host.

