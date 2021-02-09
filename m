Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617DD31534C
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 16:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhBIP6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 10:58:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231654AbhBIP6j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 10:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612886231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6SqLbxCHV6DXwffz6T5lMoalH3C/d4xGQ0lUToQcwxQ=;
        b=Z7W/aHEEeJzC8jCJw1eua5HK2V/4xGsxE2S92sLwqwD2Badz/ajqPm8XZqV00pdUs/wBt4
        MiFDm+y8F+pwdSDjYqNOCpDjfwd5EbJbiViCxKRlq5PkQ5Teu73oTZ17Q2L+bXFsAQUjiO
        /hBBH/2e3h97g2JG9v9Tm147Gv7cG6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-wk5rEMTkO-ePRDX8jgZZ_A-1; Tue, 09 Feb 2021 10:57:10 -0500
X-MC-Unique: wk5rEMTkO-ePRDX8jgZZ_A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A158427CC;
        Tue,  9 Feb 2021 15:57:09 +0000 (UTC)
Received: from thuth.com (ovpn-114-56.ams2.redhat.com [10.36.114.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9330E5D736;
        Tue,  9 Feb 2021 15:57:07 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] Fix the length in the stsi check for the VM name
Date:   Tue,  9 Feb 2021 16:57:05 +0100
Message-Id: <20210209155705.67601-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sizeof(somepointer) results in the size of the pointer, i.e. 8 on a
64-bit system, so the

 memcmp(data->ext_names[0], vm_name_ext, sizeof(vm_name_ext))

only compared the first 8 characters of the VM name here. Switch
to a proper array to get the sizeof() right.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/stsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index 4109b8d..87d4804 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -106,7 +106,7 @@ static void test_3_2_2(void)
 				 0x00, 0x03 };
 	/* EBCDIC for "KVM/" */
 	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
-	const char *vm_name_ext = "kvm-unit-test";
+	const char vm_name_ext[] = "kvm-unit-test";
 	struct stsi_322 *data = (void *)pagebuf;
 
 	report_prefix_push("3.2.2");
-- 
2.27.0

