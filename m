Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C800A58184C
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbiGZRXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiGZRXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:23:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80182AE32
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:23:42 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 17so13864065pfy.0
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RYd/Wf9A+Gl7q7Q4Y0LDv1uAxl3B2By5eka07c9ExNs=;
        b=kbmPgiASPhECAN6uAjIuk9m/gb82FQMhWDc+IAzpPMphLgarZgzKqSSOK7ZodN2ojK
         itaDmJKyc6zSQrUfUhWvAW+XD0XX8vqOxxo0NNFwhdNqJ381k0ITq8ro9PF43n86T1k1
         BLcV4Yb2EN9xVd2vDTReE70mUoFn6UAovUV7HB95XJcr3ZdJRRGk8nxoV/DYJxLbn/jD
         fAdWVVDo0+Cne21Yk0OJMPgLGEowfu+97dcItW0JMLdXvw0s7kpIt8Wd/+nBP/pyC7tY
         DIKIBlNqMfmS16SVb7SM700bWR6NO9+bXepy9YdFYkDt3Gh7bTrkM2qdw2svUdHqKRl0
         W2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RYd/Wf9A+Gl7q7Q4Y0LDv1uAxl3B2By5eka07c9ExNs=;
        b=riwyhGEmcWq7yDXb51TF4XG1dVRKPYyzooSg0iWWCV4H5IsWJnzYiEptEQc9sgtVzW
         01yQtLK62ZjkZva5TW3ZWlqq1U4ldSfUJgp3iTqFLCaOKsXpSe3eBchRtLgfQ3eQX1NK
         86eqL5TRoDd2Mr+mO47404fcGl3JFwGjC1Dz48Vh7YGZDNmnqLMxm3Qy8rfc7kMNWeZ4
         fJlP4zjvnA6h+6aglMFFYFkdZhnuwXDQ6FUxA+eUSTOb2cErc3eODdXBog12rFW4vVZY
         9wl60t58tmPQyWys30sHzDI4S80OXdxIFzA+kg3El8YAhpTih60gX0MOjeUR770fhCEy
         QZxg==
X-Gm-Message-State: AJIora9w1OywMSfPvd7ce303vJcj+tstqfA2Xt188NpPRUBdHIKYSqro
        XVlbN3FL55LK5ru8cMGR/x0/Xg==
X-Google-Smtp-Source: AGRyM1ttUKIwXitKgzyREOENf2NGddm1MW6feXH9LiyCZ18zDxcjcSDTLajew1xutLtqyAONeEgxgg==
X-Received: by 2002:aa7:82ca:0:b0:51b:cf43:d00a with SMTP id f10-20020aa782ca000000b0051bcf43d00amr18255218pfn.58.1658856222162;
        Tue, 26 Jul 2022 10:23:42 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:18d1:9eac:2d:145c? ([2600:1700:38d4:55df:18d1:9eac:2d:145c])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902bb8500b0016c4331e61csm11844244pls.137.2022.07.26.10.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 10:23:41 -0700 (PDT)
Message-ID: <d6076d60-a7fb-1930-2ace-a0d6e2d19414@google.com>
Date:   Tue, 26 Jul 2022 10:23:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] kvm: x86: mmu: Always flush TLBs when enabling dirty
 logging
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20220723024116.2724796-1-junaids@google.com>
 <Yt7Sh/aN1dlXN21N@google.com> <Yt8aDZDmu/yAwHHC@google.com>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <Yt8aDZDmu/yAwHHC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/25/22 15:32, Sean Christopherson wrote:
> ...
> 
> If we go the "always flush" route, I would word the comment to explicitly call out
> that the alternative would be to check if the SPTE is MMU-writable.
> 
> But my preference would actually be to keep the conditional flushing.  Not because
> I think it will provide better performance (probably the opposite if anything),
> but because it documents the dependencies/rules in code, and because "always flush"
> reads like it's working around a KVM bug.  It's not a super strong preference though.
> 
> Partially, I think it'd be this?
> 

This would work, but I am slightly leaning away from it because it could 
increase CPU overhead in some cases. If you don't have a strong preference for 
it, then I think we could just do an unconditional flush with a more detailed 
comment explaining the interaction with clear_young() as well as the alternative 
of checking the MMU-writable bit.

Thanks,
Junaid
