Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226E1209AF3
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 10:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390439AbgFYICG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 04:02:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbgFYICF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 04:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593072123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eou9vqm4AHgzTtr7mdfoVHRauo3785uY9+qzNqMF9o=;
        b=FLeN4MicnYn26edy7c0Q7ncHXX7OhjTbXfKdQYtK31VSd7+WpJa7MLnh9D0kXYOjMC/rsf
        pS922V5T5l5XVcwVEpUYwBPXN4/1U/pv4Ed3kh/E1bXlN1VmtYolDJSw6+VAgv87K+RpWn
        iIKHURgf3pDQj9hElsn2eRrfqEOUowI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-3LNpiA5lP6Wg4ZNiBKlGTQ-1; Thu, 25 Jun 2020 04:02:01 -0400
X-MC-Unique: 3LNpiA5lP6Wg4ZNiBKlGTQ-1
Received: by mail-wr1-f69.google.com with SMTP id e11so6310271wrs.2
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 01:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9eou9vqm4AHgzTtr7mdfoVHRauo3785uY9+qzNqMF9o=;
        b=jiMu8FJ/hBgJHWYgK6LMtZxQqAVBfzGVzjR9s/CMjF4eBY3pauEBVUWDH4rxAr+N29
         vz0QuOr0/rkkHPMl9nRIPasdP0Z5mdY0qIaecD4IyCUzP1bVD+weySTJoFY2XxeuM/HP
         0Q0XDatZvW2mb458kJdtJvfR+5dtiF4frHurSbJNC9ZiFzgBbYgdr6XVerVRQgvz+qhV
         zv6yZYqhjd1eTvnJjbgW9DYg7g0jpTQiUp7HvWfgpykQ1oWwMSKwpe80oPZWcrVl770k
         F7JAiKZ1WqWTsTyifomVBgAPO7PU1Im+Nr95IbitVIITfYIaRSL0tCMZ+2kDgmk5dO1g
         RltQ==
X-Gm-Message-State: AOAM531G35o2+hMAJajVMZ49dKJJqjehdOFx4ZzPpjZo8fxPw0g6cnE8
        mn+hedEcAQN2wvTBzaOYLM/o1Ivj4jvfKdYutEw0cYUbaHxhH0htikcOcwTP8DsCcY2NZWZ5wH5
        d+0+JUFL5Wb/O
X-Received: by 2002:a1c:dcc2:: with SMTP id t185mr2098522wmg.91.1593072120560;
        Thu, 25 Jun 2020 01:02:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7EpWGFNqIYa10mLbhT45jOJYdIWf2dOHwjj4fHw6US1mEdfsdFjoqWoc0G2UL9T1ycVUBaQ==
X-Received: by 2002:a1c:dcc2:: with SMTP id t185mr2098499wmg.91.1593072120281;
        Thu, 25 Jun 2020 01:02:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id b18sm29856972wrn.88.2020.06.25.01.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 01:01:59 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] i386: setup segment registers before
 percpu areas
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20200624141429.382157-1-pbonzini@redhat.com>
 <A954DB27-C5E8-435B-A1D7-76D21943F70F@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <64c76417-c89a-65bf-c0cd-4d664d826e90@redhat.com>
Date:   Thu, 25 Jun 2020 10:01:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <A954DB27-C5E8-435B-A1D7-76D21943F70F@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 21:58, Nadav Amit wrote:
>> On Jun 24, 2020, at 7:14 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> The base of the percpu area is stored in the %gs base, and writing
>> to %gs destroys it.  Move setup_segments earlier, before the %gs
>> base is written.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> x86/cstart.S | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/cstart.S b/x86/cstart.S
>> index 5ad70b5..77dc34d 100644
>> --- a/x86/cstart.S
>> +++ b/x86/cstart.S
>> @@ -106,6 +106,7 @@ MSR_GS_BASE = 0xc0000101
>> .globl start
>> start:
>>         mov $stacktop, %esp
>> +        setup_segments
>>         push %ebx
>>         call setup_multiboot
>>         call setup_libcflat
>> @@ -118,7 +119,6 @@ start:
>>
>> prepare_32:
>>         lgdtl gdt32_descr
>> -	setup_segments
>>
>> 	mov %cr4, %eax
>> 	bts $4, %eax  // pse
>> — 
>> 2.26.2
> 
> As I said in a different thread, this change breaks my setup. It is better
> not to make any assumption (or as few as possible) about the GDT content
> after boot and load the GDTR before setting up the segments. So I prefer to
> load the GDT before the segments. How about this change instead of yours?

Yes, this is better.

Paolo

> -- >8 --
> 
> From: Nadav Amit <namit@vmware.com>
> Date: Wed, 24 Jun 2020 19:50:36 +0000
> Subject: [PATCH] x86: load gdt while loading segments
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/cstart.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index dd33d4d..1d8b8ac 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -95,6 +95,8 @@ MSR_GS_BASE = 0xc0000101
>  .endm
>  
>  .macro setup_segments
> +	lgdtl gdt32_descr
> +
>  	mov $0x10, %ax
>  	mov %ax, %ds
>  	mov %ax, %es
> @@ -106,6 +108,8 @@ MSR_GS_BASE = 0xc0000101
>  .globl start
>  start:
>          mov $stacktop, %esp
> +	setup_segments
> +
>          push %ebx
>          call setup_multiboot
>          call setup_libcflat
> @@ -117,9 +121,6 @@ start:
>          jmpl $8, $start32
>  
>  prepare_32:
> -        lgdtl gdt32_descr
> -	setup_segments
> -
>  	mov %cr4, %eax
>  	bts $4, %eax  // pse
>  	mov %eax, %cr4
> 

