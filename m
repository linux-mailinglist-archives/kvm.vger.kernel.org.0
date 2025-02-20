Return-Path: <kvm+bounces-38777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA670A3E4AF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0838618911CC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9092147F9;
	Thu, 20 Feb 2025 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lKgC5Z9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9E1DE8A8
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078383; cv=none; b=NeWEQ4Q0D5t5KOAMeA6SAmfnLJ56/slP6kqLuIxJaxz6ljMIxNUXffUE+xtDbZnBUUpyVFQ5uTD43Q8B38LbRuLdrPXrlu+MC1YZthhlroDouybRUuqeMNfhFgkrHHnP1vQwfMniVQqqxFFZMI+oIgOchd7zaROevdK0t/6rE+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078383; c=relaxed/simple;
	bh=Gzbk8oA647+brSEDreQ77ec5kJRmlNAs2vI+Jxn2vig=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=itrurnNhwhBumgAYOZGiDTUZN9QncHWmeUQp6pBdvM7zchEFjP4uE3VeW090R8/Pe4DwENWbiIyzYmla1CL1eJI19YSemYi/r/PMag7fuyjVtU5MaVu11Tphqgus2USuHpBwa685HO9TjQb8NSJHvhg9YpIusbfMOQ9VBdz9NlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lKgC5Z9l; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220e1593b85so24887945ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740078381; x=1740683181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYhmmzI3Hvwj43jd3AGtSlQATpJIQs77a432LUSyQpc=;
        b=lKgC5Z9lW258rxnIiKXdfbZjlLCIvEOGld93AW/N80lFn+Mu5/ZnWZowg2N9twcpMu
         TiMg8u4/Qub1YbDYz5agI5ybinN2USoQuJUp+NVg3HZii7naK9nfrlLSuqcqVNWkElvv
         INdG1JC7S9ggGw5MbN/LXOElCHFw79S9QkD3XDlyYqeqtgFN2d3E42MbO+HMbCFBZl0m
         vQvOSzC2GMX2R97zOQgItJSjeshrUEdePzXZ/dQ/YxbJlvUtx3qA4cZ41ic83WVINNwH
         s/rM5YV0pc/2HZfyCj0SQaBX0hQ3rXq34558RNHCH4d0geOSMVRiqY+l4lZoLTDsVCAZ
         B/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740078381; x=1740683181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYhmmzI3Hvwj43jd3AGtSlQATpJIQs77a432LUSyQpc=;
        b=LmzmznplsykWtB3O5E3bRvwBJqGodJZzt44t9xik6KPjWUl6EMuJpO23RWZwEuLuWw
         5j/FyXdv4QTJDPd6srzHeQRqSsOCTHl7JXGhQ7e0OBKDdtxc0eC6JQ9YDFO/o0yj378l
         FfOpC/FXcoH/Dsm5wqGvIHHXpg8N026g/5kTiXRcekEe6VhmrU1XpG9m+5QDtwO3PYKB
         EU9uC/aG+DoKYGpItBctHVp1fFI7qMdrbeFhvlXva4+mRZfhuc53cMOlnY9sTzF8mfqU
         C9dDSPUjEDjeAe1rNEomOrRqKDXKEYkhk2i8n+kMxI9qg5j5uQtD8mXIwM5ytHHg/jsX
         CUjg==
X-Gm-Message-State: AOJu0YxC2+M87HKy2mg9RwPkSrCaiBOWc98aL3RCMAZsRtKojicggYOC
	uITH7RZ9RQ6Wms5oqBse1DWadBCNcooEC5mXB/BKyi6woJyGwOP05e4iFuYqowmaAqkJuJIRy3M
	JyQ==
X-Google-Smtp-Source: AGHT+IFXyWr30olnhXnQKr8gljwMC5dRN1BqTBYjzWrisRg3RUqgnh3sbDODHI0ookMdRiupVLMtBcw5Dmw=
X-Received: from pgar14.prod.google.com ([2002:a05:6a02:2e8e:b0:ad5:3aad:2e8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a1:b0:1ee:d418:f754
 with SMTP id adf61e73a8af0-1eef3dda0f6mr493309637.40.1740078381385; Thu, 20
 Feb 2025 11:06:21 -0800 (PST)
Date: Thu, 20 Feb 2025 11:06:17 -0800
In-Reply-To: <CAK51q6WPAWbmqL=qaiPU1cg1rNAehzUpaZS3K-oWmRU+KD5Gug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CH3P220MB190880164B32300C91BBA037AAE12@CH3P220MB1908.NAMP220.PROD.OUTLOOK.COM>
 <CAK51q6WPAWbmqL=qaiPU1cg1rNAehzUpaZS3K-oWmRU+KD5Gug@mail.gmail.com>
Message-ID: <Z7d9KZWpOpUD6TIc@google.com>
Subject: Re: Interest in contributing to KVM TODO
From: Sean Christopherson <seanjc@google.com>
To: Aaron Ang <a1ang@ucsd.edu>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "jukaufman@ucsd.edu" <jukaufman@ucsd.edu>, 
	"eth003@ucsd.edu" <eth003@ucsd.edu>, Alex Asch <aasch@ucsd.edu>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 22, 2025, Aaron Ang wrote:
> Hi KVM team,
> 
> We are a group of graduate students from the University of California,
> San Diego, interested in contributing to KVM as part of our class
> project. We have identified a task from the TODO that we would like to

Oof, https://www.linux-kvm.org/page/TODO is a "bit" stale.

> tackle: Improve mmu page eviction algorithm (currently FIFO, change to
> approximate LRU). May I know if there are any updates on this task,
> and is there room for us to develop in this space?

AFAIK, no one is working on this particular task, but honestly I wouldn't bother.
There are use cases that still rely on shadow paging[1], but those tend to be
highly specialized and either ensure there are always "enough" MMU pages available,
or in the case of PVM, I suspect there are _significant_ out-of-tree changes to
optimize shadow paging as a whole.

With the TDP MMU, KVM completely ignores the MMU page limit (both KVM's default
and the limit set by KVM_SET_NR_MMU_PAGES.  With TDP, i.e. without shadow paging,
the number of possible MMU pages is a direct function of the amount of memory
exposed to the guest, i.e. there is no danger of KVM accumulating too many page
tables due shadowing a large number of guest CR3s.

With nested TDP, KVM does employ shadow paging, but the behavior of an L1 hypervisor
using TDP is wildly different than an L1 kernel managing "legacy" page tables for
itself and userspace.  If an L1 hypervisor manages to run up against KVM's limit
on the number of MMU pages, then in all likelihood it deserves to die :-)

What areas are y'all looking to explore?  E.g. KVM/virtualization in general,
memory management in particular, something else entirely?  And what timeline are
you operating on, i.e. how big of a problem/project are you looking to tackle?

[1] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail.com

> We also plan to introduce other algorithms and compare their performance
> across various workloads. We would be happy to talk to the engineers owning
> the MMU code to see how we can coordinate our efforts. Thank you.

