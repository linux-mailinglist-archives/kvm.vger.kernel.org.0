Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7B4B064A
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 07:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiBJGeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 01:34:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiBJGe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 01:34:29 -0500
Received: from out0-146.mail.aliyun.com (out0-146.mail.aliyun.com [140.205.0.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84980D97
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 22:34:29 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047212;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.MnpYXHH_1644474863;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MnpYXHH_1644474863)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 14:34:23 +0800
Date:   Thu, 10 Feb 2022 14:34:23 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] x86/emulator: Add some tests for
 lret instruction emulation
Message-ID: <20220210063423.GA94518@k08j02272.eu95sqa>
References: <cover.1644311445.git.houwenlong.hwl@antgroup.com>
 <006c75f53539958c1e5d5a0a5073566a5395414e.1644311445.git.houwenlong.hwl@antgroup.com>
 <YgQ7D7AQrILRqWnt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgQ7D7AQrILRqWnt@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for your kind review.

On Thu, Feb 10, 2022 at 06:07:11AM +0800, Sean Christopherson wrote:
> Nit, "far ret" instead of "lret" in the shortlog.
> 
> On Tue, Feb 08, 2022, Hou Wenlong wrote:
> > Per Intel's SDM on the "Instruction Set Reference", when
> > loading segment descriptor for far return, not-present segment
> > check should be after all type and privilege checks. However,
> > __load_segment_descriptor() in x86's emulator does not-present
> > segment check first, so it would trigger #NP instead of #GP
> > if type or privilege checks fail and the segment is not present.
> > 
> > And if RPL < CPL, it should trigger #GP, but the check is missing
> > in emulator.
> > 
> > So add some tests for lret instruction, and it will test
> > those tests in hardware and emulator. Enable
> > kvm.force_emulation_prefix when try to test them in emulator.
> > 
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> 
> Was this tested?  There are multiple compilation errors with gcc...
> 
> x86/emulator.c: In function ¡®test_far_xfer¡¯:
> x86/emulator.c:1034:10: error: format not a string literal and no format arguments [-Werror=format-security]
>  1034 |          far_xfer_error_code == t->error_code, t->msg);
>       |          ^~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make: *** [<builtin>: x86/emulator.o] Error 1
>
> x86/emulator.c: Assembler messages:
> x86/emulator.c:81: Error: incorrect register `%si' used with `q' suffix
> x86/emulator.c:83: Error: incorrect register `%si' used with `q' suffix
> make: *** [<builtin>: x86/emulator.o] Error 1
> 
The compilation was OK when I tested on my machine. But my gcc is old and
customted, -Wformat-security is not enabled by default. After switching
to higher version of gcc, I get compilation errors too.

> > +static struct far_xfer_test_case far_ret_testcases[] = {
> > +	{0, DS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret desc.type!=code && desc.p=0"},
> > +	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret non-conforming && dpl!=rpl && desc.p=0"},
> > +	{0, CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret conforming && dpl>rpl && desc.p=0"},
> > +	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, FIRST_SPARE_SEL, "lret desc.p=0"},
> > +	{0, NON_CONFORM_CS_TYPE, 3, 1, true, GP_VECTOR, FIRST_SPARE_SEL, "lret rpl<cpl"},
> 
> Since the framework is responsible for specifying the selector and the expected
> error code is the same for all subtests that expect an exception, just drop the
> error code.  E.g. if the framework decides to use a different selector than these
> would need to be updated too, for no real benefit.
> 
> It'd also be helpful to align everything.
> 
> s/lret/far ret.  Actually to cut down on copy+paste, and because we need formatting
> anyways (see below), how moving the instruction name into the far_xfer_test?
> 
> > +};
> > +
> > +static struct far_xfer_test far_ret_test = {
> > +	.insn = FAR_XFER_RET,
> > +	.testcases = &far_ret_testcases[0],
> > +	.nr_testcases = sizeof(far_ret_testcases) / sizeof(struct far_xfer_test_case),
> > +};
> > +
> > +#define TEST_FAR_RET_ASM(seg, prefix)		\
> > +	asm volatile("lea 1f(%%rip), %%rax\n\t" \
> > +		     "pushq %[asm_seg]\n\t"	\
> > +		     "pushq $2f\n\t"		\
> > +		      prefix "lretq\n\t"	\
> > +		     "1: addq $16, %%rsp\n\t"	\
> > +		     "2:"			\
> > +		     : : [asm_seg]"r"(seg)	\
> 
> Because @seg is a u16, gcc emites "pushq SI".  Kinda dumb, but...
> 
> @@ -72,7 +71,7 @@ static struct far_xfer_test far_ret_test = {
>                       prefix "lretq\n\t"        \
>                      "1: addq $16, %%rsp\n\t"   \
>                      "2:"                       \
> -                    : : [asm_seg]"r"(seg)      \
> +                    : : [asm_seg]"r"((u64)seg) \
>                      : "eax", "memory");
> 
> > +		     : "eax", "memory");
> > +
> > +static inline void test_far_ret_asm(uint16_t seg, bool force_emulation)
> > +{
> > +	if (force_emulation) {
> 
> No need for braces.  Ah, the macro is missing ({ ... }) to force it to be evaluated
> as a single statement.  It should be.
> 
> Side topic, a ternary operator would be nice, but I don't know how to force string
> concatentation for this case...
>
I don't know too, so I use if/else statement here.

> #define TEST_FAR_RET_ASM(seg, prefix)		\
> ({						\
> 	asm volatile("lea 1f(%%rip), %%rax\n\t" \
> 		     "pushq %[asm_seg]\n\t"	\
> 		     "pushq $2f\n\t"		\
> 		      prefix "lretq\n\t"	\
> 		     "1: addq $16, %%rsp\n\t"	\
> 		     "2:"			\
> 		     : : [asm_seg]"r"((u64)seg)	\
> 		     : "eax", "memory");	\
> })
> 
> > +		TEST_FAR_RET_ASM(seg, KVM_FEP);
> > +	} else {
> > +		TEST_FAR_RET_ASM(seg, "");
> > +	}
> > +}
> 
> This only has a single caller, just open code the macros in the case statements
> of __test_far_xfer().  (My apologies if I suggested this in the last version).
> 
> >  struct regs {
> >  	u64 rax, rbx, rcx, rdx;
> > @@ -891,6 +951,74 @@ static void test_mov_dr(uint64_t *mem)
> >  	report(rax == dr6_fixed_1, "mov_dr6");
> >  }
> >  
> > +static void far_xfer_exception_handler(struct ex_regs *regs)
> > +{
> > +	far_xfer_vector = regs->vector;
> > +	far_xfer_error_code = regs->error_code;
> > +	regs->rip = regs->rax;;
> 
> Double semi-colon.
> 
> > +}
> > +
> > +static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
> > +			    bool force_emulation)
> > +{
> > +	switch (insn) {
> > +	case FAR_XFER_RET:
> > +		test_far_ret_asm(seg, force_emulation);
> > +		break;
> > +	default:
> > +		report_fail("unknown instructions");
> 
> It's worth spitting out the insn, it might save someone a few seconds/minutes, e.g.
> 
> 		report_fail("Unexpected insn enum = %d\n", insn);
> 
> > +		break;
> > +	}
> > +}
> > +
> > +static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
> > +{
> > +	struct far_xfer_test_case *t;
> > +	uint16_t seg;
> > +	bool ign;
> > +	int i;
> > +
> > +	handle_exception(GP_VECTOR, far_xfer_exception_handler);
> > +	handle_exception(NP_VECTOR, far_xfer_exception_handler);
> > +
> > +	for (i = 0; i < test->nr_testcases; i++) {
> > +		t = &test->testcases[i];
> > +
> > +		seg = FIRST_SPARE_SEL | t->rpl;
> > +		gdt[seg / 8] = gdt[(t->usermode ? USER_CS64 : KERNEL_CS) / 8];
> > +		gdt[seg / 8].type = t->type;
> > +		gdt[seg / 8].dpl = t->dpl;
> > +		gdt[seg / 8].p = t->p;
> > +
> > +		far_xfer_vector = -1;
> > +		far_xfer_error_code = -1;
> > +
> > +		if (t->usermode)
> > +			run_in_user((usermode_func)__test_far_xfer, UD_VECTOR,
> > +				    test->insn, seg, force_emulation, 0, &ign);
> > +		else
> > +			__test_far_xfer(test->insn, seg, force_emulation);
> > +
> > +		report(far_xfer_vector == t->vector &&
> > +		       far_xfer_error_code == t->error_code, t->msg);
> 
> To avoid having to specify the error code, just do:
> 
> 		       (far_xfer_vector < 0 || far_xfer_error_code == FIRST_SPARE_SEL),
> 
> far_xfer_vector and t->vector need to be signed ints, but that's perfectly ok,
> vector fits in a u8.  Printing out the expecte vs. actual is also helpful for
> debug (pet peeve of mine in KUT...).  I doesn't have to be super fancy formatting,
> just enough so that the user doesn't have to modify the test to figure out what
> went wrong.
> 
> And with the insn_name + msg + target (see below) formatting:
> 
> 
> 		report(far_xfer_vector == t->vector &&
> 		       (far_xfer_vector < 0 || far_xfer_error_code == FIRST_SPARE_SEL),
> 		       "%s on %s, %s: wanted %d (%d), got %d (%d)",
> 		       test->insn_name, force_emulation ? "emuator" : "hardware", t->msg,
> 		       t->vector, t->vector < 0 ? -1 : FIRST_SPARE_SEL,
> 		       far_xfer_vector, far_xfer_error_code);
> 
> > +	}
> > +
> > +	handle_exception(GP_VECTOR, 0);
> > +	handle_exception(NP_VECTOR, 0);
> > +}
> > +
> > +static void test_lret(uint64_t *mem)
> 
> test_far_ret()
> 
> > +{
> > +	printf("test lret in hw\n");
> 
> Rather than print this out before, just spit out the "target" in the report.
> 
> > +	test_far_xfer(false, &far_ret_test);
> > +}
> 
> All of the above (I think) feeback:
> 
> ---
>  x86/emulator.c | 57 +++++++++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 2a35caf..d28e36c 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -21,7 +21,7 @@ static int exceptions;
>  #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
>  #define KVM_FEP_LENGTH 5
>  static int fep_available = 1;
> -static unsigned int far_xfer_vector = -1;
> +static int far_xfer_vector = -1;
>  static unsigned int far_xfer_error_code = -1;
> 
>  struct far_xfer_test_case {
> @@ -30,8 +30,7 @@ struct far_xfer_test_case {
>  	uint16_t dpl;
>  	uint16_t p;
>  	bool usermode;
> -	unsigned int vector;
> -	unsigned int error_code;
> +	int vector;
>  	const char *msg;
>  };
> 
> @@ -41,6 +40,7 @@ enum far_xfer_insn {
> 
>  struct far_xfer_test {
>  	enum far_xfer_insn insn;
> +	const char *insn_name;
>  	struct far_xfer_test_case *testcases;
>  	unsigned int nr_testcases;
>  };
> @@ -50,37 +50,31 @@ struct far_xfer_test {
>  #define DS_TYPE			0x3
> 
>  static struct far_xfer_test_case far_ret_testcases[] = {
> -	{0, DS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret desc.type!=code && desc.p=0"},
> -	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret non-conforming && dpl!=rpl && desc.p=0"},
> -	{0, CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret conforming && dpl>rpl && desc.p=0"},
> -	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, FIRST_SPARE_SEL, "lret desc.p=0"},
> -	{0, NON_CONFORM_CS_TYPE, 3, 1, true, GP_VECTOR, FIRST_SPARE_SEL, "lret rpl<cpl"},
> +	{0, DS_TYPE,		 0, 0, false, GP_VECTOR, "desc.type!=code && desc.p=0"},
> +	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, "non-conforming && dpl!=rpl && desc.p=0"},
> +	{0, CONFORM_CS_TYPE,     3, 0, false, GP_VECTOR, "conforming && dpl>rpl && desc.p=0"},
> +	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, "desc.p=0"},
> +	{0, NON_CONFORM_CS_TYPE, 3, 1, true,  GP_VECTOR, "rpl<cpl"},
>  };
> 
>  static struct far_xfer_test far_ret_test = {
>  	.insn = FAR_XFER_RET,
> +	.insn_name = "far ret",
>  	.testcases = &far_ret_testcases[0],
>  	.nr_testcases = sizeof(far_ret_testcases) / sizeof(struct far_xfer_test_case),
>  };
> 
>  #define TEST_FAR_RET_ASM(seg, prefix)		\
> +({						\
>  	asm volatile("lea 1f(%%rip), %%rax\n\t" \
>  		     "pushq %[asm_seg]\n\t"	\
>  		     "pushq $2f\n\t"		\
>  		      prefix "lretq\n\t"	\
>  		     "1: addq $16, %%rsp\n\t"	\
>  		     "2:"			\
> -		     : : [asm_seg]"r"(seg)	\
> -		     : "eax", "memory");
> -
> -static inline void test_far_ret_asm(uint16_t seg, bool force_emulation)
> -{
> -	if (force_emulation) {
> -		TEST_FAR_RET_ASM(seg, KVM_FEP);
> -	} else {
> -		TEST_FAR_RET_ASM(seg, "");
> -	}
> -}
> +		     : : [asm_seg]"r"((u64)seg)	\
> +		     : "eax", "memory");	\
> +})
> 
>  struct regs {
>  	u64 rax, rbx, rcx, rdx;
> @@ -959,7 +953,7 @@ static void far_xfer_exception_handler(struct ex_regs *regs)
>  {
>  	far_xfer_vector = regs->vector;
>  	far_xfer_error_code = regs->error_code;
> -	regs->rip = regs->rax;;
> +	regs->rip = regs->rax;
>  }
> 
>  static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
> @@ -967,10 +961,13 @@ static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
>  {
>  	switch (insn) {
>  	case FAR_XFER_RET:
> -		test_far_ret_asm(seg, force_emulation);
> +		if (force_emulation)
> +			TEST_FAR_RET_ASM(seg, KVM_FEP);
> +		else
> +			TEST_FAR_RET_ASM(seg, "");
>  		break;
>  	default:
> -		report_fail("unknown instructions");
> +		report_fail("Unexpected insn enum = %d\n", insn);
>  		break;
>  	}
>  }
> @@ -1004,22 +1001,24 @@ static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
>  			__test_far_xfer(test->insn, seg, force_emulation);
> 
>  		report(far_xfer_vector == t->vector &&
> -		       far_xfer_error_code == t->error_code, "%s", t->msg);
> +		       (far_xfer_vector < 0 || far_xfer_error_code == FIRST_SPARE_SEL),
> +		       "%s on %s, %s: wanted %d (%d), got %d (%d)",
> +		       test->insn_name, force_emulation ? "emuator" : "hardware", t->msg,
> +		       t->vector, t->vector < 0 ? -1 : FIRST_SPARE_SEL,
> +		       far_xfer_vector, far_xfer_error_code);
>  	}
> 
>  	handle_exception(GP_VECTOR, 0);
>  	handle_exception(NP_VECTOR, 0);
>  }
> 
> -static void test_lret(uint64_t *mem)
> +static void test_far_ret(uint64_t *mem)
>  {
> -	printf("test lret in hw\n");
>  	test_far_xfer(false, &far_ret_test);
>  }
> 
> -static void test_em_lret(uint64_t *mem)
> +static void test_em_far_ret(uint64_t *mem)
>  {
> -	printf("test lret in emulator\n");
>  	test_far_xfer(true, &far_ret_test);
>  }
> 
> @@ -1297,7 +1296,7 @@ int main(void)
>  	test_smsw(mem);
>  	test_lmsw();
>  	test_ljmp(mem);
> -	test_lret(mem);
> +	test_far_ret(mem);
>  	test_stringio();
>  	test_incdecnotneg(mem);
>  	test_btc(mem);
> @@ -1322,7 +1321,7 @@ int main(void)
>  		test_smsw_reg(mem);
>  		test_nop(mem);
>  		test_mov_dr(mem);
> -		test_em_lret(mem);
> +		test_em_far_ret(mem);
>  	} else {
>  		report_skip("skipping register-only tests, "
>  			    "use kvm.force_emulation_prefix=1 to enable");
> 
> base-commit: b56a1a58abfcc6abc16e782f13505f4495cf59e8
> --
