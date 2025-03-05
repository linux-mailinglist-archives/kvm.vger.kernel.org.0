Return-Path: <kvm+bounces-40164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A64A502E6
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:57:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDF813A77F1
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE7E24CEFF;
	Wed,  5 Mar 2025 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PUdDf9Vm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66912356C2
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741186403; cv=none; b=SJdvYeOEPKjGTnTYhfvaJQ7xJ18cNhvYHEadQcCM/bYZ0smM81aeZDoiOpaimAkHBdkiicQX6P816SQguf2w6qAqRX3FMUoaKjKfQSJ0KXgfOEOVqz4vsa/+p503RJDM7+M71OZ30UHyyfcwsYdmgjc0E4cRe+u5IMhQTXqnOCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741186403; c=relaxed/simple;
	bh=PGeG/E7ja4XGWHxNzROzI7h2oCS+EH16SyURg4QxoA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qGHuYiAaTRYo4x/r1wCEMTMSWcJ+EAzTVAoqgCsE5UGrcEBtywq8jKbiexwl0Za/2O2vrxZrfFzPyTkOZ6xvStlNh38iOFKOV3CYiOYrfZfG1J+Hhfcu0HAmi/Uqh40jvdTjqfxAl1HwC5WSjhO708YJZDBRdHKAmDa8EcYvX8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PUdDf9Vm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22107b29ac3so15853005ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 06:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741186401; x=1741791201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu1YW5U539CmDNjnWklLjoJJJx5nCfEh8QEnX9CfqX8=;
        b=PUdDf9VmsQH1kjJuTP65L0FGZs1tbmboqC27fUONrdmB8SZ+1JitK1plNTkO5zfo0S
         qiLlO4LZr8TKCMbEz5W/f22y6w0cVuZRLRoe1j3cBT7hiExC9+8ff9mPUwbuFMDgWfLZ
         SnOXVKWfnKWOpq9iuYp0QwFBJOC5Ebf2HMnnYEBHwq7kJTvju0gJYiTQg4BMZXXZy0aV
         QbHZFjWppEyvhDtua1Lk+GjYZy+Sv+Avjke6dnqVmAC5msZg+US0xp3jQtpwSsJ3A29Q
         S2BFO/wM81HjaiH8dTCSmD/+q10WMLYMsqiJQZzt+2KOauzzt1SkyshqQ7AIxs2kbl9v
         xzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741186401; x=1741791201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu1YW5U539CmDNjnWklLjoJJJx5nCfEh8QEnX9CfqX8=;
        b=bven60OoIAr8XjHrUFUttF9tyvPwH1oo9d9VyYzd+s43K3z02cPOe+vyU7JyY1w+ku
         7gSgnkjW94FAxRAKyhhRO45V4ZV5AFbcChnudxBItiIrhRxFBpkK3NpkenqQJ77dxTX4
         mS2T21vaBX08Rde89KM9RA+7JuvHuSXxlDOpQC4teGNg2sTNEOm1CV9guukK5eCSkTOk
         DmkvnTpE4837R7jcefwu76eGdg+kfOnWbXuzfG4LpTIC8SsauJJMDf/RFR+rnARx57a8
         qJdpa747dj1LIKOKcchEfbrfaEX/V7CVeRFTaRzRJEqQdx98lNcrUsKkkq+gYwqVNCCF
         05/g==
X-Forwarded-Encrypted: i=1; AJvYcCVqS8NA7Ht6OwW6epZN78Gpxdb8pnQbeM0BSh6+mctoJrN+7dLdu81GzqQp7P0udOpYGhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhNpMjWYp/Qn15iNal4Zbv3PMJyxISEkZrCvT2dEFU4yAJSA/R
	HKA4OakInqosPOwZYOACyItw2dxgZFO1ZPuLd8nUT1/coW0uguYx0f+1h2iv0JDCYBQFyq5vPeA
	itQ==
X-Google-Smtp-Source: AGHT+IHAYzQscJ8h7qg5HkSjPcaVcG06YIt5n669L2SaCaC2sybvLMQURj9aN7SRU326Fz9IYsQdsLpJF/s=
X-Received: from pfbft1.prod.google.com ([2002:a05:6a00:81c1:b0:730:9146:35ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f84:b0:2fa:1d9f:c80
 with SMTP id 98e67ed59e1d1-2ff33c2129amr12121356a91.17.1741186401066; Wed, 05
 Mar 2025 06:53:21 -0800 (PST)
Date: Wed, 5 Mar 2025 06:53:19 -0800
In-Reply-To: <2025030516-scoured-ethanol-6540@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250112095527.434998-4-pbonzini@redhat.com> <DDEA8D1B-0A0F-4CF3-9A73-7762FFEFD166@xenosoft.de>
 <2025030516-scoured-ethanol-6540@gregkh>
Message-ID: <Z8hlXzQZwVEH11fB@google.com>
Subject: Re: [Kernel 6.12.17] [PowerPC e5500] KVM HV compilation error
From: Sean Christopherson <seanjc@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christian Zigotzky <chzigotzky@xenosoft.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, regressions@lists.linux.dev, 
	Trevor Dickinson <rtd2@xtra.co.nz>, mad skateman <madskateman@gmail.com>, hypexed@yahoo.com.au, 
	Darren Stevens <darren@stevens-zone.net>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 05, 2025, Greg KH wrote:
> On Wed, Mar 05, 2025 at 03:14:13PM +0100, Christian Zigotzky wrote:
> > Hi All,
> > 
> > The stable long-term kernel 6.12.17 cannot compile with KVM HV support for e5500 PowerPC machines anymore.
> > 
> > Bug report: https://github.com/chzigotzky/kernels/issues/6
> > 
> > Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/x5000_defconfig
> > 
> > Error messages:
> > 
> > arch/powerpc/kvm/e500_mmu_host.c: In function 'kvmppc_e500_shadow_map':
> > arch/powerpc/kvm/e500_mmu_host.c:447:9: error: implicit declaration of function '__kvm_faultin_pfn' [-Werror=implicit-function-declaration]
> >    pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
> >          ^~~~~~~~~~~~~~~~~
> >   CC      kernel/notifier.o
> > arch/powerpc/kvm/e500_mmu_host.c:500:2: error: implicit declaration of function 'kvm_release_faultin_page'; did you mean 'kvm_read_guest_page'? [-Werror=implicit-function-declaration]
> >   kvm_release_faultin_page(kvm, page, !!ret, writable);
> > 
> > After that, I compiled it without KVM HV support.
> > 
> > Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/e5500_defconfig
> > 
> > Please check the error messages.
> 
> Odd, what commit caused this problem?  Any hint as to what commit is
> missing to fix it?

833f69be62ac.  It most definitely should be reverted.  The "dependency" for commit
87ecfdbc699c ("KVM: e500: always restore irqs") is a superficial code conflict.

Oof.  The same buggy patch was queue/proposed for all stable trees from 5.4 onward,
but it look like it only landed in 6.1, 6.6, and 6.12.  I'll send reverts.

commit 833f69be62ac366b5c23b4a6434389e470dd5c7f
Author:     Sean Christopherson <seanjc@google.com>
AuthorDate: Thu Oct 10 11:23:56 2024 -0700
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Mon Feb 17 10:04:56 2025 +0100

    KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
    
    [ Upstream commit 419cfb983ca93e75e905794521afefcfa07988bb ]
    
    Convert PPC e500 to use __kvm_faultin_pfn()+kvm_release_faultin_page(),
    and continue the inexorable march towards the demise of
    kvm_pfn_to_refcounted_page().
    
    Signed-off-by: Sean Christopherson <seanjc@google.com>
    Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    Message-ID: <20241010182427.1434605-55-seanjc@google.com>
    Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

