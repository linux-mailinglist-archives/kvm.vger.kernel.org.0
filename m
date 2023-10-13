Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0287C8096
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 10:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjJMIsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 04:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjJMIsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 04:48:00 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF70CE
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 01:47:58 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4054496bde3so19177025e9.1
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 01:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697186876; x=1697791676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+COywZA7y0+Apw7N1rtPw8VsMqViKoTFFZDNe6TkQ8=;
        b=AiHw/S3CwDrJhYjqn/ncuTFdTFbzQxJUUP6WpbDA+LJKrTaGZHRtIT2WDISc3Od0ct
         1d2W16IGuuw2FCpfOizG+xZRxicFbbAXSnYBJiFHCZT5Stdcx6qCI7gL/Y7X/6viywxH
         8Wm7ntUYlK2zaZ30yOoGy6gltSW6hN23lyzTURNP/HKzHwI2uSZe7gBpqjR8n/gmy529
         mcA6tJba40RGcZWQ9Unk4CrpMVSToO9m2Q75J+DEYGULYAXXjLLlqBfP4/ONn1VybpSP
         leQdaVax9k8XUiaVSEFqAUDfufj8i1pCVfyGT/1N1HfUhsLdgBrW1WZrySL9ajHxTWI8
         dfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697186876; x=1697791676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+COywZA7y0+Apw7N1rtPw8VsMqViKoTFFZDNe6TkQ8=;
        b=OnTsYAAJdeCaTJUdy8A0DAWoE8ypV+7b114bS8laNlMxw63ZuTRZahcczi7r311f6Q
         EyJw4OLBRVowTEzbSo27KOo24rwDQbvD5Oz060m1KqWsAFNRQ01wzYi/ioQye0cuaxJb
         W7HmxFhFbcI3iUMmUx3V/F27ZvF6cGTGo14O74pJjHKixzyyjIfgnO3N7L/UVpwXyl9y
         onrh79Pszze6kxhPnRSrOrRe4AFaWQt0txNg8FbhnwJJ3iy3DF0FhOvi0O+WogkkT0QH
         zCZuWECFL9keiN0tQoqA9RgX1kIc2V2N42/TaLLRu3LbEd+hdjUkq7zwVLbFWInJYGQL
         cNaA==
X-Gm-Message-State: AOJu0Ywd5KAQSJmb2VOKVC3Q8/FKWVBXtab70ZPqUVzK2xLaREl2nhg2
        8BiyadwH0DfrPXA5A6ztmYONVm0+5eEun/4caFQ=
X-Google-Smtp-Source: AGHT+IGHzEiITjsNBBv2hlXYoWDibsoEESnLabiapiM99BVzEyACgQD6Tcf/PGvLf2OdwpLdmmxbow==
X-Received: by 2002:adf:e383:0:b0:320:1c4:e213 with SMTP id e3-20020adfe383000000b0032001c4e213mr22789101wrm.1.1697186876712;
        Fri, 13 Oct 2023 01:47:56 -0700 (PDT)
Received: from localhost.localdomain (adsl-170.109.242.226.tellas.gr. [109.242.226.170])
        by smtp.gmail.com with ESMTPSA id v10-20020a5d678a000000b0032d9f32b96csm569185wru.62.2023.10.13.01.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 01:47:56 -0700 (PDT)
From:   Emmanouil Pitsidianakis <manos.pitsidianakis@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Emmanouil Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [RFC PATCH v3 25/78] target/i386: add fallthrough pseudo-keyword
Date:   Fri, 13 Oct 2023 11:45:53 +0300
Message-Id: <76c17deab18b857ea01ed4b7f06a2d56d1977ff6.1697186560.git.manos.pitsidianakis@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1697186560.git.manos.pitsidianakis@linaro.org>
References: <cover.1697186560.git.manos.pitsidianakis@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation of raising -Wimplicit-fallthrough to 5, replace all
fall-through comments with the fallthrough attribute pseudo-keyword.

Signed-off-by: Emmanouil Pitsidianakis <manos.pitsidianakis@linaro.org>
---
 target/i386/cpu.c                | 2 +-
 target/i386/hvf/x86_decode.c     | 1 +
 target/i386/kvm/kvm.c            | 4 ++--
 target/i386/tcg/decode-new.c.inc | 6 +++---
 target/i386/tcg/emit.c.inc       | 2 +-
 target/i386/tcg/translate.c      | 8 +++-----
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cec5d2b7b6..f73784edca 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6133,7 +6133,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                                         eax, ebx, ecx, edx);
                     break;
                 }
-                /* fall through */
+                fallthrough;
             default: /* end of info */
                 *eax = *ebx = *ecx = *edx = 0;
                 break;
diff --git a/target/i386/hvf/x86_decode.c b/target/i386/hvf/x86_decode.c
index 3728d7705e..7c2e3dab8d 100644
--- a/target/i386/hvf/x86_decode.c
+++ b/target/i386/hvf/x86_decode.c
@@ -1886,6 +1886,7 @@ static void decode_prefix(CPUX86State *env, struct x86_decode *decode)
                 break;
             }
             /* fall through when not in long mode */
+            fallthrough;
         default:
             decode->len--;
             return;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f6c7f7e268..d283d56aa9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -553,7 +553,7 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
                 value |= (uint64_t)VMX_SECONDARY_EXEC_RDTSCP << 32;
             }
         }
-        /* fall through */
+        fallthrough;
     case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
     case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
     case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
@@ -1962,7 +1962,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             if (env->nr_dies < 2) {
                 break;
             }
-            /* fallthrough */
+            fallthrough;
         case 4:
         case 0xb:
         case 0xd:
diff --git a/target/i386/tcg/decode-new.c.inc b/target/i386/tcg/decode-new.c.inc
index 7d76f15275..0e663e9124 100644
--- a/target/i386/tcg/decode-new.c.inc
+++ b/target/i386/tcg/decode-new.c.inc
@@ -1108,7 +1108,7 @@ static bool decode_op_size(DisasContext *s, X86OpEntry *e, X86OpSize size, MemOp
             *ot = MO_64;
             return true;
         }
-        /* fall through */
+        fallthrough;
     case X86_SIZE_ps: /* SSE/AVX packed single precision */
     case X86_SIZE_pd: /* SSE/AVX packed double precision */
         *ot = s->vex_l ? MO_256 : MO_128;
@@ -1220,7 +1220,7 @@ static bool decode_op(DisasContext *s, CPUX86State *env, X86DecodedInsn *decode,
 
     case X86_TYPE_WM:  /* modrm byte selects an XMM/YMM memory operand */
         op->unit = X86_OP_SSE;
-        /* fall through */
+        fallthrough;
     case X86_TYPE_M:  /* modrm byte selects a memory operand */
         modrm = get_modrm(s, env);
         if ((modrm >> 6) == 3) {
@@ -1538,7 +1538,7 @@ static bool validate_vex(DisasContext *s, X86DecodedInsn *decode)
             (decode->op[2].n == decode->mem.index || decode->op[2].n == decode->op[1].n)) {
             goto illegal;
         }
-        /* fall through */
+        fallthrough;
     case 6:
     case 11:
         if (!(s->prefix & PREFIX_VEX)) {
diff --git a/target/i386/tcg/emit.c.inc b/target/i386/tcg/emit.c.inc
index 88793ba988..0e0a2efbf9 100644
--- a/target/i386/tcg/emit.c.inc
+++ b/target/i386/tcg/emit.c.inc
@@ -209,7 +209,7 @@ static bool sse_needs_alignment(DisasContext *s, X86DecodedInsn *decode, MemOp o
             /* MOST legacy SSE instructions require aligned memory operands, but not all.  */
             return false;
         }
-        /* fall through */
+        fallthrough;
     case 1:
         return ot >= MO_128;
 
diff --git a/target/i386/tcg/translate.c b/target/i386/tcg/translate.c
index e42e3dd653..77a8fcc5e1 100644
--- a/target/i386/tcg/translate.c
+++ b/target/i386/tcg/translate.c
@@ -1004,7 +1004,7 @@ static CCPrepare gen_prepare_eflags_s(DisasContext *s, TCGv reg)
     switch (s->cc_op) {
     case CC_OP_DYNAMIC:
         gen_compute_eflags(s);
-        /* FALLTHRU */
+        fallthrough;
     case CC_OP_EFLAGS:
     case CC_OP_ADCX:
     case CC_OP_ADOX:
@@ -1047,7 +1047,7 @@ static CCPrepare gen_prepare_eflags_z(DisasContext *s, TCGv reg)
     switch (s->cc_op) {
     case CC_OP_DYNAMIC:
         gen_compute_eflags(s);
-        /* FALLTHRU */
+        fallthrough;
     case CC_OP_EFLAGS:
     case CC_OP_ADCX:
     case CC_OP_ADOX:
@@ -3298,7 +3298,6 @@ static bool disas_insn(DisasContext *s, CPUState *cpu)
     case 0x82:
         if (CODE64(s))
             goto illegal_op;
-        /* fall through */
         fallthrough;
     case 0x80: /* GRP1 */
     case 0x81:
@@ -6733,7 +6732,7 @@ static bool disas_insn(DisasContext *s, CPUState *cpu)
                 }
                 break;
             }
-            /* fallthru */
+            fallthrough;
         case 0xf9 ... 0xff: /* sfence */
             if (!(s->cpuid_features & CPUID_SSE)
                 || (prefixes & PREFIX_LOCK)) {
@@ -7047,7 +7046,6 @@ static void i386_tr_tb_stop(DisasContextBase *dcbase, CPUState *cpu)
     case DISAS_EOB_NEXT:
         gen_update_cc_op(dc);
         gen_update_eip_cur(dc);
-        /* fall through */
         fallthrough;
     case DISAS_EOB_ONLY:
         gen_eob(dc);
-- 
2.39.2

