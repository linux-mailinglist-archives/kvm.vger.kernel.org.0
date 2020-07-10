Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F4521B012
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgGJHWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 03:22:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725851AbgGJHWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 03:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594365767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1LP15d34TouyszSVQjRJOSuUkVhVo3nqKacLbUvCJx0=;
        b=Qx41BLG0Nm9gemivRX69161axI4mzWyjapcGeJ7Xl0JkOG34nlYOE5+tJ5feAzyvncyo2F
        7BgclXkuWEOsZ3zAuRsKQe4EjPk27BGaCdCmSdda6253DmnzhDhPCxJi/8YlZji0e8aJRu
        WX/zd0JqdnIIGMsyDJmGrclkK5syiOk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-QL6Q1MIdOmeh2yDZl111lQ-1; Fri, 10 Jul 2020 03:22:46 -0400
X-MC-Unique: QL6Q1MIdOmeh2yDZl111lQ-1
Received: by mail-wm1-f70.google.com with SMTP id y204so5603576wmd.2
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 00:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LP15d34TouyszSVQjRJOSuUkVhVo3nqKacLbUvCJx0=;
        b=CgjAEZv3V6xZHmHg1q+uU6eMLAJ+U2UagRPxfGY+ns5E0MB78MpH4UvpWveC7vWRKE
         g9sYW6Qz4Ef/0mViYKXaKr1SFp3FlkPQccVUWADz5jD/FGJlM/tCvQAXGddvbIZOgYoG
         KVyerSnXd3SYDqTF29H87tQw8SbwYsN69F6bIAR0W+HdkYAEsr8cVGTxwSCoE2o8fMaf
         Dw1isYdrAPaPvLDhQOnKlSrtWqiBtRYbD2++F61lk/Cz22/tnzV+u8/kyzpto+jIBLCJ
         tkjMVOwWqSUavnB7wnIJHvtb0Eoq0ZIwKO8MvY810c3/eve/ALa0xC0b/SKj7QMKomYp
         XDsg==
X-Gm-Message-State: AOAM532c22U4XLZ0zSaDFK7cQhyVuU/BtekhQci/z2mEZu5kNHIZjPFX
        sN3uNweF8AmxS6+FEySRBaB0VDRbPYpdIB9ci4JcisIlSLzekvBMHL2GutHJxynYBGfmkFOp5tV
        gQcfOg4PBrumk
X-Received: by 2002:a1c:5418:: with SMTP id i24mr3615697wmb.47.1594365765014;
        Fri, 10 Jul 2020 00:22:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJDfpsWJATF3x2k0/kUpiedr1e5eRuZK3mH9pswy5ELHGWFABftH17kpJ0ccpVvxQfTUOiuQ==
X-Received: by 2002:a1c:5418:: with SMTP id i24mr3615668wmb.47.1594365764803;
        Fri, 10 Jul 2020 00:22:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id g14sm9517815wrw.83.2020.07.10.00.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 00:22:44 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm list <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net> <20200708172653.GL3229307@redhat.com>
 <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
 <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
 <20200709191307.GH780932@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <79aa7955-6bc1-d8b2-fed0-48a0990d9dea@redhat.com>
Date:   Fri, 10 Jul 2020 09:22:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709191307.GH780932@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 21:13, Eduardo Habkost wrote:
>> Doesn't this require intercepting MOV-to-CR3 when the guest is in PAE
>> mode, so that the hypervisor can validate the high bits in the PDPTEs?
> If the fix has additional overhead, is the additional overhead
> bad enough to warrant making it optional?  Most existing
> GUEST_MAXPHYADDR < HOST_MAXPHYADDR guests already work today
> without the fix.

The problematic case is when host maxphyaddr is 52.  That case wouldn't
work at all without the fix.

Paolo

