Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105F65EE133
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbiI1QGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiI1QF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7667A88DEC
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664381157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rybUb/GfYlMSMT6cYU57AYfkSdd1kUKrcHY/UZNUSuw=;
        b=YUX7hfqAfIWNhA6D7ACt42nmSeeL9SdZ/mHejMHbXDTIjKeXJ6zlKYKZu6nB8zZxanHL5n
        qMH6Yc+LbJ5BSmdM675CuZ7oLPL4UCZjLSLI3dDIzjdk0dM42Scf4gyQxuZk0Pj9eRywt1
        u7TfvPw/Y3h03bUnZhpeXCc3zG7z+mE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-bm-yucTxPFC3oSEwLvRWkw-1; Wed, 28 Sep 2022 12:05:55 -0400
X-MC-Unique: bm-yucTxPFC3oSEwLvRWkw-1
Received: by mail-ej1-f72.google.com with SMTP id qw31-20020a1709066a1f00b00783d9fd7df2so3897396ejc.17
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rybUb/GfYlMSMT6cYU57AYfkSdd1kUKrcHY/UZNUSuw=;
        b=FUqPD+DmMJ79JuD+s+bcfAy9aLj1N0mtvl4aAA5F4y5UBcXD/rh/FU/06qUSQsUnDL
         PxFW3q9s7Zu/BBarx8bj674XLZ/Acoy9xeyNeyZab+rbOFutHGoMSNmooUA8f3R/jtPE
         o+rr+7baQtC7ql0B2hJcJEWHnPvUllBfW1Y9aggKHKUUTBNYVwvlS1WUSvivhgt+OD9T
         D+ccObGUuwTq+xwIWK21xTNMvRzuq8LhlCRqgBpq0hsLtCwyrm17hdRlHlwYRgmaFnvu
         se/zlvwIKk51DdUVyKFCprnwp9V4L+ci7oumU37um6GXagri9pHRHNrFbELePkl3tGTr
         zRyA==
X-Gm-Message-State: ACrzQf0GbzxJN8xu9MvCcSuVsEMjeymBWBTygSg9P6SAIpH4HOGdZJhb
        37nFnqGvjOK8CMdZl3YAM1dwhyD2VEQ7xo9FuLSlNjcYdiMYN7o9n6wNeIkEJC+wioGnQHW124n
        ZJAx7k7ORXfy+
X-Received: by 2002:a05:6402:5419:b0:457:c955:a40f with SMTP id ev25-20020a056402541900b00457c955a40fmr7638967edb.391.1664381154451;
        Wed, 28 Sep 2022 09:05:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4nSyR86A+8QF3RzNshAjHdwAHrTQllA/f8QCPhHs3cLwtsxHAwUQ0y3NlZkR5XvuDiiH6wLA==
X-Received: by 2002:a05:6402:5419:b0:457:c955:a40f with SMTP id ev25-20020a056402541900b00457c955a40fmr7638943edb.391.1664381154273;
        Wed, 28 Sep 2022 09:05:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id m17-20020a50c191000000b00456f569f31dsm3725792edf.75.2022.09.28.09.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 09:05:53 -0700 (PDT)
Message-ID: <3e56bba7-e1d3-7804-2d8f-307e81d88a9c@redhat.com>
Date:   Wed, 28 Sep 2022 18:05:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: allow compiling out SMM support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220927152241.194900-1-pbonzini@redhat.com>
 <YzM55hqavzENQq7I@google.com>
 <f708d769-5d93-351f-ea24-8fa7deb9f689@redhat.com>
 <YzRhT6DzgDfGU7NC@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YzRhT6DzgDfGU7NC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/22 16:59, Sean Christopherson wrote:
> But with CONFIG_KVM_SMM=n, KVM is now reporting that KVM_CAP_X86_SMM
> is unsupported,

Yeah, you're right.  "default y" is what matters here the most.

Paolo

