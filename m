Return-Path: <kvm+bounces-32337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 556D19D5894
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 04:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7B611F2358B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 03:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9C11531D8;
	Fri, 22 Nov 2024 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xi8f0IJt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BC23098B
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 03:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732246474; cv=none; b=IpNveWn5D89ZktCVVm7LO2goS77wq5ySC2gOhYdU9IqbV3KQAgTT4RWas55KbH2PdL0HT2isPjRGPjWYEBB22ScBQS4RYn9NYGGZ/0F/wo5NM6VAoGlMN4ZeJYFff3kcD9U6sfVXxwgQy9yCko0JM6H4fU5m8+NNRBxhLy2IEFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732246474; c=relaxed/simple;
	bh=9kkSHX5C/Rzcba5jDJqEPRSjF0ZyIB/tw8lBGgd3K04=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oRySQ8PMH4mLVvwPaMj1QWLWHWLALYt9H1lfqS/IlUYuFB5XT23XZlwLo7KoeK2Xb9WFI+SuJN4oYfStfAA6WJrSKEmja24rf4PFPMEcTjLbndgIyF7QWxAFNn2AQsxeQTPBmLgWh+UzUOtu+TdpP7JowxRoTtG0/Z1xG5z6ppo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xi8f0IJt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732246471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5owPybl2A6mPLtXeb0GF8SzCVpIuIgw+HHvE5+2/5T0=;
	b=Xi8f0IJtgVDl+ICcmKwQX34egzpGfa7UnlZlxqUdHoY8rieABKR9cAJ1wAPfXxd9SDyrfY
	TjCSbykiY1tFZ+ebrucvL12Y8S2Tv/shIUoCsDpxJiGP9+zVpAYysn8+g5mWdj01GZEd/I
	T6TI/NZwjRx6b3FlkoWinhSOiRX9vY8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-3kLMekoNNr6oHyw9s8iRFQ-1; Thu, 21 Nov 2024 22:34:30 -0500
X-MC-Unique: 3kLMekoNNr6oHyw9s8iRFQ-1
X-Mimecast-MFC-AGG-ID: 3kLMekoNNr6oHyw9s8iRFQ
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b15499a04eso314871885a.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 19:34:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732246469; x=1732851269;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5owPybl2A6mPLtXeb0GF8SzCVpIuIgw+HHvE5+2/5T0=;
        b=dS+uuLk7vLMCDwUnKhk4viILbm5TpcPugz0pNwMl+MY3OpDg2Ivf84pe6QylDCQQj3
         jkc7U6ch9qXeAjihUroWe2umn7i9WkKc7eEtvAkp7+WrYIo8nE/bcDQ+O9QLj86o3wkl
         Kxpyx/MgY9AqwRGWTVDOCKxWXQoL+o+YyQU9CLlZPxLPUv7U5MH0t4llIU6j9xx3Hypk
         MzTs/7535RNtttkeoh0Qx9Dhrw8OjtnLoQ3nwrLBoKUA0wZJsIRBRudkVq2TwgAxTd+I
         WwO8HjyqYEWsrwG/zPEL0JP+SPhxImoLE3iktSApHat5Fh/9OQcV7MpLHUl9CdnB3P8n
         hALw==
X-Gm-Message-State: AOJu0YzdLML/ssRpqsF9P5FHHtU0YMUR9WNbx8e7A6yUVYO+gZivS6GP
	VmVpXnkKUPlE/1v03HMfWyTKHBovqdgV1JsUBBHrGrpmQKUFeluQT0evaJ9PsWB7/Dnxuc9Fcgf
	uRdRmzNt8q7xsG8whL5fT+LqTICV2er9DVKJ7+1nxI7OTWcAG7Ad0gPoUC5El
X-Gm-Gg: ASbGncsEQopKq1U5C6FKD2E9OtkqJ0dWkbR2fxwIz5ni7ynVkxaNaiYlZSPEYaFkBQX
	RLMnmTL3IQZY6MqpKIHq4knt1ow3UtnyFYh+xtezCc2Ren4PCk5mCKz/SboduVAo8Ui0tMjVb9J
	dk6HUG8B3qDvQO3hbrlA6aNWszBiBK5MasT6oJ1A29X3YKOxcLKk/gNNpfZaxEDgGAlo+IOlUva
	1v5nI1a1zmoPrPByZDRrwrsTMg6FAqWIaSYFNvcOVZrSTiOFw==
X-Received: by 2002:a05:620a:601c:b0:7b1:21c9:d1ad with SMTP id af79cd13be357-7b50c1bbea5mr922168885a.23.1732246469286;
        Thu, 21 Nov 2024 19:34:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF40kkpOkNoCUj7UXHDVNMT6f685l0ht7e59S+qcPkVWqYBRtbkkFc+AKlw7dYgnr5xBZD8Ig==
X-Received: by 2002:a05:620a:601c:b0:7b1:21c9:d1ad with SMTP id af79cd13be357-7b50c1bbea5mr922166285a.23.1732246468905;
        Thu, 21 Nov 2024 19:34:28 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d451a837bbsm4922046d6.23.2024.11.21.19.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 19:34:28 -0800 (PST)
Message-ID: <8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, 
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Ingo Molnar
 <mingo@redhat.com>,  "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner
 <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>,  Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 21 Nov 2024 22:34:27 -0500
In-Reply-To: <Zxf2ZK7HS7jL7TQk@google.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
	 <ZRsYNnYEEaY1gMo5@google.com>
	 <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com>
	 <Zxb4D_JCC-L7OQDT@google.com> <Zxf2ZK7HS7jL7TQk@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-10-22 at 12:00 -0700, Sean Christopherson wrote:
> On Mon, Oct 21, 2024, Sean Christopherson wrote:
> > On Wed, Oct 04, 2023, Maxim Levitsky wrote:
> > > About the added 'vcpu->loaded' variable, I added it also because it is
> > > something that is long overdue to be added, I remember that in IPIv code
> > > there was also a need for this, and probalby more places in KVM can be
> > > refactored to take advantage of it, instead of various hacks.
> > 
> > I don't view using the information from the Physical ID table as a hack.  It very
> > explicitly uses the ir_list_lock to ensure that the pCPU that's programmed into
> > the IRTE is the pCPU on which the vCPU is loaded, and provides rather strict
> > ordering between task migration and device assignment.  It's not a super hot path,
> > so I don't think lockless programming is justified.

If you strongly prefer this I won't argue. KVM does read back its SPTE entries,
which is also something I can't say that I like that much.

> > 
> > I also think we should keep IsRunning=1 when the vCPU is unloaded.  That approach
> > won't run afoul of your concern with signaling the wrong pCPU, because KVM can
> > still keep the ID up-to-date, e.g. if the task is migrated when a pCPU is being
> > offlined.
> > 
> > The motiviation for keeping IsRunning=1 is to avoid unnecessary VM-Exits and GA
> > log IRQs.  E.g. if a vCPU exits to userspace, there's zero reason to force IPI
> > senders to exit, because KVM can't/won't notify userspace, and the pending virtual
> > interrupt will be processed on the next VMRUN.
> 
> My only hesitation to keeping IsRunning=1 is that there could, in theory, be a
> noisy neighbor problem.  E.g. if there is meaningful overhead when the CPU responds
> to the doorbell. 

I once measured this by bombarding a regular CPU, which is not running any guests,
with AVIC doorbells. It was like 60% reduction of its performance if I remember correctly.

So physical id table entries of a VM can't point to a CPU which doesn't run the VM's vCPU thread, because
only in this case this doesn't pose a DOS risk.

Same with IOMMU (malicious guest can in theory make an assigned device generate an interrupt
storm, and then this storm can get redirected to a doorbell of a CPU which doesn't belong to a VM).


Best regards,
	Maxim Levitsky



>  Hrm, and if another vCPU is scheduled in on the same pCPU, that
> vCPU could end up processing a virtual interrupt in response to a doorbell intended
> for a different vCPU.
> 
> The counter-argument to both concerns is that APICv Posted Interrupts have had a
> _worse_ version of that behavior for years, and no one has complained.  KVM sets
> PID.SN only when a vCPU is _preempted_, and so devices (and now virtual IPIs) will
> send notification IRQs to pCPUs that aren't actively running the vCPU, or are
> running a different vCPU.
> 
> The counter-counter-argument is that (a) IPI virtualization is a recent addition,
> and device posted interrupts are unlikely to be used in a CPU oversubscribed setup,
> and (b) Posted Interrupts are effectively rate-limited to a single "spurious"
> notification per vCPU, as notification IRQs are sent if and only if PID.ON=0.
> 
> That said, while I'm somewhat less confident that keeping IsRunning=1 is desirable
> for all use cases than I was yesterday, I still think we should avoid tightly
> coupling it to whether or not the vCPU is loaded, because there are undoubtedly
> setups where it _is_ desirable, e.g. if vCPUs are pinned 1:1 to pCPUs.
> 



