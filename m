Return-Path: <kvm+bounces-24159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE78951EA7
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0A851F23132
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776131B4C5F;
	Wed, 14 Aug 2024 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WnmyIZFc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B75C1AED24
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723649739; cv=none; b=Sz0AqS2gI4pCo1E2J+1sZJxyOsGlIySb9WyYx3yuehe444cLn7G3bzQBmimePIxfg9713NLjO+mpO6xBwxGIdPH1V5YmjVhTb1Yxpo1vuadZ+YgHXMuO36Fl6d48p6YcxWUpyVsQHutdaEeo1eSAY6mU1Ae7KUmMhew802sNQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723649739; c=relaxed/simple;
	bh=EgpycVgrTE4OZBnLiqJp21Ba+1k3djK1u2mFfbGKv44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lqldSbznlkyI8tDhnHcgp51ZblYDUHEhfKieqYRqQCTe1NQIhI/H2Pp12iR9ko7BwAQJ++6+Npmr1dDnvjZ05wYCHGoor9Puzy24ngCWjddEQAEQwKBu2xdo0htS2TEeSgV8qNcLM7+8NXgr2nF1It8KMrGcjw9eY/N2w71Z9wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WnmyIZFc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ff5713901eso45960355ad.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723649737; x=1724254537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UJIHPsY2YwVSqQ2bZ1yyvT61kPfWuElvrVIzEKc/5m4=;
        b=WnmyIZFcXbTr7tLEXMQtlCkrj7fG4v7GrQpzYZuYjn7f3Wgsq7HBzhQuOLo2WUMuAe
         DnwtNKX1ZvEHmENpWmG8g9iWnr0x/xQyHycNVos0XHv7r6JzOKqDKsU64j4G5/pIU1u6
         uB/B+QsXC6m7qdxPDj0H4c67wufMSF6o80B8xEvBTFbRGM4TvgzNARut1lLzNxUsRSXx
         NffLZseVk8UK889Jc6dqIyx7bOO/1yuYvgzobuOuEHRSyQtPefLUL3P076+YWa2CwbzI
         7T23lIHEESUA5md4sGMR4ZWW4Q6mypU+WNL/lNUf5zq6AthuCmMqsBKDo02w/Tk9fdDC
         JzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723649737; x=1724254537;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UJIHPsY2YwVSqQ2bZ1yyvT61kPfWuElvrVIzEKc/5m4=;
        b=GgPRY5T8NpAuFeVyO/yH1lokASiFJ75rmG1qbYP5q4aZ+CWx4GaqT90Eq/wbJrOaAR
         vqerQmL0X9gPo3yvW7kb3E5+TdoeRxXoCdRyQnwC/IjsVmYHMqzOiBLXZ1gYfoDnUvJU
         gQuWG1+p2g5WQ/Ei+QgK1OCcFtrEAI1aw3jKG7droNV0sw/HQLTP0YSgv4saAinRbvBa
         yZgWCKe/6CtMpUAfAwqn1u/7NRlILzwaItEy2c3JRxPzbSovsglpB86Lgwh2gLNdcbBj
         w9tz6cLVXDZQuB83FMQjmtILvgA76V7I72SoaCv3mA0I14+dLSABUKNkMSWbd78rBO9b
         E8Ng==
X-Forwarded-Encrypted: i=1; AJvYcCW26mJQmtUNBB3ri4f9F5gvpPMKVChO+bkqhGJiXb7K3ubfjd5WvZVWi8R5oxmsqa2JLTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwMNmxOu4BwYsquspGa/szdFsMwY0xzhoBsHSZYljDceT+MsHL
	EttznD1l6dSULUePXfQ6eayo49B4w1urZ4KJVB/gfUs8Tl0CndPeaLn6sTcluUOQl2CKM1gXtDC
	Utw==
X-Google-Smtp-Source: AGHT+IGjGXRjCPUvJkPrRgmiEyz3DbO4hm3AtgTjq6rNLjZrlosXmtEcLdfbrMhwoJWLy46rEvpZtD/6dLU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6845:b0:201:ec02:2761 with SMTP id
 d9443c01a7336-201ec02294dmr13345ad.0.1723649737244; Wed, 14 Aug 2024 08:35:37
 -0700 (PDT)
Date: Wed, 14 Aug 2024 08:35:35 -0700
In-Reply-To: <CABCjUKD2BAXzBZixrXKJwybEPoZvkmSPfy-vPKMbxcAt0qk0uQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710074410.770409-1-suleiman@google.com> <ZqhPVnmD7XwFPHtW@chao-email>
 <Zqi2RJKp8JxSedOI@freefall.freebsd.org> <ZruSpDcysc2B-HQ-@google.com> <CABCjUKD2BAXzBZixrXKJwybEPoZvkmSPfy-vPKMbxcAt0qk0uQ@mail.gmail.com>
Message-ID: <ZrzOxxu1_-f5ZZ1m@google.com>
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024, Suleiman Souhlal wrote:
> On Wed, Aug 14, 2024 at 2:06=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > > Additionally, it seems that if a guest migrates to another system a=
fter a
> > > > suspend and before updating steal time, the suspended time is lost =
during
> > > > migration. I'm not sure if this is a practical issue.
> > >
> > > The systems where the host suspends don't usually do VM migrations. O=
r at
> > > least the ones where we're encountering the problem this patch is try=
ing to
> > > address don't (laptops).
> > >
> > > But even if they did, it doesn't seem that likely that the migration =
would
> > > happen over a host suspend.
> >
> > I think we want to account for this straightaway, or at least have defi=
ned and
> > documented behavior, else we risk rehashing the issues with marking a v=
CPU as
> > preempted when it's loaded, but not running.  Which causes problems for=
 live
> > migration as it results in KVM marking the steal-time page as dirty aft=
er vCPUs
> > have been paused.
> >
> > [*] https://lkml.kernel.org/r/20240503181734.1467938-4-dmatlack%40googl=
e.com
>=20
> Can you explain how the steal-time page could get marked as dirty after V=
CPUs
> have been paused? From what I can tell, record_steal_time() gets called f=
rom
> vcpu_enter_guest(), which shouldn't happen when the VCPU has been paused,=
 but
> I have to admit I don't really know anything about how live migration wor=
ks.

It's not record_steal_time(), it's kvm_steal_time_set_preempted().  The fla=
g
KVM uses to tell the guest that the vCPU has been scheduled out, KVM_VCPU_P=
REEMPTED,
resides in the kvm_steal_time structure, i.e. in the steal-time page.

Userspace "pauses" vCPUs when it enters blackout to complete live migration=
.  After
pausing vCPUs, the VMM invokes various KVM_GET_* ioctls to retrieve vCPU st=
ate
so that it can be transfered to the destination.  Without the above series,=
 KVM
marks vCPUs as preempted when the associated task is scheduled out and the =
vCPU
is "loaded", even if the vCPU is not actively running.  This results in KVM=
 writing
to kvm_steal_time.preempted and dirtying the page, after userspace thinks i=
t
should be impossible for KVM to dirty guest memory (because vCPUs are no lo=
nger
being run).

> The series you linked is addressing an issue when the steal-time page get=
s
> written to outside of record_steal_time(), but we aren't doing this for t=
his
> proposed patch.

I know.  What I am saying is that I don't want to punt on the issue Chao ra=
ised,
because _if_ we want to properly account suspend time when a vCPU is migrat=
ed
(or saved/restored for any reason) without doing KVM_RUN after suspect, the=
n that
either requires updating the steal-time information outside of KVM_RUN, or =
it
requires new uAPI to explicitly migrate the unaccounted suspend timd.

Given that new uAPI is generally avoided when possible, that makes updating
steal-time outside of KVM_RUN the default choice (which isn,t necessarily t=
he
best choice), which in turn means KVM now has to worry about the above scen=
ario
of writing to guest memory after vCPUs have been paused by userespace.

> With the proposed approach, the steal time page would get copied to the n=
ew
> host and everything would keep working correctly, with the exception of a
> possible host suspend happening between when the migration started and wh=
en
> it finishes, not being reflected post-migration.  That seems like a
> reasonable compromise.

Maybe, but I'm not keen on sweeping this under the rug.  Ignoring issues be=
cause
they'll "never" happen has bitten KVM more than once.

At the absolute bare minimum, the flaw needs to be documented, with a sugge=
sted
workaround provided (do KVM on all vCPUs before migrating after suspend), e=
.g.
so that userspace can workaround the issue in the unlikely scenario userspa=
ce
does suspend+resume, saves/restores a VM, *and* cares about steal-time.

Even better would be if we can figure out a way to effectively require KVM_=
RUN
after suspend+resume, but I can't think of a way to do that without breakin=
g
userspace or adding new uAPI, and adding new uAPI for this feels like overk=
ill.

