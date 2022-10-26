Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4235260E532
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 18:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiJZQF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 12:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiJZQFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 12:05:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7604360D
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 09:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666800320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2ztBP1qMYf+hyScyFNcfBG006wJpY+Pb7WIehybbH0k=;
        b=PrAaoE8okQb7FGQw5xA8Ka8DHqWTOZd3C1SiWlR+ixwSUnewDoihoWt6SMu0/gtq/EkPn3
        XMSv4Z3aXGBtfG7JECp7TloCReYw3ebCNiixXy+F/7CHWBs+5RM9pfWIh/CPf2ckPK2NSQ
        tePlgGwkjcwUvcqpqk49abT8bwQAf4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-wWIqcFAwMfC_Tl7LnY9hrg-1; Wed, 26 Oct 2022 12:05:17 -0400
X-MC-Unique: wWIqcFAwMfC_Tl7LnY9hrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB2CC87B2A5;
        Wed, 26 Oct 2022 16:05:16 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FDC1C15BAB;
        Wed, 26 Oct 2022 16:05:14 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 0/2] arm: enable MTE for QEMU + kvm
Date:   Wed, 26 Oct 2022 18:05:09 +0200
Message-Id: <20221026160511.37162-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After wayyy too long (last version was sent in *July*), a respin of my
kvm/mte series. Still no migration support. I've been hacking around on
a device for transferring tags while stopped, but don't really have anything
to show, probably because I get distra- <ohh, what's that?>

...I guess you get the point :(

Anyway, I wanted to post this as non-RFC; likely too late for 7.2, but maybe
for 8.0 (and I'd get a chance to make at least pre-copy migration work; I'm open
to suggestions for that. Support for post-copy needs kernel-side changes.) Tested
on the FVP models; qtests only on a non-MTE KVM host.

Changes v2->v3:
- rebase to current master
- drop some parts of the qtests that didn't actually work
- really minor stuff
- drop RFC

Cornelia Huck (2):
  arm/kvm: add support for MTE
  qtests/arm: add some mte tests

 docs/system/arm/cpu-features.rst |  21 +++++
 target/arm/cpu.c                 |  18 ++---
 target/arm/cpu.h                 |   1 +
 target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
 target/arm/internals.h           |   1 +
 target/arm/kvm64.c               |   5 ++
 target/arm/kvm_arm.h             |  12 +++
 target/arm/monitor.c             |   1 +
 tests/qtest/arm-cpu-features.c   |  76 ++++++++++++++++++
 9 files changed, 256 insertions(+), 12 deletions(-)

-- 
2.37.3

