Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D959542947
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiFHIV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 04:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiFHIUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 04:20:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3D2D39FD5D
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 00:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654674445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NllZgEM9+Xgx+C0OKxvAQxMq/QfRXHmPWsigKuRrfkU=;
        b=VaivpsyaMJHF9/JV7zW5ZoJOCZzJoLC1/OJHrWZ5D8h4kGAEKbSP0IbeZXzAkBG7Z1R7W6
        dDdTDhy8jWYGl2hnM9pNpj8cSv9zLH+zfZUKAUEnhttbb0Fx6Ced8zwNaBBktZfp1aGSH2
        v1pInSQy74rowHazc3ssG1k/hCkImrQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-bgRnLPXKNCuIc58MjiYohg-1; Wed, 08 Jun 2022 03:47:22 -0400
X-MC-Unique: bgRnLPXKNCuIc58MjiYohg-1
Received: by mail-ed1-f70.google.com with SMTP id y4-20020aa7ccc4000000b0042df06d83bcso14316949edt.22
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 00:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NllZgEM9+Xgx+C0OKxvAQxMq/QfRXHmPWsigKuRrfkU=;
        b=OuWSPBxkUBfPz7hPw+BMGHh/jg3SuDD7wBW+Rq9dWTcDCa6Wyb7E3xa/pFdDZ0eTFs
         UKZgI4PRHy551VqB3JvrQhlcNQfiptP21uVCIGMfX3ApWOdsjoIH7zeWaCiM+VbqGQka
         vXvDRFXlMQDmMquB4W/V40kiRb2cC/uT+G7lLbk49KCRRvnGt97Hu77YxrAbw5PxK6be
         AGeyrtLHCgfseuErMDIOO3QPZ4IS311wDzNVUHLy8lAow7AlTiy4fkQi7vC/ijUNts9E
         DNarvHgjrGgDqwOs0MXrFDcoJO4Pjl8OLVgtkobIT9vSxJC7xkGKFTsZjATBTTwcDl2w
         iq7A==
X-Gm-Message-State: AOAM532e5FePI3gp31M5JX8tu9fi4n9CxwJWy7YlkxZ8L+0LvRK1xUX2
        hjIV4WR+J2SLpLYXsmINJeKppaa6I1LM2W9oozga+3qEDLbFOrVmh5SypYbW3GjGe41DDB2QiZy
        jBYqzULmCqSTU
X-Received: by 2002:a05:6402:1c91:b0:42d:c9b6:506b with SMTP id cy17-20020a0564021c9100b0042dc9b6506bmr37157639edb.166.1654674441645;
        Wed, 08 Jun 2022 00:47:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ6zCbgAByK4tcMjAhyVE5Ffevs0gRLanA9Oj8rlcZDVQlPs1lvb3eSpEaGo0jBy/TWir7Tw==
X-Received: by 2002:a05:6402:1c91:b0:42d:c9b6:506b with SMTP id cy17-20020a0564021c9100b0042dc9b6506bmr37157626edb.166.1654674441430;
        Wed, 08 Jun 2022 00:47:21 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h4-20020a1709067cc400b006f3ef214ddbsm8815010ejp.65.2022.06.08.00.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 00:47:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 03/38] KVM: x86: hyper-v: Introduce TLB flush fifo
In-Reply-To: <4be614689a902303cef1e5e1889564f965e63baa.camel@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
 <20220606083655.2014609-4-vkuznets@redhat.com>
 <4be614689a902303cef1e5e1889564f965e63baa.camel@redhat.com>
Date:   Wed, 08 Jun 2022 09:47:19 +0200
Message-ID: <87bkv3mwag.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
>> To allow flushing individual GVAs instead of always flushing the
>> whole
>> VPID a per-vCPU structure to pass the requests is needed. Use
>> standard
>> 'kfifo' to queue two types of entries: individual GVA (GFN + up to
>> 4095
>> following GFNs in the lower 12 bits) and 'flush all'.
>
> Honestly I still don't think I understand why we can't just
> raise KVM_REQ_TLB_FLUSH_GUEST when the guest uses this interface
> to flush everthing, and then we won't need to touch the ring
> at all.

The main reason is that we need to know what to flush: L1 or
L2. E.g. for VMX, KVM_REQ_TLB_FLUSH_GUEST is basically

vpid_sync_context(vmx_get_current_vpid(vcpu));

which means that if the target vCPU transitions from L1 to L2 or vice
versa before KVM_REQ_TLB_FLUSH_GUEST gets processed we will flush the
wrong VPID. And actually the writer (the vCPU which processes the TLB
flush hypercall) is not anyhow synchronized with the reader (the vCPU
whose TLB needs to be flushed) here so we can't even know if the target
vCPU is in guest more or not.

With the newly added KVM_REQ_HV_TLB_FLUSH, we always look at the
corresponding FIFO and process 'flush all' accordingly. In case the vCPU
switches between modes, we always raise KVM_REQ_HV_TLB_FLUSH request to
make sure we check. Note: we can't be raising KVM_REQ_TLB_FLUSH_GUEST
instead as it always means 'full tlb flush' and we certainly don't want
that.

-- 
Vitaly

