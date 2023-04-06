Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04DF6D9DE6
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238100AbjDFQuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjDFQuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:50:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC2E19BF
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 09:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680799754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q+Gfg05cQPDtS43GkKaCQ4aGNXkaY2YNenXZC8M2OQs=;
        b=KsEE68SBFiLaBNqjniT10g6UGFcZGDsiCX3f/2lY/dOUBJKRyx6K33LWWGQvhKNHnRaTJL
        VsXM+Tn/5zjkQhW9DeLCgRUqI4u98mltxPaLjxsi2zJxG9d0sBEaz5uObZl5u/GgqnM0Fj
        ftoYAnHTbBZOza9O3+uLVu2JlUrHETc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-REYjXt6CMnKRKeByL0qm5A-1; Thu, 06 Apr 2023 12:49:13 -0400
X-MC-Unique: REYjXt6CMnKRKeByL0qm5A-1
Received: by mail-ej1-f70.google.com with SMTP id fy17-20020a1709069f1100b00948fd62a55cso485258ejc.0
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 09:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680799752; x=1683391752;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+Gfg05cQPDtS43GkKaCQ4aGNXkaY2YNenXZC8M2OQs=;
        b=jw9l/uDFJo8NEUVhkaQ8cxtR+OX5wZpL6McwT4Y+wdkKHKpsFvR6BqDrW4krUUiN4f
         rzhcLn0NIIiqqG11GsLfScxNb8pBHAYwONspCgT+1BcUpAxSfFnlO11+++nzdx4LsWBo
         60kE0lE1x4WhI6A9e9UfRfPu3scVTSzdsML70ceT4Qi3X4CRUipCs3iZtxBX9lEcpn4w
         qtdZLrM7RFZeRkX78HcjJGe68Vcd8rgJYIU/ToDCkY1xqXIkstYh7t1xWrmWg9lVb27T
         DnrdUwX1+JFwo7yG9yt6YHlsUNlOIzmcZeXFRTF3sfaC+x/zQPiOtTKBLbks1vN8hw7q
         7u7w==
X-Gm-Message-State: AAQBX9fR9jpvZbfQ/GZfIKdQ8bYhj2ncnjDWPqjxz6TphUNSE2M715EF
        sQuBhyPzr55ofLTf/Be5yRSckknpBKaQ/ll6z9wEYI49CMbswI2slUBnjLJGdgcANYGezRaCJV6
        X9v0sLSjjLSGJ
X-Received: by 2002:a17:906:430a:b0:914:4277:f3e1 with SMTP id j10-20020a170906430a00b009144277f3e1mr7639950ejm.53.1680799751965;
        Thu, 06 Apr 2023 09:49:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y8K4otQ0Dp5BHGvGfNLyed8QEXdtIiNSDuFTZh/fyGAVBDPavs1sn4976pDJ6UODZISRyUzA==
X-Received: by 2002:a17:906:430a:b0:914:4277:f3e1 with SMTP id j10-20020a170906430a00b009144277f3e1mr7639936ejm.53.1680799751678;
        Thu, 06 Apr 2023 09:49:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id l18-20020a50d6d2000000b004c0239e41d8sm947787edj.81.2023.04.06.09.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 09:49:11 -0700 (PDT)
Message-ID: <a20536f0-efa1-a30a-a1fc-7fc29029a81f@redhat.com>
Date:   Thu, 6 Apr 2023 18:49:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH][v2] x86/kvm: Don't check vCPU preempted if vCPU has
 dedicated pCPU and non-trap HLT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     lirongqing@baidu.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org
References: <1680766393-46220-1-git-send-email-lirongqing@baidu.com>
 <20230406095711.GH386572@hirez.programming.kicks-ass.net>
 <ZC7ugeST1OOdNANg@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZC7ugeST1OOdNANg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/23 18:08, Sean Christopherson wrote:
>> Signed-off-by: Li RongQing<lirongqing@baidu.com>
>> ---
>> diff with v1: rewrite changelog and indentation
>
> This also fails to mention my objection to querying PV_UNHALT[*].  When I said
> "this needs Paolo's attention no matter what", I did not mean "post a v2 and hope
> Paolo applies it", I meant we need Paolo (and others) to weigh in on the ongoing
> discussion.

Quoting v1:

>> +		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
> 
> Rather than have the guest rely on host KVM behavior clearing PV_UNHALT when HLT
> is passed through), would it make sense to add something like KVM_HINTS_HLT_PASSTHROUGH
> to more explicitly tell the guest that HLT isn't intercepted?

Yes, I agree with adding KVM_HINTS_HLT_PASSTHROUGH or 
KVM_HINTS_GUEST_CSTATE (i.e. host can remain in guest mode even when 
running in C1 aka hlt or possibly deeper states).

Lack of PV_UNHALT does not indicate anything about whether HLT will be 
handled in host or guest.  In fact the same KVM_HINTS_* value could also 
be used to disable PV_UNHALT.

Paolo

