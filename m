Return-Path: <kvm+bounces-34110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73AEE9F72E7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669C5188C7CA
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C487198833;
	Thu, 19 Dec 2024 02:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jAs8cw2x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC521531C0
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576302; cv=none; b=KUqs1yVRTeg4yAXHqWdKqbnyhSMxv/VtvyPAugXaOt5wK5bL4D45gF4xElc8i27Iw4ywZtbJSmIGFoWVgeiF8fQPmL9mvkgOg9nXpyRdtr7/rYiT80ij62TsjQHeAbxlbvuYQwPgG3C5IJKF7KaZPa5trVuKlgIbCoAU/zIDLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576302; c=relaxed/simple;
	bh=nXWZn1S0U99eouCzW7/PuHOUFlEV74e02m5c4wP2tDQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bpQjUnNiLYShrHCMZNSNuiTzrmactEd8nX6efR5x7/o8AnW3ssAwBbRn4Pu4AHhI8/TsC3KWD/ztQr/4Y35LoOENj850TYjx7TXWSsAfDFsoSoqu+EYrgGoAmwI2Wgw/UUT/pajj01x5R7ghVYQWLAA3or2/bgk7RE9yLu6+NBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jAs8cw2x; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-727c59ecb9fso335594b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576299; x=1735181099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/9zsofJgW1OlId0uPih4ySMlLWOOcDXwYCUYVW+e248=;
        b=jAs8cw2xHI0NkOqQqhBp3YA6fU+P8xbYzjikaruIixopd2wAvwLL6MTaNMH8UUSVM3
         nn53tUHhq8uwY8O9Jpmsi91+fR4hL3DpEJaDqCvcwd4NC5WIxntj9uzA1kCXYOJNdi5V
         WSPbdXURSH2hFuf6qklx19wghxlo1nXZJSzLbv1X6YRmej2Zd+1sJrp2PjrDyZ/19Rl7
         jB1AuLOgHAASRba+C+9xFPFhciD+DRYAQcLx/pqDNgquN5UMwAg8aW+wDBcd/qp8ohAo
         0b4uHOqiXyWuRBkykcNPMeGQaV9nkOjim+bzcsIeOT1JEdqQ92XHQyZ9qdQcLMDc1fB6
         YJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576299; x=1735181099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9zsofJgW1OlId0uPih4ySMlLWOOcDXwYCUYVW+e248=;
        b=ISHXcCiOxHu85uMEl76qWGr92djVqVj7s/Ra0hZ/vQTbCwbWYZqTVsBITYAmuQbyBt
         p1EaHROmqcVDCbJEAoWt7SgpsnGWljaaffJWpXtGO8W7lb1U3T/D2SLviqD0DDePt3jm
         y1MYfTIDZHPIwnktiYL2LxJn8hl+lkNybL9TUOoynLVGcTNfKFlI4KJ1PiV6yUFFD8eB
         Je01KKF/xaaVUJw/wwRJGfWqtePZFw49ZaALczHLQvIYFqywvuCJhEObHOS6yW0ECbQh
         CgTIFPdHI8GmQh3gQrCK9pJ0xZLJNdDpojEJShTPNoTVk0UlnvFNFTmbxDtKm6ucvn+x
         6Rlg==
X-Gm-Message-State: AOJu0YyAoCFjbcrIMbZnUJr0fotu09X7WDxnVm7YEHRoGKZVtEqiMvrB
	dOF8vi1E5bU+afMh/35U5NuoxdkvJY3ahceATaKDyFgKgqW7Pd0opBNk8FVY6rsT7T0ZmdeZj5b
	gsw==
X-Google-Smtp-Source: AGHT+IFZLizQLsIbQpvcG5vY8HG70h87iIWEzlsV8U2/H3IOCqt2Ei9hxczhc8zrdpvMjr0ptqyS6zR/wsw=
X-Received: from pgve19.prod.google.com ([2002:a65:6493:0:b0:7fd:2ecf:a784])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a5:b0:1e1:9662:a6f2
 with SMTP id adf61e73a8af0-1e5b487d810mr9175584637.35.1734576299106; Wed, 18
 Dec 2024 18:44:59 -0800 (PST)
Date: Wed, 18 Dec 2024 18:41:04 -0800
In-Reply-To: <20241101191447.1807602-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101191447.1807602-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457535127.3292703.12404941670560786467.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: nVMX: Honor event priority for PI ack at VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 01 Nov 2024 12:14:42 -0700, Sean Christopherson wrote:
> Rework and cleanup KVM's event handling during nested VM-Enter emulation,
> and ultimately fix a bug where KVM doesn't honor event priority when
> delivering a nested posted interrupt.  Specifically, if there is a posted
> interrupt *notification* IRQ in L1's vIRR, the IRQ should not be acked by
> the CPU if a higher priority event is recognized after VM-Enter (which
> unblocks L1 IRQs).
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/5] KVM: nVMX: Explicitly update vPPR on successful nested VM-Enter
      https://github.com/kvm-x86/linux/commit/637df11290b3
[2/5] KVM: nVMX: Check for pending INIT/SIPI after entering non-root mode
      https://github.com/kvm-x86/linux/commit/3d0e20e45378
[3/5] KVM: nVMX: Drop manual vmcs01.GUEST_INTERRUPT_STATUS.RVI check at VM-Enter
      https://github.com/kvm-x86/linux/commit/2732f6a7ccee
[4/5] KVM: nVMX: Use vmcs01's controls shadow to check for IRQ/NMI windows at VM-Enter
      https://github.com/kvm-x86/linux/commit/1a265986bff6
[5/5] KVM: nVMX: Honor event priority when emulating PI delivery during VM-Enter
      https://github.com/kvm-x86/linux/commit/ce5cdfb49813

--
https://github.com/kvm-x86/linux/tree/next

