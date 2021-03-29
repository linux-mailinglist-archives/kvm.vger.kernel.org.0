Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC75B34CC57
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 11:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhC2JAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 05:00:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237064AbhC2I6i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:58:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617008315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fcTGqPN58JkB4CqrxqLCMpsxGEhV/7x/d1+4H1q7GXQ=;
        b=K3WotLI1qGPnD4csYMfaUME0QA6M3R5pC8fPJIxwN+EqkEh8KV9lTX+aCZFuOaxfxrCa5o
        YHNeol0IW5Zimp+eWOtfy2v4YUgbQTnWSMwozek+4+5eNfGouwIt8USPy17vRvoz7qo10F
        7Prd54C7234xh4X5+WhAbWgphZ7Rh/A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-tLSoGIaYMoycsZc9XGPijw-1; Mon, 29 Mar 2021 04:58:33 -0400
X-MC-Unique: tLSoGIaYMoycsZc9XGPijw-1
Received: by mail-wr1-f70.google.com with SMTP id o11so8368311wrc.4
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 01:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fcTGqPN58JkB4CqrxqLCMpsxGEhV/7x/d1+4H1q7GXQ=;
        b=NSeUao0TlOR2f366KbxJ3qKY+hZXNWObDdkWnXcc/hKHIa01iQxmKcpKDiWC9UCkTz
         Jl5/xU3ftycnXbAUAlXhXbs3lbEdbxqgSBH68iXnrotuPVvWnsodEQ2qxIEd/cAPbioh
         0vjr4JwA2s9Gm1ZqEGGNl85b4HrzcVMqSDMw376k7jlmfwSh4HQdv5jHq6h/ASSR1Rxp
         4y25Y3HkKh4WJPtNrNfSNrdGIBV4rB0x3WS7uxijne5XXsu4yvsvDuzB88xnkGovgdOz
         jWxVsVRRyc+pQo1HCIaLCTOtzjtdQH7gm4AcWEwPOEO4KO3F5uA00qnVreVlUxzakov+
         OnPg==
X-Gm-Message-State: AOAM530sRkxLQwtrMhZSCgOKKD8i3nuznD8mB1rCHC4YChZjZq/QRb+B
        7BxlhEB8p11UpPtiEVD3m+VhCBQhx6ZxiOEJqf6nSyr3LKyW38XuGGRprJbavUOhsCQKgJb1vdk
        0b92ckVDApZOU
X-Received: by 2002:adf:fd91:: with SMTP id d17mr27609716wrr.0.1617008312495;
        Mon, 29 Mar 2021 01:58:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYy4+hP61UfWYDXK/BVQxqigaWxieU0j3uKAJGEp7BS1flZAWgpNaEGXAwOlVV+43nGx8DpA==
X-Received: by 2002:adf:fd91:: with SMTP id d17mr27609708wrr.0.1617008312362;
        Mon, 29 Mar 2021 01:58:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c2sm22351363wme.15.2021.03.29.01.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 01:58:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: hyper-v: Forbid unsigned
 hv_clock->system_time to go negative after KVM_REQ_CLOCK_UPDATE
In-Reply-To: <5e5ba386-99d1-162a-4e70-520af9581994@redhat.com>
References: <20210326155551.17446-1-vkuznets@redhat.com>
 <20210326155551.17446-2-vkuznets@redhat.com>
 <5e5ba386-99d1-162a-4e70-520af9581994@redhat.com>
Date:   Mon, 29 Mar 2021 10:58:31 +0200
Message-ID: <871rbybako.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 26/03/21 16:55, Vitaly Kuznetsov wrote:
>> Another solution is to cast 'hv_clock.system_time' to
>> 's64' in compute_tsc_page_parameters() but it seems we also use
>> 'hv_clock.system_time' in trace_kvm_pvclock_update() as unsigned.
>
> I think that is better.  There is no reason really to clamp the value to
> to 0, while we know already that tsc_ref->tsc_offset can be either
> positive or negative.  So treating hv_clock->system_time as signed
> before the division would make sense.
>
> It should be just
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 58fa8c029867..e573e987f41b 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1070,9 +1070,7 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
>   				hv_clock->tsc_to_system_mul,
>   				100);
>   
> -	tsc_ref->tsc_offset = hv_clock->system_time;
> -	do_div(tsc_ref->tsc_offset, 100);
> -	tsc_ref->tsc_offset -=
> +	tsc_ref->tsc_offset = div_s64(hv_clock->system_time, 100) -
>   		mul_u64_u64_shr(hv_clock->tsc_timestamp, tsc_ref->tsc_scale, 64);
>   	return true;
>   }
>
> right?  The test passes for me with this change.

Right,

in fact that's how v0 (which I've never sent out) of the patch looked
like but then I relalized that the fact that unsigned
'hv_clock->system_time' can sometimes keep a negative value is a
'gotcha' which may cause issues in the future.

I'll re-test and send v2, thanks!

-- 
Vitaly

