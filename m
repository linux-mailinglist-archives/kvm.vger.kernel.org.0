Return-Path: <kvm+bounces-57043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A824B4A0FE
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A17271B2555E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 04:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D9E2EF652;
	Tue,  9 Sep 2025 04:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUu/red0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B75B45945
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757393948; cv=none; b=TwWgNoO9h/l9yIBF8fxoma/083bWb7D8tChY4uzbsg6FAYl397oP+lSKJQQ26ovW2QcCcCA1/5U2i05YaOMY7wHR7GkQvWdW2wSVN04gfmzhpy6y/Fcnawd+KDmvRBYjLpt3s7LJI1wR3ZWxqnDtclrTnv/yL4T8vsZrnuvG+0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757393948; c=relaxed/simple;
	bh=rJ3VYbeZs93t6JJRib+IC12PIgArltgdTVzfzxFNAU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mfpQVj4eHRvxiCNnVfz3kZZQZiE07ZVMZHbs0JP3IKEp3Aily+YxXMs3odmfRVQLPNAMnlnkB3gDtFaOJCZEV3lV8xfwYEAiL3kQ2rKWMI6jaT9chByl9DwzTcE9W1FzfjZIG+B6xeozs9E5xseyD2e/8XCQAalP/4Dfi8xcc+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WUu/red0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757393945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=37ll8KrtqTLwuQ2CwEJfYHSot++YMLPHjRT3gI1RWcg=;
	b=WUu/red0fFvxiIKsNmQKwOtlxp/l6oeKlDmSTqRP4Dxoqjh7VHdsYGdxMtxs3Z4nTVTbJt
	0dggtC5qfWNRZilQ2OCjymGFZ4/gkbzkj3Hfo01QfXHgBs+GIgwEgvK1RBK0bwfGYGYqXC
	JvkC1AvCvYRPx97Fl31DZnwlcKjID/4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-hi03hBpQNLSGJ9wqFyRSkw-1; Tue,
 09 Sep 2025 00:59:01 -0400
X-MC-Unique: hi03hBpQNLSGJ9wqFyRSkw-1
X-Mimecast-MFC-AGG-ID: hi03hBpQNLSGJ9wqFyRSkw_1757393939
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95D8A1800576;
	Tue,  9 Sep 2025 04:58:59 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.46])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4DEF61800447;
	Tue,  9 Sep 2025 04:58:57 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the dependency on "jq"
Date: Tue,  9 Sep 2025 06:58:55 +0200
Message-ID: <20250909045855.71512-1-thuth@redhat.com>
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
 v2: Change the regular expression according to Claudio's suggestion

 scripts/arch-run.bash | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 36222355..16417a1e 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -296,11 +296,6 @@ do_migration ()
 
 run_panic ()
 {
-	if ! command -v jq >/dev/null 2>&1; then
-		echo "${FUNCNAME[0]} needs jq" >&2
-		return 77
-	fi
-
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${qmp}.in ${qmp}.out' RETURN EXIT
 
@@ -312,8 +307,7 @@ run_panic ()
 		-mon chardev=mon,mode=control -S &
 	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
 
-	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
-	if [ "$panic_event_count" -lt 1 ]; then
+	if ! grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST_PANICKED"' ${qmp}.out ; then
 		echo "FAIL: guest did not panic"
 		ret=3
 	else
-- 
2.51.0


