Return-Path: <kvm+bounces-71075-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEaGE+exj2k4SwEAu9opvQ
	(envelope-from <kvm+bounces-71075-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:21:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D08BF139F59
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 35EC73030753
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 23:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635BB33CEBF;
	Fri, 13 Feb 2026 23:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+6oXq6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7512833C1AD
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 23:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771024852; cv=none; b=B5PUyPKa7VJFsdg9RrHSDT2xVIuWDOP+lrVWqvV11A1DQ8GzgLKAqW3O12y3tKxYLGxgJjw0jeYJTJKc0+5yInl1BGIEKE9SWxOKRzSqJem0jUv7CRjmsFWVeMWPvZwZmIjZVEuT/8Y47/4arM/zlikx/ysFQBP5ugdgirJXFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771024852; c=relaxed/simple;
	bh=K8pHBy6qCOCWw3ObFz5eX40XTxZVYcuWPCpZ2jTFS7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ByBn9/VJbkR9dp4svjKhQh3v8lW2OeC/Pguw1pgJD/3F4Zb9Rt6XvmhsSC/uSpw41j1xuWNpcbW69sdceHj71j0DWKQbEeiN/V+8eWOnD8rqk+Zj+LKORoXQrvD36mE9I3Ai805+q47KJxBcagCsM3qtOw1poPUZpsuviYo8FA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+6oXq6R; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso5844085a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771024850; x=1771629650; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnDyPwS4Q+llctp6LQ/SlEfYWHKNFhQHk4I55u+/ouQ=;
        b=B+6oXq6RXNKb7GF2TbokV/f/s8/H6IMLeXCYk5vD7UFtEAE2Zw241OwA1UXr5au3W2
         lgjtzs/tiWnG0U4OxupylPxROMmZLH6Nl3MtYNt60ytaTfwHbsU+onGfqwR7QohRMJEm
         V0K7Ixf/+apMkipn70TJKbF8jHK5k+FhkFNlfwiM/9FRIQDgVSSwdQraVQM6aDwFx9Mk
         e6gTaQEIhqvBX25zmzWjPDZIoWAEBn+4KaO3/QQtcEh9UAExtGvMlQbk5Uy630xA5tz/
         mqGx5tfN54C7x5c/8mEUpZJiglKV8+nuN9d4M0bX94iZcG+g1rkMkFzx4I5QcPWO05Qd
         GTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771024850; x=1771629650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnDyPwS4Q+llctp6LQ/SlEfYWHKNFhQHk4I55u+/ouQ=;
        b=m9xQFelryQgNoW8lzknRlVOcCN55QQCRO1Ew7Kx7GRXMSk9LNIKUPefwkj1zoZnRcs
         jXYMOIJruNzT9QwPTxXPIF+yErj9CC0jubWdZ4ZSUU8AYWzONkgI1buE0ISPWkgUAOlE
         9utF784pMpBbjbakh6tiH2CWzVA3b4ZCJCX6TBUsndYhfILHKNTaxWzQ+AuPe16MxGw0
         4C31l2TzAu4H2CjSQYI5aFkGx9oVklzNEUsuTEvk7V741J8K0D8eTQVaQsGvvnuQKL+5
         HtBfslDTrS3Hg8HuNIVgS/oRc1/2oFqJgI4t3Nh3SiM5aUgiPzAofHCDg7NrIxGKJoEc
         HlZw==
X-Forwarded-Encrypted: i=1; AJvYcCW7HVB5FOcFbrM4u9PeLMfm4j0CVQIvE9cDhbFcnNMidQgPtD+5ljvz9hs5ti0r2yMGx48=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNA7omXspyxlA4UYqHLvWhqLOiKOQPmtfXKTG8qusQgDW4ayOI
	tU5EA+noP0Ki/AMGC7qZv06iBJiUF24BvPY/QZs/nM49HHk07xa11n+fc4rdUtTzIfZke0a3sSG
	me6CuCA==
X-Received: from pjd4.prod.google.com ([2002:a17:90b:54c4:b0:352:d19a:6739])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc7:b0:336:9dcf:ed14
 with SMTP id 98e67ed59e1d1-356aad3cb00mr3334271a91.23.1771024849714; Fri, 13
 Feb 2026 15:20:49 -0800 (PST)
Date: Fri, 13 Feb 2026 15:20:48 -0800
In-Reply-To: <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909100007.3136249-1-keirf@google.com> <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
Message-ID: <aY-x0OlJQEqInyNF@google.com>
Subject: Re: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Keir Fraser <keirf@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71075-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D08BF139F59
X-Rspamd-Action: no action

On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
> 
> 
> On 09/09/2025 11:00, Keir Fraser wrote:
> > Device MMIO registration may happen quite frequently during VM boot,
> > and the SRCU synchronization each time has a measurable effect
> > on VM startup time. In our experiments it can account for around 25%
> > of a VM's startup time.
> > 
> > Replace the synchronization with a deferred free of the old kvm_io_bus
> > structure.
> 
> 
> Hi,
> 
> We noticed that this change introduced a regression of ~20 ms to the first
> KVM_CREATE_VCPU call of a VM, which is significant for our use case.
> 
> Before the patch:
> 45726 14:45:32.914330 ioctl(25, KVM_CREATE_VCPU, 0) = 28 <0.000137>
> 45726 14:45:32.914533 ioctl(25, KVM_CREATE_VCPU, 1) = 30 <0.000046>
> 
> After the patch:
> 30295 14:47:08.057412 ioctl(25, KVM_CREATE_VCPU, 0) = 28 <0.025182>
> 30295 14:47:08.082663 ioctl(25, KVM_CREATE_VCPU, 1) = 30 <0.000031>
> 
> The reason, as I understand, it happens is call_srcu() called from
> kvm_io_bus_register_dev() are adding callbacks to be called after a normal
> GP, which is 10 ms with HZ=100.  The subsequent synchronize_srcu_expedited()
> called from kvm_swap_active_memslots() (from KVM_CREATE_VCPU) has to wait
> for the normal GP to complete before making progress.  I don't fully
> understand why the delay is consistently greater than 1 GP, but that's what
> we see across our testing scenarios.
> 
> I verified that the problem is relaxed if the GP is reduced by configuring
> HZ=1000.  In that case, the regression is in the order of 1 ms.
> 
> It looks like in our case we don't benefit much from the intended
> optimisation as the number of device MMIO registrations is limited and and
> they don't cost us much (each takes at most 16 us, but most commonly ~6 us):

Maybe differences in platforms for arm64 vs x86?

> I am not aware of way to make it fast for both use cases and would be more
> than happy to hear about possible solutions.

What if we key off of vCPUS being created?  The motivation for Keir's change was
to avoid stalling during VM boot, i.e. *after* initial VM creation.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 15:15:01 -0800
Subject: [PATCH] KVM: Synchronize SRCU on I/O device registration if vCPUs
 haven't been created

TODO: Write a changelog if this works.

Fixes: 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()")
Reported-by: Nikita Kalyazin <kalyazin@amazon.com>
Closes: https://lkml.kernel.org/r/a84ddba8-12da-489a-9dd1-ccdf7451a1ba%40amazon.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 571cf0d6ec01..043b1c3574ab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6027,7 +6027,30 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
+
+	/*
+	 * To optimize VM creation *and* boot time, use different tactics for
+	 * safely freeing the old bus based on where the VM is at in its
+	 * lifecycle.  If vCPUs haven't yet been created, simply synchronize
+	 * and free, as there are unlikely to be active SRCU readers; if not,
+	 * defer freeing the bus via SRCU callback.
+	 *
+	 * If there are active SRCU readers, synchronizing will stall until the
+	 * current grace period completes, which can meaningfully impact boot
+	 * time for VMs that trigger a large number of registrations.
+	 *
+	 * If there aren't SRCU readers, using an SRCU callback can be a net
+	 * negative due to starting a grace period of its own, which in turn
+	 * can unnecessarily cause a future synchronization to stall.  E.g. if
+	 * devices are registered before memslots are created, then creating
+	 * the first memslot will have to wait for a superfluous grace period.
+	 */
+	if (!READ_ONCE(kvm->created_vcpus)) {
+		synchronize_srcu_expedited(&kvm->srcu);
+		kfree(bus);
+	} else {
+		call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
+	}
 
 	return 0;
 }

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
--

