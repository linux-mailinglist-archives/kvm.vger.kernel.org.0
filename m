Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2B50038A
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 03:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiDNBWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 21:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbiDNBWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 21:22:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0E81B7DE
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 18:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649899175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v72fBiHQf/8zhWUKxWfFXSTDVmBo353pLbH5+QeYjP0=;
        b=gi1WkM9I5t8IFasz2nYA4F83TDWCgKWSElMTlRc8BjRa+S3EUT1T6H1baawToC/RYmqs2s
        UtKD3vIHhsw3OUf4jPJD5edlpu0yJUcDXz9I0m/cWq9msN9bW/W4A8QS+DgiAMdp0gBIkZ
        NXXE1Gmx0di+Ew9f3pm0ZzpXNZFlbm0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-bhZ8-vnFNUeFmJmLMgiPbA-1; Wed, 13 Apr 2022 21:19:34 -0400
X-MC-Unique: bhZ8-vnFNUeFmJmLMgiPbA-1
Received: by mail-il1-f197.google.com with SMTP id j16-20020a056e02219000b002cbe5b76195so114489ila.9
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 18:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v72fBiHQf/8zhWUKxWfFXSTDVmBo353pLbH5+QeYjP0=;
        b=Fxb54KNCBRBZHVgY3FPgkSrhN2lgGyFc5Vh1eTJ94Ziii8wNL5v98oA7uK4EYykl9A
         TjbD7mvu+0tmSCZlRodpNplLw0iqAJO//Ced2xinDqTWJ6kmt3uFO0nw8QjyIXrKv+HN
         1FLVtbbFH5FN3UbCJgAWr/UsF6Nj1E9g7eP9Xi85HzHfuasqWXVYj0ZRJ8lRTf6moLoo
         pGayTAni9YvyEGeuN41tBW/U383QJiQzz+9qr3godxSjvCnVC/XPNtYzWc4jFRSGsi1U
         hsIrfJrYkUs9GOHdN/A1OUoADBbqjT2krD375MKMsb85gb230r/S6sX4M8MpOROfFHL6
         qbMw==
X-Gm-Message-State: AOAM531MZSeRFy8EPgPJlBnVjpk8fg1K7yKZ7MGrkfjjanAzbm7coPMg
        /Y/SzRhYhNumRQzbnWoeS96rV3uY3j5ZThSZv55kzQ+uZwEQC2IhidXHi9TmZLjJd7iZjpkS3Ff
        doQHMzOkN909Ce/DQsBh4f/JRbicGpae1iBEuMkiG5PxvHXhEXrbeTzz1hN5grw==
X-Received: by 2002:a02:224d:0:b0:321:370b:6d59 with SMTP id o74-20020a02224d000000b00321370b6d59mr144514jao.104.1649899173739;
        Wed, 13 Apr 2022 18:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxREn9EJUMa5YNi7ZdHxBmXInmBmriVMoBCjGPUL51SMpa8tCOLf8aruSagFkhoUpIQbMP8HQ==
X-Received: by 2002:a02:224d:0:b0:321:370b:6d59 with SMTP id o74-20020a02224d000000b00321370b6d59mr144497jao.104.1649899173438;
        Wed, 13 Apr 2022 18:19:33 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id e4-20020a056e020b2400b002ca9ffbb8fesm335323ilu.72.2022.04.13.18.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:19:33 -0700 (PDT)
Date:   Wed, 13 Apr 2022 21:19:31 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
Message-ID: <Yld2o23GafZobGZy@xz-m1.local>
References: <20220414010703.72683-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220414010703.72683-1-peterx@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 09:07:03PM -0400, Peter Xu wrote:
> Our QE team reported test failure on access_tracking_perf_test:
> 
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fffbffff000
> 
> Populating memory             : 0.684014577s
> Writing to populated memory   : 0.006230175s
> Reading from populated memory : 0.004557805s
> ==== Test Assertion Failure ====
>   lib/kvm_util.c:1411: false
>   pid=125806 tid=125809 errno=4 - Interrupted system call
>      1  0x0000000000402f7c: addr_gpa2hva at kvm_util.c:1411
>      2   (inlined by) addr_gpa2hva at kvm_util.c:1405
>      3  0x0000000000401f52: lookup_pfn at access_tracking_perf_test.c:98
>      4   (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
>      5   (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
>      6  0x00007fefe9ff81ce: ?? ??:0
>      7  0x00007fefe9c64d82: ?? ??:0
>   No vm physical memory at 0xffbffff000
> 
> And I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46
> bits PA.
> 
> It turns out that the address translation for clearing idle page tracking
> returned wrong result, in which addr_gva2gpa()'s last step should have
> treated "pte[index[0]].pfn" to be a 32bit value.  In above case the GPA
> address 0x3fffbffff000 got cut-off into 0xffbffff000, then it caused
> further lookup failure in the gpa2hva mapping.
> 
> I didn't yet check any other test that may fail too on some hosts, but
> logically any test using addr_gva2gpa() could suffer.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
> Signed-off-by: Peter Xu <peterx@redhat.com>

Ah sorry I forgot to add:

Reported-by: nanliu@redhat.com

Btw, I didn't dig the history for stable trees (yet..), but the bug seems
to be there for a while, hence I didn't attach Fixes so far.

> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 9f000dfb5594..6c356fb4a9bf 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -587,7 +587,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	if (!pte[index[0]].present)
>  		goto unmapped_gva;
>  
> -	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> +	return ((vm_paddr_t)pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
>  
>  unmapped_gva:
>  	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
> -- 
> 2.32.0
> 

-- 
Peter Xu

