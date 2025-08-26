Return-Path: <kvm+bounces-55783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B05B371B5
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 19:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15C793A32C9
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBF42D23A6;
	Tue, 26 Aug 2025 17:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dEGL/pMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07EE23BD04
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230651; cv=none; b=tuEQPtwle6mIoTPXQWRdKyJfWhHLA1dHQuyB5bL7+DRc79iDUde/QHdyqgVB5bfBpZ0vg/m/BKtCPiOBM6Cuq5y3vdRYeaxv3L8cdFzOaolPPwZRmW8SDIJr2MBPkNkmAqSfW3mOOAtk/cC4iNkGzL+1uO2P5jJ2YB0lIfY42Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230651; c=relaxed/simple;
	bh=SoYGthzvA2DVaEWpuysF3EuzSM+/cYcN3iarEnwgXYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tMI/YYh8a2K3yKxhi9n/g5D3W18TI7NGuEjsiA4LoWCDabRTPb17d2+rsFBvQY/NcUjsUyY9XFDqoDh7Sc9XKbISzoa1K21OaBitZNj0nW/Bf3GxbjZD0rd7UE1xbu8XKSG8cchzB1B7eC3za9XOGXoWTVDRdVOKDmm7qALHhw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dEGL/pMe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3259ff53c2eso3583046a91.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 10:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756230649; x=1756835449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aUqwFSXiDOoK2Bx2xqLwmy8TEJEoVSK65XNfAilJTJE=;
        b=dEGL/pMeLlLZNRxFhJnpfUbfn7WnLHi+fkTotuE3A1SiFRYQztcoRvHNlfXXAYtNOr
         befU9WcC1+ewKKELYp8uooKPfWW0FNOOgX6ciHvwpQLYM0T1zZTFi3rS3AUXXbHYeyMs
         7Ux7iex6O2d7mbKosWnnBNtnIm64kMDWR0d592OKToGYWwn4ir8Xg+oeW9GEvBg5VqjB
         2qZSptXatLdKWoNKwL8BJDD/efLEZYXjA9hC6h2JsEf4DMJqaeZPcaBCeh5QwFQ4Rq3m
         cnV5WXyYOyVMhVaGty4r780+vdBZB/wnld0KTgVxxR4auMxzdJHFLVHLHbkIEb9Fza6c
         NOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756230649; x=1756835449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUqwFSXiDOoK2Bx2xqLwmy8TEJEoVSK65XNfAilJTJE=;
        b=auK11Xpc2MoU0FcsP3e9t5dvAw4ZDoFmugCwnoevOFPvUGrZMqhqmlI+dMfaAOq6Wu
         3QsLuSe3H092B5+Sudesy/IfDj349TDDNJ1wt2WgVdmGWm4JkzgiaQjn/dRtCZsU6GXw
         yfHu+4AjbtUpJcEf1TzS9ZxpVyMK6VQrDEOpD38rPQ34v9YhrrlcmpRQA4Z59+6bGesk
         WKuNiEC5F/sTwTW1uVWKsmntrjVXTjcq/KKgThovI43GbIYSJ4lqqXpitZBWaVzoqALH
         Nc9sPAjpgBY9c397HFvYtpF0Ub+B6GF5jxJ5wAUFm+usX1g+qDUmFfd4bI5FGHZ2oKBr
         wIAg==
X-Gm-Message-State: AOJu0Yx97ZczpiXXhCviwstUITSJQLIREaxOY8nUTL1tvY7VTWVVg6FS
	Oe5/235VwzhBVIwUGbHSIQxyZO/QzbemgX3E4rjEXZo66LtqTunNAElhOwS1M5W+2A8niK3XFmu
	ocqkZ3g==
X-Google-Smtp-Source: AGHT+IEd9dJFwfsX/b931ErJNgizvDk6gtbfVhHXFniSsp95TCi8X85PJ+yQnB23nN+wM4R0MogUdHTCO1U=
X-Received: from pjbrr12.prod.google.com ([2002:a17:90b:2b4c:b0:325:7c49:9cce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f91:b0:321:2b89:957c
 with SMTP id 98e67ed59e1d1-32515ec8d01mr20489624a91.27.1756230649269; Tue, 26
 Aug 2025 10:50:49 -0700 (PDT)
Date: Tue, 26 Aug 2025 10:50:47 -0700
In-Reply-To: <CANypQFbEySjKOFLqtFFf2vrEe=NBr7XJfbkjQhqXuZGg7Rpoxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CANypQFbEySjKOFLqtFFf2vrEe=NBr7XJfbkjQhqXuZGg7Rpoxw@mail.gmail.com>
Message-ID: <aK3z92uBZNcVQGf7@google.com>
Subject: Re: [Discussion] Undocumented behavior of KVM_SET_PIT2 with count=0
From: Sean Christopherson <seanjc@google.com>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Jiaming Zhang wrote:
> Hello KVM maintainers and developers,
> 
> I hope this email finds you well.
> 
> While fuzzing the KVM subsystem with our modified version of syzkaller
> on Linux Kernel, I came across an interesting behavior with the
> KVM_SET_PIT2 and KVM_GET_PIT2 ioctls.
> 
> Specifically, when setting kvm_pit_state2.channels[c].count to 0 via
> KVM_SET_PIT2 and then immediately reading the state back with
> KVM_GET_PIT2, the returned count is 65536 (0x10000). This behavior
> might be surprising for developers because, intuitively, the data
> output via GET should be consistent with the data input via SET. I
> could not find this special case mentioned in the KVM API
> documentation (Documentation/virt/kvm/api.rst).
> 
> After looking into the kernel source (arch/x86/kvm/i8254.c), I
> understand this conversion is by design. It correctly emulates the
> physical i8254 PIT, which treats a programmed count of 0 as its
> maximum value (2^16). While the hardware emulation is perfectly
> correct, it may potentially be confusing for users.
> 
> To prevent future confusion and improve the API's clarity, I believe
> it would be beneficial to add a note to the documentation explaining
> this special handling for count = 0.
> 
> I'm bringing this to your attention to ask for your thoughts. If you
> agree, I would be happy to prepare and submit a documentation patch to
> clarify this.

I have no objection, especially since you're volunteering to do the work of
actually writing the documentation :-)

Somewhat of a side topic, I expect KVM_SET_LAPIC and KVM_GET_LAPIC have similar
behavior, as KVM applies fixup on the incoming local APIC state, e.g. to force
LDR for x2APIC mode according to hardware specs.

I wouldn't be surprised if there are other SET+GET pairs that aren't "pure".
If you run into more surprises, definitely free to submit documentation patches.

