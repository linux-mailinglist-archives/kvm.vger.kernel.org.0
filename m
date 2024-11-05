Return-Path: <kvm+bounces-30631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9709BC536
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F3771C21308
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F851F708B;
	Tue,  5 Nov 2024 06:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hp2RqtWG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72EC1D5CEB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786502; cv=none; b=LL8C99NI6NPKbZ92TC9vWmUrr3bzfNpVAkBmOHrV3l4UC3c4VRGe8C92jgsofcntkGcruuiMKirEVTMuVKIYdeMZuRZyGEuKacOvPGhTbtuay/XZIC5S0YJvGsp5xI3iSsS8jwzkZWrnWXj4TXTCgFF1N7c8W2z+WtxcmS7SPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786502; c=relaxed/simple;
	bh=f8DVteVKcmiNrB06E6UwxXdOSFbeh0++n5OAa3+GgNw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpWozO5XJaZvVlpJGmPa5Gy/wJuSghFhYk0HzR2BJO0pmcjK6858/uRLFXu+jZRfZBrmjIJhJbNkdc6DlSbqebp6K8yTA/YHCxJVAZxADR5cCRJuelWyaQlAHYX7ChH7B1JPi6YKmcEjS68Ibip0JgTHs+z4OTXEZCE3Ch1jgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hp2RqtWG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7edbbc3a9f2so3494255a12.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 22:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786500; x=1731391300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/PD9Sw0SM5OXz6OLWZCRcWotykJSTnXzwhCbYXk9RM=;
        b=Hp2RqtWGIVbNAo5XdqTi9gURxbyFbGfhTvKdff8Y/+cPK0TrbV+v1Nx6WXYwKCsWJd
         os86vJPSZwXo27DFW4gZpPVfaRpwCPAV5KrMapPpdc7MwShwmU1KhxMPFJAv8YpeBwTw
         Q3OXi/PteU0/zQcXR6DQ4NMRTWQlmWNhaxsSFDVq6077d7611zLZ0wyLV/BSt1dInikl
         Ya4qWmXQoZHootxQ4dusJAcI9oL7K+poInx0MXYWfIYKE1BY9ZTdCBd4P0C9qJSoEeTH
         pQjoSZ9OfRX9nY0/RKsBUe4o/dcaa7otnFjjzWDpE0UyJpmNu++DWmERF+A0PSdL45SP
         g8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786500; x=1731391300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q/PD9Sw0SM5OXz6OLWZCRcWotykJSTnXzwhCbYXk9RM=;
        b=H9FK87LGrRcq1hcPwcT1rqTe2IRAYMuwqZJs/k5OX3hrXwJllQBw6hes+NBq0la8UM
         BQYe1XJ2+1W48XpHoAcPF0izMra0AzY9mNZlC84I66nelzkt2CDl5uMFnXE6x5mCh4iA
         nBRvKUlR1XerSPpgfCrUU5p/g7QBTcW48zaWujBlFAJ3BXc1Gavrju4Epj5WgbwX60JD
         5fs93D+obptVV05ue9KepsbKiV8HOboBz8pHZV9s16w5KpzHAkZ2PdYu3K0py2M370ao
         xh4U9Ij6iZs2BPwkCbvyP6coqnmQ8jKk3zs87ryHUeicnZBe4xJlIQZJzRAtCr5/kVuI
         UQeQ==
X-Gm-Message-State: AOJu0YyVZTOxoYn9q3BIn5an4LbWbu1aF5zaMMX4qJ7iSkQNOw+Uzxy7
	LUds96EwJ0AWLHHhQayst4anlyBeQVRGdwC8pr/FHduxV32lk6dFAEz4Y+Di1iFc+2LEhhwAOGr
	n9g==
X-Google-Smtp-Source: AGHT+IHOw3pfmHsW4s9VGqnjcDaq4yFFxI+VfnP3gswq0oYUs3OzFIt3JMwAFZKiEPBtl0PNIOsRTvuNOx4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:2c08:b0:7ea:6bf4:3643 with SMTP id
 41be03b00d2f7-7ee27e02db2mr21237a12.0.1730786498890; Mon, 04 Nov 2024
 22:01:38 -0800 (PST)
Date: Mon,  4 Nov 2024 21:56:09 -0800
In-Reply-To: <20241031170633.1502783-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031170633.1502783-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173077715101.2003996.9192111075725401901.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Micro-optimize TDP MMU cond_resched()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 31 Oct 2024 10:06:31 -0700, Sean Christopherson wrote:
> Invert the order of checks in tdp_mmu_iter_cond_resched() so that the common
> case (no resched needed) is checked first, and opportunsitically clean up a
> wart where the helper would return "yielded" in an error path, even if that
> invocation didn't actually yield.  The latter cleanup allows extracting the
> base "need resched" logic to a separate helper.
> 
> Note, I "speculatively" pushed these patches to kvm-x86 mmu, as they are
> effectively needed for David's series to optimize hugepage recovery when
> disabling dirty logging.  I'll rework the commits sometime next weeks, e.g.
> fix a few changelog typos (I found two, so far), to capture reviews, and
> add Links.  And if there are problems, I'll yank you the entire series
> (David's and mine).
> 
> [...]

"Officially" applied to kvm-x86 mmu.

[1/2] KVM: x86/mmu: Check yielded_gfn for forward progress iff resched is needed
      https://github.com/kvm-x86/linux/commit/e287e4316713
[2/2] KVM: x86/mmu: Demote the WARN on yielded in xxx_cond_resched() to KVM_MMU_WARN_ON
      https://github.com/kvm-x86/linux/commit/38b0ac47169b

--
https://github.com/kvm-x86/linux/tree/next

