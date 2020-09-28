Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490A127ACDF
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgI1LeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 07:34:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbgI1LeS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 07:34:18 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601292857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nnytngNb/L/CTDPQQn5WTYGqtJoVY9N05tOcTzUYMM8=;
        b=Qg8A/cJSLuGNP8RK3/b0paYEVE31R/uTRm5NzYzRXTvKkGTCPEnzM/WqxAu/ncICqcOu/k
        n/mzxcgMhSEBAy5Ja2SQcZCB3T5C4U4qItIiTJubejhbRYXTq9WS3vFm9uU2OUmcWEQebl
        Q29/wx/P4h2qcYPpTSMD1vjswppeWMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-Cnlb5mGbP-Cmd6rVsE8omg-1; Mon, 28 Sep 2020 07:34:14 -0400
X-MC-Unique: Cnlb5mGbP-Cmd6rVsE8omg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56CFF800688
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 11:34:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0887A5D9CD;
        Mon, 28 Sep 2020 11:34:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com
Subject: [PATCH kvm-unit-tests] runtime.bash: fix check for parameter files
Date:   Mon, 28 Sep 2020 07:34:12 -0400
Message-Id: <20200928113412.2419974-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need to check if the file exists, not just if it is a non-empty string.
While an empty $path would have the unfortunate effect that "cat" would
read from stdin, that is not an issue as you can simply not do that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 294e6b1..3121c1f 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -118,7 +118,7 @@ function run()
     for check_param in "${check[@]}"; do
         path=${check_param%%=*}
         value=${check_param#*=}
-        if [ "$path" ] && [ "$(cat $path)" != "$value" ]; then
+        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
             print_result "SKIP" $testname "" "$path not equal to $value"
             return 2
         fi
-- 
2.26.2

