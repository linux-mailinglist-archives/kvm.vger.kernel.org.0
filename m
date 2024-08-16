Return-Path: <kvm+bounces-24438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A20D29551BE
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C77C71C243F7
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801D61C4637;
	Fri, 16 Aug 2024 20:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mGnyDxZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF7476F17
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723838747; cv=none; b=rQxtffG5opc//vBrCypDDT+STJ23F+nKqsqW7WVUleN4eWtrVidmLYVwpn3ZROAKLZHSsr9/GOhXmzQINNWHqiC9Vdm6oKNPAYLJ2ev/iBPsYa9wBkilM+09sP7171qydtHHUnsbGHkHMUskI/CLiozLi7E4LcwFK7TAFr9enEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723838747; c=relaxed/simple;
	bh=lUfqJdiKyXdL5DWumOyxNsw9mMtzQA9n5hfwk9sycLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nN7HT3S633Q5KeZd7eL9XObwP07qsXgUYDZX1VxNXFUyenL3abG4wjWyqm7hh8ISWgYPpmXZdupKAIIZyjwdhSF8WttA59P0yjxe9186PLZy/uJ8Of9ntmw8UIgbUL7TZzTmQK7ZxZdd5DLlf1NKZfJdLOcu7Hd1tTlIO0sHFNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mGnyDxZ1; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a30753fe30so2040516a12.3
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723838746; x=1724443546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rfFQgdujH5aCk5KKtjxoILURhWSPcU2jN7r6jQZjhf0=;
        b=mGnyDxZ1PrsaH9g7G8bPqIOOqoYaVfcPSe5s9gCqHlysOSki3XB4rhFdUcjHI/Wh1Q
         xmbP8U/NXH7TZ43olZJ8faDMqXiadGWA/r1USjE6+Pv22Xj7t4fwg7RIV2+dq83CqxAZ
         sLa/o73nB4WRAg9VW5fPzwtJ6GsUWxMROtbnYe5KG3s1cnYrdlEPH4aFUuBGio61h6wM
         VKPKu3/7XAj+kP+rvhYNV50ebJ2JiogKBxqRE7ENJxcaEAXzu4eJHnmEPNYsL4WDcChn
         tZliBi4iK3Xz1yrurO7u0c8aRAX7xiQ24WZnuHiHYsTY3ewgpx//YP6fXosL3l5vShqi
         Pdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723838746; x=1724443546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rfFQgdujH5aCk5KKtjxoILURhWSPcU2jN7r6jQZjhf0=;
        b=YOLruoL/8WT7bs2b+wQVg68buzSb7YPBmKORnPur90xk0bxLKltUose8A15cxKYMUz
         At0d3aCrzPaBGCzzoOMrvBm2TOzg66Ue2gCryXJlkVP7+KgGtYwXieotQ3xupWjWvKrL
         K+FIqpw3MejBzfqcaxuh/ZwNX2RImtJ493rJ4n+5Blqoq6gGuk+x8JZjMWAr969AitEh
         oC2GDN7Ln7UHB+uzDk1G2SjTwgxxS+zyuJkkfRU5bogTJ3mFEPOZY2WchEPJWfRczY+s
         x5vPuWEhGwsGci31JGSnYgCLedtrHkLk9phU4WESXJ4QEiUsrYzUHQSCBiQ8PWxCcZIa
         jIJA==
X-Gm-Message-State: AOJu0YytqftbrjBk5t/uykv3iYTZxSANp7oz96x7tWO6judDw6byidd2
	uR/v2/BbnahgukuuHm7zJFAQ0TpiMQeYGHDsG1tbJ55MXvAhXYQ1e9UyMLnCqoQjRpsKdqqCGMJ
	gjw==
X-Google-Smtp-Source: AGHT+IGMmsQGLwshCVsWxdRhYAOvk+D7/QiTxlT4OA+0Z7sU69lhcjYjHpEOHB3YXXiXBAu+rBEhxjKGmCY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4e60:0:b0:7c6:acc8:3eb5 with SMTP id
 41be03b00d2f7-7c978efc48fmr6761a12.1.1723838745474; Fri, 16 Aug 2024 13:05:45
 -0700 (PDT)
Date: Fri, 16 Aug 2024 13:05:44 -0700
In-Reply-To: <20240709175145.9986-4-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709175145.9986-1-manali.shukla@amd.com> <20240709175145.9986-4-manali.shukla@amd.com>
Message-ID: <Zr-xGHQJXc-S_jTP@google.com>
Subject: Re: [RFC PATCH v1 3/4] KVM: x86: nSVM: Implement support for nested
 Bus Lock Threshold
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 09, 2024, Manali Shukla wrote:
> Expose the Bus Lock Threshold in the guest CPUID and support its
> functionality in nested guest.

Why?  This is a rather messy feature to support in a nested setup, and I'd much
prefer to not open that can of worms unless there's a very good reason to do so.

> Ensure proper restoration and saving of the bus_lock_counter at VM
> Entry and VM Exit respectively in nested guest scenarios.
> 
> Case 1:
> L0 supports buslock exit and L1 does not: use buslock counter from L0
> and exits happen to L0 VMM.
> 
> Case 2:
> Both L0 and L1 supports buslock exit: use L1 buslock counter value and
> exits happen to L1 VMM.

Yeah, no.  L1 wants to attack the host, so it runs L2 with buslock detection
enabled, but the highest possible threshold.  Game over.

If we take the min between the two, then we have to track the delta and shove
_that_ into the VMCB.  E.g. L1 wants every 4, L0 wants every 5.  After 4 locks,
KVM synthesizes a nested VM-Exit.  Then on nested VMRUN, KVM needs to remember
it should run L2 with a threshold of 1.

If we really want to support virtualizing bus lock detection for L1, the easiest
approach would be to do so if and only if it's NOT in use by L0.  But IMO that's
not worth doing.

