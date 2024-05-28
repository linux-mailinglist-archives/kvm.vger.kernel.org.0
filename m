Return-Path: <kvm+bounces-18231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2928D22BE
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9408B1F24990
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CDD38DD2;
	Tue, 28 May 2024 17:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o567LG2c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F652E822
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716918321; cv=none; b=r/j/1YsrGJ+Y6cGodYuZDtidiMgpuZPDSMST59KWYg8dJLZ16whXpVQhGSFZ9qhKowKPQ6ZNMIAv/mFTY3xSK0awDGMOOaqS/mQ5nPYsnQ6297o5dgKzPswfxJf6LRmDqzEZpI8teZ0uYqNl9TQmAPlgliFeDhgYqtMkANXXfKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716918321; c=relaxed/simple;
	bh=DNMXKmRTTaQDX2ZCLnu0jMF8Q74NM7QWH/ks6vBNBkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m4J3DA+Tafzcfv255PHtsWtQEVR+/8VVYyAeF4Yfzvf1478A8XNkNZkYYjjdcJ7rbqbYN2tibM+2bzTrWgwsnHshnK6K2mKTiNX1Fbb3cHVfmfobdwi2Mv2320/ZvKYGCJl9g5jwGLbk2p5gYn5lECQklLS5KVEhJjC6J8QwVu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o567LG2c; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df771b4eacbso1882878276.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716918318; x=1717523118; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIGS1cmSx4e8zu+p30sXUPt+x8OrRfAso5NGM8FtoKU=;
        b=o567LG2cD3XSJlLFajzzxP3PPkFbjyhVJtyAutqVn0Ykezpr1eLtHhqXC3Zc9GfE5j
         U78cclI4QOfr2dRCWKLYjDdFsoosJN6Qn8fhIDf1JBTWMJe1lYfwmcvs2HCKpVniZtgG
         IiUAH0d96ucIxir1T4rvq5vhOXbE09TaTnCa9i3NQNR1zrUZaTj/kJ6dDP7iAzRcOoDo
         xxYn2ZzW0f+yfvWE7/zgqQwfqdhiAxYWrwor5DyJ7ww75CHAZyeeaTnlfPqlE4JQLJu9
         3RZsfK+zGYuY7LaKGpcO47hux8nbLz1TEzt+nqpzXOcywciXCN1MkJySX3GgC+xAE2xk
         eOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716918318; x=1717523118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIGS1cmSx4e8zu+p30sXUPt+x8OrRfAso5NGM8FtoKU=;
        b=oAPM0uFrWjc3DJmpji+VlozqtuEBSppnf2Of5OV7Kb0L85iNZKNSlUfSLm8dsorNCz
         nKpFDyBi0tl2nO9SVmSJikIS1CGgi8xXf89VOAYTA3ET63JZeBqBmrAl4mYwX8yhSohH
         tvH4riKDhr4udeLVBNwswcsiXSjndX+GgpztDg2yRAAOnybC5toAIms4lmknvx0RkQ4g
         6ZLMP5xyEWHNDKxD0DKaTIlYIGQLl3hTDDNlytFfbF03wb02HhNsOJ6Y/GPB228Ms+nh
         ttahvEcdsgASVNpwcgvPeq0yb9Dx19SdRpSF6m7ZD6yqSpGdSVhZlk/T25H2KvsmHQQu
         FDbQ==
X-Gm-Message-State: AOJu0YwTFaCpYOrcsqGA6Zv7ft28y9HykkC9b3sWc2bh2JNU9ALEBrBG
	kW+9R44kVmFV0hJli4wpnc6Tm/Iqu5xMwnLL3xwUyJyFeMNwXWy7fuIQ+1RLOZrQV3hXjjKDCix
	Qtg==
X-Google-Smtp-Source: AGHT+IGAG5nuX6TlgZeaW3iMW769D/pF+m4rOkXUlkSz04kYWLTYhkxSejwxks45mnTDxdPmJ5F12if6SqY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:df4:90aa:f4ac with SMTP id
 3f1490d57ef6-df77239babemr3397632276.9.1716918318587; Tue, 28 May 2024
 10:45:18 -0700 (PDT)
Date: Tue, 28 May 2024 10:45:17 -0700
In-Reply-To: <CAD4ZjH0oAfUDfbipQk2YHXwV3zKdNyGwpCyybA=y8_6g3LON0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAD4ZjH0oAfUDfbipQk2YHXwV3zKdNyGwpCyybA=y8_6g3LON0g@mail.gmail.com>
Message-ID: <ZlYYLRW_3Hv36So3@google.com>
Subject: Re: Cpu steal
From: Sean Christopherson <seanjc@google.com>
To: "Y.G Kumar" <ygkumar17@gmail.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 23, 2024, Y.G Kumar wrote:
> Hi,
> 
> Is there a way of measuring cpu steal time of a guest from the
> hypervisor ? Does it give accurate information ? What are some of the
> effective ways to find out the steal time from outside the vm

Yes and no.  KVM's PV steal time information isn't exposed anywhere, but only
because it's simply a reflection of the task's run_delay that's reported in
/proc/PID/schedstat (second column).

I assume there are tools that translate schedstat into human-readable information,
and/or do analysis on the info, but I don't have personal experience with any such
tools.  If you need more help, I recommend pinging sched folks, as this is really
a scheduler question, not a KVM question.

