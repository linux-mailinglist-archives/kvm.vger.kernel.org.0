Return-Path: <kvm+bounces-61940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F5EC2F299
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 04:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B5B43B852D
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 03:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6603A27F73A;
	Tue,  4 Nov 2025 03:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ibzv9Gau"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A5523AE87
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 03:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762226949; cv=none; b=D2R0brKkc6sIn6Mc6eYqHcoxYnVXPhVG4yv9C5oaFb3AmHd/TphUz3sDfzr42NIbcDoyHMZaN8nNCMapcj9+8gDxfPIRapU9+qDO0rbaRmNXPLryUK0gwzuJgGDlen9gR9FlAyJCTcTEIdq9QvD9CHIi0LtpZ9xLdcn1WgSN3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762226949; c=relaxed/simple;
	bh=toccMtKGsKlb1dH3LHcY+VVnfqqU/d9JHHOsIQBNwk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RhEDZoTVDlED0LFRNlXIbB7XujdZZZ54tidf8S7O3lrLFulsp+et5O1iSHSfI8tHAaWlcnt2uQ8vkrRaKVGzWRM3FidNgVepHSlVYiJZ+QXffon/R/3GUbshWXT1LDE5x8JxfKTuuHX+a94VMdz+FgUHKGFtmhwLzW3xCaDVdKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ibzv9Gau; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762226946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3hWsX8Pwfh8VZ3xN+Slgk6Aq0XfZKsUZl1mRfApzW40=;
	b=ibzv9Gaun1Ax2TRKZerJ1kyaXaA40rM+z7ekXBxkzffTgn5NtCo3mqgA3KLNdwryFiuLzP
	yVl065cZMPJMlAE6rytVeh9WC15N6fgoZO19VtcFAXqkVhzXtBFbJ6D8dWVYeGGH1SwvaV
	e4/AGL2rRpt4ZDGyv7UQfgvPIVZ0rMA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-9uQiSVNjOvK2yDb_WIjMPQ-1; Mon,
 03 Nov 2025 22:29:05 -0500
X-MC-Unique: 9uQiSVNjOvK2yDb_WIjMPQ-1
X-Mimecast-MFC-AGG-ID: 9uQiSVNjOvK2yDb_WIjMPQ_1762226944
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58E4C1800675
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 03:29:04 +0000 (UTC)
Received: from dev64.shokupan.com (unknown [10.64.240.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E207180035A;
	Tue,  4 Nov 2025 03:29:02 +0000 (UTC)
From: Masatake YAMATO <yamato@redhat.com>
To: kvm@vger.kernel.org
Cc: yamato@redhat.com
Subject: [PATCH] tools/kvm_stat: add missing <delay> param to -s option
Date: Tue,  4 Nov 2025 12:28:52 +0900
Message-ID: <20251104032853.678269-1-yamato@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The parameter for the -s/--set-delay option was missing from
kvm_stat.txt.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 tools/kvm/kvm_stat/kvm_stat.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 3a9f2037bd23..a64d4428143f 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -103,8 +103,8 @@ OPTIONS
 --pid=<pid>::
 	limit statistics to one virtual machine (pid)
 
--s::
---set-delay::
+-s<delay>::
+--set-delay=<delay>::
         set delay between refreshs (value range: 0.1-25.5 secs)
 
 -t::
-- 
2.51.0


