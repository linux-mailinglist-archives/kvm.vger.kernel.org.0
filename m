Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB86E5A3A0A
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 23:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiH0VEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiH0VEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 17:04:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48C431EE1
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 14:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661634236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=phlet88rE7v9Yl8bfxsef5NsBJeVJy0zpd8p03PWOJ4=;
        b=K46VFai3/Sz59FFBzHohSRlAI7b2Y5dwed84eNZBU3eTLRnF2EYgx3VQUa1l/nY2css5Gs
        kjp1cHMRbsL5J0ZxxSbpzMw/DnJQag0Dn7C7VhW4dN9qDJIiHvt9ffh7SiPR8HU1d1go9/
        cVfm87/y4Fx2LoKiNDuxjcYYyh0iVCQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-286-KqG3ryDkMiWTLWGeTW_GCA-1; Sat, 27 Aug 2022 17:03:51 -0400
X-MC-Unique: KqG3ryDkMiWTLWGeTW_GCA-1
Received: by mail-qv1-f69.google.com with SMTP id u4-20020a0c8dc4000000b00498f6359b6dso990295qvb.17
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 14:03:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=phlet88rE7v9Yl8bfxsef5NsBJeVJy0zpd8p03PWOJ4=;
        b=OSvhaNTkEVbFyAhmX+ujDlow0wDgHVEC+08udW14Ffya9c1lEA+xvWzqxidBfpgTXj
         xkJ95S3YPCTsxvIR4NMxYQf0aQLhYiYMswP/5+8IRaqoi6lTZ//4DM8V7Fi3R3hj3/Id
         Y9EpvEkhY3UJjaZWD3iNvz5h85EUDSrtOZI8hE9PvyLo3Dkc0qjKrjYqcqFf4qktL+Um
         /0fpZ5AnZsBOcwnzQXaAPIy/QnfhXmONvkM1bjOHLNmj8T+hkd3iA/7J7yaVWJ8cGM6I
         VpjQkfKfkQjY6zqHLkQfkcNE46fkk1LoGzJqBc6KY/PRDeXwV0tNt0e/l54nFIv2YWI2
         N0wg==
X-Gm-Message-State: ACgBeo1cymo5hLHP9ayzSVKc0zvITk9SigcnvQKsA6eLewC0kB5Bozwm
        ISyTgpGMGa36CAy1Jr+P4GJgUpOqkflu+KShadr4u97bMdRksd3Dv6SC+SSsxztWOcQgXncdrp8
        /sHlG50kEHX9H
X-Received: by 2002:ac8:5948:0:b0:342:f500:2eb7 with SMTP id 8-20020ac85948000000b00342f5002eb7mr4689055qtz.483.1661634231163;
        Sat, 27 Aug 2022 14:03:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR44WovWocUMSnz9f1IIt6Wrr6vrHyW7DAE1Xhpept1waMtiMhZRfomV9SQ2N5vl/8g5NQ8H1g==
X-Received: by 2002:ac8:5948:0:b0:342:f500:2eb7 with SMTP id 8-20020ac85948000000b00342f5002eb7mr4689040qtz.483.1661634230961;
        Sat, 27 Aug 2022 14:03:50 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id d137-20020a37688f000000b006bba46e5eeasm2447691qkc.37.2022.08.27.14.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 14:03:49 -0700 (PDT)
Date:   Sat, 27 Aug 2022 17:03:48 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] softmmu/memory: add missing begin/commit
 callback calls
Message-ID: <YwqGtHrcsFrgzLzg@xz-m1.local>
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-2-eesposit@redhat.com>
 <Yv6UVMMX/hHFkGoM@xz-m1.local>
 <e5935ba7-dd60-b914-3b1d-fff4f8c01da3@redhat.com>
 <YwjVG+MR8ORLngjd@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwjVG+MR8ORLngjd@xz-m1.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 10:13:47AM -0400, Peter Xu wrote:
> On Fri, Aug 26, 2022 at 03:53:09PM +0200, Emanuele Giuseppe Esposito wrote:
> > What do you mean "will empty all regions with those listeners"?
> > But yes theoretically vhost-vdpa and physmem have commit callbacks that
> > are independent from whether region_add or other callbacks have been called.
> > For kvm and probably vhost it would be no problem, since there won't be
> > any list to iterate on.
> 
> Right, begin()/commit() is for address space update, so it should be fine
> to have nothing to commit, sorry.

Hold on..

When I was replying to your patch 2 and reading the code around, I fount
that this patch does affect vhost..  see region_nop() hook and also vhost's
version of vhost_region_addnop().  I think vhost will sync its memory
layout for each of the commit(), and any newly created AS could emptify
vhost memory list even if registered on address_space_memory.

The other thing is address_space_update_topology() seems to be only used by
address_space_init().  It means I don't think there should have any
listener registered to this AS anyway.. :) So iiuc this patch (even if
converting to loop over per-as memory listeners) is not needed.

-- 
Peter Xu

