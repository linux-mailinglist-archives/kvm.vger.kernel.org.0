Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730D65089F5
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 16:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379287AbiDTOEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 10:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379283AbiDTOEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 10:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B79303F881
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 07:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650463277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6dWgrGMk58Q4Et8ectVGURfERYkJuTF84oKkc2EBf/s=;
        b=NuYCfMFIqyMDZnwDzlli4nR25/OoeDWMWQk0skcGfm8ZnhsB1dbwE/0MkwIAbqQZR0CTsD
        CZI6vSHEc9cHDs6Jt76QCZv7zvVLfsagVys6lMIOEih0la8irVbGZJ61qMPCLn99uXmvN/
        kG0d/qHclE5EkEZuQ+aRoSNotw1herY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-mS5GxOyyOo2ESrMLLE_32g-1; Wed, 20 Apr 2022 10:01:16 -0400
X-MC-Unique: mS5GxOyyOo2ESrMLLE_32g-1
Received: by mail-io1-f70.google.com with SMTP id o9-20020a0566022e0900b00654b599b1eeso1251580iow.21
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 07:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6dWgrGMk58Q4Et8ectVGURfERYkJuTF84oKkc2EBf/s=;
        b=e05IK0jRZEfqSePPiWQqQXNyEzREbuHKcwui/36q3eRvv6BG341cd6kt0IF0Z5VfJp
         J/jjxSw/+xq3I2z4im7hgG7xEYfNmQVU7TIPs4AytOrDfnvJNZlYP6W9VZJjn/vvJpf9
         yrNuEdT4mPYfHegBTwPWcGWtkOwkv19k7qo3IIl7UfsLPnzXbKNxusyijPqBHY1rblk+
         9pzA/UhWu72AiCIQR1iAqyrwk9wSnZNNwhuYrqhicl88hGJpyR/bUVjdvYV5ySXRNewv
         8kOjTiPJnYGsKkSwEQNqE872MVo0RekqLdKbiXYbHbBZybCy0L66FUZfQa5cb6hqlsRT
         lEiw==
X-Gm-Message-State: AOAM533XVUoYeJbLSjh5wGHwVI6nDSAgBBtduumOX0uLHJvO2LCKijZg
        +K0os3CdSkTJTsX1PsG/2UIvWeVjs3YjNWN21c3+P/BAiYQWF2RusQaCpUV7FIYoAT0wVjOoEGa
        jrDaT7uiGvEBs
X-Received: by 2002:a05:6638:380e:b0:32a:777c:607f with SMTP id i14-20020a056638380e00b0032a777c607fmr3733037jav.47.1650463275404;
        Wed, 20 Apr 2022 07:01:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrbSBHT7Qold9RT6iIj368nVCg7wwcQRqm4XTm0xUjEZXcAj1xlH0C5Yv3q6FhP2UXQNLn2Q==
X-Received: by 2002:a05:6638:380e:b0:32a:777c:607f with SMTP id i14-20020a056638380e00b0032a777c607fmr3733020jav.47.1650463275188;
        Wed, 20 Apr 2022 07:01:15 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id m8-20020a92cac8000000b002ca9d826c3fsm10823497ilq.34.2022.04.20.07.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:01:14 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:01:13 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH] kvm: selftests: do not use bitfields larger than 32-bits
 for PTEs
Message-ID: <YmASKf+pMma+Qf0O@xz-m1.local>
References: <20220420103624.1143824-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420103624.1143824-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 06:36:24AM -0400, Paolo Bonzini wrote:
> Red Hat's QE team reported test failure on access_tracking_perf_test:
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
> I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46 bits
> PA.
> 
> It turns out that the address translation for clearing idle page tracking
> returned a wrong result; addr_gva2gpa()'s last step, which is based on
> "pte[index[0]].pfn", did the calculation with 40 bits length and the
> high 12 bits got truncated.  In above case the GPA address to be returned
> should be 0x3fffbffff000 for GVA 0xc0000000, but it got truncated into
> 0xffbffff000 and the subsequent gpa2hva lookup failed.
> 
> The width of operations on bit fields greater than 32-bit is
> implementation defined, and differs between GCC (which uses the bitfield
> precision) and clang (which uses 64-bit arithmetic), so this is a
> potential minefield.  Remove the bit fields and using manual masking
> instead.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
> Reported-by: Peter Xu <peterx@redhat.com>

Should be:

Reported-by: Nana Liu <nanliu@redhat.com>

Meanwhile:

Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

