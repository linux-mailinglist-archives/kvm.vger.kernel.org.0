Return-Path: <kvm+bounces-71779-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPVPKc+FnmnRVwQAu9opvQ
	(envelope-from <kvm+bounces-71779-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ECDA191E73
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 64FCC306ECA2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B452D481F;
	Wed, 25 Feb 2026 05:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pq/Lihay"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783C271A94
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996396; cv=none; b=EelppDQSOb6nXmBgyevdjCrgYRn9iygTzEU3D3Wig6htyJSUjPO3EmX22AXu2yllM/vMlhEOJik2E5ETWNPv+oMr8n+r2HxYf3l7j6YFaQkA4xe+CJQjSXusK5MNMHSOhHWa/8rVcoT7dSO1p9+h4PLsUSepwo1TSv3zcq0qots=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996396; c=relaxed/simple;
	bh=ptvdtvt4pOgw51Q1eGDp+/xnajZKbVwNJRCooAtok1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9+ASxdyU5+eE+CADhh0UvWrNnm8gEly8lk2RmYcmYRAEnY2cd5ku+SIeAfdW6cpVBmFf0k9DfZ5ulNxC1TQVjTbA5fGesn9y1AxFpPum/5iLzLKU6Pgv2utSpj1PkgKh/TGuz26J1C+zX7M+5+Lwt43sjrFuiMeRao+S3z/34M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pq/Lihay; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48336a6e932so38080025e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771996393; x=1772601193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqrb1njuSeGzwFOqvJshYg5hho1sLouIHptMUptf6Ks=;
        b=Pq/LihaygZKm8/trojeaSiEInJjX8hdfvUQVrHQaAdShtvsg7EQJNWjFwwLf1Tx5jb
         /iYJm1XaJLzow8lmV4F/egpunkZ8kf67pRfHRhefjSY1g47i2wXzAqKgJHEkz367jyc/
         O8jlgG32N1IyNLKarwz0d3h403o1zreyqLiirZUs4DBDgDCWYjS7Vbs74guZ9/Ehuhn3
         zkRciaLGCBojK6fhRSo2qbKHMGreSvL2cJijD5TeLNcE+HEErjpexa9j2dLmOUYwnQBi
         wwdF1k2Ik+NORRwm9+Qtw98qo3dW6VTqdbg/mtWL7IrzwiHZMHHterIe83j/UtMzK0AB
         9Z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996393; x=1772601193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yqrb1njuSeGzwFOqvJshYg5hho1sLouIHptMUptf6Ks=;
        b=UayC933VOqGsLTEKMUdIXeMRN0YiFf3r6dnrCslthV/geHbuTSN0k7p3vALK8bE+Zc
         PyWmc1iZiM7nO7wLRj9G7JAK/fs4SRoc4aibAbyM/USyFK4iEYzRckaxvN3cGTyFyIpv
         OOm/9ewIQ/Pb7LAP9j3pjOD6ujvLq5HFkF2LmCAtRkkEYmLvKGFohwZNQPRUMK/mTEOO
         8kc4jR4d7eZdOOaN2nBaFe5eeEHiLPG1PBADJ8GkFOCuRlOVI32nrrrJ95jr3aND9lPo
         RfHtLPXXBMlPxiNDXJrqc2M9Z0hU4/6Sj5+2Q9axh6s1IYaKyFdXClKjBUIBIdB00s+f
         56Hg==
X-Gm-Message-State: AOJu0Yz9BIqvt+kLpEyKm674BamerQwjSKKaa8E8ilfT6Rqk8x0gcyG7
	C/pSA6XeA7PPCBK8G2XrEOrKBYvt49ZRlAiINCUhpJC5aGeyMEwt8e/rl/LD0s5XluA=
X-Gm-Gg: ATEYQzz80ZKdK4I8ZdSrULn5rXeFLsqluslFWVaVgPIkUcCyWYb+CPnJ7Gqu2X4zHP+
	pc1puwknftU9bDMOyd+g+CChB/jCyGQHw020TtoZxjFh1c8j1QsWFrf0iY+oWrMAbuiQZebC2Vu
	uHunQ9KWDHCVP6wKsHMirXcbzfQv5cYuLgo3f0/VkKCSZ0HeqwoMCGnqvyhTYsrgNdU/K39SEvw
	lqf3/eQ9CI5hGklXEjvJg5x25aHB7P9KsTLuThCJvEYO6EbOn0PF/A0lBHJxbWh+7U6KHyslUux
	K8mZgDaIinw9hf4LNY1Ua3J4S7CohCk5q7ug1zXm81vSt9Uv/VITS+N65CDE22ZNLKykB6OtJe2
	6Nwm2O6EMQmJzacZmU26CNsJoE7Q0IJYFnulvUSCLeG4DpAyZdU97SfdUSeNK4nDAGY5LuTOI4/
	AQtma07+Zb+u+/dMUiMqVctwVrZU1e/EzQGCH5txc0lXM7aCIpsFCvq7jUlbHVBhYyMo4Hunla
X-Received: by 2002:a05:600c:4692:b0:483:6d42:25c6 with SMTP id 5b1f17b1804b1-483bef54059mr19754265e9.23.1771996393138;
        Tue, 24 Feb 2026 21:13:13 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcbf894sm2825775e9.16.2026.02.24.21.13.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Feb 2026 21:13:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/5] accel/kvm: Include missing 'exec/cpu-common.h' header
Date: Wed, 25 Feb 2026 06:12:59 +0100
Message-ID: <20260225051303.91614-2-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225051303.91614-1-philmd@linaro.org>
References: <20260225051303.91614-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71779-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 1ECDA191E73
X-Rspamd-Action: no action

kvm-accel-ops.c uses EXCP_DEBUG, itself defined in
"exec/cpu-common.h". Include it explicitly, otherwise
we get when modifying unrelated headers:

  ../accel/kvm/kvm-accel-ops.c: In function ‘kvm_vcpu_thread_fn’:
  ../accel/kvm/kvm-accel-ops.c:54:22: error: ‘EXCP_DEBUG’ undeclared (first use in this function)
     54 |             if (r == EXCP_DEBUG) {
        |                      ^~~~~~~~~~

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-accel-ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 8ed6945c2f7..6d9140e549f 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -16,6 +16,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
+#include "exec/cpu-common.h"
 #include "accel/accel-cpu-ops.h"
 #include "system/kvm.h"
 #include "system/kvm_int.h"
-- 
2.52.0


