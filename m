Return-Path: <kvm+bounces-50869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D734AEA4E2
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80BC817AD1C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317332ED172;
	Thu, 26 Jun 2025 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dpNRsf0h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051C82ED173
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750961083; cv=none; b=La+EJMWQLGB05kwdYW/F6+mRfP6cS5Y9k7tKKgkhA9jmI7byycUyxQqpCCamplm70eL/1EYqr+SbHFYpWwSUf9KRtqAB//TjCyHdXv+n4LjmSdWqJS12DOTv5Y/xNJQhoM4U3Ehy1gbjJwODSPhBrRZplGUHBRNlYFjh0NiIya4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750961083; c=relaxed/simple;
	bh=eQ6U6jVpCk81IysrAjZBbErYEEgDXg2y74UgEa2QPJU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=APWcef/I/hRQHnHJFlF4RA6ebNyzIl9BlbchZ/cLD4fOyVrpNnnq7KKvVJOEjE1IC8mtazNvQs+7xBYkJjzNUkC7thSaGfc9tCN04KbVor+/0U12K0gzospRJTgVsHT6rffDR00hGOq776cwYMZdj68n34GmayjNdYJVYDSlHNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dpNRsf0h; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234f1acc707so12436715ad.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 11:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750961078; x=1751565878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jobF0Ds9T+/LUDa7igHGUxtw4cAlTSwtLOVTgAH0GZM=;
        b=dpNRsf0hKEVxSgT6MJggP1PNxuVh+1RKh1OdnzWDYfMGVSazA2LsZb7M12d1BC1ima
         ti8CGY4YNK3vX04M8PymBrLe2RAsWmdTOh96VY09Bm1rttl1mASF91+nDzFOoMcxO8+u
         wveJfec6qIKJwWA1oRnFRVc9N2MYpnemNDqv/M+CJ7zGETNLDlj/uAsSbWuNyIXZpGNS
         mzNLfsKBxrvzASuC5xsO6hJ/pnAIrsA3x2W/tIj/xJ3vOoHB5JZPMnyOC8emqE8zypbr
         AtBbwJM/fIgt8GyPKUXpfuyswU4AM78HxgbLXe1wJOVjMKLjrBVcHHAaxlV+r36M7GM1
         yEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750961078; x=1751565878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jobF0Ds9T+/LUDa7igHGUxtw4cAlTSwtLOVTgAH0GZM=;
        b=rIPJXavg1B/lhwrcV1guF/VBN1zZhSC4ppzb6mljC4rWkkAZ1AqasWTmU0Xkcw11ff
         UVI7NdlMa2QjBzMrov4cP7N1TnGsBzC+Ft36sxROaF5k7X1x3dAuMudWF0U9NEpgGXGd
         w+8lneDIXcYKc9dnJruH734h7zk8s/srKMkuuJoVBBUjLom5fGIUCbm9Bhlgg1KZPVaD
         AqyC1tdOxisECX4i5/qQB/1NJy+lNDsxa707VW64DOWYgC39x3ztxy3SIueQ3qr83iGe
         jZzhk9iSgItWdqEqS5qxR0ANEXSW2ALO0+aMJVN/sXQLRZB3xCK+Rc+73Qn1M2KFo+w+
         aHqg==
X-Gm-Message-State: AOJu0YyW4tfhiPcs/mzrwtTR57DMcJNtXo/opwsdVHi9QbbDBAd0KC7N
	A3BZ3vdFNhtXPKxhwyIczv+qxxt3FPLopqn+j+gUPdgRY2t1l4e8Y+dHbcS4pis2ooiTstERLdx
	fj3oM4JnHcDGMtZVSYaISdg==
X-Google-Smtp-Source: AGHT+IEyKJOMhiBbX/WTP7wtJmRlM5OJv46I/p1k2IqmKiOOM/X23xYOcwYfDtjIbAlyyPwHPZ5c0SHQzgwZi/Ax
X-Received: from plbmn16.prod.google.com ([2002:a17:903:a50:b0:235:1661:e986])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d58e:b0:235:779:edf0 with SMTP id d9443c01a7336-23ac463560amr3143775ad.50.1750961078345;
 Thu, 26 Jun 2025 11:04:38 -0700 (PDT)
Date: Thu, 26 Jun 2025 18:04:24 +0000
In-Reply-To: <20250626180424.632628-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626180424.632628-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626180424.632628-4-aaronlewis@google.com>
Subject: [RFC PATCH 3/3] vfio: selftests: Include a BPF script to pair with
 the selftest vfio_flr_test
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, bhelgaas@google.com, dmatlack@google.com, 
	vipinsh@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This BPF script is included as a way of verifying where the latency issues are
coming from in the kernel.

The test will print how long it took to initialize each device, E.g.:
  [0x7f61bb888700] '0000:17:0c.2' initialized in 108.6ms.
  [0x7f61bc089700] '0000:17:0c.1' initialized in 212.3ms.

That then pairs with the results from this script to show where the latency
issues are coming from.

  [pcie_flr] duration = 108ms
  [vfio_df_ioctl_bind_iommufd] duration = 108ms
  [pcie_flr] duration = 104ms
  [vfio_df_ioctl_bind_iommufd] duration = 212ms

Of note, the second call to vfio_df_ioctl_bind_iommufd() takes >200ms,
yet both calls to pcie_flr() only take ~100ms.  That indicates the latency
issue occurs between these two calls.

Looking further, one of the attempts to lock the mutex in
vfio_df_ioctl_bind_iommufd() takes ~100ms.

  [__mutex_lock] duration = 103ms

And has the callstack.

  __mutex_lock+5
  vfio_df_ioctl_bind_iommufd+171
  __se_sys_ioctl+110
  do_syscall_64+109
  entry_SYSCALL_64_after_hwframe+120

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../testing/selftests/vfio/vfio_flr_trace.bt  | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_flr_trace.bt

diff --git a/tools/testing/selftests/vfio/vfio_flr_trace.bt b/tools/testing/selftests/vfio/vfio_flr_trace.bt
new file mode 100644
index 000000000000..b246c71c8562
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_flr_trace.bt
@@ -0,0 +1,83 @@
+#define msecs (nsecs / 1000 / 1000)
+
+/*
+ * Time 'vfio_df_ioctl_bind_iommufd()'.
+ */
+kfunc:vfio_df_ioctl_bind_iommufd
+{
+	@vfio_df_ioctl_bind_iommufd_start[tid] = msecs;
+}
+
+kretfunc:vfio_df_ioctl_bind_iommufd
+{
+	printf("[vfio_df_ioctl_bind_iommufd] duration = %ldms\n", msecs - @vfio_df_ioctl_bind_iommufd_start[tid]);
+}
+
+/*
+ * Time 'vfio_df_unbind_iommufd()'.
+ */
+kfunc:vfio_df_unbind_iommufd
+{
+	@vfio_df_unbind_iommufd_start[tid] = msecs;
+}
+
+kretfunc:vfio_df_unbind_iommufd
+{
+	// printf("[vfio_df_unbind_iommufd] duration = %ldms\n", msecs - @vfio_df_unbind_iommufd_start[tid]);
+}
+
+/*
+ * Time 'vfio_df_open()'.
+ */
+kfunc:vfio_df_open
+{
+	@vfio_df_open_start[tid] = msecs;
+}
+
+kretfunc:vfio_df_open
+{
+	// printf("[vfio_df_open] duration = %ldms\n", msecs - @vfio_df_open_start[tid]);
+}
+
+/*
+ * Time 'pcie_flr()'.
+ */
+kfunc:pcie_flr
+{
+	// printf("cpu = %d\ncomm = %s (PID = %d)\nkstack:\n%s\nustack:\n%s\n", cpu, comm, pid, kstack, ustack());
+
+	@pcie_flr_start[tid] = msecs;
+}
+
+kretfunc:pcie_flr
+{
+	printf("[pcie_flr] duration = %ldms\n", msecs - @pcie_flr_start[tid]);
+}
+
+/*
+ * Time '__mutex_lock()'.
+ */
+kfunc:__mutex_lock
+{
+	// printf("cpu = %d\ncomm = %s (PID = %d)\nkstack:\n%s\nustack:\n%s\n", cpu, comm, pid, kstack, ustack());
+
+	@mutex_lock_start[tid] = msecs;
+}
+
+kretfunc:__mutex_lock
+{
+	// printf("[__mutex_lock] cpu = %d, tid = %d, duration = %ldms\n", cpu, tid, msecs - @mutex_lock_start[tid]);
+}
+
+/*
+ * Dump the results to stdout.
+ */
+END
+{
+	// Clean up maps.
+	clear(@vfio_df_unbind_iommufd_start);
+	clear(@vfio_df_ioctl_bind_iommufd_start);
+	clear(@vfio_df_open_start);
+	clear(@pcie_flr_start);
+	clear(@mutex_lock_start);
+}
-- 
2.50.0.727.gbf7dc18ff4-goog


