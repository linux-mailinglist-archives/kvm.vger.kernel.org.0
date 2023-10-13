Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E317C8E02
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjJMT6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 15:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjJMT55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 15:57:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E835BF
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 12:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697227029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ChxwyGqYyTrVtmpYs+W8xWj0pmQUAOAJISxRBQDY6Oc=;
        b=NaycPsg8QZHh5LHx1U0W47H5+KNC2GJnCxYDzrqOqj2NEtt2k+63e8HoiP/98BOr2jR53S
        DgHM5OhALVJHbDuXBIp8lxv6TdjQrYlUrcSuT4pA9SmLTb9biqfjErVGZEHHEQq59eF9y5
        u9aN4V5Tht6fUKRcnN9aEJSETzCQYk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-EesnMxLINtKyF73qNaYtHA-1; Fri, 13 Oct 2023 15:57:06 -0400
X-MC-Unique: EesnMxLINtKyF73qNaYtHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F4028185A7B4;
        Fri, 13 Oct 2023 19:57:05 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F3B40C6CA0;
        Fri, 13 Oct 2023 19:57:05 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, clg@redhat.com
Subject: [PATCH 0/2] vfio/mtty: Add migration support
Date:   Fri, 13 Oct 2023 13:56:51 -0600
Message-Id: <20231013195653.1222141-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
incompatible, I fixed an eventfd leak.  Thanks,

Alex

Alex Williamson (2):
  vfio/mtty: Fix eventfd leak
  vfio/mtty: Enable migration support

 samples/vfio-mdev/mtty.c | 610 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 605 insertions(+), 5 deletions(-)

-- 
2.40.1

