Return-Path: <kvm+bounces-20409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C665915270
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 17:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21FB5282032
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2B319B5BD;
	Mon, 24 Jun 2024 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNJO/mQk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC013D51A
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243141; cv=none; b=NFgQyNreWqrhUwfB1cq+VYQa/lSHqOKjFJp9U3k06/UAgkJ1QHtWS8/avzF2KFNYxbPC2Fh6/5bdV4Wo4YwOlTwQwQVqdsqfx54h41sWQzemCvhfy5nvBlie63tdWtJBsnhhUzUpPIsFdyqe/WBk4AYJyqpF0Wxu4T+2SrpnFnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243141; c=relaxed/simple;
	bh=WawAVsLJ2wrVp06E1yLAnPzm2a05JueYQ9ExxNigc3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ogl3zIZu4G8khwkYMZcjZfpORzx8DlsaizXnm+uXglf6q2pf0yFUOD2LDUDTtTWXuqqM84qvZpUBYcCURK7dZ0DV0s7G+WZlY+ij9gb2O8AUULjC4mU5JewMfl1HdgIuWCZb+inxFClPUcs+P/Am0BO77V8K8YMBGcS8vIkqgoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNJO/mQk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c8066074b5so2847270a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719243140; x=1719847940; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WawAVsLJ2wrVp06E1yLAnPzm2a05JueYQ9ExxNigc3k=;
        b=VNJO/mQk+GxT8wD6aDQAXS8zflMK9Ro6iIcPDqtNmNju/Uve6L8KxkevvPePWzhIKh
         Tw6zdF5TkfVl61LpzJNykotarPm3UBBUnbhjVrg7G9mLOvQLmerbGW5lBtqUTiQ5EAyI
         Cx4geUZXKTYDAQUWcRdMZxaimKeNiGM2Pnoo+TwnDzDIyzuRp0aWLQfnyHli7sA+9kIT
         GKlJGys/i1FtUoo5zSkW63wND6PNQiq1V7EJWxrPLkvfeDGvnxVfaCTdNoqFEBKAt95w
         GubCAPj58lvBOJPkRb2SFuxzqnhfIqd3CJ/bKd5vk6vnPTFTTOvGFRK2CkJHetjdAUY7
         ox3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719243140; x=1719847940;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WawAVsLJ2wrVp06E1yLAnPzm2a05JueYQ9ExxNigc3k=;
        b=nRERPEretKVPcDrEk0mr4u7S410UD+VxFrub14e7Hl75VOFEHNVzObWO+UU39rGUHM
         cJCRbtKzp8+x7Q3o49adsd+z5aSjUemCYS5HM4fkUI49KKXM/XfFq+MNWmNMNwx7EGtL
         yQtVm7Vo5U8xLk33heKbPhKll+6DOqdyIgVUgblaynRBYowkgDKtjztFRFkA8eyCyZ41
         ym/5niRdn8lZng3iFDCg/q2Hve4KIi/sa7kRv/+N070IZqaQIZDHlPNa+5NmHFQL96zb
         avCtg9Pu+WZ0TaPxvruBU8oRGDNMMEykK9wgy98b5oUT9K5chTaf96Y8/sWvptgY7gWH
         7rqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUl55u4KEuFD2/gzSr06fDZJ/zm8eCazHxM80lH1Ihv19Jry+BOoFK3tW0d8RI6iazvwkz1kIBVO7MW2lt80px+PYK5
X-Gm-Message-State: AOJu0YziKLaeJkgAGvvZxYuIBtH48Z9QvzNML9/QIK1+Cc/o4Oink31k
	afdUGNTbvNgsv5v99Ab1xw158RB+CXXs9PlA9ZREvRVB8j518kPC7v0dZuYs7NsrPbOgsSkDQOj
	bUw==
X-Google-Smtp-Source: AGHT+IEtazAEW7Z9YwGGcKXL++Dckd0kAEwC6pBQKn1v/nxqOqzOdwWoLb56caKLmrQdFmUesETPkh89cIs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2ecc:b0:2c6:d13f:3f9e with SMTP id
 98e67ed59e1d1-2c8489b9ed7mr123696a91.1.1719243139430; Mon, 24 Jun 2024
 08:32:19 -0700 (PDT)
Date: Mon, 24 Jun 2024 08:32:18 -0700
In-Reply-To: <504fa0a7264d4762afda2f13c3525ce5@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com> <504fa0a7264d4762afda2f13c3525ce5@huawei.com>
Message-ID: <ZnmRgqD6FmXNNzzI@google.com>
Subject: Re: [PATCH 00/26] KVM: vfio: Hide KVM internals from others
From: Sean Christopherson <seanjc@google.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, Anish Ghulati <aghulati@google.com>, 
	Venkatesh Srinivas <venkateshs@chromium.org>, Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2024, Shameerali Kolothum Thodi wrote:
> > This is a borderline RFC series to hide KVM's internals from the rest o=
f
> > the kernel, where "internals" means data structures, enums, #defines,
> > APIs, etc. that are intended to be KVM-only, but are exposed everywhere
> > due to kvm_host.h (and other headers) living in the global include path=
s.
>
> Hi Sean,
>=20
> Just thought of checking with you on this series. Do you have plans to re=
vive this
> series?

Yep!

> The reason I am asking is, on ARM64/KVM side we do have a requirement
> to share the KVM VMID with SMMUV3. Please see the RFC I sent out earlier =
this
> year[1]. The series basically provides a way for KVM to pin a VMID and al=
so
> associates an iommufd ctx with a struct kvm * to retrieve that VMID.=20
>=20
> As mentioned above, some of the patches in this series(especially 1-4 & 6=
) that
> does the VFIO cleanups and dropping CONFIG_KVM_VFIO looks very straightfo=
rward
> and useful. I am thinking of including those when I re-spin my RFC series=
, if
> that=E2=80=99s ok.

Please don't include them, as the patch they build towards (patch 5) is bug=
gy[*],
and I am fairly certain that at least some of the patches will change signi=
ficantly.

I expect to re-start working on the series in ~2 weeks, and am planning on =
actively
pushing the series (i.e. not ignoring it for months on end).

[*] https://lore.kernel.org/all/ZWp_q1w01NCZi8KX@google.com

> Please let me know your thoughts.
>
> [1]. https://lore.kernel.org/linux-iommu/20240209115824.GA2922446@myrica=
=20

