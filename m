Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D299B6C24DD
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCTWpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCTWpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:45:53 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91505E7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:45:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x3so52832456edb.10
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679352350;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUcdlRLcnAC1hWsEHdyUa8FyszmpMUHUsOAlPDAG7SA=;
        b=QhQgWHYq9rqaykeFLLr1VhtDpLDQnZtI8FNpc25bkbYvJ2K2vVDx5pnaQb0dhDA7l7
         hA1DxP3uHl9HW7gaTdunJaurVLRaLZRp/7W3ZU2pT4+OfVwNK3iATmCmK5fCEfD7Amwy
         hMsqiBPfPfTaPhkk7NjXj2PqIf67gT6axT7vCcpJ2pzRIx5+P3EzNixxcDDUaz8qXtd1
         MMq9MOn/xBmXC9jblADVKUsp+sNjBPAtYp5RhK13/ShLS4maR7wg3h1KxksbABnk63iy
         xb1Z4nJN8nkef75Tti/KuzS5SnZWePt7asxGGZm91pCQ9mQGilB2gPzgEcSVS/P+aRPX
         9d4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679352350;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUcdlRLcnAC1hWsEHdyUa8FyszmpMUHUsOAlPDAG7SA=;
        b=GtlDWiimgA4pyyTTnFXiB8X7NSdHa5NNi5guYCLkhMoDyogVLGRtjmQqIWBViRDGIH
         YkyA4ut3N09b15fAHNh1oFKMDc282+Yu/0lmLJlGPvyYP+145wty4QgfdqfGCZ7hEBpd
         HRpeSbUxueZ0yvX5WpkvNlREgjEeKk2+VW07B1x9TYOO0+v55hlSQqgWp9YeijI41BbZ
         JquktSYa6yIzgy5AeuA8E4ISHnW1scrfm9d2ehDjv986kqcvl+a0Ng1kgF3JxewTTKAB
         GGM1kpJcmVgFyOTUpI/Os5YFTRzm59eM3gsuTbhum8D5OHkbczXWd873mzzo+mQg2HfJ
         4bQw==
X-Gm-Message-State: AO0yUKXNeI9tt0JVxOpQ9Bag2g1Y2qBjrOaeWThE8S2/D90iBgRLD/Pz
        4dc1TYG+ilY6b8BHlwIbfrKvr7QbHPU=
X-Google-Smtp-Source: AK7set90yPsNWg0OB08xY+4fPA9WsifE84m7yQ0fGkHblafK7/Kqar0VJdz9qAjntUmmycMPpeKvRg==
X-Received: by 2002:a05:6402:55a:b0:4fd:298a:62cb with SMTP id i26-20020a056402055a00b004fd298a62cbmr1080973edx.21.1679352349891;
        Mon, 20 Mar 2023 15:45:49 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-077-011-139-095.77.11.pool.telefonica.de. [77.11.139.95])
        by smtp.gmail.com with ESMTPSA id x2-20020a50ba82000000b004fb30fc1dabsm5385560ede.96.2023.03.20.15.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 15:45:49 -0700 (PDT)
Date:   Mon, 20 Mar 2023 22:45:42 +0000
From:   Bernhard Beschow <shentey@gmail.com>
To:     =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
        quintela@redhat.com, qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <f4bug@amsat.org>,
        =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>
CC:     Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?ISO-8859-1?Q?Herv=E9_Poussineau?= <hpoussin@reactos.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: KVM call for agenda for 2023-03-21
In-Reply-To: <393c8070-e126-70de-4e85-11ac41d6f6be@linaro.org>
References: <87zg8aj5z3.fsf@secure.mitica> <393c8070-e126-70de-4e85-11ac41d6f6be@linaro.org>
Message-ID: <69825A96-1A36-42B8-B9C9-6E6E34D680BF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20=2E M=C3=A4rz 2023 15:47:33 UTC schrieb "Philippe Mathieu-Daud=C3=A9"=
 <philmd@linaro=2Eorg>:
>Hi Juan,
>
>On 18/3/23 18:59, Juan Quintela wrote:
>>=20
>> Hi
>>=20
>> NOTE, NOTE, NOTE
>>=20
>> Remember that we are back in that crazy part of the year when daylight
>> saving applies=2E  Call is done on US timezone=2E  If you are anything =
else,
>> just doublecheck that it is working for you properly=2E
>>=20
>> NOTE, NOTE, NOTE
>>=20
>> Topics in the backburner:
>> - single qemu binary
>>    Philippe?
>
>Well we wanted a slot to discuss a bit the design problems we have
>around some PCI-to-ISA bridges like the PIIX and VIA south bridges=2E
>
>One of the main problem is figure how to instantiate circular IRQs
>with QOM=2E Ex:
>
>  devA exposes irqAo output
>       wires to irqAi input
>
>  devB exposes irqBo output
>       wires to irqBi input
>
>How to wire irqAo -> irqBi *AND* irqBo -> irqAi?
>
>However personally I was busy with debugging issues opened for the
>8=2E0 release, and it is probably very late to schedule with Mark and
>Bernhard for tomorrow=2E=2E=2E

Hmm, yeah, a few days notice in advance would help me to allocate the slot=
 for QEMU rather than work=2E=2E=2E I'm very interested in the topic though=
=2E

Best regards,
Bernhard
>
>> - The future of icount=2E
>>    Alex?  My understanding is that you are interested in
>>    qemu 8=2E1 to open=2E
>>=20
>> Anything else?
>>=20
>>=20
>> Please, send any topic that you are interested in covering=2E
>>=20
>> At the end of Monday I will send an email with the agenda or the
>> cancellation of the call, so hurry up=2E
