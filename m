Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46303133F0B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 11:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgAHKNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 05:13:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23739 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgAHKNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 05:13:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578478433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVrqj6afqt7XuiTw73oIbm/4tmf2L88UQPwWRVq8vyU=;
        b=KfsetQXJW7nwTvfuMcxFnS+ACixa9wqXN57hVHZo41okAa4BOzuncRSuGMTmfkJsXOiw06
        XJvsLmqDitDpHPcYpRllxm0LsWKl2LHSXJhG56UPbWv2du3Qpit/hIIzc0nXjGAXGoUXFE
        WmPa8UGTLViWnn+nM8+7+SsFT+fisXU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-sqZ8v3GuOkyMCCL1djG8Fw-1; Wed, 08 Jan 2020 05:13:51 -0500
X-MC-Unique: sqZ8v3GuOkyMCCL1djG8Fw-1
Received: by mail-wm1-f70.google.com with SMTP id n17so269206wmk.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 02:13:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uVrqj6afqt7XuiTw73oIbm/4tmf2L88UQPwWRVq8vyU=;
        b=bHOc/yjvIkU1W3HKPVXx9zIO/hQsc+aUDDsaxWLhA4utWFa2cw1GBDRMmfIQA+W0ad
         JVPCO7zD2NlACdIP2Liy4R2qgh1qIemD4karRMdywgTY5ntEDezCavnEDyWa2pEyEPl4
         ZTQJ6OLmvCSQJWscee+I4AdY6Ws3K4h2mQ/deZqSa4JaZj4e/Gh65AfQFPVftkfk+Qdt
         JgyNIrEJUsPevQRnJ8x0N76BpDsEnUn+bFH0uHiaGWaLk8mXIa9jAxUK/yakzh9VxzlT
         TTOjbJJrbFzzSmlCGuCPI1kM70odfk9FNy2DrsKKH9uyM6P2Y1UzMwCCzFT4IztV98kQ
         1d2w==
X-Gm-Message-State: APjAAAUe7NQYeFfHDnTmjK0fviWw0Niip8EDtyB0E9jdAbUYlgZpxqKs
        Kg0Rs06d0LoR13OC2ppyqRmBrBu6nGFfkWuSqTGSaqpFtG6jxs5geM2e6F0fXcG/kF1RFzOHAR1
        Dkg54HHfWICzf
X-Received: by 2002:adf:e550:: with SMTP id z16mr3548219wrm.315.1578478430224;
        Wed, 08 Jan 2020 02:13:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRB9id3wHWWiu08oCQy3B4XNXmRQaQS6UKvo5KldVbYP8ts/jV70wGa1GYivKccPOmt1on8w==
X-Received: by 2002:adf:e550:: with SMTP id z16mr3548210wrm.315.1578478430066;
        Wed, 08 Jan 2020 02:13:50 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p5sm3698498wrt.79.2020.01.08.02.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 02:13:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
In-Reply-To: <20200108001859.25254-1-sean.j.christopherson@intel.com>
References: <20200108001859.25254-1-sean.j.christopherson@intel.com>
Date:   Wed, 08 Jan 2020 11:13:48 +0100
Message-ID: <87d0bus1b7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use a Logical OR in __is_rsvd_bits_set() to combine the two reserved bit
> checks, which are obviously intended to be logical statements.  Switching
> to a Logical OR is functionally a nop, but allows the compiler to better
> optimize the checks.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7269130ea5e2..72e845709027 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3970,7 +3970,7 @@ __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
>  {
>  	int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
>  
> -	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
> +	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) ||
>  		((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);

Redundant parentheses detected!

>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

