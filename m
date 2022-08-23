Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F2759E9E3
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 19:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiHWRjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 13:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiHWRjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 13:39:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8119A9EB
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661268397;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=QjnX3wmdIgtFpI8ynDv7BiTpKz9FZ9aszLAG9oIJvIo=;
        b=YJgXLqkEnMUE6QWT98f5E3BZcPBdiXH7Zqp+LZ0bX/6xuSIs4178E0z7rBM46nsF6dHpBM
        ls7AzcyEBCrGZUHWtWvGuFpjTxYX9bNxEwgcMqL2MIhN3hvjU7uMewdPayCDYuclp/oVDW
        fpvIODydMzRMV/MmQWeyRmpe5ZQZNVE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-flCHbY3PPU26kTQMlgUFbA-1; Tue, 23 Aug 2022 11:26:36 -0400
X-MC-Unique: flCHbY3PPU26kTQMlgUFbA-1
Received: by mail-wm1-f71.google.com with SMTP id x16-20020a1c7c10000000b003a5cefa5578so2916899wmc.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc;
        bh=QjnX3wmdIgtFpI8ynDv7BiTpKz9FZ9aszLAG9oIJvIo=;
        b=ThD3sTY0ylEQpRoM927cPlkf7ZuddoW/0buc7MqtdioRagNd0aradEfng9c3SDaxx3
         qrUQ0HDxgA2g/c7fY2dBAMi1lvXhzW948ATAYOTS2r/klBzDl5aPZ26oIhAjhvYLGCn1
         awLpsYklQntifWxw4iT0WY00MZOZVeq9X4YgNuC4NCsLuA6hIiFea0+6E1t1c29j/zYI
         g2Aqg3Lq3EpGtYplfZG1KGQRv4LdnSDo6voYnFdEsDtZSrrFBmXjS9bXxUw2KqXOAIFx
         4mafroOvtAmC8IDD0aXUtgio7Onl1V8fg3xWjqGEGwA4JSuLFDBiL2MHUQOLxBerB0zc
         vztQ==
X-Gm-Message-State: ACgBeo1QY7z4kp5gmAU+SB1VA4US0Cz94kDjhk0nEUjd6PzQkdTNDYb0
        lCrCgXo2mpfbz2cC84yak8dKZOnb+fUkp/vZMXiTsNqDLi59iZ77VRHttF+b1hxPTZ/NmjCIKdx
        C/QMgBIhwjhRdVEnnmv7QtyZCTknTwCoNk/yDqyPn9G0Szx1cN4Owy4vBAOVXd1TJ
X-Received: by 2002:adf:f7ca:0:b0:225:2df0:d23 with SMTP id a10-20020adff7ca000000b002252df00d23mr13921778wrq.255.1661268395350;
        Tue, 23 Aug 2022 08:26:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5LbOMosWu9JXp9iYzCDUIlrDKYbksxcBIGQrZXfwxkXWdWKnDVHPQ8hSH6vYNwbUrBtxfQuQ==
X-Received: by 2002:adf:f7ca:0:b0:225:2df0:d23 with SMTP id a10-20020adff7ca000000b002252df00d23mr13921762wrq.255.1661268395098;
        Tue, 23 Aug 2022 08:26:35 -0700 (PDT)
Received: from localhost (static-205-204-7-89.ipcom.comunitel.net. [89.7.204.205])
        by smtp.gmail.com with ESMTPSA id v18-20020adfedd2000000b0021e6277bc50sm17289565wro.36.2022.08.23.08.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 08:26:34 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2022-09-06
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 23 Aug 2022 17:26:33 +0200
Message-ID: <87czcryo9i.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

First of all, I am adding

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://calendar.google.com/calendar/u/0/r/eventedit/copy/NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjA4MjNUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn/cXVpbnRlbGFAcmVkaGF0LmNvbQ?scp=ALL&sf=true

  (I updated the entry, I *think* that now everybody can see it, if you
  can't please let me know.)

If you need phone number details,  contact me privately

Thanks, Juan.

