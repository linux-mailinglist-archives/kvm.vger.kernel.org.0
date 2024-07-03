Return-Path: <kvm+bounces-20912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FD3926964
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 22:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19DE728C6E2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 20:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D16918E77F;
	Wed,  3 Jul 2024 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iqnAonRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB7E13DBB1
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 20:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720037547; cv=none; b=TJuxuK7ies7J3zyR5nUwvTfwmudTPrBiRnd0YTJ9RBraBKBg8llzJJh1qX44o4TZAtHGD9A7jHlgJQJ01CAvqlov7cKDLci0YSJhi2gpYzTGWK9xMd9ZHUZ1OQFdn4J5/mA9+N4TQQ77LMDYsJc2YJP5VDrW2yRqOUfqeDkaUIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720037547; c=relaxed/simple;
	bh=80W5GndL0widXld75GsZwiV0NLDCplZ+tQVpoOnihP8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tp5Y1PacXp73E00EUfjpx37BEsZyYPALcbB+pk/AbkQmsYLAe1Y30VRfqljxHdBF+93PWebWc36q+0lYvuT6lbbYmSV7tyUocpSkLN00G2V+DDvJF4pOJvPmY2TARs75p9n7VgAE1O9HvCU/Tn4lCJ50bN33tLDBjuyPdwQcM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iqnAonRp; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42578fe58a6so32990675e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 13:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720037543; x=1720642343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zE63Ktwe2xp7wEqSVWtbUemIUpIWXGCvMeuKhVG4zNw=;
        b=iqnAonRp9rxayObwLDSchNi4ZxOCS5iJb38ud+vLCUNbEjHI1qacidvqFIAhusV926
         WHvbY5ftcJuPCKwuZLGJXnkeBndzMHO9uRoy7I0EWVCxROYLKb4EmQaq3YBvEmM15Ksa
         Egj3Ra3Qnyoio0saKhT5VtX6fSc/BsEc88oJSthkcVFnoX30lRDLyZ4SodJtxRaj1hUv
         VZdC8MRGi39sOc+hJvGTC6UqePtroDBk0akWefpWdLoVd4qWbVynDqFJrE3RujkORvej
         0IAutehKE+sbG55skP4V5UFvr3YEk2ON/zCHG7rl73RsFdRqgkqNX3ZjV+M62J+5LFUA
         5N0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720037543; x=1720642343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zE63Ktwe2xp7wEqSVWtbUemIUpIWXGCvMeuKhVG4zNw=;
        b=M8eu8CV6e6pk/jNn72WxQ/L3PB4cJSbNRh2P33Tpqj9if+1VSuaPNUtTmNoI+qbM4S
         4hSuHV1G5hL2r6ty+pExnC2jITDYjYdEcRSNsrnm7PkGBlaNwKGcZPMsHfH73JzdJogC
         yezJJxLIRzjC9lhyfTkXo4ZLDGbfnan7e2cgKUl7OB6Do4bQ/JDW/u2UyEycIj4uXujQ
         kwKNp8Z7f/se4PrJ00jv5+Ipm88vmDdvo3+drDLh6a1aw51EGjaGFxLwhWyo9sywwsEy
         DBAtFoOxlMKbG8+KJTT/LrdtUq0SVtpsXqAgJYruQTJabrggeNy7ydCqI6EwGgblHYCD
         jyUw==
X-Forwarded-Encrypted: i=1; AJvYcCVKdZrtbQngZE4QNi5vt4uSqQRFCcB7JmreRlanPIUe7ddREDbleONrsyf+giiw9fS83uKZTkVdxdg6TB7WTSu20ZzG
X-Gm-Message-State: AOJu0YyR4KhpW4rSUmij5R2xiueh8LCFocuxIGNaGqeUNSRSrsc+bJhS
	Fw8+hkTOgn+deS4nZityght7q+IJXd/kRWOS8as4ZtKs9W9dxu2bWgVSdo95PCKKNtjIZPjUFRp
	ws1JRhOYbvif2WQ20g1uWgH9Xm76g8uiPxJOI
X-Google-Smtp-Source: AGHT+IEbTBGkDEkTRWn1RGJZwfOMrQRPTBUh/CecN+lIDwo4RV9LNTAOu7EMjJk2Li2rPQJa1KTDgqJ8gKdJ6DL5+/8=
X-Received: by 2002:a05:600c:3547:b0:424:8f40:a2eb with SMTP id
 5b1f17b1804b1-4257a034de5mr93861665e9.9.1720037543469; Wed, 03 Jul 2024
 13:12:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com> <ZeuxaHlZzI4qnnFq@google.com>
 <Ze6Md/RF8Lbg38Rf@thinky-boi> <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
 <923126dd-5f23-4f99-8327-9e8738540efb@amazon.com>
In-Reply-To: <923126dd-5f23-4f99-8327-9e8738540efb@amazon.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 3 Jul 2024 13:11:55 -0700
Message-ID: <CALzav=ePCJiYABpWG70ddPj2Yt57UAxynd64ZWzSVDHUVA3X3w@mail.gmail.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: kalyazin@amazon.com
Cc: Sean Christopherson <seanjc@google.com>, Anish Moorthy <amoorthy@google.com>, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com, 
	Oliver Upton <oliver.upton@linux.dev>, roypat@amazon.co.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 10:35=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.co=
m> wrote:
>
> Hi David,
>
> On 11/03/2024 16:20, David Matlack wrote:
> > On Sun, Mar 10, 2024 at 9:46=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> >>>>
> >>>>    2. What is your best guess as to when KVM userfault patches will =
be available,
> >>>>       even if only in RFC form?
> >>>
> >>> We're aiming for the end of April for RFC with KVM/ARM support.
> >>
> >> Just to make sure everyone is read in on what this entails -- is this
> >> the implementation that only worries about vCPUs touching non-present
> >> memory, leaving the question of other UAPIs that consume guest memory
> >> (e.g. GIC/ITS table save/restore) up for further discussion?
> >
> > Yes. The initial version will only support returning to userspace on
> > invalid vCPU accesses with KVM_EXIT_MEMORY_FAULT. Non-vCPU accesses to
> > invalid pages (e.g. GIC/ITS table save/restore) will trigger an error
> > return from __gfn_to_hva_many() (which will cause the corresponding
> > ioctl to fail). It will be userspace's responsibility to clear the
> > invalid attribute before invoking those ioctls.
> >
> > For x86 we may need an blocking kernel-to-userspace notification
> > mechanism for code paths in the emulator, but we'd like to investigate
> > and discuss if there are any other cleaner alternatives before going
> > too far down that route.
>
> I wasn't able to locate any follow-ups on the LKML about this topic.
> May I know if you are still working on or planning to work on this?

Yes, James Houghton at Google has been working on this. We decided to
build a more complete RFC (with x86 and ARM) support, so that
reviewers can get an idea of the full scope of the feature, so it has
taken a bit longer than originally planned. But the RFC is code
complete now. I think James is planning to send the patches next week.

