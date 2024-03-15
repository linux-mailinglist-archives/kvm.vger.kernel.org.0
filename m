Return-Path: <kvm+bounces-11938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 110F887D4BA
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6B20284CF3
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E034537E3;
	Fri, 15 Mar 2024 19:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QIGTuRhp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCAC56475
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710532525; cv=none; b=VSlx8qzXntt25vXouix9LQQFwYE+gPBbJmURTQxyJdUM2ot55ba/E1WDS6ZKWpcCqVFw49pi7GUaJcDPfeueaCdrMVYDsybEIgIhQiJjv2sG8WCFFOjkLs0CWUt6De0HGUfUgFFjCrtFMh0Pno6moJC/z7rQ7NvzQ4omxcVtxfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710532525; c=relaxed/simple;
	bh=J6PKphrZR06vT6aM+gdKE+v15HtoN6dbFcpt+pGRX+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3EFitQsNR0lOfTeCRTcKiQCs1/dqIQQMcKAmTQHsJOXHt2UCwmL83PdEthoSOi5p+PrelMCWnnNB9F8NepyHyafsBIkrb75cuKZOWEPCi+EKYl05ZzPrgXjS0NUpF6AcMKWyCcKSBO7qSLVFneqlFrJDRVBnrXx4o0KOpyQ+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QIGTuRhp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e70785d542so3735b3a.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710532522; x=1711137322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yxyVTUGycMtYWiSqNQA2N1Tj7Ge76hIQfNcRcR5oHf8=;
        b=QIGTuRhp1ewtXKNVvCaqviHdQKuY9xu/Aehctganop+ThsW68/AQ4iisU8RmI7lB63
         JvSy9mVPvpW92opxQl5zNsQETIacwxnf7Nr/xVM4YFjvbVH5cdOmkGRaX1wz20qt8ZhE
         TV2mQI6igziVNS1+yyJpawhdFx12ZZ1HBH9XdQ1LAbPTpR+Pk2XJaxalVBOlEwUsRP7b
         OGrXtvTNHUDtIgX7pRak16MmwHMj/0zrDEfSwHQFTAQrGPEVuAY8Lewd7ViOdZdCdOhW
         vEWBrJ0aFaxLjeYzp/AtIrI8Pl3dsZVZ/L+Ydq+sNEkAuRt6ER9sSaGXt8qy7wl0KG7M
         KwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710532522; x=1711137322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxyVTUGycMtYWiSqNQA2N1Tj7Ge76hIQfNcRcR5oHf8=;
        b=EA0Wl8qJmOE2/xg2wHylX0+M3TOykATtZG0Nj0En//W63Gh+vwJCUr3uOCVK378Vxi
         VCK6DbmugXxib6MXKxBgMDyWq8bmTXvYrmGI6NkgSbC1h8LtG2ubiT+wewiOqylL7p8c
         ZHa9cjtrcDIDHDcKKUHe6QysUP28fB4zx7uN9INRpRfncZtVs5PPM/1OdA3SHAyvb+a0
         0s5SNM3tCUehdzf/nUWpUbcqZi5nRc+nHm6Y4ZiUWenSeKwns7DTgdNRsWOTXluKEEzG
         BKw51qkKFnAG9MV8GVOxqZofvXYhgN9JNEZud+jobNBUi08O4ie43u9bh6qhbky7rPC4
         +Gbw==
X-Forwarded-Encrypted: i=1; AJvYcCXZrdJfA6kuVEcmFpGoUalkJQFhqXRST/6tkLr6nsA16ZSF5G/DL9l/meI/WPO4pWC8O/9kf+ZlLQymysoSF2zzUJ+d
X-Gm-Message-State: AOJu0YzVE7wiafcLYgOazrIwRcxk/g0EzaT6fSqFZ5o8OtMABmITqpSz
	cipIcjY+LJAsEUhTAwfs0utmC4ZWI5ZUCTzv5mnWBEupw8uHtxGyRAVoMAWOZr9ALSW9jCvVDqS
	3qA==
X-Google-Smtp-Source: AGHT+IEMtCqxevjMlBgShcDqmIvoX0aabbMfq9kTGHCGc9Q0Ud9Vyavfn60pnT3bfVR8zK01ozt0Yd1y/sM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:84c4:0:b0:6e6:985c:987e with SMTP id
 x4-20020aa784c4000000b006e6985c987emr38651pfn.3.1710532522246; Fri, 15 Mar
 2024 12:55:22 -0700 (PDT)
Date: Fri, 15 Mar 2024 12:55:20 -0700
In-Reply-To: <202403151639.371a9400-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202403151639.371a9400-oliver.sang@intel.com>
Message-ID: <ZfSnqIu3qw_pC7_O@google.com>
Subject: Re: [sean-jc:x86/disable_adaptive_pebs] [KVM]  ade86174dc: kvm-unit-tests.pmu_pebs.fail
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Like Xu <like.xu.linux@gmail.com>, 
	Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 15, 2024, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "kvm-unit-tests.pmu_pebs.fail" on:
> 
> commit: ade86174dc69254b50a67f836b2b8ac2c5644e11 ("KVM: x86/pmu: Disable support for adaptive PEBS")
> https://github.com/sean-jc/linux x86/disable_adaptive_pebs
> 
> in testcase: kvm-unit-tests
> version: kvm-unit-tests-x86_64-023002d-1_20230714
> with following parameters:

This is expected, pmu_pebs incorrectly assumes adaptive PEBS is supported in
certain flows.  It simply wasn't hit until now because all hardware that is
compatible with the test supports adaptive PEBS.  KUT patches are posted:

https://lore.kernel.org/all/20240306230153.786365-1-seanjc@google.com

