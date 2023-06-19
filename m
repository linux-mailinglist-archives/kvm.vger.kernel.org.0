Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C1F735E23
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 22:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjFSUFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 16:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjFSUFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 16:05:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A8913D
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687205051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zhTtXKT2osa1prHP1XTeS0lqCKe9bZ3xIKWPs8QOAu8=;
        b=ZnIhtYDW53G32wU1S1xgPlIF0xsqdw5/A6nUao0EYLT4VT4suN0LG8USXi+r25nQRoI11B
        nnFsQI9SHhRJTr9Kx1bgxwA2Yp8ZHBN3+rm7MZ6ZwO67mR+Iui9qVaZLuP/O3ivrXS46q1
        +DpwclMGBCpKa8ciZOtVfBefVpeLN1M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-aI6g9jmFPr2UAkahpMD34Q-1; Mon, 19 Jun 2023 16:04:06 -0400
X-MC-Unique: aI6g9jmFPr2UAkahpMD34Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B69101A52A;
        Mon, 19 Jun 2023 20:04:05 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24E0FC1603B;
        Mon, 19 Jun 2023 20:04:03 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 0/6] arm: pmu: Fix random failures of pmu-chain-promotion
Date:   Mon, 19 Jun 2023 22:03:55 +0200
Message-Id: <20230619200401.1963751-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On some HW (ThunderXv2), some random failures of
pmu-chain-promotion test can be observed.

pmu-chain-promotion is composed of several subtests
which run 2 mem_access loops. The initial value of
the counter is set so that no overflow is expected on
the first loop run and overflow is expected on the second.
However it is observed that sometimes we get an overflow
on the first run. It looks related to some variability of
the mem_acess count. This variability is observed on all
HW I have access to, with different span though. On
ThunderX2 HW it looks the margin that is currently taken
is too small and we regularly hit failure.

although the first goal of this series is to increase
the count/margin used in those tests, it also attempts
to improve the pmu-chain-promotion logs, add some barriers
in the mem-access loop, clarify the chain counter
enable/disable sequence.

A new 'pmu-mem-access-reliability' is also introduced to
detect issues with MEM_ACCESS event variability and make
the debug easier.

Obviously one can wonder if this variability is something normal
and does not hide any other bug. I hope this series will raise
additional discussions about this.

https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3

History:

v2 -> v3:
- took into account Alexandru's comments. See individual log
  files

v1 -> v2:
- Take into account Alexandru's & Mark's comments. Added some
  R-b's and T-b's.


Eric Auger (6):
  arm: pmu: pmu-chain-promotion: Improve debug messages
  arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
    values
  arm: pmu: Add extra DSB barriers in the mem_access loop
  arm: pmu: Fix chain counter enable/disable sequences
  arm: pmu: Add pmu-mem-access-reliability test
  arm: pmu-chain-promotion: Increase the count and margin values

 arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
 arm/unittests.cfg |   6 ++
 2 files changed, 153 insertions(+), 61 deletions(-)

-- 
2.38.1

