Return-Path: <kvm+bounces-37282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC92A28036
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 01:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E2C13A71F6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 00:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30012227B9A;
	Wed,  5 Feb 2025 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k5v+1PSS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C8B227B98
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 00:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716167; cv=none; b=lVZfRML8v7pozGA1sXRwX/CxWGd/9q/9n1U7tL9B7YDQlMSkjAafgOQfAMMbZXrAoHhGHCWCHpWNFf7MqpkAm2TP11h9hcgF3nmFkLY67nZEu+t4I569wyB06Ls2EnX4CDr5ab0z2TQUYr40+C4kwtL92/OBuKG2yo2RbhvoM5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716167; c=relaxed/simple;
	bh=+k4LG/xT//VjVjGnheLfyBH4vM/8in5IOLbtjE03/+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oc/TtMLLF2ZduKuEqaBzt07hDYNEmURVLVUO7m/iFYOpznamFmFBI6JxZUvdOTf6k9RXg45Uc69oPZP7C5GtKFtdts822I6WNNjLjxDojJhe0u/YKoswQKPeoYdVkQ48XI31em6tBtRFFAAifrYI7QNV+vRlGV0OZxFktuFXAqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k5v+1PSS; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-544043a21eeso6275e87.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 16:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738716163; x=1739320963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+k4LG/xT//VjVjGnheLfyBH4vM/8in5IOLbtjE03/+4=;
        b=k5v+1PSSEjxNbX/PQIPnzj5Z7eE4vrJem52rOiiWMw+h55g2fmFHvjU/keNkJftSB+
         C7Hn4VjY6plgwdzm1PcY4lA019FGEsNlWmRQsYQoyJVlxR6PXKe7OFo4IPqZ+0TY4Bec
         NzFcQD2IyzaGgFWZNogVtaGcdTrIJI5x/lYCUg7n5vx1OH5uEdYzYScp3T0oCNrmR7o5
         OSvsm8Fv9tikMOpbtEbXU1lI29DytiML6GLucugxD0D79udvHsZSSkGIP7LNy7zurSC+
         hdBtrKU9L2C2ZT5kUDSmLSr3w7U73+1Ai0K75CloynT7/p3/WqpjVZ/HMlrUvURGomBL
         14ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716163; x=1739320963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+k4LG/xT//VjVjGnheLfyBH4vM/8in5IOLbtjE03/+4=;
        b=oGf2ja6tVAgRh6/4CWkaPG06ReihGufi5HzKWDWaVK/OuUN+pYuwfA+A3N0ky8ZA0S
         Bq+ov/aj7Ap4HMvjRlGy3OH4CxE1JaImwF9kyixAxO31bNE1iBLj+956BW59ufNAOAtP
         GDPg6FaIWj8nHYdeLQaUXn84b75ttw4y2Bhgk/NCXWvWV87SzEAmkxR5mhIhxHFJSopf
         WIz2Zix3EHXKlVWCTqpp4qTtxiMxGEMlbXH0cJlmqFLNvOy+f+T2SbEU2Phw1GXuogf/
         pBFdO27pYW6OFbBm2xb7HkF9wANVQdXKpgM997yUyFSILXNd9flt8+TnX54ytOK1U2J2
         Bagg==
X-Gm-Message-State: AOJu0Yz3n8LjPQK+pXDeY8DH4zoQDe8QQTg7qfehtV6q0zmiefRT6OAW
	Nt36L4dAtUoiXhcsUlGycZGSKQMznDBcVqcC7SPjK/zDtqdmkm/WZqQSg5wsvrX0H0ut8DDflGn
	Bch82/XJsUtSucdPjUWmIRsTuxEav6ssHju9e
X-Gm-Gg: ASbGncsYluzVbOQOk3xeAE8saVKGBIVvIU9I/otqpv4KGHPwRM1RXywfRgEyJyuiZF8
	I03LVWPyVADZe12COaXKhFizjikRevMvBkjxhNZcXJpv/lanJJGAt15GAoICSa+rLifGzXfm0NX
	Zyg+bFNBlnYxatbjz9/kSN8a8h
X-Google-Smtp-Source: AGHT+IGnTx6UzLjGyk5EFTTHRVuNUcIuJg7HuQX71hjcnsPe9x8OGm1xiRttmYhFZ6m7rhIXBpjHdBpULzkf6vArrrI=
X-Received: by 2002:a05:6512:3f26:b0:542:92ee:25ec with SMTP id
 2adb3069b0e04-54400bd3692mr317361e87.1.1738716163227; Tue, 04 Feb 2025
 16:42:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-7-tabba@google.com>
In-Reply-To: <20250117163001.2326672-7-tabba@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 4 Feb 2025 16:42:31 -0800
X-Gm-Features: AWEUYZkca8r5uZlJZJrsv5qE9mdpIrtFmbgbr53sT6Fli1EBF4Nt1S-XWhf5aYQ
Message-ID: <CAGtprH90zc3EWSuyqy4hE7hsmSZSYfB3JBC8KBvc1PdMcw5a4w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 8:30=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Before transitioning a guest_memfd folio to unshared, thereby
> disallowing access by the host and allowing the hypervisor to
> transition its view of the guest page as private, we need to be
> sure that the host doesn't have any references to the folio.
>
> This patch introduces a new type for guest_memfd folios, and uses
> that to register a callback that informs the guest_memfd
> subsystem when the last reference is dropped, therefore knowing
> that the host doesn't have any remaining references.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> The function kvm_slot_gmem_register_callback() isn't used in this
> series. It will be used later in code that performs unsharing of
> memory. I have tested it with pKVM, based on downstream code [*].
> It's included in this RFC since it demonstrates the plan to
> handle unsharing of private folios.
>
> [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestme=
m-6.13-v5-pkvm

Should the invocation of kvm_slot_gmem_register_callback() happen in
the same critical block as setting the guest memfd range mappability
to NONE, otherwise conversion/truncation could race with registration
of callback?

