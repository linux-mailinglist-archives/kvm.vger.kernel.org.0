Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B0636D92C
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbhD1ODH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:03:07 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:43624 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbhD1OCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 10:02:44 -0400
Received: by mail-wr1-f47.google.com with SMTP id x7so63152674wrw.10;
        Wed, 28 Apr 2021 07:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uheu8s26iW3ko1XKinftj7CiwtVhVkhr//K4W010x+g=;
        b=MKy3Kq2BVhQG9g3ncrRkK2jYiFZKB8NepwFyhtZ7wcio0uUUosnue5H8Sqvo9DqKAQ
         LO6tS9Bf0q3jgPz2OjQzEJ56c0TSBU8uAo867FfLjBidj0yw7SjVDyFxgATIL03w3MqL
         ZxZMndHxq2wNHmx5N9hFn6ITqCJWV3uWcbXfaR0KssqdtHpw1BSn6FHYb52hr9Q0lwtp
         kCzWCsIGfkfT5ismQ+1Mf7sJBC3ifXjJqAhq5+cadYtHMdi8cHrSzen3H+5UxPWlQdWD
         TJRklLWs1IRvoomxjx1uh5AYyV8hh8804md2jfL2Pg3tTxpaHp4ilO1S2rqEs/YTWY7f
         ownw==
X-Gm-Message-State: AOAM532VtWf+/A6zEemLZZWpM4pnJhnHluB1XlcbOAlqIKW0yvPdv+KR
        duBT9oeq4VB9ZBli7jl7zfA=
X-Google-Smtp-Source: ABdhPJxivxFyQJiOiApbgYKWy7pGxc/X9ieVDkn9eHOL7wL9k5J3eH/h4E+cAhTd8gYUx4EopFk0PA==
X-Received: by 2002:a5d:638f:: with SMTP id p15mr23588927wru.255.1619618518894;
        Wed, 28 Apr 2021 07:01:58 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n12sm3882943wmq.29.2021.04.28.07.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 07:01:58 -0700 (PDT)
Date:   Wed, 28 Apr 2021 14:01:56 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 1/7] hyperv: Detect Nested virtualization support for
 SVM
Message-ID: <20210428140156.flf5ie6r2j7os5ch@liuwe-devbox-debian-v2>
References: <cover.1619556430.git.viremana@linux.microsoft.com>
 <8ffa88e6ceb55d283c76b4c5fd9ad0fb1a2cf667.1619556430.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ffa88e6ceb55d283c76b4c5fd9ad0fb1a2cf667.1619556430.git.viremana@linux.microsoft.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 08:54:50PM +0000, Vineeth Pillai wrote:
> Previously, to detect nested virtualization enlightenment support,
> we were using HV_X64_ENLIGHTENED_VMCS_RECOMMENDED feature bit of
> HYPERV_CPUID_ENLIGHTMENT_INFO.EAX CPUID as docuemented in TLFS:
>  "Bit 14: Recommend a nested hypervisor using the enlightened VMCS
>   interface. Also indicates that additional nested enlightenments
>   may be available (see leaf 0x4000000A)".
> 
> Enlightened VMCS, however, is an Intel only feature so the above
> detection method doesn't work for AMD. So, use the
> HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS.EAX CPUID information ("The
> maximum input value for hypervisor CPUID information.") and this
> works for both AMD and Intel.
> 
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
