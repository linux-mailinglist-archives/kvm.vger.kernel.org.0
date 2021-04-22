Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540FB3678D0
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhDVEqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhDVEqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:46:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507ECC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 21:45:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso277952pjn.3
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 21:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DXjCdAnHAhGCr+w3KoEts8f/6jwy2njywZx+6/hg9YE=;
        b=t6ENp/xv8z4IDL6KI0OqHPbBHh1kOa3qGrSZCajGcUXCTFbZlgP2SLPNctiLmrSQ2t
         G69Hu/zbSglnwGiCWmCxCd3W7wbr2cGv248NJkXbE9SqrKmVh1DjGHdJAD1hO3RtcMGU
         pJElz9RZ9jO5HY8B7yBmy3sGIguOsCcJq2V7Z1S9kHnD0eFQFqKIFC0CedA6qTz5yXNF
         X9nEnjvZhNEWTL+27nlyhg3Vo75BHLBdEy5VoY+he1dUlT4w98TFneA37OayYr4EpLkg
         UuF23A0tbRXu9tLBKmJwVRRzM/HVlW1zGJ1/nbf+SWZU3kBHzNH/qcmRafvbPN/q3XOd
         4K5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DXjCdAnHAhGCr+w3KoEts8f/6jwy2njywZx+6/hg9YE=;
        b=PdIZy8wUUFulxKIOjSHylh5mVpGCWy82dhIhfWopfRuuSuS9Ga1h1/ifJfyA6zqnR3
         9Xw9gw8tvepsqm2BuRIJ++wVxVQO/vVkagI82k8GPo0iUqpA0Rjz2K5oEycs71NfYKE6
         kVcFVuMT/FEp+SO9oUNq/XP7h14GAN0YGJq6lH7NKaAc1a+SmIRDRpDHrJ0gPgMWgqNy
         Lbgq6fVdnJVAlF3PvOwmoFnlAQJU3ibCNZlsXpU/zI2LRAZVt20O7sSrxaWZ2XTyA4Dw
         jlpXnJZ6WFqP1DJZeVdCiD7PkT4eju7oZtqydiHHuz4PZVz8Sl2TJbnt6X2+kFoLSMQJ
         +PjA==
X-Gm-Message-State: AOAM530xekZp/fia1lYrCGG1qL+bBtQe1fefSUeprqLu9VZZZh9YaQxa
        sSW+4YmpWQVxVmrWo5iSC2hximbiqfqPzA==
X-Google-Smtp-Source: ABdhPJxqDifEjz2EiDSvzzDYU591AdzyddlKSGsVhoBDF+p1Gg4e6D3cog9LXZZA24AqVdb/AbPy8w==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr15499041pjo.235.1619066731812;
        Wed, 21 Apr 2021 21:45:31 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.131.83])
        by smtp.gmail.com with ESMTPSA id e7sm828010pjd.6.2021.04.21.21.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 21:45:31 -0700 (PDT)
Subject: Re: [PATCH v5 3/3] ppc: Enable 2nd DAWR support on p10
To:     David Gibson <david@gibson.dropbear.id.au>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     qemu-ppc@nongnu.org, mikey@neuling.org, kvm@vger.kernel.org,
        mst@redhat.com, mpe@ellerman.id.au, cohuck@redhat.com,
        qemu-devel@nongnu.org, groug@kaod.org, paulus@samba.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        pbonzini@redhat.com
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
 <20210412114433.129702-4-ravi.bangoria@linux.ibm.com>
 <YH0M1YdINJqbdqP+@yekko.fritz.box>
 <ca21d852-4b54-01d3-baab-cc8d0d50e505@linux.ibm.com>
 <8020c404-d8ce-2758-d936-fc5e851017f0@kaod.org>
 <0b6e1a4a-eed2-1a45-50bf-2ccab398f4ed@linux.ibm.com>
 <YIDX5nRJ2NWdGvlj@yekko.fritz.box>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <01a7ea82-1d51-6d8d-5b47-43ef9df6b81e@linaro.org>
Date:   Wed, 21 Apr 2021 21:45:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YIDX5nRJ2NWdGvlj@yekko.fritz.box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/21 6:56 PM, David Gibson wrote:
> I don't actually know if qemu has TCG watchpoint support on any
> hardware.  Presumably it would mean instrumenting all the tcg loads
> and stores.

We tag the soft tlb for pages that contain watchpoints.

See include/hw/core/cpu.h:
   cpu_watchpoint_insert
   cpu_watchpoint_remove


r~
