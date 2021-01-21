Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E792FE35E
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 08:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbhAUHEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 02:04:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbhAUHDj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 02:03:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611212533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=k4womrgZC1t12zXUnXkUHJc1RDUUJ4HKh78lY5FVqYE=;
        b=gSKJYHqJm5MtrdesLSRQzmKhLJUFvxFn0xCAbUsIigGnb/zQMhblIusNgy6mtA1RZ+uK0j
        SeZZcIyelv7al3efygr8cl6IuhsJPM80XJ4QzNNsZfbwQcuRzVsDzrocSBaHrNE1nTG6u3
        CNTf8kgVFmoZHXHdOsUIveIOjsHtZSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-q6Gp6TnFMlOIFURspEDrQQ-1; Thu, 21 Jan 2021 01:57:11 -0500
X-MC-Unique: q6Gp6TnFMlOIFURspEDrQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ACA9107ACE3;
        Thu, 21 Jan 2021 06:57:10 +0000 (UTC)
Received: from thuth.com (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9A9F9CA0;
        Thu, 21 Jan 2021 06:57:05 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH] lib/s390x/sclp: Clarify that the CPUEntry array could be at a different spot
Date:   Thu, 21 Jan 2021 07:57:03 +0100
Message-Id: <20210121065703.561444-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "struct CPUEntry entries[0]" in the ReadInfo structure is misleading
since the entries could be add a completely different spot. Replace it
by a proper comment instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sclp.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 9f81c0f..8523133 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -131,10 +131,15 @@ typedef struct ReadInfo {
 	uint16_t highest_cpu;
 	uint8_t  _reserved5[124 - 122];     /* 122-123 */
 	uint32_t hmfai;
-	uint8_t reserved7[134 - 128];
+	uint8_t reserved7[134 - 128];       /* 128-133 */
 	uint8_t byte_134_diag318 : 1;
 	uint8_t : 7;
-	struct CPUEntry entries[0];
+	/*
+	 * At the end of the ReadInfo, there are also the CPU entries (see
+	 * struct CPUEntry). When the Extended-Length SCCB (ELS) feature is
+	 * enabled, the start of the CPU entries array begins at an offset
+	 * denoted by the offset_cpu field, otherwise it's at offset 128.
+	 */
 } __attribute__((packed)) ReadInfo;
 
 typedef struct ReadCpuInfo {
-- 
2.27.0

