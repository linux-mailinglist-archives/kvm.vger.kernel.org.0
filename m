Return-Path: <kvm+bounces-14915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDDD28A79E7
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CD89B221F2
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE23B17F6;
	Wed, 17 Apr 2024 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uNkXE46n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17974690
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 00:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713314081; cv=none; b=J3A7nb66vwcHO8zVJmuJG54x1hSnAJ2V0C5HyOpLNVl9iXodGKNqs9bxE/19oVVQOSRI7mD2GowXvEuTQKTjfJ2Q0Ru/RqcllGzK3bubDDLx8fZKA5SXYSNne0YkGGyXZC7Z9HwupjmimouX9mG2eDqQ0uMoRqUzIf1KD9JZ3LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713314081; c=relaxed/simple;
	bh=QcQ5CwIdJPBpAiEUOMxmQT8OLzK8+XohcwiHGYdlD08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EZSAfxCns0BCkEsnqxlbPZR8HxyyAs3V/PerXOpU9z2S+Ym2e4xAD2QhefLezO5plx2WEGxAgyifNkP8UEorL88C2ZS5biUyU5kLB7D++qEN5S/VbxCNWHOKRbvVAQOWUsrwk/wzyVLVK4K8hv/OaTiRNKrHJIlKPb0iwK3zyck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uNkXE46n; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so8281531276.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713314078; x=1713918878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKCPeGd9SYcDB4rlgTO3GZ6PUnpW3Lm5DsYKGNpWRYU=;
        b=uNkXE46nug6U7+Tx0/9dCbzeGNzW6wFtParN2EJbtRfLTzOqXruV8XY6sislZTeJ8g
         KqKVX0Q95gkgsemPW1eYJ2yzdd921yULnRohdUVx8z79E4eWs0F1K+i/jDetHNoxbopi
         G6GUqEed5H/Uiy/XGCEQ68ed/LFfHpjaPD5++8b5jdRkbB7J9/dKfjQH5lomY5fZgPUb
         RhNlknfsozKKTvVxd3L8gkPTbrtXSZ5sp7AfMG9ObIBLNieanHSK//mrSjbbyCFaSaFD
         aaPmag5Y2SK//ddPCCYRCWK7FZMS4uqnmX9bFggfyz8ElZF3yoCNJGi+Z6S03B5SSTiy
         /Sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713314078; x=1713918878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKCPeGd9SYcDB4rlgTO3GZ6PUnpW3Lm5DsYKGNpWRYU=;
        b=LZs2442dLxaUiyHCYdbh6tpNQzMIrN21cf73RlFStfYbLsmMP/2fBtdz6ui+pKZ7xQ
         LJamzsMtzun6QCWT/kZaxs/DYvK8yAvg3eg/VBAEMVKhtF7BALf0Mk8zHd1RIq7f2mPK
         M+8l2qTIiiScktp1UzkrFGuTruSYqNJcfowgkzppvdlKpfpEbrUW9dLOI07nO4j1uigy
         E2svtWxzTXSpVCpKcVh9PlX7TmeopUW2Z8eh08HMkZQSGsI2TbFpp4GaYVhcK7mDvaaL
         r4B5cXlVDhC4cqRhZBkhyh59W5OylzoRK6c+jHszTifKBq6vtjxUh1IEu19HWYiOhX6g
         fODg==
X-Forwarded-Encrypted: i=1; AJvYcCUo6lJKt3UXcMA7KBoSuBYG8P61sx0lii7Yn+g9M8JKLcu6HBRpem5TiRpg0+vjf9gBRYuYvwDLuFKSTCcQWB2bny9P
X-Gm-Message-State: AOJu0YxQM6nsvsfLEsceDahC/l0TiQMvlGNMCuB6jZxFy8XLg6/rvvpZ
	TNfcGMJVGnNIiZBoVYf24KgfPb2i42w7/71SQ8Q4nE8cksaKbUHKJ7waC+Csdl9uwfZ8vGoau0g
	L+g==
X-Google-Smtp-Source: AGHT+IGEjrPNgrfTQIQLaRwbEsHxol7QnWaKIZ3J4/4PrcaZUAePBGJtWepwBEycSYnoXivT9VAJAYBVrW8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1883:0:b0:dd9:312c:83c8 with SMTP id
 125-20020a251883000000b00dd9312c83c8mr1574843yby.10.1713314078597; Tue, 16
 Apr 2024 17:34:38 -0700 (PDT)
Date: Tue, 16 Apr 2024 17:34:36 -0700
In-Reply-To: <20240405223110.1609888-2-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com> <20240405223110.1609888-2-jacob.jun.pan@linux.intel.com>
Message-ID: <Zh8ZHPUlQk4niS7k@google.com>
Subject: Re: [PATCH v2 01/13] x86/irq: Move posted interrupt descriptor out of
 vmx code
From: Sean Christopherson <seanjc@google.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	Paul Luse <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Jens Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	maz@kernel.org, Robin Murphy <robin.murphy@arm.com>, jim.harris@samsung.com, 
	a.manzanares@samsung.com, Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com, 
	robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"

"KVM" in the scope would be nice.

On Fri, Apr 05, 2024, Jacob Pan wrote:
> To prepare native usage of posted interrupt, move PID declaration out of
> VMX code such that they can be shared.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/include/asm/posted_intr.h | 88 ++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/posted_intr.h     | 93 +-----------------------------
>  arch/x86/kvm/vmx/vmx.c             |  1 +
>  arch/x86/kvm/vmx/vmx.h             |  2 +-
>  4 files changed, 91 insertions(+), 93 deletions(-)
>  create mode 100644 arch/x86/include/asm/posted_intr.h

Acked-by: Sean Christopherson <seanjc@google.com>

