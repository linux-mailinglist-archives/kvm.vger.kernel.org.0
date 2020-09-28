Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7827B3A5
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgI1Rua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726684AbgI1Ru3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:29 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=TIgRicJInSQvZMzAg3zt8cELNWrV41FAFENuoCLRHIw=;
        b=G9ZCyG11h4s0BCpyXljsoRJSPELl0n47HwfZunCG2149VmeufZkzP+CUueb1fOtiusBqcH
        V3WNioQAJqVAVHBu0py1zVpLwzDqR1VRs+t1jsd+oAAbVmJkrtfJUJkJNixCrUjoxwCDPM
        CsUFWiooCXMZdhtn3OrndKscD4to0Y8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-2V1VY3mtOViM3SLe5ZHUmw-1; Mon, 28 Sep 2020 13:50:24 -0400
X-MC-Unique: 2V1VY3mtOViM3SLe5ZHUmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B502B1084D61;
        Mon, 28 Sep 2020 17:50:23 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CF9210013C0;
        Mon, 28 Sep 2020 17:50:21 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 11/11] scripts/arch-run: use ncat rather than nc.
Date:   Mon, 28 Sep 2020 19:49:58 +0200
Message-Id: <20200928174958.26690-12-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

On Red Hat 7+ and derived distributions, 'nc' is nmap-ncat, but on
Debian based distributions this is often netcat-openbsd.  Both are
mostly compatible with the important distinction that netcat-openbsd
does not shutdown the socket on stdin EOF without also passing '-N' as
an argument which is not supported on nmap-ncat.  This has the
unfortunate consequence of hanging qmp calls so tests like aarch64
its-migration never complete.

We're depending on ncat behaviour and nmap-ncat is available in all
major distributions.

Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Message-Id: <20200921103644.1718058-1-jamie@nuviainc.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 660f1b7..5997e38 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -101,13 +101,13 @@ timeout_cmd ()
 
 qmp ()
 {
-	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | nc -U $1
+	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
 }
 
 run_migration ()
 {
-	if ! command -v nc >/dev/null 2>&1; then
-		echo "${FUNCNAME[0]} needs nc (netcat)" >&2
+	if ! command -v ncat >/dev/null 2>&1; then
+		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
 		return 2
 	fi
 
-- 
2.18.2

