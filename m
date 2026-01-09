Return-Path: <kvm+bounces-67566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED14D0AA86
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD04D305222C
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA102BDC10;
	Fri,  9 Jan 2026 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DmZEcLfR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F732877C3
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969288; cv=none; b=Hqhc3X62bWvX9uHA3gXspwuB46u1R8w3R9/TgGqAfVz5IiRtEPvCnMFCySK5TukIfccQEi9KH/NYZXdktVaKVAte/1AOC8lgaLGIO6sg4JP7NsJuCyOoybd7t0j65T0r3JrURCoUU4r6FReQsm4lemqaF/M+iVuntAFoh8ybypQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969288; c=relaxed/simple;
	bh=PyOS79v0LSZ3zmpAxC32H34f8YDAFMjKVXrcBNSDDHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRyyyDwWfw7AOLV6pRPDz4TI+exX1anagoP/n2kmqgNvbMeF/XAEeG321ZQdntfmhWmDj811B2TUi5NDGjIX3c3E1nP0poLyMLjEJxazwtgMnGHOlngFV/kpzGGagDmXCcZUcz1Z2gOerjTrMpmpEgZMOEpk8tpam1JyJSNhEWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DmZEcLfR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767969285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRabUwKCcnSa4tcxD8eunuOpk4bc+IJarAuAxh7ITUE=;
	b=DmZEcLfRIMJ6B3dX/+2HReYueAx3YYL0e7jcyti4fJSNlHRtxxhF2xy6vRl8+moNICjZdb
	PRTMwrzvQyqV9d3kbRcvGjHiKueHSc5sMsO6X+HSDYu+miBPamLpFkEbKQ/9ooZp1FeNfY
	jA5Lw4Bai6Ui8jY4i2BXNhrzQpsanb4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-6G9LkJXhOVGlCvQ16DNN4g-1; Fri,
 09 Jan 2026 09:34:42 -0500
X-MC-Unique: 6G9LkJXhOVGlCvQ16DNN4g-1
X-Mimecast-MFC-AGG-ID: 6G9LkJXhOVGlCvQ16DNN4g_1767969280
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9171B18005AE;
	Fri,  9 Jan 2026 14:34:40 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.84])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69C0318001D5;
	Fri,  9 Jan 2026 14:34:35 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v3 3/6] igvm: Add missing NULL check
Date: Fri,  9 Jan 2026 15:34:10 +0100
Message-ID: <20260109143413.293593-4-osteffen@redhat.com>
In-Reply-To: <20260109143413.293593-1-osteffen@redhat.com>
References: <20260109143413.293593-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Check for NULL pointer returned from igvm_get_buffer().
Documentation for that function calls for that unconditionally.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/backends/igvm.c b/backends/igvm.c
index a350c890cc..dc1fd026cb 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -170,9 +170,16 @@ static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
                 (int)header_handle);
             return -1;
         }
-        header_data = igvm_get_buffer(ctx->file, header_handle) +
-                      sizeof(IGVM_VHS_VARIABLE_HEADER);
-        result = handlers[handler].handler(ctx, header_data, errp);
+        header_data = igvm_get_buffer(ctx->file, header_handle);
+        if (header_data == NULL) {
+            error_setg(
+                errp,
+                "IGVM: Failed to get directive header data (code: %d)",
+                (int)header_handle);
+            result = -1;
+        } else {
+            result = handlers[handler].handler(ctx, header_data + sizeof(IGVM_VHS_VARIABLE_HEADER), errp);
+        }
         igvm_free_buffer(ctx->file, header_handle);
         return result;
     }
-- 
2.52.0


