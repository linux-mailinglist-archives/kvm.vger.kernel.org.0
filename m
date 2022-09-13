Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A15B6B7D
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 12:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiIMKRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 06:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiIMKQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 06:16:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414DA50059
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 03:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663064217;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=inVe8dJWP7LKJfU9nqCSt710wfXhHJdu+160e8XyDjw=;
        b=EvpLu4uS5a82yE6ndo/xAQtf1Q7FkVb/uUY40Cws093XvqGbjEO/2ftagLbCNLLH21AVDm
        C/od/yzOzTQMNlRIuatLz1LOFqsrZ8MHM3SKzztoTFINHBRbDP7MKOtwQKFrBSBlnDsC1y
        Y5tHkh/4cUkS7S9RAiH1mD/ttvlbuJY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-116-kUf80r9OO2K9h5S8lc_l1Q-1; Tue, 13 Sep 2022 06:16:56 -0400
X-MC-Unique: kUf80r9OO2K9h5S8lc_l1Q-1
Received: by mail-wm1-f71.google.com with SMTP id h133-20020a1c218b000000b003b3263d477eso6277146wmh.8
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 03:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=inVe8dJWP7LKJfU9nqCSt710wfXhHJdu+160e8XyDjw=;
        b=kCegv9f4I60uhX19beWgk7sZ63pvNy02jYWOVf3idynflvLkzPaSs1aG87qZFQs0Ur
         KkuCBs32ZhZ575b/yWfLH/ECW5Df5QCBtu7L6BkXYX3YuQpX5eQJftmuWDFQlrl5o9G8
         SOV1PcKESLBHxqEOFNmRArWLK9z0FFpFyeuE8GLiNI29FpxSooNnJc7kXWwm1lDvDiVP
         d/HLgJwB755R8e6mP1KbKHSEaF6TmxopCjGHdrH5pyHe/eTGbuYhC0OIksw4l9rSvZH3
         wpjUaMAhTONUR2fZB/giZuHx+YdyvruNwnuaYKLerc5qmXoo7TmjpqAMnUEJK97B6q7r
         nVuA==
X-Gm-Message-State: ACgBeo2QNRxnpRM0esCh9qHLOyrOKXORtHdna3VuaqwaDfhKfjciy9FI
        maiBnaMo54s8MAL8ZtsmKr7wQNBhvcjRAzN9Ns/uckduFig3lp8ypWSk1F0LbCNePJiVdBJmD47
        ATp+uCdAbY8+tFo1kcxJCJaS1RHcpAhRCoqdJ9bntEeWV94hQKyN2RzIH/xOPffPp
X-Received: by 2002:a05:6000:2ce:b0:226:d420:db7a with SMTP id o14-20020a05600002ce00b00226d420db7amr16951095wry.489.1663064214907;
        Tue, 13 Sep 2022 03:16:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ENAUQ3Vwt5Y5a4zvjhTouitO7g55T2X93uJd8GKG5xTH8WvYCWVmtq8lfIyaozYJxbnUZPg==
X-Received: by 2002:a05:6000:2ce:b0:226:d420:db7a with SMTP id o14-20020a05600002ce00b00226d420db7amr16951080wry.489.1663064214618;
        Tue, 13 Sep 2022 03:16:54 -0700 (PDT)
Received: from localhost ([89.101.193.72])
        by smtp.gmail.com with ESMTPSA id bw2-20020a0560001f8200b00228c483128dsm7402536wrb.90.2022.09.13.03.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 03:16:54 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2022-09-20
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 13 Sep 2022 12:16:52 +0200
Message-ID: <87illrpoiz.fsf@secure.mitica>
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

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

https://calendar.google.com/calendar/u/0/r/eventedit/copy/NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjA5MjBUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn/anVhbi5xdWludGVsYUBnbWFpbC5jb20?scp=ALL&sf=true

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

