Return-Path: <kvm+bounces-40084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 554A9A4EF64
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48251172C6A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C06278103;
	Tue,  4 Mar 2025 21:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKHSVMcl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D0B2673BA
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741123898; cv=none; b=mvZ7NkbAC1ywJBeCVKwfg/d1HquHiLVn0wfF48Q77ViNKNLMirRTsPQ8MQ74b7chwMI1yv+t9JkkyGODyTUtw3WGNs4IwadgglRApzQPgH7X5IhYNM1/Qp825K2xt8iMb7H13Avf+Yroci1KBPSfJEhpcyNMRmAweO5NV7smpbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741123898; c=relaxed/simple;
	bh=iZIzip/a82vX2LkJv4zSZm4C3SJDxHZJwHDvU2KQ3Lw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=obT9boisS8dNqy39HuvYJfo5mqtdiuUfha25md0FG6k1fcOyvmrV8CilNyneoFZI5qe2KrS1y7z6bo8jvy14u0xFCYkjpSZXXgiRxPX3M1dyzSnrW24Ld8kIvW+E1QS+HJUotFb+zebrH5Lc/W2xQkals29TIYXPjeZtje69c8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKHSVMcl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741123895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/u+lFueGmAvUTM+DtaLsQO1A1g/BaRj/gNOIsb+910g=;
	b=PKHSVMclxtCDIQ+ZkfTp4Q3WZXs3lReg5RD0iiLH0Wf0BegavvJbwUd0NzQsuACnny2tOe
	noWX3jQ2acxzsdereNtHsJPGlV2ei2ASeoepzaw32JevZLJNwfC5rG3IeepOF8Iwbcd11B
	qxjniK52Y4Z4DOCxCmnjfgC3SgXdTIw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-3_UlCdBXO-OkX_oIR4xNtg-1; Tue, 04 Mar 2025 16:31:34 -0500
X-MC-Unique: 3_UlCdBXO-OkX_oIR4xNtg-1
X-Mimecast-MFC-AGG-ID: 3_UlCdBXO-OkX_oIR4xNtg_1741123893
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4721d9703ecso133760901cf.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 13:31:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741123893; x=1741728693;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/u+lFueGmAvUTM+DtaLsQO1A1g/BaRj/gNOIsb+910g=;
        b=eJwLLz4iEFEc4tqdxu+Q1sDbJXPA4pTUFXgv1VeXLWU8zWuz4RgOhmXCxLUgY6N3HT
         3zB4QPjxu93GKbWQc+wVvwkr8K8Z7VaJZ/IBhthqUbCVkrRdcf7mUrdRGCvyJ+BBLWVH
         12wZ9SxkANIfXSLZlYr0jcGh5ZxCUZoZ5259czkZceoEJKxLN8DFwwBFfbb3bdr3Yme0
         MjbZFtWXbm+QEn4C56X0XHPDGVjia26d2xksaVUBPS1gV3zrRdIg+0SSzZyGONMXYDQv
         JY+yt29QZoSO3MuC2ivBRaTixerZEulUvTtIWNIZFKPSD/FEFgmk+zSufkqqsoRM3pg4
         W5nQ==
X-Gm-Message-State: AOJu0YyPRTtjnqbztF5lcLbCpEaIwl2jtcs+U347vG4WtyN+hIC0X2eK
	dP8k31ae8ags6TZdw7idYi77Rr6lIgSeMOszh78jRAvgoLteBd0GnUh/iYHAJhy6gq3RaMeIIQg
	Vs38Tz7ZtW1hBWgCw0sIaLCrPmaNhsE5vfdtkNikt5j8JVCYqsQ==
X-Gm-Gg: ASbGncsS1CLvKWUVxYwfUhdHgtb8NWLDN7ESzUCOttYbplTOPqnmPng3LiYcg6oynnL
	1rvmDNSDQX65DH5ziHspQS2KxFpVPXa3OefbrMIqTNNXETtkCREgUZeJi9i8sLDTZSdRmhoFwv/
	KjXUwGz3wjMHxRPo1b359XA5i4ewlnw/NxsddHakOomIz1EosB8jXp5fhVdaISY8mTiVzu1u28I
	kv06gFCWu0sV6o4RPE71mtqC4akgxwoZtY90KnOSuDiLHQ65WT3i2wXpXRTS6+vLdI0bL8Y+ekp
	oH8Ip3E/Gr5FAvQ=
X-Received: by 2002:a05:622a:60f:b0:471:be0e:e853 with SMTP id d75a77b69052e-4750b43c3d2mr11681861cf.20.1741123893530;
        Tue, 04 Mar 2025 13:31:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFq3Qm8HjXWzqA8J3MceftXH5+TdpP0G/l/xsbfQtBrI9xoJPnzFc7gCJPy7NR5vHnpnooV3A==
X-Received: by 2002:a05:622a:60f:b0:471:be0e:e853 with SMTP id d75a77b69052e-4750b43c3d2mr11681531cf.20.1741123893214;
        Tue, 04 Mar 2025 13:31:33 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-474e0f1e0c1sm36608431cf.47.2025.03.04.13.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 13:31:32 -0800 (PST)
Message-ID: <23cfae5adcdee2c69014d18b2b19be157ef2c20d.camel@redhat.com>
Subject: Re: QEMU's Hyper-V HV_X64_MSR_EOM is broken with split IRQCHIP
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson
	 <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
	 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, "Maciej S. Szmigiero"
	 <maciej.szmigiero@oracle.com>
Date: Tue, 04 Mar 2025 16:31:31 -0500
In-Reply-To: <87cyewq2ea.fsf@redhat.com>
References: <Z8ZBzEJ7--VWKdWd@google.com> <87ikoposs6.fsf@redhat.com>
	 <Z8cNBTgz3YBDga3c@google.com> <87cyewq2ea.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-03-04 at 15:46 +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Mar 04, 2025, Vitaly Kuznetsov wrote:
> > > Sean Christopherson <seanjc@google.com> writes:
> > > 
> > > > FYI, QEMU's Hyper-V emulation of HV_X64_MSR_EOM has been broken since QEMU commit
> > > > c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), as nothing in KVM
> > > > will forward the EOM notification to userspace.  I have no idea if anything in
> > > > QEMU besides hyperv_testdev.c cares.
> > > 
> > > The only VMBus device in QEMU besides the testdev seems to be Hyper-V
> > > ballooning driver, Cc: Maciej to check whether it's a real problem for
> > > it or not.
> > > 
> > > > The bug is reproducible by running the hyperv_connections KVM-Unit-Test with a
> > > > split IRQCHIP.
> > > 
> > > Thanks, I can reproduce the problem too.
> > > 
> > > > Hacking QEMU and KVM (see KVM commit 654f1f13ea56 ("kvm: Check irqchip mode before
> > > > assign irqfd") as below gets the test to pass.  Assuming that's not a palatable
> > > > solution, the other options I can think of would be for QEMU to intercept
> > > > HV_X64_MSR_EOM when using a split IRQCHIP, or to modify KVM to do KVM_EXIT_HYPERV_SYNIC
> > > > on writes to HV_X64_MSR_EOM with a split IRQCHIP.
> > > 
> > > AFAIR, Hyper-V message interface is a fairly generic communication
> > > mechanism which in theory can be used without interrupts at all: the
> > > corresponding SINT can be masked and the guest can be polling for
> > > messages, proccessing them and then writing to HV_X64_MSR_EOM to trigger
> > > delivery on the next queued message. To support this scenario on the
> > > backend, we need to receive HV_X64_MSR_EOM writes regardless of whether
> > > irqchip is split or not. (In theory, we can get away without this by
> > > just checking if pending messages can be delivered upon each vCPU entry
> > > but this can take an undefined amount of time in some scenarios so I
> > > guess we're better off with notifications).
> > 
> > Before c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), and without
> > a split IRCHIP, QEMU gets notified via eventfd.  On writes to HV_X64_MSR_EOM, KVM
> > invokes irq_acked(), i.e. irqfd_resampler_ack(), for all SINT routes.  The eventfd
> > signal gets back to sint_ack_handler(), which invokes msg_retry() to re-post the
> > message.
> > 
> > I.e. trapping HV_X64_MSR_EOM on would be a slow path relative to what's there for
> > in-kernel IRQCHIP.
> 
> My understanding is that the only type of message which requires fast
> processing is STIMER messages but we don't do stimers in userspace. I
> guess it is possible to have a competing 'noisy neighbough' in userspace
> draining message slots but then we are slow anyway.
> 

Hi,

AFAIK, HV_X64_MSR_EOM is only one of the ways for the guest to signal that it processed the SYNIC message.

Guest can also signal that it finished processing a SYNIC message using HV_X64_MSR_EOI or even by writing to EOI
local apic register, and I actually think that the later is what is used by at least recent Windows.


Now KVM does intercept EOI and it even "happens" to work with both APICv and AVIC:

APICv has EOI 'exiting bitmap' and SYNC interrupts are set there (see vcpu_load_eoi_exitmap).

AVIC intercepts EOI write iff the interrupt was level-triggered and SYNIC interrupts happen
to be indeed level-triggered:

static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
...
	irq.shorthand = APIC_DEST_SELF;
	irq.dest_mode = APIC_DEST_PHYSICAL;
	irq.delivery_mode = APIC_DM_FIXED;
	irq.vector =
vector;
	irq.level = 1;
...


Best regards,
	Maxim Levitsky




