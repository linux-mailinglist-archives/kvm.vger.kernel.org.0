Return-Path: <kvm+bounces-14051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF5C89E6BC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 913C5B2243F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9845D385;
	Wed, 10 Apr 2024 00:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+TQXp40"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C24438F
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708552; cv=none; b=AF3VY9OE2fXEVoQAQwPIvChxMvoBU35QlIzIIbvgqPYq/oEgYJMKgxiBsT/r1yj/K6FC5P/g5Ly2MgWpLWAJDHbxGwErlXFZ6W5xUwiEFwNrOWAcVMd9VNV6DUKJz4PhCuMVYo8krMKDfQN5r5xBc+yGiOYfjCmgCJj9im2WpQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708552; c=relaxed/simple;
	bh=Z9rrIYqtjyBYONugzEHEVOXxHicHAUfstC3/uFmc8wM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=QZO1vvy0hGKkdTurlYxVR3+wX14Aoq2TcGIQsaGXsmOTNUjQL421ubk7SvMvka8R7Itwm9PnL8z1Ux0DRPscN9bxILztQuFN9Q/czF7/NeDdV5J/xnrR4LXxeUNDuNMBTwkEIjzC4pCZiMEaewAYlaA518fKolKdYaJrIADr7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+TQXp40; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4a072ce28so5515037a12.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708550; x=1713313350; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5sfMNCEkatI5+37V0HtPWgRxldSFLEUDvaDizvYyy+g=;
        b=Q+TQXp40mEFOsTakqNFhBWNFitHPPBGP4iFg88hfWtZdq6DLtEMrHqTY598a8jQnD7
         s9HP6STsu7kXcm+/5KNzrKIXMKgaHBCxgDQLrIaPCXDfpYJTVyNv4a2G4txSS5JSOtHO
         BQ1N4JPnkJGPKaqBYKCobQXGzwAczMHLu0xSLY6FNOOlWBZcBqDRB3zCaLLwMiBOt6lK
         UeJaIMYfoo7WUenZ1w/UafpMbhJgYHgIw1Kwc7u/j+QUpjYMmKpN9BrajMAmhp5LZbsy
         3mMozk6fGd1Dhpf/6WaPQ7bnyK/TutbhdIPv1Oq30TC4W+t2r48W/9XBQ2mu8zr58OF8
         rbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708550; x=1713313350;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5sfMNCEkatI5+37V0HtPWgRxldSFLEUDvaDizvYyy+g=;
        b=ayOqUmfohCY1LW+NGCrPhG9OvPaAVo1y3IJW4SspV/3QHpTLciMncHzOYUdSkZsGOw
         Bu7GKkZ06CE35is7DB1Jgy8hkJni1J/NAy1vhVrJl7sdS642NpIGXJ+OgoPS+Gohpslo
         y7+vLx4bE865qRpR3LKfR0W4WusplMeOMxCQSTLkugHHIPdzoAFHdjkL6KBm6xivobD/
         WqM22RtIRIBtbQ4p2Pey/+RTH3hiEMZeqWil4pWNk0XHM9acMgU5FBYd60kmz00Siiae
         BJR4JPdL1dsLJDX1YMv4DO2ol3cSQZQuS3Mr9Z0JRke30UL1Msh2X6WZNaASHg1hVn87
         78AQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFnWs8pAK+ogKYybYnvNRt+MEBdlNjl2Y8ZIfxDxrzk8JfULPFhfZdvt6gRQe2gwd3MOVhNBxabVWCVSxqm08BkP49
X-Gm-Message-State: AOJu0Yy0yN7LdbPEAIX3HyaJu5ls/yxOkjQQfWugsWKUbdUIxVJnTF4h
	II2CMsLoHdXr+bCi2C5o1oSIt+7SdBpAGVNc9Qdhz1a7LweLkkyH6PmbPH0JqlsrrAxHix6DH9S
	DbA==
X-Google-Smtp-Source: AGHT+IG8WvcjaFAKxD0/NsdctMdTpjvXQrYV0DB+YWE9B5yypLHXcHGQ7MZnFwk7sV3FLp7IzhqNqgi4BZ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f352:0:b0:5dc:8f83:ca2e with SMTP id
 t18-20020a63f352000000b005dc8f83ca2emr3607pgj.0.1712708549779; Tue, 09 Apr
 2024 17:22:29 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:50 -0700
In-Reply-To: <20240131012357.53563-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131012357.53563-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270498952.1589775.12428483327634748506.b4-ty@google.com>
Subject: Re: [PATCH] KVM: use vfree for memory allocated by vcalloc/__vcalloc
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 31 Jan 2024 09:23:57 +0800, Li RongQing wrote:
> commit 37b2a6510a48("KVM: use __vcalloc for very large allocations")
> replaced kvzalloc/kvcalloc with vcalloc, but not replace kvfree with
> vfree
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: use vfree for memory allocated by vcalloc/__vcalloc
      https://github.com/kvm-x86/linux/commit/a952d608f0be

--
https://github.com/kvm-x86/linux/tree/next

