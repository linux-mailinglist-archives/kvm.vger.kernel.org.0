Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F6D6796D8
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 12:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbjAXLmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 06:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbjAXLm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 06:42:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE162884B
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 03:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674560503;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=+2NFEF7IRIXzVpiGFFgag93HDumbpr+DQPbZrpSfuYk=;
        b=B8uzPS1ItkYPe8lUm6hhNXXFoATGsIplcUnPXG4O1ylHARa+EqzHMGdg5x79U3amHsf+71
        YjpXvBk+ToYlrE9sqZknyjqyHn/9QbSMpLHM16+ryzZ9bR4tnNDAy+urKtJD2jcJVW6UBx
        cMdF1xYF7UxVDGQGmRCPDGC4tJufvpg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-350-gB-AUVkBOYSEFPht_y-rIQ-1; Tue, 24 Jan 2023 06:41:42 -0500
X-MC-Unique: gB-AUVkBOYSEFPht_y-rIQ-1
Received: by mail-wm1-f72.google.com with SMTP id bg25-20020a05600c3c9900b003da1f6a7b2dso11068012wmb.1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 03:41:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2NFEF7IRIXzVpiGFFgag93HDumbpr+DQPbZrpSfuYk=;
        b=Dk/wegzdGvLGRwUIrsBgaoDKpz6qQMg8M4JNcdN411+DFco1X2YGvc9QuDwqTMJqx+
         SgSd+02CebbE5Fp/rt81TD1NQUxDas1bXuGMk4G2qnJf11GEfZ/5IXnk6CSq44g2JwIg
         cECt8+M/jtMfiKwjfebDM67/NQN+RFWnQ3h7iGjQUKNPUVAe3SYe9Fi05alaVygPk2FG
         WQL1BZQE1b6FI0dZAgt5nQpAkjfCr+nn4CXVKBaRMQkxJf2FJibtLQUkEKApiIoYwGun
         vgjDwLhjlAOV8Z/64aIkPuQhylGJv+TLNCCnkhamyU5+IlgYifvkbYYlo8Xt35vZtykp
         IIcg==
X-Gm-Message-State: AFqh2kqZjp73AXgglybltbdiUD6p9cc/DR/zMHPNG2XyENXX/qq2J/cq
        ZC9WgjI1RFFc8D/eiC/4cUgg/5yS86RXkKu4+dsHx5fNvjC+kBGjMtogBYdwZhDf60oX1yKYUqU
        gzYspaVHaWrmCxRNphSKqj1aE7+8i0EDrQTnyWodYu79BQidUCuZY8bE2lokFoWkF
X-Received: by 2002:a5d:5c10:0:b0:2be:3ccd:7f33 with SMTP id cc16-20020a5d5c10000000b002be3ccd7f33mr20356119wrb.27.1674560500734;
        Tue, 24 Jan 2023 03:41:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvGGtuLQf5OyAI7AkSDGbqG+sSRaqvFyvMgJzPwIxPdW0Wv+2hsmrkdKiqYekgAQ+bDdsh/tg==
X-Received: by 2002:a5d:5c10:0:b0:2be:3ccd:7f33 with SMTP id cc16-20020a5d5c10000000b002be3ccd7f33mr20356102wrb.27.1674560500497;
        Tue, 24 Jan 2023 03:41:40 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id z8-20020a5d4408000000b002b8fe58d6desm1673525wrq.62.2023.01.24.03.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 03:41:39 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Today KVM call meeting
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 24 Jan 2023 12:41:39 +0100
Message-ID: <878rhsgnws.fsf@secure.mitica>
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

We are having today a call meeting, we are switching to jitsi as
discussed on the previous call.  The "coordinates" are:

Click the following link to join the meeting:
https://meet.jit.si/kvmcallmeeting

=====

Just want to dial in on your phone?

Dial-in: +1.512.647.1431 PIN: 1518845548#

Click this link to see the dial in phone numbers for this meeting
https://meet.jit.si/static/dialInInfo.html?room=kvmcallmeeting

 Call details:

By popular demand, a google calendar public entry with it

  https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

