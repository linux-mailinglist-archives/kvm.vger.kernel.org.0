Return-Path: <kvm+bounces-10117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C40C086A064
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EAEEB30ECC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1154A143C48;
	Tue, 27 Feb 2024 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j45o1q6j"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD49524B2
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061687; cv=none; b=pex1CIn8O/QZti4YWxfPuY68tZX+Toj05Dhbal46oRZNPxCXTXYqX5oDqd9bjpdYp4W90ClgHujYwpOn7Es1g1qPjmZLITH6kfdGsVAd8ST2/sOWGzaauVPTpkkuNboM7UpMJud/xPxgltDbykrgxiLx+aWOJQuFCELQTsiKoEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061687; c=relaxed/simple;
	bh=3LDznxWjy7yNqKOljjbACMiXY3NHVbc6pQf9X3Yw9ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=bGtdeQ6A8hm728NHWSZVjQGnOUhROiap7DZkSwSHiOBy6rK8/gmwgIxEAox3p0Xmik5fNIGUCMA7wmRmI0aGitEpkhyh9y2mTpgZ4S58HbA7ckM+3eNyeC9iDzjrPoXiU2+hxWdMGiKsPHjWIQOkR+nJbDpbVGpU4UsrT0VjDCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j45o1q6j; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YaaM1tdWXQy3CMwa8iTfOjIIZAX3H3bey75zFrrIGnE=;
	b=j45o1q6jCNB3DCZWurHh2q39AFZwuG4+v/btXnjihR+n48puNnKo8SmYR27AFw/qPNmCVP
	xK7E31vRuF+P9NwLutt0gwBxQoQHa0as7JvD8HhSVpg/kiJlHNhcqJ2r0QdMaWb5W4DJgD
	nnJrlM7j1lcPD+Uv144ikDljToD1chE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 02/18] runtime: Add yet another 'no kernel' error message
Date: Tue, 27 Feb 2024 20:21:12 +0100
Message-ID: <20240227192109.487402-22-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
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
2.43.0


