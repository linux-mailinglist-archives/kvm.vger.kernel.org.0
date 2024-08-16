Return-Path: <kvm+bounces-24442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 127E6955219
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C336A286D7E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6D41C230B;
	Fri, 16 Aug 2024 20:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlF+gyfT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0655213A899
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 20:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841836; cv=none; b=MBfSkRjrzCvS/0LzaHdaIi8CgkIOafLTXUimfrSI+I6N362XfOsq0+imTuXoVuHMf6TQWQRfAG81zrDyjNaU9r44AoE+ZvUF+VydWvbJrB/IJv+Csy6pVygG+pwhvC4zlMy27rMDpFtdY4eDTh5zkVi7fE/zEhVdn05DxS+Plkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841836; c=relaxed/simple;
	bh=RBEJ+RmDihoYqO8IB9EiZNepAbBIDt2a1lRtlREGuc4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/J7pVirrflkrbTLrL4SNbq5PU8/uKIxcqT8h4gooVTV3nnGczqug0lD+0fivU1KVrrZDicklGVNymrS6CySGo1FGxEHxtzeunbxhW14ioLCYQOTdZXHJ3jZbHbF0gIYJ+eugE4tUhGi/QF0+81xh9jR4e7BgsuAI/evTPvBD7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlF+gyfT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201ee593114so19393325ad.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723841834; x=1724446634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ITzWFu2l2gIOubWBntrWLN53RX2KMrpIXb4EIawwVe4=;
        b=rlF+gyfT94EURF50IR5c7FeieF9I5Pk+BXEqEzoM1Evl0eLeLgLcElH95yG6pLtovx
         7GXIH7m5reOe3mkUgl46biwukZHWR4MilWFEqU5meQfKsWJdz70rODXQzgAu2mJlJIpc
         Slv/NGXWmUSqDaGYLvmIMbfUxFgZEA2uUQLPIXgxxFLEnnLpGfXct9dJdsMTs5CUREJB
         oieT5XzlN5wCbYWMdlgHMtZP6cz/WZK85+3RZBgmuBE+MrUTpr+Ws4E51AmQ4z9BZpXV
         9Cf6wWmArQDX72NDvEqzeCb3uosht+ayY5+8ij7WRKolR/4LzZRwznuwyf1+X33LcYau
         4MNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841834; x=1724446634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITzWFu2l2gIOubWBntrWLN53RX2KMrpIXb4EIawwVe4=;
        b=hUJO3pC7loJTAIH0p+SxGO9CjBfTYUEWdlSm8qFIOkdQQ+km+6otIPGgzUH+ClGJdX
         xvN5Pyk9We8UPZc9eT3ZyItgNkro3UnFBRgNLhQBh+2nAj0cZdt2m0KJCanYMbX0umtX
         PrtOd11pomLe6iEjgrl0gAfRTKLHB1O03YWCoIgYyoPNGzuQyG901NIMzliAaJw2rREN
         8DHef6ZjH7l3s3pIIrLDpSd5xmtPmMjgZALInD2ULstLueR7jehy/UEPiDPLq4Goquzc
         sk2RNiMftULloW5z2eUHC+3CTwdVfG/mDqMcEfHxFEbabGmdnoBBpFeKJD5Pec9z/Dqg
         7ppQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZDWDqpMtbQFGLWGOxzI6h/AftAJ9a8znMooDdJzj1wg/VeC55C0brclHXWXFvggqDtLy2E8UB7t8QSxnJmshZteCC
X-Gm-Message-State: AOJu0YwtJj0wIAhx3GO34TO0hO7sTqJ0w2MWJbMPclmbi3ukApGHIXY0
	eNZSuV276YxAXkCRmnp2m1O+8Hwx8mqQTs/SDTr14kL5XvN+aWqbKwUOfMtDo4Suj87tedMTfLr
	Ppw==
X-Google-Smtp-Source: AGHT+IEQfYawzH1OLXUwwk7EQAKtqFGys4076yqyg7VRWC3gn64VBhuYN9Gdm8xtcwxQcEVyIscKrTCr4vg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b7c5:b0:1fb:f1f:19ea with SMTP id
 d9443c01a7336-201ee49bfd7mr280315ad.1.1723841834095; Fri, 16 Aug 2024
 13:57:14 -0700 (PDT)
Date: Fri, 16 Aug 2024 13:57:12 -0700
In-Reply-To: <20240809205158.1340255-3-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-3-amoorthy@google.com>
Message-ID: <Zr-9KOvcWK6XtA3i@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2
 fault handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Anish Moorthy wrote:
> Right now userspace just gets a bare EFAULT when the stage-2 fault
> handler fails to fault in the relevant page. Set up a memory fault exit
> when this happens, which at the very least eases debugging and might
> also let userspace decide on/take some specific action other than
> crashing the VM.

Heh, most of the way there (from my hack-a-patch response), just need to add
the KVM_BUG_ON() + -EIO conversions.

Can you send x86 and arm64 as separate series for v3?  E.g. for x86, just this
patch and the -EIO changes.  I'm pretty sure the docs updates can go in the arm64
series (I need to send another response to that patch).

