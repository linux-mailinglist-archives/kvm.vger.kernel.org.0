Return-Path: <kvm+bounces-9110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB1A85AE2C
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 23:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 382E41F225D7
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 22:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5ECB54FA0;
	Mon, 19 Feb 2024 22:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oGP+GQB6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DB354BEA
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 22:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708380416; cv=none; b=ToXAShv5GeAjPhI21YewfaVX7OBvVRV8smyggd717VJvf/aphkVniKo/u9YORvb0DS2FyQTJpNyQZm0LqCqPSCJBoLudINTSEuwuJeqx5oEYdnGI03LJ5Dvqp9v3bqx7PfYW4+RUW5hXMq+bqnPjWnhOr8If6z6S+PEHBPcOj+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708380416; c=relaxed/simple;
	bh=l0HvovpPqMVUQu9B4ZqhpUtqDN71UcjNp3KMDMRYNP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A9C/QhBDyTKnoTplk6TxljXBESW7bai5vlYon3LqGdwonevhBN++DlhVqc7suD+YVITjQ/p7YFBoz4bGoY+ougIDRZSQSMIBNBp5Nhq67GElDUI7uB/ddCAunKMV5ypoDjSof3H4NrfNgGEqQVV8h30XBFKwQ/p48DRBUUZksek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oGP+GQB6; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b5d1899eso7624648276.0
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 14:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708380414; x=1708985214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpOEZIVxoohE3GrUqHhwdrDwGh8LEXRlOdsMaQjdYhc=;
        b=oGP+GQB6s2Je7VhzfpYJba2+bM5S9z+eV4RJaJFUN5dWI8Tivumk/t0sg/aOroXc7r
         29vAAfGLHIWGzvb1+A/6TUuFoyXKyYmnorE/tru2PjJoTGHHQW+J3+0EENgOM1U0Fk74
         OzzIPNe4OWGIvlDgGSxJW1dpRYaaqylFAy3Ee5wizVqs/rsoCecfT1JfUy3cz53STMix
         EfEtLuUpTEFjV60iB8pztpvkhV8TApvaXGeNUFktmzrvu56LMgoCIaC8+fyyDC8oU2Tp
         7KCrtwNqDVrWj24E6lQ/IQ+wWWA7APUXSPwLNZsba9cAWMgAewtpOLK8jUrINYc7YZu3
         Krow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708380414; x=1708985214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mpOEZIVxoohE3GrUqHhwdrDwGh8LEXRlOdsMaQjdYhc=;
        b=q7wf0iq5W4netkGZ+Zb2qFB0IO8KrLjqQHg3JkkV0fV/Ar34uamLQD/AXAJ/8oQusK
         SPBJbxKdHqJlKRl3yhm6Wxq2uYRp7sUDz5r5RPQv7jnFgDysRxk8U11snzBQXbkAhQVX
         qidIR6hW8+1HYjeXuN0OHGkqWSiKUtfqE0DuttWSxSQ2pEmksa/xwDBawrggnUykxX6r
         +YAyOEHI02LgmI4zRHAU0osZBt/tMl6rV1Cll2NbUZODren/4eul5KzCPTtpWEs0fiZs
         hmxUdPlk+Ld5opNdzZZP/pB60elohUEcrBH4eCjbo7nBIqzbfJLQf6polkiEawbTBYk3
         MvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY+yISFS3oLnAaOmS2njJ6J1yW7/az5hIFn9QsSSCE/ujJFmzpbO8HCK65uU6AqWVNaH2Ur1Lg1X92a3HqvIFaoNzI
X-Gm-Message-State: AOJu0Yz71P5kBLSN6kla6YoJHVep+v991YKbJ1ceZtx8MfXs9Q++9F2l
	E9LHdtO9lUEweVJ7TWkB3hKwqC6SbPeITuIUqc+/8xNuANXzth9ravta9JUCe8mMKIqMjllVt7Q
	Kag==
X-Google-Smtp-Source: AGHT+IGRqD5MJLHGgiuZ4aiPpWZMq+YddUVmGLFXTlIV3IDh3/IjNrlEjd6bMLCvEt6hO0XIgEvR5LwUl4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120a:b0:dc7:7655:46ce with SMTP id
 s10-20020a056902120a00b00dc7765546cemr4267897ybu.2.1708380414286; Mon, 19 Feb
 2024 14:06:54 -0800 (PST)
Date: Mon, 19 Feb 2024 14:06:52 -0800
In-Reply-To: <20240215152916.1158-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215152916.1158-1-paul@xen.org>
Message-ID: <ZdPQ_AcbTYMtArFJ@google.com>
Subject: Re: [PATCH v13 00/21] KVM: xen: update shared_info and vcpu_info handling
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Paul Durrant wrote:
> David Woodhouse (1):
>   KVM: pfncache: rework __kvm_gpc_refresh() to fix locking issues
> 
> Paul Durrant (19):
>   KVM: pfncache: Add a map helper function
>   KVM: pfncache: remove unnecessary exports
>   KVM: x86/xen: mark guest pages dirty with the pfncache lock held
>   KVM: pfncache: add a mark-dirty helper
>   KVM: pfncache: remove KVM_GUEST_USES_PFN usage
>   KVM: pfncache: stop open-coding offset_in_page()
>   KVM: pfncache: include page offset in uhva and use it consistently
>   KVM: pfncache: allow a cache to be activated with a fixed (userspace)
>     HVA
>   KVM: x86/xen: separate initialization of shared_info cache and content
>   KVM: x86/xen: re-initialize shared_info if guest (32/64-bit) mode is
>     set
>   KVM: x86/xen: allow shared_info to be mapped by fixed HVA
>   KVM: x86/xen: allow vcpu_info to be mapped by fixed HVA
>   KVM: selftests: map Xen's shared_info page using HVA rather than GFN
>   KVM: selftests: re-map Xen's vcpu_info using HVA rather than GPA
>   KVM: x86/xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA
>     capability
>   KVM: x86/xen: split up kvm_xen_set_evtchn_fast()
>   KVM: x86/xen: don't block on pfncache locks in
>     kvm_xen_set_evtchn_fast()
>   KVM: pfncache: check the need for invalidation under read lock first
>   KVM: x86/xen: allow vcpu_info content to be 'safely' copied
> 
> Sean Christopherson (1):
>   KVM: s390: Refactor kvm_is_error_gpa() into kvm_is_gpa_in_memslot()
> 
>  Documentation/virt/kvm/api.rst                |  53 ++-
>  arch/s390/kvm/diag.c                          |   2 +-
>  arch/s390/kvm/gaccess.c                       |  14 +-
>  arch/s390/kvm/kvm-s390.c                      |   4 +-
>  arch/s390/kvm/priv.c                          |   4 +-
>  arch/s390/kvm/sigp.c                          |   2 +-
>  arch/x86/kvm/x86.c                            |   7 +-
>  arch/x86/kvm/xen.c                            | 361 +++++++++++------
>  include/linux/kvm_host.h                      |  49 ++-
>  include/linux/kvm_types.h                     |   8 -
>  include/uapi/linux/kvm.h                      |   9 +-
>  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  59 ++-
>  virt/kvm/pfncache.c                           | 382 ++++++++++--------
>  13 files changed, 591 insertions(+), 363 deletions(-)

Except for the read_trylock() patch, just a few nits that I can fixup when
applying, though I'll defeinitely want your eyeballs on the end result as they
tweaks aren't _that_ trivial.

Running tests now, if all goes well I'll push to kvm-x86 within the hour. 

