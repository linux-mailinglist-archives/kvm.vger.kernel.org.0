Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8347BCC8
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhLUJVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:21:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232251AbhLUJVi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 04:21:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640078497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=E+nU5g3WvlXrnBIx5xzr54f9zPjEKnDM/lB43a3RtfA=;
        b=EHq8ql200qKYg+OUj8nK0wjVuhslg9Tm09PdbkZyPxUMsNF/eAcFvBADpph7aWZoeRF22N
        RjAd3p17FY4bFzVus2b7qzonRGSu4frTeoquzClzw2DnYAQ0td4pDs8XOZykeL4psLSuB3
        9hkrEYrBDpbT0ZiOoVVOm/0i0+ID/MM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-SvE9ufMBNNCTNRLW58Hm0g-1; Tue, 21 Dec 2021 04:21:36 -0500
X-MC-Unique: SvE9ufMBNNCTNRLW58Hm0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D32301006AA3;
        Tue, 21 Dec 2021 09:21:35 +0000 (UTC)
Received: from thuth.com (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE8AD5BE0E;
        Tue, 21 Dec 2021 09:21:31 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as SKIP if ncat is not available
Date:   Tue, 21 Dec 2021 10:21:30 +0100
Message-Id: <20211221092130.444225-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of failing the tests, we should rather skip them if ncat is
not available.
While we're at it, also mention ncat in the README.md file as a
requirement for the migration tests.

Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 README.md             | 4 ++++
 scripts/arch-run.bash | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 6e6a9d0..a82da56 100644
--- a/README.md
+++ b/README.md
@@ -54,6 +54,10 @@ ACCEL=name environment variable:
 
     ACCEL=kvm ./x86-run ./x86/msr.flat
 
+For running tests that involve migration from one QEMU instance to another
+you also need to have the "ncat" binary (from the nmap.org project) installed,
+otherwise the related tests will be skipped.
+
 # Tests configuration file
 
 The test case may need specific runtime configurations, for
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 43da998..cd92ed9 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -108,7 +108,7 @@ run_migration ()
 {
 	if ! command -v ncat >/dev/null 2>&1; then
 		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
-		return 2
+		return 77
 	fi
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
-- 
2.27.0

