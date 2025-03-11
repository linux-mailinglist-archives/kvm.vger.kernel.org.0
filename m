Return-Path: <kvm+bounces-40798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFCBA5D02E
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A0953B9F93
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DED264FB5;
	Tue, 11 Mar 2025 19:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="juyWFU4t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46412222D6
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723105; cv=none; b=UQbX2F8LueZUSA5Z51qqWmaOxXvc9gve2jQAyNI/YizmbDQkYtxr2RQoUrSfm+kocCzP9us9lFWCy/9auEJ6rinVmG9cmihx1Mtl1I3NB14SJU8qCVzSGgJfztXtxOhK2Eb4lyWbxwEDz+6jyADaF8K001vLdMt+JLuVzdk9ixQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723105; c=relaxed/simple;
	bh=2EiUgDnSIr2U0DMUcevHrrz6cNF3hvjf3O5YcIT7Nyc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m8UNudR1Eji14Au//FrTeuUWrf4b24tPhL06D304znBq8fWGy/9ivpTRtXtEIzYryGW6NrVtZk+TE9oZkDXTcQRVBb+LzjSk3GvNKGUZF2iFoK7Ug4XbQLorK1l4NZ5n0jo8tQk9qLG2J7DzOxgB5QStPH5D6z61h6D4Pr0uKGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=juyWFU4t; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224191d92e4so104659625ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723103; x=1742327903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9PU2mUUZXceFgFF8NURkIZqXSTxuLUTW3yG3F37dHQ=;
        b=juyWFU4tuDzqEq9xi3IclMGCP7yIpEwgS2cY9ruUy/Ou3Qd5KtZ+5BxdsCT9MOcyJG
         biv3P0E7fQnBWiatRKfO7ec7q51EsXJpydUaBx+bFReeU+N0BZFCmdRX2Vp+vLlSBsJf
         YR3X7fiz3WDw2j1oKrReg8gMKxNM9NXIiQO/2XnL7E0Yn06PTKU7if5JUY0Qm8viTgMy
         4bDp4lBeCP2f4dcsF3ao2vAPAPqhLuaTy3vMBENT0+1PS7F6umlmV53QMPi4LrdR5URV
         0TTcqDlMP8urudTxPS7ixZIW2/+rq93bISszVw3KWv+L3RY/1OfFFXELp6aiQ94CV/9f
         4lfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723103; x=1742327903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9PU2mUUZXceFgFF8NURkIZqXSTxuLUTW3yG3F37dHQ=;
        b=WY8MpPB0KehgqhJmEn3Rl0QfhpnYxpWhFrbqGMEKe7PSjAEYrdQPSVoG6wx0xc/LTS
         txuCIJB19BdKSB1q0FbZkyMbC8PZ+xa0zNubiQ+iK1ev12GvIIe7TyTD+AnBAa4HGoCn
         Y7cCfNRstw1zGmYNIDVX16JnglnaF73tFW9UJ2zMr6TE6GqhpuPEhZzoPF18tKNy4dmh
         mIPpMXxtI+lNxDRxxug7ulfyeNlGSUV/TJ2FE7uzqCZ7Pn7Rkh96BUtjn1K5uGdmuAeE
         732nXGkGO+dfQT2bGnxB4NZAJHVp6zTsoB5CzQTYTvQFQGGlEyKTnAUNErgbM45fl3F6
         nFyw==
X-Forwarded-Encrypted: i=1; AJvYcCUbnJ+Wy85tzltATz1nBpvOXIQICgL81Dhz4PHkmyGjQ1fqDOb+cjDZcHmURE3X9MtM18Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVUYtc9FaWTkWAOeZB9529Y253fr5CgDQFzD1Ft7B833OI0Vr2
	Jm/n4YrG55bOWuaFBZUGuC3wQ9tSAnPMuF7d/29cjdjrD4ou0pxmUBpLM7g1t5A=
X-Gm-Gg: ASbGncurlvied++bpTfkRhQcS7xB7aQmh8BYJaWLfPnE6n/PvDlJrvkBVPOX7BeKnPi
	knchGsHW98G8yEcAj2uXGBbmQ06UNmbIS514dtnp7UpqoXwP/fIY8oqqUrVKndIXqBwcFb8hlCY
	RnvCSqkl7ncQRAvz/g4SWZHRJusP/eHivdox+FX6fq2P+gsWBfaWSKWCdZ662PtfUK+dLY1R+/T
	awNQgFhVPt8LZZV9d4G6TSYompafAfLK0Md40Q578dsd4KT9yWj7WyXQ5Vi2sDZjihHntfzlRyq
	0apOmXBIxDfBaOytE7ZcaLHaYBjvnexlN8iDoFgDzQRLr7SCOF4aJ6Q=
X-Google-Smtp-Source: AGHT+IGg+aQTZ2xq9SQi3eRnsIeXjPhQ74pTHWyL4E+moWnFDewPnn2zGKzm8djm9QcS5fi3hNfHgA==
X-Received: by 2002:a05:6a00:c8f:b0:736:34ff:bfc with SMTP id d2e1a72fcca58-736aaab7d8fmr24949384b3a.19.1741723103280;
        Tue, 11 Mar 2025 12:58:23 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 11/17] exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
Date: Tue, 11 Mar 2025 12:57:57 -0700
Message-Id: <20250311195803.4115788-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/ram_addr.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 7c011fadd11..098fccb5835 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -342,7 +342,9 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
         }
     }
 
-    xen_hvm_modified_memory(start, length);
+    if (xen_enabled()) {
+        xen_hvm_modified_memory(start, length);
+    }
 }
 
 #if !defined(_WIN32)
@@ -418,7 +420,9 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
             }
         }
 
-        xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
+        if (xen_enabled()) {
+            xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
+        }
     } else {
         uint8_t clients = tcg_enabled() ? DIRTY_CLIENTS_ALL : DIRTY_CLIENTS_NOCODE;
 
-- 
2.39.5


