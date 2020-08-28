Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E158255416
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 07:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgH1Fog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 01:44:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgH1Fog (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 01:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598593475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NsNMtElLtmGEI19qz2RntAXjB6QDo6KUetwCptqxdI=;
        b=DVXALtJUHsaPspI427IxUcCmuzjCPKLzDIVIFw8Oy1ZQXs63XvNxH/5NNoS0EHP9ClrFgU
        G2pQC9klkLi3X55X56xbrY50ao8387ZzcKPWV3tMORQFonwsIHvDPZmQpUw7dvUodkAcq+
        Pjs4AmGutFnIWxV4ei+7o39rHm9CAMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-cMi_6B1BN86iysuhw9f42A-1; Fri, 28 Aug 2020 01:44:30 -0400
X-MC-Unique: cMi_6B1BN86iysuhw9f42A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0A9F8030CA;
        Fri, 28 Aug 2020 05:44:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B98361C4;
        Fri, 28 Aug 2020 05:44:28 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/7] x86: Makefile: Fix linkage of realmode
 on x86_64-elf binutils
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-4-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <89a13eb4-81af-5a51-191f-9017cf70980f@redhat.com>
Date:   Fri, 28 Aug 2020 07:44:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200810130618.16066-4-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2020 15.06, Roman Bolshakov wrote:
> link spec [1][2] is empty on x86_64-elf-gcc, i.e. -m32 is not propogated
> to the linker as "-m elf_i386" and that causes the error:
> 
>   /usr/local/opt/x86_64-elf-binutils/bin/x86_64-elf-ld: i386 architecture
>   of input file `x86/realmode.o' is incompatible with i386:x86-64 output
> 
> 1. https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html
> 2. https://gcc.gnu.org/onlinedocs/gccint/Driver.html
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  x86/Makefile.common | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 2ea9c9f..8230ac0 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -66,7 +66,8 @@ test_cases: $(tests-common) $(tests)
>  $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
>  
>  $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
> -	$(CC) -m32 -nostdlib -o $@ -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
> +	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
> +	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  
>  $(TEST_DIR)/realmode.o: bits = 32

Reviewed-by: Thomas Huth <thuth@redhat.com>

