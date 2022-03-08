Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFBD4D1C07
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347920AbiCHPnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347923AbiCHPnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:43:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5D084ECE1
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646754133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhYHAsXF5yiiujOGmxjqRxR0fzj0qbNtFN5jPjLVxlA=;
        b=aI7lOLGioH4baGG8qWv4Rcl4etRcIH+Bl+5Z5y5RKB7ZuVfbjvLlEvMllcgIPjjGEJYizg
        5xzeQXIMaYkY9mKO/UnqyykxviR0ujSjT44AQlJmIpG4VW93Nzu1kq8oiqLscuODMHVDD0
        RD6Fbo5syedHEXpUhxfE49jVLPxFZ2E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-Y8m5J9wTOv-3cEJqvbOTUA-1; Tue, 08 Mar 2022 10:42:11 -0500
X-MC-Unique: Y8m5J9wTOv-3cEJqvbOTUA-1
Received: by mail-ej1-f69.google.com with SMTP id og24-20020a1709071dd800b006dab87bec4fso5432010ejc.0
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:42:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AhYHAsXF5yiiujOGmxjqRxR0fzj0qbNtFN5jPjLVxlA=;
        b=n7yYNIwwCUJyLcOW73Apj2FWBV/YYrMBu1k+Z9V9zD5rZFKvIQcK+EAA7Obd+X2+AX
         QPRRRyiLu1qYl3Vnk3lGkE1BV0LUqVwldZVhZldnALa03hnW/CW64dYGYCHLunTxN3xY
         s6ySM7CXP6DdqF+B0GxSBvoi8t+u/CZJg4IZ9uGarnMifBdxJ94A02+ye5xkpmQXeeZf
         q6Wpjy3U8EVXrTYvBJ9rPlaI5l040tAcRtN49D6nBuyJ27wpszK/aPOeeUX6TLRcgJZP
         MpJafuMAuRVX6UYwdWY9ZMyepThX7GdviJ36S+Rf1GPPqbrwHQAL++mxSm/CwT7tKPz5
         tuVg==
X-Gm-Message-State: AOAM531T7uNx5mYuXcIZgkdP9PXtNj9wPWQvx0y6XQWFqVI89xww/AxM
        9H+UhWVbgpJsvvASrVco8runUl2m1AISNWlkMMH2sPB1Sq9FAPo/7Ie/KBSbZx/zUouUIDFPo+2
        MulDPIX0L45Bl
X-Received: by 2002:a17:907:1c10:b0:6da:6316:d009 with SMTP id nc16-20020a1709071c1000b006da6316d009mr13802035ejc.621.1646754130380;
        Tue, 08 Mar 2022 07:42:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOax+6UY08VWNomTPhnBsU4AFg8pn6Nrbdmfsvfs3P5BKegPJN7tdGqHptllnZGy6UkWatAw==
X-Received: by 2002:a17:907:1c10:b0:6da:6316:d009 with SMTP id nc16-20020a1709071c1000b006da6316d009mr13802022ejc.621.1646754130145;
        Tue, 08 Mar 2022 07:42:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z17-20020a50f151000000b004162ecc0c9fsm4501274edl.68.2022.03.08.07.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 07:42:09 -0800 (PST)
Message-ID: <1211efe5-ebe4-1f8e-397f-2e74a17d6e76@redhat.com>
Date:   Tue, 8 Mar 2022 16:42:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH] x86: Update the list of tests that we run
 in the Cirrus-CI
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20220308123538.538575-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220308123538.538575-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 13:35, Thomas Huth wrote:
> The new tests that have been added in commit bc0dd8bdc627f0
> ("x86/debug: Add single-step #DB + STI/MOVSS blocking tests")
> require a fixed kernel which we don't have in the Cirrus-CI yet,
> so let's disable the failing "debug" test for now.
> 
> The "pcid" test has been renamed to "pcid-enabled" in commit
> cad94b1394aa519 ("x86: Add a 'pcid' group for the various PCID+INVPCID
> permutations").
> 
> Some additional tests are working fine now, too (pcid-asymmetric, msr,
> vmx_apic_passthrough_tpr_threshold_test, vmx_init_signal_test,
> vmx_pf_exception_test, vmx_sipi_signal_test), likely since the update
> to Fedora 35, so we can also enable them in the CI now.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   ci/cirrus-ci-fedora.yml | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
> index a6b9cea..6eace8b 100644
> --- a/ci/cirrus-ci-fedora.yml
> +++ b/ci/cirrus-ci-fedora.yml
> @@ -20,7 +20,6 @@ fedora_task:
>       - ./run_tests.sh
>           access
>           asyncpf
> -        debug
>           emulator
>           ept
>           hypercall
> @@ -33,8 +32,10 @@ fedora_task:
>           ioapic
>           ioapic-split
>           kvmclock_test
> -        pcid
> +        msr
> +        pcid-asymmetric
>           pcid-disabled
> +        pcid-enabled
>           rdpru
>           realmode
>           rmap_chain
> @@ -59,6 +60,10 @@ fedora_task:
>           vmexit_tscdeadline_immed
>           vmexit_vmcall
>           vmx_apic_passthrough_thread
> +        vmx_apic_passthrough_tpr_threshold_test
> +        vmx_init_signal_test
> +        vmx_pf_exception_test
> +        vmx_sipi_signal_test
>           xsave
>           | tee results.txt
>       - grep -q PASS results.txt && ! grep -q FAIL results.txt

Thanks, please go ahead and push this.

Paolo

