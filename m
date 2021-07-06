Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5A93BD7B7
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 15:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhGFN0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:26:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231248AbhGFN0l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625577842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqq825G+li9OjVk5eaykIR+on9NrEBX7TA9mjDioEsU=;
        b=bMdR7VOKzsA/179SBTkPgwoUA8Of0Ethy0msQQB3IzStPcpv13JpgKRiZDEHL4beItAn0X
        QjRNvOpg25lUdMOHm7HJ9veMWQzj4BafSuJ2GSgLK9kawdvfoWRYsAO+S/tkFKJXsVfJS4
        qJRqp4syrdtwRzQQo3E/yhR+fV8ypbw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-VrS4QmZSMKKzC_c6gXU1nA-1; Tue, 06 Jul 2021 09:23:59 -0400
X-MC-Unique: VrS4QmZSMKKzC_c6gXU1nA-1
Received: by mail-ed1-f69.google.com with SMTP id s6-20020a0564020146b029039578926b8cso7916241edu.20
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sqq825G+li9OjVk5eaykIR+on9NrEBX7TA9mjDioEsU=;
        b=q5QOeVTb1hCjB+l+Dp6WlOtkdYCNzIb0rmqxkLpHFo2todbztVZOwnNNAVKlT7VRpz
         0yiY10dXAmVJ6OT7MFmdGm9HsW7Nchgi5CgB2lZSnGOPzyCNqlvAbZT5B2Ja3TN4yFLM
         w6or+hBD+VWTCCZPo0ZVnJblMchICtEg+vwj4HOAgxKAu0hSfPimqFGUPhhmwS3F1yhw
         OptNqyjREL2j7LMKTjvJkWUNoEjUNzywm7q7IpB/KhGa/EEaBKhCFARRW6aelDXNHq3M
         9Dku2xmUSFYzU0SF68Y32mcYTxE7ArBsawQ8w36tyDRpLxnB2O4WHyn1FzQ5/jubmmAT
         o/8Q==
X-Gm-Message-State: AOAM531IALDPtnN/ExHLnMtawDiZQMbsxtvE5Xl0j1eWAJ8fCux9A8Vt
        raIhxX6Dps/CPXidXgD8TQ50beIN+dLFCttQMiWnN++KFeo1uHfm2h2+Kqc7jqsER0R51dypRSh
        JVjgRlZ+9n54G
X-Received: by 2002:a17:906:2b0c:: with SMTP id a12mr11089865ejg.429.1625577838101;
        Tue, 06 Jul 2021 06:23:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpRHqxBDqgfllzawdsQdoN6ohItuD1Gz4sLZ7t9zIW0XkC+Apu6iTpuhuyoOIKoLxmFrKCxA==
X-Received: by 2002:a17:906:2b0c:: with SMTP id a12mr11089840ejg.429.1625577837885;
        Tue, 06 Jul 2021 06:23:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e2sm5733462ejt.113.2021.07.06.06.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:23:57 -0700 (PDT)
Subject: Re: [RFC PATCH v2 08/69] KVM: TDX: add trace point before/after TDX
 SEAMCALLs
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <28a0ae6b767260fcb410c6ddff7de84f4e13062c.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <03a48573-85b2-f908-f058-205e9aa02787@redhat.com>
Date:   Tue, 6 Jul 2021 15:23:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <28a0ae6b767260fcb410c6ddff7de84f4e13062c.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> +	trace_kvm_tdx_seamcall_enter(smp_processor_id(), op,
> +				     rcx, rdx, r8, r9, r10);
> +	err = __seamcall(op, rcx, rdx, r8, r9, r10, ex);
> +	if (ex)
> +		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err, ex->rcx,
> +					    ex->rdx, ex->r8, ex->r9, ex->r10,
> +					    ex->r11);
> +	else
> +		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err,
> +					    0, 0, 0, 0, 0, 0);

Would it make sense to do the zeroing of ex directly in __seamcall in 
case there is an error?

Otherwise looks good.

Paolo

