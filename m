Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BA44C9274
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiCASCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiCASCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:02:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C83FBF6;
        Tue,  1 Mar 2022 10:01:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63942613E2;
        Tue,  1 Mar 2022 18:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548CEC340EE;
        Tue,  1 Mar 2022 18:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646157679;
        bh=BlXx4FNNlsIl9zw8EoTTYqALDbRkuyGZS0mdHI4RoMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iEFkSTkWwXpMp7vsR4QZ/EJ3Oib4ZpUNZYzzsAzhylm2ksEYMVzN2682Dqakg9wuh
         5oD7D1L1KC35go81Ztkp8huNYQkMEDQlk348/XbQ5/vNFcVbnbq0T6c5zi6A5K0B/i
         F5W/Q68bc/YoS97YzoNhuopdow5scGqyEfK7IKq0=
Date:   Tue, 1 Mar 2022 19:01:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-hyperv@vger.kernel.org,
        linux-crypto@vger.kernel.org, graf@amazon.com,
        mikelley@microsoft.com, adrian@parity.io, lersek@redhat.com,
        berrange@redhat.com, linux@dominikbrodowski.net, jannh@google.com,
        mst@redhat.com, rafael@kernel.org, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org, colmmacc@amazon.com,
        tytso@mit.edu, arnd@arndb.de
Subject: Re: propagating vmgenid outward and upward
Message-ID: <Yh5fbe71BTT6xc8h@kroah.com>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh4+9+UpanJWAIyZ@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 04:42:47PM +0100, Jason A. Donenfeld wrote:
> The easy way, and the way that I think I prefer, would be to just have a
> sync notifier_block for this, just like we have with
> register_pm_notifier(). From my perspective, it'd be simplest to just
> piggy back on the already existing PM notifier with an extra event,
> PM_POST_VMFORK, which would join the existing set of 7, following
> PM_POST_RESTORE. I think that'd be coherent. However, if the PM people
> don't want to play ball, we could always come up with our own
> notifier_block. But I don't see the need. Plus, WireGuard *already*
> uses the PM notifier for clearing keys, so code-wise for my use case,
> that'd amount adding another case for PM_POST_VMFORK, in addition to the
> currently existing PM_HIBERNATION_PREPARE and PM_SUSPEND_PREPARE cases,
> which all would be treated the same way. Ezpz. So if that sounds like an
> interesting thing to the PM people, I think I'd like to propose a patch
> for that, possibly even for 5.18, given that it'd be very straight-
> forward.

A notifier block like this makes sense, but why tie onto the PM_ stuff?
This isn't power management issues, it's a system-wide change that I am
sure others will want to know about that doesn't reflect any power
changes.

As much as I hate adding new notifiers in the kernel, that might be all
you need here.

thanks,

greg k-h
