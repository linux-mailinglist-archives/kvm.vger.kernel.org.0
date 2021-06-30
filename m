Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37BA3B7C04
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 05:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhF3DQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 23:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbhF3DP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Jun 2021 23:15:56 -0400
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Jun 2021 20:13:26 PDT
Received: from resqmta-po-11v.sys.comcast.net (resqmta-po-11v.sys.comcast.net [IPv6:2001:558:fe16:19:96:114:154:170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9044AC061760
        for <kvm@vger.kernel.org>; Tue, 29 Jun 2021 20:13:26 -0700 (PDT)
Received: from resomta-po-12v.sys.comcast.net ([96.114.154.236])
        by resqmta-po-11v.sys.comcast.net with ESMTP
        id yQJRlzBTNGk1lyQcolxo5D; Wed, 30 Jun 2021 03:10:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20180828_2048; t=1625022654;
        bh=kWA7P8Gwv35fGWGmvjUPjNjn4Iks/6V537bZV4CYoFk=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=Ns6kSknQLRneX/Ot5ErQCykgFMDcspEpVvonn10vIM7y/N9mhOcQZ0BL5k7FqFvzP
         lJakk3NucaZMEdCGtPEDXZmS9dM/8hZDoIPTYkzEkTTfICEAjAyzA2+9VEfa0rC+Vq
         cLtHIwgCOsZquh4EtwZ02N7ZhuV2rjs+hpy2EliKzh18FbRh9CAhTZ4lira+z8IU82
         EwpcSlPDgMclCsJnnHJ3qxiTe+1hDqXw3o6DubiJvBUCxbbGWTJbzLZodFPDQeePoE
         o4Za8F52nqS7GGYD+HUuLOOi4MMjgrIaRvhjAwaKquI8lfTflz7pwM4/BFOpo1xK9S
         Q/+ectvfQSnuw==
Received: from localhost ([73.97.151.176])
        by resomta-po-12v.sys.comcast.net with ESMTPA
        id yQcnlY8Y114cEyQcnl6Bf3; Wed, 30 Jun 2021 03:10:54 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgeduledrfeeiuddgiedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepgggvnhhkrghtvghshhcuufhrihhnihhvrghsuceovhgvnhhkrghtvghshhhssegthhhrohhmihhumhdrohhrgheqnecuggftrfgrthhtvghrnhephefhvdeuledvgfdtvdeghfffiefhjedvtefgfeehjefhkefhteeftdehieegiefhnecukfhppeejfedrleejrdduhedurddujeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplhhotggrlhhhohhsthdpihhnvghtpeejfedrleejrdduhedurddujeeipdhmrghilhhfrhhomhepvhhsrhhinhhivhgrshesohhpshdutddurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjmhgrthhtshhonhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopegvlhhvvghrsehgohhoghhlvgdrtghomhdprhgtphhtthhopeguvhihuhhkohhvsehgohhoghhlvgdrtghomhdprhgtphhtthhopehvvghnkhgrthgvshhhshestghhrhhomhhiuhhmrdhorhhg
X-Xfinity-VMeta: sc=0.00;st=legit
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org, jmattson@google.com, seanjc@google.com,
        elver@google.com, dvyukov@google.com
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>
Subject: [PATCH] KVM: kvm_vcpu_kick: Do not read potentially-stale vcpu->cpu
Date:   Tue, 29 Jun 2021 20:10:37 -0700
Message-Id: <20210630031037.584190-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu->cpu contains the last cpu a vcpu run/is running on;
kvm_vcpu_kick is used to 'kick' a guest vcpu by sending an IPI
to the last CPU; vcpu->cpu is updated on sched_in when a vcpu
moves to a new CPU, so it possible for the vcpu->cpu field to
be stale.

kvm_vcpu_kick also read vcpu->cpu early with a plain read,
while vcpu->cpu could be concurrently written. This caused
a data race, found by kcsan:

write to 0xffff8880274e8460 of 4 bytes by task 30718 on cpu 0:
 kvm_arch_vcpu_load arch/x86/kvm/x86.c:4018
 kvm_sched_in virt/kvm/kvm_main.c:4864

vs
 kvm_vcpu_kick virt/kvm/kvm_main.c:2909
 kvm_arch_async_page_present_queued arch/x86/kvm/x86.c:11287
 async_pf_execute virt/kvm/async_pf.c:79
 ...

Use a READ_ONCE to atomically read vcpu->cpu and avoid the
data race.

Found by kcsan & syzbot.

Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 virt/kvm/kvm_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 46fb042837d2..0525f42afb7d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3058,16 +3058,18 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
  */
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	int me;
-	int cpu = vcpu->cpu;
+	int me, cpu;
 
 	if (kvm_vcpu_wake_up(vcpu))
 		return;
 
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-		if (kvm_arch_vcpu_should_kick(vcpu))
+	if (kvm_arch_vcpu_should_kick(vcpu)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		WARN_ON_ONCE(cpu == me);
+		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
+	}
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.30.2

