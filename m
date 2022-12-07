Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C78A645D91
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLGPXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGPXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:23:54 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3080EE19
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:23:53 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id c2so10215707qko.1
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6BjtQDIErWZSlLV6C6Y1bdjQhfHwiai6Crt/CAhz88I=;
        b=dFUDX8NlTBTV7Aj1ebd3+NvcpRfGg1VRb17hPDdBt0uwloWqH/Ore6WMl78z4/dPUW
         epsnfWv+iKVXWcUcpwbZCWlqUIql94Duh5OWIzsNjWMKV0LJVs7Nk/UmbMklJPRg0Leb
         OdCzJF9qliMKSwl07s3tkuQCrOdNpZi5cUjVAXVkbI97lSmY298Z5XxTzDS+WLRdgil5
         3aahQdJeXnOybAZARucXGsCz6KUxmKpH3oABwta5MbAQZVbmrmiB1It635kDsNiSHyYM
         ngizYQqGdfJxLKrzBuZ2E9wB3VTyi5SCI8RafU3A+oVjLUEJvtRGYPsit5umzd/g97jn
         5Cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BjtQDIErWZSlLV6C6Y1bdjQhfHwiai6Crt/CAhz88I=;
        b=Jyl1Cd2QYS4/t4g9R4hIJ7ZP6xaYsMjKnbuhLh2HZi2/UMmb6NTTJnaFgnvf8F1AtT
         6P6T1kBz6PTm32kMtrVA45oYCXSgTmh+OBExUX3VkZtmTQsso8ZEoC9pqNQe607j1PWv
         rvuz7V83sCP/7B0IXHzy2pSJn9mBVIApBdX1czTuN07dmP6ddcAq2pi8jJqtTjflhA3G
         1v5zcde4tABd+HWnh/H28GwK3RILq/SeRQk1dLTU+CQFGLYrsP5jpefNHAmdbfIuL/Rp
         3u4PeMlRlKWi7p7jmQ2gBJHTcS1ECZiTkYlkDFrITHL9ufU90rF0fP8ReDDLW7u48aIT
         57pQ==
X-Gm-Message-State: ANoB5pkyFe5KeUaS8aiWQ328frqcvD2P6wX3rutraZYWjWOdZbmdgq7i
        G0CtdCrRq7H/Bi6/FJ5MeyyLkQ==
X-Google-Smtp-Source: AA0mqf6KSOHP3pYWXDN3TlkYZY5f/Xuq8kwq81Xk+4qZbk+priPaJMxMSRilx3uZZ6xa2nR4SFyILg==
X-Received: by 2002:a37:bcb:0:b0:6fe:c433:2ece with SMTP id 194-20020a370bcb000000b006fec4332ecemr9132537qkl.367.1670426632813;
        Wed, 07 Dec 2022 07:23:52 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a258a00b006fc92cf4703sm17139377qko.132.2022.12.07.07.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:23:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2wH1-005EZI-JJ;
        Wed, 07 Dec 2022 11:23:51 -0400
Date:   Wed, 7 Dec 2022 11:23:51 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 0/8] vfio virtual address update redo
Message-ID: <Y5CwB9J7K8pemFFK@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:55:45PM -0800, Steve Sistare wrote:

> Lastly, if a task exits or execs, and it still owns any dma mappings, they
> are unmapped and unpinned.  This guarantees that pages do not remain pinned
> indefinitely if a vfio descriptor is leaked to another process, and requires
> tasks to explicitly transfer ownership of dma (and hence locked_vm) to a new
> task and mm when continued operation is desired.  The vfio driver maps a
> special vma so it can detect exit and exec, via the vm_operations_struct
> close callback.

I don't think any of this is necessary. If a VFIO FD is "leaked" to
another process there are many hostile things that process can do
beyond invoke this new ioctl. Considering the complexity I prefer to
drop this.

Jason
