Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DD5367EAC
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhDVKdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhDVKdU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619087565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2Btu50h2SmkA6z4GjSXki84Hb6VYRx9g1fp8/EHavQ=;
        b=Jvn27a66OfZ5cRWTZfRZLbTZaGj3lDO2XDvkO5ZOoAiM6ANTGgvVeR31KkFHot2tTcg8Tj
        w4FRg/OqXL4OjW+6UgqW1Pa1bzRy7wEsABvMlKr0HeD7OGAt1llB1a7RLV5LTaE/AE/631
        iFom+6IKcy7e/YRw7ptlGv8habknLZU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-2MZAXXIsNoSxsnGI410m2Q-1; Thu, 22 Apr 2021 06:32:32 -0400
X-MC-Unique: 2MZAXXIsNoSxsnGI410m2Q-1
Received: by mail-ed1-f70.google.com with SMTP id f1-20020a0564021941b02903850806bb32so10554335edz.9
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h2Btu50h2SmkA6z4GjSXki84Hb6VYRx9g1fp8/EHavQ=;
        b=FD5+V15LwDU77kxI0hnMQwJzuYuMDnbSpkDqiJ0H+gQWJ5dDTMsOwHnmHd0HKl/Qh8
         vvkPStqn6dQqPMpeK0IzEyrcjQvwVrtpa3VIQQvAIBBo/rowGmksW6XoYdJd8LeA7zlC
         oiZ3zVey4ttYmOji8Ukfrdv9Nkv8ev+pjzb70qgmsRpPq5eMmzmVhyX9fXTsS2VLAwBI
         iHwOSp5YoPDaI/md/8wQTRNfwaRh9ZlpRzELFSfm/AKY/pzQDG+THv9WV6ZluQzAjq+9
         th9tuSOGkDwRar7OmPc08ZXhv1KOfxhknfPWaxsIlnKPmKx/blvR2Pko8C8aTxeZ59KG
         06uw==
X-Gm-Message-State: AOAM530TDV5NfgAjbsaLvg1/9NxAKStf6T2squIzkLI7YLOULcqFdYKz
        +rcxq3/uH5mnw2K6a0eRYEwgdJ93FyAV+pah9Od4aaJk5OUHnnkQmMSteiSBomyf8l5P+omk/dh
        OO7OdHLdVVRcP5V30NN44xFMrzu/kI2tIEd1sCnpwUuRPrnS5/OAfHntUvqMXspR9
X-Received: by 2002:a05:6402:4415:: with SMTP id y21mr2992843eda.115.1619087551431;
        Thu, 22 Apr 2021 03:32:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGpHYpjBFfvyP7Lg2zIFzafNgD93IfoeIRSYOOV+HRic/18Kk1ss7n0Z4liuKwtsK+ie2VXQ==
X-Received: by 2002:a05:6402:4415:: with SMTP id y21mr2992826eda.115.1619087551271;
        Thu, 22 Apr 2021 03:32:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a22sm1738851edu.14.2021.04.22.03.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:32:30 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 12/14] x86: msr: Verify 64-bit only MSRs
 fault on 32-bit hosts
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210422030504.3488253-1-seanjc@google.com>
 <20210422030504.3488253-13-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f08a4adc-79aa-e38e-208d-3103181cfec7@redhat.com>
Date:   Thu, 22 Apr 2021 12:32:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422030504.3488253-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 05:05, Sean Christopherson wrote:
> Force "cpu -host" so that CPUID can be used to check for 64-bit support.

"-cpu max" is preferred because it also works with QEMU binary 
translation, otherwise looks good.  Someone can fix KVM if they're bored.

Paolo

