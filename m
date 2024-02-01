Return-Path: <kvm+bounces-7758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B09845F9E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ED8B28E3C5
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91DD185658;
	Thu,  1 Feb 2024 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CsmJBSEn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE2B12FB16
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706811112; cv=none; b=CbaEMSJiI4K8mOiKIbtRmh/8qVKIm+2wdkmlHD0Nh07bavR9s0zDSq9ZhKtEjgZF20CsGiYRL6QC5BnB9S3sbyrf0+4hYHTZhZvuBF97i2aV174/mOCCFK82UzQdq6iB8Zlt4TIiO+Cr79lf0cRoQKXnFbkf2xBcAasBn+xsWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706811112; c=relaxed/simple;
	bh=oJZnExPh1hLgqd8BEo0SYF65ohxWIh+oCvihI7FGxG8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qdyy0jjKFwsKTwMN5JfgLW/KCqaiKUAn1miF74WU5FC+GIFs8UZR1qAKDniu6algSIUDFjxp312ZRO2MqbF7yu0murExibfZ9lF3l2yHlo338q9/lcdpiOvt0bz2eKuwJcv+JD2CF85Fa16pkbgKMAU3uNVZ49QLBk6R8Tiu9fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CsmJBSEn; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cfc2041cdfso1173497a12.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 10:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706811111; x=1707415911; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zVMnVgWmji6IfqNjADiisykpRLTCPp2q6B857igSDOs=;
        b=CsmJBSEnsObvgJ9cRpPVKDC2nGegf+fGsTmpHhqkn1P5iBKPnWrAbK2Si5F8rVB2YQ
         6fTXxUEVVW7JDz+7UFoCP1mKE0CZUrT/oWqC+LpcMZYBXalwAHUnOkag4XxpH4N4ikeo
         7ktKo7mNVEQwFH1X0Yd8yALAL0AfqKmYbmqU8PKjiF5eD+kX4P/84G2biMV7pdP6RknW
         6b3fOTHVgrN6PQ2WROj63BDmEQhQ7ob7kcBG6VJfGpOoFfkDa0Xl8Sz6JeU1o26xvAHD
         dVf/xgdH+dydq/vzkL1yVEHWh9BFfeJAozrXMNPCb04m5UHJ/v5FTZtFf+xiPhGwQyR8
         hgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706811111; x=1707415911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVMnVgWmji6IfqNjADiisykpRLTCPp2q6B857igSDOs=;
        b=gARvw80KfkNNqyfgCdRjXkIjvw1ToC1VPNQf9dZ1BZcBfNY7MwvMH/aLG3EBVmCAuJ
         3af9d4smf8IQBL1mS/mRx6/GliIuP4e6vkcAtdRk2DkV2YDsmuWz1/kRDBNaDM+ZpWWn
         0xXCZ6X7Yau0wG7HTJAuF8fJiNisXTSQn/HhMjAkpIwBDHnwWfZkpWbPvw9O5lfQq0f6
         69mOQRCG7iPPkhuARHNdws3wrwf4vqHlaULraiY1ymCNI9Ly+wdJIXk0NCw6pRfg2TbB
         YNGGIPvUaW7oyXRdXeYsuNUuXdwHgRK3w2+puvmW0aqtlNpk3/YBKdqu89B7Qj6kccoV
         JzVw==
X-Gm-Message-State: AOJu0YztHDT2tbsQ8BMsIl5OE2hmM+ifg0LDIgdiNiZMS61BvnaabC9B
	hKqpHz3hHqsFz8R5L03FZ7LtmI/kKfO2liazKf1wIFRvof5VUEmcJjllQNvSMXN6Kc7UV/UPtGA
	LZQ==
X-Google-Smtp-Source: AGHT+IHHAKDdARYeMq/bRYuEKynmW78Qhk9wtqyeU1rePQV6W0NpV7NnCGnKy/agnZmiFEbXa37846yjzPc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6257:0:b0:5ca:31a3:c70c with SMTP id
 q23-20020a656257000000b005ca31a3c70cmr57679pgv.3.1706811110759; Thu, 01 Feb
 2024 10:11:50 -0800 (PST)
Date: Thu, 1 Feb 2024 10:11:49 -0800
In-Reply-To: <56e34602-3fa1-cd95-a854-007b3276dbe4@polito.it>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <65262e67-7885-971a-896d-ad9c0a760907@polito.it>
 <ZMFYhkSPE6Zbp8Ea@google.com> <56e34602-3fa1-cd95-a854-007b3276dbe4@polito.it>
Message-ID: <Zbve5bAxC0pD3bOg@google.com>
Subject: Re: Pre-populate TDP table to avoid page faults at VM boot
From: Sean Christopherson <seanjc@google.com>
To: Federico Parola <federico.parola@polito.it>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 26, 2023, Federico Parola wrote:
> On 7/26/23 10:31, Sean Christopherson wrote:
> > On Wed, Jul 26, 2023, Federico Parola wrote:
> > > Hi everyone,
> > > is it possible to pre-populate the TDP table (EPT in my case) when
> > > configuring the VM environment, so that there won't be a page fault / VM
> > > exit every time the guest tries to access a RAM page for the first time?
> > 
> > No, not yet.
> > 
> > > At the moment I see a lot of page faults when the VM boots, is it possible
> > > to prevent them to reduce boot time?
> > 
> > You can't currently prevent the page faults, but you can _significantly_ reduce
> > them by backing guest memory with hugepages.  E.g. using 2MiB instead of 4KiB
> > pages reduces the number of faults by 512x, and 1GiB (HugeTLB only) instead of
> > 2MiB by another 512x.
> > 
> > But the word yet...
> > 
> > KVM needs to add internal APIs to allow userspace to tell to KVM map a particular
> > GPA in order to support upcoming flavors of confidential VMs[1].  I could have
> > sworn that I requested that that API be exposed to userspace via a common ioctl(),
> > e.g. so that userspace can prefault all of guest memory if userspace is so inclined.
> > Ah, I only made that comment in passing[2].
> > 
> > I'll follow-up in the TDX series to "officially" float the idea of exposing the
> > helper as an ioctl().
> > 
> > [1] https://lkml.kernel.org/r/6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata%40intel.com
> > [2] https://lore.kernel.org/all/ZGuh1J6AOw5v2R1W@google.com
> 
> Thank you very much for the prompt reply and useful tips. I'll keep an eye
> on the topic.

FYI, I finally followed through on this.

https://lore.kernel.org/all/Zbrj5WKVgMsUFDtb@google.com

