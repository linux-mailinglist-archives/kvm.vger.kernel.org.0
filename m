Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC3454E60B
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377903AbiFPP2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbiFPP2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:28:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D7E6248FB
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655393325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XskGf25OAiPtPSUK4BxcnPczRA0Oydi/igOaaTpXUSQ=;
        b=bdDBnxXql2SOny0hceigHtBqaMQQEQeNGOv8yJdKDVIWqxcdrE0YHy2hAdDU1Lib9mWMOc
        FFLTWBu+k2XFHJyfRYAMiqO9A2R+2RQ3Pgu6hlVnpkyNS//GIrTuPKXnWknevWxw3NU+3j
        EJFnXXN5KfVdQRTyOCYv/RfDszXny8I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-6nfnIUjxN7em9GxzCzGe6A-1; Thu, 16 Jun 2022 11:28:43 -0400
X-MC-Unique: 6nfnIUjxN7em9GxzCzGe6A-1
Received: by mail-ed1-f69.google.com with SMTP id eh10-20020a0564020f8a00b0042dd9bf7c57so1485189edb.17
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=XskGf25OAiPtPSUK4BxcnPczRA0Oydi/igOaaTpXUSQ=;
        b=Kv884aT2ehDpTc/S43O8qLOTn8Ha3fdbqfvqqJgo/uwjtjQT2L16tWGNJiRUR6yR/m
         1nspeFrsuDDtx8X2WX6zyt48TuPEDMmydGN+4YM+ZsLCmxqsq8Vq86m5/Jag7Ke1vx0E
         qTHb62fwUXAJMWiLj+lIjQgfs2MRQVpeDRXzLC3DeYUWW6G+7DB+ul/iURmOV/+ERQlv
         APtd52UJwMK/5fMYjDrYBiaGFLWAFuWhHZcG3IsR1G2ehAZneuAcFxoGpEE/7FkDohoN
         l1rwTaQ7djmplwx4KgFc7pXXA3Jugl8DeXWAim3xITGuaCb2vALuNGSWoFCjSXM1FBL7
         1ijg==
X-Gm-Message-State: AJIora/diArecBpcVoZ57+7tdK0z+FSz4jXkFQ8IG18c0r2RmFokjB99
        Po6q5bZs6ACbjWDEv/EptrmgMLZpEsqkmtCYdrC4c+WNVQKPrpn0H9O064ULJaxViZI2eNiUUxC
        ObtSRTQQs398r
X-Received: by 2002:a17:906:7a4a:b0:712:c6d:46df with SMTP id i10-20020a1709067a4a00b007120c6d46dfmr5085386ejo.314.1655393322557;
        Thu, 16 Jun 2022 08:28:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJsE6d4JZOi53Tz2XAP/rgRHZ/OSAOnXOCoxVH7wTJZGlMIVUlbi95yyig9j53CDCfTpb6Jw==
X-Received: by 2002:a17:906:7a4a:b0:712:c6d:46df with SMTP id i10-20020a1709067a4a00b007120c6d46dfmr5085361ejo.314.1655393322317;
        Thu, 16 Jun 2022 08:28:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w12-20020a056402268c00b0042aaaf3f41csm2083977edd.4.2022.06.16.08.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 08:28:41 -0700 (PDT)
Message-ID: <8a38488d-fb6e-72f9-3529-b098a97d8c97@redhat.com>
Date:   Thu, 16 Jun 2022 17:28:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
 <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
 <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
In-Reply-To: <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/22 16:18, Peter Zijlstra wrote:
> On Thu, Jun 16, 2022 at 12:21:20PM +0200, Paolo Bonzini wrote:
>> On 6/16/22 12:12, Peter Zijlstra wrote:
>>> Do I understand this right in that a host without X86_KERNEL_IBT cannot
>>> run a guest with X86_KERNEL_IBT on? That seems unfortunate, since that
>>> was exactly what I did while developing the X86_KERNEL_IBT patches.
>>>
>>> I'm thinking that if the hardware supports it, KVM should expose it,
>>> irrespective of the host kernel using it.
>>
>> For IBT in particular, I think all processor state is only loaded and stored
>> at vmentry/vmexit (does not need XSAVES), so it should be feasible.
> 
> That would be the S_CET stuff, yeah, that's VMCS managed. The U_CET
> stuff is all XSAVE though.

What matters is whether XFEATURE_MASK_USER_SUPPORTED includes 
XFEATURE_CET_USER.  If you build with !X86_KERNEL_IBT, KVM can still 
rely on the FPU state for U_CET state, and S_CET is saved/restored via 
the VMCS independent of X86_KERNEL_IBT.

Paolo

> But funny thing, CPUID doesn't enumerate {U,S}_CET separately. It *does*
> enumerate IBT and SS separately, but for each IBT/SS you have to
> implement both U and S.
> 
> That was a problem with the first series, which only implemented support
> for U_CET while advertising IBT and SS (very much including S_CET), and
> still is a problem with this series because S_SS is missing while
> advertised.

