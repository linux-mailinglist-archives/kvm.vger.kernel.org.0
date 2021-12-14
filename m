Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C12C47438D
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 14:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhLNNey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 08:34:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229902AbhLNNex (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 08:34:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639488893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ks3M5C8EaCK4GjMRAAKSo6Eyx91OR1oex8ha7Ihy6PQ=;
        b=V1vNl5hxufoW6Uo2LjG2tv68PV21tQwFIrBsADuUJIlUXiK6BPlMOE6lFscN5fABWoH84P
        cRkxncO8CyFxlmjlOxNu1UICHzVQP96/salTnrJd7Tkp0emYf4Q+vXfLx+nCQ9F0emRp+o
        ti7EaAly2sX6NsbA+9XjJkVU0I/YjHE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-V_5TZXitObWEdHXwtthqNA-1; Tue, 14 Dec 2021 08:34:52 -0500
X-MC-Unique: V_5TZXitObWEdHXwtthqNA-1
Received: by mail-ed1-f71.google.com with SMTP id p4-20020aa7d304000000b003e7ef120a37so16916626edq.16
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 05:34:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ks3M5C8EaCK4GjMRAAKSo6Eyx91OR1oex8ha7Ihy6PQ=;
        b=fo3Jgc4MBdv75Au4OCCGFwfRJ8wxJMfZ2+6dENwsEbZyq4oTcMbUt8Tg7nBjAXIk8i
         lDJ1ycd1EFecfRPXuVtoQ//FFc8cbirJmnIVSYRUCmV17suVNCdcnR8+2tNeBRFPAKi8
         VpIUs9dpfTcfLXRqy7dBxr4TnJJulj6xJar4o5n2rtKBZuCeQEiIKrTOUljxvqdV12Jt
         Eye2FGtwgl/9xilIFOIt3WYn3w/PlLctn+9MOyQd5HVJaQbWic2JbwsRIO4HXQg7ZnAY
         yZhWKY+LTw5J9v8VeytYF2Jt6zmNH+veERZ7eFA/dM66R6508Z0kh7V2kxL0cp97mHjB
         +AnQ==
X-Gm-Message-State: AOAM531IufRMAn0hQ/bFnhkxyRnxGnbre6x4t6ii7s2huejkfSW4z5/k
        KeWs3zhw0S/sP9+lIYNGcnqtsDTKspedApiVUk132zTm/VUWblaJBUw1auv+i5+KYDyxNdFKWEU
        PRg9PDvuuR96b
X-Received: by 2002:a17:907:7f9e:: with SMTP id qk30mr5484647ejc.238.1639488891030;
        Tue, 14 Dec 2021 05:34:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqM5EYX790yLEJfRzJAdIh/+o6T7TWGGY3j7D/yNFbJe/W4j2ZKaCKFYpB7QwPBGLGQXJupg==
X-Received: by 2002:a17:907:7f9e:: with SMTP id qk30mr5484625ejc.238.1639488890815;
        Tue, 14 Dec 2021 05:34:50 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id sh33sm7367278ejc.56.2021.12.14.05.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 05:34:50 -0800 (PST)
Date:   Tue, 14 Dec 2021 14:34:48 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oupton@google.com, yuzenghui@huawei.com, jingzhangos@google.com,
        pshier@google.com, rananta@google.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for
 debug state
Message-ID: <20211214133448.6yjlbputjfabzftq@gator.home>
References: <20211210165804.1623253-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210165804.1623253-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 08:58:01AM -0800, Ricardo Koller wrote:
> Add some tests for checking that we can migrate debug state correctly: setup
> some breakpoints/watchpoints/single-stepping, migrate, and then check that we
> get the expected exceptions.
> 
> The 3 patches in this series add tests for breakpoints, watchpoints, and
> single-stepping one patch at a time.  Each patch adds a migration test and a
> sanity test (to test that debugging works with no migration).
> 
> Note that this is limited to 64-bits and a single vcpu. Also note that some of
> the code, like reset_debug_state, is borrowed from kvm selftests.
> 
> Ricardo Koller (3):
>   arm64: debug: add a migration test for breakpoint state
>   arm64: debug: add a migration test for watchpoint state
>   arm64: debug: add a migration test for single-step state
> 
>  arm/Makefile.arm64 |   1 +
>  arm/debug.c        | 420 +++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg  |  37 ++++
>  3 files changed, 458 insertions(+)
>  create mode 100644 arm/debug.c
> 
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
>

Applied to https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

