Return-Path: <kvm+bounces-53793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E8CB17015
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 13:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 770A416F31D
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDA92BE05F;
	Thu, 31 Jul 2025 11:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VO/A+Wso"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AD81F8753
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 11:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753959915; cv=none; b=PYy0MeP6tlfDqvrlzq4Dq98HLuh+enFtTq4X2yPQlRvbr6sIFXzFttZfiFf8nv+689pxz4PMEE1NW0Ca8OnbuwJEYh0BraMplBtPEZiPkKVslzR9BcOw1p8YGGOCLpf5/nGkdsu0zOZFfprQARBxrtVJnLOeNv24ahBpj34mPp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753959915; c=relaxed/simple;
	bh=2Lxu4/r+qMp5SjE4zG5rtaWv7fX61RLvDYdfGVX2X3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fKVSXy+3f8JiUnZLh1YHl5j9HtnQiQ7shKKq4MBgLnrUBWCxxLv17ySTZnALD93LyuC6UfweCv9wy6lp2+Q/NKatlrdWmAXTSUC+C8L4nIPuGv22hgKaHsw4Q2qq1Et2XWnYuiXGEtCbxZv+7Rfc3SFisEMdlTuKP/lOp5Atmj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VO/A+Wso; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753959912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0nuuisopRtI27MiBsxXAHfQEUoCZ9z7qIDXsfZJpxOQ=;
	b=VO/A+WsoyhOjwmM8HRI1DE+1cJi3/3gha3ru6WaGyk2P3S4HY/XJGbWUfkIyDXFKYRC8b5
	LT3xMAOcOMTEQk9vZdNFlHoek0p4v5QKztmWBA7dAh/CXUctazei2yvkU279WGSv9nVNXq
	vJ+Sdz64xSNRJZcanbZRWiOKMAH7+0w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-DesoCcSNO36kNePGMDDYvg-1; Thu,
 31 Jul 2025 07:05:06 -0400
X-MC-Unique: DesoCcSNO36kNePGMDDYvg-1
X-Mimecast-MFC-AGG-ID: DesoCcSNO36kNePGMDDYvg_1753959905
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C4821800360;
	Thu, 31 Jul 2025 11:05:05 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.86])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08BAE1800285;
	Thu, 31 Jul 2025 11:05:02 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the dependency on "jq"
Date: Thu, 31 Jul 2025 13:05:01 +0200
Message-ID: <20250731110501.38034-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

For checking whether a panic event occurred, a simple "grep"
for the related text in the output is enough - it's very unlikely
that the output of QEMU will change. This way we can drop the
dependency on the program "jq" which might not be installed on
some systems.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Use [[:blank:]]* as suggested by Claudio

 scripts/arch-run.bash | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 58e4f93f..4642cf95 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -287,11 +287,6 @@ do_migration ()
 
 run_panic ()
 {
-	if ! command -v jq >/dev/null 2>&1; then
-		echo "${FUNCNAME[0]} needs jq" >&2
-		return 77
-	fi
-
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${qmp}.in ${qmp}.out' RETURN EXIT
 
@@ -303,8 +298,7 @@ run_panic ()
 		-mon chardev=mon,mode=control -S &
 	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
 
-	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
-	if [ "$panic_event_count" -lt 1 ]; then
+	if ! grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST_PANICKED"' ${qmp}.out ; then
 		echo "FAIL: guest did not panic"
 		ret=3
 	else
-- 
2.50.1


