Return-Path: <kvm+bounces-39891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5BBA4C4E0
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 16:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D9917496F
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB242139D1;
	Mon,  3 Mar 2025 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oShce406"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6E32135D8
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741015352; cv=none; b=cMnvC1JT5reP/iCY43ktVG2KKA6nlIzmcu83G0Brn2qkYhKuJ0AEjns5Nfab2ZXaKEU8l2BFG8fpiyGD7MY/8HbogIfsobiAahGQRXkrgzB8OZd37/klYoVGDR1bIcg6xpGhTOdqC6n2dwi91To/AJBFf0MnPsy9RJ2HTET18ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741015352; c=relaxed/simple;
	bh=1GJMzL1JCfD1of+CdpWKHBCwpGULIi+nH9B6YQ4M1zk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iNL9p2cQLtSbTf/gTIaxe4HWti3MbSXyDJaXSz9kHuqAddC4R5CovVt642Hah/VLJEgV0s6+P9cnNgI4iOpMcIp2sR9m+lwHnA0+RRWnPvJ3nJl/AXK0lr2Mlf/CLuxx56N6wCElsjLgc3Upj54OQS6Sfm4ISL6ufS6EYBAixvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oShce406; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff0875e92bso3377054a91.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 07:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741015350; x=1741620150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMGTphITkQdxhY2pPCzGCe412KH9D06U0hlG+OB42HI=;
        b=oShce406ft3mjFZB3zbn8VZhGuZJeFwgagXZFVgqi2k1jwUcf88cIIs9g3faBBkhwX
         y1iJ4znY77WxlZFtLHNRKd6YNJoqARvrcNCOpRFiI82Ia7oo2sJ1DQVmBCRZm0b0r4zm
         8iudFBPGQFAq5CfW/dhAz01LQmOHK3KV6Qp7LD18PuP5blwAbge5fAtem0+7Uh8v/uPW
         aHixGJ12t7NxuIATVPJmLJ2aLqrXkm+B5Xdarr0MEhrkZimeaFuU7xw+6hZ4K6y/hMZh
         4W/AR8CxORaeQmfZOtnfp3QZaQPuJf5JPCRw1L8/yVo6IafRzGOnuK//CRshEdK2jsBD
         /3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741015350; x=1741620150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMGTphITkQdxhY2pPCzGCe412KH9D06U0hlG+OB42HI=;
        b=gPILuOFoW3swGEo+Wg77oJoMpt02yCeK7mGiIh/6fc6/TyiwxY+5x82U2JfEx6TtDq
         uDuioPCzJfCWfrngxYvaQVnjgon1Fe6S1d1hbIB+A56O0Apgx5NYYsE6jln7cFnxBqZr
         pHMa04I9iYrWa2rnsF2DCfhWM+MZJPxnS7YhXUqeKZhYanHjVwZT358z2Cgcn7kIXYhR
         xO8Qkx9hLQXnGaCgHWlb+VZARxGGewy2YSI5bz75T9qJBAgqTRPmX5pDCIIQEngT70g/
         vLNcj2+d2jEQQ4lHYObq0VVv/ZMWPdoKDQlB8suOL6xv6MDcpz+9m3W9AL+4IC0548wX
         UJlA==
X-Forwarded-Encrypted: i=1; AJvYcCVmEf8Wcd70NKHlSPrJ6g5m6D1oti0U28hDS3kSZCoq44x+ETNG7Royi9eb2n4zHHoi48E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsPuAVUVEnbzGDLN9zwwl62UGkG3n2tu3KC4Z8zhaJ8mcmf8bn
	2tAGARhTGnIY27W6CHNxdlQf/69yTG+o5F0xCnuLpjfdq3qy28hixsjZYUJoJozXF128sYEG6xi
	CjQ==
X-Google-Smtp-Source: AGHT+IHvVroj58g38Bhwial1jgUOWY2xT0+A3ebuimFp+WwwaSWOqv1ssW/wZoApYGVvPw9TTxNKsvTpG4A=
X-Received: from pjboe14.prod.google.com ([2002:a17:90b:394e:b0:2ef:8a7b:195c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d0a:b0:2f6:be57:49d2
 with SMTP id 98e67ed59e1d1-2febab7459bmr24737076a91.17.1741015350383; Mon, 03
 Mar 2025 07:22:30 -0800 (PST)
Date: Mon, 3 Mar 2025 07:22:28 -0800
In-Reply-To: <202502271500.28201544-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202502271500.28201544-lkp@intel.com>
Message-ID: <Z8XJNEIEBtBggM44@google.com>
Subject: Re: [linux-next:master] [KVM]  4cad9f8787: kvm-unit-tests.vmx_apic_passthrough_tpr_threshold_test.fail
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: Liam Ni <zhiguangni01@gmail.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 03, 2025, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "kvm-unit-tests.vmx_apic_passthrough_tpr_threshold_test.fail" on:
> 
> commit: 4cad9f87876a943d018ad73ec3919215fb756d2d ("KVM: x86: Wake vCPU for PIC interrupt injection iff a valid IRQ was found")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

...
 
> Test suite: vmx_apic_passthrough_tpr_threshold_test
> PASS: TPR was zero by guest
> FAIL: self-IPI fired

Known issue, (should be) fixed by commit 982caaa11504 ("KVM: nVMX: Process events
on nested VM-Exit if injectable IRQ or NMI is pending") in Paolo's and Linus' trees.

