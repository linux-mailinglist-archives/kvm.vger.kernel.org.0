Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8501460B6D7
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 21:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiJXTMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 15:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiJXTLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 15:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FAB36792
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 10:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666633735;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=E8U2lwzte2ArrE93NNq5YpgdgKlqmYf52lAguACgFO8=;
        b=aRAsLjTNaJGEVf6oghdlTI4QjUtlHUJsaFGibeOVV/NuNSbAuez8K3sWCiDMD9MgHSPQrQ
        zh105NtoMMnnUdZJ7rZ7g0N813tzYUKxsOW75j6OhsiSVWAwgsXeUJiieBMErk+dg/ZG/Z
        w64LwNhllFYFPBHFns4lwzSvdzEqB64=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-462-kP9gy9QmP62q5UMBLctK0w-1; Mon, 24 Oct 2022 13:48:54 -0400
X-MC-Unique: kP9gy9QmP62q5UMBLctK0w-1
Received: by mail-wr1-f72.google.com with SMTP id n13-20020adf8b0d000000b0023658a75751so3062799wra.23
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 10:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:subject:to:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E8U2lwzte2ArrE93NNq5YpgdgKlqmYf52lAguACgFO8=;
        b=Yw6jlzXP5RcBYOrMWAPYDPY0TFIzJNFUm+faBk4TE/86//WrbKZRjxdQ4GP1B7FSNC
         1EkEnZl6ttdRU9JacG7BycNzEd32Me8buq5awZB1s2/JHE88EH9sIZQm5y+NhXD1vRyX
         MKGhNifKcHJbhkYSodf1ZVZfylK3ONeb3sjno167LRC9HurtpmlNlS9t4KnIdfMO8ARO
         S62Z5Kalm8bB8gtRBlQW/wpHVh6E5zBAM93cRZ4WWzPvh2iRgzFAH3H6Sh0gzot2PUDx
         0i1ZqeCN9A5W+s0osvh/UKetNfRtT03dmCL4v1VjnH9iSssNrSN5+b1dBiyOwlt/res4
         5aCw==
X-Gm-Message-State: ACrzQf3VHoOCsFcxPQ9xYIAszA96mKE+RtmEogPW+5ogP/wXGB+wvHSR
        tlrPpMG+aodorno44saSGT7RDPAXgilj9FucQ53wp/TrdZQdCSele+MY2IxPAdeaMurDJ/zyw4W
        9vhNst/7e2aOnSZEe7NXzp47SXrwSq9JkR9ZGWXTv928/liytZXT42dzP3reXcjjl
X-Received: by 2002:a05:600c:1616:b0:3cd:f079:e34a with SMTP id m22-20020a05600c161600b003cdf079e34amr5691052wmn.11.1666633732772;
        Mon, 24 Oct 2022 10:48:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6VUFD1ubAUWM5rvcmZeECVQ2fG/57AQF6qClJnt6APdhHCkm5ct9f3+wtxhJ2SYgP5uKxaVw==
X-Received: by 2002:a05:600c:1616:b0:3cd:f079:e34a with SMTP id m22-20020a05600c161600b003cdf079e34amr5691041wmn.11.1666633732548;
        Mon, 24 Oct 2022 10:48:52 -0700 (PDT)
Received: from localhost (static-28-206-230-77.ipcom.comunitel.net. [77.230.206.28])
        by smtp.gmail.com with ESMTPSA id e12-20020adfdbcc000000b002258235bda3sm246170wrj.61.2022.10.24.10.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:48:38 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Adam Williamson <awilliam@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: (Extra) KVM call for 2022-10-25
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 24 Oct 2022 19:48:29 +0200
Message-ID: <87a65l9kpe.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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

As discussed on last week KVM call, we repeate this Tuesday to
continue talking about vfio migration. So far we need to discuss:

- My RFC series, if they are enough for vfio devices (i.e. they are able
  to get a cheap call to calculate the size of the device state)

- My (not yet s ent) way of sending data through new channels. I lost
  the calendar entry for all calls during this years.

KVM developers conference call
Tuesday 2022-10-25 =E2=8B=85 15:00 =E2=80=93 16:00 Central European Time - =
Madrid

Location: http://bluejeans.com/quintela

If you need call details or want to be on the calendar entry, please contac=
t me: quintela@redhat.com

url:
https://calendar.google.com/calendar/event?action=3DTEMPLATE&tmeid=3DNWpzcz=
hmMThzY29tNDJwY3I3dmEzbzE3cjcgZWdlZDdja2kwNWxtdTF0bmd2a2wzdGhpZHNAZw&tmsrc=
=3Deged7cki05lmu1tngvkl3thids%40group.calendar.google.com

Later, Juan.

PD. The conference is on: https://bluejeans.com/quintela google calendar
decides that it is a good idea to add a google link entry by
default. I think that I removed it this time (who knows).

PD2: The entry should be public, if you can't access, just let me know
     to figure it out what is going on.

PD3: No, I have no clue how to convince google calendar to let someone
     that is not logged somehow on gmail to show the entry.  I tried to
     put it public everywhere.

