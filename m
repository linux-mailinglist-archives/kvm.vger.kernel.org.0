Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B760646610D
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 10:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbhLBKDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346120AbhLBKCa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 05:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638439147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uqme7qrG0Spt/6Ky8+XXVtSqkTTv4O7fMW6HZ/cKL94=;
        b=PnBSzrFJePI4XCc+YrQKBdtvydl6o9pujrmJ7QeKQMU+LugSC0bzAY1jyinFSBV5bq/P09
        3/MV+kkhXjTsL+BqSkoovD/mhd2y+be8xzEYJEsqX0+/ozCyNa7jo6fcZ/P0L35G6EHPIg
        SZBeOBeQrIHjZ0yGAYtTsl7/4UuPSO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-cNhnxZFLNUejQZiiJ-Rj7w-1; Thu, 02 Dec 2021 04:59:06 -0500
X-MC-Unique: cNhnxZFLNUejQZiiJ-Rj7w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EFCC802926;
        Thu,  2 Dec 2021 09:59:05 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 453FA5D9CA;
        Thu,  2 Dec 2021 09:58:58 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v1 1/2] s390x: make smp_cpu_setup() return 0 on success
Date:   Thu,  2 Dec 2021 10:58:42 +0100
Message-Id: <20211202095843.41162-2-david@redhat.com>
In-Reply-To: <20211202095843.41162-1-david@redhat.com>
References: <20211202095843.41162-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Properly return "0" on success so callers can check if the setup was
successful.

The return value is yet unused, which is why this wasn't noticed so far.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index da6d32f..b753eab 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -212,6 +212,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	/* Wait until the cpu has finished setup and started the provided psw */
 	while (lc->restart_new_psw.addr != psw.addr)
 		mb();
+	rc = 0;
 out:
 	spin_unlock(&lock);
 	return rc;
-- 
2.31.1

