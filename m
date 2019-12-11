Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E7311A7A1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfLKJmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:42:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728590AbfLKJmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 04:42:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576057351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3qlUCV9KAzTRD5BLeh8Hw9oSDfU4THuhXKb8NvAbCk=;
        b=Pq5VyOlxmfWEfWw3z/Rw3qYSCO/QaT4aLWEZeKb7f4SrRztX6TwBgeGzhLO7F+JVxO51US
        6rb6Hwb0QiP9jums+Ceczz9nLuBCRjxJbdXqttBGbwrYgj6FyibEcsn2AhhqAiscO6YeAO
        6RjIeW1ePcNEIoujIB6eXgv6gNm0JqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-RmA6yfBXPnC75X-WRRUQ3g-1; Wed, 11 Dec 2019 04:42:28 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D67800D4C
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 09:42:27 +0000 (UTC)
Received: from thuth.com (ovpn-117-11.ams2.redhat.com [10.36.117.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AFB763629;
        Wed, 11 Dec 2019 09:42:26 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 1/4] scripts: Fix premature_failure() check with newer versions of QEMU
Date:   Wed, 11 Dec 2019 10:42:18 +0100
Message-Id: <20191211094221.7030-2-thuth@redhat.com>
In-Reply-To: <20191211094221.7030-1-thuth@redhat.com>
References: <20191211094221.7030-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: RmA6yfBXPnC75X-WRRUQ3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU recently changed its output if it could not open a kernel file
from "could not load kernel ..." to "could not open kernel ...", see
QEMU commit 350f5233d755 ("hw/i386/pc: avoid an assignment in if
condition in x86_load_linux()"). Thus we have to adapt our script
that looks for this string accordingly.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index fbad0bd..eb60890 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -18,7 +18,7 @@ premature_failure()
     local log=3D"$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"
=20
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not load kernel" -e "error loading" &&
+        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
         return 1
=20
     RUNTIME_log_stderr <<< "$log"
--=20
2.18.1

