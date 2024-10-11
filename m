Return-Path: <kvm+bounces-28639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC8B99A751
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 17:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B5981C228E3
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C8F1946A8;
	Fri, 11 Oct 2024 15:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f+o16kcw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2A5199BC
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728659744; cv=none; b=Sblg4abbdefCBHRaJxQor3ICbn1tzgq+CbVkjZxeLSHGI4sc+ZDIAjLxEvj/VY5i+tNx78KWk99ExQbK8256usJvYLQPp3AWdq4lsZXtmVW788BCQAqqLkTITUPRagfVWj05Z5SrIhSEVZX7KgIuzlCN7KTh12mSmmn85NPtN2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728659744; c=relaxed/simple;
	bh=0ird5SSUaLCFpmcf0H3uDs6mag8WxLiTFKAm5TpIph0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tx2kZHxG44QWmLU/8FLcRX55nN7oGAGN8+05lrKs6OOmboJHCMcNOVoK+t7bFrPStJAV2Yicu/kPn0Zs7kMMFjcArLKaOTgllgfZp7TQJnJZSITj5Zxl6eIiFRpgxtoj/jYtHaOqRL/UyTaTGYrIkgfbZuZrlp09EjKBmL0ewa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f+o16kcw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e17bb508bb9so3232820276.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 08:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728659741; x=1729264541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yD8fLJDMIKEGL9LdS26hHvshcG+d1j7neE9mXfOfORQ=;
        b=f+o16kcwRFef9nXokMdLDity2rxAma1Uy/KVlTMSDjhdlH1NnI2o62jE0rAXmHzjJa
         JAXd8Z3FhcbF4Dlwq9I+5s8aHcTg+u3wecYamdFhxjBKcRAlaD4wuCfA3hC8yUZR49Sg
         1B0P0tspvoaeSuswHC7tx/cxlvFV4F+l36Wdcovz2vPR5DkV3Tm6e+9X8yUwkTMPkbnH
         9j6kNIXwLHr8+xtObF4/+n0MlcJuGBbmPFpFeuqRjvt4kARjvafQbzfs5KoaEOyK7rLC
         bAmOwsanfEuDMK1LVQsaDMzQ9IcjvyhnJD5Cr5xvk7DrgiSesttoHuQqnqq9dm/YGEaS
         i6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728659741; x=1729264541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yD8fLJDMIKEGL9LdS26hHvshcG+d1j7neE9mXfOfORQ=;
        b=i/Z4AXdqPnyBH0fXtpVtOWNucSO5/pgFEMcda06poW7AcJovFbl6x9XAvp94bMtDt5
         tEXJwcspqikJ2EMiAr4ynMJyJ95yeH33ektPW5aTI+XOr9BjEgfmfhBJxGDrZ9iQygsR
         wtcSq63Cf+Huwd835hmHQFOBBCCYd/bmKUhWrqWN5kMgwfMHio2a7tCRnXTyurlz9OuA
         gTxdSqZfbl0yYBcGHr1tsvMAeJZgF+E8kSA+m4MAcFcoDW57E3no54SLBs2/w+PMgSDT
         WV/1kv7KaOdCIW1gZWU1HPIQD6W+c2fz/zINoEpqSp02VYXbb/jpPcdTyWgER0rTKB0B
         y/Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVPuSLbKaCtUvaYRCzBA/fOm8OsN2IV+cNtsNEC4HaSmtTceXsFlsiIJHeLExAqd3qy5uA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn1iwvxBuiLOoQNb5N852oTKhjtcrGGflrWCj+Eu7t+dE74ejR
	HxAAavOhsFEcSMvjk8F0148TfP89paMX30p3vJ/2QKy+SBkYZ0LYTWNdC3/W+8w++PEly7mK092
	oNA==
X-Google-Smtp-Source: AGHT+IHcJiD6aNAzPZbyQ0X6W/CQXqg5RExz1ZOW/RVcZQ9RjOja9gvFQTsg5ZX8TQuQ7LSYdG7H3he9psU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:86d0:0:b0:e25:5cb1:77cd with SMTP id
 3f1490d57ef6-e291a32d32cmr11193276.10.1728659741554; Fri, 11 Oct 2024
 08:15:41 -0700 (PDT)
Date: Fri, 11 Oct 2024 08:15:40 -0700
In-Reply-To: <d54f9b64-fc9f-4b63-8212-7d59e5d5a54d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzy12vswvr.fsf@ackerleytng-ctop.c.googlers.com> <d54f9b64-fc9f-4b63-8212-7d59e5d5a54d@redhat.com>
Message-ID: <ZwlA7oi4WQWi6bXB@google.com>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 11, 2024, David Hildenbrand wrote:
> On 10.10.24 19:14, Ackerley Tng wrote:
> > David Hildenbrand <david@redhat.com> writes:
> > 
> > > Ahoihoi,
> > > 
> > > while talking to a bunch of folks at LPC about guest_memfd, it was
> > > raised that there isn't really a place for people to discuss the
> > > development of guest_memfd on a regular basis.
> > > 
> > > There is a KVM upstream call, but guest_memfd is on its way of not being
> > > guest_memfd specific ("library") and there is the bi-weekly MM alignment
> > > call, but we're not going to hijack that meeting completely + a lot of
> > > guest_memfd stuff doesn't need all the MM experts ;)
> > > 
> > > So my proposal would be to have a bi-weekly meeting, to discuss ongoing
> > > development of guest_memfd, in particular:
> > > 
> > > (1) Organize development: (do we need 3 different implementation
> > >       of mmap() support ? ;) )
> > > (2) Discuss current progress and challenges
> > > (3) Cover future ideas and directions
> > > (4) Whatever else makes sense
> > > 
> > > Topic-wise it's relatively clear: guest_memfd extensions were one of the
> > > hot topics at LPC ;)
> > > 
> > > I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
> > > starting Thursday next week (2024-10-17).
> > 
> > This time works for me as well, thank you!
> > 
> > > 
> > > We would be using Google Meet.
> > 
> > Thanks too! Shall we use http://meet.google.com/wxp-wtju-jzw ?
> 
> I assume that room cannot be joined when you are not around (e.g., using it
> right now makes me "Ask to join"). Can that be changed?

Yeah, it can be changed.  I did it for the PUCK Meet, but I forget the exact steps :-)

> Otherwise, I think I can provide a room (Red Hat is using Google Mail/Meet
> etc.)
> 
> Thanks!
> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

