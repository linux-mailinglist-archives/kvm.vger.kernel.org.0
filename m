Return-Path: <kvm+bounces-11815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1173287C2E7
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429071C219DD
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E50D74E10;
	Thu, 14 Mar 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GsdmCkqp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3B770CCB
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710441647; cv=none; b=Y+9JtYB7pWD5LBKc8nTxFo4Xmo42C72NC088h+/vSpMeWPDnyEfgT+fU1X9YTEFNp6d68PfsWzgYA8TShQUkeCQUbmegk3DksPPw5fOTT2d7IcEt2bIguuHsXkDTF3n+AIX3MhG9R4g4RYsjZ4JyTOSE5m7lPIMqWWcL2gEDslA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710441647; c=relaxed/simple;
	bh=Q3DRaUnkNmoBKi0eg0HQnH8IEFyzesJnvrMrZUVvx3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XKD0q6fxT1kkOGB3o3HorturgyKAxHywB8lH47dRzfEdrNyesWm6+B+pBC+wz1OW+5fhu2QgMiORM0G6u/ZDiE9OBwGtYkIJM65cd0XeKkb8zpwKoA7Rk7OVd4tcfnk8/G9OdRcFl+MkGNGwZCz41O8YkcKlXKNAMY13ObkdFss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GsdmCkqp; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cd62fa3a6so6290417b3.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710441645; x=1711046445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lpMprx7x9B9yx+3CvoKRnmXKr2JamMth4mY2dj456Ww=;
        b=GsdmCkqp4SkqoM9GJwLNYccyFe7kcqJ80Dyz/b4pa7J5LcklecOW7vqbOYMhapFUfb
         HNat1q1OKM4akyKewDVyGcCDwDpPM7KY1l1F8EhnRjyIaBizj2ww3R8+/D2LP09ljLHB
         DXRJ60KhfoCIZs30c+e/UuKUUWvORQ6pMyp+KBuzxXfE2FFLSe+4eyra4jKePFJlqSv+
         i6zko3LrUAl1C2R1GX6tEu0awo+MnScWOIFMFGHiie9Yw8SoOFSZ7AeYakUG5AITqFer
         rXF4taCLNuneBmr2DgZ+NV1QAywU/AMpLw6sph9190/Emhcd5V1NrrgPvOPejrJ6/v/3
         TCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710441645; x=1711046445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lpMprx7x9B9yx+3CvoKRnmXKr2JamMth4mY2dj456Ww=;
        b=Tttvmuk+eS3SCiqS5B/NHByNeqicUQUfLOm+G8BoLfeJz8qpe2M3xP2+Ju8S+xGEPT
         6ockkya89AP7rrsroCeSWbmHi/2xzoRFoqmzf0paYGSQnMBx0Lt6NL4T3X8YA/TLZDMG
         qfDGhZ3VI7GVnbb73YrokqX3KXNdLs2/X86pCR4A7TaROaraaWdWXhCCZl2ytQaYGI0J
         Tfvo8G0j544nKedGhDFhtiBaUdIVXg1IUHS3HyGMvRmvXNFSjBU7yGZeLxiuip8fC6pb
         FItKFQj0Io2x1FWl/27PkR9pzPUSIb/pStXbOLmgyajDQ9wWc9yOMI0i+GIHvWbNtSeZ
         /I+A==
X-Gm-Message-State: AOJu0YwnZuEUBRJJTGRzrT5T7OfUsFIB+0OGJi/U8DOnA/nXzApA0noe
	Wocdj7e5GN1jFTitx1NCFMj4F0qa5plJvHfTFNogQBMWhm3Hdc9z+Omqu5+2Cj2aLZyG0HiLT/U
	+wg==
X-Google-Smtp-Source: AGHT+IF+keQ0tZZQPsb0LZJ18aMfHcX5w1D4YRYdDX1MabHJOIATypkQkaJqlJR+t8uIKHgg/p6W4uz5JDk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4ece:0:b0:60a:6a62:a34b with SMTP id
 c197-20020a814ece000000b0060a6a62a34bmr409797ywb.6.1710441645389; Thu, 14 Mar
 2024 11:40:45 -0700 (PDT)
Date: Thu, 14 Mar 2024 11:40:44 -0700
In-Reply-To: <ZfDeohmtLXERhyzC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com> <20240308223702.1350851-7-seanjc@google.com>
 <5e302bfa-19a8-4849-82d0-0adada3e8041@redhat.com> <ZfDeohmtLXERhyzC@google.com>
Message-ID: <ZfNErIqnETakZxli@google.com>
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 12, 2024, Sean Christopherson wrote:
> On Mon, Mar 11, 2024, Paolo Bonzini wrote:
> > On 3/8/24 23:36, Sean Christopherson wrote:
> > > Add SEV(-ES) smoke tests, and start building out infrastructure to utilize the
> > > "core" selftests harness and TAP.  In addition to provide TAP output, using the
> > > infrastructure reduces boilerplate code and allows running all testscases in a
> > > test, even if a previous testcase fails (compared with today, where a testcase
> > > failure is terminal for the entire test).
> > 
> > Hmm, now I remember why I would have liked to include the AMD SEV changes in
> > 6.9 --- because they get rid of the "subtype" case in selftests.
> > 
> > It's not a huge deal, it's just a nicer API, and anyway I'm not going to ask
> > you to rebase on top of my changes; and you couldn't have known that when we
> > talked about it last Wednesday, since the patches are for the moment closely
> > guarded on my hard drive.
> 
> Heh, though it is obvious in hindsight.
>  
> > But it may still be a good reason to sneak those as well in the second week
> > of the 6.9 merge window, though I'm not going to make a fuss if you disagree.
> 
> My preference is still to wait.  I would be very surprised if the subtype code
> gains any users in the next few weeks, i.e. I doubt it'll be any harder to rip
> out the subtype code in 6.9 versus 6.10.
> 
> On the other hand, waiting until 6.10 for the SEV changes will give us a bit more
> time to see how they interact with the SNP and TDX series, e.g. in the off chance
> there's something in the uAPI that could be done better for SNP and/or TDX.

Though I'll add the belated disclaimer that performance testing is not my strong
suit...

