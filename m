Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6778F770BD3
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjHDWRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjHDWRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDDF10CA
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691187389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBev8f48euppbrlGUJrvFvq/NbcYvN6NDEEVGIE+gM4=;
        b=VnhYn6LO3yPtnz9DKfy/FGMwK6T+Wq/FpfrUGvCtxp9xNr/z9cPyaTq7LiMvca7UuRgTq/
        bwNOyN/I+8Wqa0WKQNgv7SM/pZ/xirViumUfRz7gq1Lfa4zgCrJQFmvqD67uWTdQsH+LSH
        b8YTvVOr616JCh2dYtl4GKWYnK4O404=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-a7MRxR8lM063iDrBZxxFpw-1; Fri, 04 Aug 2023 18:16:27 -0400
X-MC-Unique: a7MRxR8lM063iDrBZxxFpw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94f7a2b21fdso173515866b.2
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691187386; x=1691792186;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBev8f48euppbrlGUJrvFvq/NbcYvN6NDEEVGIE+gM4=;
        b=Gounvci7Sa+YZTl+/NW7PhMTBCGb2ikigm68j8Y/ePtazFeEV5gThgmtTA5ekbbgCH
         RfD9CDRVFbX3tdSBdfTMHNh3Sd3majPKRSnoVePcU5OLm0q1lURBKK4BgB7qF4oojnhD
         c9eHjHvY07SzPbzgN4jPsSpcI63VfAy2qlQ4qaC351QT4mjwDTHuVeRrDn4JudLy1wRD
         Xm99KN0xczMMAWfTOXEI7/ddsUE3HeIOD5e7X5b6S+BpBwPAVJ1+qEjnXeikpkKkXlF2
         +WEZNEfbLjTIUKK9iaZeFkjii7uaXloBT/7uF2cBlEeT0NRBlwMqFzkUbxR+hbgAcM1i
         6lWw==
X-Gm-Message-State: AOJu0Yx+7sy75MJnAwW2sewcShJCMvX9GjZ0yKCyWaO8IE6zgi0PyfjQ
        9O8NasJq5AHhoN9iRWd+j/iJu/sihLyHuM5VvKHNLxri2zMqGhM0x+bMv6p1Ht7Xoy3lnFHmnE8
        1NHweb32+mR80jAKQj+HD
X-Received: by 2002:a17:907:2e19:b0:99c:6c29:7871 with SMTP id ig25-20020a1709072e1900b0099c6c297871mr2382641ejc.65.1691187386212;
        Fri, 04 Aug 2023 15:16:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/XXy6aDU1bbyW2yj9LLfsXSmynDDC9N6br47yixyCqPnORioHqUSbfysOOjLmNVL+/dXRnQ==
X-Received: by 2002:a17:907:2e19:b0:99c:6c29:7871 with SMTP id ig25-20020a1709072e1900b0099c6c297871mr2382632ejc.65.1691187385974;
        Fri, 04 Aug 2023 15:16:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id si10-20020a170906ceca00b00992e14af9c3sm1858566ejb.143.2023.08.04.15.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 15:16:25 -0700 (PDT)
Message-ID: <84a37508-4884-ff06-f7f3-6e8cd136b1f2@redhat.com>
Date:   Sat, 5 Aug 2023 00:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Question about the KVM API KVM_VCPU_TSC_CTRL to control guest TSC
Content-Language: en-US
To:     Yifei Ma <yifei@clockwork.io>, kvm@vger.kernel.org
References: <ED93F288-CA91-4D4D-85C3-3482234287D7@clockwork.io>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ED93F288-CA91-4D4D-85C3-3482234287D7@clockwork.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 21:56, Yifei Ma wrote:
> The doc says "Read the KVM_VCPU_TSC_OFFSET attribute for*every vCPU*
> to record the guest TSC offset”. However, the KVM API for
> getting/setting the offset is not through vCPU’s fd, it is through
> KVM device's fd, E.g., when I refer to the KVM selftest code, I found
> accessing TSC_OFFSET is through the “KVM_SET_DEVICE_ATTR” cmd, with
> args “KVM_VCPU_TSC_CTRL” & “KVM_VCPU_TSC_OFFSET”. It looks like the
> API sets the TSC offset on all vCPUs, instead of a single vCPU.

KVM_SET_DEVICE_ATTR is accessible through the vCPU fd as well.  In 
particular, the group=KVM_VCPU_TSC_CTRL attr=KVM_VCPU_TSC_OFFSET is 
available through the vCPU fd.

On x86, the device fd instead supports group=0 
attr=KVM_X86_XCOMP_GUEST_SUPP.

Paolo

