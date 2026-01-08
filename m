Return-Path: <kvm+bounces-67469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB897D06127
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60AD9306A0E3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7D632F766;
	Thu,  8 Jan 2026 20:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E7GQ5QIH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F5532ED22
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904155; cv=none; b=YV1mqbEZuqTgFUzhdf5cG1psUsJCTwGuoTU/maq17+DbnVQrwRgsegSIj9WBryAVU0GhGw4zvSuR3Az+Ze1nd9ARCkoffsdUSdSOfks+GxoZb6ECXJLe+MW6YA0jVBOgRGK1Vu+NLv2q8O3fb/CYQ8eQsWEt4UeeZ1Nrfj/rnmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904155; c=relaxed/simple;
	bh=COjeahyQKq/WjlvRhmJa/k/eFDaGlubJQKHvMo2HvWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KC2y4kVnqt4qAiFDAhNUAAxZtaGCg+p2u92/OkJ4Vs7shL/jR+mpYCr98ICghPZgbSw6DjD1LEP8I+p+jPLwFoeRg0agbii/54pAXJ9P2PWUVC2DOA5EQa+NnAawrvJH66OaKdnbPu7XSQ9+eCccs6pAK4r1xm9zizJY3xJuIDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E7GQ5QIH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c21341f56so7549108a91.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 12:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767904151; x=1768508951; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ncr9wQixKp0DuZvt8wQRxeDUwFvl6Ym9a7uU4tCK5vA=;
        b=E7GQ5QIHjD+i57b5Tmg3vqg1Z/CdZFRfF5+qKo4qyDE/7NFREnED1zDQkKsUq0RXZk
         wTqs7n/x+L6v0UfYcMJ8qtio5sJ2hpF1vKCB3Y4M3IZzsutYMneUohKG1sYgHd9pkY2X
         Nmqmlkvk5vFROokWbmOnK6UzS2ziivXnh1C69HaRPHNaB/yoEi+Q0pClrnojt4VuTeeu
         fbDR98tP+paP0QMNzl2x6MpXALeyfes9TK1NikfyvzYTQ6DYJpPwo69vVgNwh8TpLOC1
         B2Oucs4/M0vFQVM7OTiYq7X+MLN9q6MmdcY5suMPJK2eXcsb8qNlKPE51mDSJffkYoog
         6NWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904151; x=1768508951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncr9wQixKp0DuZvt8wQRxeDUwFvl6Ym9a7uU4tCK5vA=;
        b=hGRgvQt/wBzwUivJd5xxs6kj/2/OYuBgwDLxLXmqLAkAfXlseoei18TOCJ7rw13HH0
         WJAVJFSip6CtA59E1/HDqXiq0i7F7/2NZrOra6UcO2f5Fh1vaTaSQ0xUyJNR1xlcuqhU
         TGmAxJFt4ipvJMN5x3s8wIMg1Xro7j2Knx1eh8cwmMjem61vLrjoH3zWzmi2FfwnyAF/
         bNQTXMJ3nZ3xW9kO2Tr8+1zDenguBQI9AWUdnKq20wPWCGlQ47TSYv55hXETEd6ECpaA
         4qcyQODOsGHsQqekET+6AsLdMeZuUdlyq7ap8xAebkf9NkdTs16c1iyD3JEcla+z0Y6B
         XN7g==
X-Forwarded-Encrypted: i=1; AJvYcCVlNIih05NT8zvCugV/5Ptl0nbDgNwXbV2PfK8S7jSMFxGXZEzeud8DFzc8zOlab9jgqH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVIs1dOwToxKoCdMoV+M5lTAf7/tbcampD0vaBfBVD1mZnLeQN
	VSl5qAj89TV+v94dB2SRx62fWk39SaYPJNRT1teRRfceeEa8wl60Z/ThV+CVmoDEAofAmDOW91i
	6onwtVQ==
X-Google-Smtp-Source: AGHT+IESJ6DBGvd9XcEdp+Peyz/5rANQAvVoqUp8W0UHChsh0K8dNusc9fRWmWPXBczuvgljaqvYKeQ4Bc0=
X-Received: from pjop14.prod.google.com ([2002:a17:90a:930e:b0:33b:52d6:e13e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2647:b0:340:dd2c:a3f5
 with SMTP id 98e67ed59e1d1-34f68c30870mr6773023a91.3.1767904151387; Thu, 08
 Jan 2026 12:29:11 -0800 (PST)
Date: Thu, 8 Jan 2026 12:29:09 -0800
In-Reply-To: <3xrew6ag7pefka7wava4z7ht54e6xlpwbywcm2ivsgnkdbahe4@yqzsaxnhedj7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com> <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com> <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
 <aV_3-lhnZ-MoKnjv@google.com> <3xrew6ag7pefka7wava4z7ht54e6xlpwbywcm2ivsgnkdbahe4@yqzsaxnhedj7>
Message-ID: <aWATlfisv8ZVZi0c@google.com>
Subject: Re: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> On Thu, Jan 08, 2026 at 10:31:22AM -0800, Sean Christopherson wrote:
> > On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> > > >  	/*
> > > > -	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
> > > > +	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
> > > >  	 * affects both L1 and L2.  However...
> > > >  	 */
> > > > -	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
> > > > +	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
> > > >  
> > > >  	/*
> > > > -	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
> > > > -	 * 0xc0000000.
> > > > +	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
> > > > +	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
> > > > +	 * respectively.
> > > 
> > > Are these ranges correct? I thought L2 GPA range [0xc0002000,
> > > 0xc0004000) will map to [0xc0000000, 0xc0002000).
> > 
> > Gah, no.  I looked at the comments after changing things around, but my eyes had
> > glazed over by that point.
> > 
> > > Also, perhaps it's better to express those in terms of the macros?
> > > 
> > > L2 GPA range [TEST_MEM_ALIAS_BASE, TEST_MEM_ALIAS_BASE + 2*PAGE_SIZE)
> > > will map to [TEST_MEM_BASE, TEST_MEM_BASE + 2*PAGE_SIZE)?
> > 
> > Hmm, no, at some point we need to concretely state the addresses, so that people
> > debugging this know what to expect, i.e. don't have to manually compute the
> > addresses from the macros in order to debug.
> 
> I was trying to avoid a situation where the comment gets out of sync
> with the macros in a way that gets confusing. Maybe reference both if
> it's not too verbose?
> 
> 	/*
> 	 * ... pages in the L2 GPA range [0xc0002000, 0xc0004000) at
> 	 * TEST_MEM_ALIAS_BASE will map to [[0xc0000000, 0xc0002000) at
> 	 * TEST_MEM_BASE.
> 	 */

Heh, your solution to a mitigate a comment getting out of sync is to add more
things to the comment that can get out of sync :-D

Unless you feel very strongly about having the names of the macros in the comments,
I'd prefer to keep just the raw addresses.

