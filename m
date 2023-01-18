Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65606718C6
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjARKRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjARKPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:15:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD6C66ECD
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674033727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRpao2U67NwWvD0GEz79kUj8iQxU/5jsj0HVM0mbPII=;
        b=bnk+HwJmktv7aJnnTTVOh1wPf3zN/K12ltpU74arvonzumJP1l/YreBjqjrvKLUEBfYtvj
        +NVWNb81DWp9eyWz/YUldymAvOvWR0q+qknm2VwdW1oCAal4MXn9Ui3OdhLtRLEHU5UWB/
        zGGGP7iObX7IhddK2M1+mgsQ7/I3Asw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-UZO_jiJfP6S4dV4N2e0F1g-1; Wed, 18 Jan 2023 04:22:02 -0500
X-MC-Unique: UZO_jiJfP6S4dV4N2e0F1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3C3858F0E;
        Wed, 18 Jan 2023 09:22:02 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8327B40C2064;
        Wed, 18 Jan 2023 09:21:58 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        pbonzini@redhat.com, shuah@kernel.org, maz@kernel.org,
        oliver.upton@linux.dev, maciej.szmigiero@oracle.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH 1/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
Date:   Wed, 18 Jan 2023 17:21:32 +0800
Message-Id: <20230118092133.320003-2-gshan@redhat.com>
In-Reply-To: <20230118092133.320003-1-gshan@redhat.com>
References: <20230118092133.320003-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two VMs created in prepare_vm(), which isn't necessary.
To remove the second created and unnecessary VM.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e6587e193490..adbbcca3e354 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -308,8 +308,6 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
-
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		data->nslots, data->pages_per_slot, rempages);
 
-- 
2.23.0

