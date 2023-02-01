Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC96686E46
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 19:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjBASlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 13:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBASlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 13:41:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4FB6AC81
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 10:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675276750;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=irfXd+OrbWvofFmv4DMNGRP0MqrsgnJtsh3k4L15HzA=;
        b=DlIlVhe7kcIgn+Lg5X0J3fIh6S6CQKeF/c6uMODKFFTDqTgJA2fm/pPVZfzvrpE29fjL8w
        lj7vL/Ib352yiR98L2Sa8FGfEoO2jOuCYh8oq+itfOvTjsysEYDo53w+T9yEHj1Z6hS2na
        r+HLdO+xGyH7UJPQ+Ns8NugsQuvRQMw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-uJl4JVA0OEuDaazF4FY3ZA-1; Wed, 01 Feb 2023 13:39:10 -0500
X-MC-Unique: uJl4JVA0OEuDaazF4FY3ZA-1
Received: by mail-wm1-f69.google.com with SMTP id l31-20020a05600c1d1f00b003deab30bb8bso1262440wms.2
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 10:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irfXd+OrbWvofFmv4DMNGRP0MqrsgnJtsh3k4L15HzA=;
        b=oeBoFdSKtS+NYPM0pi06B6bte/GhQ2CBpb40izOssH88LrKuVKEc1IOkhgbD92CHvu
         FPIJidLhL6YQBGsuiX4ShdLTT0cBv7gOkKze0VjgEaPJLyy9c7DDUIlcUUy7uw49+mtU
         VH2/W/RgpFxR4ZUhBpjm2m2edOYUqFSegmioW5z5ET7gRKnoOAxGdKQyrgDdBe5Tx5nP
         cYcFpSTNZqjIBfSMfVehh5oiygLtzoV0hdq/M50iA3L+z5QALkY+EUZLHrLTEgq/0u2B
         pXtqVPx4EmS0M07ArNInADHaPO9JmwoXB7A31N+AMfeHZTKJacpmW3ze19AuoltXqd3A
         190g==
X-Gm-Message-State: AO0yUKX5gUkR5pmQSOEtIemFG/IQgt3MfvwzMBlaZjJoD/HjJRpPtaTT
        ZjI+zu1AD7paianMh7oft30tsTZgFMpHJUX36NJ6Kx6t/uUWQW8wK5HavnftsRdlvoB9GO7XMo0
        IXsZM1GzcquUqsD91MchqO6d1jxZbzn1nh3jpTnYumRMzF/9hIQH52FmVZKc435A6
X-Received: by 2002:a05:600c:468b:b0:3dc:486f:1552 with SMTP id p11-20020a05600c468b00b003dc486f1552mr2958253wmo.34.1675276747650;
        Wed, 01 Feb 2023 10:39:07 -0800 (PST)
X-Google-Smtp-Source: AK7set9wgu5J7HLpiXqapVMiboy+U/oLSr3m8W1k/5mrCDRdWpLICHi4/FuknGpRgDvciRWBI8cK0w==
X-Received: by 2002:a05:600c:468b:b0:3dc:486f:1552 with SMTP id p11-20020a05600c468b00b003dc486f1552mr2958236wmo.34.1675276747455;
        Wed, 01 Feb 2023 10:39:07 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id m17-20020a7bce11000000b003dc492e4430sm2589010wmc.28.2023.02.01.10.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:39:06 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     qemu-devel@nongnu.org, Markus Armbruster <armbru@redhat.com>,
        peter.maydell@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Wei W. Wang" <wei.w.wang@intel.com>
Subject: Re: Fortnightly KVM call for 2023-02-07
In-Reply-To: <87o7qof00m.fsf@secure.mitica> (Juan Quintela's message of "Tue,
        24 Jan 2023 16:03:05 +0100")
References: <87o7qof00m.fsf@secure.mitica>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 01 Feb 2023 19:39:05 +0100
Message-ID: <87ilglxmba.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> wrote:
> Hi
>
> Please, send any topic that you are interested in covering in the next
> call in 2 weeks.
>
> We have already topics:
> - single qemu binary
>   People on previous call (today) asked if Markus, Paolo and Peter could
>   be there on next one to further discuss the topic.
>
> - Huge Memory guests
>
>   Will send a separate email with the questions that we want to discuss
>   later during the week.


Hi folks

Just one addition for next call.

"Wang, Wei W" <wei.w.wang@intel.com> has asked to give a presentation
about a new feature:
    TDX Live Migration
He wanted 1h, but I told him that we already have two topics for next
call.  So we leave it in half an hour and will do the rest of the
presentation in a following call.

Later, Juan.


>
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
>
>  Call details:
>
> By popular demand, a google calendar public entry with it
>
>   https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
>
> If you need phone number details,  contact me privately
>
> Thanks, Juan.

