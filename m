Return-Path: <kvm+bounces-17348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 077838C47B0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 21:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38C2A1C2307E
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63129770F5;
	Mon, 13 May 2024 19:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X2/HHKJh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C33F1E49F
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715629249; cv=none; b=cg2sfQopolEm2TTlRvKdrEFN5Hjm703swQq/5sr05eXO6P87qRjE7nmqQtoXx0jbILGoicwu6dNXgV03E3YTC44o+KXZAWdMorv8qc5sBnOcJi/p8id25/dhHIWivwS204rDYXJgwQHXlpEgjV46ksJh56A+e/+6LMa3srak5+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715629249; c=relaxed/simple;
	bh=//NGOHTIP6HghHGerT7/lK4Uz6RPwCBltXnXUwVGkvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PcuwHcSwnDhrR2gKqdQuJhxz41H+KP2tx/wwEMWgbqALz6RJBWkqNLnxFo+A+dfv1gsvM8iN2W8CStkzqy/cR2Jwo8nN0jUN7pXvBvLFNICATIi7s6h9SCubX6jvba+dIUNN2RGHDfCjMELUdBe6M2w7voBz5k84eNBgFWeuT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X2/HHKJh; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de60321ce6cso8766778276.1
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 12:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715629247; x=1716234047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oVao59+8SWn5R7wq1a2EyacHCsnmokQY3DXiYJQLN0I=;
        b=X2/HHKJh35SGbbfoCeEwrVgbdwXvMBSLfp0FDriUHjM33U+VBxcfE6aMi2QLaBCYk6
         vqD6MIixzDIe9vqYGlrY4bNC8eDBcRtYr/pQwOq3pgW+pUsd8tBXqLRwhdfn7AF+uW8x
         k7Qm75uQHgLcwCI/RiIy0MhufQUyUaY6NtlaflBU7Z8wmKOKSUUr795y5z9IuejnyS4o
         vZsx9HDhwxl3z+lWVrJOlD3AHpBhup07by/z2/KwAF1aFaaYxbxt8NqcDvUivJuDrT/0
         NmVPvAIuH4/RLJvhXkpR3fGMjHqnBjGilIFGo+2Iv+abbAyQHnGljcHON9N3TjdWzz38
         GwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715629247; x=1716234047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVao59+8SWn5R7wq1a2EyacHCsnmokQY3DXiYJQLN0I=;
        b=lOCVoitfUdwEhQEXGz4Pk4laboMpNPiC5R9hL3QgvPHZkuZuroDZdfs2/bzTM9NoTf
         pZau7m/MkJlc2qIEd+nYSUV1iNdqB369GMLIz13l1gHyHwSdDhvaToBl+5WDErBT7p7a
         Cs6dTLOOO2rmJUj3Yoa6MT5g5Tv/cGKUJ3J0nBKws7llTjuHkcYuamdcknNQLGUkPIUv
         twttFlzV813gP5oPaf5VlxnrD0YCc9ra79MiarqA0FGbUjmcMan4sXATDNbaROOBvYsc
         fOPI9q3p1fH872QmR+YaTty6v8GqDFyFtTj6822r0TvCvbbaF3YzWZ838quAkmGXfb0F
         UwCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsjhU2P6LvuuzcICed+W4su6hRQi7kgj18eCvHBgT2ewmAw8VqgnuHJRCuIoEpwMaSiIMuo5sGaLANJWCcjYrv4aw9
X-Gm-Message-State: AOJu0Ywzsj8CSOFeyI3IoK+fza7kQeJhjoLjnDYbHZ/4osV2BgGqSU7U
	GxM03zEbieIyOBMmEolk+e+chLAJ975Fwgzzu6GO9kZV4+S8dWmPUgDc9PcrG73CqgoTgfrIwnv
	pgQ==
X-Google-Smtp-Source: AGHT+IHQJ6MAKEsQp7Jyujf1L79g5X9IUEtHDXgP8rtrY9IbuHK5YWHJ/ubuIU33ww2PXq/pEwLP75RZH3k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120f:b0:dcb:e982:4e40 with SMTP id
 3f1490d57ef6-dee4f38b7cbmr3058891276.12.1715629247216; Mon, 13 May 2024
 12:40:47 -0700 (PDT)
Date: Mon, 13 May 2024 12:40:45 -0700
In-Reply-To: <20240511020557.1198200-1-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240511020557.1198200-1-leobras@redhat.com>
Message-ID: <ZkJsvTH3Nye-TGVa@google.com>
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
From: Sean Christopherson <seanjc@google.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 10, 2024, Leonardo Bras wrote:
> As of today, KVM notes a quiescent state only in guest entry, which is good
> as it avoids the guest being interrupted for current RCU operations.
> 
> While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> check for any RCU operations waiting for this CPU. In case there are any of
> such, it invokes rcu_core() in order to sched-out the current thread and
> note a quiescent state.
> 
> This occasional schedule work will introduce tens of microsseconds of
> latency, which is really bad for vcpus running latency-sensitive
> applications, such as real-time workloads.
> 
> So, note a quiescent state in guest exit, so the interrupted guests is able
> to deal with any pending RCU operations before being required to invoke
> rcu_core(), and thus avoid the overhead of related scheduler work.

Are there any downsides to this?  E.g. extra latency or anything?  KVM will note
a context switch on the next VM-Enter, so even if there is extra latency or
something, KVM will eventually take the hit in the common case no matter what.
But I know some setups are sensitive to handling select VM-Exits as soon as possible.

I ask mainly because it seems like a no brainer to me to have both VM-Entry and
VM-Exit note the context switch, which begs the question of why KVM isn't already
doing that.  I assume it was just oversight when commit 126a6a542446 ("kvm,rcu,nohz:
use RCU extended quiescent state when running KVM guest") handled the VM-Entry
case?

