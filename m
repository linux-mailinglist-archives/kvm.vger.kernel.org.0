Return-Path: <kvm+bounces-7757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFB7845F4E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 427B61C22746
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA7212FB3C;
	Thu,  1 Feb 2024 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBeRCQHw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684474299
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 18:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706810571; cv=none; b=UWs73X9R/nq9v14+S2QEU5HxUKfIaaqLS0DXVhbQuFMMMNL7lYoplhGYf+0QDID1aC2BRtzuF6RW9U1ISIlt9PM8AP1/u53UYosTZqOVs6w6rltgunAMpingD347aY+KKRsXx3uhU/dwHqEK8a9cZrN2mKTR1cCsBkoK6bKMxxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706810571; c=relaxed/simple;
	bh=ColfYwGzOWxKPXerfApdGAeGET6bCQa3gNPmYycvkQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Urt229891h4krMDSNhiH+5THN/NRg/m6B6KHSCbilsZAdv138IfwBbJ+e85k369lkfn1VZDfqObltgekQBTI1d5J6p2JrESICd5MyLgzj6TUM0umMjSu204fdRr8qQ4zgqgUsoZWByNIDWkbN5tz7fp1cGMBOKoNwNdJ7v7Y14s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBeRCQHw; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60403a678f2so20844687b3.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 10:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706810569; x=1707415369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vt7MU0bmv3DhhiQJ3wtJw9K+Dqd9x1ouKjCbyi3XDIo=;
        b=iBeRCQHwnhng3F7xF2wvH9rngX7LXNNuPb4fIrcvbWP0PKEchzldpXqbtvENO0q2af
         8ufDzTTB14ip4V47s2EbwMRCybDCocdBE8iYQwwmKv4HwL5EcHUqc89OZCg/CvwfD8eh
         kdV+WzDrl41kQ++QUXTNQoGBaouklYy83LvdvLajTYBun6f5/VUhO0yF8VpX4BfyiZv/
         gQ9Ueb8gYuFztOFz+6nmkX0sZfej2ov2Eb1vnoNKys5esCjsXIhUNR/fQAc8KxPlsnSs
         aAbM2TNGdJ0OC8Oxjit+M7Yk0zABfE0dW5AoFvWQ+NH1td3UVxOA/kmUS7Mw529NX7tN
         B08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706810569; x=1707415369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vt7MU0bmv3DhhiQJ3wtJw9K+Dqd9x1ouKjCbyi3XDIo=;
        b=BBpSV3VKGzuKYTHsPJQmpFC91aP4ApcokgxMTlVDs1gC97zzqbeWFkE9b82KAhKouH
         OiFfexIK+DtLYIiySQkILzba4aPLfsEIK2lMHlO7+t1+YWGTVtbFttqFpRfy4grKNlrI
         tTFkjwdT5Flrxb1mog2M72ICOXUkN0vC0FgS6Sl8zcMl9ApbDWJ8Hy1GpSmuUE/N87A2
         LmXm2Nd9LDUVP3X2zwGypwylOMEDM+GhdN9GmGc0JBr3bhg17eRYF/keWHORZuIdKwx5
         Ai9BzFlJzGGs4DWScVH9BsgNpc+g02falYF1pJW07q/URYYuzqDDK9b+H2Ata2bx2KBR
         sRjA==
X-Gm-Message-State: AOJu0Yywy6egTXILKUFmoYTb1ggrjHutpVO4/O9A4D2NLiCuU9GYAMHY
	i5glJXpD9vIFunD2L4iyIQ7pmGOJ9zbfM9f070oIR/r+rzUkhvpZrmHx6D2OL2c7grdBWMw85OF
	CFA==
X-Google-Smtp-Source: AGHT+IGoUgKcoa4GAi8Lw+GdpN5bAXMcZfSWEQrKdT61wiJMGMnkzYXnrDgYCKzRULVUjofcJPOdgJcRbDc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:13ce:b0:dc2:1bde:b7ed with SMTP id
 y14-20020a05690213ce00b00dc21bdeb7edmr1349889ybu.8.1706810569436; Thu, 01 Feb
 2024 10:02:49 -0800 (PST)
Date: Thu, 1 Feb 2024 10:02:47 -0800
In-Reply-To: <20240201061505.2027804-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240201061505.2027804-1-dapeng1.mi@linux.intel.com>
Message-ID: <Zbvcx0A-Ln2sP6XA@google.com>
Subject: Re: [PATCH] KVM: selftests: Test top-down slots event
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 01, 2024, Dapeng Mi wrote:
> Although the fixed counter 3 and the exclusive pseudo slots events is
> not supported by KVM yet, the architectural slots event is supported by
> KVM and can be programed on any GP counter. Thus add validation for this
> architectural slots event.
> 
> Top-down slots event "counts the total number of available slots for an
> unhalted logical processor, and increments by machine-width of the
> narrowest pipeline as employed by the Top-down Microarchitecture
> Analysis method." So suppose the measured count of slots event would be
> always larger than 0.

Please translate that into something non-perf folks can understand.  I know what
a pipeline slot is, and I know a dictionary's definition of "available" is, but I
still have no idea what this event actually counts.  In other words, I want a
precise definition of exactly what constitutes an "available slot", in verbiage
that anyone with basic understanding of x86 architectures can follow after reading
the whitepaper[*], which is helpful for understanding the concepts, but doesn't
crisply explain what this event counts.

Examples of when a slot is available vs. unavailable would be extremely helpful.

[*] https://www.intel.com/content/www/us/en/docs/vtune-profiler/cookbook/2023-0/top-down-microarchitecture-analysis-method.html

