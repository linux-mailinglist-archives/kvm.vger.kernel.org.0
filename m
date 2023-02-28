Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808E26A5B3F
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjB1PD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 10:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB1PDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 10:03:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755B51F931
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 07:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677596558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5AsD+lSBqsPncK5WAfJthLdvOGLMn8lKJcrsX+/oOvo=;
        b=IvEduRuZ25pXKXgtlR6QubdukC+AL9lyLvgYWUXsOu7SQ88YMfpPA5nNswnE3WLgMO9N1v
        Pv8JCkdkAYVSAMU4T+PpBAONMvjIQOc1GFZJc7pa83J+HTvEhdEAk5cAYhLRdB8SsC1qmy
        8mI3YpHx+wg9usfAK3YmpjrU32YYWeI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86--z1MfU-dMQCHm3g_lUhFKg-1; Tue, 28 Feb 2023 10:02:34 -0500
X-MC-Unique: -z1MfU-dMQCHm3g_lUhFKg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 869A785CBE2;
        Tue, 28 Feb 2023 15:02:33 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE170492B0E;
        Tue, 28 Feb 2023 15:02:31 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v6 0/2] arm: enable MTE for QEMU + kvm
Date:   Tue, 28 Feb 2023 16:02:14 +0100
Message-Id: <20230228150216.77912-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another respin of my kvm mte series; again, tested via check + check-tcg
and on FVP.

Changes v5->v6:
- "arm/virt: don't try to spell out the accelerator" has been merged
- some more reordering of the enable_mte logic
- added more explanations
- rebase to current master

Cornelia Huck (2):
  arm/kvm: add support for MTE
  qtests/arm: add some mte tests

 docs/system/arm/cpu-features.rst |  21 ++++++
 hw/arm/virt.c                    |   2 +-
 target/arm/cpu.c                 |  18 ++---
 target/arm/cpu.h                 |   1 +
 target/arm/cpu64.c               | 110 +++++++++++++++++++++++++++++++
 target/arm/internals.h           |   1 +
 target/arm/kvm.c                 |  29 ++++++++
 target/arm/kvm64.c               |   5 ++
 target/arm/kvm_arm.h             |  19 ++++++
 target/arm/monitor.c             |   1 +
 tests/qtest/arm-cpu-features.c   |  80 ++++++++++++++++++++++
 11 files changed, 274 insertions(+), 13 deletions(-)

-- 
2.39.2

