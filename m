Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119CA4D321B
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 16:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbiCIPr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 10:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiCIPry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 10:47:54 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495F511629F;
        Wed,  9 Mar 2022 07:46:54 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u1so3674918wrg.11;
        Wed, 09 Mar 2022 07:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rUxlp0PyM2gm522aFsSG3DVXlsPAiJ3a25VeEzybOso=;
        b=Xs/DlaSp6/RycZSWX+MQMeH0V4xoWXtgw6dp6jntcLjOLJBzh6hCLiElYScSsGqAuQ
         1FMF30zFbNOLeB9emv3r9+qIiFkPtV86EuJEpUh785jpM8896uqd6z/aGDB4mPXZzg63
         wW5OSRNnNIsHmL4yrUsXQ/JDA629Y9dD5t6Q9PAgsuAMgqPnoF8Emu1HOiXMgnyTPUnd
         ggkZHpinUnsZQ1woMhtepRF+q9QVyw8p7aZsoBtoTD1T+ixRFzEv8m7GdHPOdpIuTWtX
         oI6upBdpKf4pDTMuuAoZZ4nBKdEDOigHvYE8Rrzp3vjok6f+mBD6CrVAs1JWo5xzCgst
         3Iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rUxlp0PyM2gm522aFsSG3DVXlsPAiJ3a25VeEzybOso=;
        b=3uQThw7Khoqh1rfVN25rc5XzdAV3OtDC6ZOiTuAkbXqNq+JJy6Hh56fKP1ZTrVg84d
         Z/Capf3iAUzzGhjszb3O9Vx63qYPV5EgeX7OWnPV361KpiaVGE/nM9XZe4k7/e82xVc9
         iMloKtApkWftqqAzSwCKSaPyy0IV0vgQhZkPvX+c/zWaxJlGmRjhMXbsXmFC4py5SW/4
         nbcRFG3TDxwz6J1YCaSo9C6U4fQmnI9kt4INAZgRyWRNENj5X+EdT+9gr3VmhEUzPKRa
         cVKt2AL4zRbtDQ8JakL7KwfnP3n41ZnDkkb4Wsg37HjQWTStMC+nuWQEIXnaMBOtZq6I
         OueQ==
X-Gm-Message-State: AOAM531knjoLzQFaYRvfYmvCrKS45RC3ekfOv2siUrbzyKJoZ9fm/yLH
        kP4CmKc6LLI+REH2/0a7pdk=
X-Google-Smtp-Source: ABdhPJxeGdN4zPkYLuIwePnp6MzdSYNfgeNRVT49hltNOfqEuL3Wh5n3y3KgFLzKlu4JT509ECjMYg==
X-Received: by 2002:a05:6000:2a8:b0:203:7a50:5dfe with SMTP id l8-20020a05600002a800b002037a505dfemr203939wry.260.1646840812758;
        Wed, 09 Mar 2022 07:46:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o7-20020a5d6707000000b001f067c7b47fsm3089040wru.27.2022.03.09.07.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 07:46:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <da421a98-cca2-aece-b3a2-eb83e9795801@redhat.com>
Date:   Wed, 9 Mar 2022 16:46:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/4] KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-2-mlevitsk@redhat.com> <Yh5KTtLhRyfmx/ZF@google.com>
 <2fddbfd6b6e68f3f8e972536c27a87ffadbe1911.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2fddbfd6b6e68f3f8e972536c27a87ffadbe1911.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 18:13, Maxim Levitsky wrote:
> The fact that we have a stale VM exit reason in vmcb without this
> patch which can be in theory consumed somewhere down the road.
> 
> This stale vm exit reason also appears in the tracs which is
> very misleading.

Let's put it in the commit message:

This makes it a bit easier to read the KVM trace, and avoids
other potential problems due to a stale vmexit reason in the vmcb.  If
SVM_EXIT_SW somehow reaches svm_invoke_exit_handler(), instead, 
svm_check_exit_valid() will return false and a WARN will be logged.

Paolo
