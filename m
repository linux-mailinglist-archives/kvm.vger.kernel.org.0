Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6916E1628
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 22:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDMUzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 16:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjDMUzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 16:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AC87ED8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 13:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681419303;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=qyFTmv8B9Q2ZebQ5VyUiyE3lYybh2qt9vq9LjX5mk08=;
        b=Pddnnb2uXx2l8BiOqizChOwsFh1t+hRd0Y0ycDFK8UrKXjQ/OfLjcuH2E1nJS+oDE1i+wU
        2pxen4OVlRkLoNUpX3chxctTJE+GpWwvDIKS7Z5K0o2ufzQ0Z8aJt5F5KhQN6YrnB6xpYd
        AJ2Hx/VZZh85iJHaGwcveh4JX9681f8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-vB-hWoWkNUGvxInCOodIsw-1; Thu, 13 Apr 2023 16:55:01 -0400
X-MC-Unique: vB-hWoWkNUGvxInCOodIsw-1
Received: by mail-wm1-f72.google.com with SMTP id w16-20020a05600c475000b003f082eecdcaso6093471wmo.6
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 13:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681419300; x=1684011300;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyFTmv8B9Q2ZebQ5VyUiyE3lYybh2qt9vq9LjX5mk08=;
        b=Jg1alsJ5kS0YU2y1cez6BwsvszwGh5dhRkm0Pt+FM40oC2XzJcjkCH9HCZpO/dWfAU
         +AElMr98ePd2yjn2bO3WtcJp+aKLNQEQLAr/wivmsA4aJKumpdsMS1B6WYs2m1Xy0UvQ
         Oj+VotIAW8OBs6slY/MsNjwAfaI6pPK/2TU2zMmOySJqPW+SJwaYINHuubQrCXEt7/L4
         7mx6pINoBO0g1ME5a498aLsaf7BBJrI+I+2qeIM/tgX2z3yk05QzJe9otGdi8hz6XClY
         5i+RT2adIvItfvfjiLE1/3wyYYCw/b/0jJ4nHPBNlld10EaCJh9c2ZyqJdUR93XsOPPC
         dROA==
X-Gm-Message-State: AAQBX9djS/ciMMJl5lsCQwo5ees6YT/MsVRrTbiFUx1GD3hJuc7P7rnr
        lj8f0p0CxCZgWkbqTZDQhYYRDu2P13TiBFlmfsEb2VCIBv5zhKlPdhmnsIUfu7A514PSq0xk/85
        +640rs3Ozz+AN
X-Received: by 2002:a1c:cc05:0:b0:3ef:d8c6:4bc0 with SMTP id h5-20020a1ccc05000000b003efd8c64bc0mr2699317wmb.40.1681419300318;
        Thu, 13 Apr 2023 13:55:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zo143EWZNQSrlA5zw2mZ1NxT1Cye6rNp2MzadTtPGAPSIW66kV+mrpkv/u1nWRc+xOpHIqKQ==
X-Received: by 2002:a1c:cc05:0:b0:3ef:d8c6:4bc0 with SMTP id h5-20020a1ccc05000000b003efd8c64bc0mr2699281wmb.40.1681419300048;
        Thu, 13 Apr 2023 13:55:00 -0700 (PDT)
Received: from redhat.com (static-214-39-62-95.ipcom.comunitel.net. [95.62.39.214])
        by smtp.gmail.com with ESMTPSA id v3-20020a1cf703000000b003f04646838esm2707316wmh.39.2023.04.13.13.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 13:54:59 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     afaerber@suse.de, juan.quintela@gmail.com
Cc:     ale@rev.ng, anjo@rev.ng, bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, Eric Northup <digitaleric@google.com>,
        dustin.kirkland@canonical.com, eblake@redhat.com,
        edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
        eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Subject: Re: QEMU developers fortnightly conference call for agenda for
 2023-04-18
In-Reply-To: <calendar-8e6a5123-9421-4146-9451-985bdc6a55b9@google.com> (juan
        quintela's message of "Thu, 13 Apr 2023 20:52:45 +0000")
References: <calendar-8e6a5123-9421-4146-9451-985bdc6a55b9@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Thu, 13 Apr 2023 22:54:58 +0200
Message-ID: <87r0sn8pul.fsf@secure.mitica>
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

Please, send any topic that you are interested in covering.

[google calendar is very, very bad to compose messages, but getting
everybody cc'd is very complicated otherwise]


At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
QEMU call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you want to be added to the invite, let me know.

Thanks, Juan.

