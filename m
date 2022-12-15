Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CECB64E388
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiLOV41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiLOV4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:56:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73BABB7
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671141337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vos1+z5OkM2lbvQ/8RNPfK9IFqX7xMJAguBWePudVWk=;
        b=chRZulOiWGwVC09gSJ3/L/78ntiBxs92OpPTw6dxJ4g6Bx0/ixno1nQ8ppoTQX04zPB4e/
        8CNwPGVKfaUKGB31yNhNNmGHPdiV+EEpn8fJhivLb7iri5UhI46+Bjrk/aiwtjmL/s2QuE
        KpXARV/X8QtZcJopFhCmRbU6Fwkbvoc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-r3p_7GcjNMy6qBQMn0ghcA-1; Thu, 15 Dec 2022 16:55:36 -0500
X-MC-Unique: r3p_7GcjNMy6qBQMn0ghcA-1
Received: by mail-il1-f198.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so441484ilj.14
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:55:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vos1+z5OkM2lbvQ/8RNPfK9IFqX7xMJAguBWePudVWk=;
        b=FivQNr9UjyGuPImsnqz+R61XoaBk2Eneop9k+5/Rie18B8mfuews0EcvjODS80dqYT
         VulhMM9EJ0I9KEbHrVwlw5+VyQeJyGaUGbmSvA/tDexUR3Y0oDULYl40ISNxmLHcwpzD
         CWy+5N+B3hcjICrhLNIdr+dIoxpbvFTLNhZMFBD8+WkFlfEEKkQXQBa3iDJPPfsEFdKw
         I0mC6MED/n4SxtjwGtMvL+oI8Hq2xqvQ8GKGhLjxmGPJ7+qhc6wY6RgpxwAHIpIfBhLK
         36MNYWcTeklzHRhrbIsiAwbIe24+42NifziZBvhIBg6U2TIOpKs46Rssi2pizRofETOV
         wHug==
X-Gm-Message-State: ANoB5pmQ3ufgqtU5EqftLJUew3UpQ+33vrfXnhxAQIsdXPCrlDkNzrI5
        jJWZST8d8oaueB5LmVF9Q1g3rKgMpRc8NNAzN2cRTu92NGn6UeMeePDTP5YVn5yY7TIWqUKuJPd
        LqlG7LO9PW45+
X-Received: by 2002:a05:6e02:e42:b0:303:92b3:27ec with SMTP id l2-20020a056e020e4200b0030392b327ecmr16203667ilk.31.1671141335627;
        Thu, 15 Dec 2022 13:55:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4gKGQbnyggKffBVvBbY4HJA//GchKMkj1R3kloLiYVtBWO1MyRQOxSUuDkypG1B6qE22P+Ag==
X-Received: by 2002:a05:6e02:e42:b0:303:92b3:27ec with SMTP id l2-20020a056e020e4200b0030392b327ecmr16203657ilk.31.1671141335398;
        Thu, 15 Dec 2022 13:55:35 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c91-20020a029664000000b00389de6759b8sm140604jai.162.2022.12.15.13.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 13:55:34 -0800 (PST)
Date:   Thu, 15 Dec 2022 14:55:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] VFIO updates for v6.2-rc1
Message-ID: <20221215145533.3a27b429.alex.williamson@redhat.com>
In-Reply-To: <CAHk-=whQ48-RsU85vM+Kwi=pRNU9fX8JXmooqx4=c1QYOjv2uw@mail.gmail.com>
References: <20221215132415.07f82cda.alex.williamson@redhat.com>
        <CAHk-=whQ48-RsU85vM+Kwi=pRNU9fX8JXmooqx4=c1QYOjv2uw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Dec 2022 13:20:11 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Dec 15, 2022 at 12:24 PM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > I've provided resolution of the conflict chunks here below
> > the diffstat.  
> 
> Ok, mine is slightly different, but the differences seem to be either
> irrelevant ordering differences (in the Makefile), and due to Jason
> apparently renaming the goto targets which I didn't do.
> 
> But hey,. maybe I messed up, so please do check out it and test. I
> verified that it all builds cleanly for me, but that's all the testing
> it has gotten.

Yep, all looks well.  Thanks!

Alex

