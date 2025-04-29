Return-Path: <kvm+bounces-44749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00077AA0A5B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34F63BCBDE
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCA72C377C;
	Tue, 29 Apr 2025 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPRQHm9D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424B2C1E1F
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 11:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745926922; cv=none; b=D87PUigJ+q95GXSLTjNrswz3zxCjgIsO4LzC9sWtnQmfNhN8kwwKIO12iXP0oeioEO4tw6xDEXHhIgb0OZOGHxqyCAHPOx4X0R3/VOBwb0GDbs5NMmiFKp9njNUXXhImDuaHOgYvzVt/chrHOLDRZDz8JBD4RbjnBxobAokN9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745926922; c=relaxed/simple;
	bh=kxWC1t7/BhbfuL23Afr2KNhXz8vZgT9DHhKCYr4vZLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ku1FizzOV5klyAS10G8RFpK1Lc00B87XhYybo6VltUcpmtDW4q0Krf4KO1CxPvcNl1j4+zPEreGILHH7Jgp8roClywlwEgK88Nuav4oIva6PnEBAZKSp3uo9cy6Z+l6IubgJJQGNw8ErVSPNzsipWONK1LP00kYKvGVMMjVm4pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPRQHm9D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745926919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOR+/fkeCQEE32OWhR0BqyOD5/ykiIz6VrqIxRu0TPQ=;
	b=aPRQHm9DL8BhITg582uw1DUlWVjO2r0WYUZdrhJ8N0sOvOTn8mjZi+edq4GAHmj1io7pJa
	SaB4guNGLLPqHRMH8Bbw1AHtB1ZWCAEVxeTOO0j1t7ewgKf951jB//RY6ZDnU5qmeHnSf3
	GQ2nOJgwIB4Y5kHy0EATMQxyqYdlIyU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-A84IH6JAPCeA7cHwNRTckw-1; Tue,
 29 Apr 2025 07:41:57 -0400
X-MC-Unique: A84IH6JAPCeA7cHwNRTckw-1
X-Mimecast-MFC-AGG-ID: A84IH6JAPCeA7cHwNRTckw_1745926913
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 219821800360;
	Tue, 29 Apr 2025 11:41:53 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.225.102])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 227BD19560A3;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	bpf@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Naveen N Rao <naveen@kernel.org>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Kees Cook <kees@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Rong Xu <xur@google.com>,
	Rafael Aquini <aquini@redhat.com>,
	Song Liu <song@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Brian Gerst <brgerst@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	John Stultz <jstultz@google.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH v5 16/25] KVM: VMX: Mark __kvm_is_using_evmcs static key as __ro_after_init
Date: Tue, 29 Apr 2025 13:32:33 +0200
Message-ID: <20250429113242.998312-17-vschneid@redhat.com>
In-Reply-To: <20250429113242.998312-1-vschneid@redhat.com>
References: <20250429113242.998312-1-vschneid@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The static key is only ever enabled in

  __init hv_init_evmcs()

so mark it appropriately as __ro_after_init.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kvm/vmx/vmx_onhyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.c b/arch/x86/kvm/vmx/vmx_onhyperv.c
index b9a8b91166d02..ff3d80c9565bb 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.c
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.c
@@ -3,7 +3,7 @@
 #include "capabilities.h"
 #include "vmx_onhyperv.h"
 
-DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
+DEFINE_STATIC_KEY_FALSE_RO(__kvm_is_using_evmcs);
 
 /*
  * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
-- 
2.49.0


