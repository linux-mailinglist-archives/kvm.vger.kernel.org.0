Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614E56BFC1C
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 19:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCRSLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Mar 2023 14:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRSLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Mar 2023 14:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2985631E20
        for <kvm@vger.kernel.org>; Sat, 18 Mar 2023 11:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679163041;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=+GjR7fSCNL8SDsgzOekp2fTkL2g0P5AjbEUKio71uEs=;
        b=Zv+Qmbo6ZedDheLJyhMYWhRnWuEFjujBkFmjwevZF0O3PIuGJG273rGKkU28rz5wjxKMFH
        2I6TguR3sBieJWJDYuIIuDmruW8/LGJ5f283OU7lezw60YPEQEpPLUzlLQm/7jhhAj8wHh
        0hJpOornSOPtbMMA6ICOXW0GUrtQnXY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-Az03IoCYM4-thbmkm_Md2Q-1; Sat, 18 Mar 2023 14:10:39 -0400
X-MC-Unique: Az03IoCYM4-thbmkm_Md2Q-1
Received: by mail-wm1-f69.google.com with SMTP id 1-20020a05600c024100b003ec8023ac4eso3086572wmj.0
        for <kvm@vger.kernel.org>; Sat, 18 Mar 2023 11:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679163038;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+GjR7fSCNL8SDsgzOekp2fTkL2g0P5AjbEUKio71uEs=;
        b=Lb7Z5r0xQDQJR1iYMGOSSyLI/N8eXHK/8i5kGYX6KjQdMqyq6BJl+q3aFMYJxhi/6w
         bafp+VJGJJ/g8vcYnhFmN3VZqfQ70qmTmyhDFsMaIrzWebQhD35O2f7ox2EsQxAOPDrw
         05Fjj9pWdmw0qN8CRRoUIVG/pG4Ru5g6pjjcCWBR32/vowhW3PbzsRAB+2DVcec/8tKa
         Pydb60Eum1C/qgrG2bWLIQ/HGOg1XsMKMDCwIKmT104dF0/LfIBExEETFuZIb6brz3q+
         Yidy+h1P+Lw2AK13nfRR2Ou9Y0gypp5MOMW2iFv4LB2UQM3oivZaxSo94bsZE2IZsg15
         ZBzw==
X-Gm-Message-State: AO0yUKVvNpf22Z0sUKltsXT64uDiDvHf/sp8tCBTVT8RM4jfQsEFphtm
        h66kj92yBGtJb/Gq7Vjq90RmQ9cKCflQ0dulTfvAa+pUoIQcDuhkYyRUCOJs58DIFB+MXiXh28b
        1wXsOEQwijMe9
X-Received: by 2002:a05:600c:46c7:b0:3d3:49db:9b25 with SMTP id q7-20020a05600c46c700b003d349db9b25mr27429703wmo.26.1679163038640;
        Sat, 18 Mar 2023 11:10:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set8xkg8OfKGxHO9gdyd5K3dDqlSysUY5qzN0XBMec8uJZ5R3AcuDriQrl+mm0GU7oHsEYYF/mw==
X-Received: by 2002:a05:600c:46c7:b0:3d3:49db:9b25 with SMTP id q7-20020a05600c46c700b003d349db9b25mr27429691wmo.26.1679163038394;
        Sat, 18 Mar 2023 11:10:38 -0700 (PDT)
Received: from redhat.com (62.117.238.225.dyn.user.ono.com. [62.117.238.225])
        by smtp.gmail.com with ESMTPSA id k3-20020a7bc403000000b003ed1f69c967sm11311267wmi.9.2023.03.18.11.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 11:10:37 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org, kvm-devel <kvm@vger.kernel.org>
Subject: Should I record QEMU developers fortnightly call?
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Sat, 18 Mar 2023 19:10:37 +0100
Message-ID: <87sfe2j5gi.fsf@secure.mitica>
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

I got asked several times if we have a record of previous QEMU calls.
I think that we don't discuss anything that prevent us for recording the
calls. But they have never been recorded in the past.  Could we discuss
if should record them and make the recordings available, or not?

Is there anyone that has any strong opinion in any of the two
directions?

Thanks, Juan.

