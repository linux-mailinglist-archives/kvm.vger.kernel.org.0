Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FE43AEFE7
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 18:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhFUQnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 12:43:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232769AbhFUQlY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 12:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624293549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNrhWGaCEE6tlRQzMAC0qRSOkCc4lESqY0tViKqRaA4=;
        b=U8kgj9CngIlwHAjNzu0z8Yn+aTlDLVaL4XYepIRC2crWNXCbGUS3bebegNG5wiEtPTg1kJ
        vI1PuCHjGsJmSYbig28nm6fPl9qTjtMn8SOfN7ZQ4Ifg1NlBKsXfr7Acms9e9Qy5YXOR3H
        xvlm04SPMvGjoYK1cGBfOzATFl+UZOg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-JusAsHiEOMSFdHT7BRP0Wg-1; Mon, 21 Jun 2021 12:39:07 -0400
X-MC-Unique: JusAsHiEOMSFdHT7BRP0Wg-1
Received: by mail-wr1-f69.google.com with SMTP id b17-20020a5d40d10000b029011a9ecaf55dso1227684wrq.19
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 09:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNrhWGaCEE6tlRQzMAC0qRSOkCc4lESqY0tViKqRaA4=;
        b=UZFEw6+yc0LYBDcUDll8I/kNsuFKTvZPZ+q12IjzwRjQ6MhhcdPCm1Vti9wQDt3UD0
         FInNkvApdK8J+DA/Hy7Hqt/pHZo+oDJEpVcmdVtf46GV5Ni39DxdLe0dWlvbEWcCLTxx
         S6C+P3ccNIbZq7/lYe0I0J66WKXN9Rc0KWrz9Kl235u2fExlCbyj8tDucwNK4PaJ5r85
         dv+BpjK/r0gKI5NqCRDnP7gEs51dWaqM5f76lp3MN6KvSWRYbC/OhkVepLqWh1OdvFQy
         8NSXmhXxAUqSAqGgHrqN5snEBMvQ3h6Xw/WmsvXVCciEda4Fkoh6roCaJwrFA+/+FpR9
         ppPw==
X-Gm-Message-State: AOAM532zEODlPXF110Gx8aaLYh7QQ0gTlzpEXnqrI4EfATT5NcOKJR42
        OmJ7PZcuonfk6u7i8F+SpNDaVyjftqXs4XrtyDokA9KuVDNAfuFAyl14HBh+j9FgMaGexKxZVZD
        2ZKOBfcGdQtim
X-Received: by 2002:adf:c3d4:: with SMTP id d20mr29479252wrg.183.1624293546369;
        Mon, 21 Jun 2021 09:39:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdEswH/yGTRhXZ1gO9tpcXCMyM68MKeybsENTeeaW0I+76u4JxxClPc6tiA9Gn01YIGQBV5Q==
X-Received: by 2002:adf:c3d4:: with SMTP id d20mr29479237wrg.183.1624293546245;
        Mon, 21 Jun 2021 09:39:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y14sm11979790wrq.66.2021.06.21.09.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:39:05 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210618214658.2700765-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
Date:   Mon, 21 Jun 2021 18:39:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210618214658.2700765-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 23:46, Sean Christopherson wrote:
> Calculate the max VMCS index for vmcs12 by walking the array to find the
> actual max index.  Hardcoding the index is prone to bitrot, and the
> calculation is only done on KVM bringup (albeit on every CPU, but there
> aren't _that_ many null entries in the array).
> 
> Fixes: 3c0f99366e34 ("KVM: nVMX: Add a TSC multiplier field in VMCS12")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Note, the vmx test in kvm-unit-tests will still fail using stock QEMU,
> as QEMU also hardcodes and overwrites the MSR.  The test passes if I
> hack KVM to ignore userspace (it was easier than rebuilding QEMU).

Queued, thanks.  Without having checked the kvm-unit-tests sources very 
thoroughly, this might be a configuration issue in kvm-unit-tests; in 
theory "-cpu host" (unlike "-cpu host,migratable=no") should not enable 
TSC scaling.

Paolo

