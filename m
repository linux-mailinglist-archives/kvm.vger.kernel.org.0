Return-Path: <kvm+bounces-4384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BB9811C34
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 19:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1B601C2123B
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D81C59B54;
	Wed, 13 Dec 2023 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lqpWHaS+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B653B2
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:20:04 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ca26c07848so82289357b3.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702491603; x=1703096403; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xz5fzkhA7XaxO8qhCaeU0/NhPvZFDZX9ISdl3VEiPjQ=;
        b=lqpWHaS+KDxwCPYcd3H0K8nJNNhWgvp7PV5vo+IG+hZRF0hu+TpAWSlfhwLsQYdoB/
         61T8/EWFkILVcx03y+sm9sqPeYuKP5Y5i3qmGfc0RV3UmdWcPB4sltWO+lX3Yzt0omCB
         mGNfbV37pGhUgW/UcicHADrsGUIRVQvpLC/MdfRTtBqtZvkG5xfOCkX5TAfsh7Fhgo2N
         qkouFfoTQ67m1Nt/IRM4v2aVpYOueIDPoQsRA28L59VLCgy1xJ79rWritpwfMSpalO6J
         DhYde82T5+RdyXlnLBSAuNt8QtmgBPShZDl+ml+ty3HhSSU09hmACjVAmNyWNGhX/Tmd
         JZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702491603; x=1703096403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xz5fzkhA7XaxO8qhCaeU0/NhPvZFDZX9ISdl3VEiPjQ=;
        b=hVJbghOtUYOpfVHbBuPSdukROtrlGeZZLHoL4JOh9fX4LHs8ORGUgBkaW1TCR3JN7Y
         oTMwPiUsnSkdKizqbXHHmy+qaPvxKholiHcYXGlQWSVYY/E4hm7LNB7nl8tLgw1e1Se+
         efNWkGiHnylkUlQAGIcPm4LWzhFbs/fjnnZm1/UU1YJ7gudWFmzhVHSl9hgEPrJ75IZn
         m13jeoRV7G55/Offulti93GIzCjURw+ElBATLR+AiH8h0kTX5XTECqdzxlU4rsXSkHlj
         S0Ffla0+wuA6sXxD4obTR2/3LHdBCfMNUsutoQVXswnhn/gzAKCzDO72A6pAmztfXYlt
         gnVg==
X-Gm-Message-State: AOJu0Ywzlxu9TRtCESfCfOXHzyr2DpLdGFZT3gphhVB/wN8dlfSON6OI
	q/QRhZ9joxasp6LJm4PL5eW3xCFXBZY=
X-Google-Smtp-Source: AGHT+IG1TeJv3EnRuYNshAUDbJSdPJ9DNka+BkhDZ31QZyhY0767Nz++D+q/1qnnpHpjFxYeKsvxC/mt4rE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f89:b0:5c8:b920:dc5a with SMTP id
 df9-20020a05690c0f8900b005c8b920dc5amr88321ywb.0.1702491603604; Wed, 13 Dec
 2023 10:20:03 -0800 (PST)
Date: Wed, 13 Dec 2023 10:20:01 -0800
In-Reply-To: <67f29426-7af4-4b07-a22e-fdf89a7b452c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212062708.16509-1-dan1.wu@intel.com> <ZXh5fJonSWLcHmkN@google.com>
 <67f29426-7af4-4b07-a22e-fdf89a7b452c@intel.com>
Message-ID: <ZXn10V63oCZ2NicV@google.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] x86: fix async page fault issues
From: Sean Christopherson <seanjc@google.com>
To: Dan1 Wu <dan1.wu@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 13, 2023, Dan1 Wu wrote:
> 
> On 12/12/2023 11:17 PM, Sean Christopherson wrote:
> > On Tue, Dec 12, 2023, Dan Wu wrote:
> > > When running asyncpf test, it gets skipped without a clear reason:
> > > 
> > >      ./asyncpf
> > > 
> > >      enabling apic
> > >      smp: waiting for 0 APs
> > >      paging enabled
> > >      cr0 = 80010011
> > >      cr3 = 107f000
> > >      cr4 = 20
> > >      install handler
> > >      enable async pf
> > >      alloc memory
> > >      start loop
> > >      end loop
> > >      start loop
> > >      end loop
> > >      SUMMARY: 0 tests
> > >      SKIP asyncpf (0 tests)
> > > 
> > > The reason is that KVM changed to use interrupt-based 'page-ready' notification
> > > and abandoned #PF-based 'page-ready' notification mechanism. Interrupt-based
> > > 'page-ready' notification requires KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well
> > > in MSR_KVM_ASYNC_PF_EN to enable asyncpf.
> > > 
> > > This series tries to fix the problem by separating two testcases for different mechanisms.
> > > 
> > > - For old #PF-based notification, changes current asyncpf.c to add CPUID check
> > >    at the beginning. It checks (KVM_FEATURE_ASYNC_PF && !KVM_FEATURE_ASYNC_PF_INT),
> > >    otherwise it gets skipped.
> > > 
> > > - For new interrupt-based notification, add a new test, asyncpf-int.c, to check
> > >    (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implement interrupt-based
> > >    'page-ready' handler.
> > Using #PF to deliver page-ready is completely dead, no?  Unless I'm mistaken, let's
> > just drop the existing support and replace it with the interrupted-based mechanism.
> > I see no reason to continue maintaining the old crud.  If someone wants to verify
> > an old, broken KVM, then they can use the old version of  KUT.
> 
> Yes, since Linux v5.10 the feature asyncpf is deprecated.
> 
> So, just drop asyncpf.c and add asyncpf_int.c is enough, right?

I would rather not add asyncpf_int.c, and instead keep asyncpf.c and modify it to
use ASYNC_PF_INT.  It _might_ be a bit more churn, but modifying the existing code
instead of dropping in a new file will better preserve the history, and may also
allow for finer grained patches (not sure on that one).

