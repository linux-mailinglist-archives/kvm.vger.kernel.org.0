Return-Path: <kvm+bounces-649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B0A7E1E96
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:40:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E83421C20AFE
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FDC18B09;
	Mon,  6 Nov 2023 10:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AFLH666B"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42A1803C
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:40:24 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE5B99
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oTzSlnwFiwNNyo9+XLJSozlV3tES1c1DD/ZmREeHw24=; b=AFLH666BhTE9iLsKwkcxfjYYVk
	EK1GRnKx1eeQSIv4t+AlzQ51FcOiV4PCFI+D9tzyDeaMe6dga8PYsEugIJlk8ThSR6cXwK2AKXIxM
	vYAXj7UM09WBHcehjYNl+F4q/IdDbIauXkudVIoN/MgOzhWFA+Pyh9VobKDkjCaBQ0r3+ac+bZ7f4
	vjf/MzboSSR81s4957qqdvrSVWv9ufNI6hAQ3y8jvHLmnO/b1ZYN4vlIQa8/WUDuCtsOyPoL13Siu
	1oguA+OYtjBq95Y5Tnq77a8QjdpITiik2VpWIa7KX8H7aNQBgSFdL60drlP/vZ+JFZUNtSuxNPsF8
	R+CngbmA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qzx1P-005R1i-Rt; Mon, 06 Nov 2023 10:39:56 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1qzx1Q-000qGH-0X;
	Mon, 06 Nov 2023 10:39:56 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	qemu-stable@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 6/7] hw/xen: take iothread mutex in xen_evtchn_reset_op()
Date: Mon,  6 Nov 2023 10:39:54 +0000
Message-ID: <20231106103955.200867-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106103955.200867-1-dwmw2@infradead.org>
References: <20231106103955.200867-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The xen_evtchn_soft_reset() function requires the iothread mutex, but is
also called for the EVTCHNOP_reset hypercall. Ensure the mutex is taken
in that case.

Cc: qemu-stable@nongnu.org
Fixes: a15b10978fe6 ("hw/xen: Implement EVTCHNOP_reset")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/kvm/xen_evtchn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index 3d6f4b4a0a..b2b4be9983 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -1135,6 +1135,7 @@ int xen_evtchn_reset_op(struct evtchn_reset *reset)
         return -ESRCH;
     }
 
+    QEMU_IOTHREAD_LOCK_GUARD();
     return xen_evtchn_soft_reset();
 }
 
-- 
2.41.0


