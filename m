Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FCF546E8A
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 22:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348592AbiFJUkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 16:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344070AbiFJUki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 16:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 897C6D8D0A
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 13:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654893636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imQtSutlv2T4FRJs3wX0riAEQ8dDpDNZLaDj9MeOMHo=;
        b=GZEFbW7bk/64HnzFKW1VQz/CMHI+ySbT14T7RzWt5PUTPZbgrGMSv2VjHpXTOrcjMTilrT
        gjeFsBkTr3dZ/MnsDkzOzNKDNrXbd8mukMg/bQ2vMQeTsCVKE+ozED2VeY0WsuseOzHOFx
        MRrHBTChQLiNLQI+2Kcf0OfeKNnYHtI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-wjCELk1wN9qhgyaxcxrsJA-1; Fri, 10 Jun 2022 16:40:35 -0400
X-MC-Unique: wjCELk1wN9qhgyaxcxrsJA-1
Received: by mail-qv1-f69.google.com with SMTP id x18-20020a0ce0d2000000b0046458e0e18bso320110qvk.1
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 13:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=imQtSutlv2T4FRJs3wX0riAEQ8dDpDNZLaDj9MeOMHo=;
        b=KFWqPkx/rKolyZvnEnFRm5rcP8n20DmUGJpevD47pRvc8slekmxI9sx4ObYrkuW9U6
         fAXPMkQgA0QBT6D/S7wcaAeW3zajTZMUUgONmFSdyI2aXK6vSOWmv3cgwxSv8bayHRB6
         UjRKOTNmZM4KpxijZSiem/lDeg+4wVqXSQ8jxj0uj9qUwsDzHQyRf03MfF4icHAGAavf
         p7pz5DVVjtriJBNB/i5iv6x6b2nqQNrm4QpXJlK1G7Ev9eR2tiI+niT7nuyWvO9br3EW
         F/qGug/R2Y+1Oorpn5M2jYgdn60nzb9rPm2Kr2r8qRFFoDbaTf3oZzcZ3eacw9driFjA
         pVPg==
X-Gm-Message-State: AOAM5323r59kpGNXEQTt1+AwiLdWbOdq7u1EY0Mlw/+A2tMl3gkCNa6e
        26qQW/VAwcd8R8nUOFYYBtxmmMLSWLXbeSi/JzX501epID+vWzxw7puYXCenSy5whDzNHXbNerb
        dC4qFcUjSwwdq
X-Received: by 2002:a37:42d5:0:b0:6a7:361:e583 with SMTP id p204-20020a3742d5000000b006a70361e583mr10230177qka.514.1654893634395;
        Fri, 10 Jun 2022 13:40:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvla18giycZ4zPi/6qxLDu9O4h+mrD/tTC42NkufoVZPTXQ4Z8EMEceHMrKqxdxJGrexWC9w==
X-Received: by 2002:a37:42d5:0:b0:6a7:361:e583 with SMTP id p204-20020a3742d5000000b006a70361e583mr10230163qka.514.1654893634003;
        Fri, 10 Jun 2022 13:40:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u21-20020ac858d5000000b00304e8938800sm57230qta.96.2022.06.10.13.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 13:40:33 -0700 (PDT)
Message-ID: <4bb7b5e4-ceb4-d2d8-e03a-f7059e5158d6@redhat.com>
Date:   Fri, 10 Jun 2022 22:40:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC 0/2] arm: enable MTE for QEMU + kvm
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220512131146.78457-1-cohuck@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20220512131146.78457-1-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,

On 5/12/22 15:11, Cornelia Huck wrote:
> This series enables MTE for kvm guests, if the kernel supports it.
> Lightly tested while running under the simulator (the arm64/mte/
> kselftests pass... if you wait patiently :)
> 
> A new cpu property "mte" (defaulting to on if possible) is introduced;
> for tcg, you still need to enable mte at the machine as well.
isn't the property set to off by default when kvm is enabled (because of
the migration blocker).

Eric
> 
> I've hacked up some very basic qtests; not entirely sure if I'm going
> about it the right way.
> 
> Some things to look out for:
> - Migration is not (yet) supported. I added a migration blocker if we
>   enable mte in the kvm case. AFAIK, there isn't any hardware available
>   yet that allows mte + kvm to be used (I think the latest Gravitons
>   implement mte, but no bare metal instances seem to be available), so
>   that should not have any impact on real world usage.
> - I'm not at all sure about the interaction between the virt machine 'mte'
>   prop and the cpu 'mte' prop. To keep things working with tcg as before,
>   a not-specified mte for the cpu should simply give us a guest without
>   mte if it wasn't specified for the machine. However, mte on the cpu
>   without mte on the machine should probably generate an error, but I'm not
>   sure how to detect that without breaking the silent downgrade to preserve
>   existing behaviour.
> - As I'm still new to arm, please don't assume that I know what I'm doing :)
> 
> 
> Cornelia Huck (2):
>   arm/kvm: enable MTE if available
>   qtests/arm: add some mte tests
> 
>  target/arm/cpu.c               | 18 +++-----
>  target/arm/cpu.h               |  4 ++
>  target/arm/cpu64.c             | 78 ++++++++++++++++++++++++++++++++++
>  target/arm/kvm64.c             |  5 +++
>  target/arm/kvm_arm.h           | 12 ++++++
>  target/arm/monitor.c           |  1 +
>  tests/qtest/arm-cpu-features.c | 31 ++++++++++++++
>  7 files changed, 137 insertions(+), 12 deletions(-)
> 

