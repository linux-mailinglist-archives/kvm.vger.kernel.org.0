Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726522A93B3
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgKFKIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:08:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgKFKIm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604657321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zFWQauZB9Jb1vvi72pwbusWJtyLmY5VTZrvuC3s4RU=;
        b=bBtM5K2fEV5AGKBvKR7pZC3tvHfMGYR6eYa/JSaQGFWh1WUo5NAY82ZfSf4HntM5mKrgDX
        HnBhEH2Vt7y3yX/ePsLFa06UgnKbt7tNF2Hjf9/AQ5sEEuNO5dcDiS0t8GIORysVoIst7Y
        8T3YWIumYpKzdPasVibY20Ouef7Qcww=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-Q2Xkq_rxOs-VMXbuIZePnA-1; Fri, 06 Nov 2020 05:08:39 -0500
X-MC-Unique: Q2Xkq_rxOs-VMXbuIZePnA-1
Received: by mail-wm1-f71.google.com with SMTP id s85so244968wme.3
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 02:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/zFWQauZB9Jb1vvi72pwbusWJtyLmY5VTZrvuC3s4RU=;
        b=jhTRvxKJS/n/9qtAA2sgVi5YPO6oRAcEcqcuCZpI705ONRfRNs9D4JZlbrOvdZWbaN
         ks5OTRZWNFIj5Gc4I9q6LkCcFgim3sbz+X3ZOGU1JEZvgec6zZSjRR4zlyDud4OmtrUm
         hVmZvB/JNX+DeP0wm9kICHYvkvF+JdD5MWlwX1xeaYvMf4mjeUFZ4uEYces4hjRMMuTD
         5iabITGKzHLY3p0k5ELlf81/7f9KfyqzBqLc74E8iFSiV2ZAzdsahhQvSWIFD2KEhMb2
         tzJGP8Fwv3prs1jMyHGZrx6omCJ8bMvuuE3iPeN4xZlyj/FsoFkVnUr69geEtJLPH016
         dyQw==
X-Gm-Message-State: AOAM533R4ccN/9QUB4mEQgVLQQ3qBx2uUhHlbWdoJIHNNgnBvBUfE1R9
        bx/lUYcx8kmaLtm0hP5FgXvjT4SxpuZqI7U7+O4heiCTzSHtsKtRdpJzYsP1x8yxvSzZ5dHrnOZ
        sj40C4FzCHkkP
X-Received: by 2002:a1c:5946:: with SMTP id n67mr1536303wmb.162.1604657318384;
        Fri, 06 Nov 2020 02:08:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9igtEtChE6ux/KRrMYki2O+eSBRULpatbRYPhKVZ8EhtQD35zmOPT8mRBC+PnTw+rpJneaQ==
X-Received: by 2002:a1c:5946:: with SMTP id n67mr1536280wmb.162.1604657318153;
        Fri, 06 Nov 2020 02:08:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b14sm1256478wrx.35.2020.11.06.02.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 02:08:37 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: handle MSR_IA32_DEBUGCTLMSR with
 report_ignored_msrs
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, oro@8bytes.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
References: <20201105153932.24316-1-pankaj.gupta.linux@gmail.com>
 <36be2860-9ef9-db0f-ad8b-1089bd258dbc@redhat.com>
 <CAM9Jb+igM6Pp=Mx3WAqQJBsVqmVhfaYmkspFvDq1Y93Dihdp8w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ec4e9eb-763e-d16b-4938-2d463f63bc23@redhat.com>
Date:   Fri, 6 Nov 2020 11:08:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAM9Jb+igM6Pp=Mx3WAqQJBsVqmVhfaYmkspFvDq1Y93Dihdp8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/20 19:58, Pankaj Gupta wrote:
> Windows2016 guest tries to enable LBR (last
> branch/interrupt/exception) by setting
> MSR_IA32_DEBUGCTLMSR. KVM does not emulate MSR_IA32_DEBUGCTLMSR and
> spams the host kernel logs with the below error messages.This patch
> fixes this by enabling
> error logging only with 'report_ignored_msrs'.
> 
> "kvm []: vcpu1, guest rIP: 0xfffff800a8b687d3 kvm_set_msr_common:
> MSR_IA32_DEBUGCTLMSR 0x1, nop"

Sounds good, thanks.

Paolo

