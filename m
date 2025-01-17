Return-Path: <kvm+bounces-35874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7C3A158E0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:14:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6CD164775
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F0A1ACDE7;
	Fri, 17 Jan 2025 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h+3r3hUD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06513C9D4
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737148446; cv=none; b=AmHBzFbGg63nptmveEd+PS8uea6p1KRXYjxMP6t5aMuTzjtoT7hJ1CVJXeWUyheBf0VYaEwja0emzAQHQSm9rtdjrEEAvVquZLl6Osx2gieDW9nE39E0BZNV4VhUz+5WsovKhY1gJVqBC6eLw5h3KNWsYgjfgfdbdNHH+KlbK0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737148446; c=relaxed/simple;
	bh=ikVN6on2dhX26t8BcZAfBvyHKN466ydU/FtaOIQK14E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GPFZGNmMnfRH4kmYaAI/m+kNnEr7y78Zr3kkJCeaxgfJWzJeapftKG4dGB0ZrzyPkfE316On5XLZqGGYwRIYfZW6NQNUfQOlq3WKNex2fT/YBBlLGS5ygLjdppeQMPhMy4LO7rdM1mmzHWRt57fKDBX9/rriNh3E3JcoXqKvYj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h+3r3hUD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2162259a5dcso77445775ad.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 13:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737148444; x=1737753244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lYNnIYqKlVaCW5yjh3/vk4Rk7LFokJ1iex20vKR2caw=;
        b=h+3r3hUDGCfDdoZMXyVm6Ayna6TGdMCuyp3RV8qncX4hvEt4TdrJ2V0taD/AmffSZk
         rhsqyjbwrSCmeKOrDj3N4++cDOyHZI/aeu6fPJCJkNiPRqfyY1ssp5cSa/+63BMAfMiA
         Mj3xjwhcCcGJ+dRRK7JBQZe0FPQ1xF4dpreBPEYWmQxdsjSvxUi5r8p58yrzBKJ4r9qe
         162tpLjokPdBs9yd4M7nucz8dGXswmuTO7mKpvvltZT1OzBuK01rBxXhf1mgENI2eknX
         SnVoMG8PyYhGlRCOZt87jcDy4b4snnGWQsDRbVpk9r6zvky9bpWp300UlL+lIkupx+8c
         ZifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737148444; x=1737753244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYNnIYqKlVaCW5yjh3/vk4Rk7LFokJ1iex20vKR2caw=;
        b=QOlrvc+D0GQmFEtoUwd1zRCSE5Jk/STr7GiayvWl2BmL8rB/hl7bMxP/Ivk2YCsZEL
         5uVdpVdJeVTj+Q+WI1bG/8qe37/nDoWP8sxbSq7b3s7eDcqleVB5HhEmfEnFkBo8YqaN
         vE5obmgH16jvAFc0J/mTooTrYmreoqk02iPGTOkYLzgKPW+lhiQ6qfcaevnW9evT9OTJ
         pHdIN/smDAOs818TsRvg7ONqnQkl58FAK9KaPP8Z8AhxhUYyJ2xU/qX3cjDpkP91+xog
         qqL2TQTwOVx2LNOukzEC8DrqVQSJ5tGm9brWwIRAl0CVKm6txHM+/I1P12v1TP+Y8DHY
         o1KQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY4nNY6EcB0ep/RepiwePwYF9UqZertTBa4fiC2J6PzeUD1vRjHvzDy+pqoThEXpUWJKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YznG4kOyI6+lN3Dgn2XhRzxVeUhkvogz0ssOvTPeJwXzCodEOs7
	M/3YXRIQRYkO2Htu7wee+sPKsHujjA76RpNYx5I9WgnldIJelWPOfDzxsu7jeF7DEUteZ6rDCgm
	Aqg==
X-Google-Smtp-Source: AGHT+IEwPPyP1BehuVb+1cCPxwwZEOtdZtF8brXlcwf1F/RI+bUJs1pvun2GzQVInlKAr7ZQoK8oVPzrUQ4=
X-Received: from pgf9.prod.google.com ([2002:a05:6a02:4d09:b0:7fd:5437:9912])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f96:b0:1d9:c78f:4207
 with SMTP id adf61e73a8af0-1eb2147d3f9mr5832183637.11.1737148443850; Fri, 17
 Jan 2025 13:14:03 -0800 (PST)
Date: Fri, 17 Jan 2025 13:14:02 -0800
In-Reply-To: <20250113021218.18922-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113020925.18789-1-yan.y.zhao@intel.com> <20250113021218.18922-1-yan.y.zhao@intel.com>
Message-ID: <Z4rIGv4E7Jdmhl8P@google.com>
Subject: Re: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler
 on RET_PF_RETRY
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Yan Zhao wrote:
> @@ -1884,7 +1904,24 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>  	}
>  
>  	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
> -	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
> +
> +	while (1) {
> +		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> +
> +		if (ret != RET_PF_RETRY || !local_retry)
> +			break;
> +
> +		/*
> +		 * Break and keep the orig return value.

Wrap at 80.

> +		 * Signal & irq handling will be done later in vcpu_run()

Please don't use "&" as shorthand.  It saves all of two characters.  That said,
I don't see any point in adding this comment, if the reader can't follow the
logic of this code, these comments aren't going to help them.  And the comment
about vcpu_run() in particular is misleading, as posted interrupts aren't truly
handled by vcpu_run(), rather they're handled by hardware (although KVM does send
a self-IPI).

> +		 */
> +		if (signal_pending(current) || pi_has_pending_interrupt(vcpu) ||
> +		    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)

This needs to check that the IRQ/NMI is actually allowed.  I guess it doesn't
matter for IRQs, but it does matter for NMIs.  Why not use kvm_vcpu_has_events()?
Ah, it's a local function.  At a glance, I don't see any harm in exposing that
to TDX.

> +			break;
> +
> +		cond_resched();
> +	}

Nit, IMO this reads better as:

	do {
		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
	} while (ret == RET_PF_RETY && local_retry &&
		 !kvm_vcpu_has_events(vcpu) && !signal_pending(current));

> +	return ret;
>  }
>  
>  int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> -- 
> 2.43.2
> 

