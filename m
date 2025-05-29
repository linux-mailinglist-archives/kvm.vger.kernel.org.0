Return-Path: <kvm+bounces-47983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05279AC7FCE
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 16:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 500F93A7409
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 14:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0E722AE76;
	Thu, 29 May 2025 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hRvjffPp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF25F219E93
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748529562; cv=none; b=CT4h5wLC+VR+zCRlTxGm2aoP2EVDek4mZgnP5nvXOeKD8t+hQ+VnRKUc70uZwHK3DnjGm6OCoszk2ZOk25joP6YbU8KRHayVmN++RkBehOdZ1nIbFK62XFcUT6Apmw2jgy9zuieRJNW1EIN5pMF2+FSLcfyW5L8+zK05PV6gncE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748529562; c=relaxed/simple;
	bh=AV3ES5YCbjV4DWcsEdH3BBLXaARTJL41ZMtZqz9w4rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T19ZXCOy0auIyzYSbG7QbIwjMCI/0pofXDWDGPwGqA74hzF/LYBtQdC3SLk5xZMyHcANXdRYi/6Ai3QLORLxTPC3owgSCi7oPdKJirrx5s4EFb8z1cyx6HAU7aCjWIFPn+BmXgnEvVscobeEx/dFEyLuPfo28buEoM4M/1KLou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hRvjffPp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so846717a91.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 07:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748529559; x=1749134359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xNU4esLQTJeSc9s6NX0+57EwpHiPvJrGTCr/LKvOY+E=;
        b=hRvjffPp7cX3NTKCIK03c0yQL4Ap3t8Mp22HJT3clV9U2KmRZtaQvC72eaFBPsdrgZ
         AsEi97dRVKYaeYX53tLZ4vI2cc8ClsP773bri/dAYbsCNuBLQRa5ToUpC5NSocbMkQmv
         OQMzLjiFFCkDb1MqkzHjFqRW2zXGpjCTotxAD17cm16nelh42IjcCZnU97NA3T8MDLwE
         nkpiaInPIEl53HPTYqNDBr2S9nsJFdZruFNRV1dwKaUNOs49trrSsWToZr4yy+dzW0Fv
         20vrqQnQ2rHTUgmZOU/Y/txpgc0oU0qSWvaUHARthgoJ04cq6agFEjdy8fobl/BaWy/d
         bMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748529559; x=1749134359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNU4esLQTJeSc9s6NX0+57EwpHiPvJrGTCr/LKvOY+E=;
        b=Hl9GdP4QtM3XMIUmpc+V1LNB6HgFbQubExE9LuAq5n2VUc3NvP50kzI1YfwlpYI5lS
         x1del9PUZjFliV53jrGplUJSgjb3SybnRPy0XFQob+Ru+s+QynofFs6Nrw0mCp3QnFk/
         fQxnk/HjrAUxsnMRpF2mtulLajUpTjnhKEHIvYHbFg7qKgYDrL1cjerLOS+I1WY2ybjm
         4O3m33ytEplQqftdsMtTtbWsN1eU26rzxeqWV31COkmjutD2xPER7zrce/7aiK+Mjg9Q
         cMfa92KUfW/+mfLwOnhs4H3H8o2iCsYkE/dafMP2khfDIALHlBUt8WPbRqW+xCw9eOWE
         2FXw==
X-Forwarded-Encrypted: i=1; AJvYcCXX/ggg155XOnwUIRgeJtLoLQdq2eo62nfreSnSYt6p8c7+e/ZpOKHHKnsfAhhE8eGTjD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBkxLt64GNIw78p/2wbDGnFqqCQtaCYMaZcU+j9eHpb4oSjXS1
	pWJdAYiRUgClm8RnpJnKJghUPgZ0+8pUvUdqxzTPqfwX5A2HCcnO5YxdqtVNPM/thpK4dzW94UQ
	SBreG8A==
X-Google-Smtp-Source: AGHT+IEPLUlO0bEM312C1lkvzSJg3YO38HianJoHmgjrLk4H4zuj1AahrI8DhoIW4Ey8GMjYyXU3U8s+f5o=
X-Received: from pjbsz13.prod.google.com ([2002:a17:90b:2d4d:b0:30e:7d59:f3a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d02:b0:312:25dd:1c86
 with SMTP id 98e67ed59e1d1-31225dd1debmr2792026a91.18.1748529558530; Thu, 29
 May 2025 07:39:18 -0700 (PDT)
Date: Thu, 29 May 2025 07:39:16 -0700
In-Reply-To: <100ec82b37b7ce523a12b81623613b71e72c8ba0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com> <20250519232808.2745331-5-seanjc@google.com>
 <100ec82b37b7ce523a12b81623613b71e72c8ba0.camel@intel.com>
Message-ID: <aDhxlH3yT9XzFyDT@google.com>
Subject: Re: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 29, 2025, Kai Huang wrote:
> On Mon, 2025-05-19 at 16:27 -0700, Sean Christopherson wrote:
> > Drop the superfluous kvm_hv_set_sint() and instead wire up ->set() directly
> > to its final destination.
> 
> kvm_hv_set_sint() is still there after this patch.  Did you mean "superfluous
> kvm_hv_synic_set_irq()"? :-)

Ugh, yeah, bad changelog.  Maybe this?

  Rename kvm_hv_synic_set_irq() to kvm_hv_set_sint() and drop the previous
  incarnation of kvm_hv_set_sint() provided by irq_comm.c, which is just a
  wrapper to the hyperv.c code.

That said, given that the tracepoint is trace_kvm_hv_synic_set_irq(), and that
the IOAPIC and PIC versions are kvm_ioapic_set_irq() and kvm_pic_set_irq()
respectively, I'm leaning towards a straight drop of kvm_hv_set_sint(), i.e. keep
kvm_hv_synic_set_irq().

