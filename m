Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3ED525B8F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 08:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377324AbiEMG01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 02:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377282AbiEMG0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 02:26:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF81275E4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 23:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652423178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QHsNXsIpenLxiaLwVm/9s/dCg9vaSdDn6D4+UbPBLfI=;
        b=A05bik7ELBhLr/dnavfytsqAnuuW0aZ/naTcOqpTXgFisM7UUYqoADq5z+dl9nKIrvnFIa
        0s+NyVJuR7E2z3/4rYUpncKY76uwqM4TYdmPwEjdOqUbgoJgtW3oFpBMtm7u3J+vFM8JTE
        mYRAKo/3vb/BbrsxI65XAdzRVRAGpdo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-yPjDgiVOPRact-o7CMU8Og-1; Fri, 13 May 2022 02:26:16 -0400
X-MC-Unique: yPjDgiVOPRact-o7CMU8Og-1
Received: by mail-wm1-f69.google.com with SMTP id v124-20020a1cac82000000b003948b870a8dso5524403wme.2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 23:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QHsNXsIpenLxiaLwVm/9s/dCg9vaSdDn6D4+UbPBLfI=;
        b=ay7yEDyp8kY0RJHowX6uXtxtciVDZFZchsSUXEWcanfI7G0KA/KRV8yeHu/bITfoes
         W0dB+yq95jf+sLknru+xyvFaR9/aVdX9RSSzWSVM3OJC0wh+NDk0Yh1BiYFfiJwQ1414
         ucB1IoFAOPi6pgjUKW2aE8Wg8blQFMQPjtUHoyqn89BNGtNMCpWJpaE5iLcIGl2MQ22O
         raWGKrKn5dFFU8bUGplac/hTlrKXEHsQAvcw9l4DkYWKdFBRXh82kMyKKMvhk9hajkOO
         tdhRddc7ugN4HaeJ1bZtFJpUds5USKIkESW5igI2wsKUnMTY41HlshWe3Rp6ahyWLauI
         wYbg==
X-Gm-Message-State: AOAM5319Q0LCB0y3tXlp1NLCz0ajG8HhdGsP2LnGX1KPZ6qumlwGfk3Q
        rRiEoDjSeLwF8I37BhR9tnQ0LKGor/E4qtUGlHrWu3nDgnp8vja6rxUKPkeUNNRfQmbcsAzThn3
        /haBymbFeEZK/
X-Received: by 2002:a5d:404a:0:b0:20a:eb17:559 with SMTP id w10-20020a5d404a000000b0020aeb170559mr2487484wrp.602.1652423175579;
        Thu, 12 May 2022 23:26:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrIVsMZ2/uWUXpazqTGFfUmcTo3VPMiWppUJ6yLH+VlSIOYUNTDVnD7ABeIJu5g3NHZWe2Zg==
X-Received: by 2002:a5d:404a:0:b0:20a:eb17:559 with SMTP id w10-20020a5d404a000000b0020aeb170559mr2487460wrp.602.1652423175253;
        Thu, 12 May 2022 23:26:15 -0700 (PDT)
Received: from smtpclient.apple ([2a01:e0a:834:5aa0:d9b7:a18f:9b9f:cea4])
        by smtp.gmail.com with ESMTPSA id c6-20020a05600c4a0600b003942a244f29sm4314830wmp.2.2022.05.12.23.26.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 23:26:14 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: Cyclictest with small interval in guest makes host cpu go very
 high
From:   Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <CAJuRqcC0Z-wbAhb39ofKPstgbg+ZmsT8eFivWEr-hZY64_A1xA@mail.gmail.com>
Date:   Fri, 13 May 2022 08:26:13 +0200
Cc:     kvm@vger.kernel.org, nsaenzju@redhat.com
Content-Transfer-Encoding: 7bit
Message-Id: <4D910AFF-1C6A-4732-BAC6-16064B981949@redhat.com>
References: <CAJuRqcC0Z-wbAhb39ofKPstgbg+ZmsT8eFivWEr-hZY64_A1xA@mail.gmail.com>
To:     Florent Carli <fcarli@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 May 2022, at 08:15, Florent Carli <fcarli@gmail.com> wrote:
> 
> Hello,
> 
> When I run a cyclictest with a small interval in a guest, even though
> the guest's cpu load is small (2-3%) the host qemu-system thread is
> showing 100% cpu utilization, almost all of it being "system/kernel".
> There seems to be a threshold effect:
> - on my system an interval of 220us creates no problem (host
> qemu-system thread is 4% user and 1% system)
> - an interval of 210us shows the host qemu-system thread at 4% user
> and 50% system)
> - an interval of 200us makes the host qemu-system thread at 4% user
> and 95% system
> 
> Those threshold values are probably not universal...
> 
> I'm using kvm with qemu on x86-64, and this issue seems easily
> reproducible (yocto with a 5.15rt kernel, debian stable with a 5.10rt
> kernel, or a non-rt 5.10 or a backported 5.16rt kernel, etc.). I
> reproduced this issue on a debian stable non-RT kernel to be sure the
> problem was not due to preempt-rt.
> My cmdlines for host and guest are very basic: ipv6.disable=1 efi=runtime
> Vcpupinning does not change the outcome.
> 
> I'd love to understand the cause of this behavior and if there's
> something to be done to solve this.
> Thanks a lot.

I suspect this is related to this:

https://lkml.kernel.org/kvm/ad6184a3-5de6-9a9d-77f8-84b6b47efb04@gmail.com/T/

Can you try adjusting poll_threshold_ns to confirm?

> 
> Florent.
> 

