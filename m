Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7E1681D8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBUPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:36:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728186AbgBUPgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:36:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oOToEHS8ihajx9JSHSORZaVCnP2phBIkFva4hj6D5cY=;
        b=JqS5hdNrGoh83S+CEneU+3Kjt/y9pG/RsK3ZWd5x9MGU1BC4BquQA88DGz3rfEmGZMT8ir
        Gu8DEY2OwHiQGLfhKN50D9deBoWKTTrxJnEleoQNlefMDx+mKpjlVUPrOqGLBCc7qiByj5
        188trpUBl6Lo/Rrzcv5N3UhL/oyUaL4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-nYVhkBtWOieGNQeYdCF1Zg-1; Fri, 21 Feb 2020 10:36:02 -0500
X-MC-Unique: nYVhkBtWOieGNQeYdCF1Zg-1
Received: by mail-wr1-f71.google.com with SMTP id d15so1187459wru.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oOToEHS8ihajx9JSHSORZaVCnP2phBIkFva4hj6D5cY=;
        b=cMfiZSia3rf11mQpbtDVqLrKlv4tVvvggTtkWJfw/Po5+u3D0GysbW7LSOXQxp7jrt
         B4Y9Fh95oMh2l7xXxKmksj1dJHJ6YqkjEIZKkztcFMSp4V29n/FSPxZylbla9NbPk7CY
         /AzmTa52dQbiQ0XD3+RcvA24jlwBrN++uFwQm/sc3gxDgta1VFcSEOew9d6SbmcyrkCu
         me/+rv+STqCM5DMGg32q5h1Tc3hhU2dHpIjUDuLGB4udCIdeK0lkXbshogdVnHI9G/hA
         4U4JiRoDbtUdsc48Yp/OEyJmeR7Icoazzjpev4Aw++I7ry8i2R9WdENXZ3sFeFZ5rj7b
         /aXA==
X-Gm-Message-State: APjAAAWilscCrFOe6MVa64o5dRzOZKe4PgNPzi7ACrfzgvGZdn1uXiS3
        qdAcycaYTb45rtBx90minoAnDbO52ZqusHMTynLBqDW0eqkQL8JOufAfaXx2k9mGG7rMtunhY9j
        p7ThlT1tcOxCt
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr51994285wru.220.1582299361668;
        Fri, 21 Feb 2020 07:36:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEUtM+sR0YQOKEdCKvF0CFcEBjKZHAFpG0mki6xtVyPaCiKifi4wmUC/gBy9khmvLU/IPTwQ==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr51994269wru.220.1582299361468;
        Fri, 21 Feb 2020 07:36:01 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o15sm4581585wra.83.2020.02.21.07.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:36:00 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/61] KVM: x86: Clear output regs for CPUID 0x14 if PT isn't exposed to guest
In-Reply-To: <20200201185218.24473-24-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-24-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:36:00 +0100
Message-ID: <87eeuoq7fj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Clear the output regs for the main CPUID 0x14 leaf (index=0) if Intel PT
> isn't exposed to the guest.  Leaf 0x14 enumerates Intel PT capabilities
> and should return zeroes if PT is not supported.  Incorrectly reporting
> PT capabilities is essentially a cosmetic error, i.e. doesn't negatively
> affect any known userspace/kernel, as the existence of PT itself is
> correctly enumerated via CPUID 0x7.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d3c93b94abc3..056faf27b14b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -663,8 +663,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	/* Intel PT */
>  	case 0x14:
> -		if (!f_intel_pt)
> +		if (!f_intel_pt) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>  			break;
> +		}
>  
>  		for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
>  			if (!do_host_cpuid(array, function, i))

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

