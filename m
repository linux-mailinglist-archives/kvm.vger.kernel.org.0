Return-Path: <kvm+bounces-60373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B731BEB857
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F23A04F31E8
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 20:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD7A340A4D;
	Fri, 17 Oct 2025 20:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GPCu6NB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EDD3064B7
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760731974; cv=none; b=NGXr2EBgiPbN98J/NczhiCwDUbl42d4S6HSdaHSPbOFeivBLQcfVwReg0GL9q8kaKJosKYQaSrhDxQTPQaCX5LTsoWKU6jwrIasp3e6Z9CoFG3xx2p/dKx7ITMKo0325XrPr4mDSWWEJ08g0fyAN4x209By0Ljk4sQKD6FxDKrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760731974; c=relaxed/simple;
	bh=5sPCbmVaZjwOnK8esh5b6y2EMzjDjIkrPLz3+NCgVqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cv+2XP6vcIs39W7C0R2hb5D+eeYKWUhRB3uORfIpO/b7XDp4d7rYfp+AlvhaJ+AI3M6WeXtu8b/Q1HwFcvlEpxPjcvtA7e3pBw4JJsi/YX2D7F825nRhHlcqNRfdkiyJd9xkTY1o4L8qDb68M/9GEzw80OsB+2xaEko+rxl/4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GPCu6NB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so2008885a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 13:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731969; x=1761336769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KR72vgpCvELPyR/ICJ3IjpNbxUCWAnmK6eB3NpuYbR4=;
        b=2GPCu6NBEQ55fkAt62GWgZJGk65LERr9vIAnjHp/c3Z8GfUJGHtq0HPcHoH8N0y1o/
         nwQgm8NIDrox+5S8SdA46S7Lxqcao+Ahby6IPylziz6YP/ek2uywwB/ekjMKBhn/nSB0
         d7LagSCiX2+mGIihCUzlfZggCfiKjxcGAJ5Wl9lZXH+msnTYEdmNZSKZ76q+X2Np2Y1P
         AXRGOQ1nlvjNvTa09XdWT2YdYMZX3ftUApXUCVgd+6oD0Lqx0Yi6573wGNIkG7c2b7Wf
         2M5UzNj73z/5djAQQWSyGsoOblkvVU6ND7tMS2vfWCUwUjf3XNyHEeI/dghRLs2A4BS1
         8TIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731969; x=1761336769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KR72vgpCvELPyR/ICJ3IjpNbxUCWAnmK6eB3NpuYbR4=;
        b=YxXHzKw9DIhQBK0Ferwbz2wAG0Z2tFBqS9f1etFHmISaK4no5+yYxDQs4H/L/tb1lQ
         VvBM9Qclzt5cSYgmigKW3ugfZPkHrnb4hHhygNqVVquQ54TCBklcqRU/RDnYVHxDrkRP
         nqnGzwXj+jzBEyCE0Jfk1hI2OpVZi8hrNXhk4c3oUPJTbIdH+gXaKwqGGAn1j+to4jjn
         ueKJCnR6WSneiT/nwjMC6w71QifBkyGJw20cLjGkK1HFJVuLxULG0J7xwCt23jaw0qnX
         KEESH118sGue4HXD9REUTwlVk88S4WX+uJ7HCpGSIh0Znlux7ghBrf4/XbNHwTkiDikM
         3pgw==
X-Forwarded-Encrypted: i=1; AJvYcCXse3GfLDfUJmrpAFrBACfiEIaaNZDDysU/kNAXCb0HhSC+wVxbF4ANF3XGOvDv4JVuVq0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1oxVoe96p+IH9Bst+ZRKtl9BaRnC7FW0KqLD46k1ACd2ePcyM
	HMK/eHJv+bNqRAbMMSONHuae9nAMcIhoY9DT/2cwJM4nSrB24wmR4LJR4wTQV6jnDXKJleWzLPD
	Fo7KR6EGG1hdn7JmYMwBmJBhxSg==
X-Google-Smtp-Source: AGHT+IGTLI28yZrk0rADnL8AJRnYpgX7fVX5tQYbza0e4ND5OU4Hj5SMJ3v64nlbDhoh1Pqxs5RCZmim7dvJP9f9Zg==
X-Received: from pjbdy13.prod.google.com ([2002:a17:90b:6cd:b0:33b:ce80:9efc])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e46:b0:335:2823:3683 with SMTP id 98e67ed59e1d1-33bcf953e72mr6347941a91.9.1760731968802;
 Fri, 17 Oct 2025 13:12:48 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:53 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <36defde6a09d2a7b4ff5507b752546a906b262f9.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 12/37] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

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
index acb03b45ba050..49c7709e3d895 100644
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
index b3473aec4d24d..72b19813e5412 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -112,10 +112,6 @@ config KVM_MEMORY_ATTRIBUTES
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
2.51.0.858.gf9c4a03a3a-goog


