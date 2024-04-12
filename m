Return-Path: <kvm+bounces-14579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C06F8A3737
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2015428692B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CBF3F8E4;
	Fri, 12 Apr 2024 20:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yQMQuYjb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF4F2574D
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 20:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712954687; cv=none; b=Is3UuNqm9ME0HHjobVJexq++TBJx1cG0keAGP2GGowgQ4LK4XXRzapL7FfKmT0I2ZOtxhHr4TIUc4Cf4sGrH3pWFeFVc+Nrnbkvqy0Bu92g4JugD9kt+no0tvgf5DZWtimb7livBV9UN5LOP3DICWBEPx1Boc/tKupddYiSPniQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712954687; c=relaxed/simple;
	bh=4vp5qyEZGAMwuOagLnJKbRJSa5AiEMRLbDSwvkWArmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2kVj+qJjkeYEFO8A6a3hVERmor1Vq3AOJFBMNFKqfSvzmRMp5JLApcebHR+4N2qu2JHIv4BjTr4B7yiF/KdvxcsOe/hXJubWFkzpZizcex+jaVEqDdw0p3ifSOyX/GCbzkQRPaMNBNeG+Yv0aW2IQV3EwsWbQGbUxeJbRY9z8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yQMQuYjb; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso1229355b3a.0
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 13:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712954686; x=1713559486; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7z+VKNpPRufGEfzC58h5hLq5eFFz0DWRzzztXBo7m7o=;
        b=yQMQuYjbhFOlCQ8Gzdl9Xv5QCd08u8VB0kdTakIKfGcmTWPifX2DN5q+K6tDaZxH5n
         m0uANjkHLbhn93+7D+MspsP2TiTCGrWh2pgaVNYTymjZJ7oJlrywjfqzqFltxdVqmtfh
         spHaY02+TzoAG1rLUD/1xA9suQ5zVPpGahp9VJZJtU/l5QUI1o5+9kCdwblBN83wvfV9
         +jxcKb5OHNiycfISJkgopR8+IlK+6wBMXciW4G3ZDW9yIKMYq6pF8aijFTZdYtmHndsm
         gzF/VTejqERQC//+ZuY+46rEx90KZm0iyYcmg+cdGUZtdRwJ3JFFVuO1SrmWoAoH00Od
         00Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712954686; x=1713559486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7z+VKNpPRufGEfzC58h5hLq5eFFz0DWRzzztXBo7m7o=;
        b=iR6Kdwjx+JvPssUujP4sjOl6/GK7aBBNajZEzys24pMK2FRd1rz2W14NCy8Jgjb/6R
         AFG4i6zYeVsiEeSjyXpBtPUl8VTI3mnRqv/g11kIilnIe6HFK1P4oj9zRaeAhtBoGjS/
         IBB/OJX45CBAVFy8G20frM+arvD9jdW9aRl/lJHYPNF4dBhhnOSY05g9BdazZ1BPK9UH
         6jb3jJWFYEVCky/aZnQVl7DTgasttyXrQuNz63XfSoEGuSMUldHicHc5GP5XMjTWNW6T
         qXZj7HMgplNQNTHe+go+czT/LUfqg8QiWIE0iin7HhhEdTwGJHPZB7PK1lZXG7DFOKC4
         2xvw==
X-Forwarded-Encrypted: i=1; AJvYcCV8v7e24aPa/ceAXGMNG2RpYIvE0SqUnwXcRqXo8xAHfER0BRZ1u9PIl/PCVQ8hwYWgpW8Oz9qUWhdmwUH1NeCgKwyo
X-Gm-Message-State: AOJu0YxnOkDtrP1G9Axi+j0WCrp+O6TOHhqoZtZS6tLGaJJtFJ7jJmki
	i/FtCaYgSnFWzQwtLvL2JtaENH/J8BHDbnuouDlBHKGIGtezueWbeb+FOMvZig==
X-Google-Smtp-Source: AGHT+IFZFKdCRdPaL3Vb0XTMjnUQNtJVoruOo48GxoyfTAhTrJOnmmO+jVgRuAaY5z2jRsVdxr03aw==
X-Received: by 2002:a05:6a20:8428:b0:1a9:6c42:77f5 with SMTP id c40-20020a056a20842800b001a96c4277f5mr4669546pzd.59.1712954685790;
        Fri, 12 Apr 2024 13:44:45 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id lr31-20020a056a00739f00b006ecfe1c9630sm3368108pfb.92.2024.04.12.13.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 13:44:45 -0700 (PDT)
Date: Fri, 12 Apr 2024 13:44:41 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
Message-ID: <ZhmdOb7lAd3DM5Tq@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401232946.1837665-6-jthoughton@google.com>

On 2024-04-01 11:29 PM, James Houghton wrote:
> Only handle the TDP MMU case for now. In other cases, if a bitmap was
> not provided, fallback to the slowpath that takes mmu_lock, or, if a
> bitmap was provided, inform the caller that the bitmap is unreliable.

I think this patch will trigger a lockdep assert in

  kvm_tdp_mmu_age_gfn_range
    kvm_tdp_mmu_handle_gfn
      for_each_tdp_mmu_root
        __for_each_tdp_mmu_root
          kvm_lockdep_assert_mmu_lock_held

... because it walks tdp_mmu_roots without holding mmu_lock.

Yu's patch[1] added a lockless walk to the TDP MMU. We'd need something
similar here and also update the comment above tdp_mmu_roots describing
how tdp_mmu_roots can be read locklessly.

[1] https://lore.kernel.org/kvmarm/ZItX64Bbx5vdjo9M@google.com/

