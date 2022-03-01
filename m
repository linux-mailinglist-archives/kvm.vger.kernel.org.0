Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45E74C9280
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiCASCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiCASCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:02:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E737364BD2
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646157710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vC3jRvgjxiHHWCObfMQOTUeJWucpIxxqG1tIi+VkA4s=;
        b=G70wyj/iVCr6hbdlC6OSvr6o4N+22wSY0LuICN1BoToaNKLotAmqc8OmsOCMn2MTqK6OPS
        izobJpkxpX0IYRLUcQHn3X9nEiOyr887j6kFYBQCPs0jqWnsbPqYOxEACfbYIW15wBrwJX
        fN7QCF57S/UY6uhsudtrKEqY4tswEow=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-cVI3Cm9CN1GE3MLourZSRQ-1; Tue, 01 Mar 2022 13:01:47 -0500
X-MC-Unique: cVI3Cm9CN1GE3MLourZSRQ-1
Received: by mail-wr1-f71.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so3599917wrp.10
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 10:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vC3jRvgjxiHHWCObfMQOTUeJWucpIxxqG1tIi+VkA4s=;
        b=a4/BoBUT/8LHYZO3CQ2oY8xo2fYpC0Xw4H8OjMohOIo9tsdrwcBp26uoYMek6cZE+H
         hxk2TzBFgu+AscyrkrCLMSxmAndHzkb2vjXUqTrOrKqU1UatPwWatjd4YR2F0JjgkDGf
         /nMj8M/MydQuYyxx0fbXzcHDqQSL6Bk2L0LK6zea45dgpJAD241caATARBLgC5LL8UDW
         mpOCCVXOTsRoYURPglgA/C9ShIfu+yStLr0dy3CAY4DzBlqkYyPRMNsbHfpJclf/h6U+
         J5YuGnKem1cckKlBrhUwp1+DrkDY+VOnmJluoFjU1rHe9bPhrOoF7H5hyeHiGt5ST574
         vm+A==
X-Gm-Message-State: AOAM532XiVsErqmKI2sfH46saWftCXFvvDtCGY/PaIJLopgNfL839i73
        /johDg9pwPGi1PPoNpFPx7gzm7N3TTYS25V5GjyUxdcTu7fLMcQMs1oJTH8mPzo7gKan5Gco/P/
        Sk7kK4UobmPvr
X-Received: by 2002:a5d:6211:0:b0:1ef:85dd:c96b with SMTP id y17-20020a5d6211000000b001ef85ddc96bmr12251075wru.456.1646157706390;
        Tue, 01 Mar 2022 10:01:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOCc8N/yzaGMbDUmMRscLuKpd1KFyw5zGQyUM1JpCBNL/kdDlQCwQWT9Ouxag0VgEwgDpIuQ==
X-Received: by 2002:a5d:6211:0:b0:1ef:85dd:c96b with SMTP id y17-20020a5d6211000000b001ef85ddc96bmr12251063wru.456.1646157706179;
        Tue, 01 Mar 2022 10:01:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id z10-20020a056000110a00b001ea75c5c218sm14239404wrw.89.2022.03.01.10.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 10:01:45 -0800 (PST)
Message-ID: <c2919129-2e56-d3df-f439-8085430005d9@redhat.com>
Date:   Tue, 1 Mar 2022 19:01:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/8] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL
 ctrl bits across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-3-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301060351.442881-3-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 07:03, Oliver Upton wrote:
> +
> +	/*
> +	 * KVM supports a 1-setting of the "load IA32_PERF_GLOBAL_CTRL"
> +	 * VM-{Entry,Exit} controls if the vPMU supports IA32_PERF_GLOBAL_CTRL.
> +	 */
> +	if (kvm_pmu_version(vcpu) >= 2) {
> +		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +	} else {
> +		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +	}

This one I understand, following what's done with MPX, but I cannot make 
sense of the commit message just like in the case of patch 1.

Paolo

