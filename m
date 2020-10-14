Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870C228E71B
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 21:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390270AbgJNTOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 15:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390300AbgJNTOw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 15:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602702891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j7eyIpDAmINftMkywYO90JMOsADYfEqnN57dGxmdomA=;
        b=Po/ftOj06eDp0iBjFHEae1y7LmQg8CgbVnWAmflFmGD2AXGtyNMRORtoysOikX3+JKuulX
        W2uOnwJ4Hh7y4ZBkyHU5rqlaKBErC+Ou6zMt+o4fZxqN3IHiZbVGwe6cM3aFcrhoS2WmJs
        mbcGeAoW7WU1+3jvLZhgJk/t7P9Bx0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-zTJfI4sQM_2FXgbJyehWKg-1; Wed, 14 Oct 2020 15:14:49 -0400
X-MC-Unique: zTJfI4sQM_2FXgbJyehWKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81F5A86ABD9
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 19:14:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44A025577C;
        Wed, 14 Oct 2020 19:14:47 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests 1/3] lib/string: Fix getenv name matching
Date:   Wed, 14 Oct 2020 21:14:42 +0200
Message-Id: <20201014191444.136782-2-drjones@redhat.com>
In-Reply-To: <20201014191444.136782-1-drjones@redhat.com>
References: <20201014191444.136782-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without confirming that the name length exactly matches too, then
the string comparison would return the same value for VAR* as for
VAR, when VAR came first in the environ array.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/string.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 018dcc879516..3a0562120f12 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -171,10 +171,13 @@ extern char **environ;
 char *getenv(const char *name)
 {
     char **envp = environ, *delim;
+    int len;
 
     while (*envp) {
         delim = strchr(*envp, '=');
-        if (delim && strncmp(name, *envp, delim - *envp) == 0)
+        assert(delim);
+        len = delim - *envp;
+        if (strlen(name) == len && strncmp(name, *envp, len) == 0)
             return delim + 1;
         ++envp;
     }
-- 
2.26.2

