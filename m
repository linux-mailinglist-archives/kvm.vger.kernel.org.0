Return-Path: <kvm+bounces-14316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0E98A1F5B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59262B2669C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC44205E3A;
	Thu, 11 Apr 2024 19:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iH8P5mzw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08F4610E
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712862710; cv=none; b=NriE8JW89aHvN/diLoQ/Qmq57ElNn+xd7e1aIVwnzcDfbto10+dPrnpIiw/4meVxskXfuEyEuuQmgQpsLSXXKdhlFVMgJDMPaNKFN29Mnvul9zvnNqRmIn6q82JN1aOalYU5eS4MIBoFlYsUgW1eVIQTb86Ad1HYG3vesHJHSfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712862710; c=relaxed/simple;
	bh=g+B2Yue453oyyTRmIbN8HCkgKAia+fLcaH8fv6MIjmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YtQfySHcMwJ3RTFvPt66e6eP2DGJ0C32+MlGqo8JJ9z4AsBOOprpPu9MtMQ/o4pPxYVviaGS60Gnocicjo0cSAqn+ONP7ojVPEK3xbH2e0vxq2B2TgVcwoMxbB7DxRnRxUbbyNitvZKTibahg7LcIiADy/bKOVHh40lomUiJ6uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iH8P5mzw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dce775fa8adso253701276.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712862708; x=1713467508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HU0SImpdTV3E9YzuzzuR9Yv9Tp6GEC0Mdscn4mq5lRo=;
        b=iH8P5mzwtWU7CXybeByAYZKdVbHDvBdEuX3QDf6WKumvcJUqqcipMLoEm22ixoUkQG
         AbEPM1oXhk/CyEZUFJalnOIh65/AngmRgKRF5OYZzS+gzjH0vwMv55zCHKMdALWjYFCx
         mWFbOLRVjygpszMaYCUljiRplf8490+jPu+PJurU1PD63Q1nwJGXtkQLUmt6u0DsRnH6
         kZoJXs/gXgx7SmRg1YqXHXQ9inC9NAXz3OtTkqNPAc0c5vM6Z7ixdCaZ06VPtJmP6IU/
         QtgfxRvg4mqkY9/YOmKML+jkzgHyCpCIBoJoGbXwMY6hMkwPx9k69VvosbjZS+zMjIjO
         65uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712862708; x=1713467508;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HU0SImpdTV3E9YzuzzuR9Yv9Tp6GEC0Mdscn4mq5lRo=;
        b=Sa6+bfwijDjCR1CzX4qys8aqbHAN8UWFeyapxZjQaPpsz2/N/Ns3XeYj5CPFxnvBEg
         oWH/ftLtmXcd2p4KH873OzRWcxW2uFglfbmF0hV8r7BndCvILpaedSG5oLNzh/IlEU50
         D/56mfhxl2Bbgo2HwRajRO/SV1TKyxi1xMhoVkBfK+kErGvWxVvrTdwgOpLfUM9Xck1i
         LoA2FspZDtMWvgY7bEkuIhKPP5KP3Lzw7CmiKXYcMTO/gb/3xW/0zQn3ML6dL731ApyM
         2kG2g7ltvlfbSsNs3Hzz5+mEHBxKlH1eetfCwrWErEBn1Usyug+yxSI0ZgCYE5egxcB9
         obzw==
X-Forwarded-Encrypted: i=1; AJvYcCUQ/03n8lcK7XgRdvpKWX/tquVi6+fDBrN478UBD9NvvhORQkKN4+cYsbf5q8WOLtdLMBZmjtDJhuKJdPoxiyQR23Vl
X-Gm-Message-State: AOJu0Yz8yF4uEesX55/rqRieQKxH0zHCZLewdx8Dg1vXo+RVgOPQW82N
	bOcD5s+9dUbmltabFuzc0V2ZPXoYO+ljbpJIut8czFQ7qlTtcqLQ4tqRAyIENEvplmzeqEE3mA/
	25w==
X-Google-Smtp-Source: AGHT+IGUERVVXrdw0R2szQy8yRBADN5lXfcBWcVPND8hHHaQmm3bfBGTVjuyRSNt0gi4Zblz/sQNqLq7Zjw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1826:b0:dc9:5ef8:2b2d with SMTP id
 cf38-20020a056902182600b00dc95ef82b2dmr117334ybb.4.1712862707891; Thu, 11 Apr
 2024 12:11:47 -0700 (PDT)
Date: Thu, 11 Apr 2024 12:11:46 -0700
In-Reply-To: <bd8e7f8b-532f-4372-a3fd-69893e359b42@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240411163130.1809713-1-seanjc@google.com> <bd8e7f8b-532f-4372-a3fd-69893e359b42@redhat.com>
Message-ID: <Zhg18kSHFeWN1xJH@google.com>
Subject: Re: [RFC PATCH] KVM: x86: Advertise PCID based on hardware support
 (with an asterisk)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Andrew Cooper <andrew.cooper3@citrix.com>, Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 11, 2024, Paolo Bonzini wrote:
> On 4/11/24 18:31, Sean Christopherson wrote:
> > Force set a synthetic feature, GUEST_PCID, if PCID can be safely used in
> > virtual machines, even if the kernel itself disables PCID support, and
> > advertise PCID support in KVM if GUEST_PCID is set.
> > 
> > When running on a CPU that is affected by Intel's "Global INVLPG" erratum,
> > which does NOT affect VMX non-root mode, it is safe to virtualize PCID for
> > KVM guests, even though it is not safe for the kernel itself to enable PCID.
> > Ditto for if the kernel disables PCID because CR4.PGE isn't supported.
> 
> But the guest would not use it if the f/m/s matches, right?

Maybe?  There's another in-flight patch for dealing with the guest side of
things.

https://lore.kernel.org/all/20240411144322.14585-2-xry111@xry111.site

> If the advantage is basically not splitting the migration pool, is that a
> concern for the affected Alder Lake/Gracemont/Raptor Lake processors?

I have put _zero_ thought into what value this actually adds (another reason I
tagged it RFC).  This was purely a "it's easy, so why not".

