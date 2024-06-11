Return-Path: <kvm+bounces-19327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D29903D8A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A44A228971F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 13:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C0E17D89E;
	Tue, 11 Jun 2024 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="30mXD5ay"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2160517D34F
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112893; cv=none; b=V1rfMo5GQy5+l948+OfOsj6GahEqxhD2nEGOUX+e7tp0+PqaJlckh5JfIh89YYWxIbuyZY2MHmaAEGNH41NGIY4nb0wvm5FePoL5YbGoV0JEwXmN2zxJ9Mc+25b/05xlybvMNgxluxPZ6/5yc8SBNH0Xxi93ybpYAkX0+st7XKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112893; c=relaxed/simple;
	bh=l7mjqSmEs8KhQWIWbdNJbqtVKlyA+iS85GZKXGTRa3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FvyXCGXrIDIECfWYCDE9JPENjD7Z57HYaDkXMMy2s0mH3Vwxb0KOsaAPLVAqrhUvRvBrdF57z0i9VGCl8oiBpSmrx13P1jo1SatmVYcatNo9nSYGgUKMiY3MWky6X7JWoLi5dsSvmM6LthaA5fFeRBVqKH2E2BqZYhN1qiRRKtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=30mXD5ay; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfb03395462so1932418276.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 06:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718112891; x=1718717691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7wy0zuc3gt/tdjV2dQffmliBj9N+JZBxo0R2VFdxpc8=;
        b=30mXD5ayNAfLDlGoZCay7YYIo2pTNamJTnQivT9eMc23upmJxhmNYhWp3jwBSxMkX+
         3D6naOmeqG8CQQYUEhNKkjVvBt3tZfJEZ9Oz2sbNIAo1wa+ToOJhfMQPbGs5HF/PM90w
         6flGRMFDEE7Io8RSeEGGkFzs3AHKCjoIk6bCXpRjSzNfV+0KaAm163rYPZUZNMW/Gs4r
         c6p2cJ43/6B5XsGDzgfGxk/6H23Qrule0L/VFgbEb0J5PpX6XeuOlbY3k0iUxMe0CcXb
         nc2Q/VubIn541iwTfkbiSuxNWoOx1u5wxlD//OqU0xO8TG82KhavKr5Q9W1ggmiwdF7l
         pc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718112891; x=1718717691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7wy0zuc3gt/tdjV2dQffmliBj9N+JZBxo0R2VFdxpc8=;
        b=Esj6c1nbf28Usfpm1UV/Lmp5TFQs5sfoRHn1KVPp0eQ9gmEgLXAFmSECrgX2oonskR
         GPpr7vOnR8oCBereRK6/F0oT+4ublE9z1OXiHXuBRn6YHwbOQZYvRjcsvcbiA/iMNv9J
         +spG8uQWzbgn2jddWHCPPLbZm2iKeudq/FrDW0V+ofQA24ao2OGzUetygQqFw3hrnHn5
         3R67k3oxL/2YdTuZ90RIz+LNcmrDbwbw2UQhuf0x3+OLYRYpd/Kah45uzf4p4m4MH93D
         dhfu7o771wqRwQMS7B4aKQOrkeCsfmDQptecOfAdhU9EM7qnH21HqrYAUtqHQggri0x4
         aPVA==
X-Gm-Message-State: AOJu0YztUVTo/7zWtUS48HvCpRNX7iynCaLu2QKpmVpTa/SE4DqXV89x
	qHryZV0pyS38K55jRfYS0xCnoE1NW9EPKE9xlibIY0vOzOMYs3C7E4BaX4OFH9V9fawHRxbWBLu
	kdw==
X-Google-Smtp-Source: AGHT+IFeTULo2NcQChet/qgGuvsLVEcE6NKGgGhnmpF5zHy2aoM5MQtiIYrb/wrtmYy59sR3RrTL2QaYHH8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b87:b0:df7:8f43:f8a3 with SMTP id
 3f1490d57ef6-dfaf63f571amr3679544276.0.1718112891177; Tue, 11 Jun 2024
 06:34:51 -0700 (PDT)
Date: Tue, 11 Jun 2024 06:34:49 -0700
In-Reply-To: <ZmgrkMLuComwPl1X@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240410143446.797262-1-chao.gao@intel.com> <20240410143446.797262-10-chao.gao@intel.com>
 <ZmepkZfLIvj_st5W@google.com> <ZmgrkMLuComwPl1X@chao-email>
Message-ID: <ZmhSeZpyoYxACs-n@google.com>
Subject: Re: [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com, 
	Zhang Chen <chen.zhang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 11, 2024, Chao Gao wrote:
> >I continue find all of this unpalatable.  The guest tells KVM what software
> >mitigations the guest is using, and then KVM is supposed to translate that into
> >some hardware functionality?  And merge that with userspace's own overrides?
> 
> Yes. It is ugly. I will drop all Intel-defined stuff from KVM. Actually, I
> wanted to punt to userspace ...
> 
> >
> >Blech.
> >
> >With KVM_CAP_FORCE_SPEC_CTRL, I don't see any reason for KVM to support the
> >Intel-defined virtual MSRs.  If the userspace VMM wants to play nice with the
> >Intel-defined stuff, then userspace can advertise the MSRs and use an MSR filter
> >to intercept and "emulate" the MSRs.  They should be set-and-forget MSRs, so
> >there's no need for KVM to handle them for performance reasons.
> 
> ... I had this idea of implementing policy-related stuff in userspace, and I wrote
> in the cover-letter:
> 
> 	"""
> 	1. the KVM<->userspace ABI defined in patch 1
> 
> 	I am wondering if we can allow the userspace to configure the mask
> 	and the shadow value during guest's lifetime and do it on a vCPU basis.
> 	this way, in conjunction with "virtual MSRs" or any other interfaces,
> 	the usespace can adjust hardware mitigations applied to the guest during
> 	guest's lifetime e.g., for the best performance.
> 	"""

Gah, sorry, I speed read the cover letter and didn't take the time to process that.

> As said, this requires some tweaks to KVM_CAP_FORCE_SPEC_CTRL, such as making
> the mask and shadow values adjustable and applicable on a per-vCPU basis. The
> tweaks are not necessarily for Intel-defined virtual MSRs; if there were other
> preferable interfaces, they could also benefit from these changes.
> 
> Any objections to these tweaks to KVM_CAP_FORCE_SPEC_CTRL?

Why does KVM_CAP_FORCE_SPEC_CTRL need to be per-vCPU?  Won't the CPU bugs and
mitigations be system-wide / VM-wide?

