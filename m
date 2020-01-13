Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C488139A57
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 20:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMTvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 14:51:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726202AbgAMTvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 14:51:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578945069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0mFyRlYXkeza/c8rVf5F+jfb7DpuuePFUt7750qH+2s=;
        b=XhZA5WDZ5xORjUlJDJ0H/cwKhPUA1Leuu93b58R3ZpCRp5Rm9pAyjaDULrZqQs8nwuzkiI
        uw3EtORTDM7v+R1ODXwLsUUKsZd0Qm/xNpd+W9KXhtoqorRX4VEkU17gL8+AVen1Y7D4oc
        Lj+njorTDJJqrdSr96eHEItD0vtQLOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-Bf4kQpwhM--bwaFdHgFyww-1; Mon, 13 Jan 2020 14:51:07 -0500
X-MC-Unique: Bf4kQpwhM--bwaFdHgFyww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABDDB108C2AD
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 19:51:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-74.gru2.redhat.com [10.97.116.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E674260BF1;
        Mon, 13 Jan 2020 19:51:04 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests] travis.yml: Prevent 'script' section from premature exit
Date:   Mon, 13 Jan 2020 16:51:02 -0300
Message-Id: <20200113195102.44756-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'script' section finishes its execution prematurely whenever
a shell's exit is called. If the intention is to force
Travis to flag a build/test failure then the correct approach
is erroring any build command. In this change, it executes a
sub-shell process and exit 1, so that Travis capture the return
code and interpret it as a build error.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 .travis.yml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 091d071..a4405c3 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -119,5 +119,5 @@ before_script:
 script:
   - make -j3
   - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
-  - if grep -q FAIL results.txt ; then exit 1 ; fi
-  - if ! grep -q PASS results.txt ; then exit 1 ; fi
+  - if grep -q FAIL results.txt ; then $(exit 1) ; fi
+  - if ! grep -q PASS results.txt ; then $(exit 1) ; fi
--=20
2.23.0

