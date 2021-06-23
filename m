Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5BC3B2029
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 20:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFWSWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 14:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhFWSWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 14:22:40 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30023C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:20:21 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x1so3660940qkp.7
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jl8pbJWalrLhIBlNXOVoQQE4IHG/JvIijc85CtgYeeo=;
        b=O9TJXI61AW9H2nQtUEnlSBFAPp1Dbm0DFWyvVQzfD/PJICtcInbflOVhVjNXaZC+/A
         P5oHFmIKwbl6pOHIftFzPCxPDeh1x/lKRVvMsGHK9UZml3jK2tnIowXHThpv5UVtE+Sm
         5cLMhWY0zpTFvHpTYfr1AbjnBxpwd81+C7RPncszrI4askcQTsqjuNBSpGs42/FuYOUR
         Zo1Jsaxs5PUHdvj03/RI59F2gWk6fh+bkxwXwGg+BUd0Fx0z6y8O2HdfuaUyv4OWvRWt
         P1LDggXBACdgJJyoF+/8c2wmxP4OmrriRa/T9WiPUOMz7uGWEHZKMmmYOJhGWbGV+5kQ
         mXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jl8pbJWalrLhIBlNXOVoQQE4IHG/JvIijc85CtgYeeo=;
        b=KzHx4/1odS4Uj+LvxUCuj3cCK3SA3+11FhEJWJLnJ2lgXcNp1GN4axiTd3TAJyR/Y/
         mCoKT1pL3K8PBc9QzoVQlGjtgLuXfinm5oSUrGZfz4OBHb41oDOeRP8aw00wkIEN6K35
         QKg/La+9NPqXh0bldlSj2U+yIWeTXT/JIdI+Z96iSk3EoK7GLTprEKa+tnJFYeSgjb/y
         akNm/HETdy9dIWPMynZuo+BzgrCkCM5jr45Wouc9Jr5PU0cv9IdBTBO/VfiJ4/bFo3s3
         9HUPDjcTuZX2v1Tyx99xCF8bfQ0s/SgXJY38mr352RnjS18DmUukkvxVlMFJW1dG85Ex
         TziA==
X-Gm-Message-State: AOAM531p38DCeMBNObtiGkTcW8QASFYD/F/BgjLDJ8vLI77gL0yNEypW
        d5P11GdY1vkGOR4VLSu6LlsKfg==
X-Google-Smtp-Source: ABdhPJxSsiUaYE217a9+roMj6tfYeEagEHiITUo/av6ByWOnU7jl//t+ROZ4QR4Wpb+FkcwkwjCMDw==
X-Received: by 2002:ae9:c219:: with SMTP id j25mr1367484qkg.313.1624472420239;
        Wed, 23 Jun 2021 11:20:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id x19sm474843qtp.58.2021.06.23.11.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 11:20:19 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lw7U3-00BlBX-5u; Wed, 23 Jun 2021 15:20:19 -0300
Date:   Wed, 23 Jun 2021 15:20:19 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     bhelgaas@google.com, alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        schnelle@linux.ibm.com, minchan@kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] vfio: use the new pci_dev_trylock() helper to
 simplify try lock
Message-ID: <20210623182019.GW1096940@ziepe.ca>
References: <20210623022824.308041-1-mcgrof@kernel.org>
 <20210623022824.308041-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623022824.308041-3-mcgrof@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 07:28:24PM -0700, Luis Chamberlain wrote:
> Use the new pci_dev_trylock() helper to simplify our locking.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/vfio/pci/vfio_pci.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
