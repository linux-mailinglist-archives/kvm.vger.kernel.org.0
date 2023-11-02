Return-Path: <kvm+bounces-405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 660917DF6FD
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:48:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 210E2281BB1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 15:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A689D1D532;
	Thu,  2 Nov 2023 15:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hO96Hp6X"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7151CFB3
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 15:48:23 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A52D19E;
	Thu,  2 Nov 2023 08:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698940101; x=1730476101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=DPrHjqjjT0XK/XI2zNWowMuhgRJLcJS3uWdq85e10ZM=;
  b=hO96Hp6XzBD029+HfLfGrW+kBvrfgXrz8MJ2dFoiilEUpwPs4w9lNKF+
   HbktntgwoGcPnFuIJTdotfcUlbG8nKdPn+aMU+1UsfBJ7oQpTHftCOir+
   5B5m7zLZP78Ze4TLV77z1XBtV/PGWfKH1QyuahSNLMKDdXFmUE+940Diz
   wem3ZjNbEy05zq8WSJyQ+j8W102FYH731A2QIBnhqMx6NbVm3SAnS0B4w
   sHsFGRHZNIvFuihmcjY3vNuGmLte1JnukMVsNuEuYS1LEu+sh/w8cB+sy
   1nKsmOiizCcr2Lx3BmW1mpVoDOlOKmyAtgBGQr6F2r2RIpFikSUKs94uv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="368088458"
X-IronPort-AV: E=Sophos;i="6.03,271,1694761200"; 
   d="scan'208";a="368088458"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 08:48:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="878295295"
X-IronPort-AV: E=Sophos;i="6.03,271,1694761200"; 
   d="scan'208";a="878295295"
Received: from pasangle-nuc10i7fnh.iind.intel.com ([10.223.107.83])
  by fmsmga002.fm.intel.com with ESMTP; 02 Nov 2023 08:48:19 -0700
From: Parshuram Sangle <parshuram.sangle@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org,
	jaishankar.rajendran@intel.com,
	parshuram.sangle@intel.com
Subject: [PATCH 1/2] KVM: enable halt polling shrink parameter by default
Date: Thu,  2 Nov 2023 21:16:27 +0530
Message-Id: <20231102154628.2120-2-parshuram.sangle@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102154628.2120-1-parshuram.sangle@intel.com>
References: <20231102154628.2120-1-parshuram.sangle@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Default halt_poll_ns_shrink value of 0 always resets polling interval
to 0 on an un-successful poll where vcpu wakeup is not received. This is
mostly to avoid pointless polling for more number of shorter intervals. But
disabled shrink assumes vcpu wakeup is less likely to be received in
subsequent shorter polling intervals. Another side effect of 0 shrink value
is that, even on a successful poll if total block time was greater than
current polling interval, the polling interval starts over from 0 instead
of shrinking by a factor.

Enabling shrink with value of 2 allows the polling interval to gradually
decrement in case of un-successful poll events as well. This gives a fair
chance for successful polling events in subsequent polling intervals rather
than resetting it to 0 and starting over from grow_start.

Below kvm stat log snippet shows interleaved growth and shrinking of
polling interval:
87162647182125: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 10000 (grow 0)
87162647637763: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 20000 (grow 10000)
87162649627943: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 40000 (grow 20000)
87162650892407: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 20000 (shrink 40000)
87162651540378: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 40000 (grow 20000)
87162652276768: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 20000 (shrink 40000)
87162652515037: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 40000 (grow 20000)
87162653383787: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 20000 (shrink 40000)
87162653627670: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 10000 (shrink 20000)
87162653796321: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 20000 (grow 10000)
87162656171645: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 10000 (shrink 20000)
87162661607487: kvm_halt_poll_ns: vcpu 0: halt_poll_ns 0 (shrink 10000)

Having both grow and shrink enabled creates a balance in polling interval
growth and shrink behavior. Tests show improved successful polling attempt
ratio which contribute to VM performance. Power penalty is quite negligible
as shrunk polling intervals create bursts of very short durations.

Performance assessment results show 3-6% improvements in CPU+GPU, Memory
and Storage Android VM workloads whereas 5-9% improvement in average FPS of
gaming VM workloads.

Power penalty is below 1% where host OS is either idle or running a
native workload having 2 VMs enabled. CPU/GPU intensive gaming workloads
as well do not show any increased power overhead with shrink enabled.

Co-developed-by: Rajendran Jaishankar <jaishankar.rajendran@intel.com>
Signed-off-by: Rajendran Jaishankar <jaishankar.rajendran@intel.com>
Signed-off-by: Parshuram Sangle <parshuram.sangle@intel.com>
---
 Documentation/virt/kvm/halt-polling.rst | 2 +-
 virt/kvm/kvm_main.c                     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/halt-polling.rst b/Documentation/virt/kvm/halt-polling.rst
index c82a04b709b4..64f32a81133f 100644
--- a/Documentation/virt/kvm/halt-polling.rst
+++ b/Documentation/virt/kvm/halt-polling.rst
@@ -105,7 +105,7 @@ powerpc kvm-hv case.
 |			| grow_halt_poll_ns()	    |			      |
 |			| function.		    |			      |
 +-----------------------+---------------------------+-------------------------+
-|halt_poll_ns_shrink	| The value by which the    | 0			      |
+|halt_poll_ns_shrink	| The value by which the    | 2			      |
 |			| halt polling interval is  |			      |
 |			| divided in the	    |			      |
 |			| shrink_halt_poll_ns()	    |			      |
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..cfc474558660 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -91,8 +91,8 @@ unsigned int halt_poll_ns_grow_start = 10000; /* 10us */
 module_param(halt_poll_ns_grow_start, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_grow_start);
 
-/* Default resets per-vcpu halt_poll_ns . */
-unsigned int halt_poll_ns_shrink;
+/* Default halves per-vcpu halt_poll_ns. */
+unsigned int halt_poll_ns_shrink = 2;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
-- 
2.17.1


