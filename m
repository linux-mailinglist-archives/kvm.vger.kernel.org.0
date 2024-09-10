Return-Path: <kvm+bounces-26267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BE8973868
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3178282601
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1540A18EFF8;
	Tue, 10 Sep 2024 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIcq/bgV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C90B673
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725974138; cv=none; b=Wy+iGRLgA20jbItUoJG6NOjZF1hMA0Dokwnw/biyP9o1Fomy7lK6r+VfRTeemnhzSmYFdM2USLvyhLu2iIr7rXrj47x48WyXFygd/o+0bMwGZUxgiynWN/hASp8vSbf+tl5CnF8kPTFiPEFdbhn10Vza6gcCLaAHhTA3s5J4tso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725974138; c=relaxed/simple;
	bh=SMXxZBZOJWMHw/9H0nyrJrr/zFHPUw6OkMHiCuo8zn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nlNTIUqCV/0K9DeVNbh1e57b2Bnhl8vnWCEDj8RJsbVCJBgWYzaQwyt6xn/34WyAl1469+Hnux7hRwPGiwwyKRynHHXzBSVgWJ31cowMaYubAZg47TkpUQbcYPgVjxfPGEAB+CfVpGGH8gyn48me2GKfRCihWXNpORBoSA5a408=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TIcq/bgV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725974135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LTVsGxhKvknx8EHWaD9UIo0xUzxjMEZcOqiwmfsLR0c=;
	b=TIcq/bgVsIetXOXnxkwd5WhDI3wcKr/pG9/jD62e5ogCX3pwW6n/WnA5LUulRqBXAWeZCB
	4fnI3i58m06RjxjVLdsuJ0WkeErpf3E+hxL6sql1PTA0QAHSJ4x2Fxqnmp9X6cZ4qDwm6v
	AAu4en4vJBsDswirIAyhBW0s4NO2iL8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-GKOM_p0EMYKtocSsNxh13A-1; Tue, 10 Sep 2024 09:15:34 -0400
X-MC-Unique: GKOM_p0EMYKtocSsNxh13A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb479fab2so12097285e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 06:15:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725974133; x=1726578933;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LTVsGxhKvknx8EHWaD9UIo0xUzxjMEZcOqiwmfsLR0c=;
        b=rFTMNUyoYvEg5V9hYsxtz5LassTCL6ZCJlspwVZcEwh+er+rXJCmgXC9PKBP2lyOUo
         V1s3LrmSRQdze7A6AR1JKj37V+BJy/gZz0229cZ6FESuECQ0LfWwfm42NioBiDKeVToa
         rhAtwlYcRsA6Jqh3NlYrZlSJPF20Exz1Lz7kOhchwH4ajiCvB941nlnelZYHCkOtTQjJ
         ULPrlOkuSJginPLzSjdh6/v+7TZkRze6Ngj6gwQCDwH2JytaMMwN2FHS/09ArDokwTI2
         shUlEsL4H2agwsVl3Q3ZA2CoojvKy65c3If/g+hnuozoG0CTIJnnPmEhFrZa/igQrBMf
         sYeg==
X-Gm-Message-State: AOJu0Yx0P0PbjFWu66G9/gaHzNJnZLNMSrzt5upaxF9uJUhEzOHru3Q3
	wTxKoxr8Px9Uk+EHwa/V5S3vUMucEKEzSc76CyYkqOo6F1g39qO2WuUGuvjLRBp0Qfg/mJ53E92
	DOwVAyMOs1tmzB/8kfKjoy906rMVN8bCeKIcoSSfX2m5JQ2/91w==
X-Received: by 2002:adf:a792:0:b0:376:dbb5:10c2 with SMTP id ffacd0b85a97d-378a8a7affdmr1651067f8f.29.1725974132897;
        Tue, 10 Sep 2024 06:15:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFm2DqewC0CTc4Ljt8b8K3IrBiRBLYzELt/eUwORdD4RVqGuQFFQVMrDy/5yHxjtQk2Erqcg==
X-Received: by 2002:adf:a792:0:b0:376:dbb5:10c2 with SMTP id ffacd0b85a97d-378a8a7affdmr1651029f8f.29.1725974132222;
        Tue, 10 Sep 2024 06:15:32 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956767dasm9032522f8f.62.2024.09.10.06.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 06:15:30 -0700 (PDT)
Message-ID: <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
Date: Tue, 10 Sep 2024 15:15:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "dmatlack@google.com" <dmatlack@google.com>, Kai Huang
 <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
 <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zt9kmVe1nkjVjoEg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 23:11, Sean Christopherson wrote:
> In general, I am_very_  opposed to blindly retrying an SEPT SEAMCALL, ever.  For
> its operations, I'm pretty sure the only sane approach is for KVM to ensure there
> will be no contention.  And if the TDX module's single-step protection spuriously
> kicks in, KVM exits to userspace.  If the TDX module can't/doesn't/won't communicate
> that it's mitigating single-step, e.g. so that KVM can forward the information
> to userspace, then that's a TDX module problem to solve.

In principle I agree but we also need to be pragmatic.  Exiting to 
userspace may not be practical in all flows, for example.

First of all, we can add a spinlock around affected seamcalls.  This way 
we know that "busy" errors must come from the guest and have set 
HOST_PRIORITY.  It is still kinda bad that guests can force the VMM to 
loop, but the VMM can always say enough is enough.  In other words, 
let's assume that a limit of 16 is probably appropriate but we can also 
increase the limit and crash the VM if things become ridiculous.

Something like this:

	static u32 max = 16;
	int retry = 0;
	spin_lock(&kvm->arch.seamcall_lock);
	for (;;) {
		args_in = *in;
		ret = seamcall_ret(op, in);
		if (++retry == 1) {
			/* protected by the same seamcall_lock */
			kvm->stat.retried_seamcalls++;
		} else if (retry == READ_ONCE(max)) {
			pr_warn("Exceeded %d retries for S-EPT operation\n", max);
			if (KVM_BUG_ON(kvm, retry == 1024)) {
				pr_err("Crashing due to lock contention in the TDX module\n");
				break;
			}
			cmpxchg(&max, retry, retry * 2);
		}
	}
	spin_unlock(&kvm->arch.seamcall_lock);

This way we can do some testing and figure out a useful limit.

For zero step detection, my reading is that it's TDH.VP.ENTER that 
fails; not any of the MEM seamcalls.  For that one to be resolved, it 
should be enough to do take and release the mmu_lock back to back, which 
ensures that all pending critical sections have completed (that is, 
"write_lock(&kvm->mmu_lock); write_unlock(&kvm->mmu_lock);").  And then 
loop.  Adding a vCPU stat for that one is a good idea, too.

Paolo


