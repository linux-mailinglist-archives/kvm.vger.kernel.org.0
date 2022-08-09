Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E9C58D8DF
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243048AbiHIMpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243223AbiHIMpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1DF1B1F4
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 05:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660049137;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=FuLz25zKoqskCYXb5sRtHb8ZE3S2lV4cXj5D6wf1kOg=;
        b=Cbhn0tjifWyX3wJGC+Exj1gDcP2tW7hrPrnzcDVr5zhzQDY6GJcp1ntPoII+iecxlc9vL2
        qXtlZ3lW2CGnvNcaFE1GWQtoQovPS/ugB6JsZI9kzyVMY4DXHoczNfCXnCXCgZSob5zVAA
        /7VAytVUEfSqyYmBbdi1Zk5OWPtexaY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-NqMenVA0OJ6D9fs0nrxnhA-1; Tue, 09 Aug 2022 08:45:36 -0400
X-MC-Unique: NqMenVA0OJ6D9fs0nrxnhA-1
Received: by mail-wm1-f69.google.com with SMTP id i65-20020a1c3b44000000b003a537031613so1880638wma.2
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 05:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version;
        bh=FuLz25zKoqskCYXb5sRtHb8ZE3S2lV4cXj5D6wf1kOg=;
        b=KG3omLVmM6tfvv/ZvJvrSA2RO+JvkpwSlLP5NLEzt9rbWO3TBkjSjLNQkhgt3UIlCs
         zYTbr2npVmerT9+h8+NNicuRFpCiZRrB8975tDc4/tNpTdiCiIoI5xv3ksXBk/508RQo
         rxFEzoExenLaIe5V3m7a46TCE2lS0W6hpwprrqeUVv4K5u9G1s032JPw9dQk6cJ9/5jf
         Ss9t+/9RLAw78/1atvIYcSEx1XJWTFAQMNx+Jkt+UzKawcaTM4boh1S4yGPLsBdwulO4
         voHZXLdnSL2FlA815w0roM1Vr/lSjypsW1ir7KcQGNWP1LXNOtj9qzCSHrK6lxLaySEu
         XMpg==
X-Gm-Message-State: ACgBeo2mHyANspY/zhjb0bPsE6HgZ1GmRkkae1rDJPidInvEkUrZ5ORw
        zMrKQeCIv994e4qmglWiHHYLYe31Fot2xuHw4UCPf74Gb9UT5/63nY1yp1tVFywagQDbTNkCCC0
        MpssgxuggBt9QO0LCymlT2Exp1q0hBDR0FJ/K2JbcdgoP9UztLNyeUDwRS6ZyCxnG
X-Received: by 2002:a1c:f710:0:b0:394:1960:e8a1 with SMTP id v16-20020a1cf710000000b003941960e8a1mr16009635wmh.154.1660049135050;
        Tue, 09 Aug 2022 05:45:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Zo45btXvwqkLmtLNyUO2prb0k0JxPsO9+CVo3P3KirEFGYti02YLqsG/lips0iMTS8JOlZQ==
X-Received: by 2002:a1c:f710:0:b0:394:1960:e8a1 with SMTP id v16-20020a1cf710000000b003941960e8a1mr16009621wmh.154.1660049134839;
        Tue, 09 Aug 2022 05:45:34 -0700 (PDT)
Received: from localhost (static-205-204-7-89.ipcom.comunitel.net. [89.7.204.205])
        by smtp.gmail.com with ESMTPSA id bg21-20020a05600c3c9500b003a4efb794d7sm19268217wmb.36.2022.08.09.05.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 05:45:34 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     qemu-devel@nongnu.org
Subject: Re: KVM call for 2022-08-09
In-Reply-To: <87k07scn8d.fsf@secure.mitica> (Juan Quintela's message of "Mon,
        01 Aug 2022 11:44:02 +0200")
References: <87k07scn8d.fsf@secure.mitica>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 09 Aug 2022 14:45:33 +0200
Message-ID: <87mtcdk2ky.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> wrote:
> Hi
>
> Please, send any topic that you are interested in covering.
>
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
>
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
>
>  Call details:
>
> By popular demand, a google calendar public entry with it
>
>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
>
> If you need phone number details,  contact me privately
>
> Thanks, Juan.

Today there is a topic for the call:

I'd like to talk about VFIO live migration and more specifically this
issue [1].


[1]
https://lore.kernel.org/all/39f6d299-96c8-9e8c-dcbc-0e4873fd225f@nvidia.com/

See you in 15 mins,

