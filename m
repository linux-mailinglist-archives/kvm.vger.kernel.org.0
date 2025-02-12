Return-Path: <kvm+bounces-37991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7422A3322C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 23:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 668DC188BBAA
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 22:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9456D204095;
	Wed, 12 Feb 2025 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tCn2ND7d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607981EBA0C
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 22:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739398341; cv=none; b=e1xeL40GUyaphO6hqXXmmlTyQQNbhbw/yZK9+LeU/R4XeVu8aayBIkkdnuaQhvax1SfFyOPuWiOFee8J9giag354uIy9SKgYJEMaJ64ZNtiDwoUfxb31XXLdk/bmDA73yaLDmk/nkrstgtPrkgltQbMVUqn5hdTk01jarveB4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739398341; c=relaxed/simple;
	bh=72BRB4+RNJC3IxMpQSiVR5uCpdxzxA9q4DdgCLLMVOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A4yj9JmG+R5dIYD9kSiMof6PhOrNjFQnQffrtjsHb3hJLMhE+6qth9GxJaNhUc/a/eZoo4QIaQkxKMxPb73lUUIySRO2GnK83YBgQgwbsLQ9nmdekdd3P2o0ldwQwxOE84FUydtIyqbcknazw7eMuIK8JieoaucIxZCzXT3yhf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tCn2ND7d; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-52033e9d966so64314e0c.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 14:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739398339; x=1740003139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rPLBgoltQaYwjDPjqOcGlSgPBBFDomQ2kNGZA5ULopE=;
        b=tCn2ND7d4AHM2YnVqbqW/eNlAGmGoLgbfxxvW/M7NAd5BXv+xYYP3cKDEsObXfVAWa
         GlE6GrAiOiKWFJFhvewHZDQ/ZiYgfRCPDBqeBGYo2B6gIKfFfG5aMRwJinQMZd7Y3sJX
         NnmNHQtCE7zFYOMn6yIi0YlmrWJ2vtlVnKt2SbG5aJ+9hgi2brkhDhS44gcRZeontn/h
         zm4TwwzP1Jo9ZyIXsjBrHwwoWHyW+9bOpgMp1KorPGoH1XdNeMX/x6uRrAYQndU5GpqT
         f3nArrglhj9s1OrthC8A4Xnd++9BT/GbRTauYB18OPorIozRDLHwx27ixRMAgCJ1wRmo
         oAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739398339; x=1740003139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rPLBgoltQaYwjDPjqOcGlSgPBBFDomQ2kNGZA5ULopE=;
        b=Vkkmk3uckIKwsnXlJqlEH8tRrr2HK7tmHLxtNAMCeTqmDrt4Ggz2whohxc00gzxhtP
         kn+PWkWVf0yj/F0oUdoZpJSnCI/tJbH0WTAPo6hXLzanRp2AkHcSkxbssMRvCPXdrx9c
         SlQoNn0z1gfTB+sqcifFH9tP5tqjVsUsC3SA46MOoYkOw03A8KPOERq/P+fJVmNCNv43
         4uJsW/y/VoqvkY3JCflRdw9pt7c3ldiVVasRxCqxnzDppE3uC1bBlklz/64dwrS2S5Nz
         o3fy/mwdVE+d3uoNSftdNYBYFJbrB4H6tYbhOFAPsEeh3vf3p61aQzAL1J4zGqsq++kC
         XC1A==
X-Forwarded-Encrypted: i=1; AJvYcCVPceNQXZgagRvpxJ/apH8JQ5OqRz7UZYnIP58VLZlBp7etIpTWQrXdheNIZQWlohcZGKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOUT7X5oOegNNDg/dWloEQArssdbvQkJ5vhHP6FV88jBFwLmKT
	UCdNWwLOntNecwwfpISzIVATZU+OKP3SytHdC0f/H7e/g9NTvZ8bWttrBHeWFjVRLbitNC/e6ye
	ZpK92zShvtQpjri+2wg==
X-Google-Smtp-Source: AGHT+IEtUpEazFlR8DuFjBjejock4b6zp0iXGyWQLKsGbi8i9EbV7tkmLjIdkO9tXjUnHK+cNjgzk6K82Wv1WvOS
X-Received: from vkbel2.prod.google.com ([2002:a05:6122:2782:b0:520:5c18:7901])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:4684:b0:520:43e0:8ea0 with SMTP id 71dfb90a1353d-52069e1c67emr4630587e0c.11.1739398339282;
 Wed, 12 Feb 2025 14:12:19 -0800 (PST)
Date: Wed, 12 Feb 2025 22:12:17 +0000
In-Reply-To: <67689c62.050a0220.2f3838.000d.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <67689c62.050a0220.2f3838.000d.GAE@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250212221217.161222-1-jthoughton@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in vmx_handle_exit (2)
From: James Houghton <jthoughton@google.com>
To: syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com, seanjc@google.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Here's what I think is going on (with the C repro anyway):

1. KVM_RUN a nested VM, and eventually we end up with
   nested_run_pending=1.
2. Exit KVM_RUN with EINTR (or any reason really, but I see EINTR in
   repro attempts).
3. KVM_SET_REGS to set rflags to 0x1ac585, which has X86_EFLAGS_VM,
   flipping it and setting vmx->emulation_required = true.
3. KVM_RUN again. vmx->emulation_required will stop KVM from clearing
   nested_run_pending, and then we hit the
   KVM_BUG_ON(nested_run_pending) in __vmx_handle_exit().

So I guess the KVM_BUG_ON() is a little bit too conservative, but this
is nonsensical VMM behavior. So I'm not really sure what the best
solution is. Sean, any thoughts?

