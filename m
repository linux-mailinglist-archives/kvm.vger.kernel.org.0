Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00094455CCE
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhKRNjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:39:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231260AbhKRNjD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:39:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637242562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIRPYc+XbbN/gDdZNFNpMojMoOex7CBq55PiFFzw3r8=;
        b=h2EP7Z7agh9+Bki1CgVVrEaJgGAlmy0y1pzZUAeQyaVu8JfsdI520vT+PkGn78e60wyKd0
        +OGtucTUzOeRXx5ahGZknB/tB8e9fC7DCvH/WLob46ASYtCWQ3EF8AiuYIaQ/NLbMnwEkb
        Bdazpj+MkJQylSSHeXVfaW/Ds8vYpRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-3KTXJAtrMM6N6AzudDP1nQ-1; Thu, 18 Nov 2021 08:36:01 -0500
X-MC-Unique: 3KTXJAtrMM6N6AzudDP1nQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E21E487D545;
        Thu, 18 Nov 2021 13:35:59 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.33.36.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5FE162A41;
        Thu, 18 Nov 2021 13:35:57 +0000 (UTC)
From:   =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PULL 2/6] target/i386/sev: Add kernel hashes only if sev-guest.kernel-hashes=on
Date:   Thu, 18 Nov 2021 13:35:28 +0000
Message-Id: <20211118133532.2029166-3-berrange@redhat.com>
In-Reply-To: <20211118133532.2029166-1-berrange@redhat.com>
References: <20211118133532.2029166-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.ibm.com>

Commit cff03145ed3c ("sev/i386: Introduce sev_add_kernel_loader_hashes
for measured linux boot", 2021-09-30) introduced measured direct boot
with -kernel, using an OVMF-designated hashes table which QEMU fills.

However, if OVMF doesn't designate such an area, QEMU would completely
abort the VM launch.  This breaks launching with -kernel using older
OVMF images which don't publish the SEV_HASH_TABLE_RV_GUID.

Fix that so QEMU will only look for the hashes table if the sev-guest
kernel-hashes option is set to on.  Otherwise, QEMU won't look for the
designated area in OVMF and won't fill that area.

To enable addition of kernel hashes, launch the guest with:

    -object sev-guest,...,kernel-hashes=on

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 target/i386/sev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index cad32812f5..e3abbeef68 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1223,6 +1223,14 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     size_t hash_len = HASH_SIZE;
     int aligned_len;
 
+    /*
+     * Only add the kernel hashes if the sev-guest configuration explicitly
+     * stated kernel-hashes=on.
+     */
+    if (!sev_guest->kernel_hashes) {
+        return false;
+    }
+
     if (!pc_system_ovmf_table_find(SEV_HASH_TABLE_RV_GUID, &data, NULL)) {
         error_setg(errp, "SEV: kernel specified but OVMF has no hash table guid");
         return false;
-- 
2.31.1

