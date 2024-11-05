Return-Path: <kvm+bounces-30630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C899BC52F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A44A1F22A07
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6111FE118;
	Tue,  5 Nov 2024 06:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tk97Lq9G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857E81FE10F
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786458; cv=none; b=a69ZvCVjzmn/0LwOSiaTaQaSAzMaFBDmY4oNk+KRKBnADih3gkxAvu+zjgIiuBkxWPE43pQ50mxCOUCTNznOw3YPEFU/ulOEOhr3gx2dt7V6P6XrabhYClcsJCzvVQ4BrvjNmK/G4Y2nhge2zGMchZe+KoKCwcWZahrl/XtHFYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786458; c=relaxed/simple;
	bh=vw2F7jm51djnLH3oHbk6XU+B3znRlVDGjJ22TTB2LCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZD307pxB6xAiS8b17pfZbv47qMl62HbEJLTWj9y6b1IkBrHJ+EgeLnYifDO3/GcR9hPyrP2jUMqSl8VSQoDxFcCPcjawmn1NSCmrbVevidXQAPSFZYriA2vpXKLh+EnFuJF0vZ00uk6eKKqOE+AZze/8LWdQjGUq/2Hjovifeaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tk97Lq9G; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eaae8b12bfso10760507b3.3
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 22:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786455; x=1731391255; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CGk8Pf/DTg5hJ/lCP3um58iEkq1FhKzW6BfodA9diQQ=;
        b=Tk97Lq9GiJtZJt/ksqkyYYNdXKgeEk49YiRXvmvLicl2JOCupdCMH/TVGtrvgBCiYe
         U4CFlIahppHHv+feNzpwMyJ6VrSENbasmoUNSam7XJEwBmgVxaKp88+A/U5k2kyVO5NO
         DIFh41fakLFjxkjlFRycjJTyNBQE1tCUI7lGMNaIckadSc9du/Sl+vQT2RRIABG/xIZW
         giGxYWfBFzvDbx3mVsJMR6ITxN9y5oXmasY5dVm1MahaBCw+auNRuWSpmJnldmDgP9ia
         fDbdxKxQhqYzp6BZ3zQyyz8WZo+gsUGVori32mXmSK/NJH9wnv6gs133R/iO9g+zziXt
         nY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786455; x=1731391255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CGk8Pf/DTg5hJ/lCP3um58iEkq1FhKzW6BfodA9diQQ=;
        b=D5tEhHimAD91dpZAx+26uZNjskNc5irQN1aI6Iw2GOA2pqM6n5OkHe7rfGWn/39JuU
         kD+GcBG7JghSQIDYTuSuu7gZS37a62H/gVCeEgPSpqrZuIKC52sfGvbahEwyfU2AHm54
         xIJYA5cYcNAwSJcxvDM3Ym1YrjGu5SdmkL6jvGX8VRzhcSARpuXZdfMsu6rc/2SCKPSH
         XjWsHGIDK9hv38alLNunkIKyOKbeUzxCmRYSnVcbucDFK8tGEHbI4Kyh3sW3gbpJau44
         VZlq0AmayMZduJT8TF/hhm+S4Dh7oCZsZ/l1ad4xuw5ox8mqvoNgO3qQNy06M7FFBCi/
         dPjQ==
X-Gm-Message-State: AOJu0Yy+VeSDEz47UsFT8rgw4EMOuy7lN2vjPBbdq1sloco5W32fgbHp
	UQupdrkYdhM7atvSs7YJ0wVohZ8icOBlzeXBykWdh530lLm7BPegnBrUP6/NdsObB/JZwx4daFl
	a4g==
X-Google-Smtp-Source: AGHT+IGUtaVvf4FSg9zT1qWLLHbb6mI0gDATsHlIFOEDh+b4d8TtxrjtHOOPASTtBz/bPk8slTtKE97hdco=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:7c5:0:b0:e30:dcd4:4bc with SMTP id
 3f1490d57ef6-e30e5b37923mr12159276.9.1730786455484; Mon, 04 Nov 2024 22:00:55
 -0800 (PST)
Date: Mon,  4 Nov 2024 21:56:07 -0800
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173077714511.2003886.11233755560537536541.b4-ty@google.com>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Optimize TDP MMU huge page recovery
 during disable-dirty-log
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 23 Aug 2024 16:56:42 -0700, David Matlack wrote:
> Rework the TDP MMU disable-dirty-log path to batch TLB flushes and
> recover huge page mappings, rather than zapping and flushing for every
> potential huge page mapping.
> 
> With this series, dirty_log_perf_test shows a decrease in the time it takes to
> disable dirty logging, as well as a decrease in the number of vCPU faults:
> 
> [...]

Applied to kvm-x86 mmu, thanks!  Note, these won't be contiguous due to the
insertion of the other patches, but the hashes should be correct (knock wood).

[1/6] KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
      https://github.com/kvm-x86/linux/commit/8ccd51cb5911
[2/6] KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs
      https://github.com/kvm-x86/linux/commit/35ef80eb29ab
[3/6] KVM: x86/mmu: Refactor TDP MMU iter need resched check
      https://github.com/kvm-x86/linux/commit/dd2e7dbc4ae2
[4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings in-place instead of zapping
      https://github.com/kvm-x86/linux/commit/13e2e4f62a4b
[5/6] KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
      https://github.com/kvm-x86/linux/commit/430e264b7653
[6/6] KVM: x86/mmu: WARN if huge page recovery triggered during dirty logging
      https://github.com/kvm-x86/linux/commit/06c4cd957b5c

--
https://github.com/kvm-x86/linux/tree/next

