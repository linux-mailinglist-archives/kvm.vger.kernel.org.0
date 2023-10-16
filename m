Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491197CB6B4
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 00:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbjJPWtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 18:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbjJPWtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 18:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8C6E6
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697496473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y5N64g2qnbcVxmrUMZtOSoLgR2kLXvRWoQ4hTvxyx6Y=;
        b=QLlou4ZhQdYSYvwDBy/4IlnpK7EtUZ1tPQzMd0iGSxf5s16mPdEalsVZUju+79EAwWOZar
        HGgYPkboc5bND1nqLKEriopWizZa9TmGgykodyNNWI4Arx06l9GKAW61UAbvtaocvTYv07
        oTiwyxaSMngmI1CxhEqqcVBjSz5B4tg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-gcxiGaN3PWW9JERgctSV5g-1; Mon, 16 Oct 2023 18:47:41 -0400
X-MC-Unique: gcxiGaN3PWW9JERgctSV5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0599A805BC3;
        Mon, 16 Oct 2023 22:47:41 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A821225C9;
        Mon, 16 Oct 2023 22:47:40 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, clg@redhat.com
Subject: [PATCH v2 0/2] vfio/mtty: Add migration support
Date:   Mon, 16 Oct 2023 16:47:34 -0600
Message-Id: <20231016224736.2575718-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We've seen a request for CI and development to have access to migratable
vfio devices without any specific hardware requirements.  One way to do
that is to enable migration support on the mtty mdev sample driver, as
done here.

This device is particularly easy to migrate because it doesn't actually
do DMA, or in fact much of anything.  Therefore we can claim P2P and
dirty logging as well.  PRE_COPY support is also included in a similar
fashion to hisi_acc.  This provides early compatibility testing, which
is probably over-done, but perhaps illustrates good practice with
matching data stream magic, versioning, and feature flags.  These might
later be used for backwards compatibility, particularly since I'm not
positive that copying the struct serial_port between source and
destination is sufficient.

Along the way, testing migration where the source and target are
incompatible revealed an eventfd leak, where peeling back the onion
of mtty handling of SET_IRQS proved to require a substantial overhaul.

v2:
  Incorporate comments from Cédric
   - Fixing eventfd leak turned into SET_IRQS overhaul
   - Factored out mtty_data_size()
   - Factored mtty_save_state() and paired with mtty_load_state()

Alex Williamson (2):
  vfio/mtty: Overhaul mtty interrupt handling
  vfio/mtty: Enable migration support

 samples/vfio-mdev/mtty.c | 829 +++++++++++++++++++++++++++++++++++----
 1 file changed, 756 insertions(+), 73 deletions(-)

-- 
2.40.1

