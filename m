Return-Path: <kvm+bounces-53947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A9AB1AB9E
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 01:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDBEC180FF3
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 23:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E3B28852B;
	Mon,  4 Aug 2025 23:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzdEaQL5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D9D2264B8
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 23:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754351732; cv=none; b=ag+qOsI2Q+ufuqfsGGMuU9GAXbC2Bp2LEJKa0hLEioAJ8SLb28fsSSCkknm2nlICRoKX1gsHGxORtvL22mpBkn2U1VgWWPPx+ufOj81fx3tvWhnr3j2jbugyhg5LBpGGYEIJWBCD+KbfCPJ1ZzMfPe9CIv1AVedLqao5hq3tjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754351732; c=relaxed/simple;
	bh=LJa4/RLFYqhpHz6skUkYByaddwTg6kkzYxMQ4jNpMpw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gEKWaXaigcimueW+xNiiBQPH6cauZvjIcU8Y+ckwOCcyeaWRgr4Bu0KtPHqo8xYhWoRtR0bFivGOSrCEUZuLeGfat9KCGALF+43MTBHPBbLl47UHG4PLJbpGzNnI1zOYvVwEQPBdsJx8ULAl/v4v1WClRHWh0ZCOESl6Ecm/VGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzdEaQL5; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-af8fd1b80e5so831802766b.2
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754351727; x=1754956527; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kkOJrgR6AtCFvZcGKn8m61aTsvNmBN6yQcZ7tCaSTKE=;
        b=AzdEaQL5T1BLS2jVQbL3EndlQMsOXHWxD26AB+YvASRQLElh9ecZWCiQuchnDOSs8J
         00KqwxAqyyn5/teD+LLIoMhN/dq9Hd/jMO8rfgBRtaMteEOb62ZAhbflzFuOepp62FSB
         h16EjeHjCWly5esBdRNXZu8mAobUgIyLOGG30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754351727; x=1754956527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkOJrgR6AtCFvZcGKn8m61aTsvNmBN6yQcZ7tCaSTKE=;
        b=CHFmcD9NOb8nV9adAc8KVv2/ozk5GWgY84HyCyIOQEt3iVUTXSpK/zqKSKxeM1D741
         FBN2QlYvglnm3oLcsGKRd/M3x0b/ciopQwScAfM9efQcjzHRIhDVsR6QGFA2QlpE0CMc
         7h6tRiYtDL9o+20RlMSviQ6kwT3R4IT43l+tKsVNEJ/Zkk4yN+fJAbVI3F5n0zqbR98V
         fqdYKLBlB22USmo+RADWs95BFudMmGVPz3R39eWgR22Jm0bb8tMknqTiHaEF/+rp2Ms8
         13qFFVDm8ZHecJ4au08flruwne2Dfk1pB4Rd4Y/PBbq/XelQaMgfweIqSaq1eEN1D5E1
         WyYA==
X-Gm-Message-State: AOJu0YyW2f66TBPWvpgLs4I5vJMfIWO8SgEM2kGBCwlUyr6c8EbmR+Em
	CTv7fWh8gK3G5r+E04tdhS5gVy0T3NDzrtICHG7rQUsnnZtH/WrILOqxfg6Ym/20c8VQMrsjFUk
	NeIOHSvQ=
X-Gm-Gg: ASbGncu9jBGhqMfQmuRFYauJkRO38hCcHEZhpShYji+Ea2+SyaDdDBPsR/kLCK39U2N
	bJMS6R/EbCsLp6tj4RQnO9iAgt7OPQbt+a8VzQG5LVhajYM82Y1Pg1DpXOB6icCs/FVE2GEGWaY
	UrenTM+DpRZKH20HEPa2gBQzObGx4l9oFxFg8xxqIjr6cmUBYr8OPN5PmW7db7BGS8m9FqAPPXZ
	0CSxrsQugQLfyDpHB57LlVB9YxW451BrJKBRZbpgEmSvj0vX6ccYQPfSnDaxWP8KTUlr1URb1WE
	Ur3u0sXd5x33lKLbUbeS0sLody/ZrNEseDUDtIYbSEZrCjKuzzdCapHGh7nEy5g4Q6oyyUiRILN
	aQdDocPW4iV1Q5XkELKxlqUhN0/2400AEW8cLwyHdSTfDExCtO2kwI3LCeuqUI5WFY0St9mPpHB
	K+Rmw0AVI=
X-Google-Smtp-Source: AGHT+IFHZiodW12fzXxgBf0YduQcW3CpxdDIERKegxTlbZonWm3VXt/DZml7IgbZPC+O1wEPoHRHjw==
X-Received: by 2002:a17:907:6d1f:b0:ae0:c539:b89a with SMTP id a640c23a62f3a-af9400844bbmr1151035666b.19.1754351727574;
        Mon, 04 Aug 2025 16:55:27 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af93b4d4c27sm546548066b.66.2025.08.04.16.55.26
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 16:55:27 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-adfb562266cso800151966b.0
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 16:55:26 -0700 (PDT)
X-Received: by 2002:a17:906:478c:b0:ae9:876a:4f14 with SMTP id
 a640c23a62f3a-af94024cab6mr1073910366b.59.1754351726564; Mon, 04 Aug 2025
 16:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
In-Reply-To: <20250804162201.66d196ad.alex.williamson@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Aug 2025 16:55:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
X-Gm-Features: Ac12FXzNsiXa1g4lLLdotjXwBYpgPqvnDpdKKoggRbJ3KlfhT-2HsnqsEpBMoL8
Message-ID: <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Aug 2025 at 15:22, Alex Williamson <alex.williamson@redhat.com> wrote:
>
> Li Zhe (6):
>       mm: introduce num_pages_contiguous()

WHY?

There is exactly *ONE* user, why the heck do we introduce this
completely pointless "helper" function, and put it in a core header
file like it was worth it?

And it's not like that code is some kind of work of art that we want
to expose everybody to *anyway*. It's written in a particularly stupid
way that means that it's *way* more expensive than it needs to be.

And then it's made "inline" despite the code generation being
horrible, which makes it all entirely pointless.

Yes, I'm grumpy. This pull request came in late, I'm already
traveling, and then I look at it and it just makes me *angry* at how
bad that code is, and how annoying it is.

My builds are already slower than usual because they happen on my
laptop while traveling, I do *not* need to see this kind of absolutely
disgusting code that does stupid things that make the build even
slower.

So I refuse to pull this kind of crap.

If you insist on making my build slower and exposing these kinds of
helper functions, they had better be *good* helper functions.

Hint: absolutely nobody cares about "the pages crossed a sparsemem
border. If your driver cares about the number of contiguous pages, it
might as well say "yeah, they are contiguous, but they are in
different sparsemem chunks, so we'll break here too".

And at that point all you care about is 'struct page' being
contiguous, instead of doing that disgusting 'nth_page'.

And then - since there is only *one* single user - you don't put it in
the most central header file that EVERYBODY ELSE cares about.

And you absolutely don't do it if it generates garbage code for no good reason!

            Linus

