Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E6957A5D4
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbiGSRxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiGSRxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:53:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB3D95722B
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658253229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MItDTO8wiMTmPmMC7hwJGJQYhU0g3LgyQOjMnVFS+l0=;
        b=cK9COoouET5F/afPHkFmGhQ0E9YQizwgSfMQ56/ChILRa78n7kny07ss7eMC1ip/oSUr4T
        /4PALDn5wIE4vdXxqRRyToQp5imPb3KO0Rj0mDWoldKtSAeLiz42hZBPm/HlNWxWB50nE/
        gsffwZJaU4KNkUPQQDAXme76JNokxsQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-cj5aIdi9MaGaLcjOmfIWUw-1; Tue, 19 Jul 2022 13:53:48 -0400
X-MC-Unique: cj5aIdi9MaGaLcjOmfIWUw-1
Received: by mail-ed1-f70.google.com with SMTP id c9-20020a05640227c900b0043ad14b1fa0so10352494ede.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MItDTO8wiMTmPmMC7hwJGJQYhU0g3LgyQOjMnVFS+l0=;
        b=g618Mxx44VqDjB+9izFk2HCWuvUfCkaNNQ+mWnTW5d0Ff4vE2QLcdQj68Zdk2dFjN5
         FFW6hDgot6VoiE9y5q2pJUA/XbEMDaqRrUVPFoZg+8aCx96TOmEq5Bdtk3sx2mwPhDaM
         kcevKDwCHj76gGRC66L3m2oTh16hwdYVtDIaWUlEVnXaY5vTi/pokQzXIC2UipaoSwtA
         /bzpJYG7xqrqbuiBrojqOABVnd8pnHbuxFRSHyvCr0Egpz9eS4v5O2WBuaz5PgQzrD1f
         pS7+8eF1qO6WKIDznfLkyZt9jKWbxfSLe8LueD0WHkPzMDckrSWMjk3pnygiTBZjCrwj
         c2Fw==
X-Gm-Message-State: AJIora+hYbse3g/ruHZG8uCt20TcgACz/07aiKkEdZXdllecNqq5u38u
        RdVfAJnFggw3ZtDh8P/QhaikTNGI++J78y7K65wW/0j2O5qtWPxQ03S6YeqbojhBeoF0kL8C6Jf
        drIbUxnwBs142
X-Received: by 2002:a05:6402:201:b0:431:665f:11f1 with SMTP id t1-20020a056402020100b00431665f11f1mr45433673edv.378.1658253227247;
        Tue, 19 Jul 2022 10:53:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sVDsLof9rFEOLVqQyisA7CFKHLAH3cjU60EVHU7wzJUA6ffaAaCPuEtsktU89/Wd4QH1q4iw==
X-Received: by 2002:a05:6402:201:b0:431:665f:11f1 with SMTP id t1-20020a056402020100b00431665f11f1mr45433657edv.378.1658253227021;
        Tue, 19 Jul 2022 10:53:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q3-20020aa7cc03000000b0043ba7df7a42sm416874edt.26.2022.07.19.10.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 10:53:46 -0700 (PDT)
Message-ID: <a80507e7-5b9d-6c88-645b-1280535bf155@redhat.com>
Date:   Tue, 19 Jul 2022 19:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/3] selftests: KVM: Improvements to binary stats test
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, seanjc@google.com,
        Oliver Upton <oupton@google.com>
References: <20220719143134.3246798-1-oliver.upton@linux.dev>
 <20220719160914.tqpujfddvifhyfxh@kamzik>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220719160914.tqpujfddvifhyfxh@kamzik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/22 18:09, Andrew Jones wrote:
> On Tue, Jul 19, 2022 at 02:31:31PM +0000, Oliver Upton wrote:
>> From: Oliver Upton <oupton@google.com>
>>
>> Small series to improve the debuggability of the binary stats test w/
>> more descriptive test assertions + add coverage for boolean stats.
>>
>> Applies to kvm/queue, with the following patches applied:
>>
>>   - 1b870fa5573e ("kvm: stats: tell userspace which values are boolean")
>>   - https://lore.kernel.org/kvm/20220719125229.2934273-1-oupton@google.com/
>>
>> First time sending patches from my new inbox, apologies if I've screwed
>> something up.
>>
>> Oliver Upton (3):
>>    selftests: KVM: Check stat name before other fields
>>    selftests: KVM: Provide descriptive assertions in
>>      kvm_binary_stats_test
>>    selftests: KVM: Add exponent check for boolean stats
>>
>>   .../selftests/kvm/kvm_binary_stats_test.c     | 38 +++++++++++++------
>>   1 file changed, 27 insertions(+), 11 deletions(-)
>>
>> -- 
>> 2.37.0.170.g444d1eabd0-goog
>>
> 
> For the series,
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 

Queued, thanks.

Paolo

