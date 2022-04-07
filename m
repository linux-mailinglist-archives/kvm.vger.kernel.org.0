Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38C84F875F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346993AbiDGSwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347006AbiDGSwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:52:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3ECFE426
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:50:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so7189147pjy.5
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yHTfa3Xf5bj7v/fUHWGj1N6h5CrQAHQI6sZ7eNnojW8=;
        b=MAnnbKl3cqxlzEfW7eMtsWDL6/da8Ii/qpuq+LbMqdikPYaNNDXjvG0o4ZaJ77kIp/
         XeiGCvoVHahcA8MJ/GVgMZLNw4fiu2ZhjM0dAXIr+A3hSmSjZOu+mObBLP8OB45Wompp
         oVBAINJl+ZJ/yDQn/Rg1Oc2QIYNR8hSH+oftyDtkMoIkm1Q+f64f7114gxxd8PkglWbZ
         tm5ORBtDYcBBZqwZAgno9hczmEoZKVYaPPb3nzBX0aO3/1g/u7rveNmeBkLNZ4/GDuhQ
         OFFIm9KYH7v0iJzRM7Vp09oPbMFKtOTgYKjJbLGQ02uxW6sWMYzEDOa/huovuMYeTeO0
         Mi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yHTfa3Xf5bj7v/fUHWGj1N6h5CrQAHQI6sZ7eNnojW8=;
        b=3jcKq67w8WIeq3q8fumwAE9Jmwy3w3z4WdTfsRnNIwGv6GA/XTIlyJ99JINTE2m4uP
         CHYNwHqoSdg/FRnrqw1Q7yFb4m+UYwZ+Ymrk75b0xfWu0zkRPh3ARrdSyg3x4HYKGwrO
         tV9tVT+NKOFg8EG8SRaVq4Q8kg5m330j6zwi2/bikZt2x4DQ1jA7nMwqcPaOjXbzzGpz
         36UbgptxdJ3d/VqTD1FoML3qe5MM9O4UUvfhLNSYv8HG3JRsFYQL2DRTSPZwmdH6wN7Y
         FJvQcDasRQT6V1XoLKbYCAeG8yf1btVXhM27FCwShYzKlMuYAv0/zOUJA8PcVx28Pj2j
         6BXg==
X-Gm-Message-State: AOAM5325RFt0RLz+cTA07GT//OA2eCNITuPuMEQwAUnbCMko4fVswQqH
        HJQUBoHCys+ytSFXUBft8xsDHg==
X-Google-Smtp-Source: ABdhPJwbpwlnXADYDuPZIElPaEMuJWqItAHdvKGTzpWfJgQW8OP0lTZa2kMX8zjoPNXQJ8ygePNB3A==
X-Received: by 2002:a17:90b:1a87:b0:1c7:3d66:8cb with SMTP id ng7-20020a17090b1a8700b001c73d6608cbmr17530826pjb.142.1649357433648;
        Thu, 07 Apr 2022 11:50:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x25-20020a056a000bd900b004faae43da95sm22338158pfu.138.2022.04.07.11.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 11:50:33 -0700 (PDT)
Date:   Thu, 7 Apr 2022 18:50:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 18/31] KVM: nSVM: hyper-v: Direct TLB flush
Message-ID: <Yk8ydRqaIqLh/UjJ@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-19-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-19-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> @@ -486,6 +487,17 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  
>  static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VPID or

Can you use VP_ID or some variation to avoid "VPID"?  This looks like a copy+paste
from nVMX gone bad and will confuse the heck out of people that are more familiar
with VMX's VPID.

> +	 * L2's VPID upon request from the guest. Make sure we check for
> +	 * pending entries for the case when the request got misplaced (e.g.
> +	 * a transition from L2->L1 happened while processing Direct TLB flush
> +	 * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
> +	 * anything if there are no requests in the corresponding buffer.
> +	 */
> +	if (to_hv_vcpu(vcpu))
> +		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +
>  	/*
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
