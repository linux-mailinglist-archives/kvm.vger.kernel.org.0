Return-Path: <kvm+bounces-14321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94718A1F64
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84068285C4F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE831755A;
	Thu, 11 Apr 2024 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X4ADJCl3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8138D101DA
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712863383; cv=none; b=R4T54VYItFKw2sfPC4POJCgd+8dOBNZ2thwH7GFisZIQbscgB6hRHktuITJdChnrp3U9ptdibwaDLoiv4MuNsITF1z/ve6/jTtq+HkWTBItbzDbP1nb329ke052rh9RVOpfCTHuJRs3agpVbTdFC6Vm8HKhygcR2NMUQY7//lPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712863383; c=relaxed/simple;
	bh=fT4P0gGE+O7sWBDiZ8pLxxyQEVTnnen55DJKAfs9ezU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LP11IYM62RZIx+AQRt0S91Df9+/GgSs0FtepPh+/txc2ZHGI5XbWHC7bEyDdwfJG0W9BCxZWVBzzCQe5P4Ke38I1w8n3LA0l/rIT/3y4t87q04eiW6KiHEGD267dxmVK/qzz0GJcdox7RnMp+HkSaW6wTsY8lcdDU0FdGy/GSiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X4ADJCl3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-618409ab1acso1327447b3.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712863379; x=1713468179; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWyDifNB+g3/yqoVnm4if7NwdO+FurrszL4Rzn9n/PI=;
        b=X4ADJCl3aXslKO6WR1GzXOkIx0F8RxwRThktrxh9RgpI76pJwgZ7dMeC4vPKWdryr7
         NyvINpteUicAKPS/0EdyiSoTk/iB8XAl66qjAMj22rb35cwl1ahQf/ZGOBHaLswN21p+
         Coj8WrxEOUz/KyypUDOlXG7Ayc9Wcag0eMGY1AcQ8Ke1tzRypVB/LGTxm0ZZEElfXh3r
         QBj7b7rBXv9Kk2IV4CIp+33I+UQdShsd5G/5YLdTm6SXXzvxyktb2mminHz+xEGNOAGL
         jqDzOxpblthADLbthzW0AV7ziin4Wgo1DXDSoseD+Sai/PTPu9dpnIxu8xgqUIz/3AeF
         zVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712863379; x=1713468179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWyDifNB+g3/yqoVnm4if7NwdO+FurrszL4Rzn9n/PI=;
        b=m56WUtjW+ECXctE3S0Ks2jt8JAkwrZCWoPuYW76KVA26ItNMiCFUB1bGnRRdje/VtS
         kDAY/YAmGaXyQ/5+RaXbPTr0zzKs9hY3us84CBAAM2U3p6OsoxiuQObyvBvxr2j9WWzS
         Xixp0G+bHxgoUz79A4Gv7UUPyu/sUvuY6VDeXCnIRmUyRSz+0IPNoDqekh+6c6fnIkw8
         KJcOrcyLuJGAtO0bSRDwW7d7cX/7d8J5LFv8uh54ae1mzmGqlVjOIqW9cXV+BMIRwYJA
         xDajMrUhB6YNJ7emNtpEbZHkoKb6gCBuzOlwDnoXnp1xIGGbxk88NT+mGRSBZaRf140j
         s+cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV6Ock+mNECB6yaT5TlVECRq4N8TJfmEwV3B+mOhshaZTtFr5/Gv3Rx+gYq4Eza1hOI4VaY9GuXSPhUpytAH2/o85r
X-Gm-Message-State: AOJu0YwKbhZTQfZEdo/u1MG/tNCS9FiQkZEz+ydzNJO8HaoGlt71cgHc
	h0f9CEImT4SKiW909t7MsWpf/ma4AhY2AhLm9pvozY3MNR6v84wKqNm/oqF94RfplRMAYKg/RIL
	FaA==
X-Google-Smtp-Source: AGHT+IEkfHzR+4m+Th6V2ts/oqUxiy0aOaoToSSBUi9LCjdVmQdDERNlhn8Fq9lXwBTSzwWtpL0hLyOgrA4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6cc9:0:b0:615:2597:7246 with SMTP id
 h192-20020a816cc9000000b0061525977246mr83113ywc.6.1712863379573; Thu, 11 Apr
 2024 12:22:59 -0700 (PDT)
Date: Thu, 11 Apr 2024 12:22:58 -0700
In-Reply-To: <20240126085444.324918-9-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-9-xiong.y.zhang@linux.intel.com>
Message-ID: <Zhg4kkDzmdUiCYg8@google.com>
Subject: Re: [RFC PATCH 08/41] KVM: x86/pmu: Add get virtual LVTPC_MASK bit function
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@intel.com>
> 
> On PMU passthrough mode, guest virtual LVTPC_MASK bit must be reflected
> onto HW, especially when guest clear it, the HW bit should be cleared also.
> Otherwise processor can't generate PMI until the HW mask bit is cleared.
> 
> This commit add a function to get virtual LVTPC_MASK bit, so that

No "This commit", "This patch", or any other variation.  Please read through:

  Documentation/process/maintainer-tip.rst 
  Documentation/process/maintainer-kvm-x86.rst

> it can be set onto HW later.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>  arch/x86/kvm/lapic.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index e30641d5ac90..dafae44325d1 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -277,4 +277,10 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
>  {
>  	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
>  }
> +
> +static inline bool kvm_lapic_get_lvtpc_mask(struct kvm_vcpu *vcpu)
> +{
> +	return lapic_in_kernel(vcpu) &&
> +	       (kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC) & APIC_LVT_MASKED);
> +}

As suggested in the previous patch, I'm pretty sure we can safely omit this
helper.

>  #endif
> -- 
> 2.34.1
> 

