Return-Path: <kvm+bounces-18820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABB28FBFF6
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4238D284B88
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C24D14D6EE;
	Tue,  4 Jun 2024 23:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BD/4ppr3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF1B13A863
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544284; cv=none; b=dZ3H/15hn3YZy9Xgs6DwyAtmFNO5qyovdEKY5G9zoMQupr8vev8qmFsxP8B7CDjOJ3/kL1O8mU0IyVhf4UrDRVf6eWLEO4f8KT0nzm8RSWFMh9auphsTpiE1308zq25NdgE+dT0SmZYk6dAyYZ8nqE2RRzE0rn2ndYefQhDT4Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544284; c=relaxed/simple;
	bh=uCtcs6noFPE6r6gdZtSWPlGrjWvqC6KqdckCJe7HWX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mv+ox5aG9/f11tO9Fy5XgYIgxiMwtaRB/8DuV9CNn9NeM02uCZQaFPpnWmJdsDpp+AMk+m8tSbJMrys+JB1Ygnl16gJgvBOxDc8I/h+0xVfwLZUCccDI2u5CSstoQAaI3U7ee9BTz5RcPdrSqBS3WO6Tp24ENs1Saz8IfUK1rdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BD/4ppr3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c1e797cafcso315241a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544282; x=1718149082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rk/FtP1IyVv3vBWrTDjMqBLA7Gf0KiY9agQ/oo54g7U=;
        b=BD/4ppr3C6nPPgGgTQB/aEqlJaRdAfr18tZW9g3nuyYPYlBHL0W0rIwzFXGCM0YD2c
         a9ClTmqUDMQXFht8GM6VqCbmqFYA6lp7DROy0breCzD5gJixNcDzP5YEMDMNflYSJLn8
         IM7nBLfOccTTwvVFxqfyDizBy4l2vfUtkUTgk3ABctotDbzMaP6M1YdEYqd5Qx7dKjd0
         jfRQgs56yAgaF/SFTn1HjgL37AkhNWHw6ph3nKZ0R9UN9MJ72yYM3La9xzuFgvzOozsp
         waDHm/+LMIW/YR0nOgwKIKBgsdG2LOZmbUnYH/nRxj5JupJoKREPAeZB3reX3rb9iBRi
         pdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544282; x=1718149082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rk/FtP1IyVv3vBWrTDjMqBLA7Gf0KiY9agQ/oo54g7U=;
        b=dtDksigPX+AxG8KVAKkrglhBQal3+FNbgfzMlybi/b/NPyObh8qfAr2WX88npjjENF
         jkqNt1MDYNfESxBUJ1xOrO/0KBxpYICx6NgdGopDvT55yyl+6kCtyZmfgP+3G756RG+/
         2gQ+WgBnh/O6iDbQHn/ENL9AIs6GAq9K/drhCv1RFwgqtpNBgHAWvw2lXq7yJjOSaI39
         QOM4Uc1qRwe3vaZp5zblgIP2EITeaZluv+jQdvzW+ymboZJsMcL0NLaglrjKz9HJ0NlA
         cVlAZ/EtQvnUYBPL0MhGhj/drfqrwLsYO6Z7uG3bcIN0RXx2lSnnTVImgeh+m0fYm2T+
         4qtw==
X-Gm-Message-State: AOJu0YwcJ9FSsD2De1a2KqglLo4nurcZERAh4cXNEXK71hfmSBJHNJBM
	hqXjFrVTRZGd3prCK7TGVxJYPuKjF1ZVY74/6tiOf6WTq/+9N09Uky4vH21k5frG7D8XoiVAucm
	Yxg==
X-Google-Smtp-Source: AGHT+IHZIE1aSJKNameo12IiZOPatLKvd0dlaPUQsUUAhUvJrz645sSwhtTznVjkzZVO3C3zlnmmqxLLb2s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6b07:b0:2c2:4117:2401 with SMTP id
 98e67ed59e1d1-2c27cc5925cmr42158a91.2.1717544282231; Tue, 04 Jun 2024
 16:38:02 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:31 -0700
In-Reply-To: <20240423191649.2885257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423191649.2885257-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754322115.2778750.1004415588461260295.b4-ty@google.com>
Subject: Re: [PATCH] Revert "KVM: async_pf: avoid recursive flushing of work items"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Apr 2024 12:16:49 -0700, Sean Christopherson wrote:
> Now that KVM does NOT gift async #PF workers a "struct kvm" reference,
> don't bother skipping "done" workers when flushing/canceling queued
> workers, as the deadlock that was being fudged around can no longer occur.
> When workers, i.e. async_pf_execute(), were gifted a referenced, it was
> possible for a worker to put the last reference and trigger VM destruction,
> i.e. trigger flushing of a workqueue from a worker in said workqueue.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] Revert "KVM: async_pf: avoid recursive flushing of work items"
      https://github.com/kvm-x86/linux/commit/778c350eb580

--
https://github.com/kvm-x86/linux/tree/next

