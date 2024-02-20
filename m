Return-Path: <kvm+bounces-9213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2837585C0F5
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504031C21948
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4162E76400;
	Tue, 20 Feb 2024 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wQzC2tsk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A2967E93
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 16:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708445901; cv=none; b=JwDJFX0iR9nFFtTQBDm2MK8lLvTMJj67IQGbNnfcOune1qXnGGRclxnVGxYGBcOzJ8XaEEiqiNkgq4d7O22uvnd4SYeYWhqOA4zJ4Q+msMrQUHDOgZH9wecYkz2E51hGytaJckaitBhd7EMjra3I/1f6GfZiblJVuo0Qo+DBfI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708445901; c=relaxed/simple;
	bh=L6sT39TG9iv6n5WF6EkqkYT75IXBf9GOciPgjE2xBOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RAM8uQzE+Lo7c4++5ripdpWYJB3a2xTJ5ndUdkbgyXNu8+ueaTBm1OJGJv0MGdXNPMiDMhJoR5Dju3sKfdRE5LIWLSqVlKDLYFhpxkGjn/AvRHbICWR1oH12hT23IYOdf921M6kGNQrdhLSiG+7MewhqI56HTEANdq5rdQIXXCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wQzC2tsk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc74ac7d015so7023248276.0
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 08:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708445899; x=1709050699; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S01UQlrgYNJvFJj+ZTGEynd8ASfgdRjDb+KMqQ76eBA=;
        b=wQzC2tsk0lTdICO11YX2GUWOXpjSInSvDMQ6HvgnFJH9H4Ey72qatRJxApGzKlWZgJ
         pGN7uFXd2z61Gnbws2IEHNG9eh4TK2Rq2KF6cZGtD2TDB/uDDv/X3bqRpWugxMKuGUah
         CzuTbqdkcw0jt3M+YC07KAJ5fcYrzqNrmOHjVTkqzb+xQouwtcOwjHLn1qh8cPLwS36E
         L88JCU1tXWvn8I50Zt85o2ZiFGZvX2sGecXNkssYj2nSuYlwdtw6EIGe6nOCsjp7OK/Z
         7BZi3fZotVlDkVch1tGD7iIza11vutUEkcQuQ48+wQkYVKcnTK66JOrBgveKAIezKYmZ
         R06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708445899; x=1709050699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S01UQlrgYNJvFJj+ZTGEynd8ASfgdRjDb+KMqQ76eBA=;
        b=VXwumsB/dJdbP8Pl2YvWRmwLUbajDxURclhrv84C0OaEe2KWlYgRdFs4Er2UH9ydFN
         6PatvWQQWxvgH4LhNugC5hy2AH44fxzmPGd9rdiDZK8bHE08KWgLyilWAGuulNovaiMF
         IBDX8YjAEemtLHeBukp1Cuae0pcYIuwIWbzN+qRXUqOxZGdp+D/T11S7CqSbKifkkxBc
         sQ8+4iwiHohqWyUmiWy7XkoIGe1Njt/6kxSZmEcPfMMkAP5rR+psfC5tP9Tvb+4YCtra
         oUsqsNAF3rSvJfDY4ptjdz4lTWkgllgeL8k0MwVaWerPm/e3pxk+aKxcnIK+rHN0+rwU
         VI5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMr4DsvpOHjzqLqzmbSK8rL94t8JhKCvXR5AH5JU8Hyc/Lg1dflHmS/gh219a0dhsDuKZA2G540Ctdr4VXwQa22aZP
X-Gm-Message-State: AOJu0Yw9a1kC+RpkvOpugh1eP4DMNtOvi5+qra9jPn2WNHayvDYchNKo
	MeNFSg4QwHMGqMnovAtGudg2d56gg76JEftGhhYyIjYJ93qGgqJAwooZ+Q7smvG19iowrTwtcED
	nWQ==
X-Google-Smtp-Source: AGHT+IGQJNh30pNFUgfjDUxGFIU4BwxfHFn7Htyq/Tp3042C2P5MuaZm5+eAyS+98IWp3gYFcBVKnd9pFiY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1001:b0:dcc:79ab:e522 with SMTP id
 w1-20020a056902100100b00dcc79abe522mr641223ybt.11.1708445899208; Tue, 20 Feb
 2024 08:18:19 -0800 (PST)
Date: Tue, 20 Feb 2024 08:18:17 -0800
In-Reply-To: <20240219175735.33171-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219175735.33171-1-nsaenz@amazon.com>
Message-ID: <ZdTQyb23KJEYqbcw@google.com>
Subject: Re: [RFC] cputime: Introduce option to force full dynticks accounting
 on NOHZ & NOHZ_IDLE CPUs
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: frederic@kernel.org, paulmck@kernel.org, jalliste@amazon.co.uk, 
	mhiramat@kernel.org, akpm@linux-foundation.org, pmladek@suse.com, 
	rdunlap@infradead.org, tsi@tuyoix.net, nphamcs@gmail.com, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 19, 2024, Nicolas Saenz Julienne wrote:
> Under certain extreme conditions, the tick-based cputime accounting may
> produce inaccurate data. For instance, guest CPU usage is sensitive to
> interrupts firing right before the tick's expiration. This forces the
> guest into kernel context, and has that time slice wrongly accounted as
> system time. This issue is exacerbated if the interrupt source is in
> sync with the tick, significantly skewing usage metrics towards system
> time.

...

> NOTE: This wasn't tested in depth, and it's mostly intended to highlight
> the issue we're trying to solve. Also ccing KVM folks, since it's
> relevant to guest CPU usage accounting.

How bad is the synchronization issue on upstream kernels?  We tried to address
that in commit 160457140187 ("KVM: x86: Defer vtime accounting 'til after IRQ handling").

I don't expect it to be foolproof, but it'd be good to know if there's a blatant
flaw and/or easily closed hole.

