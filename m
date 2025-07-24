Return-Path: <kvm+bounces-53378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 827E0B10B71
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D3D7188185B
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B911726059F;
	Thu, 24 Jul 2025 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4sBckWNT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958DC224F6
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 13:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753363910; cv=none; b=m2Nc6jT2gfDSYzt579loXwz6X0xKXEoHeKVb09tmqKvtuBQUujumFLUDs6ZCea+xw8wmWLn9rUErFp4cwF55w86I9LERkTif15kvBltkzqYi0vUAhJNEjFHRbc1Jdjvm1ugN5vl8RI/XrzTN3BFE3NDJvmNIbfcAKJgGqF7OmD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753363910; c=relaxed/simple;
	bh=gJVEnKD+m86/Uy00KKGOC2HsXj1DksP0pHClj72P4RI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ghR3t/hZ4sOv2KSwQ0tvdZPRsAderG0wF3aZyjIGaBajz4JGdChZ1QIE7/KPgwYBM66WsrNM/ZPEQEbGCqEn4rVfE4DKrURRBIMdG9XHy+FLANBiujEGiNxJxo0K9eQpRbxzcezuo1onzMgAvOahIaisJaQkGkGAMLme2GMU/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4sBckWNT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740774348f6so1048910b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 06:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753363909; x=1753968709; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+//CxCRIZc81uvnzJthipR4khrLAZAMHtnmjaKkETc=;
        b=4sBckWNTMET7dm4fucNTlZXCkUi0DMq+yr/O+N0Y3JVgx31NxhQTzktadiEzZV4V1k
         jzAk3zEQsaX+s5P2g0at/p/Ym8d8nY064n9sVmZ5JdXKb521ER7Nqq1/cjQZWwyE+c+T
         oTAEyeJz3oFT/LrxChc6z8hpFvzJ/IK2t6dPnAjtk7P5rvv7e6VAEbgTjtjV159L0DdX
         e7UcKQkcEscPm/G88kkERgIo9sKjP93yaH8e09gZ6EVNuEgV15IJSSzvF4yrzpm1WvYh
         cCvcsmfrXV+JCEb6CJ0Eu7y6sv7988vFS3M6yJ3f7kmAQHhEkdE5qPctz6kmmKVciDDH
         7vWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753363909; x=1753968709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+//CxCRIZc81uvnzJthipR4khrLAZAMHtnmjaKkETc=;
        b=YqDd77lUKHZhQeuvvrQ7CgUprAOeMFKTfkKi+HT2+RXch9+j6fFNUNKg9UlstnaYux
         x4No6tLG8DaXa8kshKjW5rxXHjwjYBo9ZtSmkJ3K/0wfJFuuwtA6o/gozp5WazSv5lUp
         /hapZRUYr/z4WUy+yLm1mJBHTClzqVjpiel/cejL+k33fj0HJkKH+l0WLbgG+FlnkCkf
         zkUpCzFkFeGoR4CdYubtEcnzzgpO/oaneo/Q6yftr0uwRn4ob7eOTM6ESVy3ynNiQ0LW
         nZeu+2fPmOSkRWtzeGDqxRo+9VavgTdA53HIQK7Q3k9qP96dS5bs7ymBgXMUQk/le3Of
         mFzQ==
X-Gm-Message-State: AOJu0Yy9bYmmPjwmgZoOJd5weESfqwatPNfCV2maJQ53JCIAiKl5SC1t
	WmitSSvMh+nEfYWaWveXlpUOG1eAu1E37smrzdWFZ1B2Guklwkf260/Cgw2rHtVuJ8J9/lE8R+Z
	hRVjIsQ==
X-Google-Smtp-Source: AGHT+IHhPfyTLkgtMrtOM72kSjVGgRr+PyxLdwXo7qRQAzq2mFsE6l1xZorbTdGGRX+gMDUp6XZbhD1GIX0=
X-Received: from pfbil10.prod.google.com ([2002:a05:6a00:8d4a:b0:746:1857:3be6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a1c:b0:746:2591:e531
 with SMTP id d2e1a72fcca58-760353f447fmr8854470b3a.12.1753363908737; Thu, 24
 Jul 2025 06:31:48 -0700 (PDT)
Date: Thu, 24 Jul 2025 06:31:47 -0700
In-Reply-To: <eeec8f7d96b9dd9482a314b8ed81d3e26f6f6b9d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250704085027.182163-1-chao.gao@intel.com> <20250704085027.182163-2-chao.gao@intel.com>
 <eeec8f7d96b9dd9482a314b8ed81d3e26f6f6b9d.camel@intel.com>
Message-ID: <aII1w2zfPHN9yUwM@google.com>
Subject: Re: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Weijiang Yang <weijiang.yang@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"john.allen@amd.com" <john.allen@amd.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "minipli@grsecurity.net" <minipli@grsecurity.net>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Kai Huang wrote:
> On Fri, 2025-07-04 at 01:49 -0700, Chao Gao wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > Rename kvm_{g,s}et_msr()* to kvm_emulate_msr_{read,write}()* to make it
> > more obvious that KVM uses these helpers to emulate guest behaviors,
> > i.e., host_initiated == false in these helpers.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Suggested-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Reviewed-by: Chao Gao <chao.gao@intel.com>
> 
> Nit: I don't think your Reviewed-by is needed if the chain already has
> your SoB?

Keep the Reviewed-by, it's still useful, e.g. to communicate that Chao has done
more than just shepherd the patch along.

