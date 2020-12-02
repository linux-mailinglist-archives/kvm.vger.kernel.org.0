Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307952CC8C0
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 22:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgLBVRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 16:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgLBVRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 16:17:09 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C008CC0617A7
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 13:16:29 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id r9so1739464pjl.5
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 13:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=H+1oKm0pwb4E29FHyC4100Vp0vOUoGAVXJi7aD8Kt9Y=;
        b=EpTd4U46krQZ0Wwyx1Tv3g9ygf+EwpF2OMlz0xfMPb4LbT9LQGFMS+ym7/t1+hqZ3P
         ek2+8+AfLsihdsC6oj2yMFX2VCsRUvP10x5gCP4GbTQv6u0Pnir7uKf+7gED912YF+5u
         Zh9yOHh7WoIjLLNwlBn0Einsi4SCQYVRiIYZ8VH8UOJOTLa2zX0xAWUz1ogwr6jYZqg2
         VOTW+QmzBGvYpl6WZf9+9bwu1raa12Gushh5RoVS/RDp8XDs/H3mbdnBJ2ScnEV4/r0D
         6+NXlwdOLmHbQjHVszlZZfRWy3pKQEmffVE3RxAkHgSmM6fU4oxmo4istTZHcW/hTCyP
         x3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=H+1oKm0pwb4E29FHyC4100Vp0vOUoGAVXJi7aD8Kt9Y=;
        b=ItTWBuI1qH7X/9vhoGzqFC/+wFHXOBdnd4zYQgctv60z28m1R69x+no9qWHGUbNj/M
         v4WWHWXnAjZyRqTM6/EoGEf6vO3Ttm1khtLYaP3X7R2Jt5ESeoTW+TnyJzcY9vrsY9Y4
         KFOoryYXZMNJRpoTiT4NAeiNIzLzViXAxFDwHsNmWy7FmZ+u+yo7mtFSJ3nZAtEDgAwu
         iOK2JfXFtomVFwbItl47JuiqDvbKKdRz4wqdGZD+vlhJL3fUOEqduJ/EZwNc+60DIh5u
         ioAbFdTk7UOeVcT37lfVlLUZ3lnvazDNd4sNplbVdqokxTShpkruK9dLb7432/2XPd50
         68vQ==
X-Gm-Message-State: AOAM531J+3J8rFA5t7p4xqtoW14bC9aT2GLonGWkbXpNW1cg7rWGxxdx
        qCEYxTrp6HpTjOpqterbLjrZ3w==
X-Google-Smtp-Source: ABdhPJzVR5MhB7LeZKwmFWTk6vFnfgN6FPQ9SZtNhEp9NIBdnNxk/WCCn3Ujoqji3pMUzLnpONXT/g==
X-Received: by 2002:a17:90a:72c6:: with SMTP id l6mr1624281pjk.233.1606943789128;
        Wed, 02 Dec 2020 13:16:29 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z11sm515061pjn.5.2020.12.02.13.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:16:28 -0800 (PST)
Date:   Wed, 2 Dec 2020 13:16:22 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/2 v3] KVM: nSVM: Check reserved values for 'Type' and
 invalid vectors in EVENTINJ
Message-ID: <X8gEJkyUxPc7g3jf@google.com>
References: <20201130225306.15075-1-krish.sadhukhan@oracle.com>
 <20201130225306.15075-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201130225306.15075-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30, 2020, Krish Sadhukhan wrote:
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 05d564c8d034..2599b32ea7be 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -212,6 +212,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  
>  static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  {
> +	u32 type, vector;

Making vector a u8 would be more intuitive, since its mask is 0xff.

> +	bool valid;
> +
>  	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>  		return false;
>  
> @@ -222,6 +225,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	    !npt_enabled)
>  		return false;
>  
> +	valid = control->event_inj & SVM_EVTINJ_VALID;
> +	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
> +	if (valid && type == SVM_EVTINJ_TYPE_RESV1 ||
> +	    type >= SVM_EVTINJ_TYPE_RESV5)

You were a little too aggressive in removing parantheses. :-)  This breaks the
build with CONFIG_KVM_WERROR=y due to not wrapping the chain of ANDs that are
separated by ORs.

  /arch/x86/kvm/svm/nested.c: In function ‘nested_vmcb_check_controls’:
  /arch/x86/kvm/svm/nested.c:230:12: error: suggest parentheses around ‘&&’ within ‘||’ [-Werror=parentheses]
    230 |  if (valid && type == SVM_EVTINJ_TYPE_RESV1 ||
  /arch/x86/kvm/svm/nested.c:235:45: error: suggest parentheses around ‘&&’ within ‘||’ [-Werror=parentheses]
    235 |  if (valid && type == SVM_EVTINJ_TYPE_EXEPT &&


> +		return false;
> +
> +	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
> +	if (valid && type == SVM_EVTINJ_TYPE_EXEPT &&
> +	    vector == NMI_VECTOR || (vector > 31 && vector < 256))

I'm pretty sure this is straight up wrong due to removing paranetheses.  I
assume the check is supposed to reject valid exceptions with (vector == 2 ||
vector > 31).  As is, it rejects valid exceptions with vector ==2, OR any vector
greater than 31.  If for some reason this should reject any vector > 31, it'd be
better to through that into a separate if statement.

Also, the "< 256" check is pointless, it will always be true since vector is
an 8-bit value.

> +		return false;
> +
>  	return true;
>  }
>  
> -- 
> 2.27.0
> 
