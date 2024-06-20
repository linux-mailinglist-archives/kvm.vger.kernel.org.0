Return-Path: <kvm+bounces-20116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 204BE910B44
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D01DC2883A1
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F9E1B14E7;
	Thu, 20 Jun 2024 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1p0gYgTO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788FE1B1422
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718899650; cv=none; b=Jd5+u/iNxkbdmYCDzCUIeExs9vNvBy1limo2KBtPD4VSzGVjJxOih/1y2QoK9Svs1cYju/wD2+UTdLIfnzyrMKD3U69SzfvhkU6Z+h5sIp5bdTp/dB7mGF5np8ipErsOJHdZxfEp1Cve8tMWtl6NussxdrOPfTKsNB9iS6KSxNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718899650; c=relaxed/simple;
	bh=4++AFWBTLhEgMK5+HoqIjWqYXjyf7UksZRedIh8PzcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCu36kaII3qLwPSOZdFzfLD57WM/p39wRMQJSCYoB7BKVJ+9zEhZRHw0vbs7CoD31PoXsbxK6sHHMrjmU4U9ejCzmAfMO/tX+2T0HiAAmSY5MnJFcdJRivwF2C9km5xP7vHy3YD4iJYI8RSoCyNJ8GYJRkz/zSO8MZkPtTtv8PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1p0gYgTO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c7c3069f37so1204127a91.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 09:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718899649; x=1719504449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4++AFWBTLhEgMK5+HoqIjWqYXjyf7UksZRedIh8PzcM=;
        b=1p0gYgTO3lav3l8Z7O39Y0sQqdWQTAXGh8h+BsLGN1dIBoUXyFknqKeEJMvrvzGNtY
         aPm36Y9T6XuQUzao70xqtqFa4AxwNbGfUOxIJbt9kxd0Ru7N5x6fk9TDnPE6mbdNLYmM
         AMfgkR4ki+pQ7r2x+u+BCrorcE1kqeP9YPrDi0EodR6KvfO28GaRmLB19emFq5ksPGX8
         sZhyFT9kZ4QcnM7IQ+rJ+WClDy3oJONmJq73Bi569JYSj77KCA29SHoYRbwG6Ejfia5S
         AlhVrtwK1SMlzSQmlO8tSMp8KPvajIMublH2SXHQmAPxmobLbH/YMHASDexL/ca8R6HR
         ST8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718899649; x=1719504449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4++AFWBTLhEgMK5+HoqIjWqYXjyf7UksZRedIh8PzcM=;
        b=qtr60j/eYo9HnOn3b242jXVmFeH46bjUqgl2GDqK5HMHFoLRn49rZqZ+Jz88UyrGA6
         E+maIDZNzMhqDnZewI0CHf5pOQ7Rt3yg6e0U9W2O/LtQ6WaAxjJBiZvkT8oDWUyYqeut
         j0eDk22EczjDQukPf034qsgxprTBVS1xmZFVQiqLku6/7IeNNg5yoO66sx5GkZbprixl
         ztNFXt/7NC3CmjYOT7zt5eBeZ+n3+OCW1of0tpDv/HmX+Q4eWEdJuXWMp3WGADCDpp3K
         0mPsUqZpK5V4DFg6RVPSfC+KbrUWrbGp3HarrFpI1TXeA5nl5WiQxg50loBL1EcuqEDF
         1DwA==
X-Forwarded-Encrypted: i=1; AJvYcCUziyyohgzONxoBZm42JmaCBgofJhAphjSHTmwWHvjAE6JD7hBGGo48eMs+NWYnBlte46vv0lW/vUxc5zgoqhTidWhm
X-Gm-Message-State: AOJu0YxO0Wjw2SkKIx+YS15eQcIXTVgLuLaah8tcLBWbsdkcfzNp76XH
	0fZ2ORXY+mZrpao/kbVF4dNnBkh4Rv5hCPjBn8/Pc4j5p+d5th7TMK9RuLr6klxCMZqFWC7Hk1F
	w7A==
X-Google-Smtp-Source: AGHT+IGZjZFiRlw7O6PqskT9mtZGQXA4gu55zTf3jYNykdeO/HXMtMxOpQ0oZSgNwiH2VyC1b8F1sCdYgeE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1150:b0:2c2:ebde:ca6a with SMTP id
 98e67ed59e1d1-2c7b5db32demr14855a91.9.1718899648688; Thu, 20 Jun 2024
 09:07:28 -0700 (PDT)
Date: Thu, 20 Jun 2024 09:07:27 -0700
In-Reply-To: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
Message-ID: <ZnRTv-dswVUr0hzZ@google.com>
Subject: Re: [PATCH 0/2] KVM vPMU code refine
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 20, 2024, Dapeng Mi wrote:
> This small patchset refines KVM vPMU code and relevant selftests.
> Patch 1/2 defines new macro KVM_PMC_MAX_GENERIC to avoid the Intel
> specific macro KVM_INTEL_PMC_MAX_GENERIC to be used in vPMU x86 common
> code. Patch 2/2 reduces the verbosity of "Random seed" messages to avoid
> the hugh number of messages to flood the regular output of selftests.

In the future, please post these as separate patches, they are completely unrelated.

