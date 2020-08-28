Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5654D25541C
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 07:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgH1FuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 01:50:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725858AbgH1FuF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 01:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598593803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qC3irxDvwrCIsxLOtyMYReUoZq28diJc1yoLm+PnA3U=;
        b=CPx0g3BmulkvLTdw0SYPHzyu7TWBcunIuWsduSili+nSTtA+IneqazYOY5sd7YxZ+zUHrW
        E2VT8zQIUUB1AxBwSCOxeg9ymwfyfAlZepH3y5+XTs9caZzDl8cPOAVHfr0+oTCf/hHG9+
        lEG/gEuG8GAQY5MsZ9cvCbMcaddwOyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-WHkob5T8NSeZCukMof6l8A-1; Fri, 28 Aug 2020 01:50:00 -0400
X-MC-Unique: WHkob5T8NSeZCukMof6l8A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C805864080;
        Fri, 28 Aug 2020 05:49:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A36F85D9F1;
        Fri, 28 Aug 2020 05:49:58 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 5/7] lib: x86: Use portable format macros
 for uint32_t
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-6-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e22f11ca-3927-9dd5-d381-7886c82603cd@redhat.com>
Date:   Fri, 28 Aug 2020 07:49:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200810130618.16066-6-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2020 15.06, Roman Bolshakov wrote:
> Compilation of the files fails on ARCH=i386 with i686-elf gcc because
> they use "%x" or "%d" format specifier that does not match the actual
> size of uint32_t:
> 
> x86/s3.c: In function ‘main’:
> x86/s3.c:53:35: error: format ‘%x’ expects argument of type ‘unsigned int’, but argument 2 has type ‘u32’ {aka ‘long unsigned int’}
> [-Werror=format=]
>    53 |  printf("PM1a event registers at %x\n", fadt->pm1a_evt_blk);
>       |                                  ~^     ~~~~~~~~~~~~~~~~~~
>       |                                   |         |
>       |                                   |         u32 {aka long unsigned int}
>       |                                   unsigned int
>       |                                  %lx
> 
> Use PRIx32 instead of "x" and PRId32 instead of "d" to take into account
> u32_long case.
> 
> Cc: Alex Bennée <alex.bennee@linaro.org>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Cameron Esfahani <dirty@apple.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  lib/pci.c     | 2 +-
>  x86/asyncpf.c | 2 +-
>  x86/msr.c     | 3 ++-
>  x86/s3.c      | 2 +-
>  4 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/pci.c b/lib/pci.c
> index daa33e1..175caf0 100644
> --- a/lib/pci.c
> +++ b/lib/pci.c
> @@ -248,7 +248,7 @@ void pci_bar_print(struct pci_dev *dev, int bar_num)
>  		printf("BAR#%d,%d [%" PRIx64 "-%" PRIx64 " ",
>  		       bar_num, bar_num + 1, start, end);
>  	} else {
> -		printf("BAR#%d [%02x-%02x ",
> +		printf("BAR#%d [%02" PRIx32 "-%02" PRIx32 " ",
>  		       bar_num, (uint32_t)start, (uint32_t)end);
>  	}
>  
> diff --git a/x86/asyncpf.c b/x86/asyncpf.c
> index 305a923..8239e16 100644
> --- a/x86/asyncpf.c
> +++ b/x86/asyncpf.c
> @@ -78,7 +78,7 @@ static void pf_isr(struct ex_regs *r)
>  			phys = 0;
>  			break;
>  		default:
> -			report(false, "unexpected async pf reason %d", reason);
> +			report(false, "unexpected async pf reason %" PRId32, reason);
>  			break;
>  	}
>  }
> diff --git a/x86/msr.c b/x86/msr.c
> index f7539c3..ce5dabe 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -89,7 +89,8 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
>      wrmsr(msr_index, input);
>      r = rdmsr(msr_index);
>      if (expected != r) {
> -        printf("testing %s: output = %#x:%#x expected = %#x:%#x\n", sptr,
> +        printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
> +	       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
>                 (u32)(r >> 32), (u32)r, (u32)(expected >> 32), (u32)expected);
>      }
>      report(expected == r, "%s", sptr);
> diff --git a/x86/s3.c b/x86/s3.c
> index da2d00c..6e41d0c 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -50,7 +50,7 @@ int main(int argc, char **argv)
>  		*resume_vec++ = *addr;
>  	printf("copy resume code from %p\n", &resume_start);
>  
> -	printf("PM1a event registers at %x\n", fadt->pm1a_evt_blk);
> +	printf("PM1a event registers at %" PRIx32 "\n", fadt->pm1a_evt_blk);
>  	outw(0x400, fadt->pm1a_evt_blk + 2);
>  
>  	/* Setup RTC alarm to wake up on the next second.  */
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

