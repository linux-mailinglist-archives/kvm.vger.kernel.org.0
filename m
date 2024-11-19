Return-Path: <kvm+bounces-32078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 208A79D2A4B
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 16:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2320B35FC9
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4D81D61B1;
	Tue, 19 Nov 2024 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OICJEgQh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629821D1F73
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030803; cv=none; b=RJrWlatYEB4BHJt8nhurwvCnILQwH+d5UkmeeHgjKLEi0DevK/ynUMqX+VD/6WR5lqN/NvjMvA4juhrKLPILwRdWuGNmRkonDWkIFA9rSCTkQH7XtmElhIruVaKQkHjShELhmeFLfHddtFmewkiuLsrNF5j97jkOc9cwj2Yc58c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030803; c=relaxed/simple;
	bh=FDSvP1EhYqYkFNY54ZUxRHJZiVHOU5zN9wYGjv6JRq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5qMhMpuygtyRGpZoeRUSTy1284cUbu1/qaAwduEvakgS6WDHTrJOzS5/gMUJVPJACjgS5yug4Y0LZi2MCkvBxHxksx5ikcdOaOCKzay7F705FNZ8LPI6xSTZbFOAm0X7j1XHYpDzEZ91XnsGcsMu+kT9b96qDhFahuc8PDE3fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OICJEgQh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732030800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F1GnqQSFPr8VITMqjCT6H9sq2glpq77hQWm9Vj7AfgE=;
	b=OICJEgQhlqvRogHx92dhLfq7JCpGGCfyKI3RpuKIR+izFdYESAGX/yxLUD5U1ZLxF/Qn8w
	A5LXOPhn61tKr4vgY/9/WXMRuAZJ3caT5gtZIh9dSHzOh7kofZWyGP7UB12G8UOzfbsV6D
	00OI6vt0P0V0mw8NqYdbdR5CuH1RHcY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-92ypQAdDPJmP9uLfkEuaoA-1; Tue,
 19 Nov 2024 10:39:57 -0500
X-MC-Unique: 92ypQAdDPJmP9uLfkEuaoA-1
X-Mimecast-MFC-AGG-ID: 92ypQAdDPJmP9uLfkEuaoA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15EC119541A0;
	Tue, 19 Nov 2024 15:39:52 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.39.194.94])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63E1730001A0;
	Tue, 19 Nov 2024 15:39:37 +0000 (UTC)
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
Subject: [RFC PATCH v3 15/15] context-tracking: Add a Kconfig to enable IPI deferral for NO_HZ_IDLE
Date: Tue, 19 Nov 2024 16:35:02 +0100
Message-ID: <20241119153502.41361-16-vschneid@redhat.com>
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

With NO_HZ_IDLE, we get CONTEXT_TRACKING_IDLE, so we get these
transitions:

  ct_idle_enter()
    ct_kernel_exit()
      ct_state_inc_clear_work()

  ct_idle_exit()
    ct_kernel_enter()
      ct_work_flush()

With just CONTEXT_TRACKING_IDLE, ct_state_inc_clear_work() is just
ct_state_inc() and ct_work_flush() is a no-op. However, making them be
functional as if under CONTEXT_TRACKING_WORK would allow NO_HZ_IDLE to
leverage IPI deferral to keep idle CPUs idle longer.

Having this enabled for NO_HZ_IDLE is a different argument than for having
it for NO_HZ_FULL (power savings vs latency/performance), but the backing
mechanism is identical.

Add a default-no option to enable IPI deferral with NO_HZ_IDLE.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/time/Kconfig | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 04efc2b605823..a3cb903a4e022 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -188,9 +188,23 @@ config CONTEXT_TRACKING_USER_FORCE
 
 config CONTEXT_TRACKING_WORK
 	bool
-	depends on HAVE_CONTEXT_TRACKING_WORK && CONTEXT_TRACKING_USER
+	depends on HAVE_CONTEXT_TRACKING_WORK && (CONTEXT_TRACKING_USER || CONTEXT_TRACKING_WORK_IDLE)
 	default y
 
+config CONTEXT_TRACKING_WORK_IDLE
+       bool
+       depends on HAVE_CONTEXT_TRACKING_WORK && CONTEXT_TRACKING_IDLE && !CONTEXT_TRACKING_USER
+       default n
+       help
+	 This option enables deferral of some IPIs when they are targeted at CPUs
+	 that are idle. This can help keep CPUs idle longer, but induces some
+	 extra overhead to idle <-> kernel transitions and to IPI sending.
+
+	 Say Y if the power improvements are worth more to you than the added
+	 overheads.
+
+	 Say N otherwise.
+
 config NO_HZ
 	bool "Old Idle dynticks config"
 	help
-- 
2.43.0


