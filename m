Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BCD657634
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 13:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiL1MAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 07:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiL1L7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 06:59:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DE011445
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 03:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672228741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ytmtT6Wc4jP+D7KnHgvblT0TRWEyfzn6TxOBcbCw6w=;
        b=LoOX6F0zrximfKKoTK1KEsGFYbNtmJBOOYRw2yuMdzTewLxrzhKbKeM3kF9/+drSjGg1nB
        bG1Ph1hW47zvneFcL/ziPXMPQIgim2YzhzGWbCwl0r0vkbtPUujCfI57PcYvyDkOdELzbz
        1H6s5DuUR7VG3AxeKv16rgov9NGXCgM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131-JuS3gv3INUa6kLv4dyKhkw-1; Wed, 28 Dec 2022 06:58:59 -0500
X-MC-Unique: JuS3gv3INUa6kLv4dyKhkw-1
Received: by mail-ed1-f69.google.com with SMTP id w3-20020a056402268300b00487e0d9b53fso1878430edd.10
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 03:58:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ytmtT6Wc4jP+D7KnHgvblT0TRWEyfzn6TxOBcbCw6w=;
        b=NcVQP/Nj9PnelVQDOk7FLedk2Ht8Fo1ZcucZ0Yx6OYlTFkcNoxeyVF5/pW85kbDOGa
         xz+7QDjWpFlO8v6cJRJmLCL5KXupY+1PWGM1hNqLeUgh+8OTMrLs043K0T4epNPrc0of
         mk/E37una1OVLyq9Fdrawo8YE7nkgfALmOISL6rjzz9djPwmi1pW/Do6RJIjo5nPvMw0
         /tioSm/49zq9wMaNqoUbqWR1zUjQgQa97S112Ru7iIa2GhwpuTXBJj9egQ0JociPMzn4
         H1tgqSxNYgOxdnSpDuj92/vVvUrLnAnaxbRtVlTAT1LnVMmILcT1IHOWForVlMgzB+Tz
         C27w==
X-Gm-Message-State: AFqh2kogA7xqKjxWrAiXVqpkKCxyLN5RTrZALwjeL/blcX0X3GaRSAtq
        cPy5jrh5vRKQJsgGh4RNu/yUICJ2aheTR5pZdI1NuVaH7yeu4FfzBoeOMWSEbHrLXHEP7+zn4Pg
        fWsI/ieqNxWQK
X-Received: by 2002:a17:906:370a:b0:7c0:a350:9d29 with SMTP id d10-20020a170906370a00b007c0a3509d29mr21055409ejc.18.1672228738319;
        Wed, 28 Dec 2022 03:58:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtJuq7akBikh/9xBW4s5L8HL1iMP+rMCtmjlV6irHY3usLxRtdcjdv4s6MJ5BZlung0XQ3vgw==
X-Received: by 2002:a17:906:370a:b0:7c0:a350:9d29 with SMTP id d10-20020a170906370a00b007c0a3509d29mr21055399ejc.18.1672228738136;
        Wed, 28 Dec 2022 03:58:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b004678b543163sm6982082edt.0.2022.12.28.03.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 03:58:57 -0800 (PST)
Message-ID: <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
Date:   Wed, 28 Dec 2022 12:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
 <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
 <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
 <4ed92082-ef81-3126-7f55-b0aae6e4a215@redhat.com>
 <9b09359f88e4da1037139eb30ff4ae404beee866.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9b09359f88e4da1037139eb30ff4ae404beee866.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/28/22 10:54, David Woodhouse wrote:
>> Yes, I imagine that in practice you won't have running vCPUs during a
>> reset but the bug exists.  Thanks!
> If it's just kvm_xen_evtchn_reset() I can fix that — and have to
> anyway, even if we switch the Xen code to its own lock.
> 
> But what is the general case lock ordering rule here? Can other code
> call synchronize_srcu() while holding kvm->lock? Or is that verboten?

Nope, it's a general rule---and one that would extend to any other lock 
taken inside srcu_read_lock(&kvm->srcu).

I have sent a patch to fix reset, and one to clarify the lock ordering 
rules.

Paolo

