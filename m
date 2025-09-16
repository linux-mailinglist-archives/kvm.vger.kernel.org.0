Return-Path: <kvm+bounces-57650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA2FB58938
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3AE2A3948
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3711C860B;
	Tue, 16 Sep 2025 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ntBJszff"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AA472639
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982364; cv=none; b=cKD7ZnPuCwtw0cRHKfbiGp7LWJHvRC+X2bw75n8jnKglsozXmzOiHHAfHMKq7ic/u9VniAmY1Tkh0oGvnfpQDnYZnQdrNs4a332duQI02NmOqgHGbaWbwleXV+edm2rKYl77Brbc4GrVMlBylG9n5GBvvnsOtyfevAtWpkEOjPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982364; c=relaxed/simple;
	bh=1XEahfw11WB7naFPbozfbOMsJ9u8Y82L3C6vT6vKLRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=ZEFFmNqF8M8XPUd5vM0P9fLRIuF71GW7/P7z/r+78ZUHO/fxAKNG/2RrqyfeeXAp4ZHluEtUNPUIVsGjPEEFH7XRVJI3b4SUGRGN8AXGlty2s9T4uOEp0DyKtLfHYM7bITm4A+wJOL+fnckFmeG49N21mUifxSRAacJQhUV95xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ntBJszff; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4f93fe3831so6272616a12.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982362; x=1758587162; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tCHKfv6VFh/5PpKS2D0UKIipcdXrypGgn90uGCY5r2M=;
        b=ntBJszff/muNrIl9pjK7jSm146hlKM6YGfmzEZaGAx/1t6qypnjUZ15aKmhOc9Td5Q
         5j0/Y4PdHg6NfF0Cds95vYFnekjqfc30QKQhz8ElUnRxRUg/WCLBrEt6nh9RzcwA1Ebc
         mD9cdvb8D3uhPBxkJJDN7znn3P1GX1FUWb8F8LUgdE7uyfPaZKb/DeCXjajHtIpnJsma
         m3w5adOMBUg7kV6ZbKLWxvy7K5dOhlEDTM6NfIeVXFgcfkV+Cz+V/QyRl7w90A8EIcfI
         QnJVpjVxZKXCsg9S0t5bJDaW8e3DAU7xFSO3vZ4CZ2BrO7yB66d1b+DtVZyFaWIYV3xE
         j/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982362; x=1758587162;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tCHKfv6VFh/5PpKS2D0UKIipcdXrypGgn90uGCY5r2M=;
        b=ShDZ3+eV/AXVDmUrcg1yEemhJnmi8RES52oPhs4Uhz/yaIcE5j9wrEG2AQvnGWsCo1
         jBa7ARgawWJv3Ja+Rcyjsg2xLr/xjBcc17a4vpOYZ1VzK0DP+Ui871qEbyaj9JWCK9IC
         Hw4h84MiOVbidXu8zsND82ge4ndi11tZfJbx1bQlHdPaiXuDY+MpDqxFsMkMbWmeogqx
         YLDtD5qrFJVp0DRPDDPazaKmkLuwBgecPL4LcXtghTXFWTP4us2jDaDWuFwUB0gVxCeO
         mQVevMYVO4xkwJc+PvB9nZRYGFhwErOHA11RCr77nYBEEQWVAGYE+wXpDBJVoVh1cKWB
         YyZA==
X-Forwarded-Encrypted: i=1; AJvYcCUS8LlzzhKi0oaJVaadkmGkX4Vw6qhSvKeiiBd74YCMTjzzAhqp/7k99S/ss8isTZB6JJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJHdgknDiR08ILsnT7xpBOjpoCr/FZn8n+oW+KPpYRGx9/zQfO
	9bJEqWOtO7TyL1qGjpSpDq09bwdr2lDi2I48tPK9+fzqEYq4QmjVtnLvE1UV0O9n87StgHra/Kc
	ZEp4CKQ==
X-Google-Smtp-Source: AGHT+IFK7yZRGtN4+sWH0Tl1jTnKIUO/gTV4gtNXMz8IEc3dZig0WD1nlGNQNEu68T5bSy1NdK2EZzPQr8c=
X-Received: from pgcs188.prod.google.com ([2002:a63:77c5:0:b0:b4e:65c4:b5c8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:258a:b0:251:9f29:4553
 with SMTP id adf61e73a8af0-2602a49d9e5mr17497882637.10.1757982362155; Mon, 15
 Sep 2025 17:26:02 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:33 -0700
In-Reply-To: <20250722110005.4988-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722110005.4988-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798205117.624172.7341980262867703436.b4-ty@google.com>
Subject: Re: [PATCH][v2] x86/kvm: Prefer native qspinlock for dedicated vCPUs
 irrespective of PV_UNHALT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, vkuznets@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lirongqing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 22 Jul 2025 19:00:05 +0800, lirongqing wrote:
> The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
> physical CPUs are available") states that when PV_DEDICATED=1
> (vCPU has dedicated pCPU), qspinlock should be preferred regardless of
> PV_UNHALT.  However, the current implementation doesn't reflect this: when
> PV_UNHALT=0, we still use virt_spin_lock() even with dedicated pCPUs.
> 
> This is suboptimal because:
> 1. Native qspinlocks should outperform virt_spin_lock() for dedicated
>    vCPUs irrespective of HALT exiting
> 2. virt_spin_lock() should only be preferred when vCPUs may be preempted
>    (non-dedicated case)
> 
> [...]

Applied to kvm-x86 guest, thanks!

[1/1] x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT
      https://github.com/kvm-x86/linux/commit/960550503965

--
https://github.com/kvm-x86/linux/tree/next

