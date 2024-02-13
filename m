Return-Path: <kvm+bounces-8592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E56CD8527DF
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 04:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B1F8B22D71
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2A910A37;
	Tue, 13 Feb 2024 03:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PoaFizk0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603C310A0E
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 03:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707795898; cv=none; b=BH+STyknOpU9X0kFDUhOsazEvmft14vEi6jEsXejP3Y5mGilGUdEQbZ6lUDTbUKoWAY/mNvvDYd9GaY6uvNLOPxacLBe3GJ0UtHEySpZA3fboAX8o85H+ODsZGPsyV7tQkrPfR4k4npGN3HYP+bBwMqnzO8A+hrZAdFY8edDDV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707795898; c=relaxed/simple;
	bh=JwAyQWe7miwq6SVX7IfW52aLND0+2gi89T9lvHbisTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n2qIpUPlioCj7qFWWwVho0wrXmVSuf55xnF0lDeG0ltYTG4b3QHEzllQHuQYoQQ6uKjW27thQXs3xjkCOmzYtWF+EK/HpU36S7C/5ATYRJRxzAaNm+Hp3/Hf8QnZ49QEMAau6INOhBh2hq7cBO758MfY48hQlXSa2Jeu3oxnS1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PoaFizk0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bff2b792so3980621a12.1
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 19:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707795897; x=1708400697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp/byxLraC807sITtGRawodDTA1fNMfQwGWNUUbWF5s=;
        b=PoaFizk0Sk9zLTJeuX4QBaK9mLQkM2HIK6awDJhDVIP94TKx9cnp6P2R7tMkhvPFrs
         WkkwejOzMLin2jb6UW9eI0s/OmPAuLiD2PlZSjmOiDU0WDvw5QzSUbspaQPPTv93J6iq
         k9h+4diSW/suYzS66quIOohruHvOxm2t5O/bYYxnl0WvSksBXw8WOPXwHQs94V9LvgWy
         BKQfoCaniZ0YhWJPFpgWC4aEnp/TKes83esbiCasq+rsgIrniZpUqk+3psATHWSPcmDT
         3/Ngcr85kxVXHAJNO6qJgCwQLnCP9oBo+wR+yu3E+di/NT0nJnpySN0BMKZqkhfAeOHS
         XN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707795897; x=1708400697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp/byxLraC807sITtGRawodDTA1fNMfQwGWNUUbWF5s=;
        b=kSOeT1cE6JMJSKVzZaN5DXz43QZSEajFlp3kFafXVVVIDoO7rTrVmNaZ2rSj9hB2Gz
         kXx6dcSHKAUr2FXb3w3+J/SBYsPYtnM5ax8mmHg0qMw4HlU+skdwxA1iAVRS8y+9dDH7
         sT+/fIC4HqvG9zsqRENg/5mf8knjc72as3vjgh4tTmfAAELl1NrVjMrNtwbR4hRLc+fR
         9ULscB0+UwufUTSXVsL6GbE6GZMWWLB0AMEbRGJ2IHyDCk5m3/jmT9ni3c0RMefoKKtN
         +5K+pBx+xH1oHPVlYoN+K4W2/Qys8UaTuhPryVLntf0Ls9xDn8iWKvnJFChnoWpbCIEe
         gYgw==
X-Forwarded-Encrypted: i=1; AJvYcCW62lZRHqGbTre6ulIfSrmuLe04L9MxwLmMOgQobp5y/aej2FYijJv1JKYXJ18tt5LHzecf7WrTzNX/EeKDycWfZLfO
X-Gm-Message-State: AOJu0YxDZGf2zcaCMEX5SbDggujYlRvXKVZYCcmJAClLB2fuZ7arFAgp
	P5dzvDMMc3Omb/kzgzzGMe7OTaeCLARsad4Axx/El9A2f5REOduEesW6K7SA0K90slH9zcocb9w
	7aw==
X-Google-Smtp-Source: AGHT+IGGI8Fty4SnswScI0YALjv0to7a7pfcE8bH+CFvNEGLJ/DcJmrEz5SnXPWzfMn3EDSiz3p6QME0aDg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6e85:0:b0:5d8:af18:eee0 with SMTP id
 bm5-20020a656e85000000b005d8af18eee0mr107250pgb.12.1707795896559; Mon, 12 Feb
 2024 19:44:56 -0800 (PST)
Date: Mon, 12 Feb 2024 19:44:55 -0800
In-Reply-To: <20230911021637.1941096-3-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-3-stevensd@google.com>
Message-ID: <Zcrlt0xHdRubEDLJ@google.com>
Subject: Re: [PATCH v9 2/6] KVM: mmu: Introduce __kvm_follow_pfn function
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.

Belated question: why is there no kvm_follow_pfn()?

