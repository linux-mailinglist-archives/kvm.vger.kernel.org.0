Return-Path: <kvm+bounces-59769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E835BCD502
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 15:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B69824204D9
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 13:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2482F363E;
	Fri, 10 Oct 2025 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f3geals5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE302F0C63
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760103817; cv=none; b=CqM6ughiNJgGrPGV0feJnnDM17MXOfZS2jFp3URYNdHhC9Yu2mLAj2VHPHji/Z0Twi5B6o0o191K4z670Gco1F3z0JUdnDkPOLcvyAjHh3y6/gVQ20DPqCxwSumd3neB7Nqit3L24TEDDNLfZcaLb32g9zFQUmnyztMlp0dqivg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760103817; c=relaxed/simple;
	bh=/vTXWWC2JPAD4n8xd5pahjfQN2Zb2gTQGyEYebePI6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DvvLt9ncNx0/Ksdu+0Xrj6Od1Zm/dztbOc0y6/pH4GEltce3pI7xzzJUFcS7FRx9XKE9msTiHYZsAEEEsDZKyJIC9DD9bsJgezkcJ6HVFP1snuRM3kMzSZE1EXTxkBPXnh28utj3O4/+jvPFFNlYcdlFZpiq2K+E/ZHNI1j5HuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f3geals5; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so14427345e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 06:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760103814; x=1760708614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sslmAmFx5Cxrr/elCIaZt4ybkrnljBL49HYxD0V3YF0=;
        b=f3geals5eD0BO/0psq/sQeKU4yunPAMbohXJpcM8BSYzBhaTIJApMgF6qYfwjTadP0
         PD/7MyTcw07qn1Vz3WClCgOiGRWzX5OwR6aUphdYGzW8saZP5kUZhpKzP3Rwq0bVO9Ga
         6f1AJ2UNx12TAGZkV6dutVEn03U/rp6NmkM5RJvZ1edcvSm0y24QjzALTXeoqCsC0vwo
         F+xIsanFXgQ1zvPSjqciR6o7JCz1loD7+rOOFapPHlQvpe1zguCVhIP/bYCsw8r3PmbX
         qW60uKIiLMud4AcYju1IR1+H+lOkr26d2dyu4fPYwEpeAaCyIv9cwP+V6RpwMBGla1e7
         0lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760103814; x=1760708614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sslmAmFx5Cxrr/elCIaZt4ybkrnljBL49HYxD0V3YF0=;
        b=SY6YpZzFFfVSDwhoMCrZCgIw64a9OXcYFkWVQ7igbeuD396gbQZ7JLbK/0TM8ND1mk
         4wkbMEqlB70+EdlfMVakgNWz2HsQ/MSLE6gTR+Ha4MYRQ47i7zD5V7S8PqsUovt/S6al
         Q5Hycl2eZkCfJungnlh7OnG46LKuoSlspZSW9iEBbfRLKikv+2vcm3ztxEI68CE46XtV
         avpqgUgHUJHdGB5gIefYMb2u5GtkvuyRk+msrzvGWbXnts2o7vjXxgk6/0y0cLuIAxtY
         awpY+01NDLp/JBZmBcwNByWjqO31vw5MJElhO9ySGeCkjCtzrj5I77Vyw7leRw8+8zoh
         d5fQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEGt7vObul4X0qmaj9x83YhYgHO8Y2wKQkaOuNO6g88T7gNh8HspPUdtLN2OD2tedbv7o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgN5qxk5sUZ/4Gws/lJ+mwMYpMf96RwLwM8ng26pxmbVOCdLtO
	e/6Sqyo/MK58KyuXt/4z7hJQNcDNZGGk33k+L9+KgY26gfrjk1PCd4wwwJPtbBOSbX0=
X-Gm-Gg: ASbGncu/IlfD3FgzJdHplRAMAwd/86QPdJqPmlD6GvkNHZcc749NuEc8Dd8aSuCfifY
	YgG3T9J2OMM1AcR91zGgxrU6US785rFAq0JRcnoIg/qN03ZRISpyPDJxXtXfFq8F3nLBhs9vpzH
	LbiDzODMJ0BcHNHinjmwfDO81ydUvBlev6sJFupbr+b9br21KqtK/d5U+tRYtrEeo8oqRNYI61+
	IFbGyOIa2u1E+EDIjOKNpf+ifJwY3uGtJe1AFwqZw/rwnQmzi/U2EnH3WTju0uVPvCaV5ibO+iA
	UMFgq8tphxFuE80lfGp8k0pNbFN2QUuHo1edzZyeElpPRektFvxmMpmML9yEktMtDbJHeVfWuDx
	TEyQH01WyFiWijYpPXTDXOiKiYvqRA5ioGNinyHBRqg1VtX/E1luxBaGACXDZWEMCWxFSij01Qk
	NlJO2x9Q22QW9YDRi4bkU=
X-Google-Smtp-Source: AGHT+IEq7PwzNWupra1NG1OBtrWiBM/xZ8ZbE2ssL1sNC/gPpkHqvpUEmnX8rktwHeIqbswn441T9g==
X-Received: by 2002:a05:600c:a341:b0:46e:39da:1195 with SMTP id 5b1f17b1804b1-46fa9a8b3a9mr84537105e9.3.1760103813909;
        Fri, 10 Oct 2025 06:43:33 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cd658sm62396535e9.1.2025.10.10.06.43.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 10 Oct 2025 06:43:32 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH 12/16] target/ppc: Replace HOST_BIG_ENDIAN #ifdef with runtime if() check
Date: Fri, 10 Oct 2025 15:42:21 +0200
Message-ID: <20251010134226.72221-13-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010134226.72221-1-philmd@linaro.org>
References: <20251010134226.72221-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace compile-time #ifdef with a runtime check to ensure all code
paths are built and tested. This reduces build-time configuration
complexity and improves maintainability.

No functional change intended.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/arch_dump.c              |  9 ++-------
 target/ppc/int_helper.c             | 28 ++++++++++++++--------------
 target/ppc/kvm.c                    | 25 +++++++++----------------
 target/ppc/translate/vmx-impl.c.inc | 14 +++++++-------
 target/ppc/translate/vsx-impl.c.inc |  6 +++---
 tcg/ppc/tcg-target.c.inc            | 24 ++++++++++++------------
 6 files changed, 47 insertions(+), 59 deletions(-)

diff --git a/target/ppc/arch_dump.c b/target/ppc/arch_dump.c
index 80ac6c3e320..5cb8dbe9a6a 100644
--- a/target/ppc/arch_dump.c
+++ b/target/ppc/arch_dump.c
@@ -158,21 +158,16 @@ static void ppc_write_elf_vmxregset(NoteFuncArg *arg, PowerPCCPU *cpu, int id)
     struct PPCElfVmxregset *vmxregset;
     Note *note = &arg->note;
     DumpState *s = arg->state;
+    const int host_data_order = HOST_BIG_ENDIAN ? ELFDATA2MSB : ELFDATA2LSB;
+    const bool needs_byteswap = s->dump_info.d_endian == host_data_order;
 
     note->hdr.n_type = cpu_to_dump32(s, NT_PPC_VMX);
     vmxregset = &note->contents.vmxregset;
     memset(vmxregset, 0, sizeof(*vmxregset));
 
     for (i = 0; i < 32; i++) {
-        bool needs_byteswap;
         ppc_avr_t *avr = cpu_avr_ptr(&cpu->env, i);
 
-#if HOST_BIG_ENDIAN
-        needs_byteswap = s->dump_info.d_endian == ELFDATA2LSB;
-#else
-        needs_byteswap = s->dump_info.d_endian == ELFDATA2MSB;
-#endif
-
         if (needs_byteswap) {
             vmxregset->avr[i].u64[0] = bswap64(avr->u64[1]);
             vmxregset->avr[i].u64[1] = bswap64(avr->u64[0]);
diff --git a/target/ppc/int_helper.c b/target/ppc/int_helper.c
index ef4b2e75d60..0c6f5b2e519 100644
--- a/target/ppc/int_helper.c
+++ b/target/ppc/int_helper.c
@@ -1678,13 +1678,13 @@ void helper_vslo(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 {
     int sh = (b->VsrB(0xf) >> 3) & 0xf;
 
-#if HOST_BIG_ENDIAN
-    memmove(&r->u8[0], &a->u8[sh], 16 - sh);
-    memset(&r->u8[16 - sh], 0, sh);
-#else
-    memmove(&r->u8[sh], &a->u8[0], 16 - sh);
-    memset(&r->u8[0], 0, sh);
-#endif
+    if (HOST_BIG_ENDIAN) {
+        memmove(&r->u8[0], &a->u8[sh], 16 - sh);
+        memset(&r->u8[16 - sh], 0, sh);
+    } else {
+        memmove(&r->u8[sh], &a->u8[0], 16 - sh);
+        memset(&r->u8[0], 0, sh);
+    }
 }
 
 #if HOST_BIG_ENDIAN
@@ -1898,13 +1898,13 @@ void helper_vsro(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 {
     int sh = (b->VsrB(0xf) >> 3) & 0xf;
 
-#if HOST_BIG_ENDIAN
-    memmove(&r->u8[sh], &a->u8[0], 16 - sh);
-    memset(&r->u8[0], 0, sh);
-#else
-    memmove(&r->u8[0], &a->u8[sh], 16 - sh);
-    memset(&r->u8[16 - sh], 0, sh);
-#endif
+    if (HOST_BIG_ENDIAN) {
+        memmove(&r->u8[sh], &a->u8[0], 16 - sh);
+        memset(&r->u8[0], 0, sh);
+    } else {
+        memmove(&r->u8[0], &a->u8[sh], 16 - sh);
+        memset(&r->u8[16 - sh], 0, sh);
+    }
 }
 
 void helper_vsumsws(CPUPPCState *env, ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 2521ff65c6c..c00d29ce2c8 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -651,13 +651,13 @@ static int kvm_put_fp(CPUState *cs)
             uint64_t *fpr = cpu_fpr_ptr(env, i);
             uint64_t *vsrl = cpu_vsrl_ptr(env, i);
 
-#if HOST_BIG_ENDIAN
-            vsr[0] = float64_val(*fpr);
-            vsr[1] = *vsrl;
-#else
-            vsr[0] = *vsrl;
-            vsr[1] = float64_val(*fpr);
-#endif
+            if (HOST_BIG_ENDIAN) {
+                vsr[0] = float64_val(*fpr);
+                vsr[1] = *vsrl;
+            } else {
+                vsr[0] = *vsrl;
+                vsr[1] = float64_val(*fpr);
+            }
             reg.addr = (uintptr_t) &vsr;
             reg.id = vsx ? KVM_REG_PPC_VSR(i) : KVM_REG_PPC_FPR(i);
 
@@ -728,17 +728,10 @@ static int kvm_get_fp(CPUState *cs)
                                         strerror(errno));
                 return ret;
             } else {
-#if HOST_BIG_ENDIAN
-                *fpr = vsr[0];
+                *fpr = vsr[!HOST_BIG_ENDIAN];
                 if (vsx) {
-                    *vsrl = vsr[1];
+                    *vsrl = vsr[HOST_BIG_ENDIAN];
                 }
-#else
-                *fpr = vsr[1];
-                if (vsx) {
-                    *vsrl = vsr[0];
-                }
-#endif
             }
         }
     }
diff --git a/target/ppc/translate/vmx-impl.c.inc b/target/ppc/translate/vmx-impl.c.inc
index 92d6e8c6032..ca9cf1823d4 100644
--- a/target/ppc/translate/vmx-impl.c.inc
+++ b/target/ppc/translate/vmx-impl.c.inc
@@ -134,9 +134,9 @@ static void gen_mtvscr(DisasContext *ctx)
 
     val = tcg_temp_new_i32();
     bofs = avr_full_offset(rB(ctx->opcode));
-#if HOST_BIG_ENDIAN
-    bofs += 3 * 4;
-#endif
+    if (HOST_BIG_ENDIAN) {
+        bofs += 3 * 4;
+    }
 
     tcg_gen_ld_i32(val, tcg_env, bofs);
     gen_helper_mtvscr(tcg_env, val);
@@ -1528,10 +1528,10 @@ static void gen_vsplt(DisasContext *ctx, int vece)
 
     /* Experimental testing shows that hardware masks the immediate.  */
     bofs += (uimm << vece) & 15;
-#if !HOST_BIG_ENDIAN
-    bofs ^= 15;
-    bofs &= ~((1 << vece) - 1);
-#endif
+    if (!HOST_BIG_ENDIAN) {
+        bofs ^= 15;
+        bofs &= ~((1 << vece) - 1);
+    }
 
     tcg_gen_gvec_dup_mem(vece, dofs, bofs, 16, 16);
 }
diff --git a/target/ppc/translate/vsx-impl.c.inc b/target/ppc/translate/vsx-impl.c.inc
index 00ad57c6282..8e5c75961f4 100644
--- a/target/ppc/translate/vsx-impl.c.inc
+++ b/target/ppc/translate/vsx-impl.c.inc
@@ -1642,9 +1642,9 @@ static bool trans_XXSPLTW(DisasContext *ctx, arg_XX2_uim *a)
     tofs = vsr_full_offset(a->xt);
     bofs = vsr_full_offset(a->xb);
     bofs += a->uim << MO_32;
-#if !HOST_BIG_ENDIAN
-    bofs ^= 8 | 4;
-#endif
+    if (!HOST_BIG_ENDIAN) {
+        bofs ^= 8 | 4;
+    }
 
     tcg_gen_gvec_dup_mem(MO_32, tofs, bofs, 16, 16);
     return true;
diff --git a/tcg/ppc/tcg-target.c.inc b/tcg/ppc/tcg-target.c.inc
index b8b23d44d5e..61aa77f5454 100644
--- a/tcg/ppc/tcg-target.c.inc
+++ b/tcg/ppc/tcg-target.c.inc
@@ -3951,9 +3951,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
             tcg_out_mem_long(s, 0, LVEBX, out, base, offset);
         }
         elt = extract32(offset, 0, 4);
-#if !HOST_BIG_ENDIAN
-        elt ^= 15;
-#endif
+        if (!HOST_BIG_ENDIAN) {
+            elt ^= 15;
+        }
         tcg_out32(s, VSPLTB | VRT(out) | VRB(out) | (elt << 16));
         break;
     case MO_16:
@@ -3964,9 +3964,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
             tcg_out_mem_long(s, 0, LVEHX, out, base, offset);
         }
         elt = extract32(offset, 1, 3);
-#if !HOST_BIG_ENDIAN
-        elt ^= 7;
-#endif
+        if (!HOST_BIG_ENDIAN) {
+            elt ^= 7;
+        }
         tcg_out32(s, VSPLTH | VRT(out) | VRB(out) | (elt << 16));
         break;
     case MO_32:
@@ -3977,9 +3977,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
         tcg_debug_assert((offset & 3) == 0);
         tcg_out_mem_long(s, 0, LVEWX, out, base, offset);
         elt = extract32(offset, 2, 2);
-#if !HOST_BIG_ENDIAN
-        elt ^= 3;
-#endif
+        if (!HOST_BIG_ENDIAN) {
+            elt ^= 3;
+        }
         tcg_out32(s, VSPLTW | VRT(out) | VRB(out) | (elt << 16));
         break;
     case MO_64:
@@ -3991,9 +3991,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
         tcg_out_mem_long(s, 0, LVX, out, base, offset & -16);
         tcg_out_vsldoi(s, TCG_VEC_TMP1, out, out, 8);
         elt = extract32(offset, 3, 1);
-#if !HOST_BIG_ENDIAN
-        elt = !elt;
-#endif
+        if (!HOST_BIG_ENDIAN) {
+            elt = !elt;
+        }
         if (elt) {
             tcg_out_vsldoi(s, out, out, TCG_VEC_TMP1, 8);
         } else {
-- 
2.51.0


