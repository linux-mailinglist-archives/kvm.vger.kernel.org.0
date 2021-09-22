Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BA4147B5
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 13:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhIVLVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 07:21:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235586AbhIVLV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 07:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632309598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mM5VXmI58akpcs3K7I7iFiF0Ov8PqxzFl08K4hexAMI=;
        b=eRQcT6CbrzuMqRPMSeMVPB539vH6E2KP0W9aPy5iCA6zRUJfxjZpAinPf3Hjvj+pvZGmuz
        HPhnYuUTC2moT5rUhVfSm98BFpmeGtuHgf1HDmqTiNxx5FSLMHKGIcvXvvL++B7jjEX3id
        taX8qpzbfE8a0BeOEygws9heF/r4ey0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-WFxaxzn4MzOXH2uh0OphIw-1; Wed, 22 Sep 2021 07:19:57 -0400
X-MC-Unique: WFxaxzn4MzOXH2uh0OphIw-1
Received: by mail-ed1-f69.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso2732979edx.2
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 04:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mM5VXmI58akpcs3K7I7iFiF0Ov8PqxzFl08K4hexAMI=;
        b=OtMZi9pgDHRyS2F5lD1tswDHYguBOD46hmXX/peSKdg6bhpaHBRpympyvD1uF70tJp
         mYR4hHlEyNZgjXpCcsrL7GwmiL+l20a32FTv/hOYg4HcwlnKHZeRu1KCFZNf8+n6JTq+
         8iaJvD/9f0LmsmSDJXkAj60A+udZ3XedgJ4LqhqRCKsFbsHQv+pWoeVoOPcwOxP1fjoW
         8SByLo1e6ywgXO3bP3hZQPTWdlc7KepXhm69O+G7H8UqeBSBE8p0SnQ9t/eAaXFT5WXZ
         O6+4yWSwIWHKZDOn6e1GYvzO6CG+ozkqkrNR4SdybO2H/SeOLXkSquUu86qHZON/zA0Y
         B4sw==
X-Gm-Message-State: AOAM531uoitq3e1Xfd/Thua14TRIFmd5V/qXQ/bFAkBVZ2GYsh/RCr20
        bhcSXoVSsh+gmXTAbUQMgImDSBC3PUSnJGvPsfkon/M3mwbbPmX+kU+dbj39NYrEsWwuZsNE4vR
        Lji2JpqnlqBtx
X-Received: by 2002:a05:6402:51d2:: with SMTP id r18mr41815545edd.108.1632309595907;
        Wed, 22 Sep 2021 04:19:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJDDT9/sA4pO1Xp2Sgz12Z3rLjflnS/C4nVxy1R6VLaR4Jo/8bxeTcnus3Xzg95TO+xhIOhg==
X-Received: by 2002:a05:6402:51d2:: with SMTP id r18mr41815525edd.108.1632309595692;
        Wed, 22 Sep 2021 04:19:55 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id q6sm897041eju.45.2021.09.22.04.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 04:19:54 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:19:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>, kvm <kvm@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Fix dirty bitmap offset calculation
Message-ID: <20210922111953.sc66aavyghobf2lf@gator.home>
References: <20210915213034.1613552-1-dmatlack@google.com>
 <20210915213034.1613552-4-dmatlack@google.com>
 <CANgfPd_WkrdXJ3qYmv_DKLbKDsNs8KJK4i9sX3+kR_cwNmbJ_w@mail.gmail.com>
 <20210916084922.x33twpy74auxojrk@gator.home>
 <11b4e1ba-e9cd-8bc7-4c5d-a7b79611c20f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11b4e1ba-e9cd-8bc7-4c5d-a7b79611c20f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:09:57PM +0200, Paolo Bonzini wrote:
> On 16/09/21 10:49, Andrew Jones wrote:
> > > I was a little confused initially because we're allocating only one
> > > dirty bitmap in userspace even when we have multiple slots, but that's
> > > not a problem.
> > It's also confusing to me. Wouldn't it be better to create a bitmap per
> > slot? I think the new constraint that host mem must be a multiple of 64
> > is unfortunate.
> 
> Yeah, I wouldn't mind if someone took a look at that.  Also because anyway
> this patch doesn't apply to master right now, I've queued 1-2 only.

David posted a v2 on Sept. 17 with the bitmap split up per slot for patch
3/3. I think the other patches got some tweaks too.

Thanks
drew

