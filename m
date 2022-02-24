Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C24C29F7
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiBXK4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiBXK4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:56:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA16E27B9B7
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 02:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700166;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=YaoPgRiiMFZyEiFbgVOYNnx9/MH1T+le09fTeysDAhE=;
        b=EQ76mn3gvwDJb5keZFJInzqkaPNxUWQ/0Hjy71jV+ajO0Irf2QB7Mvg8E8BSmRUVfJxas5
        ZAs7M6fDyzo0S4TW6Q5vm+EomNA0iUNZpK3n9R8KBvHORapkFNN3opTWONUjaxOIN/Hqt0
        Zxqr9Bm6QG40XDDOkeWT9Q0iWmp9IaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-8ALh40HuPAmZXiOGTne0Rw-1; Thu, 24 Feb 2022 05:56:03 -0500
X-MC-Unique: 8ALh40HuPAmZXiOGTne0Rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B05CB51DF;
        Thu, 24 Feb 2022 10:56:00 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A15123769;
        Thu, 24 Feb 2022 10:55:13 +0000 (UTC)
Date:   Thu, 24 Feb 2022 10:55:11 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Laszlo Ersek <lersek@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        adrian@parity.io, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>, graf@amazon.com,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Igor Mammedov <imammedo@redhat.com>, ehabkost@redhat.com,
        ben@skyportsystems.com, "Michael S. Tsirkin" <mst@redhat.com>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
Message-ID: <YhdkD4S7Erzl98So@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
 <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 09:22:50AM +0100, Laszlo Ersek wrote:
> (+Daniel, +Rich)
> 
> On 02/23/22 17:08, Jason A. Donenfeld wrote:
> > On Wed, Feb 23, 2022 at 2:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >> second patch is the reason this is just an RFC: it's a cleanup of the
> >> ACPI driver from last year, and I don't really have much experience
> >> writing, testing, debugging, or maintaining these types of drivers.
> >> Ideally this thread would yield somebody saying, "I see the intent of
> >> this; I'm happy to take over ownership of this part." That way, I can
> >> focus on the RNG part, and whoever steps up for the paravirt ACPI part
> >> can focus on that.
> 
> > (It appears there's a bug in QEMU which prevents
> > the GUID from being reinitialized when running `loadvm` without
> > quitting first; I suppose this should be discussed with QEMU
> > upstream.)
> 
> That's not (necessarily) a bug; see the end of the above-linked QEMU
> document:
> 
> "There are no known use cases for changing the GUID once QEMU is
> running, and adding this capability would greatly increase the complexity."

IIRC this part of the QEMU doc was making an implicit assumption
about the way QEMU is to be used by mgmt apps doing snapshots.

Instead of using the 'loadvm' command on the existing running QEMU
process, the doc seems to tacitly expect the management app will
throwaway the existing QEMU process and spawn a brand new QEMU
process to load the snapshot into, thus getting the new GUID on
the QEMU command line. There are some downsides with doing this
as compared  to running 'loadvm' in the existing QEMU, most
notably the user's VNC/SPICE console session gets interrupted.
I guess the ease of impl for QEMU was more compelling though.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

