Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1C4C47BD
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241133AbiBYOhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiBYOhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:37:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA32A66D7;
        Fri, 25 Feb 2022 06:37:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B93EB831FA;
        Fri, 25 Feb 2022 14:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C059FC340F0;
        Fri, 25 Feb 2022 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645799817;
        bh=txqJvZ34d7BrZO7RHw7rO9yWJUsvqMki1kDp9v2h9SU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iiVujjQ+GKRu9o3Io6hV9VsR0n61Yyt+SAmGtX8wulItYIIZncpvOK8biXCD5PgcB
         PzOkze+vVDjUdVaQnIkflDCRdyk/ofuobsv4uRmMT8yStgeM5CM4HUfagNAo7e+C1I
         IcZCkROjHF/JTBbFT68rwgzOwBRKp2NfsKRiajzU=
Date:   Fri, 25 Feb 2022 15:36:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Graf <graf@amazon.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, adrian@parity.io, ardb@kernel.org,
        ben@skyportsystems.com, berrange@redhat.com, colmmacc@amazon.com,
        decui@microsoft.com, dwmw@amazon.co.uk, ebiggers@kernel.org,
        ehabkost@redhat.com, haiyangz@microsoft.com, imammedo@redhat.com,
        jannh@google.com, kys@microsoft.com, lersek@redhat.com,
        linux@dominikbrodowski.net, mst@redhat.com, qemu-devel@nongnu.org,
        raduweis@amazon.com, sthemmin@microsoft.com, tytso@mit.edu,
        wei.liu@kernel.org
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <YhjphtYyXoYZ9lXY@kroah.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 02:57:38PM +0100, Alexander Graf wrote:
> > +
> > +       phys_addr = (obj->package.elements[0].integer.value << 0) |
> > +                   (obj->package.elements[1].integer.value << 32);
> > +       state->next_id = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE, MEMREMAP_WB);
> > +       if (!state->next_id) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
> > +
> > +       memcpy(state->this_id, state->next_id, sizeof(state->this_id));
> > +       add_device_randomness(state->this_id, sizeof(state->this_id));
> 
> 
> Please expose the vmgenid via /sysfs so that user space even remotely has a
> chance to check if it's been cloned.

Export it how?  And why, who would care?

thanks,

greg k-h
