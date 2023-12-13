Return-Path: <kvm+bounces-4367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA89811A4F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86E1A1C20834
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72123A29E;
	Wed, 13 Dec 2023 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f3YD/9f2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23749B3
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:01:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbcd721b366so442145276.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702486880; x=1703091680; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tBbCvvAbfrdh23iT+WwFecyH8e6C96pOJEulkEptHYE=;
        b=f3YD/9f2F1vfPHFmM9wYBfYZFdwfWMm+ekF8Km1XgAbVEEzPJdSmTPFWRO6rkUqiRx
         3isrpcBEc0R5vgiCikWWCeVy7ZnM24qlbfKxa5/Wu1rEvv2ha5UiKOfEVtwkj1hXWJnc
         JX67IZrZbK3EaNsDHByAozeDi0+nDvG6zOy46YIfNFU+VHQrH99HcJpkEatWJ4c4mSMX
         Yq9QIa7bjn/58FG0gBFe0TzUAvXI8DKfvFRdfrqcZ+w4x/XpiQSRqccOcwFlnQ9n+Sep
         xx8XQAmxHivLYV51Qwm+v5zezjoPYeBiAYBn1OFnlwMM2RAuzwJI7V75NLv0Biozr1NH
         +RnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702486880; x=1703091680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBbCvvAbfrdh23iT+WwFecyH8e6C96pOJEulkEptHYE=;
        b=Hhc+hTy4eIb/hI55tUcgCW9RzHcK+f6X/R2vrjFVZcANMVYK98ioc3ouNvuNxTMJE7
         JGBf7y8BEqTdadvldxeaJm4zdaPU3e5PyXBBZGZcSQukNoO9ZObox5v+ewkdRqd6AwLp
         z8Yj59jT5yh9V5FKtho3Lv0OiVy1Ae6yn3EMN7aQd416jxEPAgsdMSEN0SFnq415FzeB
         c5un/bEJMC+Rh88m+nzF7ahcbeo/LGVbUZ7KO6m2KcAG0oWHNchcI/3w9odbO0EHIOpT
         TaU45yVpm11656744W8GpfdxXanVifXCy0GsbQT2aDq3u9UaXU/ZlYgJeIy8nHJ4g4+U
         Yuwg==
X-Gm-Message-State: AOJu0Yx9ZaY6Y+9Wl8pHOW3ZfnxfavPqa3eucLOnP41SaFcSjrbNTP7k
	hmbuICTuqJWAh3WxISnPKPyvfrBlSew=
X-Google-Smtp-Source: AGHT+IEyZ+uONV8Dhhp5xu8cUqXpYmvSlrh5N8bZOFr3e6ylPDRYbfi5xXr7UbRWLhU/SyrWbxX3k3h8RAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:14d:b0:db5:3aaf:5207 with SMTP id
 p13-20020a056902014d00b00db53aaf5207mr135703ybh.3.1702486880334; Wed, 13 Dec
 2023 09:01:20 -0800 (PST)
Date: Wed, 13 Dec 2023 09:01:18 -0800
In-Reply-To: <0591cb18-77e1-4e98-a405-4a39cfb512e1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231206032054.55070-1-likexu@tencent.com> <6d3417f7-062e-9934-01ab-20e3a46656a7@oracle.com>
 <0591cb18-77e1-4e98-a405-4a39cfb512e1@gmail.com>
Message-ID: <ZXnjXuLXl4mfVUJC@google.com>
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andi Kleen <ak@linux.intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 13, 2023, Like Xu wrote:
> 
> 
> On 13/12/2023 3:28 pm, Dongli Zhang wrote:
> > Hi Like,
> > 
> > On 12/5/23 19:20, Like Xu wrote:
> > > From: Like Xu <likexu@tencent.com>
> > > 
> > > Explicitly checking the source of external interrupt is indeed NMI and not
> > > other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
> > > positive samples generated in perf/core NMI mode after vm-exit but before
> > > kvm_before_interrupt() from being incorrectly labelled as guest samples:
> > 
> > About the before kvm_before_interrupt() ...
> > 
> > > 
> > > # test: perf-record + cpu-cycles:HP (which collects host-only precise samples)
> > > # Symbol                                   Overhead       sys       usr  guest sys  guest usr
> > > # .......................................  ........  ........  ........  .........  .........
> > > #
> > > # Before:
> > >    [g] entry_SYSCALL_64                       24.63%     0.00%     0.00%     24.63%      0.00%
> > >    [g] syscall_return_via_sysret              23.23%     0.00%     0.00%     23.23%      0.00%
> > >    [g] files_lookup_fd_raw                     6.35%     0.00%     0.00%      6.35%      0.00%
> > > # After:
> > >    [k] perf_adjust_freq_unthr_context         57.23%    57.23%     0.00%      0.00%      0.00%
> > >    [k] __vmx_vcpu_run                          4.09%     4.09%     0.00%      0.00%      0.00%
> > >    [k] vmx_update_host_rsp                     3.17%     3.17%     0.00%      0.00%      0.00%
> > > 
> > > In the above case, perf records the samples labelled '[g]', the RIPs behind
> > > the weird samples are actually being queried by perf_instruction_pointer()
> > > after determining whether it's in GUEST state or not, and here's the issue:
> > > 
> > > If vm-exit is caused by a non-NMI interrupt (such as hrtimer_interrupt) and
> > > at least one PMU counter is enabled on host, the kvm_arch_pmi_in_guest()
> > > will remain true (KVM_HANDLING_IRQ is set) until kvm_before_interrupt().
> > 
> > ... and here.
> > 
> > Would you mind helping why kvm_arch_pmi_in_guest() remains true before
> > *kvm_before_interrupt()*.
> > 
> > According to the source code, the vcpu->arch.handling_intr_from_guest
> > is set to non-zero only at kvm_before_interrupt(), and cleared at
> > kvm_after_interrupt().
> > 
> > Or would you mean kvm_after_interrupt()?
> 
> Oops, it should refer to kvm_after_interrupt() as the code fixed. Thank you.

No need for another version if that's the only hiccup, I can fixup when applying.

