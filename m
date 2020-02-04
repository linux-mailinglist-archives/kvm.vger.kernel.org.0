Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D60151653
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBDHOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:14:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49235 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727286AbgBDHOD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 02:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=JYiRtRvpBRR1lSpvsT6uq7BwYvk8CgobihKz7X3F0/Q=;
        b=LnCPc9gOpvliVmiOS/HvxNmHONLksxLmTDRscnS/pE7yGNr2RtFE8owGMKqr6C1XeGE6Ti
        z19eSO0ixOoQ39S4io3EDbK3zGCF3dVu2kENsWXB/Dbj14YC3537I3Wz7eR+VMAJ+iZ87I
        OkQ9aAiBCuii9KZK+3R3fGeYwq0BPWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-4Dzz6PP0NwiRomkKiu3ZAg-1; Tue, 04 Feb 2020 02:14:00 -0500
X-MC-Unique: 4Dzz6PP0NwiRomkKiu3ZAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4415C1090780
        for <kvm@vger.kernel.org>; Tue,  4 Feb 2020 07:13:59 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89AF45C1D4;
        Tue,  4 Feb 2020 07:13:55 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [kvm-unit-tests PULL 9/9] travis.yml: Prevent 'script' from premature exit
Date:   Tue,  4 Feb 2020 08:13:35 +0100
Message-Id: <20200204071335.18180-10-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wainer dos Santos Moschetta <wainersm@redhat.com>

The 'script' section finishes its execution prematurely whenever
a shell's exit is called. If the intention is to force
Travis to flag a build/test failure then the correct approach
is erroring any command statement. In this change, it combines
the grep's in a single AND statement that in case of false
Travis will interpret as a build error.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-Id: <20200115144610.41655-1-wainersm@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 091d071..f0cfc82 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -119,5 +119,4 @@ before_script:
 script:
   - make -j3
   - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
-  - if grep -q FAIL results.txt ; then exit 1 ; fi
-  - if ! grep -q PASS results.txt ; then exit 1 ; fi
+  - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.18.1

