Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F325412F3D
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 09:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhIUHUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 03:20:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhIUHUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 03:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632208749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vd756pui6KEC1UbpIk1pqZxBtMYyZDzhx0CEGUXBa3g=;
        b=gCm1hs7A7EefNvG2JMRJntP6f/kJ408bMnGSt+dRoC4l1Z4Jjpn04Ne+y662hsULpWHlox
        G0b1bsOjiYwYOrhrXnnooWlDYWllvo4rcjQiAMn+rkLpMOsB1ssI2fbmu8uwNBAoqLrsHo
        8Xh3SxvfP6hwwFrGUiWb6XqZtBApC18=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-T8p1NE_wMpiU1e-XvmJ49w-1; Tue, 21 Sep 2021 03:19:08 -0400
X-MC-Unique: T8p1NE_wMpiU1e-XvmJ49w-1
Received: by mail-ed1-f72.google.com with SMTP id e7-20020a50d4c7000000b003d871ecccd8so4173598edj.18
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 00:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vd756pui6KEC1UbpIk1pqZxBtMYyZDzhx0CEGUXBa3g=;
        b=UUqQ3H/ZcYnJrrEFYDopa2+Ye5Ue1HYkD/G6XPx0j3SRJP7JEeIXK8ya+xNbXj+xoO
         GDKYYPYIZIT2sG1Cvyf626A3GgDc+CXmJ74OyAz2Gjz20fEfp3Ft+8B4CudkSBWHJWUE
         DR5Y2mBseh20fYoQJvQmKqMdZo7oJlWICCToSaFgo+qzTsVYqeTbv6aKe30ZAEfSkMU9
         iGA1P2tLa7DLRde9vmgk7A8nMWB0cY7hoMo0g8lASrEQZ6J0Zu7tDfS8qW7avO7Eh12g
         TwJWTAqGyXxZxMjZo6jPOHY6fhOCuV5te20TQs+dbNMGhQ3d5hsGg2UGb8ERhIQFUnr5
         dUVQ==
X-Gm-Message-State: AOAM533UQLFOXTh/LIG1e3DHJUL2QZ+Ev4hW7g/DJBPlaoc672QcQ0xm
        PpzoSeE6GyPyqa3oi4qhSn5dX0FRGK33OucnhXC0+YL3qPDhxw8Qbi4Rxedoam5PPkzVCMgWqEC
        2vh38IUBHWyg/
X-Received: by 2002:a17:906:39cb:: with SMTP id i11mr34466638eje.168.1632208747404;
        Tue, 21 Sep 2021 00:19:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI0XEybugInECb0uqIoYxDJZLvNGiDElvnIwBQk5rwedeJJwROpvlubrUCVRAUxU8E/axZ8g==
X-Received: by 2002:a17:906:39cb:: with SMTP id i11mr34466616eje.168.1632208747251;
        Tue, 21 Sep 2021 00:19:07 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id bf28sm8078306edb.45.2021.09.21.00.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 00:19:06 -0700 (PDT)
Date:   Tue, 21 Sep 2021 09:19:04 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Fix 'asm-operand-width' warnings in
 steal_time.c
Message-ID: <20210921071904.5irj3q5yiquoubj2@gator.home>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921010120.1256762-3-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 01:01:20AM +0000, Oliver Upton wrote:
> Building steal_time.c for arm64 with clang throws the following:
> 
> >> steal_time.c:130:22: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>           : "=r" (ret) : "r" (func), "r" (arg) :
>                               ^
> >> steal_time.c:130:34: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>           : "=r" (ret) : "r" (func), "r" (arg) :
>                                           ^
> 
> Silence by casting operands to 64 bits.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..eb75b31122c5 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -127,7 +127,7 @@ static int64_t smccc(uint32_t func, uint32_t arg)
>  		"mov	x1, %2\n"
>  		"hvc	#0\n"
>  		"mov	%0, x0\n"
> -	: "=r" (ret) : "r" (func), "r" (arg) :
> +	: "=r" (ret) : "r" ((uint64_t)func), "r" ((uint64_t)arg) :

Actually, I think I'd rather fix this smccc implementation to match the
spec, which I think should be done like this

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..7da957259ce4 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,12 +118,12 @@ struct st_time {
        uint64_t st_time;
 };
 
-static int64_t smccc(uint32_t func, uint32_t arg)
+static int64_t smccc(uint32_t func, uint64_t arg)
 {
        unsigned long ret;
 
        asm volatile(
-               "mov    x0, %1\n"
+               "mov    w0, %w1\n"
                "mov    x1, %2\n"
                "hvc    #0\n"
                "mov    %0, x0\n"


Thanks,
drew

>  	  "x0", "x1", "x2", "x3");
>  
>  	return ret;
> -- 
> 2.33.0.464.g1972c5931b-goog
> 

