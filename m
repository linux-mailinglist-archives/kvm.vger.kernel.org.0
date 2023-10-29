Return-Path: <kvm+bounces-15-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051F17DABF8
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 11:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5A7FB20ED0
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 10:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A47B947A;
	Sun, 29 Oct 2023 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37D99448
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 10:17:43 +0000 (UTC)
X-Greylist: delayed 1198 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Oct 2023 03:17:42 PDT
Received: from 14.mo582.mail-out.ovh.net (14.mo582.mail-out.ovh.net [46.105.56.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6E9BD
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 03:17:41 -0700 (PDT)
Received: from director2.ghost.mail-out.ovh.net (unknown [10.108.20.39])
	by mo582.mail-out.ovh.net (Postfix) with ESMTP id CDC93260A3
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:39:40 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-wchvn (unknown [10.110.171.1])
	by director2.ghost.mail-out.ovh.net (Postfix) with ESMTPS id A84961FD2D;
	Sun, 29 Oct 2023 09:39:38 +0000 (UTC)
Received: from foxhound.fi ([37.59.142.102])
	by ghost-submission-6684bf9d7b-wchvn with ESMTPSA
	id Vv44I1ooPmW0GAAAMIZvTQ
	(envelope-from <jose.pekkarinen@foxhound.fi>); Sun, 29 Oct 2023 09:39:38 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-102R004927f133c-9d22-4865-bed1-34b055a274b6,
                    2D5A9C8C3C9544CFCEEB4DEE313913C815DB1A20) smtp.auth=jose.pekkarinen@foxhound.fi
X-OVh-ClientIp:87.94.110.144
From: =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	skhan@linuxfoundation.org
Cc: =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] KVM: x86: replace do_div with div64_ul
Date: Sun, 29 Oct 2023 11:39:28 +0200
Message-Id: <20231029093928.138570-1-jose.pekkarinen@foxhound.fi>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2908199461897021094
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrleekgddtiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofggtgfgsehtkeertdertdejnecuhfhrohhmpeflohhsrocurfgvkhhkrghrihhnvghnuceojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqnecuggftrfgrthhtvghrnhepfedtleeuteeitedvtedtteeuieevudejfeffvdetfeekleehhfelleefteetjeejnecukfhppeduvdejrddtrddtrddupdekjedrleegrdduuddtrddugeegpdefjedrheelrddugedvrddutddvnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheekvddpmhhouggvpehsmhhtphhouhht

Reported by coccinelle, there is a do_div call that does
64-by-32 divisions even in 64bit platforms, this patch will
move it to div64_ul macro that will decide the correct
division function for the platform underneath. The output
the warning follows:

arch/x86/kvm/lapic.c:1948:1-7: WARNING: do_div() does a 64-by-32 division, please consider using div64_ul instead.

Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3e977dbbf993..0b90c6ad5091 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1945,7 +1945,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
 	ns = (tscdeadline - guest_tsc) * 1000000ULL;
-	do_div(ns, this_tsc_khz);
+	div64_ul(ns, this_tsc_khz);
 
 	if (likely(tscdeadline > guest_tsc) &&
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
-- 
2.39.2


