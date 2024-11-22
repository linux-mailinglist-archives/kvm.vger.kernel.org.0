Return-Path: <kvm+bounces-32330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5889D56F5
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 02:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FE9DB220BD
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 01:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC35FC147;
	Fri, 22 Nov 2024 01:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxrBZfB0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6066D5CB8
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 01:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732237459; cv=none; b=NvpkYc4Y9eM4NOh4u2OZKxzq8AMv7EdzjCcKnekm9MRXf7goN71b6R+EDyEynJ75wUmMHwGciGyXku1oPf5kXol1/qUwv0hz4rVaW6Y+QYKrRjhjuBi5tTqYUq78Lktst/eLts6DWiPY/o57XndjBhU566ai5IAbkFGhgyeeNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732237459; c=relaxed/simple;
	bh=w9bPiPzeaX1ctUb+PJzQ8yuATzJlSGzZOfzvZwr5lF4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P0iRvgq9DJlzfrRiooRaWkcvmf0Dy1zvTOtBEUyXdDJ0ZXFEA1k/Qt27WOPYnSdPVFBJJbeG451xIWCL9PsixjJrhgLkJPkawFn6uHxdXKCdxLw81ztC14uK5TaUKPpPoPzJvmKjxxjjIj3pRLqq1WlDZCi/MphzS4h0rWkrUAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxrBZfB0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732237456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1yYlsdUE8xMG7/GD4z42ixP0BqO1UCILEBK6vX1sFg=;
	b=fxrBZfB0WvBuLZT+fIm1+FpR3L/GUkHBPl1LsY0Dw1G3xx0082KsWOwTrx4Dr7Q1h6Sdqj
	wfJ2h35e+BgXqlEtmQ6kFSvwWETmD4ENLqx9/XM80u3j4poQ7dmELBttClrvPThtrBtb/E
	RwrXF8pXvmWMslfgTzEH3/eGszZeDow=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-J3ox2a0aNPCmIt1-fIS2Pg-1; Thu, 21 Nov 2024 20:04:14 -0500
X-MC-Unique: J3ox2a0aNPCmIt1-fIS2Pg-1
X-Mimecast-MFC-AGG-ID: J3ox2a0aNPCmIt1-fIS2Pg
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b15c3ad7ceso157710885a.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 17:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732237453; x=1732842253;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b1yYlsdUE8xMG7/GD4z42ixP0BqO1UCILEBK6vX1sFg=;
        b=j/U8P9dGuxSrDpqZ3PkbdX/Z70P0XhKfSp085TM4CIFLWbkvN1rq4U3K4bXutgj8Kp
         ZsgkVIKD1+vKPdO684Q7jdII95sx3aQxbPNnv2Vxl/2tGgYsszbhFJtNHAKOlwd05798
         yrII+PjYdQMfLnUSL8JpZweYwUZCh/8x/5ka51XtboQIwlFpbi7bOhxPlvLOL2sfVrtZ
         SnlBOgs9T+h2ODIkPAc9pL9vmAaiEbAOIxGiG26Kbf6FT4HgS4/a1d01brtUpwxL302w
         1lmGkAqCMINr16cx7kHlIuR6SErtxLFvsK4wl3nIlXEsSk+vLOtBdLg3yNf74pzp8ldz
         AZHw==
X-Gm-Message-State: AOJu0YzAwaeE4/AcIvD+SD6kuqgsIjdrwPuOTN2RPwB179ApciV+gBxd
	MmcUjoM7j2zeSi1PBx448bf2xGB+1WLUyW11zumdaV7VK3Rx+GDEjoVNI26W4mNOqr7MsMgflqb
	WIUNKd7cqCO0Vjl4xJfLTp7wTiJ8dRA6iOt2SYNdyUwbGB/HoZQvPX5PgC+PCtPA5RUEjyuDTgb
	d8+hlRXkqK+FAbPJhN5OGFMfrpBeo4z3B4UqLL
X-Gm-Gg: ASbGncuFw9fhPNF7Boi6EKj128MhQrwGxt1vBwWBFMtGhYR5YwoKFzKELENe4UiGB0O
	051ZpujwGKDQeqykyujtTyZwH46kS00FT+YFrd4O2N/74OFHR3KeNMWM/BrVHv3azooaPXQCoCV
	glnMIdNsG46k/S0nu1HSUTLnMi2kt95srPKK7XfvOsXaylmb0CZH0r5AIUQjxfmbyOhkjMoWNci
	DvSKCy6p3Elu32O4xReCAuuvOyYvYujSIw34pWNX6wrzYOAdA==
X-Received: by 2002:a05:620a:2a03:b0:7a1:c40d:7573 with SMTP id af79cd13be357-7b5145a6ae3mr127754185a.49.1732237453325;
        Thu, 21 Nov 2024 17:04:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMi9WAXqyjGBhUJc1OOj8HBASbYMPtLh8JD1G2rZsijJCmjLbdQRxzDYkVLF6q9uwODhBebg==
X-Received: by 2002:a05:620a:2a03:b0:7a1:c40d:7573 with SMTP id af79cd13be357-7b5145a6ae3mr127751485a.49.1732237453004;
        Thu, 21 Nov 2024 17:04:13 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b513f91e14sm36850585a.22.2024.11.21.17.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 17:04:12 -0800 (PST)
Message-ID: <ef5ad5116b1b39b94a3ba49e9c78edb3a5ebc91a.camel@redhat.com>
Subject: Re: [PATCH v5 0/3] KVM: x86: tracepoint updates
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Paolo
 Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Sean
 Christopherson <seanjc@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
 linux-kernel@vger.kernel.org
Date: Thu, 21 Nov 2024 20:04:11 -0500
In-Reply-To: <d59b923ebd369415056c80b99ca4e0f75d60fa84.camel@redhat.com>
References: <20240910200350.264245-1-mlevitsk@redhat.com>
	 <d59b923ebd369415056c80b99ca4e0f75d60fa84.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-10-30 at 17:21 -0400, Maxim Levitsky wrote:
> On Tue, 2024-09-10 at 16:03 -0400, Maxim Levitsky wrote:
> > This patch series is intended to add some selected information
> > to the kvm tracepoints to make it easier to gather insights about
> > running nested guests.
> > 
> > This patch series was developed together with a new x86 performance analysis tool
> > that I developed recently (https://gitlab.com/maximlevitsky/kvmon)
> > which aims to be a better kvm_stat, and allows you at glance
> > to see what is happening in a VM, including nesting.
> > 
> > V5: rebased on top of recent changes
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > Maxim Levitsky (3):
> >   KVM: x86: add more information to the kvm_entry tracepoint
> >   KVM: x86: add information about pending requests to kvm_exit
> >     tracepoint
> >   KVM: x86: add new nested vmexit tracepoints
> > 
> >  arch/x86/include/asm/kvm-x86-ops.h |   1 +
> >  arch/x86/include/asm/kvm_host.h    |   5 +-
> >  arch/x86/kvm/svm/nested.c          |  22 ++++++
> >  arch/x86/kvm/svm/svm.c             |  17 +++++
> >  arch/x86/kvm/trace.h               | 107 ++++++++++++++++++++++++++---
> >  arch/x86/kvm/vmx/main.c            |   1 +
> >  arch/x86/kvm/vmx/nested.c          |  27 ++++++++
> >  arch/x86/kvm/vmx/vmx.c             |  11 +++
> >  arch/x86/kvm/vmx/x86_ops.h         |   4 ++
> >  arch/x86/kvm/x86.c                 |   3 +
> >  10 files changed, 189 insertions(+), 9 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 
> > 
> 
> Hi,
> A very gentle ping on this patch series.
> 
> Best regards,
> 	Maxim Levitsky
> 
Another kind ping on this patch series.

Best regards,
	Maxim Levitsky


