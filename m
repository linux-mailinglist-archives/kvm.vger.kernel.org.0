Return-Path: <kvm+bounces-30235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4759B83D1
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:57:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 507801F2174B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601BD1CCB27;
	Thu, 31 Oct 2024 19:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kU42oUR5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348D347C7
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404580; cv=none; b=BNYeJRtkud1T/PczwCfSQk/LeDAZKBuVVFeGRq6L1yF9j3QAOISpz20ClD+3GOGj0EF3NRYSFt7upM4VfzEbBygyGzluCOXEFK/1rH4BSSKSW1GYtHW6iWvDLv4GPet4q0T5ayBNPRxJfoJvSKD8Fo96RDRIYzFBb0CxLXgHPA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404580; c=relaxed/simple;
	bh=BRrXataTRR4Ms36tXkzOTbXr5RIoMk9XasFjsN9WXKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s93+UwsDe4yLiwEvgTvo6YRZ+w2wnsLX1mBIZhcu8nkyQwYxJoWx+oTBlDplMREA0I5B7fSqoSsHy9XbZKXPs67/uEiBzaDAKWxHt9m+pRJXejClGgunKpx3tlefHn2KYCKPqkTRi7ao3NBidtbz9HpNPbLOnvJzW2yecErybVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kU42oUR5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fea2adb6so2009720276.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404578; x=1731009378; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=txZjjV9RcIShW3nVjFWlvOpvL41tXBbYireztk+Aubg=;
        b=kU42oUR5/SFSIUKy3VCzRyTaP4efeWOD1Vh1CZQd02kEbWlTBwMNcXcgpNZRCRktEW
         Qhzw0LXbdK5BrTxEX8lqKXX4OMWQn5PDq7uo1djEa2LkcKSL8K2Xnqs6tE6P1vRj86Sw
         SQ/hvVvaJU2RI7R80nFXIWL6yW41fPHT7sDXFia3VXpkmck+Fdi0/rKx40SLqG1OrJBp
         x7OdPxaam3uJb+QengnkWC7SncFgkcmRez4nr9wZmZggFCkf+/f5UVmEnH9zBY6WgXHC
         BDt02VaMpE9kuezLh5+Ed4acrkX8PTj+om7r7A8NS8JA7ANecAXK7xKJw4/Yh2ZBHuAj
         yCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404578; x=1731009378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txZjjV9RcIShW3nVjFWlvOpvL41tXBbYireztk+Aubg=;
        b=wFcswRgtjEKr5ai4LBR/nnQS3Y+G/92us6c/wdRDxc/UMmOO/hTt/GEHAIUiKu7iGn
         6jWYfeEX3Nc0e7N4nkub/Ivci0pZB/xr0cYBRqdjm6kjdi0xKGU1P74oflLkzYO7aDjl
         WGFUaCPUQY+3jrbPVXxO53S+SqoA7IlL1trOB2/QOfaiLsASpAehm5OUI47aG78ijheK
         KhposhZZWgl4jkM338SDTvz7PkDukszdMr6rC2KPdjNI/3FZ4jXLy32fio8sbz0Xc7IG
         CpnMEgX4tzJmKy8D/cz3up2VzR2VjpI/nUvPYnPojaSwpL1x/E61AmuMMnedQa/bQidB
         pwbg==
X-Gm-Message-State: AOJu0Yw3q2niOwnWjedIUFmYVJ70xeIbqZIAGsu3MqJpkI2Q96QOKoXx
	N5q/cqHiTHDVaG1wrbPFQu9dBzSrUIFWVpkkwB60Q7fRnyAGBM2qxXow0w7zBZeCaxfR/dV166R
	YFg==
X-Google-Smtp-Source: AGHT+IFq1n0hln1PuXIug0g9U4zAlW/fXzKfAeWXs5tiH8N8rfYic8hDm2ig51IotN0LdGwVjOczliRMcT0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ba0d:0:b0:e28:fb8b:9155 with SMTP id
 3f1490d57ef6-e3087bfc93amr51693276.9.1730404577846; Thu, 31 Oct 2024 12:56:17
 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:48 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039527562.1510435.10161508474712301971.b4-ty@google.com>
Subject: Re: [PATCH 00/18] KVM: x86/mmu: A/D cleanups (on top of kvm_follow_pfn)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 10 Oct 2024 19:10:32 -0700, Sean Christopherson wrote:
> This is effectively an extensive of the kvm_follow_pfn series[*] (and
> applies on top of said series), but is x86-specific and is *almost*
> entirely related to Accessed and Dirty bits.
> 
> There's no central theme beyond cleaning up things that were discovered
> when digging deep for the kvm_follow_pfn overhaul, and to a lesser extent
> the series to add MGLRU support in KVM x86.
> 
> [...]

Applied to kvm-x86 mmu, with Paolo's suggestions (the guard(rcu) trick in
particular was quite nice).

[01/18] KVM: x86/mmu: Flush remote TLBs iff MMU-writable flag is cleared from RO SPTE
        https://github.com/kvm-x86/linux/commit/081976992f43
[02/18] KVM: x86/mmu: Always set SPTE's dirty bit if it's created as writable
        https://github.com/kvm-x86/linux/commit/cc7ed3358e41
[03/18] KVM: x86/mmu: Fold all of make_spte()'s writable handling into one if-else
        https://github.com/kvm-x86/linux/commit/0387d79e24d6
[04/18] KVM: x86/mmu: Don't force flush if SPTE update clears Accessed bit
        https://github.com/kvm-x86/linux/commit/b7ed46b201a4
[05/18] KVM: x86/mmu: Don't flush TLBs when clearing Dirty bit in shadow MMU
        https://github.com/kvm-x86/linux/commit/856cf4a60cff
[06/18] KVM: x86/mmu: Drop ignored return value from kvm_tdp_mmu_clear_dirty_slot()
        https://github.com/kvm-x86/linux/commit/010344122dca
[07/18] KVM: x86/mmu: Fold mmu_spte_update_no_track() into mmu_spte_update()
        https://github.com/kvm-x86/linux/commit/67c93802928b
[08/18] KVM: x86/mmu: WARN and flush if resolving a TDP MMU fault clears MMU-writable
        https://github.com/kvm-x86/linux/commit/1a175082b190
[09/18] KVM: x86/mmu: Add a dedicated flag to track if A/D bits are globally enabled
        https://github.com/kvm-x86/linux/commit/a5da5dde4ba4
[10/18] KVM: x86/mmu: Set shadow_accessed_mask for EPT even if A/D bits disabled
        https://github.com/kvm-x86/linux/commit/3835819fb1b3
[11/18] KVM: x86/mmu: Set shadow_dirty_mask for EPT even if A/D bits disabled
        https://github.com/kvm-x86/linux/commit/53510b912518
[12/18] KVM: x86/mmu: Use Accessed bit even when _hardware_ A/D bits are disabled
        https://github.com/kvm-x86/linux/commit/7971801b5618
[13/18] KVM: x86/mmu: Process only valid TDP MMU roots when aging a gfn range
        https://github.com/kvm-x86/linux/commit/526e609f0567
[14/18] KVM: x86/mmu: Stop processing TDP MMU roots for test_age if young SPTE found
        https://github.com/kvm-x86/linux/commit/51192ebdd145
[15/18] KVM: x86/mmu: Dedup logic for detecting TLB flushes on leaf SPTE changes
        https://github.com/kvm-x86/linux/commit/c9b625625ba3
[16/18] KVM: x86/mmu: Set Dirty bit for new SPTEs, even if _hardware_ A/D bits are disabled
        https://github.com/kvm-x86/linux/commit/85649117511d
[17/18] KVM: Allow arch code to elide TLB flushes when aging a young page
        https://github.com/kvm-x86/linux/commit/2ebbe0308c29
[18/18] KVM: x86: Don't emit TLB flushes when aging SPTEs for mmu_notifiers
        https://github.com/kvm-x86/linux/commit/b9883ee40d7e

--
https://github.com/kvm-x86/linux/tree/next

