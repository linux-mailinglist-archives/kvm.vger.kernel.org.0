Return-Path: <kvm+bounces-24079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A65E395115B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EFCEB22B29
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF0A10953;
	Wed, 14 Aug 2024 01:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sloy322b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D58C04
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597426; cv=none; b=TUDqO48cSC5iwjPJ6tCi5Wgt5E+PfId7xkE+q6M/b7vui4uGxRgSXM9NNcvpxGtvYzJAB2/x8YmBWXet/1OQxS0TLgIf6Y6f85Ffgs3t8+ZMRTMRdcwctCLpyBq3ryQlOr+VddMGQxXpW/SbL8aRLPYxg7RZxU1N5Kl4hQ4SxuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597426; c=relaxed/simple;
	bh=/l0rXDlvw7NhjD2gM02gSHjD7vmJYerckruLlAuFmaE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gqReJWAYXB+D9maWEuO2+6XdEPEF7Y5H7xQMyA3NrukqjS/3xhARzsu8Z572naUoR/G2GSYBImPgFMvpSpRZ9o3+fT5lsu6LKSX3vM3iL00Sl04JXy1MTuxnDB3SljLti8D7x2zbMSHeg+UuZtiP49HWsAKo9HzIFrAB/ZaI1jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sloy322b; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd72932d74so57151885ad.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723597424; x=1724202224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6GXHPkr3SYkJk/BjQwBdG1N86V9MTczoF7nIyPuYFg=;
        b=sloy322bjPljuN3JUyLo9gt8trnhqIIjr3GV/47Hde1uxkYEhLzWStZsYHSyZEYfid
         Y2awcIQ4KcVRzEoErYf90Q2RfMap6l6CJamS/gUJ2uWCBKS+Fp/ZXJhjZ8ELTzFOshqe
         lVUKqU8vOVf5Y7NjlbbUFtvyio3Uc5Kqbq6wEOQ2eJikVK+o8Yr7iOhnE+Lgv+jCbruT
         1+rVwpXvESAYXTzrkSEfekahRrShqkYKYT6Bn5I9tiValjFo0U8mngoFmIfJKAPETbpA
         9/n8K8Zx/Pzq9xA2CyGrB3OIXcKBWNAGt16j9d0tnyfBXbSwi3+waNr6xRkfg2tZ8RW8
         YKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723597424; x=1724202224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6GXHPkr3SYkJk/BjQwBdG1N86V9MTczoF7nIyPuYFg=;
        b=JBCosHE21/xpoTnjhKGP4snZ2nmhFyLPhvMUbOb0MGU4nJXee9szD1oKp0OKl4dUCf
         yTIlwFwQAcxbcEOuMAQxviiLTHdfyuSrfLIXPhhTsVF3WtLwD1fQlGkLku0tUQW5lU+v
         MVZLCAZQLLlIbBAqMLtgpa0izmnLE7GcBrhUpVMqCXObgwfTed11tPzzGcKNPlohKbGs
         0b6jmxxLM0iftI7/GfZKmkuPMHthPAo3JZRfCA5N2iXKxqsfcy6nj+jc7ejTZDcRHBkn
         ChzKx9FPIPCqn6qI5qlq48nYYDcY0s+1ZaB9kbMm551HhUl6CUivLZDoTQeVrfTeQorj
         359w==
X-Gm-Message-State: AOJu0Yxo5caykqs0DpF4xYrXuE1rQ2bNHKIH8A30KWdhM1iIlQpBijHA
	bFA2FsHUT4T9gHZEium0L44pViCVcSSa8M6PzHYmO2C6Dh2YUEHxJfxB2QEzMZFG5i5JTGDbUw1
	xUQ==
X-Google-Smtp-Source: AGHT+IFp+zkpt1P27X4CXq7C4fu6+sC7L/9JCX5CTa8notXBHyrfBfo5f7Po9lUup6Tm8E2ohsfwgwS1+Wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8b:b0:1fd:6529:7443 with SMTP id
 d9443c01a7336-201d64b4f7bmr898275ad.11.1723597424379; Tue, 13 Aug 2024
 18:03:44 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:03:42 -0700
In-Reply-To: <gsntv8049obx.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZruZjhSRqo7Zx_1r@google.com> <gsntv8049obx.fsf@coltonlewis-kvm.c.googlers.com>
Message-ID: <ZrwCbsBWf3ZxAH3d@google.com>
Subject: Re: [PATCH 0/6] Extend pmu_counters_test to AMD CPUs
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, mizhang@google.com, ljr.kernel@gmail.com, 
	jmattson@google.com, aaronlewis@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 13, 2024, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Aug 13, 2024, Colton Lewis wrote:
> > > (I was positive I had sent this already, but I couldn't find it on the
> > > mailing list to reply to and ask for reviews.)
> 
> > You did[*], it's sitting in my todo folder.  Two things.
> 
> > 1. Err on the side of caution when potentially resending, and tag
> > everything
> > RESEND.  Someone seeing a RESEND version without having seen the
> > original version
> > is no big deal.  But someone seeing two copies of the same
> > patches/emails can get
> > quite confusing.
> 
> Sorry for jumping the gun. I couldn't find the original patches in my
> email or on the (wrong) list and panicked.

Ha, no worries.  FWIW, I highly recommend using lore if you can't (quickly) find
something in your own mailbox.  If it hit a tracked list, lore will have it.  And
if you use our corporate mail, the retention policy is 18 months unless you go
out of your way to tag mails to be kept, i.e. lore is more trustworthy in the
long run.

https://lore.kernel.org/all/?q=f:coltonlewis@google.com

