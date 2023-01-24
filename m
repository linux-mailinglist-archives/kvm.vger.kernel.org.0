Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE69679CDA
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 16:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbjAXPD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 10:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjAXPDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 10:03:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFD96591
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674572590;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=K7kvdv6wvYJP9dCVajEv6FN9lfYBZBvsojCGxfXmS5o=;
        b=VXcZTJJYCjOGjYmsuObgSt8b17BD4T5ZECxj3oj8oLUQroD6z41gytg71qUJoTnho1oBfY
        L/5w07ltf2QhYppTbQxx8X41MMB+renXlCfvlI15wpSaFXPdf5NnNnXTLQjVK1HZT4PAXU
        aL3NtablYF27FXfUscGbMWz/tgU/gn0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-YPxxNtZHOe2hNGZ74uebhg-1; Tue, 24 Jan 2023 10:03:09 -0500
X-MC-Unique: YPxxNtZHOe2hNGZ74uebhg-1
Received: by mail-wm1-f72.google.com with SMTP id q19-20020a1cf313000000b003d96c95e2f9so4041412wmq.2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7kvdv6wvYJP9dCVajEv6FN9lfYBZBvsojCGxfXmS5o=;
        b=HKUrb8yzjrU/VbxhYfkxl8KiGRtcKyNBeMih+O2QwYtVmjUVpgw8YZ2O7aa00NDO8E
         j2QV9KV+uSPDG4tIDX7RIfmFlgHT1FQKHOtXYALeG3xrUFjCCLEKnRBJF5wsDB2tqEOh
         w4ozPUl3xiGB1nAMh9Uwqb1fmAjqswDvHtnjOZewycqDytVGuSFMOTnuevrVmTg2IOxZ
         EAaOn2cekPEPOXFgr2qfuvizCeDPD0Xrj1vfZbEAss2GIR21o1kBUmJXR+vULxZpudqa
         uVzWmeZp6sQYl3NwG6gN+7QKEV18ZuBskRZt9PVpDgGimJjqKxB/CXR20HuP/Z1I+dIJ
         mjXg==
X-Gm-Message-State: AFqh2kqAluMkCR5TajV33E8F6/FiJkpjfVNVI45Kt9JEHt7fKoEb29wB
        SeeRfGaEUSVQLsbqqRXRF7n39ShpogZTP/zWln4+GyIJc9FyGOHWseYQuL2CkzSkgySey3SahbM
        gvGNR1O/MKrymGJtHZK3PKuM9k6mghURYui3tP3f5oHMhav7JerN4KVynTkUCX1xU
X-Received: by 2002:adf:dc81:0:b0:2a1:328f:23aa with SMTP id r1-20020adfdc81000000b002a1328f23aamr25278424wrj.6.1674572587696;
        Tue, 24 Jan 2023 07:03:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs/jOZZNEY7RIrjFi14RFrGKUr8JfW5Mnq9RXNm4iHolDENzoTRYfQ+JrxTyUv32+zY0omTvQ==
X-Received: by 2002:adf:dc81:0:b0:2a1:328f:23aa with SMTP id r1-20020adfdc81000000b002a1328f23aamr25278387wrj.6.1674572587312;
        Tue, 24 Jan 2023 07:03:07 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id x10-20020adfdcca000000b002bbddb89c71sm2044330wrm.67.2023.01.24.07.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:03:06 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Markus Armbruster <armbru@redhat.com>,
        Paul Moore <pmoore@redhat.com>, peter.maydell@linaro.org
Subject: Fortnightly KVM call for 2023-02-07
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 24 Jan 2023 16:03:05 +0100
Message-ID: <87o7qof00m.fsf@secure.mitica>
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

Please, send any topic that you are interested in covering in the next
call in 2 weeks.

We have already topics:
- single qemu binary
  People on previous call (today) asked if Markus, Paolo and Peter could
  be there on next one to further discuss the topic.

- Huge Memory guests

  Will send a separate email with the questions that we want to discuss
  later during the week.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

