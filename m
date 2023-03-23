Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851816C6FC0
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCWRyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWRyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9A4268C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679594039;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=AcVaKmUYfRPIzhOHIdyvhx4rya5cRTOl5IuLPMK0XRs=;
        b=U0nvgveYyTJ1ekEKFECLc5KZXZH6zzl2HK7xew+5Dgwz4XHDaJPCL2iPe9k+YT6yb7/rKI
        lmHXuAJH43/0mUJd/QDhyNaAoyibWzAtpxrxnE6LxO262EHIuBK/ssqZDO4SHNHLdQoutU
        ok1kVZe8/Gm85dGgo59jDGeYdqn3tcA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-KpByUvjTPdOQR3l4SAS0Fw-1; Thu, 23 Mar 2023 13:53:58 -0400
X-MC-Unique: KpByUvjTPdOQR3l4SAS0Fw-1
Received: by mail-wm1-f69.google.com with SMTP id bg7-20020a05600c3c8700b003ee86f5a756so1367647wmb.6
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679594037;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AcVaKmUYfRPIzhOHIdyvhx4rya5cRTOl5IuLPMK0XRs=;
        b=yn27Y4zuUAGrtabfQcwE/iQV13v1CYwpM8PoBegh0qfTtlb2Hx3Z6DwN8q5y/k6+ru
         JIlOxemzJ8BANvkwYp2Hkp+6J/CmR1/vgKdmlLarg6fTnnEnwlErFfYJmBeFopZeeBwC
         5LDC87YvScoMWof0xRlTYVQIl30DH54k1Hc+n82vFvSswr1j7Fbm/Wtq4eHGSJAIVy3c
         CsZtaueS1naIMAYwOr9nO5DuUsnBrAYDJ9ylyv06z73IdvkY7F3rL7Udjcxb4QQeAPnQ
         /TmC/T86y/E7FJRJ2UO4zUDf1ADr8QFh4s64wMfJLSC95H90OYv1N0m17TaGBajqS7DY
         tqLA==
X-Gm-Message-State: AO0yUKXQyauy/sxfr3SU3kQ8dbqleYU/2VZV1g9B2APo0MFrOJ4Oq1r0
        Anf0OWod+0cs/oRrjxNGWiqBTwe0AyRah86Fkkfp6pPgIKCx6QGYPRb2heG31g6QklP8p6dYrqt
        CzadhlKwoGeHiBPLq5nstc/T31ofQP/IyAP9nRC7DNQXSgZTA3bgU2SmVRs+8uibiiwndzkVD7x
        BCeA==
X-Received: by 2002:a7b:cc98:0:b0:3eb:3945:d405 with SMTP id p24-20020a7bcc98000000b003eb3945d405mr334719wma.38.1679594037093;
        Thu, 23 Mar 2023 10:53:57 -0700 (PDT)
X-Google-Smtp-Source: AK7set+/muTI6EHBcwKMzSGfpd6mGkNFf0hVFu3RXbKRQPHnNEQmVeuKo8kX4qewJldKEM1tQpW4DA==
X-Received: by 2002:a7b:cc98:0:b0:3eb:3945:d405 with SMTP id p24-20020a7bcc98000000b003eb3945d405mr334702wma.38.1679594036736;
        Thu, 23 Mar 2023 10:53:56 -0700 (PDT)
Received: from redhat.com ([77.211.5.130])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003edef091b17sm2510776wmr.37.2023.03.23.10.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:53:29 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Alex =?utf-8?Q?Benn?= =?utf-8?Q?=C3=A9e?= 
        <alex.bennee@linaro.org>
Subject: QEMU fortnightly developers call for agenda for 2023-04-04
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Thu, 23 Mar 2023 18:53:14 +0100
Message-ID: <87cz4zmk1h.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

Topics on the backburner:
- qemu single binary
  On this week call, phillipe said that he wanted to discuss pci irqs
  and default devices?
- The future of icount
  My understanding is that Alex wanted to wait until the openning of 8.1
  to continue discussions/show code.

Anything else?

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
QEMU call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

