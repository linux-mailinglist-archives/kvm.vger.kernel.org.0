Return-Path: <kvm+bounces-18920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4150C8FD1CF
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBFB028BB0C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42292535C4;
	Wed,  5 Jun 2024 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i7mV3pBM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1827519D891
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717601890; cv=none; b=rfG3qrP4sypUgUVWR/jDgIdlIvQiHaMqP7BydpHt7tF5PwLPxVc/50yZ3AWWtA7I9VbPaZ7yrRL3rjAt51iorndDK2BK0ax4CWAR9Itp8+NSjA/gSj5J2nDLL/1GBVJIZZYVbDVXsE3bDD2u0zNoUuFHcZ8VH4GDqibKFCITTPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717601890; c=relaxed/simple;
	bh=bpFNmEe++Fm6Jhn5LqQS44pORnnsMVjcXJi0YMeG9xI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eU2Mkyj/5t8EEZ1mxIxK5ilkomLib0ZM+XWZzdzedRjXoaVYw8z8pn6jvBwkVNDj/cD9RG6Q9wipIgdL99zUR/X1xpx6hZTb9s5lIWXj+TUyi+rY0MZ0TjJ3UIC3CuGQQR5G2up7tRkzwV4OW/kVFz4lhvGT+k+j1wxr/haCSkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i7mV3pBM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a088faef7so13700387b3.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 08:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717601888; x=1718206688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kIwFDSYK6IZoKm19H7uH4SBYfg7R2PGBVGLBIDSlog=;
        b=i7mV3pBMEar5mH8xrDKUgrXbxQvALUJkZUo79eSMLMqN79Y4rVJwAbrYAuKHYa//T/
         Cv61I2YB7ou0dAgzKWVBsxaYX6qe84R9X4dNk6bwo8C8vdMO3FQy28JhaKQivJtweIsR
         6Af1FRZql7xQ+YOCTQ+NZk3sS9fvQzhEvUgtN9g2qyccE7tiKF7pCGkGEQBGHNqS41x5
         AZ1hl4Ric+S8oEk0DbLkpwYVGMmfX/atirjqU9cdNIF4ihqW6klDCyvVFfc+etFL8Pur
         HHL0oVa7e6HSZKcyv45X//ZqcFKaNIby4ku8mN7SNZSe/FgosbQsCRQURDKGMbufMkAx
         FCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717601888; x=1718206688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kIwFDSYK6IZoKm19H7uH4SBYfg7R2PGBVGLBIDSlog=;
        b=Uf54Ntwl38+RViRDeTyGeI6ejSjv0yqxIoY7PWK+kVLJsWs1jvjxba95+qUif0bfUJ
         ZVpvf0a/S9T5k0Q/aVCFrF5+H8Lyk3A6aMeJPoho1xbyN9HC95Acy5FORC3RiYC8Ux/i
         Y1B2E6LW3Rn/QonXwunPJcXb3AR/KBxhZzMmBj82+xrBCYSnLxN2Zj/swUwplhaVQBNq
         rGhfwmek+NAJvunZi0b87sQBaKrtUrTEsU2RgZeNzzVVQJsAEVuvr14TvoeYbzRvglZZ
         IFCePPV6A+xM1RbfN8pcQ2bGSPAQpCP2eiYCVnH0z0wwAEXR7ieLc87+zebFK1wVt54D
         ZYNA==
X-Forwarded-Encrypted: i=1; AJvYcCVrrLT8g058CeuBpP6Z+l/ToGmcHEt12J7PoA3DNYclOlQ+6wyFOi6roaQBL5DszLgjjx5V8PMTF5o7fKiUXtve9gah
X-Gm-Message-State: AOJu0YxvCfAo/xv0Y7I2CDinehFL1c+rfMXaPWAHerWVgQqkOQ4c91xp
	3s8jpW/xStBWd9lkFRqVmHScPtJMAH8xjLdWv6FU65Ols2sI9bw+5SB7KEOp61mwHUMkBM0Mowf
	k/g==
X-Google-Smtp-Source: AGHT+IFVGwW9/cpLUjRGOTBt7abgUxXeVyV3Hw/4O0+DzAsmAXs3qbFgTiclGA8Y/LqWnzwtdCDqyCrlowg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b02:b0:de5:9ecc:46b6 with SMTP id
 3f1490d57ef6-dfadeba2a13mr1790276.6.1717601888104; Wed, 05 Jun 2024 08:38:08
 -0700 (PDT)
Date: Wed, 5 Jun 2024 08:38:06 -0700
In-Reply-To: <81d9b683-450a-4fb6-9d95-108c77d9b3cb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com> <20240520175925.1217334-9-seanjc@google.com>
 <81d9b683-450a-4fb6-9d95-108c77d9b3cb@intel.com>
Message-ID: <ZmCGXhnlwQjqbfab@google.com>
Subject: Re: [PATCH v7 08/10] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, Xiaoyao Li wrote:
> On 5/21/2024 1:59 AM, Sean Christopherson wrote:
> > +#define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
> 
> Same as Patch 4. It is newly added but will be used by following patch 10.
> 
> Call out it in change log or move it to patch 10.

This one actually is mentioned, though it's not super obvious.

    Opportunistically use BIT_ULL() instead of open coding hex values, add
    defines for feature bits that are architecturally defined, and move the
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    defines down in the file so that they are colocated with the helpers for
    getting fields from VMX_MISC.

