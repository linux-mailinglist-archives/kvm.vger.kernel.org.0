Return-Path: <kvm+bounces-18217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85ED58D2042
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D9D5B20ECB
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BB2170859;
	Tue, 28 May 2024 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZdELZijr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489DE1E867
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 15:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716909703; cv=none; b=j/BOVNsRYFXbrGEolanL+zBQx+WE8LVWCgpje9Mr65SiYVWT3//sBHyMkizPszipjTTrZuPj2+wbhiC2elL4at1aeeGt5Jt87HR8gHN+2NU62GYx7v8DWtm8XbtvDnysU38v2cI+sNlnsYFJXYZa1hIzv2uyiGY2/AFjESshdEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716909703; c=relaxed/simple;
	bh=0Yz2y7QOJfyVBPMZHgZvT/EZ6hOdwvYJIao8t7SoEpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oZF/U2D9tHUk0/hcUxKKXaFwy2J8ZVxnDCsGwCHManEV93wqj554iJGZjmPev1/1O/KlNMttkqEJIb/nu0BCT2QDdPlq2hV6BuMZlTksqrznrlKHbmnC3wLnBAVxhaPHhEcxlAop/qMR0E+SWbF1Svs2ycDU7UU9OVL47iwS/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZdELZijr; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df78ea30f83so3116586276.1
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716909701; x=1717514501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bRBd06u9sCh27O0CX55ErAEywPjabZqaR+RrcX+yUJY=;
        b=ZdELZijrgmbN4vo4vJlQaB7jZlrjKQ8tU4sE3CQEnDrkNcVTUFcaUH1Qh5kPvXiEGk
         rqwd1RUNKiyVXID2bmOq7duAJN1Ma6zfSfBAIwA8sEaANUXS72LTvBvpszIfEDSiffSw
         ZQR8StReqr2wZz1ybHZCwlAgS57al8vX9oyvP6bDTPQ1KrIxmBRbSvDSWzAg4YmLlyFx
         kQ4QALOtdAAhnvrDxZkTJUerhwZanVmDYyEdA8a7QI3duc8wLz3SIlXdeF7F2tNHvOYL
         VXl7pcX0a3QV2/eZkNd0iiSJioPUtU9W13zzvsJjViGMHvIGuW3EXEUWlCBkGkiR8qyl
         d1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716909701; x=1717514501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bRBd06u9sCh27O0CX55ErAEywPjabZqaR+RrcX+yUJY=;
        b=KDi7c54oAfgQwbuMwp7mDRSzzDy2+7DOH2mQEalptQVRJReQ8fKRCOTkJoZT4Vbv4l
         92+8kV4dUDNujoaQvVkZxV4fUaZSs/jEAG8x3l2YM88nSEGz5XznQOJi6xsd01eFf41K
         GwfPPmS2uAV+PpOKFwss9/NJwmpP+Yi7SkDpClEzbTtRnr1RcRCTte3RxvSRfOgp7+AH
         AwDoWEig5F6xxmDE0TRC/BlUv4t/IMVpNDbJoZ/StcJEjyGXQ551edJEXp8HwGfjqIh0
         WcnCxO6B/15pg8ynOFfIpTg9jBq/2FiMZ1VRRaLP0ZLuPODdZ/3N2Jgu8zZnqnvYVRDG
         qK3A==
X-Forwarded-Encrypted: i=1; AJvYcCVuSciDTLtB/KSXdm0MJYvHTp/OG/aTKdO3DfhxP9OLVeAESZaZjK/aiZw0eN/OKCtGdtpjBvkvilI1i1bBMA1vFU5P
X-Gm-Message-State: AOJu0YzvE7/PM1/cXXIPlCDpoOA7jbL0P1WXvl87IJcowF4DO5z06P+f
	RuckQk0BwyPj1KdupussuBmGvAt6rG7fu41LKOMU5lm+UkofiwAnsaHqd0BDYd4n0UR43joYUY5
	+yw==
X-Google-Smtp-Source: AGHT+IFUg0oBR9pemkRQzM4G8p0w9fg1yaIVZjFK83T1P8hqcQyT058SSgYKhk+6Fyn6cEBObfTSHitNrv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:f11:b0:de5:a44c:25af with SMTP id
 3f1490d57ef6-df55e78b521mr3033739276.5.1716909701251; Tue, 28 May 2024
 08:21:41 -0700 (PDT)
Date: Tue, 28 May 2024 08:21:39 -0700
In-Reply-To: <9296de25-0d3f-47eb-a98b-e0dcd388cd6b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-34-seanjc@google.com>
 <9296de25-0d3f-47eb-a98b-e0dcd388cd6b@linux.intel.com>
Message-ID: <ZlX2gxki9tw3Uny8@google.com>
Subject: Re: [PATCH v2 33/49] KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, Binbin Wu wrote:
> 
> 
> On 5/18/2024 1:39 AM, Sean Christopherson wrote:
> > Advertise TSC_DEADLINE_TIMER via KVM_GET_SUPPORTED_CPUID when it's
> > supported in hardware,
> 
> But it's using EMUL_F(TSC_DEADLINE_TIMER) below?

Doh, yeah, the changelog is wrong.  KVM always emulates TSC_DEADLINE_TIMER.

Thanks!

