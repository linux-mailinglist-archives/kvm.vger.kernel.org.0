Return-Path: <kvm+bounces-18601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A268D7CEE
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83D261C2126F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 07:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC91F535D4;
	Mon,  3 Jun 2024 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXUVY9ox"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2473D5025E
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 07:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717401594; cv=none; b=r5rtvZkv3jw1XIGwWd21VbAmJZitiki4bz0hy1s2BWFyOzoxWocnaf1DuVIa6yHtjUvI84LJOey4ZxGt9WI2q8zRKb//8U7tHh5bFbW6Q1HG5utgRKxlPPk/ACl41J47GaCDuAXIpJXfg7VyjneFbVw2lFIxrsHOHrFkmPYjFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717401594; c=relaxed/simple;
	bh=sl0eOhKaqV4ZffyJ1b37o5/QReEGdFrUaANebd2RGn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hv3yYPLs2nTb7hqqz0ls3l8fjIDySPjYab6fD7T7ixMp965S0uHLkwABqQuwMNc1tho9TpseKNcpmx4+Sbx9vUrDm7GiFAF0MrxHDFC2JdM57faQ2WQDAQ6Rlmbyr/ddZWdGKibpuSYrShFqEaaE0SM8UQtycyjF8XxJDW0ItQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXUVY9ox; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717401591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1wJofXETn62DHmI5q9LgtOq/N3UMFNLogstvq5m/PqM=;
	b=eXUVY9oxyDsDb4ojfyKjFk/3Sf/8xAMrliGh7NWvMPjZwneFL0cmjHITRRwubJdc9p888B
	y/SNLCATaH5wNR+eg+7nRQK9If2ZworYGQp4pbFB237DiMubyyiVPx+RcKqX+WyuL3XJ83
	gNr6b27+uiuxtQevEEy2bm6Gek6Dm8E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-c2vdkhXUNe-oF_nZugxyDg-1; Mon,
 03 Jun 2024 03:59:47 -0400
X-MC-Unique: c2vdkhXUNe-oF_nZugxyDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C7FB29AA382;
	Mon,  3 Jun 2024 07:59:47 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.65])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C714A28E3;
	Mon,  3 Jun 2024 07:59:45 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	linux-s390@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] scripts/s390x: Fix the execution of the PV tests
Date: Mon,  3 Jun 2024 09:59:44 +0200
Message-ID: <20240603075944.150445-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Commit ccb37496 ("scripts: allow machine option to be specified in
unittests.cfg") added an additonal parameter (the "machine"), but
we forgot to add it to the spot that runs the PV test cases, so
those are currently broken without this fix.

Fixes: ccb37496 ("scripts: allow machine option to be specified in unittests.cfg")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/s390x/func.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index 6b817727..f04e8e2a 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -35,5 +35,5 @@ function arch_cmd_s390x()
 		print_result 'SKIP' $testname '' 'PVM image was not created'
 		return 2
 	fi
-	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 }
-- 
2.45.1


