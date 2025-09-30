Return-Path: <kvm+bounces-59206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22866BAE33E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 931AE7A79C3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4BD30CB53;
	Tue, 30 Sep 2025 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmWjH5Ps"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CA62116E0
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253646; cv=none; b=fR6TTpnurrCFLK8GXjNo5sWc1irY9RtW7z/5PRP74tzAO+mqcWb6NKW28iEB6L9j+pfYeLYuWdDa/xnY1JJMXtgWIm3ySvy6s+vCdwtEBkp5r4hCortMHtQHKfRi1rFrx25zU6BEjMcKv0HfhwEi1gQuE2BtHhve4k+qSSiJJIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253646; c=relaxed/simple;
	bh=K4Kj52Sc3WHaxQWWb9WPz4PfQKbfYsJ2LEia1X3xeUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dbSNV3Wf1AD/JW8GUG/P2EcM6kR1b0pOHnwk5qpYe7cAClFP8VugXSCpRPRalPsggeibt/zmULEJOpYOaIfBFou4IwmPVRnm3GNwJvbw1lx+Nw3Gr/STg37ZrdLalhH0eND2uwuE5B/RIBwjc6NDnJggSzoWj14HR1f4/w/tCOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CmWjH5Ps; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759253644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+AjrEkys0A8lAun7rL+EyAWl7XyGEJmHCLWyCAkReQ=;
	b=CmWjH5PswNok5uzmOgWhAWgunIZ6iVHfsvVPFmb1kHlhdIvK8vhuqVWdrqnXONqwmaCzx4
	0gZ5M4u+e62dzPWlSkc+xYNmx936ImUVmR7L56ab63zLV+kw0qsXKyzumExBbZ2NkjKdTa
	MlJC6M2E+8k3cisRyZH1m9eWBPHA/eI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-mgA9Rbs5M7id_Iz1FtkGvQ-1; Tue, 30 Sep 2025 13:34:03 -0400
X-MC-Unique: mgA9Rbs5M7id_Iz1FtkGvQ-1
X-Mimecast-MFC-AGG-ID: mgA9Rbs5M7id_Iz1FtkGvQ_1759253642
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e997eb7232so2694849f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253640; x=1759858440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+AjrEkys0A8lAun7rL+EyAWl7XyGEJmHCLWyCAkReQ=;
        b=YjPPUH+C+3iL5oNNpA7mtcAA5/LjSH6q0GEzvGjTWH7MTgqRFBFnFkjDoId5GRVIUC
         Wh/CjHUVIlXWSRKc7+UDJuwNDmjHEe85ZO9MYuiRDvnYOFlPqr3iH4WixL1kC6Z+Sh4V
         4HvWxZCJxvhZSEpzegKwjDWlQP+0Q/t4bO2t4sieR19on56YxVoi8yU1C7X7S5p54I2g
         sOTGJcEAM8GFrO3d81wYJusR0Mrncwak54OvqXl8w05F8EOQ5IzwcVe9cRtyhGEomgBs
         q5ZrEuXhYWLBezeoN2KyNm94HmXO6YE1wn4tnviInEQ9kiOet6rUf5GV5fJDeMw9iYEP
         emeg==
X-Gm-Message-State: AOJu0Yx7n+7RqKQiYWH7L3NBX4GqcST1giB/4Zai1jcDbwKXJ2epgsfj
	UU+t84WvqIccpNnrZ1aMV2qjk16v83kG9zFqbtquZzsJkprk/Do2T17JV5dnvLavk5hQZwvNKS8
	iaxiiv2Jua29S4uPQ9a4amGizkBNUZm74aVBOnYZgP06+1m26+bZEzF8SeVda7CBP6/SGAh9s55
	1WWHTKXhZrD+u7kcG6ZZlX2mBs3kCnyYY3ZZrF
X-Gm-Gg: ASbGncuCiK7b2RbEY1M3g+tmzcXB90JPNLgvBX09GU6/3mv6WE0jf/Ww1qxWxu+/ddl
	k6ViDpwWxowA9CmrdGVKbyn+HTno5/lIOd7UxhS5nEFq8sXa3DIUBhOdCA4uYNDyJ/l7/WXrIW2
	bXnuR1thfP8oTuSpWmaA4JANbtB3Vj4fBr1R94K2wZJsiDGx72Zr21NVjBQHupSbt7Cl6yroqBL
	DCS7cWmwFOYSBSIWvyMoxGnIY2i08Iq
X-Received: by 2002:a5d:588f:0:b0:3ff:d5c5:6b0d with SMTP id ffacd0b85a97d-425577ed88bmr408192f8f.4.1759253640468;
        Tue, 30 Sep 2025 10:34:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3esXsCWsgGFUCgiPEWX5HrwSCxn5E9orJMEqPLqizpyiB5xgXSXOTU3gUaxW1EpxeDlmCfno1tPzhUpXUOcY=
X-Received: by 2002:a5d:588f:0:b0:3ff:d5c5:6b0d with SMTP id
 ffacd0b85a97d-425577ed88bmr408176f8f.4.1759253640090; Tue, 30 Sep 2025
 10:34:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-4-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:33:48 +0200
X-Gm-Features: AS18NWAKmn_gozvK6e2eroDMudheoXMPsQ32SpXHvGeu2n7Tv2i2n7iC9U7Nkh4
Message-ID: <CABgObfaJ7ZBVhY5Fcmh9rfa6w8ji8v33JShUjb5-uZQVZRWHzg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Recover TDP MMU NX huge pages under read lock, and fix two (interruptible=
)
> deadlocks in prefaulting and in the TDX anti-zero-step code (there's a
> selftest from Yan for the prefaulting case that I'll send along later).
>
> The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0=
b9:
>
>   Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.18
>
> for you to fetch changes up to 2bc2694fe20bf06eb73524426e3f4581d7b28923:
>
>   KVM: TDX: Do not retry locally when the retry is caused by invalid mems=
lot (2025-09-10 12:06:35 -0700)

Pulled, thanks.

> ----------------------------------------------------------------
> KVM x86 MMU changes for 6.18
>
>  - Recover possible NX huge pages within the TDP MMU under read lock to
>    reduce guest jitter when restoring NX huge pages.
>
>  - Return -EAGAIN during prefault if userspace concurrently deletes/moves=
 the
>    relevant memslot to fix an issue where prefaulting could deadlock with=
 the
>    memslot update.
>
>  - Don't retry in TDX's anti-zero-step mitigation if the target memslot i=
s
>    invalid, i.e. is being deleted or moved, to fix a deadlock scenario si=
milar
>    to the aforementioned prefaulting case.
>
> ----------------------------------------------------------------
> Sean Christopherson (2):
>       KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves memslot dur=
ing prefault
>       KVM: TDX: Do not retry locally when the retry is caused by invalid =
memslot
>
> Vipin Sharma (3):
>       KVM: x86/mmu: Track possible NX huge pages separately for TDP vs. S=
hadow MMU
>       KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its pu=
rpose
>       KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock
>
>  arch/x86/include/asm/kvm_host.h |  39 ++++++----
>  arch/x86/kvm/mmu/mmu.c          | 165 ++++++++++++++++++++++++++--------=
------
>  arch/x86/kvm/mmu/mmu_internal.h |   6 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++++++++---
>  arch/x86/kvm/mmu/tdp_mmu.h      |   3 +-
>  arch/x86/kvm/vmx/tdx.c          |  11 +++
>  virt/kvm/kvm_main.c             |   1 +
>  7 files changed, 192 insertions(+), 82 deletions(-)
>


