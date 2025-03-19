Return-Path: <kvm+bounces-41499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F147A6949F
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC5EA463AA7
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 16:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437B51DDC0F;
	Wed, 19 Mar 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ZTJtdp/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FF52D78A
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742401060; cv=none; b=gtuYKSpY71GGiNrzafPujoiQacyRM+dVNcLhLy/A0XEOtsMCIcXqeO79kuKCtnjUCPKtkTEPPncceS3bQMsdySF9IM0I2c6y7TAlKBQW9tP5GnaWRckARfCXrN49JgagUsV4p++r882FMKmQxwxmICbFAsaWR7SUCBUcn5gN87k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742401060; c=relaxed/simple;
	bh=jbOC+o3+3slq/d0ASbLVedkAIa2bznIj8Peq9h8P6uI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N/EOlJE2DUBW5ZQP8OHUJGXQ4k5WJocTmqZhiF2mtUEwDJEe6IgmVS7shFMGCKCfM86vNkSqm6JKH9epITUZjxgucerlZTDjzW7FnxEhX8I52MFQF39AJ7MA8HFdvmnXLxZUxVU56RDkwr1nKxLV1P5UDMuJzUIw74nRtHYarms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ZTJtdp/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff581215f7so5541226a91.3
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742401058; x=1743005858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WoD5DKfQqevYzurdQIu8nnKIp6f3nd6/1LVx52oUP4U=;
        b=1ZTJtdp/uWSsVEIx+4E/g2H3QSl3G/QXOCaSE5B25oJmBtEOTq9Rh5I8XSwJ+Hw/f4
         4UczgTvg8xzFGwOe4qFBg3GojoNTRnDsVIS8lAzu0Hv0l7eD67zJfVh/X6bAi59H2WEb
         xhKOpZvIAZV2o5+7ON5dFUJzhNZnTmxolHZkTbEAwxT7RhwvV9eLR6K1Z4qU2xBQoiTv
         SoTCLMen49vLiLVQuDrC+XhH9FC11VhbHFvt6j/nPGgTCmHpdM69tYuknRtr4JY2tb4q
         9VzRju/6xG5Fbb6WBVegq8DqigISyWHL4qk8yQ7tr7qy7lLMfR4vixj8rC71/TwIM1vV
         aFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742401058; x=1743005858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoD5DKfQqevYzurdQIu8nnKIp6f3nd6/1LVx52oUP4U=;
        b=FE+l5R361fjPjExdxY3u0buCgvrczNobjyS/46NJ5ySNxM0bdExDI6ZZ2S4kfJpfKb
         O1ZeEKbyiBJvkRT6moy7Hb26oZri4CM421a+KWk1OPCv93t7aEZ1tSothxVvBOTCJ6vC
         ahJ72eb7ogU5NAIXoucN2yRDMyVp0k49c5zKZRcB/zOCAApWgpKQeNgn6xqQTtOHxh2f
         qH+DGVRG41bA45NWcpvlu/ZarCdnTMlWpS0xeBlDa9B+yjksNqRUAHduwqkyYh9mI13T
         crFvejqrhdArYRcrRN0qpWmxRZ7KtowMllykHDClV51p2Yu7/0Bt6eMIabfoi+C4mjFX
         /Vsg==
X-Gm-Message-State: AOJu0YxGj3laQY4LSJoZti3YurZ42OvKjgF1BvGsYCi6hMTH6myMDW6g
	lA0gikxNQy94tvAMQfyqs0iNIdAYzbiMC6iEH8Y0DcDpKh1fOMfIuNQgpj26xXWppx2N52igPrx
	zlw==
X-Google-Smtp-Source: AGHT+IHBAquCFoLXFaKF8VR+x5dMwMJATO0BsCvU4An0lFbtqwfhCCbV5yQaIKtgTPJ/WL/4K7xnyVPHHkk=
X-Received: from pfwp28.prod.google.com ([2002:a05:6a00:26dc:b0:730:880d:7ed5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3943:b0:1f5:8220:7452
 with SMTP id adf61e73a8af0-1fbebd7b90cmr5800518637.24.1742401058261; Wed, 19
 Mar 2025 09:17:38 -0700 (PDT)
Date: Wed, 19 Mar 2025 09:17:36 -0700
In-Reply-To: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
Message-ID: <Z9ruIETbibTgPvue@google.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock lock
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

+James and Yan

On Tue, Mar 18, 2025, Maxim Levitsky wrote:
> Hi!
> 
> I recently came up with an interesting failure in the CI pipeline.
> 
> 
> [  592.704446] WARNING: possible circular locking dependency detected 
> [  592.710625] 6.12.0-36.el10.x86_64+debug #1 Not tainted 
> [  592.715764] ------------------------------------------------------ 
> [  592.721946] swapper/19/0 is trying to acquire lock: 
> [  592.726823] ff110001b0e64ec0 (&p->pi_lock)\{-.-.}-\{2:2}, at: try_to_wake_up+0xa7/0x15c0 
> [  592.734761]  
> [  592.734761] but task is already holding lock: 
> [  592.740596] ff1100079ec0c058 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu))\{-...}-\{2:2}, at: pi_wakeup_handler+0x60/0x130 [kvm_intel] 
> [  592.752185]  
> [  592.752185] which lock already depends on the new lock. 

...

> As far as I see, there is no race, but lockdep doesn't understand this.

Yep :-(

This splat fires every time (literally) I run through my battery of tests on
systems with IPI virtualization, it's basically an old friend at this point.

> It thinks that:
> 
> 1. pi_enable_wakeup_handler is called from schedule() which holds rq->lock, and it itself takes wakeup_vcpus_on_cpu_lock lock
> 
> 2. pi_wakeup_handler takes wakeup_vcpus_on_cpu_lock and then calls try_to_wake_up which can eventually take rq->lock
> (at the start of the function there is a list of cases when it takes it)
> 
> I don't know lockdep well yet, but maybe a lockdep annotation will help, 
> if we can tell it that there are multiple 'wakeup_vcpus_on_cpu_lock' locks.

Yan posted a patch to fudge around the issue[*], I strongly objected (and still
object) to making a functional and confusing code change to fudge around a lockdep
false positive.

James has also looked at the issue, and wasn't able to find a way to cleanly tell
lockdep about the situation.

Looking at this (yet) again, what if we temporarily tell lockdep that
wakeup_vcpus_on_cpu_lock isn't held when calling kvm_vcpu_wake_up()?  Gross, but
more surgical than disabling lockdep entirely on the lock.  This appears to squash
the warning without any unwanted side effects.

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..5984ad6f6f21 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -224,9 +224,17 @@ void pi_wakeup_handler(void)
 
        raw_spin_lock(spinlock);
        list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
-
+               /*
+                * Temporarily lie to lockdep to avoid false positives due to
+                * lockdep not understanding that deadlock is impossible.  This
+                * is called only in IRQ context, and the problematic locks
+                * taken in the kvm_vcpu_wake_up() call chain are only acquired
+                * with IRQs disabled.
+                */
+               spin_release(&spinlock->dep_map, _RET_IP_);
                if (pi_test_on(&vmx->pi_desc))
                        kvm_vcpu_wake_up(&vmx->vcpu);
+               spin_acquire(&spinlock->dep_map, 0, 0, _RET_IP_);
        }
        raw_spin_unlock(spinlock);
 }

[*] https://lore.kernel.org/all/20230313111022.13793-1-yan.y.zhao@intel.com

