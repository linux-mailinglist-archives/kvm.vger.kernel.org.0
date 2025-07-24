Return-Path: <kvm+bounces-53384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E20B10DAB
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 16:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44BF51C83385
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9787C2C15B4;
	Thu, 24 Jul 2025 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edjyBTv2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D42C15AB
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753367589; cv=none; b=LqhxdNMSPcnWqyu7VWD660OyzXz6I1Ad6+0oZZ0eKdk0o01+g7uz2T6AucrOwg9jChk2JKlYzcG0vYrifHhur0nt7lCKHpyXfmolfeP+/i2y465LMAUWI4FxYfP4e9MAonX6BrC/qx4lMx+KreuYN6ZZiDBbnn62Q4PHu6iI59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753367589; c=relaxed/simple;
	bh=ACr3dE8O5DiVKuCZcD+Ccn25vl/gAPSsalH527SvbAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jaojQ9uFuQvIben1fHBOWTgIfXAtH62ebfQAk/+TNC2Ntu8hrYiZCTARrAaUYmPOxUlovgnwf7VIeLo3xTUaYkqPmdFk56MxFvse/6w5U+ieuB4N6u3kpIohP6fV6SNizflr/r6aGfZhXe/U83Xfx1N+TD49xmYaRmqGc6rLrD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edjyBTv2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753367586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r7Qf88+b3GmDd0Jy3caEkchuJxkyb/YskX3TVb93Loc=;
	b=edjyBTv2ZhEsywJxDpzeVHohq7NVpl+nRI+jeH7kj1nD5tMLNcRKHgwCSDMHppwGirgIqv
	w/SJJv5Ci+NBqS3ohXYXlnKDg1fCcAPr9354xIjp6bw+o2u6ZvWYaXThkze7mVIHgSVdbW
	tZbqfonshMdKwJtY19+CI1qc9bM99qU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-e6fR9NgROteM9NIzBEuw8w-1; Thu,
 24 Jul 2025 10:33:02 -0400
X-MC-Unique: e6fR9NgROteM9NIzBEuw8w-1
X-Mimecast-MFC-AGG-ID: e6fR9NgROteM9NIzBEuw8w_1753367581
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 927231956089;
	Thu, 24 Jul 2025 14:33:01 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.82])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E44D419560AA;
	Thu, 24 Jul 2025 14:32:59 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org
Cc: Andrew Jones <andrew.jones@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests PATCH] scripts/checkpatch.pl: Adjust the top_of_kernel_tree check for kvm-unit-tests
Date: Thu, 24 Jul 2025 16:32:58 +0200
Message-ID: <20250724143258.52597-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

The copy of checkpatch.pl that we currently have in the kvm-unit-tests
repository refuses to work without the --no-tree switch, since it looks
for some kernel-related files to determine the top directory. Adjust this
list of files for the kvm-unit-tests repository to make it work.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/checkpatch.pl | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index acef47b7..e858261c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1382,9 +1382,8 @@ sub top_of_kernel_tree {
 	my ($root) = @_;
 
 	my @tree_check = (
-		"COPYING", "CREDITS", "Kbuild", "MAINTAINERS", "Makefile",
-		"README", "Documentation", "arch", "include", "drivers",
-		"fs", "init", "ipc", "kernel", "lib", "scripts",
+		"COPYRIGHT", "LICENSE", "MAINTAINERS", "Makefile",
+		"README.md", "docs", "lib", "scripts",
 	);
 
 	foreach my $check (@tree_check) {
-- 
2.50.1


