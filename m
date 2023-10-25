Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09437D6FE8
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbjJYOvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344380AbjJYOva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:30 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E6213A
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q/tyhQvSuMwg2Gh5kOIH6qsA0eNCoglo/BC/VrIl6Es=; b=KDYI3aY4tMOqlZWdfNfO3LfWji
        oD5wYOBY7+ELSt03QoqbH58su+Ih3wGW5y4L029rvsFpFws8RSdxkpx1kvzrlS+TR8NZrSvLHKS2E
        SjvLuuRm8b/GnqIqaDOe5rDZTyJ/8Guse6k/gguUsxYD44GH6Tn/1C0kqkUq3glxbg20jjPwKv8u9
        Utgyvf4duButgytsgIFvJi/gbUd0SSA1jqoxw3sxA0TP7WEocX4xU//yXPAlhMq2BmAgFO6SYdQxX
        O1MwfOqd73UkIrEQm5B9gRr0qBVYQsayxRgtHc1M0nfSNSW/4X7QtGGxiam1VQgi1BhfsTGnBKIs/
        5Klyv7rQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDZ-00GPLw-00;
        Wed, 25 Oct 2023 14:50:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDX-002dEB-38;
        Wed, 25 Oct 2023 15:50:43 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v3 04/28] hw/xen: don't clear map_track[] in xen_gnttab_reset()
Date:   Wed, 25 Oct 2023 15:50:18 +0100
Message-Id: <20231025145042.627381-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231025145042.627381-1-dwmw2@infradead.org>
References: <20231025145042.627381-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The refcounts actually correspond to 'active_ref' structures stored in a
GHashTable per "user" on the backend side (mostly, per XenDevice).

If we zero map_track[] on reset, then when the backend drivers get torn
down and release their mapping we hit the assert(s->map_track[ref] != 0)
in gnt_unref().

So leave them in place. Each backend driver will disconnect and reconnect
as the guest comes back up again and reconnects, and it all works out OK
in the end as the old refs get dropped.

Fixes: de26b2619789 ("hw/xen: Implement soft reset for emulated gnttab")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/kvm/xen_gnttab.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/i386/kvm/xen_gnttab.c b/hw/i386/kvm/xen_gnttab.c
index 21c30e3659..839ec920a1 100644
--- a/hw/i386/kvm/xen_gnttab.c
+++ b/hw/i386/kvm/xen_gnttab.c
@@ -541,7 +541,5 @@ int xen_gnttab_reset(void)
     s->entries.v1[GNTTAB_RESERVED_XENSTORE].flags = GTF_permit_access;
     s->entries.v1[GNTTAB_RESERVED_XENSTORE].frame = XEN_SPECIAL_PFN(XENSTORE);
 
-    memset(s->map_track, 0, s->max_frames * ENTRIES_PER_FRAME_V1);
-
     return 0;
 }
-- 
2.40.1

