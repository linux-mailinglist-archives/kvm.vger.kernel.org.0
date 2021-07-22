Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703F33D2B85
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhGVRNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhGVRNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eQ9PfyYo0VZyCVLkadaLAOsWh1sYSHEr6fbIS39JgK4=;
        b=YTwMEXmJuSiTKeVfkspcFBXPyHQCCCwFqA2vZlN3gCbXCUMD4/aQnLbGwr/0cCleKAtKLK
        7FVkxMoKy9YmqnaQQH8tB7tl/7IKib+09XcENcaGO1DuWEBX3kAkmnOdtv/NgHRR6Y6dgF
        knXnbNunrRUTKokvK8EX7LtnIS4hfVU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-SkIB4znUN2W8QAeQWhIlGg-1; Thu, 22 Jul 2021 13:53:57 -0400
X-MC-Unique: SkIB4znUN2W8QAeQWhIlGg-1
Received: by mail-ot1-f71.google.com with SMTP id x19-20020a9d70530000b02904d23318616aso4138104otj.17
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eQ9PfyYo0VZyCVLkadaLAOsWh1sYSHEr6fbIS39JgK4=;
        b=rp9yKROF0QE7WnsGcEzgghoB6yFYAj+hEpm60+Zrho7J1RaroQ3F0hEXX3TzZM4bkn
         /TQhGx2ANUIA/HqBRgwGW7D1D9iW5UgYTPmieoSWO4YfYfg1BjvvupcHUFR/jENAek2w
         6NRTDngaI7h8aG8InH3GSNU3/kJhA/zCmJYT3/KyMlYZm/1XTEHU5DvhXN9cSDuMyGVi
         ZhjBeztxliKMCLJWQ2DsLK4Zy2/bS5+0yHmYcsCvEtMWJJXBFUJZsFY3N0kaGyrAUq18
         PBSDJH2y6Kw/t304h6dUrAo/7ci9hxig6ligjzBZWIwjm7Y8wd1KWSG5ugMQ+L0+joyG
         Tmww==
X-Gm-Message-State: AOAM532xiskee0+tBAPZ/v5VZQGec2U48FLd11+cTZfjIzKSw5/Fr8hD
        P3ONxfnOPK3cW4NAM6PP7oGKk0iAcDzFdocXiY6Ci5I0BTD80ogBPRWRsZfo3zFCAKnG7AEcoPh
        OvvBbccKSdj0Kee6J7yleVuPE1tg/aGvYoiWoGFVcq/K6rmNDQWvCuwsB0So9KA==
X-Received: by 2002:a9d:5f93:: with SMTP id g19mr673614oti.236.1626976436795;
        Thu, 22 Jul 2021 10:53:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy86xavV/0DrIGNUTle5OGdO/XAB11pCbeZG9OFmaf+myDiV3jIMEiVMfShYxoPi20xOzE3Fg==
X-Received: by 2002:a9d:5f93:: with SMTP id g19mr673587oti.236.1626976436569;
        Thu, 22 Jul 2021 10:53:56 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id n23sm4388620ooq.48.2021.07.22.10.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:53:56 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 11/44] i386/tdx: Implement user specified tsc
 frequency
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <564e6ae089c30aaba9443294ecca72da9ee7b7c4.1625704981.git.isaku.yamahata@intel.com>
Message-ID: <42187f1c-26b5-b039-8fcf-f9268129feb8@redhat.com>
Date:   Thu, 22 Jul 2021 12:53:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <564e6ae089c30aaba9443294ecca72da9ee7b7c4.1625704981.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Reuse -cpu,tsc-frequency= to get user wanted tsc frequency and pass it
> to KVM_TDX_INIT_VM.
> 
> Besides, sanity check the tsc frequency to be in the legal range and
> legal granularity (required by SEAM module).
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> [..]
> +    if (env->tsc_khz && (env->tsc_khz < TDX1_MIN_TSC_FREQUENCY_KHZ ||
> +                         env->tsc_khz > TDX1_MAX_TSC_FREQUENCY_KHZ)) {
> +        error_report("Invalid TSC %ld KHz, must specify cpu_frequecy between [%d, %d] kHz\n",

s/frequecy/frequency

> +                      env->tsc_khz, TDX1_MIN_TSC_FREQUENCY_KHZ,
> +                      TDX1_MAX_TSC_FREQUENCY_KHZ);
> +        exit(1);
> +    }
> +
> +    if (env->tsc_khz % (25 * 1000)) {
> +        error_report("Invalid TSC %ld KHz, it must be multiple of 25MHz\n", env->tsc_khz);

Should this be 25KHz instead of 25MHz?


