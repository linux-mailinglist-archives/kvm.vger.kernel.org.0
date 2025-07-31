Return-Path: <kvm+bounces-53785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E9DB16E05
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 108F47A47FD
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953DA293C4E;
	Thu, 31 Jul 2025 08:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQqXkfNb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1EB28FFF6
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753952345; cv=none; b=pX0ZcwAY/tAijuYs7sz0f+xBIqi6YcB7cSKNc2cF5rxQY/MYnnAQ+y3Mk5yZAmQEjAM6PygPSwYfbw1QhuCupomuuNykqNVOGWytoe8rwn5/jZbNQ0qiNfvLv7CKCAsq8BRGZmsVZjs3S/NSuNqA+P6dHB3TuTAVtqJ9zsY/1Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753952345; c=relaxed/simple;
	bh=2d1YMb0J1eSQ53PQabe7ZeM9hYCLsvXXfFGuiA5EUhk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kU/IBkwM9y8crEoti3Z3xKz5ZdjNP1FpfyJoTcuMQQqkGRSXMrO+XyfTwKKlTJYS/4V91u3hlSDwhBICPRwZxhSoLTVjrJY81wlOPfeZTyTS9Mhkxn+JuIjNVPc4zbXAOAAL/ntTwaUuZBXa8slgtYJWnLmEN6+ed11SjcJuhjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQqXkfNb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753952343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQg42DZTW6WZPAwrJ2jBsBoi3NebuZnOy331nH63Y68=;
	b=WQqXkfNb68WTjA085/UQ2afvszBYoumXDPwlrwtacfSqL1ZblthMH9Cs+uGmuKiEElCKS2
	Fkbg7wXal6hkQR/Iy67Ke9MTyV4t/g62VII32STRla2FeqynftimzLBYPSEnQq8cOJDnsi
	kPtjg6xnwCssB0Vuoj7zn4D0rkxmgtI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-0vj6v_ZIN5CT93mpzvtECw-1; Thu, 31 Jul 2025 04:59:00 -0400
X-MC-Unique: 0vj6v_ZIN5CT93mpzvtECw-1
X-Mimecast-MFC-AGG-ID: 0vj6v_ZIN5CT93mpzvtECw_1753952340
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d30992bcso4358795e9.2
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:59:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753952340; x=1754557140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQg42DZTW6WZPAwrJ2jBsBoi3NebuZnOy331nH63Y68=;
        b=sc+CrbWyPyoi3L2xjzNVhdxBmWW+1D7B/otu3mAov7HCL/xO1eX819gNjOkz6N+uuk
         FB0ykGc4fuGsAFac2d8yiD0ipwYLw+fBxGLT+pAV+rA79vPUQnTFbVvf2Z9fRX80oW+3
         caNzIlS9IXWcrDyP6PU2upW5NaqvWR3SLm3085JzbVKVNkO4iCfa5hJhBLYBhkE+69pb
         B0qHmH/tgvnjj9jt63T7mADUUMAFwHcCZjuwpwHpHEUMxw4Pg7SWscYk98SW9rd6mG1n
         hEFyzIoFd9RBq4iskjY2wEeSstMW36rGwzQ6wQu8XhojNiGEUjtwLEC0KFyRzN6XzSXO
         dM3w==
X-Gm-Message-State: AOJu0YwfWJ+JvT4bYWKRIWSnb2zgJy/Jt4bNpn/G003L/1qfykSccPFQ
	i/4VWEMpuoX9tugumy3jc+xdPAS+4GhyNn351N3TJwRog9o+EthQO69/3HnphkfDIYQszmieyHl
	P12rS0Aqo4RK33AhR+XGpsR3bHS3hUQXvTFJlXEuG0BBTZmP4LtaT5w==
X-Gm-Gg: ASbGnctMXedMw6hzB1YsVJf7wVtFUb/B3Bj1gTJuqECf4baM+eiYbhQmsch4m9SjcaM
	FEhZ7spblzG11EJ6tMUgEjRmQezp3avCoF+m+qvVOp5VosTVUqEGk9eNyZQ2z+Aqbp8mRbVQZH8
	Wq2YBAPwaLrFbzqWVSqF1FNiaHinPxAR70BO8E7vHPLbR7bJe3/TnHfgqHPjUuQ7ApdDGTDg/7H
	gRXE7QmIRLl4YRE/BymUnfyib9AIcvwqT/jKvWKdXhZgKc3KkpCCMHAU4J4BkyvnsY00X9B39VJ
	XK3oauh7K7F800woltdbo+ldyKzJ7A==
X-Received: by 2002:a05:6000:2c01:b0:3b7:8abc:eba2 with SMTP id ffacd0b85a97d-3b794fd72femr5034226f8f.20.1753952339637;
        Thu, 31 Jul 2025 01:58:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjoAOuLOJVy8jkDqKUmFu6cwUQ0YOE9iW/44ZMTnOxVyIl67Q8Ee1VR1UyOVRtHgCRbg3urw==
X-Received: by 2002:a05:6000:2c01:b0:3b7:8abc:eba2 with SMTP id ffacd0b85a97d-3b794fd72femr5034199f8f.20.1753952339198;
        Thu, 31 Jul 2025 01:58:59 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533e6sm1714850f8f.35.2025.07.31.01.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 01:58:58 -0700 (PDT)
Date: Thu, 31 Jul 2025 10:58:57 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 3/5] x86: move USERBASE to 32Mb in
 smap/pku/pks tests
Message-ID: <20250731105857.2cdb5c22@fedora>
In-Reply-To: <aIqG8nAB2kaH3Mjg@x1.local>
References: <20250725095429.1691734-1-imammedo@redhat.com>
	<20250725095429.1691734-4-imammedo@redhat.com>
	<aIqG8nAB2kaH3Mjg@x1.local>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Jul 2025 16:56:18 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Fri, Jul 25, 2025 at 11:54:27AM +0200, Igor Mammedov wrote:
> > If number of CPUs is increased up to 2048, it will push
> > available pages above 16Mb range and make smap/pku/pks
> > tests fail with 'Could not reserve memory' error.
> > 
> > Move pages used by tests to 32Mb to fix it.
> > 
> > Signed-off-by: Igor Mammedov <imammedo@redhat.com>  
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> > ---
> >  x86/pks.c  | 2 +-
> >  x86/pku.c  | 2 +-
> >  x86/smap.c | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/x86/pks.c b/x86/pks.c
> > index f4d6ac83..9b9519ba 100644
> > --- a/x86/pks.c
> > +++ b/x86/pks.c
> > @@ -6,7 +6,7 @@
> >  #include "x86/msr.h"
> >  
> >  #define PTE_PKEY_BIT     59
> > -#define SUPER_BASE        (1 << 23)
> > +#define SUPER_BASE        (2 << 24)  
> 
> Nitpick: maybe 1<<25 would be easier to read.

I can try with, if I have to respin.

 
> Below are some random thoughts when reading these tests..
> 
> I'm not sure whether I understand them correctly here: all of them so far
> depend on the "test" var present in the .bss section, and they all assumed
> that the var's physical address (likely together with the whole .bss) will
> be under SUPER_BASE after loaded in the VM.
> 
> Based on that, there's yet another restriction versus the need to reserve
> (SUPER_BASE, SUPER_BASE*2), because the tests want to map the same (0,
> SUPER_BASE) memory twice in that virtual address range, so here the tests
> do not really need the phys pages in the back but kind of a way to reserve
> virtual addresses..
> 
> Instead of these tricks, I wonder whether we can do alloc_page() once, then
> put the test var on the page allocated.  Then we can build the required
> PKU/PKS/SMAP special pgtables on top, mapping to the page allocated.  It
> should make sure system changes (like growing num_cpus) never affect it
> anymore.
> 
> That (even if feasible.. or maybe I missed something) can definitely
> involve more changes, so not something to ask for on adding the hpet test /
> x2apic support.  Just some pure thoughts when reading it..

I had the same thoughts but I'm not confident enough to rewrite
those tests. Hence a knee-jerk reaction of just fixing up base
to unbreak affected test.

> 
> Thanks,
> 


