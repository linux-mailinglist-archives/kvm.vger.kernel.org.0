Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF09B6740B7
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjASSR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjASSRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38491449F
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674152215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q+oPjhxahFRNdh2AOJEQpeD10rNKUEwEjHNdLdR7TwE=;
        b=efGHEeCrNTgWiuhZn0pKh2ZOqwJcjHGsfMhYNPeMDU8YSyHXqZbPUTrgBFZ6Jj6BDmXLDS
        RnIn0Jv+O+yvYcSsHRDf7j4q2xabODg+F/yTrpMam20BsYe4/yqifGGvGdcJdowCJpJObU
        mtnDAAZ9g2PrKz4MJ1iXS5x9DJIKzWM=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634--Idt3y2UPsCkPKB-JHf9-w-1; Thu, 19 Jan 2023 13:16:53 -0500
X-MC-Unique: -Idt3y2UPsCkPKB-JHf9-w-1
Received: by mail-vs1-f70.google.com with SMTP id 68-20020a670347000000b003bf750cb86eso964535vsd.8
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:16:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q+oPjhxahFRNdh2AOJEQpeD10rNKUEwEjHNdLdR7TwE=;
        b=3a+7AyenFKSb0RCzf8uRVhDK1XZX4ABT6JhfwXxeLm8U+D29T/Ud461tzCZXvWB80i
         9lp2qcgQSR4AV543Su589EDQ0t641R/enh886JVG09xY8/RHI9sPnKNsf+tL5Tq+iKSv
         j/5skhrd5kPPCCCYq1/xkhWg+Ds39VI72vg92RMqcbA0BGbY5zmD9pkl1GKqkMMy4bl6
         0Q9KdguwN+3aFaTpnxRCEKk7a3OnjQXZ1P7EF4QR/cxnCuM7qM9Fpp0s/e9FN7lqNgbx
         KyeT8whiN/vI3Jv/CHp/fo33m92YAISGwvOXPFKdgK5RyZXzyyRTkQBiGHW/blwvwNM+
         jTag==
X-Gm-Message-State: AFqh2krmssx3d0yxYvmpZRkfjRffmQgyia54iLYoP4k96NPtnFMYNWt4
        FV2eSZxzAt3Dd7RUFkco4GMyErdl54HOVjvqgDR//pQIBMZkTmjmIv+2xuVd2AQxM6/akxYm0j+
        lhIBcpEeWmpXAQB44TIXV5nnxOnI9
X-Received: by 2002:a05:6102:b09:b0:3d0:f045:c1eb with SMTP id b9-20020a0561020b0900b003d0f045c1ebmr1625579vst.54.1674152209554;
        Thu, 19 Jan 2023 10:16:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtthD5MJghyW9vRqY3kw4Xa5W7Er3DFd3yJoQHRfgQ/SGRx//G/5kOA5gfW6jCk/RgHHH9euHP/f7VcqX4SsTw=
X-Received: by 2002:a05:6102:b09:b0:3d0:f045:c1eb with SMTP id
 b9-20020a0561020b0900b003d0f045c1ebmr1625574vst.54.1674152209344; Thu, 19 Jan
 2023 10:16:49 -0800 (PST)
MIME-Version: 1.0
References: <20221228110410.1682852-1-pbonzini@redhat.com> <20230119155800.fiypvvzoalnfavse@linux.intel.com>
 <Y8mEmSESlcdgtVg4@google.com> <CABgObfb6Z2MkG8yYtbObK4bhAD_1s8Q_M=PnP5pF-sk3=w8XDg@mail.gmail.com>
 <Y8mGHyg6DjkSyN5A@google.com> <CABgObfZZ3TLvW=Qqph16T0759nWy0PL_C3w3g=PACj9cpupBQA@mail.gmail.com>
 <Y8mIoUqO8qFgoBZI@google.com>
In-Reply-To: <Y8mIoUqO8qFgoBZI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 19 Jan 2023 19:16:37 +0100
Message-ID: <CABgObfbCjQUZ9ES+vOdW7uZp6QHmz2cYQ=bnytScdcsDStWZ7Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 7:15 PM Sean Christopherson <seanjc@google.com> wrote:
> A minor selftest fix
>
>   https://lore.kernel.org/all/20230111183408.104491-1-vipinsh@google.com
>
> and a fix for a longstanding VMX bug that seems problematic enough that it
> warrants going into this cycle.
>
>   https://lore.kernel.org/all/20221114164823.69555-1-hborghor@amazon.de

Ok, I had seen the latter so I'll put together a pull request.

Paolo

