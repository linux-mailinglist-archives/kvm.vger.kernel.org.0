Return-Path: <kvm+bounces-72405-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mBFzKcXDpWnEFgAAu9opvQ
	(envelope-from <kvm+bounces-72405-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 18:07:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 200F71DD853
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 18:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3C1483046AB8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 17:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E504F426D07;
	Mon,  2 Mar 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T1FIhc6F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D1C426685
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772470964; cv=none; b=hXbwbvHqVelhykyr3jFuJ9+F2ytH8UqZOFE7GC9wM9ilQCa/ZNx1Bn2ZhQ6xTl95pybsz0hHaDWxjwMJuDHjvIFfcHlFf6840rNsM8iHDwfzXalUh9GHPishmEaCYPvfkOA+IjeE7OSXdIM2tza466s0/IC5/2efx5xFzbUE3XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772470964; c=relaxed/simple;
	bh=f7f6RNaV0yL3M61YiC7jd5CCIvUd17Z5NSWa/2LOMhg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Knk9nEYKlQzzoDQrYFfrf5rsVVOv8EgKXt/qhBi+pDwgG/4FOgHTPgRv+v0oiHBbtu8hYI05NjoP1uDtr+LGKRaMPus5OXB4pRjOsC4wL2MQdjhsBK4Yiu5CRn40wAJ4DmVYbilrK+ERflvaZM2BCeki0COldjlDlZswgGM5vYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T1FIhc6F; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70f137aa4aso2753258a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 09:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772470962; x=1773075762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7nIJKnAoTlZY5dkO0+xgnDvgGoKc3sJhm52pQfwJ7k=;
        b=T1FIhc6F8MXdZikqypWZJAlmBBUGA/YLvfF0axgVD/DQkwzweQjvmFwRcNxsDyzuR/
         TMYIcgj/lqGYSvnMNHQte7uKGNFqVWckWexF4OtE6XnNO+zNc1p7IZQIjnZe/3DS+TYY
         R78xAMio1GS+iqsFVMLUPGWwTjGJVCINnPH4IS9YwwBs+hpThO7zR+ktYbvOA7DOJwrz
         iEDQDhFQisbrAo102Y7sHmbFE3m/VxtQL1zeQHxBAjipl8ksugOAsoHVUjKhbsImEAXz
         rOkn2WXef+5OCWTFxqBFTO08cVunbPcPkgMSWEbLvDJUHcsDsjSTVlrCayDEhNCyngOO
         Fgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772470962; x=1773075762;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D7nIJKnAoTlZY5dkO0+xgnDvgGoKc3sJhm52pQfwJ7k=;
        b=EU2XkPTVnS+8s5D3M21nJxeu+UVay6vRoC+pXNxWjy9yZn2c6TBU+0n2e0wup6gYw5
         n0wpN3a7uTZMJSEWGX9PfATna5RIuMtffFcDp1kaJzx79NRIf/0oqNN4JMt/1i6d8If5
         IL1AyAGcQ8neKtgh687AUGawWq9eS3BVGQyushScn/srF/6fcpqBqrwSa3VN05b1iel8
         kSJGAAbAm/tIA56G6Ee4f7gTZxbzuQmriwr5MYaoXaNbxwoXW7IFBGu2fCZhU8eUIMM7
         SnxZ8B5NYR7/heccyVietBKvW7SS2U0Z5td4VnDdbm6qSthJ+YTJgpOTz4h90o3X6zjS
         OTZA==
X-Gm-Message-State: AOJu0YwTXytKy4s4fb87fTcM80hc29vfqTaxCarmDGjhIoe4QV4UYbYm
	WqE3MW3NBgxoVzdNHUpqihI3DjJ/e/Pd5IvDPLlKG2M0o9IiG6Z1RgdhMw4HTeQBC8DHd066I4N
	iXpIfeA==
X-Received: from pjyl18.prod.google.com ([2002:a17:90a:ec12:b0:359:8830:eace])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c106:b0:356:35a5:4a64
 with SMTP id 98e67ed59e1d1-35965c17f3cmr11375810a91.4.1772470962136; Mon, 02
 Mar 2026 09:02:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  2 Mar 2026 09:02:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260302170239.596810-1-seanjc@google.com>
Subject: [PATCH v2] Documentation: KVM: Formalizing taking vcpu->mutex
 *outside* of kvm->slots_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 200F71DD853
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72405-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.dev:email];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Explicitly document the ordering of vcpu->mutex being taken *outside* of
kvm->slots_lock.  While somewhat unintuitive since vCPUs conceptually have
narrower scope than VMs, the scope of the owning object (vCPU versus VM)
doesn't automatically carry over to the lock.  In this case, vcpu->mutex
has far broader scope than kvm->slots_lock.  As Paolo put it, it's a
"don't worry about multiple ioctls at the same time" mutex that's intended
to be taken at the outer edges of KVM.

More importantly, arm64 and x86 have gained flows that take kvm->slots_lock
inside of vcpu->mutex.  x86's kvm_inhibit_apic_access_page() is particularly
nasty, as slots_lock is taken quite deep within KVM_RUN, i.e. simply
swapping the ordering isn't an option.

Commit to the vcpu->mutex => kvm->slots_lock ordering, as vcpu->mutex
really is intended to be a "top-level" lock, whereas kvm->slots_lock is
"just" a helper lock.

Opportunistically document that vcpu->mutex is also taken outside of
slots_arch_lock, e.g. when allocating shadow roots on x86 (which is the
entire reason slots_arch_lock exists, as shadow roots must be allocated
while holding kvm->srcu)

  kvm_mmu_new_pgd()
  |
  -> kvm_mmu_reload()
     |
     -> kvm_mmu_load()
        |
        -> mmu_alloc_shadow_roots()
           |
           -> mmu_first_shadow_root_alloc()

but also when manipulating memslots in vCPU context, e.g. when inhibiting
the APIC-access page via the aforementioned kvm_inhibit_apic_access_page()

  kvm_inhibit_apic_access_page()
  |
  -> __x86_set_memory_region()
     |
     -> kvm_set_internal_memslot()
        |
        -> kvm_set_memory_region()
           |
           -> kvm_set_memslot()

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2:
 - Document that vcpu->mutex is taken outside of slots_arch_lock. [Paolo]
 - Rework changelog to not claim that taking vcpu->mutex outside of
   slots_lock is "arguably wrong". [Paolo]
 - Provide sample call chains for slots_arch_lock. [Paolo]

v1:
 - https://lore.kernel.org/all/20251016235538.171962-1-seanjc@google.com
 - https://lore.kernel.org/all/20260207041011.913471-3-seanjc@google.com

 Documentation/virt/kvm/locking.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index ae8bce7fecbe..662231e958a0 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -17,6 +17,8 @@ The acquisition orders for mutexes are as follows:
 
 - kvm->lock is taken outside kvm->slots_lock and kvm->irq_lock
 
+- vcpu->mutex is taken outside kvm->slots_lock and kvm->slots_arch_lock
+
 - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
   them together is quite rare.
 

base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
-- 
2.53.0.473.g4a7958ca14-goog


