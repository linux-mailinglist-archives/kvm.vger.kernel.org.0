Return-Path: <kvm+bounces-11453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 704A287725E
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 17:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4ABE1F21A89
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 16:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B22822EEF;
	Sat,  9 Mar 2024 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="caNH+9c7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C5315BE
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 16:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710002978; cv=none; b=M4zcNGIqycJ9Ya5Ps14oHRVSpnHGk1niiffwf9RFtC/PfiMkQ/7bpRtrZr5fZfVLnXKL+jZPpa8dgyFNsbWhNFM67vu9bj86KXg4RjZ53HswyDS7fqbOWbz7cK9DQDdt1lpQ9vhcEqXhEFl0FTrl4JMlmIC9KEml0spnI061J70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710002978; c=relaxed/simple;
	bh=vEjrS5jTBnIZ5FzwO9lUX33siNiNs4wHlGKklMXdwVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DTd476/pB3wDQNT2SiUpzdTyw3N/p11edXeet9oTYdwOcozqedNnShJ7EcSnDGiRdo0aMXkcj4IkGJL7cpM9RR2dKaK8b+97pGHjthJME7Lx5cSe0v5h6Ll5sYnLIhUlPV5IKDSvbG9jmrrXeOjCweOgADUrOIO1waXh+G41faA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=caNH+9c7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710002975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hxzKd5BY5dUVKboeSWBZqfH96IBVGZX3rTxUjkAuefw=;
	b=caNH+9c7pqO7GOKiQMIBEB+jPuC3dOC0NFccMYVcXVANGdqfOnlmaHVTh3Ct9MfjS8neru
	858xddURJPCklhU5C0uG9/scJ105qdlaMDZUZLYcdBi152126F3bf4ZAV/TrHt64Yq8UeQ
	blsKoDYCgUWQi4KzkZsrCfI46p7yDRE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-0BWpyrqMPLmHWnyvLAXtGA-1; Sat, 09 Mar 2024 11:49:32 -0500
X-MC-Unique: 0BWpyrqMPLmHWnyvLAXtGA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-412d557cea6so9235725e9.1
        for <kvm@vger.kernel.org>; Sat, 09 Mar 2024 08:49:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710002971; x=1710607771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hxzKd5BY5dUVKboeSWBZqfH96IBVGZX3rTxUjkAuefw=;
        b=CFKxCcdtnpuepmXxIT/jSEjaJ6/IGnKD3bPvIRunIOCeMXSEP0wUggsCQby76PVOot
         sI0EXBeO+JICcA+mqKJAsW5bZ0q8Z+lWIf3yS/THmAjhYs6izPhbbIL0mA5MmULrpOUY
         OGtzrLp2ilK+9x71q877ESSRsU1VbZk1kEwz972yH3x2zZVusWAAbJDaGO7xkYZTvGY/
         jtrO51VA1G19JnvOMXQ1f79FK4T8VrdhO/AOp2I1LVOVgp5EMMmk0e1clhqz2isOEF3X
         nO68T57P2fS4q0t4m7cBUi5vwgnAtnvtdYz6rMFTBfXC5knjuEQAtP+g7EQ4MwsgZ3Ke
         K9lQ==
X-Gm-Message-State: AOJu0YyTvqtoBtFlf6MC63p/lgIlOHoArBPfLU6vDJfW9gMEAGTcWEuo
	esK4MalZ84mFoQpxWvt67H2aS4LNlfiZED1zRRh90SHgeM/enS+bSkWq7KP71oSPcHoDrW9T4cO
	PT3/57MGXroWUsZd4wmhkB7v+BuHdRezmYmXpkx7T/2sj/FuhYVocZF324svCuuoBuxzqS1FbnQ
	j/PEaN28yi5ReICbEE7d0lwnHhuaRJr5eg
X-Received: by 2002:a05:600c:4708:b0:413:1606:ba64 with SMTP id v8-20020a05600c470800b004131606ba64mr1760584wmo.26.1710002970957;
        Sat, 09 Mar 2024 08:49:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeFrOz4NEDXcHS/tILDPmiHsy4NjPvEdxzi2dFwo7mGr98s579GNUjAqDqDJUrZJcl3mwsZpbS0k/uTM4hFMY=
X-Received: by 2002:a05:600c:4708:b0:413:1606:ba64 with SMTP id
 v8-20020a05600c470800b004131606ba64mr1760573wmo.26.1710002970575; Sat, 09 Mar
 2024 08:49:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223211508.3348529-1-seanjc@google.com>
In-Reply-To: <20240223211508.3348529-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 9 Mar 2024 17:49:18 +0100
Message-ID: <CABgObfYjcP1hN-SZgCKBcoAStYAouRfzdGFdbyqhZMak6DKKCg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU(ish) fixes for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 10:15=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Two more MMU-related fixes for 6.8.  The first, and worst, fixes a data
> corruption bug during live migration due to KVM failing to mark a memslot
> dirty when emulating an atomic access.  Luckily, our userspace caught the
> corruption during checksumming after the final pause, but I've no idea if
> QEMU-based VMs have such protection.
>
> The second fixes a long-standing, but recently exposed, issue where yield=
ing
> mmu_lock to vCPUs attempting to fault in memory that is _currently_ being
> zapped/modified can bog down the invalidation task due it constantly yiel=
ding
> to vCPUS (which end up doing nothing).
>
> The following changes since commit 9895ceeb5cd61092f147f8d611e2df575879dd=
6f:
>
>   Merge tag 'kvmarm-fixes-6.8-2' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/kvmarm/kvmarm into HEAD (2024-02-16 12:02:38 -0500)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.8-2
>
> for you to fetch changes up to d02c357e5bfa7dfd618b7b3015624beb71f58f1f:
>
>   KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is chang=
ing (2024-02-23 10:14:34 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 fixes for 6.8, round 2:
>
>  - When emulating an atomic access, mark the gfn as dirty in the memslot
>    to fix a bug where KVM could fail to mark the slot as dirty during liv=
e
>    migration, ultimately resulting in guest data corruption due to a dirt=
y
>    page not being re-copied from the source to the target.
>
>  - Check for mmu_notifier invalidation events before faulting in the pfn,
>    and before acquiring mmu_lock, to avoid unnecessary work and lock
>    contention.  Contending mmu_lock is especially problematic on preempti=
ble
>    kernels, as KVM may yield mmu_lock in response to the contention, whic=
h
>    severely degrades overall performance due to vCPUs making it difficult
>    for the task that triggered invalidation to make forward progress.
>
>    Note, due to another kernel bug, this fix isn't limited to preemtible
>    kernels, as any kernel built with CONFIG_PREEMPT_DYNAMIC=3Dy will yiel=
d
>    contended rwlocks and spinlocks.
>
>    https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com
>
> ----------------------------------------------------------------
> Sean Christopherson (2):
>       KVM: x86: Mark target gfn of emulated atomic instruction as dirty
>       KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is c=
hanging
>
>  arch/x86/kvm/mmu/mmu.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c       | 10 ++++++++++
>  include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+)
>


