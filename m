Return-Path: <kvm+bounces-45544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B277BAAB837
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC153A700A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C81E35017D;
	Tue,  6 May 2025 00:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Bnye07P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4112FDED5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487570; cv=none; b=hAEvZAJ/eFzH/WtRaGwb+E47OkbxLIBtWvWQOFuGif2nuF99lYNTDy0FD0P/MSHwVaxTK6Em8U9cLCu9v0e/vS4w6zPmG80QQvVQ/GvBs/4AUzpRd5Y3M5DenrVL3midDN7vgF7tRhPq3SQcuHBMd+3d2ylyaQrrSuQXI/nsvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487570; c=relaxed/simple;
	bh=67P+5bX4ZawhTisUQZfcMBazv8K4XrXqC8MXBSwhID8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KdW+kXjhMi6XkM5H6Hy2XR6zbtVK9piAW/dszAFgVTQjtD1kV4WalMy6LtW6MPM2xMyJRSJBaEZk8uTgJe6ZBkQV5cbdZ9e3d07PoALzdzIIfKbjKW2ujDBgNj8eDmcfjb1vUVhWZWQMqJLEyUXaNfVKdg4xt2Rs+rJDYctq+HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Bnye07P; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b5f9279cso4123092b3a.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746487568; x=1747092368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4cNJ7zUGr7tO+W7VEbJ8gglNZQhXjP3xsTkrEaO8DE=;
        b=4Bnye07PH3W5XcKv/j7RxbnncVXRRZgqLPJb174CoB133qi2dntrGeUH4uEyxacrGa
         hANw5BnMSawZITgtw4aOCGmbUr8jziEQQqXk6JLarB3ogy6KD/gqw2EWf3b949cDVBwJ
         WDkX7itcJQcKg3wHZD4c/qu2+q9Wnc7p2YzjrHPynPH6550emxIaUjPDJDVVPlaf+eQH
         nfvfP8NIKAeDK7jaLBYBjRT9Wuq3T12NguRHeqeYrQfR4Oc4tfMGvHk3gOZF02cMdLxt
         46x8WhCHofdgX3Y3IYiHROHGSSKDopNT9ZbdO/V5ikQZmNM/b2sguLON9mQiJf+D+bQZ
         7wiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487568; x=1747092368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4cNJ7zUGr7tO+W7VEbJ8gglNZQhXjP3xsTkrEaO8DE=;
        b=WcC7xjk8zh47N5ZKsfv95jHCZwkVUnnQT5iG5xbrv8lUOu7ZqKvsS3z/1K75POI0MW
         41uimua0j4k+NzbGRELgFcKwr2PRZDuzCJrPnwU+I5tWEftYAowK0j8N7hB4qIaDqPF7
         03CnpO30w8IV3tFAuvvZq6zSOHDgNYYwDB4sXZSojHWOndFcWmd2fefTLw0IeEf23h7F
         6SLaIJsZnsRU3UWuxJ/kwZ7lHp+k38R97MjO25VSx2lY2uRZDgUMV2SfL8+bLwa81CQ4
         nKdYrfjKRsMP66vrbERZir0Od+i0D/hLdo+Xnc1BRcv5BvhYzuijw0zSDsYBBLihMSTP
         PN+A==
X-Gm-Message-State: AOJu0Yz4aCOEzIWzWdV2uCPaUtaskkBI2VYFWnGIPMTJm5t1BXckgQQ4
	a2s+1IhEx7WTLjTUvHlKNIvCXjrX/8KVHhvPDAhofc9Z2vr6wZz/rnUuu5qz9u51t6VWVOmhVSV
	OEw==
X-Google-Smtp-Source: AGHT+IFs82iZrMFUBe/Um77R6mZCtOyNM2zzn8fFKGEUvfFdFbOehTmWdf7D5nF7WYhoGzjYDtAoO24FpnA=
X-Received: from pfoc5.prod.google.com ([2002:aa7:8805:0:b0:73c:6d5:ce4c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:600d:b0:736:2d84:74da
 with SMTP id d2e1a72fcca58-740919e16d9mr1113768b3a.10.1746487567641; Mon, 05
 May 2025 16:26:07 -0700 (PDT)
Date: Mon, 5 May 2025 16:26:06 -0700
In-Reply-To: <20250505194836.GB1168139.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250222005943.3348627-1-vipinsh@google.com> <20250222005943.3348627-3-vipinsh@google.com>
 <aBKWmRDBrjeZhAW0@google.com> <20250505194836.GB1168139.vipinsh@google.com>
Message-ID: <aBlJDjBe3LXT8mbK@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Create KVM selftest runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Vipin Sharma wrote:
> On 2025-04-30 14:31:05, Sean Christopherson wrote:
> > Printing the timestamps to the console isn't terrible interesting, and IMO isn't
> > at all worth the noise.
> > 
> > The PID is nice, but it needs to be printed _before_ the test finishes, and it
> > needs to track the PID of the test.  If getting that working is non-trivial,
> > definitely punt it for the initial commit.
> > 
> > And presumably INFO is the level of logging.  That needs to go.
> > 
> 
> Instead of removing timestamp, I can just print HH:MM:SS, I think it
> provides value in seeing how fast runner and tests are executing.

I can probably live with that. :-)

> > I think we should also provide controls for the verbosity of the output.  E.g. to
> > skip printing tests that pass entirely.  My vote would be for a collection of
> > boolean knobs, i.e. not a log_level or whatever, because inevitably we'll end up
> > with output that isn't strictly "increasing".
> > 
> > Adding a param to disable printing of passed tests is presumably trivial, so maybe
> > do that for the initial commit, and then we can work on the fancier stuff?
> 
> You mean some command line options like:
> 	testrunner --print-passed --print-failed
> 	testrunner --print-skipped
> 	testrunner --print-timeouts
> 	testrunner --quiet

Ya, something like that.

> I can provide few options in the first commit, and then later we can
> extend it based on usages.

+1 

> > A not-quite-mandatory, but very-nice-to-have feature would be the ability to
> > display which tests Passed/Failed/Skipped/Timed Out/Incomplete, with command line
> > knobs for each.  My vote is for everything but Passed on-by-default, though it's
> > easy enough to put a light wrapper around this (which I'll do no matter what), so
> > my preference for the default doesn't matter all that much.
> > 
> > That could tie into the above idea of grabbing keys to print such information on-demand.
> > 
> 
> This will be very involved feature, lets punt it to a later versions, if
> needed.

Sounds good.

> > The runner should have an (on-by-default?) option to abort if the output directory
> > already exists, e.g. so that users don't clobber previous runs.  And/or an option
> > to append a timestamp, e.g. $result.yyyy.mm.dd.MM.SS, so that all users don't end
> > up writing the same wrapper to generate a timestamp.
> > 
> > Having a no-timestamp + overwrite mode is also useful, e.g. when I'm running in
> > a more "interactive" mode where I'm doing initial testing of something, and I
> > don't care about
> > 
> 
> We can provide user an option like:
> 	testrunner --output result_TIME
> 
> then internally runner will replace TIME with the current time?

Why overload --output and then have to do more parsing?  I assume adding options
is easy, so presumably --append-timestamp would be just as easy to add.

> If user doesn't provide _TIME then we can overwrite the directory
> provided.

I don't see any reason to tie those two together.  Again, on the assumption that
adding options is mechaincally easy, I'd much rather have --overwrite or whatever.

In general, so long as it doesn't meaningfully increase complexity, make the
interface as flexible as possible so that the runner has a decent chance of being
able to handle whatever use cases people come up with, without needing constant
tweaking and churn.

