Return-Path: <kvm+bounces-61480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14993C2005C
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBE4719C6407
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7546831D375;
	Thu, 30 Oct 2025 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GKM4+hre"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16963314D27
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827383; cv=none; b=NFUnuEPTEL7VzQHgnH3sVDfH+qvSHf0FmsmkDokNcHJNtdfis/0S4vn3gcpKQ45NvbdcjV+ykEcRO7YPPoKhaT1f30D1IGA09XpX7ICTh+dJ04LxzPwu3q5LSYl2cCUEq6XJhVOn18HtoYHEtY7Qij2uemsiczDRj00UoHzJBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827383; c=relaxed/simple;
	bh=6glx9woDpeCvbycK59nFQ0fRq1+1rRnPJVeZNMkmik4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f0VSmJNp5Rs2BUKjtZPGZi3aSAbVd01q1UXDg8uQIG8Bmd2YLI9uAV0hU0wRtO8mkPuHWbjxfp5tNYBJ6xRe5+48Ys+amBA4nGJ2gm7e/Jb1s2RlELx8F2buE9KcZopAX385DLarv+pLU+NIAiflo7k11vZFJU5NxHrPwHs2iNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GKM4+hre; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-471168953bdso8277395e9.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 05:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761827380; x=1762432180; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6glx9woDpeCvbycK59nFQ0fRq1+1rRnPJVeZNMkmik4=;
        b=GKM4+hredi7LZ9np2n26q+7HwrErNmIxpbF2BPd0y3qxRV3rENyp8SK9UkdP7xr8Ye
         psaRF5cvB/OZWO8VGRBYEAC6KBGCjZXcapEC9FanT09SoRFyYpATPTCoiXE/FfBTrVzg
         xhQhi7VOEChV1h+ZbHlPO4bJG0mtSGLNVn/+WNvu7tQBMiwNRZQZVqj1/bLShVTJbK5f
         PcPYyl6t7k6hcJWGoYrlTUknMR1Qv57oubrDPIskZ/BKV4kbn3GOUBcwv2YXDYxvxZMK
         8BfWrmKEc3/jNI7P84RqzzMftDQmEfLZop/WQS+/cY/irBZ6AohLUwMfBB9Hn1aZzja6
         lWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761827380; x=1762432180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6glx9woDpeCvbycK59nFQ0fRq1+1rRnPJVeZNMkmik4=;
        b=KqOJLfOs8Q3Humv990iV0PuG1slDMZZ0ZI7AU3buaxvug1aErluX27uqHHwiqgcG1o
         15gbgDg4AI51JffpqswWyYNqSbN98SkUs98crl0YQSkL9lQS26glpmeta1FpQY/j/31D
         dQ1FP84Lp/JCdL9xiaPrARi3KR52s+QzbbTzQNVjOzEyR2+ZjiLsrtU6mWK5aOiGUGhC
         CCw1x3OoznxK+kCDarZG3+5qGMX1Ur8WShw93Fskhwu+67WciS80Jz56JsUaFO3Z90hY
         Ux/Ey8B1YnTmwvRX/19lmvJk+rN2CAbFyrUkz4nfyqhTDe1WmCf8V9sgI/PzE7SofWeb
         H77Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2aAw9LG0GARtV1gN9qxQdyJ4VeCL2DvlZT57Xx8gv30UPIPpPYu8DlxDS6fIdS4XohK0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEhXqXjcpdxEe1pby76uHad60o+N+yhI9pE34AXwqsv2myUfN3
	lQzyzEuiONeKUKIdgxDsx/JyEJf23dsL+tsedBz4NAW3eHhnO+qvsfOU928m1f0TYXYw4UA9Mld
	zdsw9mq8iM5U4Sw==
X-Google-Smtp-Source: AGHT+IFJU30jjrRfj2rHmfFH1yC5PvdCbuzWZP+cAv5nh5fYXFv6mQK1AGS8WOMTzYBA7PItmqNim7cIM2VNHg==
X-Received: from wmvx1.prod.google.com ([2002:a05:600d:42e1:b0:477:1681:b2c8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:ce96:0:b0:471:611:c1e2 with SMTP id 5b1f17b1804b1-4772622261fmr23212855e9.3.1761827380512;
 Thu, 30 Oct 2025 05:29:40 -0700 (PDT)
Date: Thu, 30 Oct 2025 12:29:39 +0000
In-Reply-To: <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com> <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDVNOKPKN4II.33NWK6IDYPRFD@google.com>
Subject: Re: [PATCH 2/3] x86/mmio: Rename cpu_buf_vm_clear to cpu_buf_vm_clear_mmio_only
From: Brendan Jackman <jackmanb@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, 
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> cpu_buf_vm_clear static key is only used by the MMIO Stale Data mitigation.
> Rename it to avoid mixing it up with X86_FEATURE_CLEAR_CPU_BUF_VM.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

(except the build issue)

Reviewed-by: Brendan Jackman <jackmanb@google.com>

