Return-Path: <kvm+bounces-39912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1061A4CA8E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDF613AB4AD
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CFF217F32;
	Mon,  3 Mar 2025 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LfRPn5Eg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CAF14A62B
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741024327; cv=none; b=ruCrX2lndVLVsoEzp1S2lJZG+7tWBfQaT2QjXRxg3EvZvwJvE+yDrR6E4HTBC7MciW0ECDUt3xau5CKHzHDAbytlXx2bLxSUYnuMlaqMQMQdSdW4zR8FvXXIcjB/F/L6/gH/CAmf6ZWe8R3eKpfmUBmuYKzZgi8ChI3j0zciV9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741024327; c=relaxed/simple;
	bh=QgP6NlBbs6rnKRSAqZSsqdiq8RcsyUmD/3Z4AUZwGfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AyauF/K0hHrZtu/gYeyW41BRRA/DIE2dnicn/zk6nvxUbL780GPTkRebJ2QD0qG/8eVI4wX+TrYH9r8Li5jOOA+QgTd6LI6T9c2TMXnTCnbb7pMF+UySRwBzLiu+28RbOoytYjtf1mfd/fiQoCjBID8R3r1JMtGJ2eE7YzmBda8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LfRPn5Eg; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e05ac70b61so173a12.1
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741024324; x=1741629124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RaobNh8YJ+j6HIOIVsKGbmDCn24ZoUL5ZjszjFtTcS8=;
        b=LfRPn5EgR3wV0UwXYgBIycUNpBriUrfIdsNTfd19Blv5waSFgbxQsXLDp+nagyB6hK
         6u9H6uwX5FH82P9/KuzpJBlrnQTMoM/CrNizy3BGeM/mmrlpjxcOpRwGNn7bw3LwTpU4
         zcrlJi5xWDuueANLU4W1ZADLFyVDOGm1theH+qQAhuJswXcO6WDgj1/kKQKQ9y3qKiVd
         QDM+7J3L0gVNZj0exbDAeY5/zBOXrUiblQ/J0+m3w3Jj5nX8XiPaCgCke1F1HQdWvQ1+
         9xBhvv1lyf0+jMBXubMJ1y94oewBocUBccGhK5g1wyFhySbnsBPDT8dW+F7A5MkcGRKR
         DryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741024324; x=1741629124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RaobNh8YJ+j6HIOIVsKGbmDCn24ZoUL5ZjszjFtTcS8=;
        b=DAVMkdPelB723pyrRWSmPFcgc3pqBh2jWAI/VXzxboSu2pdm5Gs8qUyFVY3nh+lkUE
         S1vyEY8L49nMndQBAeOF/7aPz38932xPq6KBUKOpXFVpCfNiVPmv/lx9PkU5WLwqWGgq
         gS3kDjl6OONYpH/1FXxFaWH77ccAPKtp51n7YRmFA2akk0/5vrUmnc0e/e1MtQdnRXSZ
         osD8ng1vA/n2gs3KbI5qyL01Xdqb/FC4Xbea0b/ZWFY178hpv3YBX+dlPe6OdAxDL8o+
         XlznOYslJq6lMTu/dxxKp9M0I8VYT/xDx8XVKRT8kkZO6qx5mu/Zwozj2a0Z/5X2tc8i
         hw9w==
X-Forwarded-Encrypted: i=1; AJvYcCWRWqKnfHdvLvlap1WDtMmjX5aUdFv1M6Y3FGhHWetBfPmzlHDoGnpP7kABKk3XtXggIHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIvhAmm4YwtWfVM7mdS4ZhZGCGmKzmnUDjl7mpv2f0ehogXcqz
	M08ZXUdY92s79cB8z3UfiECvZ0pPZJiwnXq2lXD3WIBXbsfoYn2TYTixw7gyTCS2ofyqJkqG0I4
	E2tgIZpyumFD6Seb/Zwpf9iyF6r9/+mLeeoUj
X-Gm-Gg: ASbGncsWRQe3O+om7HaHdrwB1iM3lGzIAh/c0WcDLYFGAlVO+8DZQ2ItwEn6iYboAql
	WBzYXpcTkmXQM+lXQfg+Zuh1+DLWgsqpwlbay55RzA7xeWDTDb6/+YHhXSiNnetHnIaIoZfXA7h
	1qYLX/wPXKyLgOokJv4VyFbqPvrA==
X-Google-Smtp-Source: AGHT+IHPcwKiQzmn4yJOryRL5uTQknzFAuD+P5AADy3IJVvd+Dc/ZHFNhuisMirp59eZXjRx9+fwabi/H/38Lmlxb4g=
X-Received: by 2002:aa7:df06:0:b0:5dc:ccb4:cb11 with SMTP id
 4fb4d7f45d1cf-5e50f8af131mr187775a12.4.1741024323531; Mon, 03 Mar 2025
 09:52:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-2-yosry.ahmed@linux.dev> <Z8JOvMx6iLexT3pK@google.com>
In-Reply-To: <Z8JOvMx6iLexT3pK@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 3 Mar 2025 09:51:51 -0800
X-Gm-Features: AQ5f1Jq-mwSjDevO7kvzGk_6Els8FMXYyGYRIuLa4ds4q8oc7antxsMG0ld7T2w
Message-ID: <CALMp9eSGRLMj-a_ZrzzeLx_jgAea13-to=ZPHu3F+trQq28YjA@mail.gmail.com>
Subject: Re: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 4:03=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +Jim, for his input on VPIDs.
>
> On Wed, Feb 05, 2025, Yosry Ahmed wrote:
> > The ASID is currently tracked per-vCPU, because the same ASID is used b=
y
> > L1 and L2. That ASID is flushed on every transition between L1 and L2.
> >
> > Track the ASID separately for each VMCB (similar to the
> > asid_generation), giving L2 a separate ASID. This is in preparation for
> > doing fine-grained TLB flushes on nested transitions instead of
> > unconditional full flushes.
>
> After having some time to think about this, rather than track ASIDs per V=
MCB, I
> think we should converge on a single approach for nVMX (VPID) and nSVM (A=
SID).
>
> Per **VM**, one VPID/ASID for L1, and one VPID/ASID for L2.

When using EPT on VMX, there is probably no advantage to using one
VPID per VM. The physical ASID is determined by <EPTRTA, VPID, PCID>.
Two different VMs are not going to share an EPTRTA, so they already
have different ASIDs, even if they have the same VPID.

> For SVM, the dynamic ASID crud is a holdover from KVM's support for CPUs =
that
> don't support FLUSHBYASID, i.e. needed to purge the entire TLB in order t=
o flush
> guest mappings.  FLUSHBYASID was added in 2010, and AFAIK has been suppor=
ted by
> all AMD CPUs since.

> KVM already mostly keeps the same ASID, except for when a vCPU is migrate=
d, in
> which case KVM assigns a new ASID.  I suspect that following VMX's lead a=
nd
> simply doing a TLB flush in this situation would be an improvement for mo=
dern
> CPUs, as it would flush the entries that need to be flushed, and not poll=
ute the
> TLBs with stale, unused entries.
>
> Using a static per-VM ASID would also allow using broadcast invalidations=
[*],
> would simplify the SVM code base, and I think/hope would allow us to move=
 much
> of the TLB flushing logic, e.g. for task migration, to common code.
>
> For VPIDs, maybe it's because it's Friday afternoon, but for the life of =
me I
> can't think of any reason why KVM needs to assign VPIDs per vCPU.  Especi=
ally
> since KVM is ridiculously conservative and flushes _all_ EPT/VPID context=
s when
> running a different vCPU on a pCPU (which I suspect we can trim down?).
>
> Am I forgetting something?

TDX? IIRC, TDX requires a unique VPID for each vCPU in a VM.

> [*] https://lore.kernel.org/all/Z8HdBg3wj8M7a4ts@google.com

