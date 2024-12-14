Return-Path: <kvm+bounces-33789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3ED49F1B4B
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C15916B247
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 00:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D285539A;
	Sat, 14 Dec 2024 00:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TTSkhFu6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0AF366
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 00:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734135557; cv=none; b=WptfKrlQ4EaQHdDEU0UBbqXN4DR6olTITPdqGD9grp0Y078NqHuZqneGppuNoGvBHnH85jmstETY5cE/rzZnCuipW4GtH5uYWRkuQP0I4vEWWM8wqZtXz2GSZvm6x0CqY0R7Jng1ij+tXEze0b4r04T/ox47ZEadPsZEkWLEP6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734135557; c=relaxed/simple;
	bh=TE2/kej48l1NRoKUvHSl0JMrOqDMY2XcRJWxyjWT/ZM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aV5HGuCscZufFlJRoBaCXIUO2Pq7zv0aTXpofGUPUqaUHowrGMZXsFypEkmGySGIrKJNSrLXKvROdiIjjMJYyBvlRRgIYeDttLt0jLg7EOqg6QWtwO/EltT+n4t/hNE/fH6YnBrjgd30IVSMNnuzKsTY9PFocV45RfV/AHq94dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TTSkhFu6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734135554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QZDqfUQYIiXHYHIZyCyIqi75pB2tEsbcvItBc4XLAL4=;
	b=TTSkhFu61M/MIPt9BYPCGNGuZM8ni2FvbIGE+rG/af8xfcaVn4b3/roOztBxSNX0vqRmhV
	hzMr5L40r9xK0yHri2gIr/2G2mJSnaI8QBcslRNK/vAzdopS4OeQPVbOq68m+JMPu5xwhJ
	Xcd+8qaGuJt8bwAlAyd8R/I340dWKz0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-x-dfLoUJPC-DHiIXgu5Zlg-1; Fri, 13 Dec 2024 19:19:13 -0500
X-MC-Unique: x-dfLoUJPC-DHiIXgu5Zlg-1
X-Mimecast-MFC-AGG-ID: x-dfLoUJPC-DHiIXgu5Zlg
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ac98b49e4dso22304165ab.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:19:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734135552; x=1734740352;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QZDqfUQYIiXHYHIZyCyIqi75pB2tEsbcvItBc4XLAL4=;
        b=r+snKGYhwLx2tML6w5f2e/VrfWKyH2fC2W/LAij4A90Lk0sGSZYgmw6zjm8jV3ypIk
         MuM+EXSaLHnq9OW5BfOFoxCI5M+pEQSmL0yw0hnq6aBTuXQHwr132Z9t1o+SRwfhS2jX
         9QtH78vCH0FWR2q6536zfGhhB62nA6YgUl+5Z7R7bcWPynKnHusgGLcaWxGzG4B6ts2N
         8vXWWejR8a4yC27KFyFijiG4I9aluBSKJCx62XslbKm/1CDiUsghS4iCvU0XD828XzYn
         kdYVViiJ6ZrY3oI6hYsw+XsGTsK4JoR/ADz019IpWTMYXI3iSN9TEeLyoWHGQGmMNL0c
         CtLw==
X-Gm-Message-State: AOJu0Yw2Q1UioAuG5P56HIbUuzcIXuf8UAb0YRvhzUEaYsb1ZvWI0gmJ
	xG5IJQcBTC/ckgJe3xe9bi7xJ2ekhFaZkYZESH572Ie2qBU6LRskd2oQQdYnQCfISRWfFkgR5ik
	1GF/kCVaO4GCJGR+LbY8FMdPCrYGj3v7mcjrBaRqcrdVh/Lpt6a6bjclMcl0hpNqOIXajjVUUCq
	TZeHmumRGK7IZd5OhAEuBmLrEjh72upwL82w==
X-Gm-Gg: ASbGncsM5wmen7DiSC2+m+J7ZnLszNP72lWoDLdRyW/O0uay0+KS8j3NJ5dbDYJEynS
	42ngWmA0X7jKWxnBkkJe/9Wz1VReK/EiVwbGUhavR7kZmgSS4Q9YgXlyl1Eay+inhvirm7Lyilc
	dn/2r0nhI2bAIdNBsaivjsLfDWx+iqUuaYeXCHilDz23DK4W2gigJSp5i3gUzQMD//KSZIvJ352
	5oBE0QSXATQ5WCYIBE7GbLXHUPfQ7nX4NYutGSdm05aVWs84yyZ58QH
X-Received: by 2002:a05:6e02:188f:b0:3a7:783d:93d7 with SMTP id e9e14a558f8ab-3afee9a6acfmr49550665ab.4.1734135552359;
        Fri, 13 Dec 2024 16:19:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEty8swQ/YO+MBCY6GPd6qktbclqIooT51WUJaC331MbqBCLdHaZwxjGP5Pm4FulPTUe0/gnA==
X-Received: by 2002:a05:6e02:188f:b0:3a7:783d:93d7 with SMTP id e9e14a558f8ab-3afee9a6acfmr49550445ab.4.1734135552054;
        Fri, 13 Dec 2024 16:19:12 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e0f391d8sm119722173.73.2024.12.13.16.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 16:19:11 -0800 (PST)
Message-ID: <db61571717f7cc654ace0425c888194f61d92a2b.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] Collection of tests for canonical
 checks on LA57 enabled CPUs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Fri, 13 Dec 2024 19:19:10 -0500
In-Reply-To: <c506e88992b394433cd9e8ec92932bbe59f5b621.camel@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
	 <f13e0e2b7cb68637ceb788f5ca51516231838579.camel@redhat.com>
	 <c506e88992b394433cd9e8ec92932bbe59f5b621.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-11-21 at 20:31 -0500, Maxim Levitsky wrote:
> On Sun, 2024-11-03 at 16:08 -0500, Maxim Levitsky wrote:
> > On Fri, 2024-09-06 at 20:54 -0400, Maxim Levitsky wrote:
> > > This is a set of tests that checks KVM and CPU behaviour in regard to
> > > canonical checks of various msrs, segment bases, instructions that
> > > were found to ignore CR4.LA57 on CPUs that support 5 level paging.
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> > > Maxim Levitsky (5):
> > >   x86: add _safe and _fep_safe variants to segment base load
> > >     instructions
> > >   x86: add a few functions for gdt manipulation
> > >   x86: move struct invpcid_desc descriptor to processor.h
> > >   Add a test for writing canonical values to various msrs and fields
> > >   nVMX: add a test for canonical checks of various host state vmcs12
> > >     fields.
> > > 
> > >  lib/x86/desc.c      |  39 ++++-
> > >  lib/x86/desc.h      |   9 +-
> > >  lib/x86/msr.h       |  42 ++++++
> > >  lib/x86/processor.h |  58 +++++++-
> > >  x86/Makefile.x86_64 |   1 +
> > >  x86/canonical_57.c  | 346 ++++++++++++++++++++++++++++++++++++++++++++
> > >  x86/pcid.c          |   6 -
> > >  x86/vmx_tests.c     | 183 +++++++++++++++++++++++
> > >  8 files changed, 667 insertions(+), 17 deletions(-)
> > >  create mode 100644 x86/canonical_57.c
> > > 
> > > -- 
> > > 2.26.3
> > > 
> > > 
> > 
> > Hi,
> > A very kind ping on this patch series.
> > 
> > Best regards,
> >      Maxim Levitsky
> > 
> 
> Another very kind ping on this patch series.


Any update?



> 
> Best regards,
> 	Maxim Levitsky
> 



