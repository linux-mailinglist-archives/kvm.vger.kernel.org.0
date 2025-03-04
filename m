Return-Path: <kvm+bounces-40032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38906A4E0FD
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2D363A432C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A26B7208970;
	Tue,  4 Mar 2025 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WDMJUclK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB8D2080F4
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741098248; cv=none; b=eCNfsEbhHROO89mNUPFfmBbUM+ky1z82abGQYxnls1rfjl5DeJRZk6Xccy0cxw2EVWudXdXHmKJZnr6thB1bln+unEZpZQLTXc56bmR3jCyfR8RlSg7jTrFmgyj+S90Z5k3R4aCitAEsTN0ThO/WneQ0DrLcPR9ajajtdKrjoeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741098248; c=relaxed/simple;
	bh=9Bl9KwN0gqToxnWw3xRARnhDd5Ny5Hr/yDwL7Fo49yo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hsci1y0zNZAeaQQ/r9JeY3pSXo+KSBNncRfTzJxios+EiiHF7//efJdiaIXRwS9Yruocn0LxfeUctmOryw4353i47i/nGEr3GDmvgMCq0yLlLqfFsGcjWeTiLKVaOcN7rsjNS7XVC6/mEaex0MsIepxEbFIB8E8HN6iAhrH94f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WDMJUclK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fec1f46678so13017121a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 06:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741098247; x=1741703047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U0bJtWO/zgI2jPul9efwN4/8kC8XZP1YPShn0ZzQqIY=;
        b=WDMJUclKq45kt3hPwuLAd1qIRAaWNrKMPirGfZb9Y//YZeBBO+GaAn6QZIYZJ4vV1/
         GcnHl/pvY7p4m51Po0u36wTkApihcVF3dADWrDVQMRDi9Ajff+UGOvfvO7XL6OOIzNN7
         BUzSHxWDJGW5xTiKKz3GMA9tiYYL+fTx2bEJC1E/96UMEwnpZSY/wsfxysX+PYnGyVlk
         M+Vc9QmetS1Cwm/RLvwUsDoUW2XXDmqZcq4qKTTa5/DONO328PeMBJoaHxtmUCpQwCpo
         UIxlUcakLx5pgcQZlfApPFqMifJq/sBeBNbqED29MloHNH3roo44xk3cWu1C6x79uIpa
         1LZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741098247; x=1741703047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0bJtWO/zgI2jPul9efwN4/8kC8XZP1YPShn0ZzQqIY=;
        b=P3sEuhELlV+mbcG0pTnwT9Ra0o1eaWILRkspe6JLH64owASY3ZHqy/bUA73qBQom3G
         ZdW3/b74Fm//rHlzmPCLOC067gkY/zZ3LS0Mxx539o0n4Y9PkiFIsogr0dRdJAvyCXND
         j/4ob1kvTS0tZ/e00R2B0WfDceiz3a0ODJHVTsAnZ7kbO5HEMAWSi6DMyK3oxxAG7ydh
         0JWu7j5nMzlQRYc8qnmvZOa2q80v/qWvkRIaZzVkzlJuEIg8JMhiI1IcVOCPAx3RsFUU
         HCJR8dUMXG8m58UjScIYAHT11e+XpCblgzHhNOTubme01HEI7eyV+TiWjKIIC5vH0OAM
         5q6g==
X-Gm-Message-State: AOJu0Ywm5yvtbw1lj00ClsWa3v+frpxsPc7cVyYxqw/PNoEferN3ss4V
	o2M/5cpcVwYVole9Qq6Fyzoz5QNag0AnpUG5yZsauMyfkVJUmr/Ss3p9NtMOndvdasWZLTW6XHF
	3nw==
X-Google-Smtp-Source: AGHT+IGL3TvS3xJpuQuBmUEPAOK05SjuoCnEI7eL2mdXhB6ZVp9f2QmZKZ+Ad458Pw2V2VPF2vgblI0mNPs=
X-Received: from pjbsj5.prod.google.com ([2002:a17:90b:2d85:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c6:b0:2ee:53b3:3f1c
 with SMTP id 98e67ed59e1d1-2febab2ed89mr25640807a91.5.1741098246542; Tue, 04
 Mar 2025 06:24:06 -0800 (PST)
Date: Tue, 4 Mar 2025 06:24:05 -0800
In-Reply-To: <87ikoposs6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z8ZBzEJ7--VWKdWd@google.com> <87ikoposs6.fsf@redhat.com>
Message-ID: <Z8cNBTgz3YBDga3c@google.com>
Subject: Re: QEMU's Hyper-V HV_X64_MSR_EOM is broken with split IRQCHIP
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 04, 2025, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > FYI, QEMU's Hyper-V emulation of HV_X64_MSR_EOM has been broken since QEMU commit
> > c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), as nothing in KVM
> > will forward the EOM notification to userspace.  I have no idea if anything in
> > QEMU besides hyperv_testdev.c cares.
> 
> The only VMBus device in QEMU besides the testdev seems to be Hyper-V
> ballooning driver, Cc: Maciej to check whether it's a real problem for
> it or not.
> 
> >
> > The bug is reproducible by running the hyperv_connections KVM-Unit-Test with a
> > split IRQCHIP.
> 
> Thanks, I can reproduce the problem too.
> 
> >
> > Hacking QEMU and KVM (see KVM commit 654f1f13ea56 ("kvm: Check irqchip mode before
> > assign irqfd") as below gets the test to pass.  Assuming that's not a palatable
> > solution, the other options I can think of would be for QEMU to intercept
> > HV_X64_MSR_EOM when using a split IRQCHIP, or to modify KVM to do KVM_EXIT_HYPERV_SYNIC
> > on writes to HV_X64_MSR_EOM with a split IRQCHIP.
> 
> AFAIR, Hyper-V message interface is a fairly generic communication
> mechanism which in theory can be used without interrupts at all: the
> corresponding SINT can be masked and the guest can be polling for
> messages, proccessing them and then writing to HV_X64_MSR_EOM to trigger
> delivery on the next queued message. To support this scenario on the
> backend, we need to receive HV_X64_MSR_EOM writes regardless of whether
> irqchip is split or not. (In theory, we can get away without this by
> just checking if pending messages can be delivered upon each vCPU entry
> but this can take an undefined amount of time in some scenarios so I
> guess we're better off with notifications).

Before c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), and without
a split IRCHIP, QEMU gets notified via eventfd.  On writes to HV_X64_MSR_EOM, KVM
invokes irq_acked(), i.e. irqfd_resampler_ack(), for all SINT routes.  The eventfd
signal gets back to sint_ack_handler(), which invokes msg_retry() to re-post the
message.

I.e. trapping HV_X64_MSR_EOM on would be a slow path relative to what's there for
in-kernel IRQCHIP.

