Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04EA7CF0A4
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjJSHGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 03:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjJSHGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 03:06:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9CC11D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697699161; x=1729235161;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2vYYdaSNvFufGJ5UaXHzxeWsXskL7X0l8axOdiEA3k8=;
  b=L+1NXyPu+seYOa+c0U2HzuHjBlG9O2Hzx8lc8Py1QlPC2UbailI/oKAR
   IJ8eGY1jKqgmZm0054Tox8qaNqGiEZzqdtrxcYCc6k+CXy4RB6N/0UeQn
   Dl8OjDmAPilpOkhjCDcN3RixUlixkWTJXDLWPJoqol/QkiDGjF4mn9wMD
   I5DBm13D7v6YLHTgk8KxYYhveIwbkOo6gqMCvGOjCsWjwIjgL7xl2fGB4
   GiOe3LCoMS1jxg3XP5gtqYxYi1jPCg9IqNoZ+S65wIj48/0Cq2KMDOb4H
   OdPnrKPF4LVXpNs9CSZxtuDRtxxraV1fah/ecBJ2CrNVvPituDPSjIRhZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="7741500"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="7741500"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 00:06:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="827219863"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="827219863"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga004.fm.intel.com with ESMTP; 19 Oct 2023 00:05:58 -0700
Date:   Thu, 19 Oct 2023 15:17:35 +0800
From:   Zhao Liu <zhao1.liu@intel.com>
To:     Emmanouil Pitsidianakis <manos.pitsidianakis@linaro.org>
Cc:     qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v3 25/78] target/i386: add fallthrough pseudo-keyword
Message-ID: <ZTDYD5yadW7Fw+R6@liuzhao-OptiPlex-7080>
References: <cover.1697186560.git.manos.pitsidianakis@linaro.org>
 <76c17deab18b857ea01ed4b7f06a2d56d1977ff6.1697186560.git.manos.pitsidianakis@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76c17deab18b857ea01ed4b7f06a2d56d1977ff6.1697186560.git.manos.pitsidianakis@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 11:45:53AM +0300, Emmanouil Pitsidianakis wrote:
> Date: Fri, 13 Oct 2023 11:45:53 +0300
> From: Emmanouil Pitsidianakis <manos.pitsidianakis@linaro.org>
> Subject: [RFC PATCH v3 25/78] target/i386: add fallthrough pseudo-keyword
> X-Mailer: git-send-email 2.39.2
> 
> In preparation of raising -Wimplicit-fallthrough to 5, replace all
> fall-through comments with the fallthrough attribute pseudo-keyword.
> 
> Signed-off-by: Emmanouil Pitsidianakis <manos.pitsidianakis@linaro.org>

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> ---
>  target/i386/cpu.c                | 2 +-
>  target/i386/hvf/x86_decode.c     | 1 +
>  target/i386/kvm/kvm.c            | 4 ++--
>  target/i386/tcg/decode-new.c.inc | 6 +++---
>  target/i386/tcg/emit.c.inc       | 2 +-
>  target/i386/tcg/translate.c      | 8 +++-----
>  6 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index cec5d2b7b6..f73784edca 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6133,7 +6133,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                                          eax, ebx, ecx, edx);
>                      break;
>                  }
> -                /* fall through */
> +                fallthrough;
>              default: /* end of info */
>                  *eax = *ebx = *ecx = *edx = 0;
>                  break;
> diff --git a/target/i386/hvf/x86_decode.c b/target/i386/hvf/x86_decode.c
> index 3728d7705e..7c2e3dab8d 100644
> --- a/target/i386/hvf/x86_decode.c
> +++ b/target/i386/hvf/x86_decode.c
> @@ -1886,6 +1886,7 @@ static void decode_prefix(CPUX86State *env, struct x86_decode *decode)
>                  break;
>              }
>              /* fall through when not in long mode */
> +            fallthrough;
>          default:
>              decode->len--;
>              return;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f6c7f7e268..d283d56aa9 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -553,7 +553,7 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
>                  value |= (uint64_t)VMX_SECONDARY_EXEC_RDTSCP << 32;
>              }
>          }
> -        /* fall through */
> +        fallthrough;
>      case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>      case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
>      case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> @@ -1962,7 +1962,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>              if (env->nr_dies < 2) {
>                  break;
>              }
> -            /* fallthrough */
> +            fallthrough;
>          case 4:
>          case 0xb:
>          case 0xd:
> diff --git a/target/i386/tcg/decode-new.c.inc b/target/i386/tcg/decode-new.c.inc
> index 7d76f15275..0e663e9124 100644
> --- a/target/i386/tcg/decode-new.c.inc
> +++ b/target/i386/tcg/decode-new.c.inc
> @@ -1108,7 +1108,7 @@ static bool decode_op_size(DisasContext *s, X86OpEntry *e, X86OpSize size, MemOp
>              *ot = MO_64;
>              return true;
>          }
> -        /* fall through */
> +        fallthrough;
>      case X86_SIZE_ps: /* SSE/AVX packed single precision */
>      case X86_SIZE_pd: /* SSE/AVX packed double precision */
>          *ot = s->vex_l ? MO_256 : MO_128;
> @@ -1220,7 +1220,7 @@ static bool decode_op(DisasContext *s, CPUX86State *env, X86DecodedInsn *decode,
>  
>      case X86_TYPE_WM:  /* modrm byte selects an XMM/YMM memory operand */
>          op->unit = X86_OP_SSE;
> -        /* fall through */
> +        fallthrough;
>      case X86_TYPE_M:  /* modrm byte selects a memory operand */
>          modrm = get_modrm(s, env);
>          if ((modrm >> 6) == 3) {
> @@ -1538,7 +1538,7 @@ static bool validate_vex(DisasContext *s, X86DecodedInsn *decode)
>              (decode->op[2].n == decode->mem.index || decode->op[2].n == decode->op[1].n)) {
>              goto illegal;
>          }
> -        /* fall through */
> +        fallthrough;
>      case 6:
>      case 11:
>          if (!(s->prefix & PREFIX_VEX)) {
> diff --git a/target/i386/tcg/emit.c.inc b/target/i386/tcg/emit.c.inc
> index 88793ba988..0e0a2efbf9 100644
> --- a/target/i386/tcg/emit.c.inc
> +++ b/target/i386/tcg/emit.c.inc
> @@ -209,7 +209,7 @@ static bool sse_needs_alignment(DisasContext *s, X86DecodedInsn *decode, MemOp o
>              /* MOST legacy SSE instructions require aligned memory operands, but not all.  */
>              return false;
>          }
> -        /* fall through */
> +        fallthrough;
>      case 1:
>          return ot >= MO_128;
>  
> diff --git a/target/i386/tcg/translate.c b/target/i386/tcg/translate.c
> index e42e3dd653..77a8fcc5e1 100644
> --- a/target/i386/tcg/translate.c
> +++ b/target/i386/tcg/translate.c
> @@ -1004,7 +1004,7 @@ static CCPrepare gen_prepare_eflags_s(DisasContext *s, TCGv reg)
>      switch (s->cc_op) {
>      case CC_OP_DYNAMIC:
>          gen_compute_eflags(s);
> -        /* FALLTHRU */
> +        fallthrough;
>      case CC_OP_EFLAGS:
>      case CC_OP_ADCX:
>      case CC_OP_ADOX:
> @@ -1047,7 +1047,7 @@ static CCPrepare gen_prepare_eflags_z(DisasContext *s, TCGv reg)
>      switch (s->cc_op) {
>      case CC_OP_DYNAMIC:
>          gen_compute_eflags(s);
> -        /* FALLTHRU */
> +        fallthrough;
>      case CC_OP_EFLAGS:
>      case CC_OP_ADCX:
>      case CC_OP_ADOX:
> @@ -3298,7 +3298,6 @@ static bool disas_insn(DisasContext *s, CPUState *cpu)
>      case 0x82:
>          if (CODE64(s))
>              goto illegal_op;
> -        /* fall through */
>          fallthrough;
>      case 0x80: /* GRP1 */
>      case 0x81:
> @@ -6733,7 +6732,7 @@ static bool disas_insn(DisasContext *s, CPUState *cpu)
>                  }
>                  break;
>              }
> -            /* fallthru */
> +            fallthrough;
>          case 0xf9 ... 0xff: /* sfence */
>              if (!(s->cpuid_features & CPUID_SSE)
>                  || (prefixes & PREFIX_LOCK)) {
> @@ -7047,7 +7046,6 @@ static void i386_tr_tb_stop(DisasContextBase *dcbase, CPUState *cpu)
>      case DISAS_EOB_NEXT:
>          gen_update_cc_op(dc);
>          gen_update_eip_cur(dc);
> -        /* fall through */
>          fallthrough;
>      case DISAS_EOB_ONLY:
>          gen_eob(dc);
> -- 
> 2.39.2
> 
