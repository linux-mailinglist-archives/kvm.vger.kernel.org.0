Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF77D1D6434
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 23:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgEPVTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 17:19:21 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35320 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726592AbgEPVTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 17:19:21 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D3E204C831;
        Sat, 16 May 2020 21:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1589663956;
         x=1591478357; bh=h8c4WbAZrg5j5fotwzHP9ye4A/6BB8mqzdtMHWTCJ/U=; b=
        hPJu8yx8gHEJtNx0FQWfejj4TPrdNTIjrNGZFzOxq6BKqWd7hBL8ptN5WRYX06GG
        xSBJlUYiEE2IljNYOvHuVw7K0zzgflsYmwmEceaj4IGa4B0feIO14WdCEEiRb8u7
        hj0ILEPc3sD/eHWqLRdJ4MFhXDWv4CRUY5DLPUbfyeM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OfvQSpbdHUhq; Sun, 17 May 2020 00:19:16 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 66A9547CF8;
        Sun, 17 May 2020 00:19:16 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sun, 17
 May 2020 00:19:18 +0300
Date:   Sun, 17 May 2020 00:19:17 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: realmode: Test interrupt delivery
 after STI
Message-ID: <20200516211917.GA75422@SPB-NB-133.local>
References: <20200329071125.79253-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200329071125.79253-1-r.bolshakov@yadro.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

n Sun, Mar 29, 2020 at 10:11:25AM +0300, Roman Bolshakov wrote:
> If interrupts are disabled, STI is inhibiting interrupts for the
> instruction following it. If STI is followed by HLT, the CPU is going to
> handle all pending or new interrupts as soon as HLT is executed.
> 
> Test if emulator properly clears inhibition state and allows the
> scenario outlined above.
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  x86/realmode.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 31f84d0..3518224 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -814,6 +814,26 @@ static void test_int(void)
>  	report("int 1", 0, 1);
>  }
>  
> +static void test_sti_inhibit(void)
> +{
> +	init_inregs(NULL);
> +
> +	*(u32 *)(0x73 * 4) = 0x1000; /* Store IRQ 11 handler in the IDT */
> +	*(u8 *)(0x1000) = 0xcf; /* 0x1000 contains an IRET instruction */
> +
> +	MK_INSN(sti_inhibit, "cli\n\t"
> +			     "movw $0x200b, %dx\n\t"
> +			     "movl $1, %eax\n\t"
> +			     "outl %eax, %dx\n\t" /* Set IRQ11 */
> +			     "movl $0, %eax\n\t"
> +			     "outl %eax, %dx\n\t" /* Clear IRQ11 */
> +			     "sti\n\t"
> +			     "hlt\n\t");
> +	exec_in_big_real_mode(&insn_sti_inhibit);
> +
> +	report("sti inhibit", ~0, 1);
> +}
> +
>  static void test_imul(void)
>  {
>  	MK_INSN(imul8_1, "mov $2, %al\n\t"
> @@ -1739,6 +1759,7 @@ void realmode_start(void)
>  	test_xchg();
>  	test_iret();
>  	test_int();
> +	test_sti_inhibit();
>  	test_imul();
>  	test_mul();
>  	test_div();
> -- 
> 2.24.1
> 

Hi,

Should I resend the patch?
And this one: https://patchwork.kernel.org/cover/11449525/ ?

Thanks,
Roman
