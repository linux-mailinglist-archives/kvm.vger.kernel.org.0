Return-Path: <kvm+bounces-40040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE40A4E1B1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B833A7A7A8E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC7725FA0C;
	Tue,  4 Mar 2025 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CMHMuUu4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A019253F27
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741099644; cv=none; b=ieGQ2/DiAzpNJ5y14wQwz3i4Wroe72cJkJ7irFv8FD/bEK68vPCvD5PS/23goWcLNZrF0adgKMKlC0uFtrazILrf0DG4Wk2jQDLncocLa/cSVLsHMgSrqZIjLkISwlN9qyylknZEA1ZOdU9IhkF2MHAHq1WqAkbr2pXhb1MGLKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741099644; c=relaxed/simple;
	bh=whg8HCG6UdI1zul2/4LLXqTnV2vRgYauL8+q1OhMI8E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NAV41oSdc3Gz9C+ctmz46y4S1WN3mzYUlJVOBiAVqYgLO2mujItkyRIOaFUmSA87TGEH+ZEi0JnAnlMEp5y1TT9W/+8pKh915oAgVRWKticuI6Int0GQFc+tQa2QI4zLBjK485CrGPdVNNJUwTB8di12VaPRfitBMn29+C/vZho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CMHMuUu4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741099641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xKaITwIjY8bRG3Gkr5ECFSqk2O5WBX0rcvQdhZB+9fQ=;
	b=CMHMuUu4MyVTHoQ0zj/SCXww6ZrFvyIxD7STD9xjFi9mCL96IwQNSMNVi1rFa3KQqwj4Ee
	mezc8DvnKHObp54m0iLGSDfz8+8UCkTck8al44zNYcPi4joV9ekJUQ9Kb8kvsaD99Jo7Pi
	RCQgNDCyUDFWGbd8UV5dAK09hgGqEt0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-LCJ5lYREOoeloLejlLbvmg-1; Tue, 04 Mar 2025 09:47:15 -0500
X-MC-Unique: LCJ5lYREOoeloLejlLbvmg-1
X-Mimecast-MFC-AGG-ID: LCJ5lYREOoeloLejlLbvmg_1741099634
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43943bd1409so41624365e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 06:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741099615; x=1741704415;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKaITwIjY8bRG3Gkr5ECFSqk2O5WBX0rcvQdhZB+9fQ=;
        b=k9kTLoewNIIXdxpkycuKlha50KYsnXf0iPz7tkMPggnYXzY9Cc1pVhaPe9ydN2wPcp
         8HuBHCqRJeSaINFZtIIUWS71KQM6frfQHPywhUu2Gj1Y/Y/Ml7Jc7xsLHnprX/8/0z04
         6ZRwAyzrFLbL9otTNI1pKdFxsBXAjTbaQH2Y38y3pYP3cgosje+wqXCN7QU30m9u6P2T
         64LL+kISzThmZjfBJSB412qzt3BE4bLha4MACse8oWGOKRXTVcvZG0I0rC4XIYHuHjIH
         JhsC4ekg9jfeK+bjOBwG9JIObufcUDti03lB6oMybP+kGBlApNG95lujESXXPFtuF/Th
         mh9Q==
X-Gm-Message-State: AOJu0Yz9WEq8KVr7bDfsqAMmIRwgEpIUhg1BokbVmpnFmwfUmiGHWLbr
	ASz/1+y2OS/lbSR5FHuAPohXy9URLrWVfIlGZ4k1cf2gAWVDL8I09/69LYyOB/V4IZe5dTu7tp5
	QUBNoj3HA3OVOK1fYkBJSP5vTUrnrFftrSLv0Edbf/T3LuYMfIQ==
X-Gm-Gg: ASbGncufFJQDyCeLf/Qo+8SNOzylxRnREiZG+hSrruh0Oh0j9iyo4SFQ3IKnZbGRqZ5
	qy1FA8ir9TvPAUNCgNWKMQk/+VqooMYUEo4Qs3uT6lPrm7AynNaKEPv1JTCUXhErmeratgEVlK4
	Mf6i7nZ5pEebIDfDsioixpUNNjBnwItIMsmmhuZZKO1dOpH5t9p/q3zo9kv8RTswT13uXfqcjme
	CcJEyw0j+7NkKQVL1cFJbogvgYjH976Y0ySFB55ob+0FJ+3VLgc6pbKrN5weKH4dDyvJ2QqAJwJ
	g1Q5EJweV3A=
X-Received: by 2002:a05:600c:3ca3:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-43ba66537dcmr169093045e9.0.1741099614774;
        Tue, 04 Mar 2025 06:46:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGC0IBp+JOO2z1qAvR0ujuwVStYbT364MrRRSDeDJqeJ7/iO/DEV3l7jSL725tKC8VXgvMZ7Q==
X-Received: by 2002:a05:600c:3ca3:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-43ba66537dcmr169092845e9.0.1741099614393;
        Tue, 04 Mar 2025 06:46:54 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b736f74e8sm207928825e9.7.2025.03.04.06.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 06:46:53 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, "Maciej S. Szmigiero"
 <maciej.szmigiero@oracle.com>
Subject: Re: QEMU's Hyper-V HV_X64_MSR_EOM is broken with split IRQCHIP
In-Reply-To: <Z8cNBTgz3YBDga3c@google.com>
References: <Z8ZBzEJ7--VWKdWd@google.com> <87ikoposs6.fsf@redhat.com>
 <Z8cNBTgz3YBDga3c@google.com>
Date: Tue, 04 Mar 2025 15:46:53 +0100
Message-ID: <87cyewq2ea.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Mar 04, 2025, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > FYI, QEMU's Hyper-V emulation of HV_X64_MSR_EOM has been broken since QEMU commit
>> > c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), as nothing in KVM
>> > will forward the EOM notification to userspace.  I have no idea if anything in
>> > QEMU besides hyperv_testdev.c cares.
>> 
>> The only VMBus device in QEMU besides the testdev seems to be Hyper-V
>> ballooning driver, Cc: Maciej to check whether it's a real problem for
>> it or not.
>> 
>> >
>> > The bug is reproducible by running the hyperv_connections KVM-Unit-Test with a
>> > split IRQCHIP.
>> 
>> Thanks, I can reproduce the problem too.
>> 
>> >
>> > Hacking QEMU and KVM (see KVM commit 654f1f13ea56 ("kvm: Check irqchip mode before
>> > assign irqfd") as below gets the test to pass.  Assuming that's not a palatable
>> > solution, the other options I can think of would be for QEMU to intercept
>> > HV_X64_MSR_EOM when using a split IRQCHIP, or to modify KVM to do KVM_EXIT_HYPERV_SYNIC
>> > on writes to HV_X64_MSR_EOM with a split IRQCHIP.
>> 
>> AFAIR, Hyper-V message interface is a fairly generic communication
>> mechanism which in theory can be used without interrupts at all: the
>> corresponding SINT can be masked and the guest can be polling for
>> messages, proccessing them and then writing to HV_X64_MSR_EOM to trigger
>> delivery on the next queued message. To support this scenario on the
>> backend, we need to receive HV_X64_MSR_EOM writes regardless of whether
>> irqchip is split or not. (In theory, we can get away without this by
>> just checking if pending messages can be delivered upon each vCPU entry
>> but this can take an undefined amount of time in some scenarios so I
>> guess we're better off with notifications).
>
> Before c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), and without
> a split IRCHIP, QEMU gets notified via eventfd.  On writes to HV_X64_MSR_EOM, KVM
> invokes irq_acked(), i.e. irqfd_resampler_ack(), for all SINT routes.  The eventfd
> signal gets back to sint_ack_handler(), which invokes msg_retry() to re-post the
> message.
>
> I.e. trapping HV_X64_MSR_EOM on would be a slow path relative to what's there for
> in-kernel IRQCHIP.

My understanding is that the only type of message which requires fast
processing is STIMER messages but we don't do stimers in userspace. I
guess it is possible to have a competing 'noisy neighbough' in userspace
draining message slots but then we are slow anyway.

-- 
Vitaly


