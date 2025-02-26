Return-Path: <kvm+bounces-39201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3390EA4519B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D60B519C2876
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 00:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D05C13D89D;
	Wed, 26 Feb 2025 00:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zlC7O0zx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DB379D2
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740530299; cv=none; b=JXrpqgx8o8qaUeScyCjXSTLQEB5AZTqYa0xOGVL0CqGdRrNHV5LHnAno++VXZKVymayYqs/72IoOl6bQ+zhU+0xtYRGAX/6B4bkaHeSsIj2NeKEUTNaBVwmOj01x7j9oApIHudfpCE5zs3ONbNavEyFAroqb3mv6Nz+gIZXgdOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740530299; c=relaxed/simple;
	bh=98qmeHuxb8kfZLw5go0ikVnX5IuVeWrIvgaBxJXsmBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uK9OVlq/ND/jF9tlQCmTfb0JuRYRjIt2AQOpGui96fZwemkLivd+1sqlIUxIZLxa03OrmuBVqLypNHZ/ta0dN2z4sFwDxZt2yoO10DQttZb2ubBWUP0qrjvv3+dLMeNNnjk7MI2OiHoJ3f2b8ng9K3qUOA+G2fyAA+8qU8JcRRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zlC7O0zx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc43be27f8so20566447a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 16:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740530298; x=1741135098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yhtOhpsyhbNKeQJImuwdKpcruoCv+uVBV7M0rzTsAqo=;
        b=zlC7O0zx59DAFZPGynsUpEExuW7qIVVVfiQjR2OaA9HOyKY6Ol35giCWuFra7kuHJU
         hkW/6xkgwOFNP+Qwlc1nUxuNbDaEHhZcf6T3zZdJbXS3wTFOA1u8yfDemqXcjgOoginY
         WjGHb3WjTV+Z0J1pyjcDa8PktQLp5ZTIfs1+LdPJSQJDp+bE/zc60WatDGNbbi3vslJh
         vwsKrYD5Fv+QC9h6mhSvrteRR3keUJcKVxHr5cy2qZNk6oGRJMyeeyOMcR3QOBzWasFI
         o87Nih34LxIdOQ6pXw60p15DvE8/DGzrMCz94M8g6Xg5R3lZpgZI2KJjNSE4XjxWm0jA
         p6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740530298; x=1741135098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhtOhpsyhbNKeQJImuwdKpcruoCv+uVBV7M0rzTsAqo=;
        b=JP8DWrqH1mGt8SgT9nDPzUiSJmscZPzquBhnUDq4LaqEODx1BvtG2B0C/iYGtGF6Z+
         eykNc9etcf0QY00oq3D09SvwHH/WvtdnZuEtCddPW2O51jCEvs4D/0ihoxBAfp29y2oG
         STIoafnLLhWPkEnRIiHZxcZ9t6TGuZI430r9mO1iH7C4rSdzSmedZbHaic06ML8KMyYS
         AV92Pk8JC3uy1Lz2zRawmFUZF42qIoxPisiRNpNXDkma6XDJug59jdIt4F3AtZi4NSwq
         4eEjH9uDYGDRB+4x4/bxRBAAwMZtBuaRbyRKHOHFuB9WJfwGN/ZS3cfidgqjFwLibZWV
         IiRw==
X-Gm-Message-State: AOJu0Yw2x2FYKq8RI5L2NYFiqx/ZmHKQvSBWAhJWjBT2Zm2sC5XuABeC
	Cruz+rK9ZixaUdHXp251K0sd4mYmlcexD+IIi64lNwbcJM1Radxz5uhax/QQyX3SaozeReXcYuk
	RaA==
X-Google-Smtp-Source: AGHT+IHC1eUdH6w7RjlDG4zAxVr4I3LM4m2Ye/XQ5yW5Z/A6BJVF+fnZnmY1FqR7/bd15OP7K5YZ4bIV1J8=
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2fa:15aa:4d2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54cd:b0:2f2:8bdd:cd8b
 with SMTP id 98e67ed59e1d1-2fe7e3b1756mr2196568a91.29.1740530297782; Tue, 25
 Feb 2025 16:38:17 -0800 (PST)
Date: Tue, 25 Feb 2025 16:38:16 -0800
In-Reply-To: <20250128124812.7324-4-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250128124812.7324-1-manali.shukla@amd.com> <20250128124812.7324-4-manali.shukla@amd.com>
Message-ID: <Z75iePyU3PK01oG7@google.com>
Subject: Re: [PATCH v6 3/3] KVM: selftests: Add self IPI HLT test
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com, 
	neeraj.upadhyay@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 28, 2025, Manali Shukla wrote:
> +	if (kvm_cpu_has(X86_FEATURE_IDLE_HLT))

Well, shoot.  I gave you bad input, and we're stuck.

this_cpu_has() isn't correct, because the part of my previous feedback about
needing to check *KVM* support was 100% correct.  But kvm_cpu_has() isn't right
either, because that checks what KVM supports exposing to the guest, not what
KVM itself supports/uses.  E.g. even if we add full nested support, the test would
fail if nested=0 due to KVM not "supporting" Idle HLT despite using it under the
hood.

The lack of a way for KVM to communicate support to the user has come up in the
past, e.g. in discussion around /proc/cpuinfo.  Sadly, AFAIK there are no (good)
ideas on what that should look like.

For now, I'll just skip this patch, even though doing so makes me quite sad.

