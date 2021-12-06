Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED846A22B
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbhLFRJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349851AbhLFRFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:05:35 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C32C0613F8
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 09:02:06 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id l64so5527395pgl.9
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 09:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IDr+xC7Hxg1cElvQGV3Z7CgphH2JwHEXV2UO5AQdC08=;
        b=fwuKH/tQko9yQe3Pkuyix3eSRhkCkES82tEdJ/DjimVKfubp8G4FVAyIj+tQUR1Xbe
         U7P+S2oUI5qJ5yCFy7QSz/IuPiffv0ya9N7Aisqn6tb6UPDNpVyr3uL4RRWV5P9/tVbt
         jsQnwm2BLuzlC0qBWSzZY6/5+mhL1LL+ZlUElenZ++B1mGTYnHenZfsI17vXkBMCiQE9
         +yxG4GS7WEDzNt6mLd6qNuEA4YNRP5C/+gn6mcyvSSgWKNuNSh9r6wN/8PI2EsqOxPbq
         +b3LmMF70bt4ne/z00zjpwCytwdO0ui7CE2dL1Zr35TCsPOicAuneY62cJSVFgqhnAtp
         YYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IDr+xC7Hxg1cElvQGV3Z7CgphH2JwHEXV2UO5AQdC08=;
        b=cenDFa3TIQi89GaHMfVYkY9Zqqz8ku5YDDB2hDMM8TkmVhnnEI6Y/3gctVMT5V32o7
         b7Y/KglMKhOGkxiFooMdeTNGo2v/nl5zI5tjvjRx5TJViqeKUQ8uReuH/dp0XYnIH5qC
         6mslZA5mz7dFWmbNoxZDRRTPXikXjCQHlFfuwd5ujiAsVkoEPh7jYE5lAdEqvpEc9RwG
         qTuGW5XN3hY2RYLRb9NuhR+RIjtSgQSerl4+V/tnipBei5ir5p4TJqEXAOaYxFDqeJaf
         sqbhigvUaeUI9LTuttMaraJu4MgD4MdyLRymXLr7h4Tl4aDKdkptfUHUvPSGtCXaGBOs
         I9bQ==
X-Gm-Message-State: AOAM531PPQpM1BKLsA8jyd9gxQ7ur8FR5/FpmTEpOngFqftJE9ta8qch
        oFCTiy6JcEWrKoUFF+iaNSzjxg==
X-Google-Smtp-Source: ABdhPJy75Ia/PuA9TG+KDKmlgjT4JcIiwA2FpkVyXmKyf9mPcIl728/gC4B1UAkcOIeTotazwIEIUQ==
X-Received: by 2002:aa7:9903:0:b0:49f:e368:4fc3 with SMTP id z3-20020aa79903000000b0049fe3684fc3mr38258039pff.1.1638810125718;
        Mon, 06 Dec 2021 09:02:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l2sm13021794pfc.42.2021.12.06.09.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:02:05 -0800 (PST)
Date:   Mon, 6 Dec 2021 17:02:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3] KVM: x86: fix for missing initialization of return
 status variable
Message-ID: <Ya5CCU0zf+MzMwcX@google.com>
References: <20211206160813.GA37599@hamza-OptiPlex-7040>
 <20211206164503.135917-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206164503.135917-1-amhamza.mgc@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021, Ameer Hamza wrote:
> If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
> ioctl, we should trigger KVM_BUG_ON() and return with EIO to silent
> coverity warning.
> 
> Addresses-Coverity: 1494124 ("Uninitialized scalar variable")
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> ---
> Changes in v3:
> Added KVM_BUG_ON() as default case and returned -EIO
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0aa4dd53c7f..b37068f847ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5019,6 +5019,9 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
>  	case KVM_SET_DEVICE_ATTR:
>  		r = kvm_arch_tsc_set_attr(vcpu, &attr);
>  		break;
> +	default:
> +		KVM_BUG_ON(1, vcpu->kvm);
> +		r = -EIO;

At least have a

		break;

if we're going to be pedantic about things.

>  	}
>  
>  	return r;
> -- 
> 2.25.1
> 
