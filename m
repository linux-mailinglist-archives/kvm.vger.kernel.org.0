Return-Path: <kvm+bounces-45480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DBFAAAAA90
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C9699A1808
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 01:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298862E5DC7;
	Mon,  5 May 2025 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XWg8cwav"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E32D998E
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 22:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485842; cv=none; b=ffLDqyVjxLaBaOHIc35xA69gvZz6c/XS2a7HLew/6YQLSYappDXPzSRzPebpbvVJP0D6qm1Ue9R04K24Ea/5EQEgY9p10YnnHP7zaILCnkJEiiE7ek5FusRT+UP0rrg48GsYm1IC3i9lkuWrylTPCfIauh8LJCovZ8TJhIzqXwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485842; c=relaxed/simple;
	bh=qL9kqWpZtyzUbBfVfilzB5IvxTSPW+Sb2IbeCYPr8WU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+Kc2fEDLddUKhvu/zLa5D4Nq5nQ17NWa73gLMixma88Ut5ITIkeLszLdrQdEfkFWBpcia/Ffek5dF/9LiTsBYG3gFOLzTeRSdY+WjPEYY1aY2UHuCgvSa1HSbQAFCNI51IBpCuOkNDyfAAvYM3XIch8hOCumm9sOHw2ZiUztQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XWg8cwav; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a59538b17so2528344a91.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 15:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746485839; x=1747090639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7fTVD9mhjVGVNu76WgrWlRxCFOQNPlvAmlBjEqJWVdA=;
        b=XWg8cwavuslDr6KpUovMnPMOSK8LBXsGxJpoeo/pAiqf/QgJP1sg4j8eTPpE1jDmSE
         NWh0aQ5Hpggt3lZxw5jsZupTJ3ex+5gXX1Jacj74jeDCIiaa3lZg/AwN+jyG9th/btMe
         RW9pSwiuHTXx18t1H0fDU2WoIhtYvsNCicYScaGOSn8Ap1jpK+Ah7nq4jzJkWrC7WtUI
         7zeTibdwN7J4KrOoFpGlntelAIn1GwvOdesR/4i5CJMX1D8b8rV5ZBSo1WAof+ZMkAGn
         isgkxAjDwJg57+AY//8aYUxW0OMGk0I+G79KAF8M1OJGDde8TlVagnpQM4VfoqGiAWI/
         D1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746485839; x=1747090639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fTVD9mhjVGVNu76WgrWlRxCFOQNPlvAmlBjEqJWVdA=;
        b=qfKWsJ1ZQTLQPy55wf0z9uoj8vdcm0PrknKJ5hRAdv8JMsrkxzdFx+6/gfMqEafmKo
         J6p1GWObAn20upY7v6gR0pTAk7FGiNvzJgT7yGMN2f0cAS9gAxnCFDB7WS63IQ1unPXW
         MPdsGUtdDKoyz9kMBagQPJgncxh8fx0pBy4KQvpgZVF5830QWg1Khz6+i9dfNz4DqfGO
         Tk3PPQZ1hEtOaR6kVCbXKkfzXl+UxRRTvR1+TgI6rsmx+VQ+rEwJ7hgBWfendBh0cnBZ
         vDPe0AAlhvpSO9YLcuUC7Lcnh+lxeb1qxQIeDEi31ybpGYOD8o3Wyap9fi9bJ/9FtKx6
         G8Kg==
X-Gm-Message-State: AOJu0YwuudHeN6oaY1kIR+H2Z9hZ+D9jY9nABZTtQTI+LgZCNlSccuwt
	pqWdMSt9ItfFkWBEpvFA/w0BVMBQpa5kCgtH0niL+InpWgBOsItis+SBtOLdqcrHAP1KacXet5i
	3lg==
X-Google-Smtp-Source: AGHT+IG+bLbnRwKacBdwKEqb+ZlVouYwYu6ROj9LxnI6DWLtn5iDtn6cjFYO/W3uF1RtCR2hFz2sG6ty2pQ=
X-Received: from pjbqn16.prod.google.com ([2002:a17:90b:3d50:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4f:b0:2f9:c139:b61f
 with SMTP id 98e67ed59e1d1-30a4e5a608cmr23836495a91.14.1746485839174; Mon, 05
 May 2025 15:57:19 -0700 (PDT)
Date: Mon, 5 May 2025 15:57:17 -0700
In-Reply-To: <20250505190538.GA1168139.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250222005943.3348627-1-vipinsh@google.com> <20250222005943.3348627-2-vipinsh@google.com>
 <aBJXabTuiJyRZb-O@google.com> <20250505190538.GA1168139.vipinsh@google.com>
Message-ID: <aBlCTfAlKOWG5orI@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Add default testfiles for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Vipin Sharma wrote:
> On 2025-04-30 10:01:29, Sean Christopherson wrote:
> > But, I do think we should commit the default.test files to the repository.  If
> > they're ephemeral, then several problems arise:
> > 
> >  1. For out-of-tree builds, the default.test files should arguably be placed in
> >     the OUTPUT directory.  But if/when we add curated testcases/, then we'll either
> >     end up with multiple testcases/ directories (source and output), or we'll have
> >     to copy testcases/ from the source to the output on a normal build, which is
> >     rather gross.  Or we'd need e.g. "make testcases", which is also gross, e.g.
> >     I don't want to have to run yet more commands just to execute tests.
> > 
> >  2. Generating default.test could overwrite a user-defined file.  That's firmly
> >     a user error, but at least if they default.test files are commited, the user
> >     will get a hint or three that they're doing things wrong.
> > 
> >  3. If the files aren't committed, then they probably should removed on "clean",
> >     which isn't the end of the world since they're trivially easy to generate,
> >     but it's kinda funky. 
> > 
> > So, what if we add this to auto-generate the files?  It's obviously wasteful since
> > the files will exist 99.9999999% of the time, but the overhead is completely
> > negligible.  The only concern I have is if this will do the wrong thing for some
> > build environments, i.e. shove the files in the wrong location.
> 
> We can get the current path of the Makefile.kvm by writing this at the top
> of the Makefile.kvm:
> 	MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
> 
> Then MAKEFILE_DIR will have the source directory of Makfile.kvm and
> testcase will be in the same directory.
> 
> With this we can modify the below foreach you wrote by prefixing
> MAKEFILE_DIR to "testcases".
> 
> Does this alleviate concern regaring build environment?

Yeah, I think so.  FWIW, "concern" probably isn't the right word, more like "the
only thing I haven't thought much about".

