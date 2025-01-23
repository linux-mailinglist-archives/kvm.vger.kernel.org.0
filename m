Return-Path: <kvm+bounces-36418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7A0A1A956
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 19:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9B89166D00
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4797B166F32;
	Thu, 23 Jan 2025 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TlVtv5GR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23964149C57
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737655460; cv=none; b=YG8MW2FgTCC7T3D7vFtmvwToqzdYYckAhbPtTGQjpvmurSnFoWPgu0Jz1L0apdDstDuNUWvel40Ccx8jgoxVf6v5m7uH//2miSZ4d954LlROKFklB4gQ4atndTpJ0IlN07/y6hCMux4Ce2+HI7BSYUyKenQeJn9gNgZbMgwNMeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737655460; c=relaxed/simple;
	bh=LaIdiU3wIlShds8L8dQirHTgd7Yvpqy/oIJaqsUyfBo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WHbsp+5Rd1zm+7O9EOaGGdBseA9CEVug3xzKbs4NVRmoYCFHeJ6ahWTO33TYvYTFHKJbK3YM0VcV5M2uUrU7mgGooNZnJTL/Jw416rjSuaiw+NZllvFdLjFe59k8QnZxf2G8TLGHY7pagSVZ9SzcqUjKzo2+KsEa62krYNqlJ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TlVtv5GR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21661949f23so33050775ad.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 10:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737655458; x=1738260258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H+Z//fBwRDx4rVm3tnuemgU4fMlJMf6YcUH3qksZwgg=;
        b=TlVtv5GRWmwDRXiXdogauWRnk1oJRRYx6odpszyRijetgJ09j5gSE7bzjrwMVr51cU
         McU1W+10KoRXA61BLGyVJTr6A2PdfBxP8S9QLcGisv81SYaCRMH4OKhXWskeNgYSDbuk
         wZc3H7BfA19Ed82luoe5Ay/Z8Mpgvs0nt8glYOpiYqENHMVAIr2frlAk0hQfWckVps87
         KtHGNDBDiLgvzqLuUCLmAocblUSawrqZd88U7qKximoZvJ7mC2/AMnr3+TzwEsAhq/5p
         XrAVCDg9pQZmB1U1KSj/Ommu58DsKe3uexL5Yd78QZWmqZ4419jcoDfzhqHUbuKFkHhT
         c08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737655458; x=1738260258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+Z//fBwRDx4rVm3tnuemgU4fMlJMf6YcUH3qksZwgg=;
        b=mZWz3wTpEqNa4N+k0zNc3GuvOjIJw3CytRbq0PwCyfKbWAAF4ZOQN95J5XuA2kC7ii
         Q1e2oAsVeKbfXFPEAnyDHeoghswUgHfGXsdyaftnZJg0i7listWGb1rFPpz6ImK2nwqI
         M6weTu7U/AdRKEEFgwxrmdBvgMxsARnCYIu0KpyB2/NDLHu9eK0iAZ6QqgN0qMt2bO6/
         2Dmbz11S3EkSseLEt2k9ugjkNrSOcCk74OvAt2ZxR5CrKqmnKSG3J5iswq8cbUme9MH3
         ZpMCmuAAkSaU3bG3uZi/bNlA8FPNBnUfvEjOXfnRiwUvMWqS1Ocom/jwn0HoOTczX7q7
         3iug==
X-Forwarded-Encrypted: i=1; AJvYcCXc5K3ABu7LXJgN3j3CL7JQYpLx6j6Db7pyRJb4OKyRUAmld8TgEqWi0DA1caLaWIxUgcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyphKNXD76R7uPz8bN1sIl5NaFzXJgU4u8C6DFasEOX7/MkKAag
	E6pl3CGC5thPkFaqcu5gPmohq0gWAuYYqyb6Mz/XdEpr2afYcgiqyUym4POQidDpx1SmgSogFTn
	gqw==
X-Google-Smtp-Source: AGHT+IE2BtjrRyWcUvEgn5Rme4E3P47LTw3/2EjuqiNRl3vCY2QN2VxqcMhYy9SIEZlRz2jsk9oCj6xNEpo=
X-Received: from pfbeb22.prod.google.com ([2002:a05:6a00:4c96:b0:727:3935:dc63])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:999e:b0:1db:e0d7:675c
 with SMTP id adf61e73a8af0-1eb2148cc78mr44030142637.13.1737655458384; Thu, 23
 Jan 2025 10:04:18 -0800 (PST)
Date: Thu, 23 Jan 2025 10:04:17 -0800
In-Reply-To: <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com> <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com> <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local> <Z4qnzwNYGubresFS@google.com>
 <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local> <Z5JtbZ-UIBJy2aYE@google.com>
 <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
Message-ID: <Z5KEoepANyswViO_@google.com>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 23, 2025, Borislav Petkov wrote:
> On Thu, Jan 23, 2025 at 08:25:17AM -0800, Sean Christopherson wrote:
> > But if we wanted to catch all paths, wrap the guts and clear the feature in the
> > outer layer?
> 
> Yap, all valid points, thanks for catching those.
> 
> > +static void __init srso_select_mitigation(void)
> > +{
> > +       __srso_select_mitigation();
> >  
> >         if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
> >                 setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
> > -
> > -       pr_info("%s\n", srso_strings[srso_mitigation]);
> >  }
> 
> What I'd like, though, here is to not dance around this srso_mitigation
> variable setting in __srso_select_mitigation() and then know that the __
> function did modify it and now we can eval it.
> 
> I'd like for the __ function to return it like __ssb_select_mitigation() does.
> 
> But then if we do that, we'll have to do the same changes and turn the returns
> to "goto out" where all the paths converge. And I'd prefer if those paths
> converged anyway and not have some "early escapes" like those returns which
> I completely overlooked. :-\
> 
> And that code is going to change soon anyway after David's attack vectors
> series.
> 
> So, long story short, I guess the simplest thing to do would be to simply do
> the below.

I almost proposed that as well, the only reason I didn't is because I wasn't sure
what to do with the pr_info() at the end.

