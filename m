Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56853413838
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhIURYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:24:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhIURYg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 13:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632244987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Crx2yXztHF3g4rFcd1goQcNIJRLU07HcReSxyZxd2Qo=;
        b=AIoIxisxrqRT3Y87eSpYFGTUBLNfPGL/SSX0/TFwaD/Dx5tcqL9FcsfJ5qq0SJ5A7z8fXx
        NUnnYlDd8nhYUZkaT4GS+fPG0jO0Tpt8/JRJercb6N18LmZX9urX02N605EVCIXt1rSmPE
        wxdWRYLNNWTjIAo2+lPlN1Hz9HiB7bY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-6dXnd6w6PG6o0pHzjYug0Q-1; Tue, 21 Sep 2021 13:23:06 -0400
X-MC-Unique: 6dXnd6w6PG6o0pHzjYug0Q-1
Received: by mail-ed1-f70.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso5883951edw.10
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Crx2yXztHF3g4rFcd1goQcNIJRLU07HcReSxyZxd2Qo=;
        b=um3rEfugHiIQdObMFY2kDvL7KMIz4m09nxFUNHyq3SIRvjJLQv2XIA1ZfH2GeKGBJG
         YV436/mRj4USkBFmyNHCTmn6nEiOhUIhuJdNNPy5ZVz4Jz+xerG7rMic6GZwyXjNY8lj
         ixbEeMCYqSWWRsrw2sIysyAxXhDofP0YVy9aLIXhm48SPGbX2IbnUDUTb1smloJcYHZN
         IhSyFPFyylQA4Kn835w/u7DsXIRk4y9Y93gBjzpvxPU3KF+7fAl2UCL98VxDrt0OupaX
         K9jFoK8IRDAONdgKoi6rTV2sWJiD5wBRvPfNfAmTln7khIErdTI4ZmdEYTxDGQ+Py+PF
         L8Aw==
X-Gm-Message-State: AOAM530pt6VAqa0JqykviZRHL2dSpdZnDyTJdqh5OAY0WNxxm4873rYA
        y3bxLjmuLA6ZIQ1CD7ZFPXJROxrTsGSHTwy97D/V4v3fwRPjJQUOvDrcahEUid3GBQBQyU8O3ss
        TIzHAnPpDGEr1
X-Received: by 2002:a17:906:3e08:: with SMTP id k8mr36810595eji.361.1632244984987;
        Tue, 21 Sep 2021 10:23:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzxrG1oc6ZNBnXvUP4hiTHEcdtV+vXwmMe3LlCQlBiZU6QBmCkJE3OvUTs/WUzYdBFWgbkmw==
X-Received: by 2002:a17:906:3e08:: with SMTP id k8mr36810570eji.361.1632244984751;
        Tue, 21 Sep 2021 10:23:04 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id j2sm8939392edt.0.2021.09.21.10.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:23:03 -0700 (PDT)
Date:   Tue, 21 Sep 2021 19:23:01 +0200
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
Subject: Re: [PATCH v2 2/2] selftests: KVM: Align SMCCC call with the spec in
 steal_time
Message-ID: <20210921172301.3tkne2ucpev62r6h@gator.home>
References: <20210921171121.2148982-1-oupton@google.com>
 <20210921171121.2148982-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921171121.2148982-3-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 05:11:21PM +0000, Oliver Upton wrote:
> The SMC64 calling convention passes a function identifier in w0 and its
> parameters in x1-x17. Given this, there are two deviations in the
> SMC64 call performed by the steal_time test: the function identifier is
> assigned to a 64 bit register and the parameter is only 32 bits wide.
> 
> Align the call with the SMCCC by using a 32 bit register to handle the
> function identifier and increasing the parameter width to 64 bits.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..aafaa8e38b7c 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -118,12 +118,12 @@ struct st_time {
>  	uint64_t st_time;
>  };
>  
> -static int64_t smccc(uint32_t func, uint32_t arg)
> +static int64_t smccc(uint32_t func, uint64_t arg)
>  {
>  	unsigned long ret;
>  
>  	asm volatile(
> -		"mov	x0, %1\n"
> +		"mov	w0, %w1\n"
>  		"mov	x1, %2\n"
>  		"hvc	#0\n"
>  		"mov	%0, x0\n"
> -- 
> 2.33.0.464.g1972c5931b-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

