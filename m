Return-Path: <kvm+bounces-24785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 912F495A288
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 18:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E2B02878A0
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F97314E2C5;
	Wed, 21 Aug 2024 16:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sD+1tpzS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44B514D428
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724256744; cv=none; b=FxBPE+rfyJeEQChsKZa669BPoZSCdG1C4PfiL9BuKlrdGOWK9ejhdjRDUd0BwChDjFUc4alywRhSD7/QWBOV0T/z0mdjWMdzin/gCLbqdOKJ77MkBxk8zo/Db1nluVWDtmoDP4iUS+BYFSgy3T7O4VxbEGvAiJTdN98FCW0zLjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724256744; c=relaxed/simple;
	bh=NydtPMyTP5+oAo+84KseJU7J5BC9FkzuQeOItN+gaK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bjtytmC3fn299PEHMQi52406x3+3aQhiEf9pKy2SvVYS2JPQI4P9niaGuk5sX70K5GsTs5msIwBMMbRTAVfNDphbFIh7WCVkIhQKRtpsJ3GjROTRIytmBDmRqPg0tMDKtLehhQFkjgT6h/CeWi8CVDOWKMMQDYpjnrN9ftRKaew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sD+1tpzS; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e163641feb9so1869624276.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 09:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724256742; x=1724861542; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zDsQ2kAgROFjamftWGoiLYwkBjJi+WkA8cxHYZSjmNk=;
        b=sD+1tpzSWxyKMj9Fmn/XSOY+ZsmE5z89omTlkUS2AgaNyyEgR9l8TxytNAczFm1+CI
         uzyxs5Y79xCc668frnHciN3vI3YpqGueGi2u28KR2Vnwzi1OVppJGXb+b6yCKILJxtyD
         nSbZ9doI9NQ3LnOWU0SrmmWeK+nY8d8+2emldyovkjmiv8oKY+Mqr0dVoJpx4uxF+sC0
         EDXDferh9bcQFuD+oyKOkRmB6RiAZYjt8M2rZOscUdeknq0hDhFa5b6R0bBNwFbvcqzO
         oMG9pgNB7D/iYuEp3h/7cAUyqMgfn0ph28PhCppPVvjOEOEa+5YxztQlVGLlgYlOrbkM
         UDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724256742; x=1724861542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zDsQ2kAgROFjamftWGoiLYwkBjJi+WkA8cxHYZSjmNk=;
        b=QfI5hIkRKCCoDVlzI9CkGjvBpy3sJjEyMj61PFNn0QuM7X6KiT8LQ2eNl8l0V98g15
         HrbONuzq12IHaqlEbsHjqmY+fvmubPonG9Y4T6nQfqVS2vlC8gfTEYuSeCx3T/i36PML
         9UfMf8IaZ5+o0K+zxiwHpxyEWoZ2qePdLH0Apkox8cdz9vHoEebWVpjrGJf0NJdvhDQK
         gEnOtm+vTV7pupXPe16IK2jxNyxrMzPIymPdsIx3tEewbmjB2vlFxy5egHOjfAp5ZNRf
         K+ktmG6z3RwCXJ49L0wYcN7LdSvrn+NDjtL9sERCLhDAgLDoKMlYLxg3Nq39cZRuje/y
         O6Qw==
X-Gm-Message-State: AOJu0YwcjGLB46E78U/xwAKavKfzr1GwtttFozNzz2u4FW4zcZuvOJVZ
	fjp7+6uc3hVv/aZnQVsxftgGtxAud13bNl1ezYXL3EOd/YJrfklWXCNp7Ma3+K0Ldbz23q5dNCZ
	n4w==
X-Google-Smtp-Source: AGHT+IEqaDc2zc65jiKfBpI0W8MFg/Dr0sR6Qz6OgjwvTNDFWffOPUsnk4h73GdyvQpXdzjm+oi5UqjhEjE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:b08:0:b0:e11:757f:30af with SMTP id
 3f1490d57ef6-e177652becbmr228276.3.1724256741606; Wed, 21 Aug 2024 09:12:21
 -0700 (PDT)
Date: Wed, 21 Aug 2024 09:12:20 -0700
In-Reply-To: <20240820230431.3850991-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820230431.3850991-1-kbusch@meta.com>
Message-ID: <ZsYR5BdX0y4gntKx@google.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, Keith Busch <kbusch@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xu Liu <liuxu@meta.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Because people would like to use this (see "Link"), interpret the VEX

Please explicitly call define the use case in the changelog.  Yeah, I can follow
the link, but I shouldn't have to just to understand that this is the compiler
generating vmovdqu for its built-in memcpy().

> prefix and emulate mov instrutions accordingly. The only avx
> instructions emulated here are the aligned and unaligned mov.
> Everything else will fail as before.
> 
> This is new territory for me, so any feedback is appreciated.

Heh, this is probably new territory for everyone except possibly Paolo.  I don't
recall the last time KVM was effectively forced to add emulation for something
this gnarly.

