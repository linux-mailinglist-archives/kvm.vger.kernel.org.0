Return-Path: <kvm+bounces-53377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B9BB10B6D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F050216FDEA
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3DD2D8DAF;
	Thu, 24 Jul 2025 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KgeSm1Z7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31A28A405
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 13:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753363874; cv=none; b=gReMr29LQ80xLx/n1jv1ujY+lSafwVesbKS1NmxZZe+aqpHyI/5QT81sZBo/BkHBVvuULZUQRbb3zRccB3lo7qUByFQGK3iEtGwny6jJ3zuxarCEEtchfTy8KCbT9rEWdHwFe+Xf12qvTgEwK5qpKdACRq8wlSas3I1C4+4d4T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753363874; c=relaxed/simple;
	bh=4pAtAMRcs6w3yL3fzNMtx8tTCvPRhIm4nLAtOrCeJrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/PqN1/msVSo9H8wnXtP2UDt8rmvDn3737biOcUyfuDNOvosRxxhIrjdO3mcrnRZr+Uxp+5mtCKi65fpmWV+iKQgPuXd8gcq5SGp4pRyX6WdxbHuvmsho/PmGY6DPGAYLJS1StM0h3rn7fDkJj/rRmlvWb8Kgc2WtSB1vewKs7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KgeSm1Z7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753363871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4ujYQlYhO82BU6zkmwhTrZ/y116O7NG9CBxQOBqYTlY=;
	b=KgeSm1Z7IXIhUxxlg0uxKRvxRlcc/SVfUo3JerhxERI5gkzqJf/1CDwsl5nd2y7ofdGa8g
	n+wBxtTw2v9P/K4+koVeXa/zy4xg9Yq49kTHRETgeX6CpJLIgIFcCoNWEfT1G11aBux1rr
	JnF6H9Y3qEDZbYIgj/cfo2GnXFN8PM4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-WzBztbmQNo-W6YSnw81fBg-1; Thu,
 24 Jul 2025 09:31:07 -0400
X-MC-Unique: WzBztbmQNo-W6YSnw81fBg-1
X-Mimecast-MFC-AGG-ID: WzBztbmQNo-W6YSnw81fBg_1753363865
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B691719560AA;
	Thu, 24 Jul 2025 13:31:05 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.82])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E6E4430002C8;
	Thu, 24 Jul 2025 13:31:02 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 3/3] scripts/arch-run.bash: Drop the dependency on "jq"
Date: Thu, 24 Jul 2025 15:30:51 +0200
Message-ID: <20250724133051.44045-4-thuth@redhat.com>
In-Reply-To: <20250724133051.44045-1-thuth@redhat.com>
References: <20250724133051.44045-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

For checking whether a panic event occurred, a simple "grep"
for the related text in the output is enough - it's very unlikely
that the output of QEMU will change. This way we can drop the
dependency on the program "jq" which might not be installed on
some systems.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Marked as "RFC" since I'm a little bit torn here - on the one side,
 it's great to get rid of a dependency, on the other side, using
 grep might be a little bit less robust in case QEMU ever changes
 the layout of it's QMP output...

 scripts/arch-run.bash | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 58e4f93f..5abf2626 100644
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
+	if ! grep -q '"event": "GUEST_PANICKED"' ${qmp}.out ; then
 		echo "FAIL: guest did not panic"
 		ret=3
 	else
-- 
2.50.1


