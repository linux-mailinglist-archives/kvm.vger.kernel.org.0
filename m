Return-Path: <kvm+bounces-32069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF5D9D29F1
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 16:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81D5CB33CB0
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822871D07B9;
	Tue, 19 Nov 2024 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WxYnmFsT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3003478C76
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030673; cv=none; b=P5em7ciRdrPFsuhx+6Bwyr1u0+BSSZ1IB1qQJKf4wTEYzEapd0i6MO+SCbhjPlfWgE7rS0okoBgEeryYzMmrWvBXLWmNCZopCDManrqHssmVYOjpgK46z6FnOsd4JUfjJbqn3YCw9JVlFjGm0cR3yUPWHUJpwKUDJks7hMY8puI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030673; c=relaxed/simple;
	bh=9pH7ZkeY4viWe7Wod5zfr5y5mOdJFAFbwB72hayvvGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7csoCihCZ5lfkVI+D+kjaLKLTZQQvDWWZLdG1jyWFvbVQLpE4yWlg+0i9A/b+kbdUw8TXPSEkRRSCV9OWA6wUGCZICTi4FDz/ipFhQ/S1jBaCT4UieM9q1MGD0G+pSKrJZz2RUOI5UD4L/MQIJOt/YupqRGKHQSEcdCYyRrB7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WxYnmFsT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732030671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UFFvFWWnWyZvXw5qfQp0QkusU/cmiYrMNoaijrYT6Zw=;
	b=WxYnmFsTh1VKnOyjeivpXhvhNB8Z2uuwFr6HuiWlB6+/dz81FTDXTl+JCsCaeKhuX/vyNO
	pDCP68CXG+h9CtY+QjaEYg02XYwBWoSAdOJgD4og2cDMbD+TkIH8sIeKq464jgq5Vwnbev
	E8UZsu6EApDTAx3laFJJwMst0HA1SK8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-8NjzI6AZPs6iJgNCQczRug-1; Tue,
 19 Nov 2024 10:37:49 -0500
X-MC-Unique: 8NjzI6AZPs6iJgNCQczRug-1
X-Mimecast-MFC-AGG-ID: 8NjzI6AZPs6iJgNCQczRug
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF4C91979052;
	Tue, 19 Nov 2024 15:37:43 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.39.194.94])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B133F30001A0;
	Tue, 19 Nov 2024 15:37:27 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	x86@kernel.org,
	rcu@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Nicolas Saenz Julienne <nsaenz@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Nadav Amit <namit@vmware.com>,
	Dan Carpenter <error27@gmail.com>,
	Chuang Wang <nashuiliang@gmail.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Petr Mladek <pmladek@suse.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Song Liu <song@kernel.org>,
	Julian Pidancet <julian.pidancet@oracle.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Dionna Glaze <dionnaglaze@google.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>
Subject: [RFC PATCH v3 07/15] x86/speculation/mds: Make mds_idle_clear forceful
Date: Tue, 19 Nov 2024 16:34:54 +0100
Message-ID: <20241119153502.41361-8-vschneid@redhat.com>
In-Reply-To: <20241119153502.41361-1-vschneid@redhat.com>
References: <20241119153502.41361-1-vschneid@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Later commits will cause objtool to warn about non __ro_after_init static
keys being used in .noinstr sections in order to safely defer instruction
patching IPIs targeted at NOHZ_FULL CPUs.

mds_idle_clear is used in .noinstr code, and can be modified at
runtime (SMT hotplug). Suppressing the text_poke_sync() IPI has little
benefits for this key, as hotplug implies eventually going through
takedown_cpu() -> stop_machine_cpuslocked() which is going to cause
interference on all online CPUs anyway.

Mark it as forceful to let the kernel know to always send the
text_poke_sync() IPI for it, and to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f60..dcc4d5d6e3b95 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -114,7 +114,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 /* Control MDS CPU buffer clear before idling (halt, mwait) */
-DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
+DEFINE_STATIC_KEY_FALSE_FORCE(mds_idle_clear);
 EXPORT_SYMBOL_GPL(mds_idle_clear);
 
 /*
-- 
2.43.0


