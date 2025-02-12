Return-Path: <kvm+bounces-37932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 816A1A31A54
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1FBF1885432
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 00:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81F18F77;
	Wed, 12 Feb 2025 00:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ke07xwkV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A662C4C81
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 00:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739319530; cv=none; b=o2BrjFQQtkaHsUOoaBH/1dRP/GkHd+uJmckUqRW0EjYaNOyiCp5qKm+5nLhDMZoJ7Pj0Fd3tGeCD5Bpl0edQkDGmTm0zdoN+sF/jGHtJuMNHKon6sTXI/EEh9OZoQ3SUK5QLc1Qh2bo0+YQ54Fuo9Ud8FJusZ5Rk+VwnN71ygms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739319530; c=relaxed/simple;
	bh=+l7K6VjiRFghWsRe072G6fJM+1I5/M+ylowLUEu+/Mk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bY2XWAP4PpT3ZykCTxN+JSXJcufecRK/Zsg8mMi3lcP7BWPGOqS1qKXny2IOauIUD7Cr6zs0IZ9ecn7+bE15m/qTcGZGGAzGUuZqkY7HsehyivCMzfwNGAPqsp7WlFL5QjJHJ4+srgunqMx0qw6u0bv/LAGzb1bKI1dESIbt1FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ke07xwkV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa228b4151so9890672a91.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739319528; x=1739924328; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RspAWYFZn5in67IIy6EsuqJTvH+51nccfPJMvXzCAaE=;
        b=Ke07xwkV44PZvam3yHkhbioYZfWsPFn3sg781v9TjW1FGcU1iKD/nmT5SbhLHQpWMe
         gYsYbIdPmaGYh19lNsXAkb7qbzErv6TPVlCruMz3fByTkXYPWBPyOYguwaWknpwaBJO2
         Shi3RdptewsQqUveymXHLGhZqfCSYn6Bd/KluU6CxiYaQ6cA5rIKRW/VmtnIlIuns9sw
         RODwYesLvtfpI7oGBSIPWN6I00qHUO9UT3N1xD1AMQvgMqEWQjSRBqu45UaEKhEiTAHE
         db/D0Gqgzf0JWa0wRxvNkzoUwSKPeNQCpqhdxvUemCAR9J90n98z6dieKx8Gw5G2bU7n
         qWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739319528; x=1739924328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RspAWYFZn5in67IIy6EsuqJTvH+51nccfPJMvXzCAaE=;
        b=bm5JhEpFRtTcoPCHXMKphA1wU7CCAhEFJo8nRvExBAA8DuOK1WhUTPdzkK4wxU8kZU
         BVUhZmeNjIztsmNT0GPqgYEuQk95drNK/W0JFqREsRekzWWC+lT/CtxS9BYXnNpenRqn
         ODFe9T+XK5oHfgpCH7AvvEDWlV9P4QUyePrXWIgfeJmWfjHjK9AVMnhezpWjKndIzQku
         3IQaaCm8KyUINMlJOlVI4BqvM9+9sJlrEM5YHk+v3UH+Bd0t2Zf0E3LUw5UVDwknItsB
         FThEA3UwmO4RX87ajvgdHA9DqWWrbKtUh2WEEbvDC6cYhzZMGFcjeUaohVVhxgyipPYM
         i1oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX6WrW49T90RQba5fhGx3oU4LWYC3IxtZWVjGZjLXF8mmdkH2Qb56iZkyXbEcqi3XVA78=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiaJSB//zuDoj4xLElS0Dty9PeLoVBjAf9X+m9tiDTBYWGJ/Y/
	AWIOufn+QxKKoW7Ui6ib92WSJJcblXiI/0eb04drusDUKQW161aeqO9v8/b9aOR4aCorrGPLbgQ
	Xng==
X-Google-Smtp-Source: AGHT+IFCpz8EmxfNDAUtYTwudSatr8YDUMXPlv0oG/GzrXJKHlIs6dxLBKKmdyZ0PoX7BbqJ9KgmsB0bAb0=
X-Received: from pfbfa13.prod.google.com ([2002:a05:6a00:2d0d:b0:730:98b0:1c58])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:348c:b0:728:9d19:d2ea
 with SMTP id d2e1a72fcca58-7322c39d1c2mr1889633b3a.13.1739319527971; Tue, 11
 Feb 2025 16:18:47 -0800 (PST)
Date: Tue, 11 Feb 2025 16:18:46 -0800
In-Reply-To: <20250211025442.3071607-7-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com> <20250211025442.3071607-7-binbin.wu@linux.intel.com>
Message-ID: <Z6vo5sRyXTbtYSev@google.com>
Subject: Re: [PATCH v2 6/8] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Binbin Wu wrote:
> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	u64 reg_mask = tdx->vp_enter_args.rcx;
> +	u64 *opt_regs;
> +
> +	/*
> +	 * Skip sanity checks and let userspace decide what to do if sanity
> +	 * checks fail.
> +	 */
> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
> +	/* Error codes. */
> +	vcpu->run->system_event.data[0] = tdx->vp_enter_args.r12;
> +	/* GPA of additional information page. */
> +	vcpu->run->system_event.data[1] = tdx->vp_enter_args.r13;
> +	/* Information passed via registers (up to 64 bytes). */
> +	opt_regs = &vcpu->run->system_event.data[2];
> +
> +#define COPY_REG(REG, MASK)						\
> +	do {								\
> +		if (reg_mask & MASK) {					\

Based on past experience with conditionally filling kvm_run fields, I think KVM
should copy all registers and let userspace sort out the reg_mask.  Unless the
guest passes an ASCII byte stream exactly as the GHCI suggests, the information
is quite useless because userspace doesn't have reg_mask and so can't know what's
in data[4], data[5], etc...  And I won't be the least bit surprised if guests
deviate from the GHCI.

> +			*opt_regs = tdx->vp_enter_args.REG;		\
> +			opt_regs++;					\
> +		}							\
> +	} while (0)
> +
> +	/* The order is defined in GHCI. */

Assuming I haven't missed something, to hell with the GCHI, just dump *all*
registers, sorted by their index (ascending).  Including RAX (TDCALL), RBP, and
RSP.

