Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A476420DC
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 01:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiLEAwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 19:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiLEAwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 19:52:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBACA11804
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 16:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670201508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jyOn0zCqUHzr00gkE+WrihCChip5DaN83C5WKz94T9o=;
        b=ZGfeHdpOHPKjJPAfo8szy/nlbyg+2gP++WhfwHuzoYqkxfPOPxX/p6L12d3RgIbffFU7Mk
        gGZxN1xwWOFvVROzdhzODyfDaPi+Vf2Xko/X4CfO3mFYoYDxnjoBggpHQ9MXGlS41NCd7K
        vJzy50xE5MWj0Q5rhf0VMrHlXAAhICw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-KwzGavzUPIWulOTciLhQFQ-1; Sun, 04 Dec 2022 19:51:47 -0500
X-MC-Unique: KwzGavzUPIWulOTciLhQFQ-1
Received: by mail-il1-f197.google.com with SMTP id w9-20020a056e021c8900b0030247910269so10790202ill.4
        for <kvm@vger.kernel.org>; Sun, 04 Dec 2022 16:51:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jyOn0zCqUHzr00gkE+WrihCChip5DaN83C5WKz94T9o=;
        b=gDvDDvezWKOb6/zCK1nGoh/StNtUYwLrfT0gPQVJgIPp4eoBskByHwXwNqq5FrH1u+
         xvX06v08lrkCKZ/vdjjZGDtfhmjvxlPTsKDcaRWiP75L2BjSf/yswYQJ1epoXkIee6fi
         o8/o45NGqsVOsnwukXTNGUSX3urMK0Sga+PyMSE2YX1f9NFMQIG84VQG2U5s42IIMvdx
         2TjxHx6AY6rIhAqnyb5RXmIFngsrwF2i91/vo1t5xZl2H9sHYEoFV85lomYBsd38CgM0
         +rNrS/C8bnsLOPd09PbO3DxedkGBe8G5PgCSFH1YAub4NAXA8M4own2j/X8rs7EqXUuX
         Q4ig==
X-Gm-Message-State: ANoB5pkhDmKr+6hn+Dr68yOFBArjBHQY0j2OI1GsOBfLVpIeJHbyvYlV
        4pESk8NC0lHMRamXSnwwydEA8SUTbk0pXNj5a0bVdezVHsOQBqa2Kx6GVKLqh1KH1AHlzj3DVtg
        7v7HMCOiheo/t
X-Received: by 2002:a05:6602:2143:b0:6bc:6352:9853 with SMTP id y3-20020a056602214300b006bc63529853mr35427219ioy.65.1670201505084;
        Sun, 04 Dec 2022 16:51:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6qBOm8mQO/x/Lw1rl0Iy6Xk4eFLp0sKfVqFatl9b10bhQP9TrpcKRN/3msQCFGy6Z8h84OCA==
X-Received: by 2002:a05:6602:2143:b0:6bc:6352:9853 with SMTP id y3-20020a056602214300b006bc63529853mr35427215ioy.65.1670201504802;
        Sun, 04 Dec 2022 16:51:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h20-20020a056e020d5400b0030287ff00fesm4715510ilj.60.2022.12.04.16.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 16:51:44 -0800 (PST)
Date:   Sun, 4 Dec 2022 17:51:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "mb@lab.how" <mb@lab.how>
Cc:     airlied@linux.ie, dri-devel@lists.freedesktop.org,
        kraxel@redhat.com, kvm@vger.kernel.org, lersek@redhat.com,
        linux-kernel@vger.kernel.org, tzimmermann@suse.de
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
Message-ID: <20221204175142.658d5c37.alex.williamson@redhat.com>
In-Reply-To: <CAEdEoBYXHq9cCzsbMYTpG1B41Yz=-QAjFx7bJDOnPanN5Tmo7A@mail.gmail.com>
References: <CAEdEoBYXHq9cCzsbMYTpG1B41Yz=-QAjFx7bJDOnPanN5Tmo7A@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 3 Dec 2022 17:12:38 -0700
"mb@lab.how" <mb@lab.how> wrote:

> Hi,
> 
> I hope it is ok to reply to this old thread.

It is, but the only relic of the thread is the subject.  For reference,
the latest version of this posted is here:

https://lore.kernel.org/all/20220622140134.12763-4-tzimmermann@suse.de/

Which is committed as:

d17378062079 ("vfio/pci: Remove console drivers")

> Unfortunately, I found a
> problem only now after upgrading to 6.0.
> 
> My setup has multiple GPUs (2), and I depend on EFIFB to have a working console.
> pre-patch behavior, when I bind the vfio-pci to my secondary GPU both
> the passthrough and the EFIFB keep working fine.
> post-patch behavior, when I bind the vfio-pci to the secondary GPU,
> the EFIFB disappears from the system, binding the console to the
> "dummy console".
> Whenever you try to access the terminal, you have the screen stuck in
> whatever was the last buffer content, which gives the impression of
> "freezing," but I can still type.
> Everything else works, including the passthrough.

This sounds like the call to aperture_remove_conflicting_pci_devices()
is removing the conflicting driver itself rather than removing the
device from the driver.  Is it not possible to unbind the GPU from
efifb before binding the GPU to vfio-pci to effectively nullify the
added call?
 
> I can only think about a few options:
> 
> - Is there a way to have EFIFB show up again? After all it looks like
> the kernel has just abandoned it, but the buffer is still there. I
> can't find a single message about the secondary card and EFIFB in
> dmesg, but there's a message for the primary card and EFIFB.
> - Can we have a boolean controlling the behavior of vfio-pci
> altogether or at least controlling the behavior of vfio-pci for that
> specific ID? I know there's already some option for vfio-pci and VGA
> cards, would it be appropriate to attach this behavior to that option?

I suppose we could have an opt-out module option on vfio-pci to skip
the above call, but clearly it would be better if things worked by
default.  We cannot make full use of GPUs with vfio-pci if they're
still in use by host console drivers.  The intention was certainly to
unbind the device from any low level drivers rather than disable use of
a console driver entirely.  DRM/GPU folks, is that possibly an
interface we could implement?  Thanks,

Alex

