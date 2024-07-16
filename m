Return-Path: <kvm+bounces-21684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C57B931EC7
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 04:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB2A9B21AFC
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9E7DF6C;
	Tue, 16 Jul 2024 02:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9VAnvQ9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEBCAD32
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 02:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721096500; cv=none; b=mhwiLveniURb1jG1GdDtR97Pu7e/zqWyZJvm20H3zydPNXKtrtDJ3XpcvQEE3GvPwhFpH+PwE6UIgRi4prHhAkvpscgn0Ffkzibhi7RAaU5J78uOcf5Yt9v1AhkqR+GibDlfmqTTeZ1f/XPOAW0VA4xjsuY3idJyKvvxv//ddBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721096500; c=relaxed/simple;
	bh=gsZ4F80xkqDr34TVXrZpadh2OiEZwsAOu0bsXIODOsg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rIoirEKMlit9r+O0AACR2ytUo6TNqOy0u59yIRIF+jL3g08MABV9idpDjfSybjVhBQNgGAB1m7U3fOApRcfTCfy3ZkdsFNquJQeFI56Q9OpRm298q26vPgzHzpV+1RUgutWxGA9AoUcKpNZQPKXaD4X81GUwAyY9R01eizBiFBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9VAnvQ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721096497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V7WJQjgXG247dHuENykY6akcz79v6gaC87rfGOvpt/8=;
	b=W9VAnvQ9mFdPV3aV7pFw9ve0aikjLBFbdJ3ORuoYF2NjTLYKztG9wFBGcqe5VqkEQxFtNE
	vucWaVIHzBzqjCV1lEXemdGIx+Pj5BSSO1rWT099NkubeT4uy1k1F+Tp1zl2wM2N23yv+Y
	u6BbA+qmzwCMRZQ1QLix5TMZHx51loc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-ooCXxSrLOm2KWfdsq4Bl0g-1; Mon, 15 Jul 2024 22:21:32 -0400
X-MC-Unique: ooCXxSrLOm2KWfdsq4Bl0g-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b5dfeae8caso72532866d6.2
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 19:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721096492; x=1721701292;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V7WJQjgXG247dHuENykY6akcz79v6gaC87rfGOvpt/8=;
        b=j3CxexSSVW949pHp4qnJFw1Kfmn1htgnwkca0IC6sIUmJdbazasntK4gUE7zz5z3BX
         1iZpKgMAqcpyr70S72RvqOfnI4LC6iefOUrlPaZPzfbFVe5ajvTMFrY2QBcM7f9WbBAr
         hS9LObD0gxG9zavnRz6OJOkpD1QV6aKFaLLdsM8qIuulONoz0U/lZETi+YsFrQnRHvbw
         VSE750nFQLSJyW4P3O3pz4iccrHP6qVZWBbVz9Maw7+3yMDz8ICsb90JNWLX42W0hw2f
         k8qrnPtpwWD+2dwaBdHxnpGkTqpxWwRKeFi912UUsItyhFXJhaPiQ9l7I5vdWFbHBmN0
         z7LQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2IP8GHzvgXdbBo837c59mt+vMKUqDjGhQJ5yF8fs5V11opJZff9HC8wAFxIksvwir8bwm8RcD3oviKnYJuLS2mCUe
X-Gm-Message-State: AOJu0YzKE01gEDjBNsX6XoegCiq68AGgq/OfIXHKaLR04zbziA3u4awW
	KE+SKLqoT+LtVb+ph/9k9PuqnLbYlzMSJMlQdVHboKPFXtQVCFDEOUt6eVOM3PzQCOOsx+ruN3x
	izcBd8f9fZ6JvYNqj37ebu6/NjTDd7S9mN6Gx1B8JeuMg4MNgtQ==
X-Received: by 2002:a05:6214:27e1:b0:6b0:63ab:b7ba with SMTP id 6a1803df08f44-6b77f4df9e5mr11171296d6.15.1721096492005;
        Mon, 15 Jul 2024 19:21:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWEgmVDTEG/7zoYrFa8MTD5wFpyU132+dv2PEWBcRLlCrbgKwAEO07xx+lB9VPrtMKQ/mrsw==
X-Received: by 2002:a05:6214:27e1:b0:6b0:63ab:b7ba with SMTP id 6a1803df08f44-6b77f4df9e5mr11171206d6.15.1721096491736;
        Mon, 15 Jul 2024 19:21:31 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b76197cbbcsm26862686d6.40.2024.07.15.19.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 19:21:31 -0700 (PDT)
Message-ID: <1aafe2de083266a294d98393a6a6692320b7a284.camel@redhat.com>
Subject: Re: [PATCH 0/2] Fix for a very old KVM bug in the segment cache
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
	 <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Ingo
	Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 15 Jul 2024 22:21:30 -0400
In-Reply-To: <35aed712-d435-4660-a40a-ace7858218c4@redhat.com>
References: <20240713013856.1568501-1-mlevitsk@redhat.com>
	 <35aed712-d435-4660-a40a-ace7858218c4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2024-07-13 at 12:22 +0200, Paolo Bonzini wrote:
> On 7/13/24 03:38, Maxim Levitsky wrote:
> > 1. Getting rid of the segment cache. I am not sure how much it helps
> > these days - this code is very old.
> > 
> > 2. Using a read/write lock - IMHO the cleanest solution but might
> > also affect performance.
> 
> A read/write lock would cause a deadlock between the writer and the 
> sched_out callback, since they run on the same CPU.
> 
> I think the root cause of the issue is that clearing the cache should be 
> done _after_ the writes (and should have a barrier() at the beginning, 
> if only for cleanliness).  So your patch 1 should leave the clearing of 
> vmx->segment_cache.bitmask where it was.
> 
> However, that would still leave an assumption: that it's okay that a 
> sched_out during vmx_vcpu_reset() (or other functions that write segment 
> data in the VMCS) accesses stale data, as long as the stale data is not 
> used after vmx_vcpu_reset() returns.  Your patch is a safer approach, 
> but maybe wrap preempt_disable()/preempt_enable() with
> 
> 	vmx_invalidate_segment_cache_start() {
> 		preempt_disable();
> 	}
> 	vmx_invalidate_segment_cache_end() {
> 		vmx->segment_cache.bitmask = 0;
> 		preempt_enable();
> 	}
> 
> Paolo
> 

Hi Paolo!

This looks like a very good idea, I'll do this in v2.

Thanks,
Best regards,
	Maxim Levitsky



