Return-Path: <kvm+bounces-44750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5E3AA0A86
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1B227B6245
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54542D8689;
	Tue, 29 Apr 2025 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XeG655pU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFC52D4B61
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 11:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745926953; cv=none; b=UgtLY2WMz/KLeYpoFhAYBSbXcWpH8BygS02rmwky5dKaineiNOXQy5Z+3XLcU9BA5J0d5hWTttJHX2bFo4MqtOKISTC0eVgE9wCBhSwKk3fGVBuHMUXVjODgOABD4T9rY4Goj39EtpnZuSwX0+AnVjnHsBgobRfSY9F7x0x6fnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745926953; c=relaxed/simple;
	bh=c+zFQjpOvcrIFPQrBfK1AGlkndEEv8ZnYH49Bqu+yoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnNFPWd8oqcDvNq+arktSIbgmUFjqwlm7Q01n4VBLnK3EuXsh3WHeJOIvzC4YhVQVRHA2JIde7mFGHosx71o9zojmvOWKLKSZOu0dY4ZDcEuUDSe9lRTf4nMEc3Rw8+WUP8aAGPZlqBj4dDVJhvWwEB1Ixoxe8pd++1/PJG+lBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XeG655pU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745926950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ERC4iHAopj7w7n3GYQADioGeTv15E5tv5xtE/u14EI=;
	b=XeG655pUdpwUJF10v3poGNh5HtSKe0GKfgCgA7IJf0/Lld/fVXJqq1N5nZFBUrKWmdrY4R
	Z68pJkoQPPrnK0ESlDZ2NK4IYSn4q5QnqZxMlfQiqUo6C7wM70ejng3Nn79OaH2Gz8ECrW
	u7IuW8WtB27syCcltKF1CxDwbZyIo8A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-u7QFbanhM32YQonXELOb8w-1; Tue,
 29 Apr 2025 07:42:26 -0400
X-MC-Unique: u7QFbanhM32YQonXELOb8w-1
X-Mimecast-MFC-AGG-ID: u7QFbanhM32YQonXELOb8w_1745926942
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2406195608C;
	Tue, 29 Apr 2025 11:42:22 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.225.102])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEFB219560A3;
	Tue, 29 Apr 2025 11:41:53 +0000 (UTC)
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
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
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
Subject: [PATCH v5 17/25] x86/speculation/mds: Mark mds_idle_clear key as allowed in .noinstr
Date: Tue, 29 Apr 2025 13:32:34 +0200
Message-ID: <20250429113242.998312-18-vschneid@redhat.com>
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

Later commits will cause objtool to warn about static keys being used in
.noinstr sections in order to safely defer instruction patching IPIs
targeted at NOHZ_FULL CPUs.

mds_idle_clear is used in .noinstr code, and can be modified at
runtime (SMT hotplug). Suppressing the text_poke_sync() IPI has little
benefits for this key, as hotplug implies eventually going through
takedown_cpu() -> stop_machine_cpuslocked() which is going to cause
interference on all online CPUs anyway.

Mark it to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 362602b705cc4..59a77ca1bb14c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -117,7 +117,7 @@ DEFINE_STATIC_KEY_FALSE(switch_vcpu_ibpb);
 EXPORT_SYMBOL_GPL(switch_vcpu_ibpb);
 
 /* Control MDS CPU buffer clear before idling (halt, mwait) */
-DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
+DEFINE_STATIC_KEY_FALSE_NOINSTR(mds_idle_clear);
 EXPORT_SYMBOL_GPL(mds_idle_clear);
 
 /*
-- 
2.49.0


