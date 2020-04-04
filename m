Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA5119E63B
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDDPry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 11:47:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52446 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgDDPry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 11:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586015273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vnt8+N5RBipBuCDN1bwVcH7MsY/pHwnnja9bLS5Y4k=;
        b=TfsVg8Dbd8FUFV+aKcQj1zwgY7z00dEtMtFmWpVsZhroRWpAHDP/MpGiBfWLkI5dWGE/Um
        ic9DVWZl2oL2ImRUjFeeO4PdCvivvKU6hVxKdiAf4QWQuVv9zmGrcvDLOkg7ks83JDl4Z0
        3Tlt6Db88pjs7hhKIYa9k+ZOwOLT2q4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-_aa2KBvUMeSLHSaD9ltaWw-1; Sat, 04 Apr 2020 11:47:51 -0400
X-MC-Unique: _aa2KBvUMeSLHSaD9ltaWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64C99DB60;
        Sat,  4 Apr 2020 15:47:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 038A85E000;
        Sat,  4 Apr 2020 15:47:47 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 1/2] run_migration: Implement our own wait
Date:   Sat,  4 Apr 2020 17:47:38 +0200
Message-Id: <20200404154739.217584-2-drjones@redhat.com>
In-Reply-To: <20200404154739.217584-1-drjones@redhat.com>
References: <20200404154739.217584-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bash 5.0 changed 'wait' with no arguments to also wait for all
process substitutions. For example, with Bash 4.4 this completes,
after waiting for the sleep

  (
    sleep 1 &
    wait
  ) > >(tee /dev/null)

but with Bash 5.0 it does not. The kvm-unit-tests (overly) complex
bash scripts have a 'run_migration ... 2> >(tee /dev/stderr)'
where the '2> >(tee /dev/stderr)' comes from 'run_qemu'. Since
'run_migration' calls 'wait' it will never complete with Bash 5.0.
Resolve by implementing our own wait; just a loop on job count.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 scripts/arch-run.bash | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d3ca19d49952..da1a9d7871e5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -156,7 +156,11 @@ run_migration ()
 	echo > ${fifo}
 	wait $incoming_pid
 	ret=3D$?
-	wait
+
+	while (( $(jobs -r | wc -l) > 0 )); do
+		sleep 0.5
+	done
+
 	return $ret
 }
=20
--=20
2.25.1

