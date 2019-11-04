Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01D8EDFBB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 13:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfKDMJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 07:09:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfKDMJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 07:09:34 -0500
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03E3D2A09A0
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 12:09:33 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id l184so6037610wmf.6
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 04:09:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0BxsfdHPx/gD8VXZ690tXxGPFvfUX+kIETya6SSZjyM=;
        b=FGmAKmnmm/Lpdr4mlEs3FvVmbkUhRwFN9KsELol1apFtYbSaVUFz3MzUAQ+IKmWecK
         g5qPe4SY+Je/Mw33w0MJe7hKgC0bjcKToxl0Fa4RdRv/g5RNw6FoCiI3s2Cd9wvzuUS9
         speIu2mb/zIuOYUF7rywlymmd30KZrCGrmQtVN4rwEjISHbjwrTj7fowV4eDT3uSOQqB
         oazZIlE1QsNWsbpj25ypn5mt0BTOIqfv2xMFcbrs8hGrhVQ87at4GhB6E6ZDmFapwQe5
         ZhJdn+Yb/Q3uEbBB5T0AbqPjNg+StRInjzXnFZtq740JtErn3dfJR1L0PsRqh40Nj8Qv
         DQ9w==
X-Gm-Message-State: APjAAAWGFdeOjV9w+Hnd1s35nGTbHDcTufbFPeqQ0dGRM1Lr/MYJFrhs
        EVNDylwriJMPPaNJxnOeyzgPHfdCwcwFk6q0Qmiq7RDBF8MRvKy5iqMJ8mmJVd1kmQGuOjozwxu
        YI+yTtNUjyXhc
X-Received: by 2002:a1c:2048:: with SMTP id g69mr15074445wmg.121.1572869371264;
        Mon, 04 Nov 2019 04:09:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxawbeimXsspxht/kycE+QdrBCjD0zC/nO9okX4yKliRTleGVMkYR4QJVkZj8y2rdXiTjaeyA==
X-Received: by 2002:a1c:2048:: with SMTP id g69mr15074405wmg.121.1572869370745;
        Mon, 04 Nov 2019 04:09:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id g4sm9552350wru.75.2019.11.04.04.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 04:09:30 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 2/2] x86: realmode: initialize inregs
 with a stack
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        jmattson@google.com
Cc:     thuth@redhat.com, alexandru.elisei@arm.com
References: <20191101203353.150049-1-morbo@google.com>
 <20191101203353.150049-3-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d356414e-e2d5-68db-5e58-1ac63f56b0e4@redhat.com>
Date:   Mon, 4 Nov 2019 13:09:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191101203353.150049-3-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 21:33, Bill Wendling wrote:
> Tests may use the stack during execution. It's easy to miss allocating
> one, so automatically point %esp to the stack when initializing
> "inregs". Also remove the initialization of ".esp" in "test_movzx_movsx"
> as it doesn't appear to be required.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/realmode.c | 158 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 95 insertions(+), 63 deletions(-)
> 
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 629a221..f5967ef 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -11,6 +11,10 @@ typedef unsigned short u16;
>  typedef unsigned u32;
>  typedef unsigned long long u64;
>  
> +#ifndef NULL
> +#define NULL ((void*)0)
> +#endif
> +
>  void realmode_start(void);
>  void test_function(void);
>  
> @@ -140,8 +144,22 @@ struct insn_desc {
>      u16 len;
>  };
>  
> +struct {
> +	u32 stack[128];
> +	char top[];
> +} tmp_stack;
> +
>  static struct regs inregs, outregs;
>  
> +static inline void init_inregs(struct regs *regs)
> +{
> +	inregs = (struct regs){ 0 };
> +	if (regs)
> +		inregs = *regs;
> +	if (!inregs.esp)
> +		inregs.esp = (unsigned long)&tmp_stack.top;
> +}
> +
>  static void exec_in_big_real_mode(struct insn_desc *insn)
>  {
>  	unsigned long tmp;
> @@ -302,7 +320,8 @@ static void test_shld(void)
>  {
>  	MK_INSN(shld_test, "shld $8,%edx,%eax\n\t");
>  
> -	inregs = (struct regs){ .eax = 0xbe, .edx = 0xef000000 };
> +	init_inregs(&(struct regs){ .eax = 0xbe, .edx = 0xef000000 });
> +
>  	exec_in_big_real_mode(&insn_shld_test);
>  	report("shld", ~0, outregs.eax == 0xbeef);
>  }
> @@ -315,7 +334,7 @@ static void test_mov_imm(void)
>  	MK_INSN(mov_r8_imm_2, "mov $0x34, %al");
>  	MK_INSN(mov_r8_imm_3, "mov $0x12, %ah\n\t" "mov $0x34, %al\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_mov_r16_imm_1);
>  	report("mov 1", R_AX, outregs.eax == 1234);
> @@ -342,7 +361,7 @@ static void test_sub_imm(void)
>  	MK_INSN(sub_r8_imm_1, "mov $0x12, %ah\n\t" "sub $0x10, %ah\n\t");
>  	MK_INSN(sub_r8_imm_2, "mov $0x34, %al\n\t" "sub $0x10, %al\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_sub_r16_imm_1);
>  	report("sub 1", R_AX, outregs.eax == 1224);
> @@ -366,7 +385,7 @@ static void test_xor_imm(void)
>  	MK_INSN(xor_r8_imm_1, "mov $0x12, %ah\n\t" "xor $0x12, %ah\n\t");
>  	MK_INSN(xor_r8_imm_2, "mov $0x34, %al\n\t" "xor $0x34, %al\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_xor_r16_imm_1);
>  	report("xor 1", R_AX, outregs.eax == 0);
> @@ -392,7 +411,7 @@ static void test_cmp_imm(void)
>  	MK_INSN(cmp_test3, "mov $0x34, %al\n\t"
>  			   "cmp $0x24, %al\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	/* test cmp imm8 with AL */
>  	/* ZF: (bit 6) Zero Flag becomes 1 if an operation results
> @@ -415,7 +434,7 @@ static void test_add_imm(void)
>  	MK_INSN(add_test2, "mov $0x12, %eax \n\t"
>  			   "add $0x21, %al\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_add_test1);
>  	report("add 1", ~0, outregs.eax == 0x55555555);
> @@ -433,7 +452,7 @@ static void test_eflags_insn(void)
>  	MK_INSN(cld, "cld");
>  	MK_INSN(std, "std");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_clc);
>  	report("clc", ~0, (outregs.eflags & 1) == 0);
> @@ -484,7 +503,7 @@ static void test_io(void)
>  			  "mov $0x00000000, %eax \n\t"
>  			  "in %dx, %eax \n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_io_test1);
>  	report("pio 1", R_AX, outregs.eax == 0xff);
> @@ -513,12 +532,8 @@ extern void retf_imm(void);
>  
>  static void test_call(void)
>  {
> -	u32 esp[16];
>  	u32 addr;
>  
> -	inregs = (struct regs){ 0 };
> -	inregs.esp = (u32)&esp[ARRAY_SIZE(esp)];
> -
>  	MK_INSN(call1, "mov $test_function, %eax \n\t"
>  		       "call *%eax\n\t");
>  	MK_INSN(call_near1, "jmp 2f\n\t"
> @@ -535,6 +550,8 @@ static void test_call(void)
>  	MK_INSN(ret_imm,    "sub $10, %sp; jmp 2f; 1: retw $10; 2: callw 1b");
>  	MK_INSN(retf_imm,   "sub $10, %sp; lcallw $0, $retf_imm");
>  
> +	init_inregs(NULL);
> +
>  	exec_in_big_real_mode(&insn_call1);
>  	report("call 1", R_AX, outregs.eax == 0x1234);
>  
> @@ -572,7 +589,7 @@ static void test_jcc_short(void)
>  		      "mov $0x1234, %eax\n\t"
>  		      "1:\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_jnz_short1);
>  	report("jnz short 1", ~0, 1);
> @@ -595,7 +612,7 @@ static void test_jcc_near(void)
>  	MK_INSN(jmp_near1, ".byte 0xE9, 0x06, 0x00\n\t"
>  		           "mov $0x1234, %eax\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_jnz_near1);
>  	report("jnz near 1", 0, 1);
> @@ -609,14 +626,13 @@ static void test_jcc_near(void)
>  
>  static void test_long_jmp(void)
>  {
> -	u32 esp[16];
> -
> -	inregs = (struct regs){ 0 };
> -	inregs.esp = (u32)&esp[ARRAY_SIZE(esp)];
>  	MK_INSN(long_jmp, "call 1f\n\t"
>  			  "jmp 2f\n\t"
>  			  "1: jmp $0, $test_function\n\t"
>  		          "2:\n\t");
> +
> +	init_inregs(NULL);
> +
>  	exec_in_big_real_mode(&insn_long_jmp);
>  	report("jmp far 1", R_AX, outregs.eax == 0x1234);
>  }
> @@ -658,7 +674,7 @@ static void test_push_pop(void)
>  		"xor $0x12340000, %esp \n\t"
>  		"pop %bx");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_push32);
>  	report("push/pop 1", R_AX|R_BX,
> @@ -691,17 +707,12 @@ static void test_null(void)
>  {
>  	MK_INSN(null, "");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_null);
>  	report("null", 0, 1);
>  }
>  
> -struct {
> -    char stack[500];
> -    char top[];
> -} tmp_stack;
> -
>  static void test_pusha_popa(void)
>  {
>  	MK_INSN(pusha, "pusha\n\t"
> @@ -726,7 +737,7 @@ static void test_pusha_popa(void)
>  		      "popa\n\t"
>  		      );
>  
> -	inregs = (struct regs){ .eax = 0, .ebx = 1, .ecx = 2, .edx = 3, .esi = 4, .edi = 5, .ebp = 6, .esp = (unsigned long)&tmp_stack.top };
> +	init_inregs(&(struct regs){ .eax = 0, .ebx = 1, .ecx = 2, .edx = 3, .esi = 4, .edi = 5, .ebp = 6 });
>  
>  	exec_in_big_real_mode(&insn_pusha);
>  	report("pusha/popa 1", 0, 1);
> @@ -774,7 +785,7 @@ static void test_iret(void)
>  			      "1: iretw\n\t"
>  			      "2:\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_iret32);
>  	report("iret 1", 0, 1);
> @@ -792,7 +803,7 @@ static void test_iret(void)
>  
>  static void test_int(void)
>  {
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	*(u32 *)(0x11 * 4) = 0x1000; /* Store a pointer to address 0x1000 in IDT entry 0x11 */
>  	*(u8 *)(0x1000) = 0xcf; /* 0x1000 contains an IRET instruction */
> @@ -829,7 +840,7 @@ static void test_imul(void)
>  			"mov $4, %ecx\n\t"
>  			"imul %ecx\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_imul8_1);
>  	report("imul 1", R_AX | R_CX | R_DX, (outregs.eax & 0xff) == (u8)-8);
> @@ -866,7 +877,7 @@ static void test_mul(void)
>  			"mov $4, %ecx\n\t"
>  			"imul %ecx\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_mul8);
>  	report("mul 1", R_AX | R_CX | R_DX, (outregs.eax & 0xff) == 8);
> @@ -892,7 +903,7 @@ static void test_div(void)
>  			"mov $5, %ecx\n\t"
>  			"div %ecx\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_div8);
>  	report("div 1", R_AX | R_CX | R_DX, outregs.eax == 384);
> @@ -920,7 +931,7 @@ static void test_idiv(void)
>  			"mov $-2, %ecx\n\t"
>  			"idiv %ecx\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_idiv8);
>  	report("idiv 1", R_AX | R_CX | R_DX, outregs.eax == (u8)-128);
> @@ -939,7 +950,7 @@ static void test_cbw(void)
>  	MK_INSN(cwde, "mov $0xFFFE, %eax \n\t"
>  		      "cwde\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_cbw);
>  	report("cbq 1", ~0, outregs.eax == 0xFFFE);
> @@ -964,7 +975,7 @@ static void test_loopcc(void)
>  		        "1: dec %eax\n\t"
>  			"loopne 1b\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_loop);
>  	report("LOOPcc short 1", R_AX, outregs.eax == 10);
> @@ -1243,7 +1254,7 @@ static void test_das(void)
>  
>      MK_INSN(das, "das");
>  
> -    inregs = (struct regs){ 0 };
> +    init_inregs(NULL);
>  
>      for (i = 0; i < 1024; ++i) {
>          unsigned tmp = test_cases[i];
> @@ -1278,7 +1289,7 @@ static void test_cwd_cdq(void)
>  	MK_INSN(cdq_2, "mov $0x10000000, %eax\n\t"
>  		       "cdq\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_cwd_1);
>  	report("cwd 1", R_AX | R_DX,
> @@ -1307,7 +1318,7 @@ static struct {
>  
>  static void test_lds_lss(void)
>  {
> -	inregs = (struct regs){ .ebx = (unsigned long)&desc };
> +	init_inregs(&(struct regs){ .ebx = (unsigned long)&desc });
>  
>  	MK_INSN(lds, "push %ds\n\t"
>  		     "lds (%ebx), %eax\n\t"
> @@ -1376,7 +1387,7 @@ static void test_jcxz(void)
>  			"mov $0, %ecx\n\t"
>  			"1:\n\t");
>  
> -	inregs = (struct regs){ 0 };
> +	init_inregs(NULL);
>  
>  	exec_in_big_real_mode(&insn_jcxz1);
>  	report("jcxz short 1", 0, 1);
> @@ -1400,8 +1411,10 @@ static void test_cpuid(void)
>      unsigned function = 0x1234;
>      unsigned eax, ebx, ecx, edx;
>  
> -    inregs.eax = eax = function;
> -    inregs.ecx = ecx = 0;
> +    init_inregs(&(struct regs){ .eax = function });
> +
> +    eax = inregs.eax;
> +    ecx = inregs.ecx;
>      asm("cpuid" : "+a"(eax), "=b"(ebx), "+c"(ecx), "=d"(edx));
>      exec_in_big_real_mode(&insn_cpuid);
>      report("cpuid", R_AX|R_BX|R_CX|R_DX,
> @@ -1415,10 +1428,11 @@ static void test_ss_base_for_esp_ebp(void)
>      MK_INSN(ssrel2, "mov %ss, %ax; mov %bx, %ss; movl (%ebp,%edi,8), %ebx; mov %ax, %ss");
>      static unsigned array[] = { 0x12345678, 0, 0, 0, 0x87654321 };
>  
> -    inregs.ebx = 1;
> -    inregs.ebp = (unsigned)array;
> +    init_inregs(&(struct regs){ .ebx = 1, .ebp = (unsigned)array });
> +
>      exec_in_big_real_mode(&insn_ssrel1);
>      report("ss relative addressing (1)", R_AX | R_BX, outregs.ebx == 0x87654321);
> +
>      inregs.ebx = 1;
>      inregs.ebp = (unsigned)array;
>      inregs.edi = 0;
> @@ -1434,7 +1448,8 @@ static void test_sgdt_sidt(void)
>      MK_INSN(sidt, "sidtw (%eax)");
>      struct table_descr x, y;
>  
> -    inregs.eax = (unsigned)&y;
> +    init_inregs(&(struct regs){ .eax = (unsigned)&y });
> +
>      asm volatile("sgdtw %0" : "=m"(x));
>      exec_in_big_real_mode(&insn_sgdt);
>      report("sgdt", 0, x.limit == y.limit && x.base == y.base);
> @@ -1449,7 +1464,8 @@ static void test_sahf(void)
>  {
>      MK_INSN(sahf, "sahf; pushfw; mov (%esp), %al; popfw");
>  
> -    inregs.eax = 0xfd00;
> +    init_inregs(&(struct regs){ .eax = 0xfd00 });
> +
>      exec_in_big_real_mode(&insn_sahf);
>      report("sahf", R_AX, outregs.eax == (inregs.eax | 0xd7));
>  }
> @@ -1458,7 +1474,8 @@ static void test_lahf(void)
>  {
>      MK_INSN(lahf, "pushfw; mov %al, (%esp); popfw; lahf");
>  
> -    inregs.eax = 0xc7;
> +    init_inregs(&(struct regs){ .eax = 0xc7 });
> +
>      exec_in_big_real_mode(&insn_lahf);
>      report("lahf", R_AX, (outregs.eax >> 8) == inregs.eax);
>  }
> @@ -1470,8 +1487,8 @@ static void test_movzx_movsx(void)
>      MK_INSN(movzsah, "movsx %ah, %ebx");
>      MK_INSN(movzxah, "movzx %ah, %ebx");
>  
> -    inregs.eax = 0x1234569c;
> -    inregs.esp = 0xffff;
> +    init_inregs(&(struct regs){ .eax = 0x1234569c });
> +
>      exec_in_big_real_mode(&insn_movsx);
>      report("movsx", R_BX, outregs.ebx == (signed char)inregs.eax);
>      exec_in_big_real_mode(&insn_movzx);
> @@ -1486,7 +1503,8 @@ static void test_bswap(void)
>  {
>      MK_INSN(bswap, "bswap %ecx");
>  
> -    inregs.ecx = 0x12345678;
> +    init_inregs(&(struct regs){ .ecx = 0x12345678 });
> +
>      exec_in_big_real_mode(&insn_bswap);
>      report("bswap", R_CX, outregs.ecx == 0x78563412);
>  }
> @@ -1495,7 +1513,8 @@ static void test_aad(void)
>  {
>      MK_INSN(aad, "aad");
>  
> -    inregs.eax = 0x12345678;
> +    init_inregs(&(struct regs){ .eax = 0x12345678 });
> +
>      exec_in_big_real_mode(&insn_aad);
>      report("aad", R_AX, outregs.eax == 0x123400d4);
>  }
> @@ -1504,7 +1523,8 @@ static void test_aam(void)
>  {
>      MK_INSN(aam, "aam");
>  
> -    inregs.eax = 0x76543210;
> +    init_inregs(&(struct regs){ .eax = 0x76543210 });
> +
>      exec_in_big_real_mode(&insn_aam);
>      report("aam", R_AX, outregs.eax == 0x76540106);
>  }
> @@ -1519,8 +1539,8 @@ static void test_xlat(void)
>          table[i] = i + 1;
>      }
>  
> -    inregs.eax = 0x89abcdef;
> -    inregs.ebx = (u32)table;
> +    init_inregs(&(struct regs){ .eax = 0x89abcdef, .ebx = (u32)table });
> +
>      exec_in_big_real_mode(&insn_xlat);
>      report("xlat", R_AX, outregs.eax == 0x89abcdf0);
>  }
> @@ -1530,7 +1550,8 @@ static void test_salc(void)
>      MK_INSN(clc_salc, "clc; .byte 0xd6");
>      MK_INSN(stc_salc, "stc; .byte 0xd6");
>  
> -    inregs.eax = 0x12345678;
> +    init_inregs(&(struct regs){ .eax = 0x12345678 });
> +
>      exec_in_big_real_mode(&insn_clc_salc);
>      report("salc (1)", R_AX, outregs.eax == 0x12345600);
>      exec_in_big_real_mode(&insn_stc_salc);
> @@ -1542,8 +1563,7 @@ static void test_fninit(void)
>  	u16 fcw = -1, fsw = -1;
>  	MK_INSN(fninit, "fninit ; fnstsw (%eax) ; fnstcw (%ebx)");
>  
> -	inregs.eax = (u32)&fsw;
> -	inregs.ebx = (u32)&fcw;
> +	init_inregs(&(struct regs){ .eax = (u32)&fsw, .ebx = (u32)&fcw });
>  
>  	exec_in_big_real_mode(&insn_fninit);
>  	report("fninit", 0, fsw == 0 && (fcw & 0x103f) == 0x003f);
> @@ -1576,7 +1596,8 @@ static u32 cycles_in_big_real_mode(struct insn_desc *insn)
>  {
>  	u64 start, end;
>  
> -	inregs.ecx = PERF_COUNT;
> +	init_inregs(&(struct regs){ .ecx = PERF_COUNT });
> +
>  	exec_in_big_real_mode(insn);
>  	start = ((u64)outregs.esi << 32) | outregs.ebx;
>  	end = ((u64)outregs.edx << 32) | outregs.eax;
> @@ -1624,7 +1645,9 @@ static void test_perf_memory_load(void)
>  	u32 cyc, tmp;
>  
>  	MK_INSN_PERF(perf_memory_load, "cmp $0, (%edi)");
> -	inregs.edi = (u32)&tmp;
> +
> +	init_inregs(&(struct regs){ .edi = (u32)&tmp });
> +
>  	cyc = cycles_in_big_real_mode(&insn_perf_memory_load);
>  	print_serial_u32((cyc - perf_baseline) / PERF_COUNT);
>  	print_serial(" cycles/emulated memory load instruction\n");
> @@ -1635,7 +1658,9 @@ static void test_perf_memory_store(void)
>  	u32 cyc, tmp;
>  
>  	MK_INSN_PERF(perf_memory_store, "mov %ax, (%edi)");
> -	inregs.edi = (u32)&tmp;
> +
> +	init_inregs(&(struct regs){ .edi = (u32)&tmp });
> +
>  	cyc = cycles_in_big_real_mode(&insn_perf_memory_store);
>  	print_serial_u32((cyc - perf_baseline) / PERF_COUNT);
>  	print_serial(" cycles/emulated memory store instruction\n");
> @@ -1646,7 +1671,9 @@ static void test_perf_memory_rmw(void)
>  	u32 cyc, tmp;
>  
>  	MK_INSN_PERF(perf_memory_rmw, "add $1, (%edi)");
> -	inregs.edi = (u32)&tmp;
> +
> +	init_inregs(&(struct regs){ .edi = (u32)&tmp });
> +
>  	cyc = cycles_in_big_real_mode(&insn_perf_memory_rmw);
>  	print_serial_u32((cyc - perf_baseline) / PERF_COUNT);
>  	print_serial(" cycles/emulated memory RMW instruction\n");
> @@ -1656,8 +1683,9 @@ static void test_dr_mod(void)
>  {
>  	MK_INSN(drmod, "movl %ebx, %dr0\n\t"
>  		       ".byte 0x0f \n\t .byte 0x21 \n\t .byte 0x0\n\t");
> -	inregs.eax = 0xdead;
> -	inregs.ebx = 0xaced;
> +
> +	init_inregs(&(struct regs){ .eax = 0xdead, .ebx = 0xaced });
> +
>  	exec_in_big_real_mode(&insn_drmod);
>  	report("mov dr with mod bits", R_AX | R_BX, outregs.eax == 0xaced);
>  }
> @@ -1670,7 +1698,9 @@ static void test_smsw(void)
>  		      "movl %ebx, %cr0\n\t"
>  		      "smswl %eax\n\t"
>  		      "movl %ecx, %cr0\n\t");
> -	inregs.eax = 0x12345678;
> +
> +	init_inregs(&(struct regs){ .eax = 0x12345678 });
> +
>  	exec_in_big_real_mode(&insn_smsw);
>  	report("smsw", R_AX | R_BX | R_CX, outregs.eax == outregs.ebx);
>  }
> @@ -1678,7 +1708,9 @@ static void test_smsw(void)
>  static void test_xadd(void)
>  {
>  	MK_INSN(xadd, "xaddl %eax, %eax\n\t");
> -	inregs.eax = 0x12345678;
> +
> +	init_inregs(&(struct regs){ .eax = 0x12345678 });
> +
>  	exec_in_big_real_mode(&insn_xadd);
>  	report("xadd", R_AX, outregs.eax == inregs.eax * 2);
>  }
> 

Applied, thanks.

Paolo
