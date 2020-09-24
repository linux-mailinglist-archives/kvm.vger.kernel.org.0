Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BBB277785
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgIXRMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 13:12:33 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33434 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbgIXRMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 13:12:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1A6F557F56;
        Thu, 24 Sep 2020 17:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600967549;
         x=1602781950; bh=Cmm2qkHgKP06phKHdVNHpTlFI0E3cPDC26vPMoMUBHg=; b=
        D/mqZQdAEfKDIx6SUGCPT4lVGJUVMfFVgmSKgQ+Cjlb6PI66yu0q7eUp6KrlvyMq
        ChMC84UV0knK5wct1Z4g6sZTQcAagJgGTdH6C5rZqRR3qp9AERvQPj9HGp6I3rlF
        GrAXSthoYmBbldbezqsyoW69/i4F3NkaBdo5FdZPKac=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Kew0N92j9HU7; Thu, 24 Sep 2020 20:12:29 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 11DC157EC3;
        Thu, 24 Sep 2020 20:12:29 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 24
 Sep 2020 20:12:28 +0300
Date:   Thu, 24 Sep 2020 20:12:28 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: realmode: Workaround clang issues
Message-ID: <20200924171228.GA85563@SPB-NB-133.local>
References: <20200924120516.77299-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924120516.77299-1-r.bolshakov@yadro.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 03:05:17PM +0300, Roman Bolshakov wrote:
> clang doesn't properly support .code16gcc and generates wrong machine
> code [1][2][3][4]. But the test works if object file is compiled with -m16 and
> explicit suffixes are added for instructions.
> 
> 1. https://lore.kernel.org/kvm/4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com/
> 2. https://lore.kernel.org/kvm/20200915155959.GF52559@SPB-NB-133.local/
> 3. https://lore.kernel.org/kvm/788b7191-6987-9399-f352-2e661255157e@redhat.com/
> 4. https://lore.kernel.org/kvm/20200922212507.GA11460@SPB-NB-133.local/
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  .travis.yml         |  2 +-
>  x86/Makefile.common |  2 +-
>  x86/realmode.c      | 44 ++++++++++++++++++++++----------------------
>  3 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 2e5ae41..bd62190 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -24,7 +24,7 @@ jobs:
>        - BUILD_DIR="."
>        - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
>                 hyperv_synic idt_test intel_iommu ioapic ioapic-split
> -               kvmclock_test msr pcid rdpru rmap_chain s3 setjmp umip"
> +               kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
>        - ACCEL="kvm"
>  
>      - addons:
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 090ce22..5567d66 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -72,7 +72,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
>  	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
>  	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  
> -$(TEST_DIR)/realmode.o: bits = 32
> +$(TEST_DIR)/realmode.o: bits = 16
>  
>  $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
>  
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 7c2d776..c8a6ae0 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -639,7 +639,7 @@ static void test_jcc_near(void)
>  
>  static void test_long_jmp(void)
>  {
> -	MK_INSN(long_jmp, "call 1f\n\t"
> +	MK_INSN(long_jmp, "calll 1f\n\t"
>  			  "jmp 2f\n\t"
>  			  "1: jmp $0, $test_function\n\t"
>  		          "2:\n\t");
> @@ -728,26 +728,26 @@ static void test_null(void)
>  
>  static void test_pusha_popa(void)
>  {
> -	MK_INSN(pusha, "pusha\n\t"
> -		       "pop %edi\n\t"
> -		       "pop %esi\n\t"
> -		       "pop %ebp\n\t"
> -		       "add $4, %esp\n\t"
> -		       "pop %ebx\n\t"
> -		       "pop %edx\n\t"
> -		       "pop %ecx\n\t"
> -		       "pop %eax\n\t"
> +	MK_INSN(pusha, "pushal\n\t"
> +		       "popl %edi\n\t"
> +		       "popl %esi\n\t"
> +		       "popl %ebp\n\t"
> +		       "addl $4, %esp\n\t"
> +		       "popl %ebx\n\t"
> +		       "popl %edx\n\t"
> +		       "popl %ecx\n\t"
> +		       "popl %eax\n\t"
>  		       );
>  
> -	MK_INSN(popa, "push %eax\n\t"
> -		      "push %ecx\n\t"
> -		      "push %edx\n\t"
> -		      "push %ebx\n\t"
> -		      "push %esp\n\t"
> -		      "push %ebp\n\t"
> -		      "push %esi\n\t"
> -		      "push %edi\n\t"
> -		      "popa\n\t"
> +	MK_INSN(popa, "pushl %eax\n\t"
> +		      "pushl %ecx\n\t"
> +		      "pushl %edx\n\t"
> +		      "pushl %ebx\n\t"
> +		      "pushl %esp\n\t"
> +		      "pushl %ebp\n\t"
> +		      "pushl %esi\n\t"
> +		      "pushl %edi\n\t"
> +		      "popal\n\t"
>  		      );
>  
>  	init_inregs(&(struct regs){ .eax = 0, .ebx = 1, .ecx = 2, .edx = 3, .esi = 4, .edi = 5, .ebp = 6 });
> @@ -761,9 +761,9 @@ static void test_pusha_popa(void)
>  
>  static void test_iret(void)
>  {
> -	MK_INSN(iret32, "pushf\n\t"
> +	MK_INSN(iret32, "pushfl\n\t"
>  			"pushl %cs\n\t"
> -			"call 1f\n\t" /* a near call will push eip onto the stack */
> +			"calll 1f\n\t" /* a near call will push eip onto the stack */
>  			"jmp 2f\n\t"
>  			"1: iretl\n\t"
>  			"2:\n\t"
> @@ -782,7 +782,7 @@ static void test_iret(void)
>  			      "orl $0xffc18028, %eax\n\t"
>  			      "pushl %eax\n\t"
>  			      "pushl %cs\n\t"
> -			      "call 1f\n\t"
> +			      "calll 1f\n\t"
>  			      "jmp 2f\n\t"
>  			      "1: iretl\n\t"
>  			      "2:\n\t");
> -- 
> 2.28.0
> 

Hi,

I've noticed that the patch has been applied (thanks for that!) but a
test fails for centos-7. It has gcc that doesn't support "-m16":
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/755387059

I'm going to come up with a patch that adds a test for the option and
fixes the issue for older gcc, then bits = 16 would be used for modern
compilers only.

Regards,
Roman
