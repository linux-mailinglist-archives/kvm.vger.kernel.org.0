Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8676CA8D0
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 17:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjC0PUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjC0PUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 11:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436E610F0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679930401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBXULJ0YJW6Vv+dTm+DQzBsn3dK4XBiUD4aYtQvteI8=;
        b=GSrmkCUPp2kiMm6J6fCDvpSolJYwSY3zqUPij4r4QxNWzVlSsVCnyf4wBhgwUA9G24FL4B
        GEyk55FLHxmWYaFPjiKrkfsHtaI9lkM4NAXp0jMhkSqG92F9OFGrkIKCFYLS/Llz2BIc+N
        cmJfBAHIrQ8cLn6L9aav+nuSUJ76yzs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-wRSSFYcKN1SejWKShSHtmg-1; Mon, 27 Mar 2023 11:19:59 -0400
X-MC-Unique: wRSSFYcKN1SejWKShSHtmg-1
Received: by mail-ed1-f70.google.com with SMTP id q13-20020a5085cd000000b004af50de0bcfso13358981edh.15
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679930397;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBXULJ0YJW6Vv+dTm+DQzBsn3dK4XBiUD4aYtQvteI8=;
        b=MP/kvAi6IfEtihvHRQ06BqIfvn18/4tV2IHqbnveXetPYf4sTTFNOIGZwGdH2MMTYz
         kAVzYWdHBG+GLonK8+m/eX/MugJGrsDtYRM3AveDmxcbBOSkIkbX70NlhLtwzzUi1926
         f+8oLo2ZdfVuDkt4S5CcSyFKdmxdsRHkRq8Dh/ropjWXIIQH7M1waIR4VaMd+GfgdI7S
         2fyWepfKj3m2PoVMszancrBLNOZYeBd/0q2t5n75x0KRza7FRfnybJLNqG6A5EwXvMM1
         ObWSuIM9ype2DUlsahSpsvINId/ZOFqanjSIIQ9+zMf03POSr8RhiYxh1g7gYVvF66MV
         mxQA==
X-Gm-Message-State: AAQBX9dTtvXzG2jMwGAh7k6hOGpMWyFp/7VBiTOtbFy3Nw1KsKquj0bX
        mg00x3rAJ3qE0dJXFs/F2iRpm9WNjqXOWguaWRUsT6qJO8ou49UrAqFhyrSW0HALLpxbOw2X+zP
        KzH+Nx3tbKdqm
X-Received: by 2002:a17:906:f6cd:b0:92f:b8d0:746c with SMTP id jo13-20020a170906f6cd00b0092fb8d0746cmr12315933ejb.20.1679930397764;
        Mon, 27 Mar 2023 08:19:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350amEJt/4jKby5lbzCbh7fHRRBROfolwArbQtP8/z/b3EANonkAshH00FVXH2WUDdpY6F6QaDQ==
X-Received: by 2002:a17:906:f6cd:b0:92f:b8d0:746c with SMTP id jo13-20020a170906f6cd00b0092fb8d0746cmr12315913ejb.20.1679930397502;
        Mon, 27 Mar 2023 08:19:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id r12-20020a50c00c000000b00501d2f10d19sm10349379edb.20.2023.03.27.08.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 08:19:56 -0700 (PDT)
Message-ID: <151c3b04-31db-6a50-23af-c6886098c85c@redhat.com>
Date:   Mon, 27 Mar 2023 17:19:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/6] KVM: x86: Unhost the *_CMD MSR mess
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20230322011440.2195485-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230322011440.2195485-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/23 02:14, Sean Christopherson wrote:
> Revert the FLUSH_L1D enabling, which has multiple fatal bugs, clean up
> the existing PRED_CMD handling, and reintroduce FLUSH_L1D virtualization
> without inheriting the mistakes made by PRED_CMD.
> 
> The last patch hardens SVM against one of the bugs introduced in the
> FLUSH_L1D enabling.
> 
> I'll post KUT patches tomorrow.  I have the tests written (and they found
> bugs in my code, :shocked-pikachu:), just need to write the changelogs.
> Wanted to get this out sooner than later as I'm guessing I'm not the only
> one whose VMs won't boot on Intel CPUs...

Hi Sean,

did you post them?

Paolo

