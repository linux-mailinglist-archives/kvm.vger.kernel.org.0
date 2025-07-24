Return-Path: <kvm+bounces-53375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162C0B10B6A
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0476AAE7746
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AD5262FE9;
	Thu, 24 Jul 2025 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MoDbl0fW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AAB13B5A9
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753363867; cv=none; b=gYOgyp3jKCi4mUSarosgPZYFJzrXe1joIbvYeKw7koXZ5sHUVdr4xjlIoSdFuG6yT8jajCq9Km/77+rHunbXjszBjLQAqXMCI1AdH3ViryNJUUxbYdPdoYeGFD4Umk7IIE/3Ddx7cF8OQnhQZFDF+fLgjrpufqlluBeF4IOOXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753363867; c=relaxed/simple;
	bh=U1LTQH2xlIG9oWXXMkOsck6Dd8eOF46Ie/UNd+mfeyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hphBlDMRiaGJHwGTS6k3q5bxigQxzfAJS9D3umLyO9pUmPQawe5WEQwY96M3cCqMzSw1/VoXz8bz4T7Vk6QJsOdG7CWDNN2FP1qUnYC101SYIPvSV1MAPkkuuLfFBLIa/14wPYeJUPVT+G2fvWosLhri042B7CLqj3BAzXv1Hjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MoDbl0fW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753363864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o73t0OD4VwQtJXUCdj8mKcSys4yhjAHxfbmFUYFSglg=;
	b=MoDbl0fWDmv/2us1XH4jCrNjSwV8UVK4EhNJjgxZQWCn6Svbn7QWD6PPXCGOYUfmPPHewG
	47Ibsqw/sEZdg/2awWXE02LlqihBIqX3kQ/XoqXGS+vb8jLeb3qTQmDSMgtjTO0Rcy1Dyw
	TI2EdIAP7op+qZ6avSVxZ0tngilcfiw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-ERAbxcrHNdC1f9mHGjXdlg-1; Thu,
 24 Jul 2025 09:31:00 -0400
X-MC-Unique: ERAbxcrHNdC1f9mHGjXdlg-1
X-Mimecast-MFC-AGG-ID: ERAbxcrHNdC1f9mHGjXdlg_1753363859
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7304619560B6;
	Thu, 24 Jul 2025 13:30:59 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.82])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2127B3000199;
	Thu, 24 Jul 2025 13:30:56 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/3] s390x: Fix unreliable panic-loop tests
Date: Thu, 24 Jul 2025 15:30:49 +0200
Message-ID: <20250724133051.44045-2-thuth@redhat.com>
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

In our CI, the s390x panic-loop-extint and panic-loop-pgm tests
are sometimes failing. Having a closer look, this seems to be caused
by ncat sometimes complaining about "Connection reset by peer" on stderr,
likely because QEMU terminated (due to the panic) before ncat could
properly tear down the connection. But having some output on stderr is
interpreted as test failure in qemu_fixup_return_code(), so the test is
marked as failed, even though the panic event occurred as expected.

To fix it, drop the usage of ncat here and simply handle the QMP
input and output via normal fifos instead. This has also the advantage
that we do not need an additional program for these tests anymore
that might not be available in the installation.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/arch-run.bash | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c440f216..58e4f93f 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -63,14 +63,6 @@ qmp ()
 	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
 }
 
-qmp_events ()
-{
-	while ! test -S "$1"; do sleep 0.1; done
-	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' |
-		ncat --no-shutdown -U $1 |
-		jq -c 'select(has("event"))'
-}
-
 filter_quiet_msgs ()
 {
 	grep -v "Now migrate the VM (quiet)" |
@@ -295,26 +287,23 @@ do_migration ()
 
 run_panic ()
 {
-	if ! command -v ncat >/dev/null 2>&1; then
-		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
-		return 77
-	fi
-
 	if ! command -v jq >/dev/null 2>&1; then
 		echo "${FUNCNAME[0]} needs jq" >&2
 		return 77
 	fi
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${qmp}' RETURN EXIT
+	trap 'rm -f ${qmp}.in ${qmp}.out' RETURN EXIT
 
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
+	mkfifo ${qmp}.in ${qmp}.out
 
 	# start VM stopped so we don't miss any events
-	"$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+	"$@" -chardev pipe,id=mon,path=${qmp} \
 		-mon chardev=mon,mode=control -S &
+	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
 
-	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
+	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
 	if [ "$panic_event_count" -lt 1 ]; then
 		echo "FAIL: guest did not panic"
 		ret=3
-- 
2.50.1


