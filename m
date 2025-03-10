Return-Path: <kvm+bounces-40552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70293A58B58
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 335AB3AA4CA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1D71CB51B;
	Mon, 10 Mar 2025 04:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aQHl9Xyi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC81C8618
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582739; cv=none; b=oOdpCNp0jgoDSVJWsbhLU5fmAz4TQIKh/d0D2AF4KtA7KlqeWzSN1XJq89ghFP66LS+C10Js2dTf7aQM4H8JiQlBjcmtGgJuIwzgnGMd8VWnq4WlsT9/MqpFmQrYjBae8LgwBL/S1cdp0iWlHn+VIi03ukvTQUnpCZ6d+JkUbtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582739; c=relaxed/simple;
	bh=txLvw32hXKMfA68z8picp0J4Zz7sQ6vy6AdbMmDTuK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YkuU/unaSfcQcwCPvsJ6KeUogVQBXOGvxOsHCFpayfmOyJFaJCrPBzOsqkw+vEZebUIg8vMFciLD/2fLWZnSFIrtrLT6KR65xaSGaUlOCEqNh2KBnvFCFbtyPIljnZdTOxypnBtUM1M3BP+S+HK82vHACad8YvIq5YnjR8yLDgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aQHl9Xyi; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fecba90cc3so7410105a91.2
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582737; x=1742187537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErKU0wbfVZdnsjs5NMSuiTB4KixyX1gD9AraKkIZNBI=;
        b=aQHl9XyiNliVtEL0ybhrk46JZbR+9Ndy1s97mXOx+o2MkHxvaX4uCcy1sOXNLrLLVe
         O4lLg1p4i1U3y8cp2OLHeyjK7csyD2i932xwMmpqQ7yyCHnTiU+JQnAYIRFZ/zg9f4Gk
         AzPt9+LHuryfF9i5p7x+4RybJh6oQro0InLsXyQUrFbHUCQkoJqzq71x3KE+geM6wYF4
         YCFccpKGQEFg7f0ocGzmtsd+aFqeyn8UdFY+HRJGVvL03PGmm+lbgIAP7VkYn7nJCqnu
         JhpdZwRDqKqek57IRTnvgSMdWUkVKHlfOje8ddxUq862zL2Bvw/S7fTpCh4ll02NoN6l
         S1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582737; x=1742187537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ErKU0wbfVZdnsjs5NMSuiTB4KixyX1gD9AraKkIZNBI=;
        b=KHmeiov0MIfxetlV5E0wVvvPARJNo/dIkoTjgF8sN3Z7/4Bk2fp2nw3DMGH/Q2iLAO
         A+hgLibU5NC6MpRzXf1KYc+5Ua2TM87WnmHoR9XQKIQuXOxcBW9afkN2fkwEovRVmtLw
         zVnHxZlL1dCSafzIyaMZQ3Qh5X3b4mcGD03icVlpWBkAHYChyuUeR1z9It5P8yo2nphN
         zbd54XLU5JTzehwtDACxHjl9jvOqDN468kVcX2F6ENPBCq+6BSvH9xGgJJL6ocbgqfE8
         6zcpFW6X6UNcU+HpiLSxIbaonqCeGqa2AfA8nNNmiK/JVosbtr87AtJlg8IUm8O86gTR
         lmmw==
X-Forwarded-Encrypted: i=1; AJvYcCV3Vu+JyHpQSqi9sjJpPJM5MwKWNRPn+mzZVFQPAC+kogQ84OJM6STgT2A/TrWzTSTbG6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyepRt8/NWO48URUnmYoaZzZGhkJYXyL6HOR8Ht9x9T/1HQkKcn
	TRu4h3FbvuyQVH3RvXu9hyWw5/xgp1IT/hXyNWHuwe9t0Ia/JKp/+GsFH4vR4g0=
X-Gm-Gg: ASbGncuh1b93A7d2P+6LvzPN1K9m8bF9vQlNNkyVpCrVF+sVcNq70v613hhIOWi7OYU
	NkLXD++T6zNm95F/+Z4O7ks8Kxh86uft5XD6sr/cnUFxcokDBKVhDaxiRQ44YcNsXzfESMwD2EU
	LpC9QgBtrhVRMCFldH8xy4jqY3kBLkT6Rq8YCfLBp/F6dujMmUHu/lig4F016MYLQYcUqIobQOi
	DJwTce734PEICbshiTDzrS6DazUZkzmyDwQIS1EDD7K30G27Fij/Tcty5QhOgtZTktMkW8b6Y0f
	4T77zgznYvFfgmnjzDSMx9rTKyLUur8kJKAKQf41uMYb
X-Google-Smtp-Source: AGHT+IHO0adHTKDFbdiZLdbwVjzffyYfi7nVPL6wN+0ieHxoGwNOezFQMlR0NxHpJZQhWhI8f44U4w==
X-Received: by 2002:a05:6a21:9786:b0:1f5:8506:5039 with SMTP id adf61e73a8af0-1f585065599mr1040552637.28.1741582737079;
        Sun, 09 Mar 2025 21:58:57 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 06/16] exec/cpu-all.h: we can now remove ld/st macros
Date: Sun,  9 Mar 2025 21:58:32 -0700
Message-Id: <20250310045842.2650784-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Functions declared in bswap.h will be used instead.

At this point, we finished to extract memory API from cpu-all.h, and it
can be called from any common or target dependent code.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 1c2e18f492b..625b4c51f3c 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -38,31 +38,6 @@
 #define BSWAP_NEEDED
 #endif
 
-/* Target-endianness CPU memory access functions. These fit into the
- * {ld,st}{type}{sign}{size}{endian}_p naming scheme described in bswap.h.
- */
-#if TARGET_BIG_ENDIAN
-#define lduw_p(p) lduw_be_p(p)
-#define ldsw_p(p) ldsw_be_p(p)
-#define ldl_p(p) ldl_be_p(p)
-#define ldq_p(p) ldq_be_p(p)
-#define stw_p(p, v) stw_be_p(p, v)
-#define stl_p(p, v) stl_be_p(p, v)
-#define stq_p(p, v) stq_be_p(p, v)
-#define ldn_p(p, sz) ldn_be_p(p, sz)
-#define stn_p(p, sz, v) stn_be_p(p, sz, v)
-#else
-#define lduw_p(p) lduw_le_p(p)
-#define ldsw_p(p) ldsw_le_p(p)
-#define ldl_p(p) ldl_le_p(p)
-#define ldq_p(p) ldq_le_p(p)
-#define stw_p(p, v) stw_le_p(p, v)
-#define stl_p(p, v) stl_le_p(p, v)
-#define stq_p(p, v) stq_le_p(p, v)
-#define ldn_p(p, sz) ldn_le_p(p, sz)
-#define stn_p(p, sz, v) stn_le_p(p, sz, v)
-#endif
-
 /* MMU memory access macros */
 
 #if !defined(CONFIG_USER_ONLY)
-- 
2.39.5


