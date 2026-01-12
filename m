Return-Path: <kvm+bounces-67796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF42D146A4
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5DDA23009206
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AADD37F0E4;
	Mon, 12 Jan 2026 17:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/lfpbdY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38F0378D8B
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239552; cv=none; b=rS7g88ocEr3pfzn/wB67sMDyJH6/2oHTPndGP199Qkaujf7wss33iWewgJqUJvBaNcQUtB1JP7nsL06hIqmjk9FS7vh2O6QgLe3JZKWrSLREKE+TZAqIx/3yxTkomyMxXPzTE1gZxC7yzUV+C9Fz1hKCZPu6MSE1RNF+1TbS8TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239552; c=relaxed/simple;
	bh=RTVORSo0lJ2cws+DS7SeEfR+4yNffoXDtwOL8pkQ0Pk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OEBi25L15wHGPAiOGDp03PqLpepknDWRamtcVsTuglce++NvVlIqp/dsfIkV+FJoZwoKM0mz3T8N2BevoOZ8QsMsqFOcIoRAW6USskcu3EqjOJs+am2lft3ebSDUTjR/D6NSbVpQQJ9XJLe4K/BQZ7WEYbwT4UaTjoVFl07f2RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/lfpbdY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so5976181a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239550; x=1768844350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSFLSAUYhzme9qHXHWVTwua5JfvzMHsShR3TQ63UGKA=;
        b=M/lfpbdYEQDR465nkQSn03TcxEbHhglVz47WUXuadOcZir0mtJAmpenlK2lEn1ZeoW
         0CAVhhcSl8MsjHWVEzzn+R+a04C+/HXTslglSWEECbD/vKFPV8elRHHZ7mTPuSzEPPV7
         IhIhXuFRu7Ti/3gGW4BPKkF3L9RQwh15SRKQd5FIrfPXAEaPFOq/ihU1ALgIBlMdS91V
         hjvPr8P124Gp68yY+GoVaeiraodx25Ow17oOmIkZuPf/l84vJRPvF1yP7QoNmOsY+mYg
         qEFEFPBDuBs6KHXugWABLfLCHf+KgLD1ICASR7XIeQ7bVZlElJWcjwwMNv7RrjfIUz76
         fhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239550; x=1768844350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSFLSAUYhzme9qHXHWVTwua5JfvzMHsShR3TQ63UGKA=;
        b=EmRJ70SeNl0AsAWpAFjqbM+AQeiG87fQfq1E4W89EvZkZcUeLSGYRjJNIGQjFwLvzT
         h0Oepxke4i6GxAg5TdhldUBn/hTF0T5tEpmKj4Uifmt9b+TwjaOy9R55xRuMKCjuO5dF
         K7SWWZSuaAZFl2rFftr86uzVkfO7AXlkjMj3ey+1I0lwD/7VO+paODlg4Gw85oLfyhzx
         HRpHGq7+oq0pXmXLdMwghvDKzCi5zRnPGygkFKFFGwoo7ENqgH9qBwQW18rO1WYXoMuS
         FApckz0HHq256toitBu+kJ831M1ehtCyYLfILnPr+EOGucv4nynkd5nOkzJ10E4cXin9
         UWnA==
X-Gm-Message-State: AOJu0YxZLZuIjmKPNDh+k2cm/3Zffgr5o6mOd1DOuJBU1KuXwMKGC52Q
	glJxR+OksGY0NF/QMtSu6VJQpwOUPRkiJG8ekR/DEoEWQ7aA8U/yDWJF+fMb0aFfdRA5e3PbqUu
	5v9cFAA==
X-Google-Smtp-Source: AGHT+IHqoThw16pO0TOJ0NfbuhYU/h6fgU6ycYUUY57lEeHhtgEs/C+o3GGTFRJCZY6sRvB6vJmJFfwiFEk=
X-Received: from pjbfw1.prod.google.com ([2002:a17:90b:1281:b0:34c:a40f:705a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2789:b0:32e:6fae:ba52
 with SMTP id 98e67ed59e1d1-34f68b4cd37mr17796496a91.6.1768239550108; Mon, 12
 Jan 2026 09:39:10 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:32 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823891558.1370546.10438547249061271576.b4-ty@google.com>
Subject: Re: [PATCH 0/9] KVM: x86: APIC and I/O APIC cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Dec 2025 16:43:02 -0800, Sean Christopherson wrote:
> Drop a bunch of _really_ old dead code (ASSERT() buried behind a DEBUG
> macro that probably hasn't been enabled in 15+ years), clean up the bizarre
> and confusing "dest_map" pointer that gets passed all of the place but is
> only actually used for in-kernel RTC emulation, and the bury almost all of
> ioapic.h behind CONFIG_KVM_IOAPIC=y.
> 
> I'm not entirely sure why I started poking at this.  I think I got mad at
> the dest_map code, and then things snowballed...
> 
> [...]

Applied to kvm-x86 apic, thanks!

[1/9] KVM: x86: Drop ASSERT()s on APIC/vCPU being non-NULL
      https://github.com/kvm-x86/linux/commit/a4978324e4bd
[2/9] KVM: x86: Drop guest/user-triggerable asserts on IRR/ISR vectors
      https://github.com/kvm-x86/linux/commit/37187992dd82
[3/9] KVM: x86: Drop ASSERT() on I/O APIC EOIs being only for LEVEL_to WARN_ON_ONCE
      https://github.com/kvm-x86/linux/commit/ca909f9ea8cb
[4/9] KVM: x86: Drop guest-triggerable ASSERT()s on I/O APIC access alignment
      https://github.com/kvm-x86/linux/commit/9eabb2a5e499
[5/9] KVM: x86: Drop MAX_NR_RESERVED_IOAPIC_PINS, use KVM_MAX_IRQ_ROUTES directly
      https://github.com/kvm-x86/linux/commit/4d846f183897
[6/9] KVM: x86: Add a wrapper to handle common case of IRQ delivery without dest_map
      https://github.com/kvm-x86/linux/commit/1a5d7f9540af
[7/9] KVM: x86: Fold "struct dest_map" into "struct rtc_status"
      https://github.com/kvm-x86/linux/commit/5cd6b1a6eebd
[8/9] KVM: x86: Bury ioapic.h definitions behind CONFIG_KVM_IOAPIC
      https://github.com/kvm-x86/linux/commit/59c3e0603d86
[9/9] KVM: x86: Hide KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=y
      https://github.com/kvm-x86/linux/commit/fd09d259c161

--
https://github.com/kvm-x86/linux/tree/next

