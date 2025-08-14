Return-Path: <kvm+bounces-54699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F915B272F5
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 01:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D68971BC7435
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 23:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AB42877D3;
	Thu, 14 Aug 2025 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dA7tjBdY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC32D28507F
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 23:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755213779; cv=none; b=HVmDOUy22urHC4PJzvIn6OD0CbEFfVyeQUkqPysMrese59IgqikitBtx0Zo9IH1nivSJ9Zv4aSi+8JD0+ihKKHINkH1kYYDjUd28hewF/YI07wX/YbZ1gVvn8QHrTUtIZQc9KhEwq3bUBn07qnF1Y0WQ3ue9lueNw+hlmVKzI/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755213779; c=relaxed/simple;
	bh=tcEkdB9lYA+g3s6rbDyV0+neEJSjT70pW4GVfIJE0pU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mxA7vOqDQK8qle7zitG/bI4q6cLlKtTRNc4VcihfBJBcDWDwJNxt6nVtb9HJ0w7i1wMEw2sAc13Jqjga7s/wTAkcoiIz8eNC2jZAlz5OGFyE17HpIo0JCd4a8/OZlaR/9fGegLSK0nKeSZe0Gmyle9ZKW9/QCWE6LqtKGwkdGPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dA7tjBdY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso1222024b3a.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 16:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755213777; x=1755818577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=krfW9MJI3EjbHe3Dh5mCsfvuw0C/n3sj2jbdyYaxcO4=;
        b=dA7tjBdYGw4EQqVPWAXZ5hDBT9wkdciIIcdww80sC+GvLXMxkOSvkAnw1Gsw7U+ScZ
         KzygEcTHu/3NdmnV+UNatcaVXQTT8UIf1+TrM9qukdXTi59XmuebXKJvAmWRp8U28hDS
         uW3WHhqAzz9A7/hE6XNzYQAu14Z1eF3sleTEMKUQcekV+jsE8ObIRY3tRzRCbeMvAjUG
         VKFAtyR32HhbgCDoA5KnmFAnbyG1B3UBNmZYvswxlw6RisPHPVfXNCfvqd+Zq5jGDoqM
         MYBc8LW2HYjIwrNEzdvBO3H2EmCdOfDHuM7qCFiWzkfn0FltWu91dC1Irro5pH8lApgX
         kkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755213777; x=1755818577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krfW9MJI3EjbHe3Dh5mCsfvuw0C/n3sj2jbdyYaxcO4=;
        b=wRWEZklzWwQQ/o0KYcgyJrYoi4z14ar50DeNPhE+tn+DM9zi1V9jFrbwRfrpIB4Bw/
         WwSCJUHxngjngu3Ev/CjpNFN8oQU+dRmYM4+6FACpnSEtDJF17vIOgh8Xj0FUYhykcCM
         cQ4fvDxr8VBCgpi8OhBCBYvEzk9lgBJUvOrdjl4GvTI50z6f72cnIZTvMrzO6vMbtiRe
         KY3EVuhnh/Md/G7nnkrgs2RY8IabP0N9rHl9jGGQbsDHbQ1Byk//WwcWAIdN7XNKuxya
         ZSA641/914AZlizz/zYJRR4dq/hGvlaN1wNblE6lJIo2LEj97DRq4/B/fiNI03wVYkyI
         w4dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbNZb3vUn492MNBeBTr1JdUFJFX71YLVvCbQ+w1vcFjRi/cTedmY3rpNl85/wOgsDcI78=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO9JNf1fUA/L0fbtUzHBMKjYcydOPHAxr1L9Ea5BA6zz/DrOZO
	DO9PYzFe39C7FEv7+Eh4Ogk8j+bX3KdVclh4URFcv8nksL2PP/KEHkb72oNK7mbnXsYt47aHJdh
	zGs7bRQ==
X-Google-Smtp-Source: AGHT+IFb3Ekwhg0EesX0KNw6ePrMATVTtWrtr5mRDMYNrtZOSTfBiWV7x68SI8ZBLWJhMegWadJI1d/1X64=
X-Received: from pgcv17.prod.google.com ([2002:a05:6a02:5311:b0:b2c:4548:13d0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748c:b0:23f:fc18:779c
 with SMTP id adf61e73a8af0-240d31a4908mr42980637.31.1755213777172; Thu, 14
 Aug 2025 16:22:57 -0700 (PDT)
Date: Thu, 14 Aug 2025 16:22:55 -0700
In-Reply-To: <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755126788.git.kai.huang@intel.com> <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
 <aJ3qhtzwHIRPrLK7@google.com> <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
 <aJ4kWcuyNIpCnaXE@google.com> <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
Message-ID: <aJ5vz33PCCqtScJa@google.com>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, Dave Hansen <dave.hansen@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org" <kas@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, 
	Farrah Chen <farrah.chen@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dan J Williams <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 14, 2025, Kai Huang wrote:
> On Thu, 2025-08-14 at 11:00 -0700, Sean Christopherson wrote:
> > > > > +	 */
> > > > > +	tdx_cpu_flush_cache();
> > > > 
> > > > IIUC, this can be:
> > > > 
> > > > 	if (IS_ENABLED(CONFIG_KEXEC))
> > > > 		tdx_cpu_flush_cache();
> > > > 
> > > 
> > > No strong objection, just 2 cents. I bet !CONFIG_KEXEC && CONFIG_INTEL_TDX_HOST
> > > kernels will be the minority. Seems like an opportunity to simplify the code.
> > 
> > Reducing the number of lines of code is not always a simplification.  IMO, not
> > checking CONFIG_KEXEC adds "complexity" because anyone that reads the comment
> > (and/or the massive changelog) will be left wondering why there's a bunch of
> > documentation that talks about kexec, but no hint of kexec considerations in the
> > code.
> 
> I think we can use 'kexec_in_progress', which is even better than
> IS_ENABLED(CONFIG_KEXEC) IMHO.

I don't think that will accomplish what you want.  E.g. kvm-intel.ko is unloaded
after doing TDX things, while kexec_in_progress=false, and then some time later
a kexec is triggered.  In that case, stop_this_cpu() will still get stuck doing
WBINVD.

