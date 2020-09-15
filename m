Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FF226B100
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgIOWXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:23:19 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:38894 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727561AbgIOQYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 12:24:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 924DC57E8B;
        Tue, 15 Sep 2020 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600185600;
         x=1602000001; bh=4q3V9ew4umEFEjPLwcZttcjt5d7fSCSEjzk4nAG2rsU=; b=
        Pq/hF6EgpZX5sGOr62W0bNNbyJ/0iMjuOr9FbucD3cl+GyYiM1j6okyQi5mAoEuD
        3Zx9l7ULfn3XFN0CuJbAVnNzdyg3I9sLhBq1Ubo/6T/GyzWniKIn6hbw/AYaFEnd
        Yu6qWJn+45pUIVIu/gCLvs6dLRUbZCcDMLjRaWc22Rw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GpgqlvTnr0XX; Tue, 15 Sep 2020 19:00:00 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4998257E8A;
        Tue, 15 Sep 2020 19:00:00 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 15
 Sep 2020 19:00:00 +0300
Date:   Tue, 15 Sep 2020 18:59:59 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
Message-ID: <20200915155959.GF52559@SPB-NB-133.local>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
 <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
 <20200914144502.GB52559@SPB-NB-133.local>
 <4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 06:37:33PM +0200, Thomas Huth wrote:
> On 14/09/2020 16.45, Roman Bolshakov wrote:
> > The difference is only realmode test which doesn't work if built by
> > clang.
> 
> Hmm, if you got some spare minutes, could you check if it works when
> replacing the asm() statements there with asm volatile() ?
> (Otherwise I'll check it if I got some spare time again ... so likely
> not this week ;-))
> 

Hi Thomas,

Sure. There are only two places where volatile is missed (inside functions) and
would make sense to add it. Unfortunately it doesn't help much:

diff --git a/x86/realmode.c b/x86/realmode.c
index 7c2d776..30691bc 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -271,7 +271,7 @@ static void report(const char *name, u16 regs_ignore, _Bool ok)
 }

 #define MK_INSN(name, str)                             \
-    asm (                                              \
+    asm volatile (                                             \
         ".pushsection .data.insn  \n\t"                \
         "insn_" #name ": \n\t"                         \
         ".word 1001f, 1002f - 1001f \n\t"              \
@@ -1448,7 +1448,7 @@ static void test_cpuid(void)

     eax = inregs.eax;
     ecx = inregs.ecx;
-    asm("cpuid" : "+a"(eax), "=b"(ebx), "+c"(ecx), "=d"(edx));
+    asm volatile("cpuid" : "+a"(eax), "=b"(ebx), "+c"(ecx), "=d"(edx));
     exec_in_big_real_mode(&insn_cpuid);
     report("cpuid", R_AX|R_BX|R_CX|R_DX,
           outregs.eax == eax && outregs.ebx == ebx




So, I looked further and noticed that multiboot header is missed in the flat
binary:
        ".section .init \n\t"

        ".code32 \n\t"

        "mb_magic = 0x1BADB002 \n\t"
        "mb_flags = 0x0 \n\t"

        "# multiboot header \n\t"
        ".long mb_magic, mb_flags, 0 - (mb_magic + mb_flags) \n\t"


But I can see it in the object file. So, I believe linker didn't place .init
section at 0x1000 despite realmode.lds instruction:

SECTIONS
{
    . = 16K;
    stext = .;
    .text : { *(.init) *(.text) }
    . = ALIGN(4K);
    .data : { *(.data) *(.rodata*) }
    . = ALIGN(16);
    .bss : { *(.bss) }
    edata = .;
}
ENTRY(start)


If I read it correctly, given the segment in realmode.elf:
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0x00004000 0x00004000 0x03c90 0x03c90 R E 0x1000

Here's multiboot header in GCC-compiled binary:
00001000: 02b0ad1b 00000000 fe4f52e4 66b83412  .........OR.f.4.

Here's the same location in clang-compiled binary:
00001000: 04000000 14000000 03000000 474e5500  ............GNU.

Here's verbose invocation of linker by clang:

$ clang-10 -v -m32 -nostdlib -o x86/realmode.elf -Wl,-m,elf_i386 -Wl,-T,/home/roolebo
/dev/kvm-unit-tests/x86/realmode.lds x86/realmode.o
clang version 10.0.0-4ubuntu1
Target: i386-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/9
Found candidate GCC installation: /usr/lib/gcc/x86_64-linux-gnu/9
 "/usr/bin/ld" -z relro --hash-style=gnu --build-id --eh-frame-hdr -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o x86/realmode.elf -L/lib/../lib32 -L/usr/lib/../lib32 -L/usr/lib/llvm-10/bin/../lib -L/lib -L/usr/lib -m elf_i386 -T /home/roolebo/dev/kvm-unit-tests/x86/realmode.lds x86/realmode.o

(BTW, I'm surprised to see -dynamic-linker being set, it has little sense for
the tests but that's likely because -static is not passed explicitly)

And if I pass --print-map option to the linker I can see that GNU build id is
placed at 0x4000:

$ clang-10 -m32 -nostdlib -o x86/realmode.elf -Wl,-M -Wl,-m,elf_i386 -Wl,-T,/home/roo
lebo/dev/kvm-unit-tests/x86/realmode.lds x86/realmode.o

Discarded input sections

 .llvm_addrsig  0x0000000000000000      0x122 x86/realmode.o

Memory Configuration

Name             Origin             Length             Attributes
*default*        0x0000000000000000 0xffffffffffffffff

Linker script and memory map

                0x0000000000004000                . = 0x4000
                0x0000000000004000                stext = .

.note.gnu.build-id
                0x0000000000004000       0x24
 .note.gnu.build-id
                0x0000000000004000       0x24 x86/realmode.o

.text           0x0000000000004030     0x290c
 *(.init)
 .init          0x0000000000004030        0xc x86/realmode.o
 *(.text)
 *fill*         0x000000000000403c        0x4
 .text          0x0000000000004040     0x28fc x86/realmode.o
                0x000000000000404c                start
                0x00000000000040a0                realmode_start

.text.insn      0x000000000000693c      0x40e
 .text.insn     0x000000000000693c      0x40e x86/realmode.o

.iplt           0x0000000000006d4a        0x0
 .iplt          0x0000000000006d4a        0x0 x86/realmode.o

.rel.dyn        0x0000000000006d4c        0x0
 .rel.got       0x0000000000006d4c        0x0 x86/realmode.o
 .rel.iplt      0x0000000000006d4c        0x0 x86/realmode.o
                0x0000000000007000                . = ALIGN (0x1000)

.data           0x0000000000007000     0x2538
 *(.data)
 .data          0x0000000000007000     0x1064 x86/realmode.o
                0x0000000000008000                r_gdt
                0x0000000000008018                r_gdt_descr
                0x000000000000801e                r_idt_descr
 *(.rodata*)
 .rodata.str1.1
                0x0000000000008064      0x4d3 x86/realmode.o
                                        0x4f9 (size before relaxing)
 *fill*         0x0000000000008537        0x1
 .rodata        0x0000000000008538     0x1000 x86/realmode.o

.data.insn      0x0000000000009538      0x21c
 .data.insn     0x0000000000009538      0x21c x86/realmode.o

.got            0x0000000000009754        0x0
 .got           0x0000000000009754        0x0 x86/realmode.o

.got.plt        0x0000000000009754        0x0
 .got.plt       0x0000000000009754        0x0 x86/realmode.o

.igot.plt       0x0000000000009754        0x0
 .igot.plt      0x0000000000009754        0x0 x86/realmode.o
                0x0000000000009760                . = ALIGN (0x10)

.bss            0x0000000000009760      0x284
 *(.bss)
 .bss           0x0000000000009760      0x284 x86/realmode.o
                0x0000000000009764                tmp_stack
                0x00000000000099e4                edata = .
LOAD x86/realmode.o
OUTPUT(x86/realmode.elf elf32-i386)

.debug_str      0x0000000000000000      0x509
 .debug_str     0x0000000000000000      0x509 x86/realmode.o
                                        0x59f (size before relaxing)

.debug_loc      0x0000000000000000      0x484
 .debug_loc     0x0000000000000000      0x484 x86/realmode.o

.debug_abbrev   0x0000000000000000      0x212
 .debug_abbrev  0x0000000000000000      0x212 x86/realmode.o

.debug_info     0x0000000000000000     0x1935
 .debug_info    0x0000000000000000     0x1935 x86/realmode.o

.comment        0x0000000000000000       0x1f
 .comment       0x0000000000000000       0x1f x86/realmode.o
                                         0x20 (size before relaxing)

.note.GNU-stack
                0x0000000000000000        0x0
 .note.GNU-stack
                0x0000000000000000        0x0 x86/realmode.o

.debug_frame    0x0000000000000000      0x824
 .debug_frame   0x0000000000000000      0x824 x86/realmode.o

.debug_line     0x0000000000000000      0xc06
 .debug_line    0x0000000000000000      0xc06 x86/realmode.o


So, a workaround for that could be adding '-Wl,--build-id=none' to the
makefile rule for realmode.elf. Then multiboot magic is placed properly
at 0x4000 instead of 0x4030. Unfortunately it doesn't help with the
test :-)

-Roman
