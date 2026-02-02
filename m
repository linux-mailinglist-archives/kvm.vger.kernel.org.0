Return-Path: <kvm+bounces-69926-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAvEAD0mgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69926-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:33:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 941A4D233C
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3B1F5301FEF3
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBE038E5FA;
	Mon,  2 Feb 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M1CuXaYG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9117238E5CA
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071443; cv=none; b=iuSuyFzQRR9vY5jxnZK189Sa/98ttwg/jVO+qgE323q0FqsL25+XJBDwtRGDZu2LGor0hmrGSGZBdu2K3H1FiXeIIj3+kp1fXlDo1guS/rlb5h1td97/Trb2xg8pv8N71lnx7gknniCcD6oaE4zOCx/AqLLOAaXsaTDPIaYpdOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071443; c=relaxed/simple;
	bh=wjFLG9ZoUawzWzbxQEYs3yXL7HheO+oB6lVml9w7xBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AP6j4Q2N9vCr8X8pIhs6l2z9/vN7I8UOZhl51Dizze5/Y8mVaDabanuC/qNwTxzcQU+bCpEp1EieKiJm/9JNYjY9TYHzpaOyg818QwHT/b+2HWmIQeOzjPng3n9GMxA/CLkT+BQPEKmiyaVT7Q1T3oCOprN7o34rBQ62wOQ738k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M1CuXaYG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so3391519a12.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071441; x=1770676241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iEns3OzC0DhCSE4NhBXD+eHGA3wBWzKtR7XwA//JjDU=;
        b=M1CuXaYGlfBWbuvwpsNIgKdY/TZ8umzuZ6rdYJKpZl+DPxhe3lZ3rZS+V22IkZqW3t
         VdCX7MeWLcZqvtChj9ONIC9q/KsVbWQLmvAOddDTDbMcNlpWAPKqyIGFZtATNP2As5wO
         HyaYNHKmjO9a9ksog17d/eXcKxYf1lUKZI57eg/QvIJN0s502sEY46d17pz+4ORHqUnV
         d+eucYTGa1RtovK42Ts0FhMoH7cIIm/lRso7llTe/pOKNPE9Joe2x95ATM7UtzaEhMDU
         WheOdMfrv8S4rY2vpC2VqJ+SjZFs/eNt8WTznml0gQB9wVCthgZRcNzTkV30kTNciRii
         Q8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071441; x=1770676241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iEns3OzC0DhCSE4NhBXD+eHGA3wBWzKtR7XwA//JjDU=;
        b=nMpcz2kRKEr6YSCHY+WaO3qVFhRFBblQVzNiiUVjTGptwg9Chm8NMlyods/Yjdfj+O
         AfInfzCU8EH7wkyQyoaO97+zlENCSfjDnp70EdE5Z5WucH4ZAoXRgf0KjLuPfYEKcaFO
         dsIalBqmGYCongga2qdbYW1wpuJCghUgIkePWr5rew0qxBa+EKqgYrGGFU5Z+BltVNn6
         TG0b8tXtlloudaPpMFrG6rnZhEg3VtUloak5It94R7VLO8YnBPstahM9yzrmuuCiLgc5
         4vmvaBpSMnxxOLDsJ5YHc87b1umA8h5wNe34iPRMMrnxOQ8MYsMB2/uAzyoah8BiiRzq
         nZtg==
X-Gm-Message-State: AOJu0YyyUdzxdEjD9GuDG2bng9GwsLUbd/HCO6/NXLvad6mWOa6xhw2G
	+ZIGp+wEW0HBKtr+GGhjgvTNLZ+XrJ1nYvAmPn6/ed/Unbo7vjdk29dITUlWqyufYlnaPfyaLtl
	kerVcAGcOhsAIiMLdfA7FsP9FYECEQFJygwyQGlcSUg2vPfAgvq468Kn3B2K46RbCDYY1gFP6/Z
	l4IHzo6tpknfkt6ie9wRZmhBUQP6vd05N9hlLHfZ6B49pCXZpDqNUYm4joI3M=
X-Received: from pjbmv23.prod.google.com ([2002:a17:90b:1997:b0:352:f162:7d9f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3dce:b0:341:2141:df76 with SMTP id 98e67ed59e1d1-3543b30d84bmr11975440a91.13.1770071440682;
 Mon, 02 Feb 2026 14:30:40 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:49 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <f8d18a4fd16a2eb595c29b23ba54bb7f7ee238af.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 11/37] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69926-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 941A4D233C
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
from adding support for per-VM memory attributes, because tracking private
vs. shared memory on a per-VM basis is now deprecated in favor of tracking
on a per-guest_memfd basis, and no other memory attributes are on the
horizon.

This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
Now that guest_memfd support memory attributes, it's entirely possible to
run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.

Leave the code itself in common KVM so that it's trivial to undo this
change if new per-VM attributes do come along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 virt/kvm/Kconfig     | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1683dbab870e..385f26da48ae 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -80,6 +80,10 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_VM_MEMORY_ATTRIBUTES
+	select KVM_MEMORY_ATTRIBUTES
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index f42bc6e7de44..6f6e7da895e3 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,10 +109,6 @@ config KVM_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       select KVM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select KVM_MEMORY_ATTRIBUTES
        select XARRAY_MULTI
-- 
2.53.0.rc1.225.gd81095ad13-goog


