Return-Path: <kvm+bounces-13999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D109389DEE8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BDB6299A7D
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 15:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EEF1327F3;
	Tue,  9 Apr 2024 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKAyaOES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34BA4AED6
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676235; cv=none; b=bdxbiQ+0z7O2rynKCBmtQXANlF9us3mr3hJ8o6DZODmCp/2vzfHPo2YaTypbUwJaYw6GRS6fowIjTHUb10bX8h44CxZbpVQcpOSCGok/ljNMZ6LNnL9+IuTKFCkkDend4dhwJOmfGCQ8ExQhO+o4gVB/MAJRQ0fPO3xZjiadZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676235; c=relaxed/simple;
	bh=0QtK/XU5wRxTAWSKfFGQfHhRtI4Bz1uaKMs2LclDKxY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a5kvvZibULhsNdSS4rHhb0gz3drl7rOLdZt5ZQgNic04GL7z+u6MWnfAFs8M0Pcm8DPzCNJLjDm1EbamWUyYl3D3FdwsjdCgzCLxBpGyf2Osx0/JzOO3lUxTUQU6MSweKj3L54Jhu9Lwbegk+8TQHOq4YsR/5kGO4GXpPEbM1hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RKAyaOES; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed4298be66so1300233b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 08:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712676233; x=1713281033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zTw5tUDYTR1sSRFGOVa8mOeRWBv7Dty/0b6Yi3dyJjk=;
        b=RKAyaOESrJzoXbn2xNVQAE5rWO5NHHyfV2xyeU3YgXy9Eoh77R5kYmLD+u8t8zVMnO
         E68sND4GJlZtKSHxRXnqmzSLwHx4T24Q4ab6vrvPINIOede2Ik6aKyfoukvwdHIo/ZuL
         9dAf0KSJnO6hvtUrtMGbSR7KF55gmaSuDFpOp8GzfCyFVOTnjrLxJo8pj7XUEzGI6T40
         mi3HqvaAxouq5HuhmDvriHzWOwo9k2eub0DNzJU9TGfm2JzKZlaUQ1Ix1p4EkKeKq3pX
         1fWjs7D/s93ju7pHPQVpIKKBWg+O8BFoCR3cEYywzAUDyPpbylQXzknZDhHlwlfm2BBE
         59UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712676233; x=1713281033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zTw5tUDYTR1sSRFGOVa8mOeRWBv7Dty/0b6Yi3dyJjk=;
        b=dIBU3a5BcjeqN1V2MALIa1KX5kiOKZdtLQoZKusKBVYS4mI9AM0nnLXSypMJv2ZoQx
         M+6ZJpjVKFPWKY8hCd0kJmyF1LOKQ3HOlDUlbaNyTLgaZf9MZ38bn6+LfsO656SGI2rU
         WWh23KvEsxKYJY6cPMuDF2uNSIH0t1S9CFOS8Z9ubVSmJxrsztHrwrgXz9Vcx6mey6Wf
         D93VOmrFzNOTEPHVaCJBY9zaIqf4GgLZoNE76kEkiw8GrY82BdTIwXEUZBi9oFeiRbUT
         fwW36eUmcKYd1R2KaY7T8oh8kQ0tltH9C6OmTgjNRxVfqIEdebP8WRDUsYHvKnlRZ+K1
         +oWg==
X-Forwarded-Encrypted: i=1; AJvYcCW/2/s94G+PGl8t7Pe688ud0A7x2raJJZPj+U4/1bnBS0pDIfU9IBE/hfjr4RKoHALlzPlEeCn6n5N0Xc14zhXOd7KQ
X-Gm-Message-State: AOJu0YxbpQ92snsgglSMCKFz2sldPgliisWI7Z7mXJwE+jkNfV7LHiDz
	K6LyOticHZOrPl9+nNJhyWmdUrgX1tUe6e54mMuvStuIPLRZ25hHM3e0Ejexpe6EMQQSZQx6CF4
	BwQ==
X-Google-Smtp-Source: AGHT+IFlez/00MQ3CRbxBIC87XHuEB5bKTIC4+lU/m/V0i9jMVwrtOp4z85vX96ntN0qsjtgHbGBJNuuq6w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:180f:b0:6ec:f407:ec0c with SMTP id
 y15-20020a056a00180f00b006ecf407ec0cmr679559pfa.2.1712676233205; Tue, 09 Apr
 2024 08:23:53 -0700 (PDT)
Date: Tue, 9 Apr 2024 08:23:51 -0700
In-Reply-To: <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405165844.1018872-1-seanjc@google.com> <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com> <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com> <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
 <ZhRxWxRLbnrqwQYw@google.com> <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com> <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
Message-ID: <ZhVdh4afvTPq5ssx@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"srutherford@google.com" <srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 09, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-04-08 at 18:37 -0700, Sean Christopherson wrote:
> > As I said in PUCK (and recorded in the notes), the fixed values should be
> > provided in a data format that is easily consumed by C code, so that KVM
> > can report that to userspace with
> 
> Right, I thought I heard this on the call, and to use the upper bits of that
> leaf for GPAW. What has changed since then is a little more learning on the TDX
> module behavior around CPUID bits.
> 
> The runtime API doesn't provide what the fixed values actually are, but per the
> TDX module folks, which bits are fixed and what the values are could change
> without an opt-in.

Change when?  While the module is running?  Between modules?

> This begged the questions for me of what exactly KVM should expect of TDX
> module backwards compatibility and what SW is expected to actually do with
> that JSON file. I'm still trying to track that down.

There is nothing to track down, we damn well state what KVM's requirements are,
and the TDX folks make it so.

I don't want JSON.  I want a data payload that is easily consumable in C code,
which contains (a) the bits that are fixed and (b) their values.  If a value can
change at runtime, it's not fixed.

The only question is, how do we document/define/structure KVM's uAPI so that _if_
the TDX module breaks backwards compatibility by mucking with fixed bits, then
it's Intel's problem, not KVM's problem.

