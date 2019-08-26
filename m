Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83A69CB6C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 10:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfHZIS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 04:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbfHZIS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 04:18:58 -0400
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E60FE87642
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 08:18:57 +0000 (UTC)
Received: by mail-pf1-f197.google.com with SMTP id q12so11684615pfl.14
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 01:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cGw1QOvAWWRWVuj0lRT4bdgXpIN7Y746gADKiInC19M=;
        b=LEgoZzLEuK0nOnrzLKEAg0uZXL/g4RT9GlP910DQ+qjNEHcdk94Aw+Kt9BbM+4dxGq
         TNP1LLGqSVvZi4JtSfuiwuLBKBjxq5Y+G90mMpEvuOyrg2UmvrkSuBfrgIrx9QIpXgxo
         XCocfS3/wAHSnA6kh/gKWd8p/hzaIWjzgDHJDnD3UDVjmcJkSmh/AMrTc5YC1BEti3Ni
         Ybe8seNa05Xuss41B3f7V5bWqxPODLGR8GtzCjup5pEOQdPcQQqGIJzwUlldooHqqrtI
         HC3xuUdR0xUSYb+hreOI8Nm1JeB77nbkQQevGx8tXIHD5ubUpD8hgGaKYwvWSuX7pkfo
         W5dA==
X-Gm-Message-State: APjAAAVoGNAgVa9ZaCpK2FPWApb1rxt4NjrP7pW6IVVmzpnVCDr9YJqJ
        IZum4Rx6CXdxxdJg8J7pHv2ZlsD55RN7vCWf5bNJpq2nZ4ydhs/DwLVkIwfhhsDA42LCV0kZiYc
        QeuP2hXpIM9e1
X-Received: by 2002:a62:e401:: with SMTP id r1mr19422803pfh.193.1566807537452;
        Mon, 26 Aug 2019 01:18:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwWAprroueNItrwfSiofRmqFj877bf2csmLQNwgiA8R9NNLITxbw7s1DN/MGKT6MZzTE1+TKg==
X-Received: by 2002:a62:e401:: with SMTP id r1mr19422783pfh.193.1566807537229;
        Mon, 26 Aug 2019 01:18:57 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p8sm21990998pfq.129.2019.08.26.01.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 01:18:56 -0700 (PDT)
Date:   Mon, 26 Aug 2019 16:18:47 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
Message-ID: <20190826081847.GB1785@xz-x1>
References: <20190826075728.21646-1-peterx@redhat.com>
 <00533992-f6e9-3c06-3342-b2b8a95b61d7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00533992-f6e9-3c06-3342-b2b8a95b61d7@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 10:11:34AM +0200, Thomas Huth wrote:
> On 26/08/2019 09.57, Peter Xu wrote:
> > The dirty_log_test is failing on some old machines like Xeon E3-1220
> > with tripple faults when writting to the tracked memory region:
> > 
> >   Test iterations: 32, interval: 10 (ms)
> >   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> >   guest physical test memory offset: 0x7fbffef000
> >   ==== Test Assertion Failure ====
> >   dirty_log_test.c:138: false
> >   pid=6137 tid=6139 - Success
> >      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
> >      2  0x00007f3dd9e392dd: ?? ??:0
> >      3  0x00007f3dd9b6a132: ?? ??:0
> >   Invalid guest sync status: exit_reason=SHUTDOWN
> > 
> > It's because previously we moved the testing memory region from a
> > static place (1G) to the top of the system's physical address space,
> > meanwhile we stick to 39 bits PA for all the x86_64 machines.  That's
> > not true for machines like Xeon E3-1220 where it only supports 36.
> > 
> > Let's unbreak this test by dynamically detect PA width from CPUID
> > 0x80000008.  Meanwhile, even allow kvm_get_supported_cpuid_index() to
> > fail.  I don't know whether that could be useful because I think
> > 0x80000008 should be there for all x86_64 hosts, but I also think it's
> > not really helpful to assert in the kvm_get_supported_cpuid_index().
> [...]
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 6cb34a0fa200..9de2fd310ac8 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -760,9 +760,6 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
> >  			break;
> >  		}
> >  	}
> > -
> > -	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
> > -		    function, index);
> >  	return entry;
> >  }
> 
> You should also adjust the comment of the function. It currently says
> "Never returns NULL". Not it can return NULL.

Yeh that's better.

> 
> And maybe add a TEST_ASSERT() to the other callers instead, which do not
> expect a NULL to be returned?

I think it's fine because it's the same as moving the assert from here
to the callers because when the caller uses entry->xxx it'll assert. :)

Thanks,

-- 
Peter Xu
