Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252417B206C
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjI1PFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjI1PFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7024194
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695913494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyT2AmMvLLxljrFvJMSDRCezFgTSL0+kRV0V1GII1YQ=;
        b=ZGjROXmvUa7ySlZMcZuEgJw7jwAVZA8duIl4TkUrIfVa5rUxaFpzO5k06p2mWP0H3ue6Ot
        ZOo/e/2Zr3nB5/D+6vqDyzfciN9rPKlgqJOdD0ZBm6IkAs9OcjDuvuNTF6QaqqwPUkHiRF
        fCfGDMMVBZOh/ZoZLITUNfcEQ2d+bp4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-0K3VyQymPgyYVl7SZgYxGA-1; Thu, 28 Sep 2023 11:04:50 -0400
X-MC-Unique: 0K3VyQymPgyYVl7SZgYxGA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95190101A53B;
        Thu, 28 Sep 2023 15:04:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8B540C6E76;
        Thu, 28 Sep 2023 15:04:45 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/5] iommu/amd: skip updating the IRTE entry when is_run is already false
Date:   Thu, 28 Sep 2023 18:04:27 +0300
Message-Id: <20230928150428.199929-5-mlevitsk@redhat.com>
In-Reply-To: <20230928150428.199929-1-mlevitsk@redhat.com>
References: <20230928150428.199929-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vCPU affinity of an IRTE which already has
is_run == false, is updated and the update also sets is_run to false,
there is nothing to do.

The goal of this patch is to make a call to 'amd_iommu_update_ga()'
to be relatively cheap if there is nothing to do.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/iommu/amd/iommu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 95bd7c25ba6f366..10bcd436e984672 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3774,6 +3774,15 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
 		entry->hi.fields.destination =
 					APICID_TO_IRTE_DEST_HI(cpu);
 	}
+
+	if (!is_run && !entry->lo.fields_vapic.is_run) {
+		/*
+		 * No need to notify the IOMMU about an entry which
+		 * already has is_run == False
+		 */
+		return 0;
+	}
+
 	entry->lo.fields_vapic.is_run = is_run;
 
 	return modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
-- 
2.26.3

