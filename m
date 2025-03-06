Return-Path: <kvm+bounces-40235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 54207A54735
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 11:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E415E7A8C36
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C071FF1B1;
	Thu,  6 Mar 2025 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UG5NGoqJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F471F4289
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 10:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741255240; cv=none; b=CTU7DxbMA6Y4EVm7QxtXXftvC6AnkhmPQ5OFmqcEJuo7eJtVH3f/RqQwmWa7HVg/arFCVuoFb87xuuRlxkYxNnDfhUCOG54MVTEZnegdgkyw4c1ghJLRVUmFv5yDj0zcZZMKWskDqAwEsYd6t8KLnozvrqPRHFHgadcx80F0PIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741255240; c=relaxed/simple;
	bh=5Lhtwd5cH2PKhD/dFJio5Nb5ixUzvTEXAnioAWegKMc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=P205cbc9fPeV0HXxr5ZCqdtWgyv72oF0K1IRa5WbLfQh3NAZGNvD58Lz5HVfWQ8DHCMgcL7+Yd/1FaKTTqwMBLf/9/V8ruw3fr7sZRsRabHxu6ENh/3tYzZRLK92plIQWk+QQ5Ku8sMWjS4AX9v+3346Slp/6iLV7vb5m651k0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UG5NGoqJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741255237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wkn24CpGo6+FUEVuRlexbhMNX+ALW6So6mD2WHyvwXE=;
	b=UG5NGoqJF0UQ13IZimXnF8l4/I5XIvqd2oFLlD+5XZE27Z25U9j8ddNMaEGUYnm6k4iYNV
	D3WA8Bk0bsFkQ5e6VRL+jmeaPACgc1q1FkFKUpVPyjcT+IMJlxJs+HFzuusCAjTcLsMJ1+
	KBRSW+a8QCQmTmJIwudwT1wDa+yx27E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-wZU8ueioMLGgOKvPeGYw7w-1; Thu, 06 Mar 2025 05:00:33 -0500
X-MC-Unique: wZU8ueioMLGgOKvPeGYw7w-1
X-Mimecast-MFC-AGG-ID: wZU8ueioMLGgOKvPeGYw7w_1741255232
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912539665cso702673f8f.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 02:00:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741255232; x=1741860032;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wkn24CpGo6+FUEVuRlexbhMNX+ALW6So6mD2WHyvwXE=;
        b=IMDTj47NJv1hzw0/yqEeWQ/TagSQ1NAp9Cskzos4zSdrt4BtdNS4eJE2CqgzBgdlyi
         2Sdkm18a5GCa+0fUu/c34bTESL2fMQ6lYz3rlGeW9TBJhdVHpZwPfbsS+TBissK27X42
         LBiIgZNKvqXIk9ogZrRyEs1zXZ0C5zVoc8xtyKW0X7uAfse3t7Nh9SIIDmacyNeEdyJ4
         tWCy/OUSeP7UvJuIMlNa1MBJJuFbAW1TWkFzVtfRdfLlgwNd2ElLSg/UooF6O0NJ0LqG
         rBbeiRFfB3Qjp72+c7EpZH7JhyoGpNxnylEwKr+2UMk7CzpbBC5rv6mEfGU6XlRyTpbf
         vpdA==
X-Gm-Message-State: AOJu0YweoxlXpBAuLqTLb0tlG0D6qqZNiAJnzaPvZO0/LdRNUsiydRUm
	TWBxk2rJONAwavKS8HLJLvPw7iIlhezR931Y87QCyG+AG8Dj2TKNqhUFxgS+LYDBDKmeDLPEk0e
	tsruCkJtxU3CNXkfeaIHq1gYznM2wiwLanRrVcLji7Z3FDaBFkw==
X-Gm-Gg: ASbGnctfyz+aa2eXh+z/blARyfNFO2EDgM0/v6FvqWH7y1GChh+CBkVmjdB5BsP7WhA
	Rxr40zsHGdODf/39h9Sehi5Yi3MXLCL6h6X+/okDLPqsjWCdF/Fa1KPeN8+YmASXCNag6r7B0zl
	HkW1aunNhzCJmsO26u/7ixk8wKpGJvCeEuuXL2sLNfYSXrW/Qg1Q1ZYKxCkeCuKUM9opdqTLFZY
	heP7rGn6RbL79zikuNkf6rQDkgV08OB4riOC5rxpTiCGH2eYQpo1fkt7ebc6TzpVYgC1Z28yZku
	xKo5t12CyTk=
X-Received: by 2002:a05:600c:1c9c:b0:43b:ca8c:fca3 with SMTP id 5b1f17b1804b1-43bdb3b8fc5mr21081175e9.11.1741255232030;
        Thu, 06 Mar 2025 02:00:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbZl9Jwi9K2ockg9+UNE+kX6iPaGsi8yOptcqo6NIW8PqlcWYlqkjfEnAsg9dPJ6hUpVn3bw==
X-Received: by 2002:a05:600c:1c9c:b0:43b:ca8c:fca3 with SMTP id 5b1f17b1804b1-43bdb3b8fc5mr21080845e9.11.1741255231504;
        Thu, 06 Mar 2025 02:00:31 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435cd8csm45017965e9.40.2025.03.06.02.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 02:00:30 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, "Maciej S. Szmigiero"
 <maciej.szmigiero@oracle.com>
Subject: Re: QEMU's Hyper-V HV_X64_MSR_EOM is broken with split IRQCHIP
In-Reply-To: <87a59zq0x2.fsf@redhat.com>
References: <Z8ZBzEJ7--VWKdWd@google.com> <87ikoposs6.fsf@redhat.com>
 <Z8cNBTgz3YBDga3c@google.com> <87cyewq2ea.fsf@redhat.com>
 <23cfae5adcdee2c69014d18b2b19be157ef2c20d.camel@redhat.com>
 <87a59zq0x2.fsf@redhat.com>
Date: Thu, 06 Mar 2025 11:00:29 +0100
Message-ID: <87senqo4w2.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Maxim Levitsky <mlevitsk@redhat.com> writes:
>
>> On Tue, 2025-03-04 at 15:46 +0100, Vitaly Kuznetsov wrote:
>>> Sean Christopherson <seanjc@google.com> writes:
>>> 
>>> > On Tue, Mar 04, 2025, Vitaly Kuznetsov wrote:
>>> > > Sean Christopherson <seanjc@google.com> writes:
>>> > > 
>>> > > > FYI, QEMU's Hyper-V emulation of HV_X64_MSR_EOM has been broken since QEMU commit
>>> > > > c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), as nothing in KVM
>>> > > > will forward the EOM notification to userspace.  I have no idea if anything in
>>> > > > QEMU besides hyperv_testdev.c cares.
>>> > > 
>>> > > The only VMBus device in QEMU besides the testdev seems to be Hyper-V
>>> > > ballooning driver, Cc: Maciej to check whether it's a real problem for
>>> > > it or not.
>>> > > 
>>> > > > The bug is reproducible by running the hyperv_connections KVM-Unit-Test with a
>>> > > > split IRQCHIP.
>>> > > 
>>> > > Thanks, I can reproduce the problem too.
>>> > > 
>>> > > > Hacking QEMU and KVM (see KVM commit 654f1f13ea56 ("kvm: Check irqchip mode before
>>> > > > assign irqfd") as below gets the test to pass.  Assuming that's not a palatable
>>> > > > solution, the other options I can think of would be for QEMU to intercept
>>> > > > HV_X64_MSR_EOM when using a split IRQCHIP, or to modify KVM to do KVM_EXIT_HYPERV_SYNIC
>>> > > > on writes to HV_X64_MSR_EOM with a split IRQCHIP.
>>> > > 
>>> > > AFAIR, Hyper-V message interface is a fairly generic communication
>>> > > mechanism which in theory can be used without interrupts at all: the
>>> > > corresponding SINT can be masked and the guest can be polling for
>>> > > messages, proccessing them and then writing to HV_X64_MSR_EOM to trigger
>>> > > delivery on the next queued message. To support this scenario on the
>>> > > backend, we need to receive HV_X64_MSR_EOM writes regardless of whether
>>> > > irqchip is split or not. (In theory, we can get away without this by
>>> > > just checking if pending messages can be delivered upon each vCPU entry
>>> > > but this can take an undefined amount of time in some scenarios so I
>>> > > guess we're better off with notifications).
>>> > 
>>> > Before c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), and without
>>> > a split IRCHIP, QEMU gets notified via eventfd.  On writes to HV_X64_MSR_EOM, KVM
>>> > invokes irq_acked(), i.e. irqfd_resampler_ack(), for all SINT routes.  The eventfd
>>> > signal gets back to sint_ack_handler(), which invokes msg_retry() to re-post the
>>> > message.
>>> > 
>>> > I.e. trapping HV_X64_MSR_EOM on would be a slow path relative to what's there for
>>> > in-kernel IRQCHIP.
>>> 
>>> My understanding is that the only type of message which requires fast
>>> processing is STIMER messages but we don't do stimers in userspace. I
>>> guess it is possible to have a competing 'noisy neighbough' in userspace
>>> draining message slots but then we are slow anyway.
>>> 
>>
>> Hi,
>>
>> AFAIK, HV_X64_MSR_EOM is only one of the ways for the guest to signal that it processed the SYNIC message.
>>
>> Guest can also signal that it finished processing a SYNIC message using HV_X64_MSR_EOI or even by writing to EOI
>> local apic register, and I actually think that the later is what is used by at least recent Windows.
>>
>
> Hyper-V SynIC has two distinct concepts: "messages" and "events". While
> events are just flags (like interrupts), messages actually carry
> information and the recipient is responsible for clearing message slot
> (there are only 16 of them per vCPU AFAIR). Strictly speaking,
> HV_X64_MSR_EOM is optional and hypervisor may deliver a new message to
> an empty slot at any time. It may use EOI as a trigger but note that
> not every message delivery results in an interrupt as e.g. SINT can be
> configured in 'polling' mode -- and that's when HV_X64_MSR_EOM comes
> handy.
>

Thinking more about this, I believe we should not be using eventfd for
delivering writes to HV_X64_MSR_EOM to VMM at all. Namely, writes to
HV_X64_MSR_EOM should not invoke irq_acked(): it should be valid for a
guest to poll for messages by writing to HV_X64_MSR_EOM within the
interrupt handler, drain the queue and then write to the EOI
register. In this case, the VMM may want to distinguish between EOI and
EOM. We can do a separate eventfd, of course, but I think it's an
overkill and 'slow' processing will do just fine.

-- 
Vitaly


