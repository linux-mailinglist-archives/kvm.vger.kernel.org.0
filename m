Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D092BCFD70
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 17:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfJHPTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 11:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfJHPTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 11:19:32 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6D9D2A09CD
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 15:19:31 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id g67so1137127wmg.4
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 08:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sORjwRax29zB72Q745OUsJH6bRaFO5E6lgCn7aZafIc=;
        b=Ye1tuqF4t54pIvZOpASX/0O/0DHM4YHDsGR0piNS31tS4P9iAgAsRZNlu/XGh0ahgF
         IyD2XhUxBC6horxjRDkrl/uAXkRudosatnFrOkzKf0gC6dh0poWjMFC7rTfXaM/flSU5
         jr4Eg4OkJ1vi03wxdKfn8AzqBi4YmWUhfpL6LcOEV4RuQpe5ahDHc3VgjFl8N+pHw2Zo
         Ica0n8q2xvYwon4Yj8I0zPHffWp0hmE1GmOyiYuARASiDwSjVCrwruljWqeQWsK9I6oy
         2nz5lAnK1AOupizSPf8Ob+fZXUuKY8AdRaEpnVWRHrBzj+YtPYuRI8I2xo0o3uQVjWrg
         mrRA==
X-Gm-Message-State: APjAAAXutHImo3f/zHaCRSVJ342a4/gyXFi2ttXK1WN0gMpqV2liTv9j
        sl6UdxdgND0iH0fxiSbGWj/2FBuRypvBg7a9UGuPnfKm/+D1XCc4329vVtJk9FtkEbNlU3/FXjz
        fyk70dXcDfQAp
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr26768352wrq.292.1570547969736;
        Tue, 08 Oct 2019 08:19:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqznG8gwxLy5oOoVyyO7sS7ti/Nynrs3qR+xlBZEyjgJ6IT1TOSUarYOUDcaHfVNjH4535/Ekw==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr26768329wrq.292.1570547969410;
        Tue, 08 Oct 2019 08:19:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id v16sm18985572wrt.12.2019.10.08.08.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:19:28 -0700 (PDT)
Subject: Re: [PATCH RFC] selftests: kvm: fix sync_regs_test with newer gccs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20191008145717.17841-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <28fea32c-3f64-76ef-f38e-a3a5de22cb25@redhat.com>
Date:   Tue, 8 Oct 2019 17:19:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008145717.17841-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 16:57, Vitaly Kuznetsov wrote:
> Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
>  guest asm") was intended to make test more gcc-proof, however, the result
> is exactly the opposite: on newer gccs (e.g. 8.2.1)  the test breaks with
> 
> ==== Test Assertion Failure ====
>   x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
>   pid=14170 tid=14170 - Invalid argument
>      1	0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
>      2	0x00007f413fb66412: ?? ??:0
>      3	0x000000000040191d: _start at ??:?
>   rbx sync regs value incorrect 0x1.
> 
> Disassembly show the following:
> 
> 00000000004019e0 <guest_code>:
>   4019e0:       55                      push   %rbp
>   4019e1:       89 dd                   mov    %ebx,%ebp
>   4019e3:       53                      push   %rbx
>   4019e4:       48 83 ec 08             sub    $0x8,%rsp
>   4019e8:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
>   4019ef:       00
>   4019f0:       31 c9                   xor    %ecx,%ecx
>   4019f2:       ba 10 90 40 00          mov    $0x409010,%edx
>   4019f7:       be 02 00 00 00          mov    $0x2,%esi
>   4019fc:       31 c0                   xor    %eax,%eax
>   4019fe:       bf 01 00 00 00          mov    $0x1,%edi
>   401a03:       83 c5 01                add    $0x1,%ebp
>   401a06:       e8 15 2b 00 00          callq  404520 <ucall>
>   401a0b:       89 eb                   mov    %ebp,%ebx
>   401a0d:       eb e1                   jmp    4019f0 <guest_code+0x10>
>   401a0f:       90                      nop
> 
> and apparently this is broken. If we add 'volatile' qualifier to 'stage'
> we get the following code:
> 
> 00000000004019e0 <guest_code>:
>   4019e0:       53                      push   %rbx
>   4019e1:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
>   4019e8:       31 c9                   xor    %ecx,%ecx
>   4019ea:       ba 10 90 40 00          mov    $0x409010,%edx
>   4019ef:       be 02 00 00 00          mov    $0x2,%esi
>   4019f4:       31 c0                   xor    %eax,%eax
>   4019f6:       bf 01 00 00 00          mov    $0x1,%edi
>   4019fb:       83 c3 01                add    $0x1,%ebx
>   4019fe:       e8 1d 2b 00 00          callq  404520 <ucall>
>   401a03:       eb e3                   jmp    4019e8 <guest_code+0x8>
>   401a05:       66 66 2e 0f 1f 84 00    data16 nopw %cs:0x0(%rax,%rax,1)
>   401a0c:       00 00 00 00
> 
> and everything seems to work. The only problem is that I now get a new
> warning from gcc:
> 
> x86_64/sync_regs_test.c: In function ‘guest_code’:
> x86_64/sync_regs_test.c:25:6: warning: optimization may eliminate reads
>  and/or writes to register variables [-Wvolatile-register-var]
> 
> checkpatch.pl doesn't like me either:
> 
> "WARNING: Use of volatile is usually wrong: see
>  Documentation/process/volatile-considered-harmful.rst"
> 
> I can think of an 'ultimate' solution to open code ucall() in a single
> asm block making sure the register we need is preserved but this looks
> like an overkill.

It is probably the best idea though.  It's a processor-specific test
anyway.  It also doesn't need the full ucall(), just a single in
instruction will do.

Paolo

> Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/sync_regs_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> index 11c2a70a7b87..25c54250d591 100644
> --- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> @@ -28,7 +28,7 @@ void guest_code(void)
>  	 * use a callee-save register, otherwise the compiler
>  	 * saves it around the call to GUEST_SYNC.
>  	 */
> -	register u32 stage asm("rbx");
> +	register volatile u32 stage asm("rbx");
>  	for (;;) {
>  		GUEST_SYNC(0);
>  		stage++;
> 
