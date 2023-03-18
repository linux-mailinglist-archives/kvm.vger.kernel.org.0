Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C687A6BFC14
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 19:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCRSAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Mar 2023 14:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCRSAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Mar 2023 14:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030911E281
        for <kvm@vger.kernel.org>; Sat, 18 Mar 2023 10:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679162373;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=OJEVScnaLDHPfvx83sUGg69fsesIBjFMqQlpwoU8/S0=;
        b=ghcVMcrkYK44r1FD2Qv7cziGz3u9IH1buqbflBkBcWvpboNSIyEm+dKkkMfGGW5DUD2WcP
        KTLO4BtRbGDkdpG95SVhLISyegEpEAHMfGV5qxXMRsjR10L54G5uwsRA177aTyGREyPAun
        m3gP/Qa6nAqFaoAb1Dmk21+6uGF+5yw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-2v3_DUxlMeCTMggW0dh7GQ-1; Sat, 18 Mar 2023 13:59:31 -0400
X-MC-Unique: 2v3_DUxlMeCTMggW0dh7GQ-1
Received: by mail-wm1-f72.google.com with SMTP id k41-20020a05600c1ca900b003ed383b1b62so3054056wms.8
        for <kvm@vger.kernel.org>; Sat, 18 Mar 2023 10:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679162370;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OJEVScnaLDHPfvx83sUGg69fsesIBjFMqQlpwoU8/S0=;
        b=3Y6w/cT+LXuqxxZoXcTLgXvT11GKxcQQTBtYdfOMG470rIISsoZ4FfF0DlrKYqKLj4
         YSn417AuK6nFu7h0TZQI1y/Pv+Z7T/c81nWxsObVV+uO3Kd7fuSMPqBURdVhxa5+MqjJ
         M/YNdU0HpM5lnVocLPMUP9Zj/7n40rkSDlCU11in0e53eQ439uVddlVcGDbxchhLjKAF
         sbCYSBGm6/MmbS4cqK6SYAM0Kdcd1/Y4vR1JQ5w9aqt0XPsBAmCLFhL+JNc5JN45I3Xw
         Iks5zsGstBgPPJvTIUm5dPo9prHg6Mfc2f4Tc4H4UmCfn+79Hj6fcXnuIsjCj0f/2c03
         MvhA==
X-Gm-Message-State: AO0yUKWaki/SXmgjQpIJz8hjcKzF7RAAv0ftqh1RvVrfQ3GG5126O7Km
        UWEtJctcD853n5J5YkMnbmd5WebkfQkO8SfcSLReNB8eNKRmCTGsdfa9eLq/+BGDCFknXxRC5hI
        xHjBomn/HoVRA
X-Received: by 2002:a5d:4311:0:b0:2d1:a818:6c23 with SMTP id h17-20020a5d4311000000b002d1a8186c23mr7486524wrq.39.1679162370578;
        Sat, 18 Mar 2023 10:59:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set+YPaUznPcUWXi0WWRMpRB/TajlljOehVWXlea9GX4ZNX+Vc1GOTm/9EGE8FRa89zZa3pmkMA==
X-Received: by 2002:a5d:4311:0:b0:2d1:a818:6c23 with SMTP id h17-20020a5d4311000000b002d1a8186c23mr7486513wrq.39.1679162370301;
        Sat, 18 Mar 2023 10:59:30 -0700 (PDT)
Received: from redhat.com (62.117.238.225.dyn.user.ono.com. [62.117.238.225])
        by smtp.gmail.com with ESMTPSA id h5-20020a5d4305000000b002c3f81c51b6sm4779444wrq.90.2023.03.18.10.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:59:29 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: KVM call for agenda for 2023-03-21
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Sat, 18 Mar 2023 18:59:28 +0100
Message-ID: <87zg8aj5z3.fsf@secure.mitica>
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


Hi

NOTE, NOTE, NOTE

Remember that we are back in that crazy part of the year when daylight
saving applies.  Call is done on US timezone.  If you are anything else,
just doublecheck that it is working for you properly.

NOTE, NOTE, NOTE

Topics in the backburner:
- single qemu binary
  Philippe?
- The future of icount.
  Alex?  My understanding is that you are interested in
  qemu 8.1 to open.

Anything else?


Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

