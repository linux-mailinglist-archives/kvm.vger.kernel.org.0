Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C018B569BD8
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 09:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiGGHi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 03:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbiGGHin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 03:38:43 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4913204E
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 00:38:32 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id e12so29681967lfr.6
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 00:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h02RRLlCZrlQLgVQNQN23bBxseybce+EQbOM36ezlNg=;
        b=d/ip9ht1bpZ4Zpe99Fl86zLCSZxphAsMxiCdxRQORyPwAh2XIqC/0LSc5Usyfabn8A
         rz+Lq391SPN0v+OTC45OMTtvbdRlAi7onidVGjuQVtIW48/Bax28sK9hSZZ4gKtuBUA+
         WLIkDqbPUiRJ+p0AijSpSYuqgBvnywvm7YM1SEMYzy8z1OZ0woPBSiQXTrg8n2pvLZUE
         agkNJu6lmk4SCk8xf/D9SwLbrPgxic0cp7eUnDFwL9N7U/HXPgVzvelZtQf8PItfXIQQ
         4WPqDoMY5l1CMiNVB/xelFayDenJJfpQ49i8ca8GN0c/hZ6h5/V0BZK9BIXvk2Nbi0QL
         7XRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h02RRLlCZrlQLgVQNQN23bBxseybce+EQbOM36ezlNg=;
        b=SdGpBeFgFjQr2t2fCmXj4V130eU2VOSYmUu1p5QOLk4SDE9ykMEPCmoL+miUbTGWfK
         AoaKUy9wGMh/keRk94rOX86o3nVZcSUfwuWRWcFMr8OeAMQ9C6bO1/CcJWvs4+O+4/jL
         Rd84Xs7Lph67tknj5Zip3sA5TSMPoOelUiXCXCTlBq9NVD5TyJQUPurHiGIqjin/Ze/2
         G4YSDb5v7EP1xwVME7cBj4GqJ5HWTUi8NwdGNsC42HU13/HB1gkgl5cNq1AMvIWBGN4z
         XLIlP3uMOEMuQsdcPijyZNi67L1CL42zcb1V0uffsuSCpH2/nNY28+fOt5FMMbDEx9kp
         q1fQ==
X-Gm-Message-State: AJIora8TBwwEPwAtOpfAyhoapimUkpnN5yIImePXnictt1+JQkP3/B9l
        3rZfGYWzZAKv4wNXVDYLMrxnjw==
X-Google-Smtp-Source: AGRyM1vgY3W7bPbVrub+o6x8zeLxWCMQcD5M/aR+4KQTjOH1Yl086PjW/HqkfusPVNoRDySyp5TSPw==
X-Received: by 2002:a05:6512:2185:b0:482:b4f0:f23 with SMTP id b5-20020a056512218500b00482b4f00f23mr13403325lft.31.1657179510403;
        Thu, 07 Jul 2022 00:38:30 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id n17-20020a0565120ad100b004786332a849sm6721342lfu.41.2022.07.07.00.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 00:38:24 -0700 (PDT)
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
To:     Sean Christopherson <seanjc@google.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <YsXzGkRIVVYEQNE3@google.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <94423bc0-a6d3-f19f-981b-9da113e36432@semihalf.com>
Date:   Thu, 7 Jul 2022 09:38:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YsXzGkRIVVYEQNE3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 7/6/22 10:39 PM, Sean Christopherson wrote:
> On Wed, Jul 06, 2022, Dmytro Maluka wrote:
>> This is not a problem on native, since for oneshot irq we keep the interrupt
>> masked until the thread exits, so that the EOI at the end of hardirq doesn't
>> result in immediate re-assert. In vfio + KVM case, however, the host doesn't
>> check that the interrupt is still masked in the guest, so
>> vfio_platform_unmask() is called regardless.
> 
> Isn't not checking that an interrupt is unmasked the real bug?  Fudging around vfio
> (or whatever is doing the premature unmasking) bugs by delaying an ack notification
> in KVM is a hack, no?

Yes, not checking that an interrupt is unmasked is IMO a bug, and my 
patch actually adds this missing checking, only that it adds it in KVM, 
not in VFIO. :)

Arguably it's not a bug that VFIO is not checking the guest interrupt 
state on its own, provided that the resample notification it receives is 
always a notification that the interrupt has been actually acked. That 
is the motivation behind postponing ack notification in KVM in my patch: 
it is to ensure that KVM "ack notifications" are always actual ack 
notifications (as the name suggests), not just "eoi notifications".

That said, your idea of checking the guest interrupt status in VFIO (or 
whatever is listening on the resample eventfd) makes sense to me too. 
The problem, though, is that it's KVM that knows the guest interrupt 
status, so KVM would need to let VFIO/whatever know it somehow. (I'm 
assuming we are focusing on the case of KVM kernel irqchip, not 
userspace or split irqchip.) So do you have in mind adding something 
like "maskfd" and "unmaskfd" to KVM IRQFD interface, in addition to 
resamplefd? If so, I'm actually in favor of such an idea, as I think it 
would be also useful for other purposes, regardless of oneshot interrupts.

VFIO seems to have an assumption that once a device is initialized, its 
interrupt stays unmasked all the time. I agree it might make sense to 
revisit this assumption.

Thanks,
Dmytro

> 
>> Therefore, since the interrupt has not yet been acked in the guest's threaded
>> handler, a new (unwanted) physical interrupt is generated in the host and
>> queued for injection to the guest in vfio_automasked_irq_handler().
