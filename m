Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443A2539F68
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350690AbiFAIZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350764AbiFAIZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 546BA2AE3
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654071907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PuqWSM1RqEiAAMMqRkf0RREiczy16fCzdCz4SZ9Yh8=;
        b=a3X3DM8Q450FYyesFUrHPF2J/QSKCH5+ZUisxb+Kbv+QX7wyMo398Ra6iaImtmW0AacKrV
        XM+xLz9Ds80MpETIpazRnyC8VSLUxSizGfbQMVStbTVa0VvutwAV2mqZyC6YxRV24huX4s
        yhrHFJnR8/d5YiAgA1IUVZvwC+Umh6I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-cKVynqtrOVODGBfNlraXHg-1; Wed, 01 Jun 2022 04:25:06 -0400
X-MC-Unique: cKVynqtrOVODGBfNlraXHg-1
Received: by mail-wm1-f72.google.com with SMTP id l31-20020a05600c1d1f00b003974df9b91cso2966124wms.8
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9PuqWSM1RqEiAAMMqRkf0RREiczy16fCzdCz4SZ9Yh8=;
        b=aD6fdX8qNiW0xHZKvWU4chOjkXf1LEKsa7NrmHJJuIyzXH5qyplvqLQhPY8UBYg3Gz
         HxcckmKY9vw9Qpu4IOQTTZObRZnDh3iT2dz92TfdThr7R9B1g0FhgzXkty8ZzlkrmAiV
         DVeG5ARrz7ei0sZXic/yNIoLIP6OWOLUvb5D90HXdRlZ/96/hhI35H4Pu/V+l86TMZ0f
         ADSdZHIH1B1lJI/gI6v0/qM8d/Q2s5dyHNagEe82C88sXFTKiQ/CJ3WxC6Yj7SCXBuBb
         QRfp5UKlFliEBj2MA3XAEEPUAw4rfJYG0ynWuGJRrT25+/Pt1Lh6C05Qs+I/rZa30xDM
         qzNA==
X-Gm-Message-State: AOAM530m6oyagxfdKhsmEK+gRK1Dalunab2zd2OrzU6bBColyMep0G6t
        pxQzCKMQomt2KBVin6RZhjFCmJOh5waBPXXDlb2brfBsqbDYwx6E6TYCO23Gswa642Yq4j/8nxJ
        GT4m8qs+ruk+Z
X-Received: by 2002:adf:fb46:0:b0:210:2316:dd02 with SMTP id c6-20020adffb46000000b002102316dd02mr17673876wrs.557.1654071905004;
        Wed, 01 Jun 2022 01:25:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRD/IRDpVLqPBmdGC0pIb4xFXUChVcdXWE70cLKfJv6Nh+TFUtXKaRUjy4B0vznzkaEH6ugw==
X-Received: by 2002:adf:fb46:0:b0:210:2316:dd02 with SMTP id c6-20020adffb46000000b002102316dd02mr17673852wrs.557.1654071904613;
        Wed, 01 Jun 2022 01:25:04 -0700 (PDT)
Received: from smtpclient.apple ([2a01:e0a:834:5aa0:2c2a:4832:6517:63a])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c358f00b003973ea7e725sm6337978wmq.0.2022.06.01.01.25.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jun 2022 01:25:04 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: ...\n
From:   Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <87r148olol.fsf@redhat.com>
Date:   Wed, 1 Jun 2022 10:25:01 +0200
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F662DF4F-930A-486E-86FB-97D54E535114@redhat.com>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
 <87r148olol.fsf@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 1 Jun 2022, at 10:03, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>=20
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
>> On Tue, May 31, 2022 at 02:52:04PM +0000, Durrant, Paul wrote:
>=20
> ...
>=20
>>>=20
>>> I'll bite... What's ludicrous about wanting to run a guest at a =
lower
>>> CPU freq to minimize observable change in whatever workload it is
>>> running?
>>=20
>> *why* would you want to do that? Everybody wants their stuff done
>> faster.
>>=20
>=20
> FWIW, I can see a valid use-case: imagine you're running some software
> which calibrates itself in the beginning to run at some desired real
> time speed but then the VM running it has to be migrated to a host =
with
> faster (newer) CPUs. I don't have a real world examples out of top of =
my
> head but I remember some old DOS era games were impossible to play on
> newer CPUs because everything was happenning too fast. Maybe that's =
the
> case :-)

The PC version of Alpha Waves was such an example, but Frederick Raynal,
who did the port, said it was the last time he made the mistake. That =
was 1990 :-)

More seriously, what about mitigating timing-based remote attacks by
arbitrarily changing the CPU frequency and injecting noise in the =
timing?
That could be a valid use case, no? Although I can think of about a
million other ways of doing this more efficiently=E2=80=A6


>=20
> --=20
> Vitaly
>=20

