Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1345D63F1EE
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiLANrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiLANrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:47:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0631021
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7oq/5KWy0M8bnmSAvvJkGvFC1dRf3gcIMbGnaxS+Ce4=;
        b=RexrNQwvveAhZPCJ7X0Ss7eP0fV6bFzNtg0OB6RLbWSiGObQtO8z+yGORquDB2tCoxNQUU
        OL96YsndeoYBphnO6B35Vz3qQVZnX4CTtR888GWlf5ZFg3Qq1leeu9vwvDbJyl1yf+86mf
        Vl4km0hXFh2lYoRTYDnpO/WWgJSQva0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-97-QMAA0uxePmi-k0hEZuezKQ-1; Thu, 01 Dec 2022 08:46:26 -0500
X-MC-Unique: QMAA0uxePmi-k0hEZuezKQ-1
Received: by mail-qt1-f197.google.com with SMTP id y8-20020ac87088000000b003a528a5b844so4364869qto.18
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 05:46:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7oq/5KWy0M8bnmSAvvJkGvFC1dRf3gcIMbGnaxS+Ce4=;
        b=NVPNwlB/TPRm8xrwCRDGzovW46kJ3w9lRJAArg0XNY7KGUwEZGxMo3y7pdxzi3Ze4B
         4CaNMUw1cjXOt/B3fVU1CMh+tjhEGh6tbnRGxfyPDxj6znM0wfA61K6pbXyY0fCmHvq/
         ylF317x7PyVr50LZUCMmu9oL0Pztohs4gArHFZJKLTv8x/RS/jW8NypX/b059gWluS3R
         uMYekDTtAeJTtwJ4j2xAx3J2aLn4q8OOY8BVxfp6AhT82xpv68dQmJfJeL7QYT9bvJ9C
         b7wHLDg8KvCd4RD/3MHRniqepzHQzZjjztuHsLa31c2yB0J1KFRpHVUH99zJWxmrUSbg
         Sg0A==
X-Gm-Message-State: ANoB5plpvYihzRS1IaEKc6yqIsGa7lVYui0csVLWMrAYu58S2Vy+O9bQ
        ya/0uaVvXjyAi/oDbGfnOLvaIvqNo+dpuabmjgT3xqg9tleXzYIsuy7n5HmPm8hOXdMtVzt72KB
        g2evRYpuBKLhg
X-Received: by 2002:ae9:ef82:0:b0:6fc:9612:a9b8 with SMTP id d124-20020ae9ef82000000b006fc9612a9b8mr9498534qkg.596.1669902382224;
        Thu, 01 Dec 2022 05:46:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf41tVRL1INXSc+CJ8HMzatJNn0kpDNLtHx4uEip+W0bfXaSN/zV57Di/1yiJpsynuAm5XETaQ==
X-Received: by 2002:ae9:ef82:0:b0:6fc:9612:a9b8 with SMTP id d124-20020ae9ef82000000b006fc9612a9b8mr9498327qkg.596.1669902378844;
        Thu, 01 Dec 2022 05:46:18 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id h12-20020ac8714c000000b0039a372fbaa5sm2521191qtp.69.2022.12.01.05.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:46:18 -0800 (PST)
Message-ID: <332e7d94-4a3b-40d1-dc66-fa296e8d322e@redhat.com>
Date:   Thu, 1 Dec 2022 14:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 01/27] x86: replace
 irq_{enable|disable}() with sti()/cli()
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-2-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> This removes a layer of indirection which is strictly
> speaking not needed since its x86 code anyway.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/processor.h       | 19 +++++-----------
>  lib/x86/smp.c             |  2 +-
>  x86/apic.c                |  2 +-
>  x86/asyncpf.c             |  6 ++---
>  x86/eventinj.c            | 22 +++++++++---------
>  x86/hyperv_connections.c  |  2 +-
>  x86/hyperv_stimer.c       |  4 ++--
>  x86/hyperv_synic.c        |  6 ++---
>  x86/intel-iommu.c         |  2 +-
>  x86/ioapic.c              | 14 ++++++------
>  x86/pmu.c                 |  4 ++--
>  x86/svm.c                 |  4 ++--
>  x86/svm_tests.c           | 48 +++++++++++++++++++--------------------
>  x86/taskswitch2.c         |  4 ++--
>  x86/tscdeadline_latency.c |  4 ++--
>  x86/vmexit.c              | 18 +++++++--------
>  x86/vmx_tests.c           | 42 +++++++++++++++++-----------------
>  17 files changed, 98 insertions(+), 105 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 7a9e8c82..b89f6a7c 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -653,11 +653,17 @@ static inline void pause(void)
>  	asm volatile ("pause");
>  }
>  
> +/* Disable interrupts as per x86 spec */
>  static inline void cli(void)
>  {
>  	asm volatile ("cli");
>  }
>  
> +/*
> + * Enable interrupts.
> + * Note that next instruction after sti will not have interrupts
> + * evaluated due to concept of 'interrupt shadow'
> + */
>  static inline void sti(void)
>  {
>  	asm volatile ("sti");
> @@ -732,19 +738,6 @@ static inline void wrtsc(u64 tsc)
>  	wrmsr(MSR_IA32_TSC, tsc);
>  }
>  
> -static inline void irq_disable(void)
> -{
> -	asm volatile("cli");
> -}
> -
> -/* Note that irq_enable() does not ensure an interrupt shadow due
> - * to the vagaries of compiler optimizations.  If you need the
> - * shadow, use a single asm with "sti" and the instruction after it.
Minor nitpick: instead of a new doc comment, why not use this same
above? Looks clearer to me.

Regardless,
Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

