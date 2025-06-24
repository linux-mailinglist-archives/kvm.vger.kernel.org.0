Return-Path: <kvm+bounces-50539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1FEFAE6FD0
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EDBA17B9DA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CADA2E9738;
	Tue, 24 Jun 2025 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yj/Bfpoy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7508522259F
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750793917; cv=none; b=cT9KWhgPFUB1D8y/SU58FeiMDihjHiuAl5CHlno8u5cJm2nzt8RF9a1iMofTXaw2H+1AJzynOkzDHh+NHOsPCNITxIuYCD2uqZeJuBGYQk77anrERzCNdCvIv5VyfJ2OtbqOSTrlIzF0qGx85Z56CVeaq/ct0ElKeJcT5ity9g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750793917; c=relaxed/simple;
	bh=twptM5Qxux0nrd1AK+HItqru9u5lEnVGglh7RnVcqZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dgfQw3O59BTCKkPaaTtHrsoKab4pVgtQUgvgncTMrFq2SMwgjdhAnoGHyCZH6M4BvGCWpuSRZg8Kc1XHYU9wiMNyItduyMoU+vJj4yKq6z29EcrxJfXkBJEJQL5cx5GUV6WBsQp1gnPpbCMiBtPp1FlhXAY6ctBHq0oz2zpxB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yj/Bfpoy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313c3915345so1413388a91.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750793916; x=1751398716; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MbmTGb7rJSpyBX4d80hPoeJGIxezKRaodgXxCjrASGg=;
        b=Yj/Bfpoyb05A/K/RTk1W6rjmW+FPV/lHf49ttHk+WfBtVv3hRFyOXpDSa/h+q3XKY/
         PbXvzJ217Y+9TQjiRnKIhTXP48UH0NFFNAVkeKa+WFFWhPWq/qBpUOK3kVJltEtFKWEa
         XfJ9LsMF5PZ152+yInH/9XJABi3Ml7BMAs8pKsW5f7DJHfmqCddPa6AjR9mTwtcKubOI
         4Gyh0VukXMp6NnqRH5OwqYcZMljsSR+zhQsav+wjvo5rYdtVzrRxzSTslHYAv5NWEk43
         o0+7lVqSrlGgHGAEQTslgvTbCX694Mx7bjll+0U0Mriri88UAYweotkkuFxKYBPptxD/
         AivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750793916; x=1751398716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MbmTGb7rJSpyBX4d80hPoeJGIxezKRaodgXxCjrASGg=;
        b=nAz0m6PVaD2NPLnxxh89rzt15ziM0n3N/no/mdqhyHjPuCxx0Phlrxo8HTaBFfH+m8
         u2y/HJMzZvL2682XJBk24gwtmRO9YJp1E98cqRqjP0OvavYMc/L5SbMiSAZjaxPuCEKB
         kybRo52vryXcfWagSP8niNQWIPFUEvSbFn/5L3OnB1O61SEtm+Q+C8S1y2GAsskUPgW8
         PW759LGcSIAibirg5cNWdKsASiM1caUv16RZFR/QPVMls854sG/kJfiC6eEPEMHWVkct
         mjJ4Wej86iJKmYDJ4poIeI9XJrJ+HtHwZp+HD41B+T9ePNbaKxL57IhSZ82KPwpqsMI4
         pDqg==
X-Forwarded-Encrypted: i=1; AJvYcCV/dCp1myKmMW0NYxHT+e4ExaahB870c8/9jwivq9fnKsEBLmLEVzOoxmFdTbo7OT3NwnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuJKMCF8T4NQHP46wEGIbxHKIXrF10kCR8DAL45aXwv7w1xCi8
	8O5osEKW18Ss6G+8WOVO0/fotZFmc9d4oFDJP22XrrkmO/iSzICUWinsun79PpWrzwcuSYblcMq
	1EbL2mA==
X-Google-Smtp-Source: AGHT+IGZwhCBQvNu/HBaFdGHerB63N3HJcv/7dELpqe76tf9E/2jghrTw8qT08hT6Fhiaf1CGBCMscO32hU=
X-Received: from pjbse13.prod.google.com ([2002:a17:90b:518d:b0:311:7bc3:2a8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2cc6:b0:313:db0b:75db
 with SMTP id 98e67ed59e1d1-315f26a365amr131836a91.33.1750793915772; Tue, 24
 Jun 2025 12:38:35 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:16 -0700
In-Reply-To: <e489252745ac4b53f1f7f50570b03fb416aa2065.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e489252745ac4b53f1f7f50570b03fb416aa2065.camel@infradead.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079198224.513744.6336161745259606181.b4-ty@google.com>
Subject: Re: KVM: x86/xen: Allow 'out of range' event channel ports in IRQ
 routing table.
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Ivan Orlov <iorlov@amazon.co.uk>, David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 08 May 2025 13:30:12 -0700, David Woodhouse wrote:
> To avoid imposing an ordering constraint on userspace, allow 'invalid'
> event channel targets to be configured in the IRQ routing table.
> 
> This is the same as accepting interrupts targeted at vCPUs which don't
> exist yet, which is already the case for both Xen event channels *and*
> for MSIs (which don't do any filtering of permitted APIC ID targets at
> all).
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/xen: Allow 'out of range' event channel ports in IRQ routing table.
      https://github.com/kvm-x86/linux/commit/a7f4dff21fd7

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

