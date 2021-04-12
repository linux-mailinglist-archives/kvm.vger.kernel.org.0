Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26CC35D1D8
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbhDLUOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 16:14:45 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:47035 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhDLUOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 16:14:44 -0400
Received: by mail-wr1-f44.google.com with SMTP id c15so5250848wro.13;
        Mon, 12 Apr 2021 13:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z92rtPihB/PVDuKi0eES4Biw0NIjfY+hn1ygMacOhy8=;
        b=GBnPTsQXwe5XTcvDzF0OD0YE1/hvR9jXrtkxvf4CkoslBGskxF9bOBiTyjCRrpt0od
         kjKPN9zluevk5ZFOGeTyzADIYGc2osZsmT6gzV/q2+BNJvbscNMxAT34y9D3upWzuivh
         xftXAt8D+rOj62zf6loGSjKWoMd+4UfczvT0YQXtC2bGfrXQ/8fBU0tPiI3TBWiXNslG
         r3YAbxwgogZAN3bpX4BvduzpXt3YImug0RSH7TCvFIkRF93gFzHZG0s9iHBqTCa9gugu
         prLnu2F2kPo0xYP631r9PiaZA/xbQAb09qemK2+aBKko2o8qBX8kqWBJZp4wpFdwD41N
         sxVQ==
X-Gm-Message-State: AOAM531IBOaQdwgnkF0a72E1la5du8rhRowbI/X4pzZaxtErspTj9yiO
        lGRWjpKNXng2movOIKKVB9Q=
X-Google-Smtp-Source: ABdhPJwM2Cp0dd0jYY/ic5wltnj6odHl7XohCWY3V1Iljex7jjw0eFyvOJtluZCne1tiHI54d/vIQg==
X-Received: by 2002:a05:6000:120b:: with SMTP id e11mr4630505wrx.299.1618258465495;
        Mon, 12 Apr 2021 13:14:25 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id e13sm19787044wrg.72.2021.04.12.13.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 13:14:25 -0700 (PDT)
Date:   Mon, 12 Apr 2021 20:14:23 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: hyper-v: Advertise support for fast XMM
 hypercalls
Message-ID: <20210412201423.rfpykzfgpmjh6ydy@liuwe-devbox-debian-v2>
References: <cover.1618244920.git.sidcha@amazon.de>
 <5ec20918b06cad17cb43f04be212c5e21c18caea.1618244920.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ec20918b06cad17cb43f04be212c5e21c18caea.1618244920.git.sidcha@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 07:00:17PM +0200, Siddharth Chandrasekaran wrote:
> Now that all extant hypercalls that can use XMM registers (based on
> spec) for input/outputs are patched to support them, we can start
> advertising this feature to guests.
> 
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 7 ++++++-
>  arch/x86/kvm/hyperv.c              | 2 ++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index e6cd3fee562b..716f12be411e 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -52,7 +52,7 @@
>   * Support for passing hypercall input parameter block via XMM
>   * registers is available
>   */
> -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
> +#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
>  /* Support for a virtual guest idle state is available */
>  #define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
>  /* Frequency MSRs available */
> @@ -61,6 +61,11 @@
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
>  /* Support for debug MSRs available */
>  #define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
> +/*
> + * Support for returning hypercall ouput block via XMM

"output"

Wei.
