Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3B913C26C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 14:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgAONRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 08:17:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726555AbgAONRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 08:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579094227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d3lYgzAufqIBnHm/YrA9eVcXZGLVtR4oW9p6BLViQI4=;
        b=NPP3l/XQ4TI8QPrb+LQHlGqqwUfGgpzQ/Lo5dER3ehlsQ90CIuI2otKO+ncetIkeLjg9dk
        oxJREffpIgx5AanFyAFXKUhsQy5hjfg+lACKuGrzYfL7xBE6/QKcAqlLWlfZqjigK5kC5a
        WYfN9TiC+hs1OJwnVbPVzXrgsqgIbmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-dnImFfl2PQah2Y3x4VCaJA-1; Wed, 15 Jan 2020 08:17:06 -0500
X-MC-Unique: dnImFfl2PQah2Y3x4VCaJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DA00800D4C
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 13:17:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-74.gru2.redhat.com [10.97.116.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B43A510372F3;
        Wed, 15 Jan 2020 13:17:03 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH v2] travis.yml: Prevent 'script' from premature exit
Date:   Wed, 15 Jan 2020 10:17:01 -0300
Message-Id: <20200115131701.41131-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'script' section finishes its execution prematurely whenever
a shell's exit is called. If the intention is to force
Travis to flag a build/test failure then the correct approach
is erroring any command statement. In this change, it combines
the grep's in a single AND statement that in case of false
Travis will interpret as a build error.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 Changes v1 to v2:
   - Simplify the grep's in a single statement [thuth]
   - Also grep for SKIP (besides PASS) [myself]
 .travis.yml | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 091d071..0a92bc5 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -119,5 +119,4 @@ before_script:
 script:
   - make -j3
   - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
-  - if grep -q FAIL results.txt ; then exit 1 ; fi
-  - if ! grep -q PASS results.txt ; then exit 1 ; fi
+  - grep -q 'PASS\|SKIP' results.txt && ! grep -q FAIL results.txt
--=20
2.23.0

