Return-Path: <kvm+bounces-43977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FF4A9943B
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DED264A82A0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C42F266F1E;
	Wed, 23 Apr 2025 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4OVJxLgq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A6627990F
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423760; cv=none; b=imU/DJZX/jH/vB356N/7Diu/HwB+6rtRhmnuaYi6wxLFADgRPXGeIjGEhvMjInBIExazJuSoOf98GPSmZehjn/Nhm4JhmmXQWbOTt4mBoo7bDLdddAMB6UbKJI9mI0GYtx/FXE2FFd9ccweaOp8t4X41cBu0+GSZaNMFY3rR9II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423760; c=relaxed/simple;
	bh=+2Q0TqTUlO+XxdYqin3kJ59kqtlT8h5Kw4yFiitoAu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KEFY/3Punw4TZnMRaH+GmcrYlixDBpC4J8c9i4pv7mZ9GkVzNJPnFCG+OFDE/+oBxSt8RWiPa4tLx1CtvEjgbWaQPGZyJ0OXD3RBMs22AxhPS/h8q3SL5PyPZvnG3Z6k9ZGHs6TcvnT7uqil0hIWAGAi8dos3LzVZ2kA08gA9NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4OVJxLgq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff68033070so11559a91.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 08:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745423758; x=1746028558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jmJGVTNM68EN1Na+PFsjzt6zkvxFPDOKXQFGaHd/MNo=;
        b=4OVJxLgq7yQkXec/gpLkz9iv5/PLWU420CoYpKP8880ek60gBNTCC0WFREfJp5KC4Z
         SaXDyam9s72dD5F5N0+6m7DHBUlZgtvea/DvRDjDISL2bziWggyAF/CQTsQ9B00ihEq7
         ufw7MTg2fTrpGrAlpz30CLk5U+2T16iMINDFXwFxvoUY0So2pjLYQuLouKpA6ENTFTiK
         cvczy//hU74hhep9XwQnQCiqGsruOeHIsKrlIhV6ca3t/mHRdS0gqj9wVndmzmcSU/VY
         lya36nqLTPxKD2sA3bC1cAsK+xFJdbAIvdOQ7Uc26drvjYDDwfhj1XXKCu5PlVDW8feO
         DCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745423758; x=1746028558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmJGVTNM68EN1Na+PFsjzt6zkvxFPDOKXQFGaHd/MNo=;
        b=eF3YCSNkcrNDPAerPvBDI/Ny3yEcLxMV+HAOZQeIpJ04vKS/9SG5djFsNfZi68Gy3n
         SpTE/Fs3SCyXFbWZka8fKeOYxeCmEB5D/m3dnx8v/l5KwedtVdzIuBhaYlvSu2lJaPCH
         26N3EFixgTTYMKnItMY1YSdwsLtgxpB2XwYPOsdYHStyhGIjPqn0VT9M/946TPRpfkGj
         OQioUlof7QiLQV0mWtBvRqXrjzcShPkh2JN2y9akWX5GLPZY7b4ptO1w+w6DgZclywG0
         eYhgPetaTMAS1Fgj31stmGzmCLpoTbLmhXdvlATcJnq4gw8beGwn2+fieBkNAq90yX+p
         VVbw==
X-Forwarded-Encrypted: i=1; AJvYcCWdjxCLezapJ0e6q3b43lUg1q9uUBXuMQBeeKTY4pUJTi/Fl4xlpOteMgAMWGOOHEFvgI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd9a6hA/pOhI7ors/k4sbFPDxkL9LT+K/AxT5SK8U2Zj+1ltRt
	i6IVHb5LZSHGojVr3i4zjR+saQIduMUQjtXO/A6y4vXJSsaildTrwEhxAdWsk+3XkgHQlK8+Y0M
	0/w==
X-Google-Smtp-Source: AGHT+IHnOGraDXWHVwtcHF/KJZows5bTw5g1o0e7YCWv5QZQLWNkV6iHhA0+G3682VIduWV5Xwdn6KbTATw=
X-Received: from pjyp14.prod.google.com ([2002:a17:90a:e70e:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2404:b0:309:eb44:2a58
 with SMTP id 98e67ed59e1d1-309eb442db3mr417907a91.22.1745423757994; Wed, 23
 Apr 2025 08:55:57 -0700 (PDT)
Date: Wed, 23 Apr 2025 08:55:56 -0700
In-Reply-To: <15e24c455fb9fca05b5af504251019b905b1bd77.camel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-32-seanjc@google.com> <15e24c455fb9fca05b5af504251019b905b1bd77.camel@gmail.com>
Message-ID: <aAkNjKIleB97r2fe@google.com>
Subject: Re: [PATCH 31/67] KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
From: Sean Christopherson <seanjc@google.com>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: baolu.lu@linux.intel.com, dmatlack@google.com, dwmw2@infradead.org, 
	iommu@lists.linux.dev, joao.m.martins@oracle.com, joro@8bytes.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 23, 2025, Francesco Lavra wrote:
> On 2025-04-04 at 19:38, Sean Christopherson wrote:
> > @@ -876,20 +874,21 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd
> > *irqfd, struct kvm *kvm,
> >  	 * 3. APIC virtualization is disabled for the vcpu.
> >  	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
> >  	 */
> > -	if (new && new->type == KVM_IRQ_ROUTING_MSI &&
> > -	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &svm) &&
> > -	    kvm_vcpu_apicv_active(&svm->vcpu)) {
> > +	if (new && new && new->type == KVM_IRQ_ROUTING_MSI &&
> 
> The `&& new` part is redundant.

Ha, good job me.  Better safe than sorry?  :-)

