Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC264AB98
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 00:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiLLXfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 18:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiLLXfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 18:35:43 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EE1A06D
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:35:42 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id h10so9289224qvq.7
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iLTijJVtdW1q5zD3A9979ILEhVmXcyfAbNI+lfP2gAw=;
        b=Of+7Sagc+X3UcrLZKhIX5m4NBWhIVVmn/45YJcOBbVCuSM8XlX9MPWiAh/zV2DEYlC
         HoZldMo60q/vviuCU8Sfhe1Me6H2pzs9b/qa4lFFmQu59wNCe1a7MofxDHCfw2eEsRwe
         aUXMijw48SWXcJ5YKqrbB69o/ThUDbZQOKCt/04M4Zu62Fvl7KkbkqDBP9beTZd3lDXP
         5GJWPYc0beZxiNmr5o6Di48vkG4ddezImAOORbtyAthcpGj/cNs/5VyEfiwmVvYLphy+
         Z3Lvw3LjoUeQbAxpucSQXSK9atxEqO+WP+N6n2Ttbm0XrntNP1ZfeOSDV8VoEFapBv0c
         iq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLTijJVtdW1q5zD3A9979ILEhVmXcyfAbNI+lfP2gAw=;
        b=LTWAy1j411cADNK3A8VxeIKf8mrNVdpabXjql9XzW/qRw4d1jI0bmUuSaQQ5LmUpFx
         /7nOzqwR8fDcp33860fUUrGt8KC2LXHzDqtt/9ICYzTQJeYzihxvzU658HH233f0H+0l
         4wuSH7GWZhEsiR0mOoPN9VPaTX5aX9GtyvqcpNk24/hnrhBTtqrxi5DVAgQ7j0j11glV
         ahVEgo73r6/1/Tn1S1FItOopUnaQFcKm+izqC9TgCLG1/TnSUunvPDp+vGXwHQaEdxKe
         7fA3GkoNhggPhYq4sDo9q5Yih3hFR6EiJqzAIJYshdVpeFgpNBb+zldj39FzOEIf/Nkf
         oAhw==
X-Gm-Message-State: ANoB5pnwxiwqG4u5OeS9wbHOab5XPTMatM5pbuw3OHNHQ3AkzTszgwge
        8wzYkCwX1cu8muU+ujrsMdfuD6RdUHuXY13J
X-Google-Smtp-Source: AA0mqf4GNi6MjXFhA+2NfbfZq4rSQN+dsBQuVCXkD2QMFyR+SEigQSGOiOTBZ4fx6YxGdBt7ZFcMFA==
X-Received: by 2002:a05:6214:881:b0:4c6:5acc:1e22 with SMTP id cz1-20020a056214088100b004c65acc1e22mr26992311qvb.5.1670888142054;
        Mon, 12 Dec 2022 15:35:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id x8-20020a05620a258800b006fef157c8aesm6839235qko.36.2022.12.12.15.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 15:35:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p4sKi-008zVY-Ml;
        Mon, 12 Dec 2022 19:35:40 -0400
Date:   Mon, 12 Dec 2022 19:35:40 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Steven Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <Y5e6zB3tW2D/ULlQ@ziepe.ca>
References: <20221209124212.672b7a9c.alex.williamson@redhat.com>
 <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
 <20221209140120.667cb658.alex.williamson@redhat.com>
 <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
 <Y5cqAk1/6ayzmTjg@ziepe.ca>
 <20221212085823.5d760656.alex.williamson@redhat.com>
 <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
 <20221212142651.263dd6ae.alex.williamson@redhat.com>
 <Y5e0icoO89Qnlc/z@ziepe.ca>
 <20221212162948.4c7a4586.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212162948.4c7a4586.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 04:29:48PM -0700, Alex Williamson wrote:
> On Mon, 12 Dec 2022 19:08:57 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Mon, Dec 12, 2022 at 02:26:51PM -0700, Alex Williamson wrote:
> > > On Mon, 12 Dec 2022 15:59:11 -0500
> > > Steven Sistare <steven.sistare@oracle.com> wrote:
> > >   
> > > > On 12/12/2022 10:58 AM, Alex Williamson wrote:  
> > > > > On Mon, 12 Dec 2022 09:17:54 -0400
> > > > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > >     
> > > > >> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> > > > >>    
> > > > >>> Thank you for your thoughtful response.  Rather than debate the degree of
> > > > >>> of vulnerability, I propose an alternate solution.  The technical crux of
> > > > >>> the matter is support for mediated devices.        
> > > > >>
> > > > >> I'm not sure I'm convinced about that. It is easy to make problematic
> > > > >> situations with mdevs, but that doesn't mean other cases don't exist
> > > > >> too eg what happens if userspace suspends and then immediately does
> > > > >> something to trigger a domain attachment? Doesn't it still deadlock
> > > > >> the kernel?    
> > > > > 
> > > > > The opportunity for that to deadlock isn't obvious to me, a replay
> > > > > would be stalled waiting for invalid vaddrs, but this is essentially
> > > > > the user deadlocking themselves.  There's also code there to handle the
> > > > > process getting killed while waiting, making it interruptible.  Thanks,    
> > > > 
> > > > I will submit new patches tomorrow to exclude mdevs.  Almost done.  
> > > 
> > > I've dropped the removal commits from my next branch in the interim.  
> > 
> > Woah, please don't do that - I already built and sent pull requests
> > assuming this, there are conflicts.
> 
> I've done merges both ways with your iommufd pull request and don't see
> any conflicts relative to these changes.  Kconfig, Makefile, and
> vfio_main.c related to virq integration and group extraction are the
> only conflicts. 

I got an extra hunk in the header file

> Besides, it's already pushed and I don't have any references to the
> old head, so someone would need to provide it if we wanted to keep
> the old hashes.

https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/tag/?h=for-linus-iommufd-merged
https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-linus-iommufd-merged&id=e9a1f0f32d86c05f01878a0448384a46a453abc7

> > Why would we not revert everything from 6.2 - that is what we agreed
> > to do?
> 
> The decision to revert was based on the current interface being buggy,
> abandoned, and re-implemented.  It doesn't seem that there's much future
> for the current interface, but Steve has stepped up to restrict the
> current implementation to non-mdev devices, which resolves your concern
> regarding unlimited user blocking of kernel threads afaict, and we'll
> see what he does with locked memory.  

Except nobody has seen this yet, and it can't go into 6.2 at this
point (see Linus's rather harsh remarks on late work for v6.2)

So we are punting on this for another kernel cycle. I don't like any
of this.

Regardless of what happens I need this all settled and the vfio tree
unchanging by Thursday to finalize the above tag..

Jason
