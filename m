Return-Path: <kvm+bounces-32071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD269D2A87
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 17:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 060D3B344B8
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6541D0F50;
	Tue, 19 Nov 2024 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ksdh/qUf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D2E1D0F51
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030690; cv=none; b=bFW5K7BcL5S2dAZEza1sfzmHxvPiT7DNULLqEfwj62cwwG4AYd4LVuW5tWdsTda5JDYBy2PdPUk52xYkmqRDRvkptURrzqOc6/JPznJuWkF/PePYMwbBjaMBE8nqh5HK8z5NKYmLAk47tydhUvNIGY+reSr97TNrCw78JH+OUp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030690; c=relaxed/simple;
	bh=WcoRXmH8EHSSUkrYncG38ywpgNOrSaCBNAPretltWvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIAp+9bxbQbG3j1E9dq0+va/roGvt4pCBm8SuNFHJlitreMAargO8fOGEYGg1roeYQ+mtx+0hdvnkh005ZaZ1ro8Ig3c3AYos2MCpbSF+xHilnxrPJdUvOtY8taASqKXxVIe8WosCkmIck2kBFjWqFSEbslvOEglYhedFi5Epqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ksdh/qUf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732030688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpSGcS2OHkivSptNEqV1yoUV7L+1Tpt77Idg0XadxAw=;
	b=Ksdh/qUfMGAu3JF60FBMQQA8j5wcLeTDikdgTdcG/3VfJ7rqNBrEJ3w6b83/WBkylTaf9p
	GJrpI8XeDKN4Qci7qUdjy2EHfJycO42eIA1roL9NZsOV6FOnAKmEdbSABiOKL/AFzDT5yF
	EgBcphIs5Mu7KHFkPluWl44QWo8zcnk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-209-w8WZReDNPhuTuNl53MRXLw-1; Tue,
 19 Nov 2024 10:38:05 -0500
X-MC-Unique: w8WZReDNPhuTuNl53MRXLw-1
X-Mimecast-MFC-AGG-ID: w8WZReDNPhuTuNl53MRXLw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F25E1955F41;
	Tue, 19 Nov 2024 15:37:59 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.39.194.94])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59F3B30001A2;
	Tue, 19 Nov 2024 15:37:44 +0000 (UTC)
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
Subject: [RFC PATCH v3 08/15] sched/clock, x86: Make __sched_clock_stable forceful
Date: Tue, 19 Nov 2024 16:34:55 +0100
Message-ID: <20241119153502.41361-9-vschneid@redhat.com>
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

__sched_clock_stable is used in .noinstr code, and can be modified at
runtime (e.g. KVM module loading). Suppressing the text_poke_sync() IPI has
little benefits for this key, as NOHZ_FULL is incompatible with an unstable
TSC anyway.

Mark it as forceful to let the kernel know to always send the
text_poke_sync() IPI for it, and to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/sched/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 200e5568b9894..dc94b3717f5ce 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -76,7 +76,7 @@ static DEFINE_STATIC_KEY_FALSE_RO(sched_clock_running);
  * Similarly we start with __sched_clock_stable_early, thereby assuming we
  * will become stable, such that there's only a single 1 -> 0 transition.
  */
-static DEFINE_STATIC_KEY_FALSE(__sched_clock_stable);
+static DEFINE_STATIC_KEY_FALSE_FORCE(__sched_clock_stable);
 static int __sched_clock_stable_early = 1;
 
 /*
-- 
2.43.0


