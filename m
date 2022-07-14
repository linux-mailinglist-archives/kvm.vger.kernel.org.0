Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0579A574CB9
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 14:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiGNMDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 08:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiGNMDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 08:03:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B418521B
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 05:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657800213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wAxz9tvWBXP7vb3lbaEzVBejhbAljYzNf3UGKYGM0hM=;
        b=GdK1ZzFZL8Xcj3Azn9a2lflUiY7HU8OSo1Mz3UBSABjCa4tRdp3wYU99MhxoScJduwLE0q
        Er1RevQ8M1C4Fhj2wiMSVQRwtHb6Vs6cNrdZ+jTvujsO5j2dXFH7hmaC6J4y9F10pki8mV
        NdoERbOjy8KgHPVDXCEyTbgtJI7rF2Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-Z5XlF72MMByeMNnpFn95vw-1; Thu, 14 Jul 2022 08:03:30 -0400
X-MC-Unique: Z5XlF72MMByeMNnpFn95vw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82206811E75;
        Thu, 14 Jul 2022 12:03:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 698B92166B26;
        Thu, 14 Jul 2022 12:03:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] Documentation: kvm: clarify histogram units
Date:   Thu, 14 Jul 2022 08:03:30 -0400
Message-Id: <20220714120330.1410308-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the case of histogram statistics, the values are always sample
counts; the unit instead applies to the bucket range.  For example,
halt_poll_success_hist is a nanosecond statistic because the buckets are
for 0ns, 1ns, 2-3ns, 4-7ns etc.  There isn't really any other sensible
interpretation, but clarify this anyway in the Documentation.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 48bf6e49a7de..6e090fb96a0e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5703,14 +5703,13 @@ Bits 0-3 of ``flags`` encode the type:
     by the ``hist_param`` field. The range of the Nth bucket (1 <= N < ``size``)
     is [``hist_param``*(N-1), ``hist_param``*N), while the range of the last
     bucket is [``hist_param``*(``size``-1), +INF). (+INF means positive infinity
-    value.) The bucket value indicates how many samples fell in the bucket's range.
+    value.)
   * ``KVM_STATS_TYPE_LOG_HIST``
     The statistic is reported as a logarithmic histogram. The number of
     buckets is specified by the ``size`` field. The range of the first bucket is
     [0, 1), while the range of the last bucket is [pow(2, ``size``-2), +INF).
     Otherwise, The Nth bucket (1 < N < ``size``) covers
-    [pow(2, N-2), pow(2, N-1)). The bucket value indicates how many samples fell
-    in the bucket's range.
+    [pow(2, N-2), pow(2, N-1)).
 
 Bits 4-7 of ``flags`` encode the unit:
 
@@ -5731,6 +5730,10 @@ Bits 4-7 of ``flags`` encode the unit:
     statistics can be linear histograms (with two buckets) but not logarithmic
     histograms.
 
+Note that, in the case of histograms, the unit applies to the bucket
+ranges, while the bucket value indicates how many samples fell in the
+bucket's range.
+
 Bits 8-11 of ``flags``, together with ``exponent``, encode the scale of the
 unit:
 
@@ -5752,7 +5755,7 @@ the corresponding statistics data.
 
 The ``bucket_size`` field is used as a parameter for histogram statistics data.
 It is only used by linear histogram statistics data, specifying the size of a
-bucket.
+bucket in the unit expressed by bits 4-11 of ``flags`` together with ``exponent``.
 
 The ``name`` field is the name string of the statistics data. The name string
 starts at the end of ``struct kvm_stats_desc``.  The maximum length including
-- 
2.31.1

