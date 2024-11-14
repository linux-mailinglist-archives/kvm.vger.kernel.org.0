Return-Path: <kvm+bounces-31854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E729C8EA4
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63AA61F21374
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 15:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FD91B21BA;
	Thu, 14 Nov 2024 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BK4SWUBu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B421B21A6
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598700; cv=none; b=JIQe2naiTucXgKklhM203L0PCvLvsuWK0rEI5bBudyNi0b5XrZIGnTXHtyu6LKtZGEa3XeuSdg3txXJKl3w1COuIjn+HTTe/xVd1ez+g8S/TcW0Xc5klMN90Q5dXWOBdRous1rKskTPm/GgdVs/QZzMkmNFMng8EjSqbDkf925U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598700; c=relaxed/simple;
	bh=8uAKE4ueNMd0aSGsxS2kQiRNaOcMtz5ZCAAuLV4T9+c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZUWxoWnLtynVFivzaPLyw6+fPUTo4bFajGTwcJ04IWUaxK0f6KIkXPsPShg0fujzN/QpN8ahc3/nM/jcZ+aRwZBRUcrmGrZlKmpYcv6+e7IVukXv+aTguSu+kyFcZ1wref1hX7JZJSJpwivfeQ/P0Xl4xwYPgwPFYdZz51Qnq0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BK4SWUBu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea0c861834so441628a91.3
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 07:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731598697; x=1732203497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nrghbEI+TsYbtMq/izvt1GHrUUl0ZnJFsIi7cn6pUdA=;
        b=BK4SWUBueAtOtlT1Ir5u97O8rdsKZM4HfxczgTwryffhm9yzxYfD4Yc4Xlbom1wXsp
         OAxZ4lLoRx8aEHqICPwGsWnMBz50HRdVnAOWVuxkH0S7z8b07HeHEzdKP7+pA1Ex6qSG
         dyFYHGKNnaie5J6hvBC/u9lRwtg0nKW9wl0Fp8YRDxfipHV26YY5WlFzGZn+9DwwFFHP
         tWsIECYp29yO63AVKzErnvtcyD5TeNhwfoyTGPlSj7Xcz7ufxiXzM0A64OtkiKvQT1iN
         5+5Tpstbrg5KTADvF06sk6cS7ejRAvjArzBHu4jP4c/aHwU+dzjrUf5REZ2/6hV+AhHf
         j0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731598697; x=1732203497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrghbEI+TsYbtMq/izvt1GHrUUl0ZnJFsIi7cn6pUdA=;
        b=SDta+M9YnV8q01O1EBd+mNPUQtjv4ZUt5KamLI+oyD7HDs5zdknF+oFgFXKeT61qrT
         yc77RvvTJoQ28MKc8xld7xfUzK36EpS0Z8dvNpe3b7sb1hIYn/eKmh57tGeoJy0ay6RL
         oLoV2QSZEk6KyzL0c/Ky3s6vbXXQ1K+4TpQ7h98uXeZc9i5slKK2jYugnZ5FqrUWQW6v
         +C90xWSuSLb4RqxZsi9hDCl9687YRrrt1WXyiL85LD/P+atd2hOANstTfbMfG5lMf5kb
         Aq8u4PeTp60UnQMf4CJMhkrIkeNZxv2xOV4YX8e8imWDy2Kps9ZI1USzc68sq8TXrPHk
         ZRhA==
X-Forwarded-Encrypted: i=1; AJvYcCUiJh29AJlS1k3FrhmlQlfINglUcJZ4dVdp4viO1X89Ydysyj18Wpg1yOLI5q08lqL1/CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB1z4vTyrUrM65yymeclE/iNd0H1NmThthRGEi6sTfvsd4+PBp
	cr3B9j7APsWAYnwNXQ0liUC7NimYKZkgbAW7m+N+3vhAI5Pu6DpG/svgvTscZSKV5IZ7JXP202t
	kAQ==
X-Google-Smtp-Source: AGHT+IFZkSoZg3ul1mmW5lhfWd9c1u9W2ZDRyrepFRM02g+D3CvPh2OtOXG2/DORJfcwlC16RJHonxT9FHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:8ca:b0:2ea:b9a:f6bb with SMTP id
 98e67ed59e1d1-2ea0b9af9d4mr2901a91.7.1731598697039; Thu, 14 Nov 2024 07:38:17
 -0800 (PST)
Date: Thu, 14 Nov 2024 07:38:15 -0800
In-Reply-To: <70ee319f-b9ec-448a-a068-8165c8e38e6d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <ZzU8qY92Q2QNtuyg@google.com>
 <70ee319f-b9ec-448a-a068-8165c8e38e6d@redhat.com>
Message-ID: <ZzYZZ4MgMhavYDM2@google.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 14, 2024, Paolo Bonzini wrote:
> On 11/14/24 00:56, Sean Christopherson wrote:
> > > +static bool kvm_nx_huge_page_recovery_worker(void *data)
> > > +{
> > > +	struct kvm *kvm = data;
> > >   	long remaining_time;
> > > -	while (true) {
> > > -		start_time = get_jiffies_64();
> > > -		remaining_time = get_nx_huge_page_recovery_timeout(start_time);
> > > +	if (kvm->arch.nx_huge_page_next == NX_HUGE_PAGE_DISABLED)
> > > +		return false;
> > 
> > The "next" concept is broken.  Once KVM sees NX_HUGE_PAGE_DISABLED for a given VM,
> > KVM will never re-evaluate nx_huge_page_next.  Similarly, if the recovery period
> > and/or ratio changes, KVM won't recompute the "next" time until the current timeout
> > has expired.
> > 
> > I fiddled around with various ideas, but I don't see a better solution that something
> > along the lines of KVM's request system, e.g. set a bool to indicate the params
> > changed, and sprinkle smp_{r,w}mb() barriers to ensure the vhost task sees the
> > new params.
> 
> "next" is broken, but there is a much better way to fix it.  You just
> track the *last* time that the recovery ran.  This is also better
> behaved when you flip recovery back and forth to disabled and back
> to enabled: if your recovery period is 1 minute, it will run the
> next recovery after 1 minute independent of how many times you flipped
> the parameter.

Heh, I my brain was trying to get there last night, but I couldn't quite piece
things together.

Reviewed-by: Sean Christopherson <seanjc@google.com>

