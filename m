Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D901405AAB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhIIQVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhIIQVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:21:50 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49623C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:20:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n34so2194550pfv.7
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mq+nWy8A3w05M/jNdRBC+ueJXB9b06Z4r6ikEGWgYbM=;
        b=ron2C1aQMLtHuaUDinHLs22V49sX04sC4cmoqLoSXvBC4GErAQnvMEgrmfAgA5EKCx
         5EqXdxLbR2Ya4bilBa2iEGyZZ92SZNBkLbfRIycYfSP+pixl3vH81Hpjs0GqvMUhUxDU
         GwcMjs01IwlyoXmW9BxAfCCsQ3ZrJ6iej7vJZbW0ePJMFmOOpZDMqumdL7Cwa108YLFQ
         AzL2FJEoZNY+KlvvlaJEzPPiJ3asr7I5wOMXj4py+h2fRm2tlyBCuO9ukNEwvHQMHI57
         3+ewP5+olEGWKPMmzhqB4kpOo8eyhqa+qx2JjBXKuOiPRqoe5VOr0/Oadmv4T8lLZ4PJ
         YnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mq+nWy8A3w05M/jNdRBC+ueJXB9b06Z4r6ikEGWgYbM=;
        b=ToWiInSIJLa17HqyPH7j4x5jHUOIZfjaKwn8J2Sgf7gN3xwdg65UAMWOyAdhSZXuoo
         tdto9YREHm4Wkb1+J+dNbk307K8F1f76Sr2FHzvnLmRuizTQpPRAkH9bVUxYfB6SW1//
         6JNeLCekL5VeJirhG4V1hz8AHX4uyJmitU1GyStK/lScllOk811FMHGTtmKocuweQf4S
         hgiKE1WEN3IvDAZ/Q0uToxu10Nt/3CpDKzzvD3B02pYAfqKLcPSX1rqQfcytu9+ZTw/O
         Tk4yeKIPIg+nHXwdcmPQFdEcOrOXQ7CLeD8aCWajAmcEdiC2Rf3PQIKds21jpjcpyXd3
         rOKA==
X-Gm-Message-State: AOAM533d8H0O8zBMsLhfzYS0VNtpUvejYKhmKSHJViM0FeNqlSFzhtlv
        q59SAJV94u8ts/jtSXgYsgnmWg==
X-Google-Smtp-Source: ABdhPJwCnb1h2lDn6q1HoRMUeDZxli6VbjNX5PsowQJhCVoi8uFSOO2R0igBNYSauqC2RbZiNx+Q+g==
X-Received: by 2002:a63:f62:: with SMTP id 34mr3322234pgp.159.1631204440449;
        Thu, 09 Sep 2021 09:20:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o22sm2288796pji.18.2021.09.09.09.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 09:20:39 -0700 (PDT)
Date:   Thu, 9 Sep 2021 16:20:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
Message-ID: <YTo0U0ae3shRbUYC@google.com>
References: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021, Yu Zhang wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Currently, 'vmx->nested.vmxon_ptr' is not reset upon VMXOFF
> emulation. This is not a problem per se as we never access
> it when !vmx->nested.vmxon. But this should be done to avoid
> any issue in the future.
> 
> Also, initialize the vmxon_ptr when vcpu is created.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 1 +
>  arch/x86/kvm/vmx/vmx.c    | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 90f34f12f883..e4260f67caac 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -289,6 +289,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
>  
>  	vmx->nested.vmxon = false;
> +	vmx->nested.vmxon_ptr = -1ull;

Looks like the "-1ull" comes from current_vmptr and friends, but using INVALID_GPA
is more appropriate.  It's the same value, but less arbitrary.  The other usage of
-1ull for guest physical addresses should really be cleaned up, too.
