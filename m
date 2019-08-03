Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F280497
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 08:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfHCGGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 02:06:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40135 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfHCGGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 02:06:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so68266457wmj.5
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 23:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Y2MfltBjM4w3rpzVLmcXYSB8ElHIZX5s1+oCLpyexA=;
        b=hEtUAC/VNhI764peITQ6qHVSvXN+POf8uYw8YUufGRw07qcKCmH7dlVkLaID5WZLI8
         Z9X2rfz1ZQZDyePoYS7rlJr5zYGMqTtjpFDEm/AjYNjngwMnnqM6EaX4/AEERljjnCU3
         cHd/P/UhON63qGDrD/v84tqKTrq1p+/KbeLyWSc7gCjmqgvWWnTFxdlB/0SLI9PniiSF
         kmLI/dsL1Cny1c68IMTN2qBwdno9V7WEX/HFA5EfCctziH3x4H0XY1RURaZZMo1vSWtZ
         3ZAscJgC4JvN66rTet+yHBYtyMnzh5rKFx+UHWh59hUndpH3/ZGQcopP5WUn69Ae/s1W
         hCqw==
X-Gm-Message-State: APjAAAWYaR8Rs24V3+AMef8XkGpgf9zra8yNCf73RBbj2RiXTqjD50CQ
        xhlCdT5VMVVhRxmC3IuJ7C+HBAs4qvs=
X-Google-Smtp-Source: APXvYqzpLlLz6AtIOQHOfqmjKUWfD0j9N6DoFMoge29TZOBuNjelO6Fgu+0hZ8KTBoKSRQp5sebdxQ==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr7961511wmk.40.1564812405747;
        Fri, 02 Aug 2019 23:06:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id j17sm128393516wrb.35.2019.08.02.23.06.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:06:45 -0700 (PDT)
Subject: Re: [PATCH 0/2] kvm-unit-test: x86: Implement a generic wrapper for
 cpuid/cpuid_indexed calls
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <960ef4d5-93e5-e9cd-3507-f0358abb4579@redhat.com>
Date:   Sat, 3 Aug 2019 08:06:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 23:52, Krish Sadhukhan wrote:
> This patch-set implements a generic wrapper for the cpuid/cpuid_index calls in
> the kvm-unit-test source code. This is similar to what we have in the kernel
> source code except that here we retrieve the data on the fly.
> This implementation makes it convenient to define various CPUID feature bits
> in one place and re-use them in places which need to check if a given CPUID
> feature bit is supported by the current CPU.
> 
> 
> [PATCH 1/2] kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed
> [PATCH 2/2] kvm-unit-test: x86: Replace cpuid/cpuid_indexed calls with
> 
>  lib/x86/processor.h       | 147 +++++++++++++++++++++++++++++++++++-----------
>  x86/access.c              |  13 ++--
>  x86/apic.c                |   8 +--
>  x86/emulator.c            |   4 +-
>  x86/memory.c              |  16 ++---
>  x86/pcid.c                |  10 +---
>  x86/pku.c                 |   3 +-
>  x86/smap.c                |   4 +-
>  x86/svm.c                 |   6 +-
>  x86/tsc.c                 |  16 +----
>  x86/tsc_adjust.c          |   2 +-
>  x86/tscdeadline_latency.c |   2 +-
>  x86/umip.c                |   6 +-
>  x86/vmexit.c              |   6 +-
>  x86/vmx.c                 |   2 +-
>  x86/vmx_tests.c           |  11 ++--
>  x86/xsave.c               |  15 ++---
>  17 files changed, 153 insertions(+), 118 deletions(-)
> 
> Krish Sadhukhan (2):
>       x86: Implement a generic wrapper for cpuid/cpuid_indexed functions
>       x86: Replace cpuid/cpuid_indexed calls with this_cpu_has()
> 

Queued, thanks.

Paolo
