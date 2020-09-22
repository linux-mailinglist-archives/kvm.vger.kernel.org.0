Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C9F274B39
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 23:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIVVee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 17:34:34 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48728 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbgIVVed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 17:34:33 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 17:34:31 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 670615754D;
        Tue, 22 Sep 2020 21:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600809908;
         x=1602624309; bh=555VwteurID509dx8aTHbMUOSFvsKRrIAohXb4eRfWA=; b=
        bYW4ElWnG9fy9uwbumxTAaVLzM8OahlKlkyTyfMU2Gt7A/vY0zjv1XMycFmRdWki
        S701r96KBycwSDOIFHHXPuvHhHhZeWPctGL3mWeCZn8lFHkVuOsjFeCnExSDMvTh
        i5v/lJnP3LYSIIgGk/vfYaZ3CE2nY2AxkwXebUU3EXs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mdCnyV4sXyGD; Wed, 23 Sep 2020 00:25:08 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A087B57549;
        Wed, 23 Sep 2020 00:25:08 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 23
 Sep 2020 00:25:08 +0300
Date:   Wed, 23 Sep 2020 00:25:07 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Thomas Huth <thuth@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
Message-ID: <20200922212507.GA11460@SPB-NB-133.local>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
 <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
 <20200914144502.GB52559@SPB-NB-133.local>
 <4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com>
 <20200915155959.GF52559@SPB-NB-133.local>
 <788b7191-6987-9399-f352-2e661255157e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <788b7191-6987-9399-f352-2e661255157e@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 04:51:18PM +0200, Paolo Bonzini wrote:
> On 15/09/20 17:59, Roman Bolshakov wrote:
> > So, a workaround for that could be adding '-Wl,--build-id=none' to the
> > makefile rule for realmode.elf. Then multiboot magic is placed properly
> > at 0x4000 instead of 0x4030. Unfortunately it doesn't help with the
> > test :-)
> 
> Heh, weird.  I also tried adding
> 
>     /DISCARD/ : { *(.note.gnu.build-id) }
> 
> to the linker script and I got a very helpful (not) linker warning:
> 
> /usr/bin/ld: warning: .note.gnu.build-id section discarded, --build-id ignored.
> 
> ... except that the --build-id was placed not by me but rather by gcc.
> So we should probably simplify things doing this:
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 090ce22..10c8a42 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -69,8 +69,8 @@ test_cases: $(tests-common) $(tests)
>  $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
>  
>  $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
> -	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
> -	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
> +	$(LD) -o $@ -m elf_i386 \
> +	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  

Agreed, in the case it's better to tell linker directly what is needed
rather than fighting with compiler's way of invoking the linker.

>  $(TEST_DIR)/realmode.o: bits = 32
>  
> diff --git a/x86/realmode.lds b/x86/realmode.lds
> index 0ed3063..3220c19 100644
> --- a/x86/realmode.lds
> +++ b/x86/realmode.lds
> @@ -1,5 +1,6 @@
>  SECTIONS
>  {
> +    /DISCARD/ : { *(.note.gnu.build-id) }
>      . = 16K;
>      stext = .;
>      .text : { *(.init) *(.text) }
> 
> which I will squash in your patch 3.
> 

Thanks!

There's another difference right after multiboot header.

Here's how GCC binary looks:

00004000 <stext>:
    4000:       02 b0 ad 1b 00 00       add    0x1bad(%eax),%dh
    4006:       00 00                   add    %al,(%eax)
    4008:       fe 4f 52                decb   0x52(%edi)
    400b:       e4                      .byte 0xe4

0000400c <test_function>:
    400c:       66 b8 34 12             mov    $0x1234,%ax
    4010:       00 00                   add    %al,(%eax)
    4012:       66 c3                   retw

Here's clang:

00004000 <stext>:
    4000:       02 b0 ad 1b 00 00       add    0x1bad(%eax),%dh
    4006:       00 00                   add    %al,(%eax)
    4008:       fe 4f 52                decb   0x52(%edi)
    400b:       e4 66                   in     $0x66,%al
    400d:       90                      nop
    400e:       66 90                   xchg   %ax,%ax

00004010 <test_function>:
    4010:       66 b8 34 12             mov    $0x1234,%ax
    4014:       00 00                   add    %al,(%eax)
    4016:       66 c3                   retw


So, clang pads stext with two NOPs after 400b until it's quad-aligned.
I'm not sure how we can ask it to stop doing that.

The assembly (clang-10 -S) doesn't show an alignment requirement:

.set mb_magic, 464367618
.set mb_flags, 0
        # multiboot header
        .long   464367618
        .long   0
        .long   -464367618
        .p2align        0, 0x90
        .globl  start

".p2align 0, 0x90" behaves like ".p2align 4, 0x90", sounds like a bug?

But it doesn't introduce an issue as it turned out later

> But the main issue is that clang does not support .code16gcc so it
> writes 32-bit code that is run in 16-bit mode.

I had impression that it does support .code16gcc from the PR (and
included since LLVM 4.0):

https://reviews.llvm.org/D20109
https://github.com/llvm/llvm-project/commit/6477ce2697bf1d9afd2bcc0cf0c16c7cf08713be

Then another changes register allocation since LLVM 5.0 but I don't
know if it breaks anything (I'm not familiar with LLVM TBH).

https://github.com/llvm/llvm-project/commit/f5f593b674ed031f3f5aa2c44ac705547532d5cb

> It'd be a start to use -m16 instead of -m32, but then I think it still
> miscompiles the (32-bit) code between "start" and the .code16gcc
> label.
> 

Bingo! Changing target variable "bits = 32" to "bits = 16" helps, it
proceeds properly until "iret 1" (insn_code_iret32) test and then it
hangs.

Inline assembly:

        MK_INSN(iret32, "pushf\n\t"
                        "pushl %cs\n\t"
                        "call 1f\n\t" /* a near call will push eip onto the stack */
                        "jmp 2f\n\t"
                        "1: iretl\n\t"
                        "2:\n\t"
                     );

GCC:

00006c25 <insn_code_iret32>:
    6c25:       66 9c                   pushfw
    6c27:       66 0e                   pushw  %cs
    6c29:       66 e8 02 00             callw  6c2f <insn_code_iret32+0xa>
    6c2d:       00 00                   add    %al,(%eax)
    6c2f:       eb 02                   jmp    6c33 <insn_code_iret16>
    6c31:       66 cf                   iretw

Clang saves 16-bit registers but restores 32-bit in `iret` and `call`
doesn't have an operand-size prefix:

00007547 <insn_code_iret32>:
    7547:       9c                      pushf
    7548:       66 0e                   pushw  %cs
    754a:       e8 02 00 eb 02          call   2eb7551 <edata+0x2eacb6d>
    754f:       66 cf                   iretw

So, this fixes the test and makes "iret 3" pass (otherwise it hangs):

diff --git a/x86/realmode.c b/x86/realmode.c
index 7c2d776..0ae5186 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -761,9 +761,9 @@ static void test_pusha_popa(void)

 static void test_iret(void)
 {
-       MK_INSN(iret32, "pushf\n\t"
+       MK_INSN(iret32, "pushfl\n\t"
                        "pushl %cs\n\t"
-                       "call 1f\n\t" /* a near call will push eip onto the stack */
+                       "calll 1f\n\t" /* a near call will push eip onto the stack */
                        "jmp 2f\n\t"
                        "1: iretl\n\t"
                        "2:\n\t"
@@ -782,7 +782,7 @@ static void test_iret(void)
                              "orl $0xffc18028, %eax\n\t"
                              "pushl %eax\n\t"
                              "pushl %cs\n\t"
-                             "call 1f\n\t"
+                             "calll 1f\n\t"
                              "jmp 2f\n\t"
                              "1: iretl\n\t"
                              "2:\n\t");

With the above change I get the following machine code for iret32 which
is equivalent to GCC:

00007547 <insn_code_iret32>:
    7547:       66 9c                   pushfw
    7549:       66 0e                   pushw  %cs
    754b:       66 e8 02 00             callw  7551 <insn_code_iret32+0xa>
    754f:       00 00                   add    %al,(%eax)
    7551:       eb 02                   jmp    7555 <insn_code_iret16>
    7553:       66 cf                   iretw

Still, there're a few more failed tests but realmode doesn't hang anymore:
FAIL: pusha/popa 1
FAIL: pusha/popa 1
FAIL: jmp far 1

And explicit instruction suffixes fix them too:

@@ -639,7 +639,7 @@ static void test_jcc_near(void)

 static void test_long_jmp(void)
 {
-       MK_INSN(long_jmp, "call 1f\n\t"
+       MK_INSN(long_jmp, "calll 1f\n\t"
                          "jmp 2f\n\t"
                          "1: jmp $0, $test_function\n\t"
                          "2:\n\t");
@@ -728,26 +728,26 @@ static void test_null(void)

 static void test_pusha_popa(void)
 {
-       MK_INSN(pusha, "pusha\n\t"
-                      "pop %edi\n\t"
-                      "pop %esi\n\t"
-                      "pop %ebp\n\t"
-                      "add $4, %esp\n\t"
-                      "pop %ebx\n\t"
-                      "pop %edx\n\t"
-                      "pop %ecx\n\t"
-                      "pop %eax\n\t"
+       MK_INSN(pusha, "pushal\n\t"
+                      "popl %edi\n\t"
+                      "popl %esi\n\t"
+                      "popl %ebp\n\t"
+                      "addl $4, %esp\n\t"
+                      "popl %ebx\n\t"
+                      "popl %edx\n\t"
+                      "popl %ecx\n\t"
+                      "popl %eax\n\t"
                       );

-       MK_INSN(popa, "push %eax\n\t"
-                     "push %ecx\n\t"
-                     "push %edx\n\t"
-                     "push %ebx\n\t"
-                     "push %esp\n\t"
-                     "push %ebp\n\t"
-                     "push %esi\n\t"
-                     "push %edi\n\t"
-                     "popa\n\t"
+       MK_INSN(popa, "pushl %eax\n\t"
+                     "pushl %ecx\n\t"
+                     "pushl %edx\n\t"
+                     "pushl %ebx\n\t"
+                     "pushl %esp\n\t"
+                     "pushl %ebp\n\t"
+                     "pushl %esi\n\t"
+                     "pushl %edi\n\t"
+                     "popal\n\t"
                      );

        init_inregs(&(struct regs){ .eax = 0, .ebx = 1, .ecx = 2, .edx = 3, .esi = 4, .edi = 5, .ebp = 6 });



Then everything passes in realmode test:
$ ./x86-run x86/realmode.flat | grep FAIL
qemu-system-x86_64: warning: host doesn't support requested feature:
CPUID.80000001H:ECX.svm [bit 2]
$


Perhaps it's worth to respin the series.

Thanks,
Roman
