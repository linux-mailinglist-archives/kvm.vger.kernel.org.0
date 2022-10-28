Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C84961176E
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 18:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJ1QWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 12:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiJ1QWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 12:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0341CDCE5
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666974095;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=h1IpVPQmelOzExrKI7Q1wX5nVXwi3nwXWMr9RzFeuk8=;
        b=C08SUtgeYs4h2vIuXEr/swgpgflZJDLP6lQ0jorPvOqqw3zG/ex1H5ELYtELVPdi6AgQXP
        /L0JS58PeeL+ivhNhKEL6SFviOC5DeVlrHRpBA0dC+P1jpwCm37/DBUyptUDMMo1PfQA3x
        X5pAIdmpbzyllmZQaO71mEAwv01mvLY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-122-3FWvRLWxPfyRJ_sqBWMXsA-1; Fri, 28 Oct 2022 12:21:33 -0400
X-MC-Unique: 3FWvRLWxPfyRJ_sqBWMXsA-1
Received: by mail-wm1-f70.google.com with SMTP id l7-20020a7bc447000000b003cf6133063dso542618wmi.8
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h1IpVPQmelOzExrKI7Q1wX5nVXwi3nwXWMr9RzFeuk8=;
        b=tX8MvUp8DADC9hmXSdTofYKjGC+LkOFkgLq/XosJoiNNAcZKUrd6uYwi7EYjXER5hD
         EM0nh00Ke9pHGDM+HYLS52FBza0fVpxm0Wzi91r/Xf9aLrgtLR+71lwJYcGmi1kClk8J
         n6+Vr4BWgwRok0nvC/Ik91988VoiiNd+v8C8oLRfOkZLnO/235LePuqygfskr1UQ7dfi
         Soo/kdvhSpdqR7AN39+SGVoCaxJvFJ8ctWvkKXTGjh37FA17tuRgBmED1Dgz5JbOVOrD
         JL5i8mMkeJidgpwbSikYNnhSsFvTG+XoTl3J7HaErM3IBpZfbUPxaRyr8M3YoPIL9xih
         YnvQ==
X-Gm-Message-State: ACrzQf3VQEVp1AVvpOjQHr9SxcHfbJc2tJZoYiMNpbzcirJcgzszbtg+
        XIfYo1+A2Wt8juQoDkibGtiWhoE1rWT9cGxu8mxyxBXleAQXpA3mr7GcWSMgKmJ/n1Ja2zMgmSj
        Mt04UhErIV3BC
X-Received: by 2002:a7b:c005:0:b0:3c3:6b2a:33bf with SMTP id c5-20020a7bc005000000b003c36b2a33bfmr7402wmb.167.1666974092643;
        Fri, 28 Oct 2022 09:21:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6U7D4L8Uoj4SveCT/kQkA8Mofy7/aenWFmFnzzO06Zx6XcWrChzydAcomOrPbEdUl7ESv3JQ==
X-Received: by 2002:a7b:c005:0:b0:3c3:6b2a:33bf with SMTP id c5-20020a7bc005000000b003c36b2a33bfmr7383wmb.167.1666974092277;
        Fri, 28 Oct 2022 09:21:32 -0700 (PDT)
Received: from localhost (255.4.26.77.dynamic.reverse-mundo-r.com. [77.26.4.255])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d460e000000b002206203ed3dsm4030546wrq.29.2022.10.28.09.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:21:31 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org, kvm-devel <kvm@vger.kernel.org>
Subject: KVM call for agenda for 2022-11-01
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 28 Oct 2022 18:21:31 +0200
Message-ID: <87tu3nvrzo.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

Call details: By popular demand, a google
calendar public entry with it:

https://www.google.com/url?q=https://calendar.google.com/calendar/event?action%3DTEMPLATE%26tmeid%3DNWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjExMDFUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn%26tmsrc%3Deged7cki05lmu1tngvkl3thids%2540group.calendar.google.com%26scp%3DALL&sa=D&source=calendar&ust=1667405630835374&usg=AOvVaw3LYcQS3PjgGMlWJ-anZdRM

(Let me know if you have any problems with the calendar entry. I just
gave up about getting right at the same time CEST, CET, EDT and
DST).

If you contact details, contact me privately

Thanks, Juan.

PD. I am trying to setup this calendar entry again. If you are
    interested to be in the invite, please send your information to
    me. I added all the people that I had for the previous invite, but
    probably there are still people left.

