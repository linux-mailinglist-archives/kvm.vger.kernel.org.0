Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C725D3F4
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBQLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:11:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39623 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBQLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:11:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so18502979wrt.6
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyhCl+Mrz4L1wckzE8zfYLH2ZwFXAn4MRZ3itjkcqYo=;
        b=A7e/VR2RCNXyWkoCNC6XeNrmMDitdVLPnr+9XUxEx78Nr/NcG8ci6nlrm2CRb+yHl6
         nzYtBhhh6puqq9IVc35Zho76E1lvwsBDk7sUgUpR6tHJuscFq6B2VnSM0G19u3auwhA2
         Vv75vr7roI5NtU48fSbKW3oEDDYX99NwkbegnWThiqxZEpwsNafi6c82j44uVPC0G6rU
         UzQTO0izobLpQHQ4VzejWc75VFjA4J2XI8RZZWZRSWP+aFVEUGMkK1Bjw9BIjtC6xiXo
         DBKS6q4il09YbBrt+OTiTRF+kflI5FWIJXeZAOjNabgvC9rsdNMIF9z4EiIX1RahJ4D4
         mn0Q==
X-Gm-Message-State: APjAAAW5OCd4yOzbDNtLGOo8VccZ1dJP/3r7S3J+/e/8TE+FjQYuzskM
        Gyy6NmSu/sfr7oFkUuAn/Egag1zf1gg=
X-Google-Smtp-Source: APXvYqxRDDaaSVHihgQQjtMMT2IFEeIbEU/KVNPgxbUCshT4n1fDX/QZVSHNrjbDpCLzmeA4/zDIYw==
X-Received: by 2002:a05:6000:11ca:: with SMTP id i10mr4668932wrx.56.1562083894263;
        Tue, 02 Jul 2019 09:11:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id n14sm30974607wra.75.2019.07.02.09.11.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:11:33 -0700 (PDT)
Subject: Re: [PATCH] kvm-unit-test: x86: Remove duplicate definitions of
 write_cr4_checking() and put it in library
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20190628212108.23203-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ef77eff1-9b26-f097-d48f-c4f8daa42098@redhat.com>
Date:   Tue, 2 Jul 2019 18:11:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628212108.23203-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/19 23:21, Krish Sadhukhan wrote:
>  ..so that it can be re-used.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> 
> ---
>  lib/x86/desc.c  | 8 ++++++++
>  lib/x86/desc.h  | 1 +
>  x86/access.c    | 8 --------
>  x86/pcid.c      | 8 --------
>  x86/vmx_tests.c | 8 --------
>  x86/xsave.c     | 8 --------
>  6 files changed, 9 insertions(+), 32 deletions(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 0108555..5f37cef 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -251,6 +251,14 @@ unsigned exception_vector(void)
>      return vector;
>  }
>  
> +int write_cr4_checking(unsigned long val)
> +{
> +    asm volatile(ASM_TRY("1f")
> +            "mov %0,%%cr4\n\t"
> +            "1:": : "r" (val));
> +    return exception_vector();
> +}
> +
>  unsigned exception_error_code(void)
>  {
>      unsigned short error_code;
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 7a7358a..9cf823a 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -207,6 +207,7 @@ extern tss64_t tss;
>  #endif
>  
>  unsigned exception_vector(void);
> +int write_cr4_checking(unsigned long val);
>  unsigned exception_error_code(void);
>  bool exception_rflags_rf(void);
>  void set_idt_entry(int vec, void *addr, int dpl);
> diff --git a/x86/access.c b/x86/access.c
> index 9412300..f0d1879 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -171,14 +171,6 @@ typedef struct {
>  
>  static void ac_test_show(ac_test_t *at);
>  
> -static int write_cr4_checking(unsigned long val)
> -{
> -    asm volatile(ASM_TRY("1f")
> -            "mov %0,%%cr4\n\t"
> -            "1:": : "r" (val));
> -    return exception_vector();
> -}
> -
>  static void set_cr0_wp(int wp)
>  {
>      unsigned long cr0 = read_cr0();
> diff --git a/x86/pcid.c b/x86/pcid.c
> index c04fd09..dfabe0e 100644
> --- a/x86/pcid.c
> +++ b/x86/pcid.c
> @@ -21,14 +21,6 @@ static int write_cr0_checking(unsigned long val)
>      return exception_vector();
>  }
>  
> -static int write_cr4_checking(unsigned long val)
> -{
> -    asm volatile(ASM_TRY("1f")
> -                 "mov %0, %%cr4\n\t"
> -                 "1:": : "r" (val));
> -    return exception_vector();
> -}
> -
>  static int invpcid_checking(unsigned long type, void *desc)
>  {
>      asm volatile (ASM_TRY("1f")
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index c48e7fc..7184b06 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7090,14 +7090,6 @@ static void vmentry_movss_shadow_test(void)
>  	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
>  }
>  
> -static int write_cr4_checking(unsigned long val)
> -{
> -	asm volatile(ASM_TRY("1f")
> -		     "mov %0, %%cr4\n\t"
> -		     "1:": : "r" (val));
> -	return exception_vector();
> -}
> -
>  static void vmx_cr_load_test(void)
>  {
>  	struct cpuid _cpuid = cpuid(1);
> diff --git a/x86/xsave.c b/x86/xsave.c
> index 00787bb..ca41bbf 100644
> --- a/x86/xsave.c
> +++ b/x86/xsave.c
> @@ -33,14 +33,6 @@ static int xsetbv_checking(u32 index, u64 value)
>      return exception_vector();
>  }
>  
> -static int write_cr4_checking(unsigned long val)
> -{
> -    asm volatile(ASM_TRY("1f")
> -            "mov %0,%%cr4\n\t"
> -            "1:": : "r" (val));
> -    return exception_vector();
> -}
> -
>  #define CPUID_1_ECX_XSAVE	    (1 << 26)
>  #define CPUID_1_ECX_OSXSAVE	    (1 << 27)
>  static int check_cpuid_1_ecx(unsigned int bit)
> 

Queued, thanks.

Paolo
