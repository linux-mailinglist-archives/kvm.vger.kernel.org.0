Return-Path: <kvm+bounces-11022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDBC8724A0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17BB7282C3B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB7CDDB3;
	Tue,  5 Mar 2024 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wQ1z0WXD"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD7FDDA0
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657197; cv=none; b=eTiTooTj/ob/cY6T60Cj0ff3K0W6UiAMsPCzf7mzkkdoNvHuwaikChJoRCmhgkbV1L2+ezE7fIKy7HqJ8yM+hGpm7/GVXxDf492mC86U2wy+VUDYTOt+lfgib8uGiGPgaYdk/FCV64VONwtG+yE0PmgQ08UuoLV38WG9hI6FKGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657197; c=relaxed/simple;
	bh=lIwH8xHnBJ818vrg9V46923YX02/dsCdX8btlYgC618=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=D7F2PfstgHn/tY6sodewt4FaXhIJMP1EgJKORHSsfLICC81YyFroz1lbhWmfB6yh8k49d13wij55dkSjulnZMYvlifUUQr7d+g8SlMdgW3CKj1GpknICc+up5q5F/JWesoXsqajmGweal0ygOH8SheVbQsYJiKCeo+AiS6c1w8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wQ1z0WXD; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ByW6rDJtS6bwTp7JrfCRYR36QW/IGNhNiPCknwPvfkA=;
	b=wQ1z0WXDGBwuC3OyQm/jBErGrb7onmv1yOihG8axXolWsfKx3ZRbg/rZihHaOokeSqZ0x0
	bWVZ6kk1khlFxDzV3zWa3gIUsLFkxqjvC5LDkAD2cZzonlEnfgKUIRZBQ3RGqzHtHvfXk1
	enULMe85qPO3RpwfUTVUeTjA5/JL2MQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 02/18] runtime: Add yet another 'no kernel' error message
Date: Tue,  5 Mar 2024 17:46:26 +0100
Message-ID: <20240305164623.379149-22-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When booting an Arm machine with the -bios command line option we
get yet another error message from QEMU when using _NO_FILE_4Uhere_
to probe command line support. Add it to the check in
premature_failure()

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f2e43bb1ed60..255e756f2cb2 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -18,7 +18,7 @@ premature_failure()
     local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
+        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
         return 1
 
     RUNTIME_log_stderr <<< "$log"
-- 
2.44.0


