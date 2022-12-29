Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C19B659200
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiL2VHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiL2VHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:07:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4314E1E4
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672347989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=it+B1PS32dTGPCypZI1aX6Ei43ZO2hTLVkDexUvu2GQ=;
        b=ac7MxG5VAy52JNbTCyvMGWawtJF0Rzfztc+8H+AMQ1HQ0Zo/43H5VVSKVMguKx8fvS77OJ
        3q/9XbFVd7ed3ycE4os6JoY8yG11RlXZxsOcKrVpzIDVWpYwbFBsHVaoMbex0BicGGPcSZ
        CwDSI/WJGxw64znkuO1JQU1BIYYdsVk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-266-3qpcaH4dNcmAd5VOqhgXRw-1; Thu, 29 Dec 2022 16:06:27 -0500
X-MC-Unique: 3qpcaH4dNcmAd5VOqhgXRw-1
Received: by mail-ej1-f71.google.com with SMTP id dr5-20020a170907720500b00808d17c4f27so12919153ejc.6
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:06:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=it+B1PS32dTGPCypZI1aX6Ei43ZO2hTLVkDexUvu2GQ=;
        b=jAMMRL76JKo+DZ/Fmvnr5cTXNudZMhWJLXx3qU0UDqvNjBHzg/w5K4tPMowMrXR/sH
         RTzzTQmNomXdYxX+A3bHq7GH4ciwuofwkRlTdQ3JJFKowm50pTcpgyWskzb6JdwPtlcU
         IWTGg1CBE0BYEoCb6G9sbCVeunz6wHeAslZOV7b2Dy5c86s5kcnTawKPc53HkEEBjf4u
         zeR+Bq6l5wxrssWRtIB3QZCAEXQvvNfFUZZufIUzDlSJ4NlnBUc5HcXGKakXAXmVobbU
         n+7SccFKct1L54naZbLPRn2lGwGVagnpF3be6flDP/RFokfyvXhDlobOFx4aMznaE67d
         TOQw==
X-Gm-Message-State: AFqh2kqoRG+KmsLHbyDoGK5PUQryrNEKVRnEU4oR8ayyJNnxfGlhP/TT
        x75EuMt0jAg7OMJiFmP8rP/1STseZccYEeN94jgQmCitl1TJ/moQGrOCC31U3BoWzsFTfzBREPY
        r/M7KGkkpijz9
X-Received: by 2002:a17:907:8c0a:b0:7c4:edee:28c0 with SMTP id ta10-20020a1709078c0a00b007c4edee28c0mr33927893ejc.24.1672347986714;
        Thu, 29 Dec 2022 13:06:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvQL7mNzDT9TfcU620OIPHvZr6KsbN//Mw8YFdfU0TCUvExqxFpww9gz67fGiOGe/8ra1uDMQ==
X-Received: by 2002:a17:907:8c0a:b0:7c4:edee:28c0 with SMTP id ta10-20020a1709078c0a00b007c4edee28c0mr33927879ejc.24.1672347986450;
        Thu, 29 Dec 2022 13:06:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::529? ([2001:b07:6468:f312::529])
        by smtp.googlemail.com with ESMTPSA id c10-20020a17090618aa00b00846734faa9asm8878423ejf.164.2022.12.29.13.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 13:06:25 -0800 (PST)
Message-ID: <49636b4c-10e1-8cec-efdf-e2bd4b832a9e@redhat.com>
Date:   Thu, 29 Dec 2022 22:06:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and
 epilog to its caller
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
 <20221213033030.83345-6-seanjc@google.com> <Y6H2o2ADCALDA2oL@google.com>
 <Y6NRJTboZnjKbAL7@google.com> <Y63v0UnlI+wrrXfa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y63v0UnlI+wrrXfa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/29/22 20:51, David Matlack wrote:
> Your proposal (below) to split out the "lower half" of the page fault
> handling routine works now because that's where all the divergence is.
> But with the common MMU there's also going to be divergence in the fast
> page fault handler. So I prefer to just keep the routines separate to
> avoid thrashing down the road.

Can you put the changes at the beginning of the common MMU series? 
Large parts of the whole common MMU refactoring can be merged piece by 
piece, so they can be taken as soon as they're ready.

Paolo

