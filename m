Return-Path: <kvm+bounces-38198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B8EA3673F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CBC616B9C1
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 21:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F361DA31F;
	Fri, 14 Feb 2025 21:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2AyZwLk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5712417E
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 21:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567326; cv=none; b=hJL2KEVbnqw7YoZiM71xWFa9iEFWkC1tu51Qw5X4AGfA//SSxywjxFeMHRechkw9OHPbTsS5/KeX2QY7ysj8u+2NFQooeDwHuQvir5ZgW2D3VJ9AFbrB7lOjpUERFduFThQp5fNuNSjtfG2Md4xZsvnGH7vKzBB9vKYd0rT/2F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567326; c=relaxed/simple;
	bh=TABwW3ceukCNtXZ6II8q8PhTuJdg9NELJOoW5SvPSxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aUNzrKciWPHafPJSGCco7YKIa+WEX0sXXYP6HRen+hu0WkDuXYgHefVsMTDgzyQ24/djd9WIbpLagFfTZqLlM6yzPI4d4756aFCT6KJnikMGKh3WZUW+aAZN0BdO8u19CfCiWJKrWRkLl0XunDnWPZufmAiTsdlQU2/18KOfOsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o2AyZwLk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220cad2206eso52461745ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739567324; x=1740172124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDk9Bd6Y/gy2sTN8NncOlmLs9sUGP6oX096KSBQmv2E=;
        b=o2AyZwLkD2ETHCjiegJneBZ50czWafrXH93eGhdfIT4qsM1KrykBi/SK5kjZ8AGMbj
         J/dFV1r2rOTgkgWyPfspmSaRzx0jAcx2avbO6o9Lle5PL1O8BLDmLlzvU3J6rUweZ1SS
         dpql/SdfhF/S+5OgcqEW/tYWTSMwgCiqYAwiMPFESjgnLnN6oSnXdPQh7YvfF71zIuTr
         A6H7RfeW0kaSBYz6fS2QI5hZYnbPRa/zWoqcRiw+8bhRLbjdB6uBXHcr5pV2/3klyjDI
         vUo4NTXJw/yBCCDdj0WXZHrjYS6UHSDQLKt3nFKJkym8zF5GSAOrwkFuXTJPHux0kyhV
         9Jvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739567324; x=1740172124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDk9Bd6Y/gy2sTN8NncOlmLs9sUGP6oX096KSBQmv2E=;
        b=n9Nl7tQ5eHsJHhe3VezNiXQ7wAFBCuo8RgP9ZyOVIu8r+fLjqrzWFJPMJdxtkxHyaO
         uxL0KFYPARXQI2VP7Le1eBuD+RnjulIhuhLixe62Eo8gBXH70u5e9TzVQ3tPgkk/Vno0
         MjDZi/Fu5TTT6Ji9MPKJNhbBHB1aP1MegBvo9rJ6YcDhX5ESbuvIyPVSaXqfu+lMSqEj
         aQ+rzV/IvDBM09c4Qy89Tbk8TY1y1qJs734OquV8BI1mbi9WAfhXMlHgZLXsa9P5w+o8
         8gcZj1p2Vy+uVA2DbMInNhKpPsQGFrxIxixZ7F6p0ZUqanmqe8QmplP/gM8wgPzQQ8Z6
         Z1JA==
X-Forwarded-Encrypted: i=1; AJvYcCXvhJ/S1+wur82oDzxwggl9nkDFXKPaRElocV8sY1r2vXSV7HYjoMIcGH3uL82BX0XGZoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr7r51DYlCKm/e9C3TV8n8251asC+1J8REsOICtnk2X832SZ4e
	69o1xDW0ngP8DvtaBRRLDlB/kJGmabe0QlMQWUnsoUEOXqBp/HyjWY0GA5x8f3Dk98pyBLwDm7u
	uaw==
X-Google-Smtp-Source: AGHT+IHGrqSV53zwVxDPFhenez3hyCmOAIu+9D/XKocIxWU0Dw1My/XXweOF81M6LpwkA3MOCD/JQLSXGkQ=
X-Received: from pgf7.prod.google.com ([2002:a05:6a02:4d07:b0:ad7:adb7:8c14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2341:b0:21f:9107:fca3
 with SMTP id d9443c01a7336-2210405c6ccmr11127175ad.30.1739567324694; Fri, 14
 Feb 2025 13:08:44 -0800 (PST)
Date: Fri, 14 Feb 2025 13:08:43 -0800
In-Reply-To: <20240914101728.33148-14-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com> <20240914101728.33148-14-dapeng1.mi@linux.intel.com>
Message-ID: <Z6-w24T1iH2S_Fux@google.com>
Subject: Re: [kvm-unit-tests patch v6 13/18] x86: pmu: Improve instruction and
 branches events verification
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Sep 14, 2024, Dapeng Mi wrote:
> If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
> __precise_count_loop(). Thus, instructions and branches events can be
> verified against a precise count instead of a rough range.
> 
> BTW, some intermittent failures on AMD processors using PerfMonV2 is
> seen due to variance in counts. This probably has to do with the way
> instructions leading to a VM-Entry or VM-Exit are accounted when
> counting retired instructions and branches.

AMD counts VMRUN as a branch in guest context.

> +	 * We see some intermittent failures on AMD processors using PerfMonV2
> +	 * due to variance in counts. This probably has to do with the way
> +	 * instructions leading to a VM-Entry or VM-Exit are accounted when
> +	 * counting retired instructions and branches. Thus only enable the
> +	 * precise validation for Intel processors.
> +	 */
> +	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
> +		/* instructions event */

These comments are useless.

> +		gp_events[instruction_idx].min = LOOP_INSTRNS;
> +		gp_events[instruction_idx].max = LOOP_INSTRNS;
> +		/* branches event */
> +		gp_events[branch_idx].min = LOOP_BRANCHES;
> +		gp_events[branch_idx].max = LOOP_BRANCHES;
> +	}
> +}

