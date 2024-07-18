Return-Path: <kvm+bounces-21858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95348935115
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3E98283061
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 17:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C965C14535D;
	Thu, 18 Jul 2024 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LmOsclIT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459F144D10
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721322553; cv=none; b=XuxQuaQoZKkYR4lckAG1+HUh3cP7oW8ZP/HMbAQdOgs21k7QBCEbNyS71veDf7ZK4BmLl3HAJ1lmk1lMzR4DSLA+I9QPfFt3VmCRk4jTUOU4dfBGgrbIppogA83UMrPM5AEWf9kWwREND9ylwxJW6EWS/PvUMAjvR/Sez8VukhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721322553; c=relaxed/simple;
	bh=hfptMg5b01LvLxc2SG4Uz4PY1885pejHBHnSI3jHNo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AttpQti12X5uXlsm4ZYVTAZqsZwUj3LvRSj06pv5wNxZ+dEmRM6bm/EIn0O+zsWucPdJX+12PhpNlFYIwrct5rR03ijpwNcwAogGC2GhAdDQusXXB3ghy7x2IkNPK0kZl9Oo1qyh/4ju4qazJ2xvhvFspjOZ++Cqxg+jAeL2hYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LmOsclIT; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fb67f59805so6505ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721322551; x=1721927351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfptMg5b01LvLxc2SG4Uz4PY1885pejHBHnSI3jHNo4=;
        b=LmOsclITNClWJfccpQJt2d2iHpl/UCf69BGG/qXacLLcSjuk07wmb42ijg/DHol4Wu
         zzaRt3nYlqxI32p6P3fknA9c1Jnu/XObYxmdhrhY+cnHyFFJz8qWMKvrgTMYmwvSPLuE
         7MDiShHq/qqCzvOHCZY+Tb7HyCB0yk+1whAA60XKsDW47S0cCQ3Q3T/7DXV6FBI/DQRf
         +PF+YmJLrKj0iFvY6MQNv8MLcwJEViYdCZ4QPYVB9536ExbIn4vAiqZy4ntmZD6RFhfi
         DAWXSSyCB4AJwuH/TkY1UKengFCJrD3kW9BupQa17aMPlprq0yK/DC7p8FFd91bO3KPe
         yyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721322551; x=1721927351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfptMg5b01LvLxc2SG4Uz4PY1885pejHBHnSI3jHNo4=;
        b=E959RfxnryFb6JiBcblzc7lGz5yA4dK+uCMWba+3y0Eir5CUh8WrQjbL0REn07136k
         4OCsRmPSKIOj8dMS48qRezNvBW/6zEvb+EUBWVte4PUyRYz9TXKg7vdDIruy83H1hvnX
         BIWSxEiflHzG91AhxxhNz3A3n9vL/ZvG59fGnieIy9hveA2tSu/hIlqxPPFNAR3JQGwA
         9liY87iGtfZU+D3QgTWBYGYfJFEbgndMqU0UtnoWpG5ssXrO7yn/u6mStohw4d+60XHe
         1lhU2rZ3PgfFns69JHRseYaxwRuYrmnetisr6HIyMx1/YWXDLOlx1jfKZgNbmlBrPW6V
         UT/A==
X-Forwarded-Encrypted: i=1; AJvYcCWKEEwdppltaspFqfd2CwJoW5nfJ0IAN0xCCujhrXSSEcceT4nhzkRheqhQRmdY5Iq7DUIrrKsouS6wz8cxyuR1IlPB
X-Gm-Message-State: AOJu0YyRYeZk73g7aKKEXa66ZMhe5SAoIbv897ZVVrui3gATPEnHcdla
	Oa5KclTlkPSCu4Je4b/Hzl4dnjQigEK1k3C+lohf9bkLMdgOZoz/eaXmWWMpPCCsyHeZbiBIXtU
	pF4QXPELMVb8BT2+poDqu0PLb1+Iby7ZiO2GK
X-Google-Smtp-Source: AGHT+IFyQOwgVWytrps02GnyGzCKWAzKQb9jdGG6O5HjYS2fonQnaQCgjBSaqq+ZRXTyamSyDlrVjFSIa0H9hip10Ho=
X-Received: by 2002:a17:903:183:b0:1f7:1c96:d2e8 with SMTP id
 d9443c01a7336-1fc5f58803emr2989145ad.10.1721322550399; Thu, 18 Jul 2024
 10:09:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-9-jthoughton@google.com> <DS0PR11MB6373C1BE8CF5E1BCC9F2365BDCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB6373C1BE8CF5E1BCC9F2365BDCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 18 Jul 2024 10:08:33 -0700
Message-ID: <CADrL8HVDUG7OSN2ERmmiXeg8eT8D6edoSiqYKsnjAnVbhGAX9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 8:34=E2=80=AFAM Wang, Wei W <wei.w.wang@intel.com> =
wrote:
>
> On Thursday, July 11, 2024 7:42 AM, James Houghton wrote:
> > The first prong for enabling KVM Userfault support for x86 is to be abl=
e to
> > inform userspace of userfaults. We know when userfaults occurs when
> > fault->pfn comes back as KVM_PFN_ERR_FAULT, so in
> > kvm_mmu_prepare_memory_fault_exit(), simply check if fault->pfn is inde=
ed
> > KVM_PFN_ERR_FAULT. This means always setting fault->pfn to a known valu=
e (I
> > have chosen KVM_PFN_ERR_FAULT) before calling
> > kvm_mmu_prepare_memory_fault_exit().
> >
> > The next prong is to unmap pages that are newly userfault-enabled. Do t=
his in
> > kvm_arch_pre_set_memory_attributes().
>
> Why is there a need to unmap it?
> I think a userfault is triggered on a page during postcopy when its data =
has not yet
> been fetched from the source, that is, the page is never accessed by gues=
t on the
> destination and the page table leaf entry is empty.
>

You're right that it's not strictly necessary for implementing
post-copy. This just comes down to the UAPI we want: does
ATTRIBUTE_USERFAULT mean "KVM will be unable to access this memory;
any attempt to access it will generate a userfault" or does it mean
"accesses to never-accessed, non-prefaulted memory will generate a
userfault."

I think the former (i.e., the one implemented in this RFC) is slightly
clearer and slightly more useful.

Userfaultfd does the latter:
1. MAP_PRIVATE|MAP_ANONYMOUS + UFFDIO_REGISTER_MODE_MISSING: if
nothing is mapped (i.e., major page fault)
2. non-anonymous VMA + UFFDIO_REGISTER_MODE_MISSING: if the page cache
does not contain a page
3. MAP_SHARED + UFFDIO_REGISTER_MODE_MINOR: if the page cache
*contains* a page, but we got a fault anyway

But in all of these cases, we have a way to start getting userfaults
for already-accessed memory: for (1) and (3), MADV_DONTNEED, and for
(2), fallocate(FALLOC_FL_PUNCH_HOLE).

Even if we didn't have MADV_DONTNEED (as used to be the case with
HugeTLB), we can use PROT_NONE to prevent anyone from mapping anything
in between an mmap() and a UFFDIO_REGISTER. This has been useful for
me.

With KVM, we have neither of these tools (unless we include them here), AFA=
IA.

