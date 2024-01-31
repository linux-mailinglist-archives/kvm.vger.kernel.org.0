Return-Path: <kvm+bounces-7524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAEF8432FA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C28D28540C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899F5672;
	Wed, 31 Jan 2024 01:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DgAniXR1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B6117554
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706665688; cv=none; b=XWFfxdG+EW4RLgG4CTsng01KDGSDMqoOEF+NelrpcpRc4xhFrGqhMDG3or0kNh86rzGSJaybigOSyvcUbW46ooH0aC0pWUlq5lXWQGAKYMoCIVvL5+TmoE+zMlALLeC+EivnLAcvOzQ1Uglhm90+oqaV6fqPxsI/qvrM68bHelI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706665688; c=relaxed/simple;
	bh=z18/1NG1zLW5yoDGt3zYqzrbxZEW6XZZsTCTId9IDzI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u2yP2gVpVhlC8M3P7Bmd1y6ge8rfHC0PIm9nBv+tuYo/SHgNc6bfVpUnt5//AxygD9QQaS+fmpQ7G5c3rR13pgr9zirvZiR98r/MBjw1yBiU5BEOm27+kSbEQlJAULDCPxEfq2Rknu29ZxiZAKk92srVxPXX+pqhzuLAGuPS1gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DgAniXR1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-295beab55daso968006a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706665686; x=1707270486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JdG1KVU/njo7PApRXford/HnaGUTjmthKcJoPmpTjfU=;
        b=DgAniXR1jVedgB6qKJXSofURIl06lw5e5OZRvVpd9LmENzgTWAp7O5wpdsl9hoEA2M
         TgL/iYk6H1zUHf0z0HYpZqfzkQ7qTQXaIRdjhyLnbZkd8bqLI4fNpOj3h6gBgkV/pbpp
         d2eeK8+DKK19JY6wHVIbXzk7pz8ycIqnCUklsrkhsSOvDfujImbNDG4xwSZzIKDj/+By
         /bIfLlc7/NvH1Y667azXl37sthpMaj9SUhdNJ+9hAJaB8Ld8AGkJqYoT3TogPr6OCQ/G
         glBy3bFmSzGzondiheCgKKl3zoD/O9qBeMcmcRliQYWZbsIIfpDGBe3B1CnJqj81kVC/
         qPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706665686; x=1707270486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JdG1KVU/njo7PApRXford/HnaGUTjmthKcJoPmpTjfU=;
        b=M20JBfw6p2hcn0sPURPKIkp9PEK28sRERrYJM1IjaoCEr++DxJGfcLmx5lItbsRrMU
         yFlpNcDfhg0Lgif5mzbVuAaTQv7oJ+P5fjKljSTGD4VJFbBcRKkGQljkDp5eDvV8BbbO
         EAj/XdbleNWPdLHVb+5mSQ8J9Tdj/E43M8x2sohlmdwLaBhHWn2w1K0NBQtT0+URjPHr
         VZPnyuHkef61rlW1+ahCJF1S+rLOioJDzYIp812D0e32AWWvGHdB+DmpSKH94XSfcmDR
         FZLWKuIcGTANA0VXSs8p4XdlUFxK1a393Z0wz+t+52FyiJSYl2rleABIux0zPkDs4LJQ
         mJxA==
X-Gm-Message-State: AOJu0YzvNTRVnhIkQFeJcbNFOr0VFbdDOie8cy/oeZKTEX9f/P8vvr4b
	vaK26cXcMOtUg/2byIPQaNrf9hje4BuJqHpZk6vaGM8r0PxvawMa+oCG7IYg6J6qbkHHV4rTuRL
	u3g==
X-Google-Smtp-Source: AGHT+IHkPAPzDQDil9cIn2c+oGBBDcXjd/kr8cTjB0uidyn4CQbS7fkF9Zjbea81BRd2hGwSuMMpPlMakCU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e550:b0:290:fd51:d7be with SMTP id
 ei16-20020a17090ae55000b00290fd51d7bemr1533pjb.5.1706665686046; Tue, 30 Jan
 2024 17:48:06 -0800 (PST)
Date: Tue, 30 Jan 2024 17:48:04 -0800
In-Reply-To: <20240126234237.547278-4-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com> <20240126234237.547278-4-jacob.jun.pan@linux.intel.com>
Message-ID: <Zbmm1DZPmbFm8gan@google.com>
Subject: Re: [PATCH 03/15] x86/irq: Use bitfields exclusively in posted
 interrupt descriptor
From: Sean Christopherson <seanjc@google.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	Paul Luse <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Jens Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	maz@kernel.org, Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Jacob Pan wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Mixture of bitfields and types is weird and really not intuitive, remove
> types and use bitfields exclusively.

I agree it's weird, and maybe not immediately intuitive, but that doesn't mean
there's no a good reason for the code being the way it is, i.e. "it's weird" isn't
sufficient justification for touching this type of code.

Bitfields almost always generate inferior code when accessing a subset of the
overall thing.  And even worse, there are subtle side effects that I really don't
want to find out whether or not they are benign.

E.g. before this change, setting the notification vector is:

	movb   $0xf2,0x62(%rsp)

whereas after this change it becomes:

	mov    %eax,%edx
   	and    $0xff00fffd,%edx
	or     $0xf20000,%edx
   	mov    %edx,0x60(%rsp)

Writing extra bytes _shouln't_ be a problem, as KVM needs to atomically write
the entire control chunk no matter what, but changing this without very good cause
scares me.

If we really want to clean things up, my very strong vote is to remove the
bitfields entirely.  SN is the only bit that's accessed without going through an
accessor, and those should be easy enough to fixup one by one (and we can add
more non-atomic accessors/mutators if it makes sense to do so).

E.g. end up with

/* Posted-Interrupt Descriptor */
struct pi_desc {
	u32 pir[8];     /* Posted interrupt requested */
	union {
		struct {
			u16	notification_bits;
			u8	nv;
			u8	rsvd_2;
			u32	ndst;
		};
		u64 control;
	};
	u32 rsvd[6];
} __aligned(64);

