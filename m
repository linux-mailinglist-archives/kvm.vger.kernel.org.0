Return-Path: <kvm+bounces-14050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FC689E6BB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 659A81C22933
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D502B621;
	Wed, 10 Apr 2024 00:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bwALE1aH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D44E37C
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708542; cv=none; b=W0F+tYvL/QPp5NZKb6IS04gcojvf79JLqcucr9D2+O3di46810z0uQKh0lr/5DnM2LdX17IZfIvNqkMS2V0UI05Poou+nRfWrjRETrg5NgAmv+GJi38coOmftz5M5MkG+YwJds3WxE0Wt+nMLoEPqu1xh5RG6MYKpRknbbDVlc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708542; c=relaxed/simple;
	bh=4x6QKLqVdfIdsNIWxfFepTI7whyAWTC7EzcS0w+c2co=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLJehi4z5CSVAuIL0DZhV3i59BQA54rIghdt94483Cm0oLOURHV9gQl6B15xa1l83AUI8ESFTnPykONJzMaJU2kleX61Vpdqy2mBJY57SO5K//+kbo0/lgDbaL7Mutlsd3aauEl/Nw6mASvHyEJXOb5Sx01zRvkKzCMxK0t+5+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bwALE1aH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6180514a5ffso27819007b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708539; x=1713313339; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3CTS7AVeK8l4L7hsZqFSyBCqfREsJyVbUvRWFSz911c=;
        b=bwALE1aHcOQUwWf4a40pxmAz4R/v11pQOheCAjIE9lU5dCRNk2sKNM5W/B64eUcox5
         uH/8uM1O866qX+4RrRyA6rtsIrmHpsPzyuEOOJH7byY71/+Jkutn/dnkrtc+xI41SxXN
         9t+C4LNMUuy1W6oe8ZIOpHWMuEtXSR9hsB3iImdUVW7NqNpM2cEXTpGMBrPuLD1CEthk
         PBMeM9MdnY18+QtH6uC2vsgf3uoARY3ntHy4bMg1g73TE8wawa1Iu7Q4pc3rdyyYp61d
         DQBdYUN19fcYuNlFjO7BHUbHDE++hPmxaluf12tzKffc6wuZF7pwrO085kShmjQD+St+
         Eplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708539; x=1713313339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3CTS7AVeK8l4L7hsZqFSyBCqfREsJyVbUvRWFSz911c=;
        b=qVoU2i2R6xnpTYrAoG9vtFIBr0qJJSOT9c15R9RunYuxVn2K/+tpfuGbJ2C/BV8xsg
         g7cZ4qwJmfxPAGVhOheY60aM9NFmG8Dg81gGh1GlImf77zrZGMRqFzw/1xyGJSBjVo86
         C9H8gMziuiGhWmZo1P+VQNjTCy0kguhgHwaIbA7uddN32a4rCy8NID5xbAd7+bfhiG4Y
         Bk5ZKYTzkeS8vhmPGOvWr6eqUJaZoUWfBHwXgO45qqJaqC1Nh25Deglt1m8i2wt2o/HK
         pjVF0i++jsAnC8UF/QUk7+4JzTG28NXc0rqGNxXgcbFrBeYSRK8hd75tnsVFBSwv5h/H
         a4SA==
X-Forwarded-Encrypted: i=1; AJvYcCVfeGkVzhVkXZarFdSbwOv9zSIIVHPAS9zYK4kZiGsGPDtDWVq0xcgqo32/4XWeet5D2EH/I5KLQ7S+06dYORtLeJ9G
X-Gm-Message-State: AOJu0Yz4Ibc3pzFDAFqPLMuYmweEMlPdFptfLFBq/hWDrT1fgxaC/d/4
	Xh2Azd6A/jnvwxyFKNAtT8jWvZ4w+JEhZrkZzhNfw+t4RSOzbsgL/wqbjaG8aUBWTBxqVyc7JmK
	Ohg==
X-Google-Smtp-Source: AGHT+IFWgggW4I3X+t4KiPDeKOLO4y1X+yzQ8TtFh+wQ2npRsz15wA1XNJ1rBnmX0C0Ri2MwpH+GzVw5M58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e695:0:b0:618:3525:2bb4 with SMTP id
 p143-20020a0de695000000b0061835252bb4mr656119ywe.3.1712708539243; Tue, 09 Apr
 2024 17:22:19 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:48 -0700
In-Reply-To: <20240313125844.912415-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313125844.912415-1-kraxel@redhat.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270475472.1589311.9359836741269321589.b4-ty@google.com>
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Gerd Hoffmann <kraxel@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 13 Mar 2024 13:58:41 +0100, Gerd Hoffmann wrote:
> Use the GuestPhysBits field (EAX[23:16]) to communicate the max
> addressable GPA to the guest.  Typically this is identical to the max
> effective GPA, except in case the CPU supports MAXPHYADDR > 48 but does
> not support 5-level TDP.
> 
> See commit messages and source code comments for details.
> 
> [...]

Applied to kvm-x86 misc, with massaged changelogs to be more verbose when
describing the impact of each change, e.g. to call out that patch 2 isn't an
urgent fix because guest firmware can simply limit itself to using GPAs that
can be addressed with 4-level paging.

I also tagged patch 1 for stable@, as KVM-on-KVM will do the wrong thing when
patch 2 lands, i.e. KVM will incorrectly advertise the addressable MAXPHYADDR
as the raw/real MAXPHYADDR.

Please holler if you (or anyone) disagrees with the changes or my analysis on
the KVM-on-KVM issue.

Thanks!

[1/2] KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID
      https://github.com/kvm-x86/linux/commit/6f5c9600621b
[2/2] KVM: x86: Advertise max mappable GPA in CPUID.0x80000008.GuestPhysBits
      https://github.com/kvm-x86/linux/commit/b628cb523c65

--
https://github.com/kvm-x86/linux/tree/next

