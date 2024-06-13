Return-Path: <kvm+bounces-19635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59EFF907F87
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 01:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C2AF1C21432
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 23:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E726156890;
	Thu, 13 Jun 2024 23:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4sasEoIn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8B714EC49
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718321610; cv=none; b=XSXTgQrz3mJKSdY0Z8+ia3mRsC1qHr5HS7y5nT0FyTg4hBs/P+iwvNJHcOmV3d7ehryg2MuDqTHi8sbVdYKSyzc8tVr8QE6esOmp9pmv1cT0kGfa5fA5mwRTIn9W9higFu/1cn9xmuCYQmy+LilOxWjq1b5DeT+A4uFEh1m/1eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718321610; c=relaxed/simple;
	bh=qAt2UhvpvEnOSzh/aTun94gQOxAFglIb1x68LgT5u/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rVLt9RgR8XCDSstY/L9YTiog5QjWPV98PedVSGrO7M0hGiGPTCVrvPNh0ELQoYvbBB9NzzYQLFmIztlQOuabxjWgqFJy7oy3o05hPhsRG536wyORFjKdMZ24qLC6RXoPU9nzS0r+L5Zf1wwdV3m9ewGB/8vi662BiSxLXrL+Zss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4sasEoIn; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df771b5e942so2455703276.2
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 16:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718321606; x=1718926406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S/IekIUszeeugklFzZ/8PWVNYpSQN15CTup3urqE43g=;
        b=4sasEoInUqj1CeNY/ryElq34gXJktIoRPvl46p/YjtKF/YaLvsItdqF90lJeAoBwHr
         xuj/4z8sx9kBxvVigH9tIzjDRKfVqaak12gq8Tt0Ra5mdgHJwbUStxyCr9CzKGBmmPOw
         xcroUBlF0+aF4gEQqz5YuJ5ERwKRzlNHPHijfPa7364q9DElP3vccPzSjSyIyPbUzaa3
         Bnq8iB5XkxlIgZYOgawDvc7CutvMu3Wokx1UKihu6heFWIfnmRqQNKGgrBewUfqsiLF9
         tDkbWQ+Bk1DmlLBQFygDsmBzuvgZh9x8a3CjTSQ/RMmDw89BAfLYhhsF6bgVFE42Sqdi
         Tm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718321606; x=1718926406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/IekIUszeeugklFzZ/8PWVNYpSQN15CTup3urqE43g=;
        b=TQbf8nfij0Oz0d2LZXsJW4+1/4xmYnOa4SpIvNLVXqY5ezKEHRPPSgWgpjwLhfK8Xl
         iMlLj2HqIe13xzYojJxHrlE2zO7PbulklRwA7ANgx3ocAGl51RvDDMdPFLguYb4Nv7Xf
         y5ceLgXsD/5C3831ILqFiR4QbLIFrfDACAUDnrY0ZGnopjQvIcd4gug8RsQwKAOYXiX7
         DO25UNzxBOnKSQllmZTk0VXguaF+DGi1IN3xNIhlwr/uTnfBxKvoZU7qVBvyqT9E/wKH
         +1tstuBe1tZY8/a9VkBTw0BVgvmnWOMKEyUklhbtB5BNLbeMUnPMt6LfjEIZhmlg35R8
         eEOQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4kK7kUk3FQ9gMu92GSyl6s2si4JdxsajJBIQWP9dHh6mSCQ3r91IMuDRx05Gu5qsVoyCx/xkoj/ePcBIH35vPQ0M4
X-Gm-Message-State: AOJu0YyjZFBJicRASQUkeUt9pApNh03hvHMFRoRNDE7CbWj9JjGMfIBh
	Yhny6yfdZ+FxCQjp5abPLuQmJuo6C/13wDAnithc0REku3h99iWsnj/N0hRvPuf6HoEo5W9wW7q
	62Q==
X-Google-Smtp-Source: AGHT+IELUA3WIM5Wphps0xkQTRhby+UDCJjkk/RQ2PxIjMMY045f/NVk5on7zOgMXu0rVeJlBwRipETmKZ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:adcf:0:b0:dfb:c58:6beb with SMTP id
 3f1490d57ef6-dff153d0fdfmr32821276.4.1718321606405; Thu, 13 Jun 2024 16:33:26
 -0700 (PDT)
Date: Thu, 13 Jun 2024 16:33:24 -0700
In-Reply-To: <ZmthZVGmgcM5NQEm@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611215805.340664-1-seanjc@google.com> <ZmthZVGmgcM5NQEm@google.com>
Message-ID: <ZmuBxFwWLAReYUn1@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Clean up function comments for dirty
 logging APIs
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 13, 2024, David Matlack wrote:
> On 2024-06-11 02:58 PM, Sean Christopherson wrote:
> > I don't actually care too much about the comment itself, I really just want to
> > get rid of the annoying warnings (I was *very* tempted to just delete the extra
> > asterisk), so if anyone has any opinion whatsoever...
> 
> I vote to drop it and document the nuance around PML in the function

As in, drop the function comment entirely?  I'm definitely a-ok with that too.

> > @@ -1373,14 +1354,26 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
> >  }
> >  
> >  /**
> > - * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> > - * PT level pages.
> > + * kvm_arch_mmu_enable_log_dirty_pt_masked - (Re)Enable dirty logging for a set
> > + * of GFNs
> >   *
> > - * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> > - * enable dirty logging for them.
> > + * @kvm: kvm instance
> > + * @slot: slot to containing the gfns to dirty log
> > + * @gfn_offset: start of the BITS_PER_LONG pages we care about
> 
> Someone once told me to avoid using "we" in comments :)

Darn copy+paste.

