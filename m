Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD5470032
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 12:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240727AbhLJLlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 06:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240732AbhLJLld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 06:41:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615CCC0617A1;
        Fri, 10 Dec 2021 03:37:58 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so28658577edd.0;
        Fri, 10 Dec 2021 03:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9PGzqzVr2lWR3c2FT6fcegvnLqjE5zdT1FTCSBDISuI=;
        b=OM3Nsd4ERses81PNwgGaV6Q7lHZ2NrIuizdbzBgNTGK9RHnDCOrAsDnSChO7XKFAZi
         vLUjMEQcVNFHcGMVfYKcGFH2HBh6Vw3rIMPk91Mzbko3xYPcjWXaD0QhzPgcRCzi/rmz
         TigzgBdHpHE1kgICxTUm3FPaWKeuU6uYvAJUZCVcvdbmCN0jXN6JZcfN1tyLFT310IQs
         7O4yK8ofsPkeRg6dtwxD+XD/+2wNTzt9Q0pA3c5hwe74Zk+jsx176dHTG9EnmTmbYPbD
         tYe4dTjQoFl1jcBSNq1N8m6APJC9eoK8SuIahBSIyDP06/QAkhsmqLyGvpnFOkJO7Mnz
         G1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9PGzqzVr2lWR3c2FT6fcegvnLqjE5zdT1FTCSBDISuI=;
        b=1xwpjRNz4ZZi7ifvhev+HPpGx6TBYxmIMWAW/65diX0fgktnDhQZKSvhQE2lh+HVmZ
         wzHxhsMULbPWbozbxR5mAoYe/FIY4F2dMN94cHwHymg+uneBarqp5Rd2nCaycVuDa1fd
         Ot34zuU5EI1T/LKR8irL7GFURP4PEey4k0ewr3bWRZuhKVh/T6AXz8+sPso+aOf0Tcak
         LUSBF+IqB0lqoY7TlmN4gQnTujRj+AaKlKKrTyz2mxtHcSz9MokIN/GZJwTFUMBG8ARS
         KqdQCn9akKgpGszmr+x3M0BtrXoM2AwIbKgdzKfZWZREMZ2YPEWBZCwy2LeAhbtTLPGB
         rhKg==
X-Gm-Message-State: AOAM531eiMeBSIoBg6Uulw+fI/zu0j7QKfQ2EGxspO5WIcoSQg/wvlT3
        w7awceM7jOrAyMYyFHqbPjY=
X-Google-Smtp-Source: ABdhPJx6v0WRp3OGfTassW/62i7NBEybv5+nw9b4oMWyDZPAfmhh2AuYeK9X3ZI4bHRxlhTob2it/g==
X-Received: by 2002:a50:9ea6:: with SMTP id a35mr37180244edf.400.1639136276255;
        Fri, 10 Dec 2021 03:37:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::973? ([2001:b07:6468:f312::973])
        by smtp.googlemail.com with ESMTPSA id sa17sm1389929ejc.123.2021.12.10.03.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 03:37:55 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ad666891-a67e-f126-da14-6de382bf0659@redhat.com>
Date:   Fri, 10 Dec 2021 12:37:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/6] KVM: SVM: fix races in the AVIC incomplete IPI
 delivery to vCPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
 <20211209115440.394441-5-mlevitsk@redhat.com> <YbIjCUAECOyIbsYQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbIjCUAECOyIbsYQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 16:38, Sean Christopherson wrote:
> +                       if (svm_deliver_avic_intr(vcpu, -1) {
> +                               vcpu->arch.apic->irr_pending = true;
> +                               kvm_make_request(KVM_REQ_EVENT, vcpu);
> +                       }

This is a good idea, but the details depends on patch 3 so I'll send a 
series of my own.

Paolo
