Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15892575214
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbiGNPmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240011AbiGNPm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5E95501BF
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657813346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VOgvUYIncXWnFhKR1hAi50QlDyggks7WiA8ZUF17MI0=;
        b=fg9Up3dG5BJ1rBLTfg42pxeIH9RhD5efYv7NVENMK3zOs3Cf/ibQ3VpTheIsbc4qr132GP
        XfYmmGzXhKxMQdxftaM7hzqv9j+DztAyLD4Bxv3MvZ2nrDEQQcSCcIuhXNDhjux03p3YFN
        dK9fZOaxWVNqdiQmyn4naGlB4CT0j0A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-YaNUFhGYNYukoTnTg8VB_Q-1; Thu, 14 Jul 2022 11:42:25 -0400
X-MC-Unique: YaNUFhGYNYukoTnTg8VB_Q-1
Received: by mail-ej1-f70.google.com with SMTP id gb37-20020a170907962500b0072b820af09dso909916ejc.20
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VOgvUYIncXWnFhKR1hAi50QlDyggks7WiA8ZUF17MI0=;
        b=f2EqQzITBOVHg7c51eT4mMGtx+Yuw1ZBdRlXE5/XkfgeBRzhEHW4651Qm1IWRxvjTf
         VtPRxIyXAtOJFR+0KxEh04Wi5tZSCb6LneRk4ZKyuV2jUWHYKOAB8b/+gWpv1iJsEMyQ
         tqOWUoK3+zfuJP26MMyisQOAiseWIc9by3y2gyvI0JIW50RDpNBTvgyvo2SOIkHGbqd+
         nwBWXGE0QoAJg7MdjE2F+myXtLo9JouWKhgEEaRKzLQNA5gfySR/P3aeO0ltnyMyfs9B
         P5q6q13TuMS1dqfwvIUWgx/qzng5jvh3WLzSB8Gj8BBtxInsaApIpvEyNWGU+HM6SQD0
         i7Pw==
X-Gm-Message-State: AJIora9xXfVoETsEdjNr+m1q23rdv/fE8lpuSvAvj1zhXfFhliMaJNQu
        DOyzV2zbuz0zlyk/w+P5aCuQlW3sDerJw1NoFS2xw5I1b9Z9+DlOqVPwEgO1dnGgbhfEJ3P+ZK2
        DrFsYIfXbSEKY
X-Received: by 2002:aa7:d155:0:b0:43a:bc8d:8d75 with SMTP id r21-20020aa7d155000000b0043abc8d8d75mr13060084edo.322.1657813344365;
        Thu, 14 Jul 2022 08:42:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s7gve3iab4X/ADupNn/dQIy8nWtHC/Qs9AINATQpnZItpmwgA4FIBPCDi8iL7P+4KWrXVlCg==
X-Received: by 2002:aa7:d155:0:b0:43a:bc8d:8d75 with SMTP id r21-20020aa7d155000000b0043abc8d8d75mr13060048edo.322.1657813344150;
        Thu, 14 Jul 2022 08:42:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v6-20020aa7d806000000b0043a754d53e5sm1231016edq.78.2022.07.14.08.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 08:42:23 -0700 (PDT)
Message-ID: <a2ade925-89db-5d05-ba44-e3b77125032e@redhat.com>
Date:   Thu, 14 Jul 2022 17:42:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        shuah@kernel.org, maz@kernel.org, oliver.upton@linux.dev,
        shan.gavin@gmail.com
References: <20220714080642.3376618-1-gshan@redhat.com>
 <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
 <YtA3s0VRj3x7vO7B@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtA3s0VRj3x7vO7B@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 17:35, Sean Christopherson wrote:
>> Can you check that smp_rmb() and smp_wmb() generate correct instructions on
>> arm64?
> 
> That seems like the most likely scenario (or a kernel bug), I distinctly remember
> the barriers provided by tools/ being rather bizarre.

Maybe we should bite the bait and use C11 atomics in tools/.  I've long 
planned an article "C11 atomics for kernel programmers", especially 
because this will also be an issue when Rust gets into the mix...

Paolo

