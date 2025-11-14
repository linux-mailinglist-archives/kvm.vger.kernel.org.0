Return-Path: <kvm+bounces-63162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A100C5AD99
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B86DF4F1DA0
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AD323E35F;
	Fri, 14 Nov 2025 00:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sFDSd1LZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854A622333B
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081211; cv=none; b=Soi5waLdMkIOomHAfML0Ea/wqdarpzAGkaMqdYG+vSjjRLdG2QQWi8uDh2i6wJZhLFI1x8mOhbiAxUAETqQS5zjEX62cL+AtXkHXih6CqrJQ4oftNBoRKusn64hWCc2//nOHC/LLkkXuhvw0Zzk+WO9XyJ4V0xTNewQG7xUYriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081211; c=relaxed/simple;
	bh=9owepp8iQfA2npTRT8f2dr+9Px69I9VyQh60+7kjYKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=Awm2PPSPeC0oCTcuCjk1BbmeHI33QQn8am7/rr54edOyuQ+sZLDIWsIxXuJbwD5AX/Zk/EF5WAGffkOF9XNVysGwOLsr6FdubM8X3ODjKS4CU8/IBMAX9XdlELK4lvoi/Rc2BXdgIH6xMuBObpbY100hEo47rIGNPd1orcl7I4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sFDSd1LZ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8973c4608so3687671b3a.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081210; x=1763686010; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CV28lUyLRyixTvhpjJCM9zbVXVan+sgw/6AEFI9vpYs=;
        b=sFDSd1LZodTy8Z46Tz51vXHOXm70gyA1fQ+++/me49mSIBW4wl+7+FoXOzPK9chQsW
         zP86QoLSCMoim3QVe+vMq4QbGblR1PzLzZUynK40cqXfX1lgefjH9cxAUG7fUgE+yQ9h
         1YITdqDReDMwIlEngSKY4UB9+9jxqketIVyKa3vU2S7GmEcBes2GodETR3m2s2hLr/B0
         zXBv7vigRQGVOH+Sxmhx0rL389z1Za//rOuyTdc8ofQGkEIjt5XYAXJemLy+CiwdhyN8
         ZFDeGLmEt+7s4RZNZGo9Pzt2KJqswPd4+rhcC4TexOyJn/SAds/082P0M9ktMIVSJEas
         I0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081210; x=1763686010;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CV28lUyLRyixTvhpjJCM9zbVXVan+sgw/6AEFI9vpYs=;
        b=hKoBTqjMa1cMfQnE/vNkTkk8Qs0Y1MJA2UhC1Xa0FqIxMHfsmN54B5FgrYWswDGtHq
         s3LJRUHQFYOxyI5LAXvMipMm2s0dr6JZYUvGASEJxAMkYfNKFMIvKByikRh9/iOFKTwZ
         G+WSP6QRAFhA5rOI5O9Ql0FakSJFTe6PNuw39xgYCL65nHjCT4v6EiTsPI08JOd65cmK
         QoCT0VYaBV5RTPrg1VhQjOOEy9MFtGEbeKHT5hHwUokgRtXdJtSsGtDz7zWw2X88cZgA
         lidyDITw5vs5jr8gCvEzPtkAmdHN2WmZaIP9jr8XG2qmsSQV+AxYW0RscVQIHINsnkp4
         CVLg==
X-Forwarded-Encrypted: i=1; AJvYcCWvcO/djPtQWWzHqS/OeioJU6pdraNPOd1zj6TvdFt7x7n8zcxKdwOvzxR82ZWz05aS39U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCYoS4HsebtjeBNuo4Egi6baVakg1jy8kJfuBXJIIIj1eGyI2S
	uoQfEipV13f6S82oWhGKHdFqkpZGmav6g15uSojdhwV/0HJB8scLMYCYZw64NYIIxOg3i/e7cyu
	rwovVDg==
X-Google-Smtp-Source: AGHT+IGJ1FLl0zRFYeBHvkyelqK9iY/pcb+Y1suzfHithCNRAzaORGZkYhYu8+muG8lSpw87YyMOgl0rnvI=
X-Received: from pfej1.prod.google.com ([2002:aa7:8d01:0:b0:7a9:ce34:8e4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c89:b0:34f:7454:b97d
 with SMTP id adf61e73a8af0-35ba0787ba8mr1957512637.25.1763081209813; Thu, 13
 Nov 2025 16:46:49 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:07 -0800
In-Reply-To: <20250724191050.1988675-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724191050.1988675-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176308088153.1726846.11241547001093275242.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86 hypercall spring^W summer cleanup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="utf-8"

On Thu, 24 Jul 2025 21:10:47 +0200, Mathias Krause wrote:
> This little series cleans up the x86 hypercall tests by making them no
> longer rely on KVM's hypercall patching to change a non-native
> instruction to the native one.
> 
> There are attempts[1] to disable KVM's default behaviour regarding
> hypercall patching, actually requiring executing the native hypercall
> instruction.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/3] x86: Don't rely on KVM's hypercall patching
      https://github.com/kvm-x86/kvm-unit-tests/commit/8b65d2877206
[2/3] x86: Provide a macro for extable handling
      https://github.com/kvm-x86/kvm-unit-tests/commit/4f68c893fec9
[3/3] x86/hypercall: Simplify and increase coverage
      https://github.com/kvm-x86/kvm-unit-tests/commit/010dee475cd2

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

