Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8861A310C35
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 14:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhBENwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 08:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhBENuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 08:50:10 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB1BC0617AA
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 05:49:29 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id n15so6846890qkh.8
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 05:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ClyUAOZa7OFCglp1bjgNnlXnosYgcrxy4Bo5DWX5whw=;
        b=FOINqIGCcM6JC0NsYY3CkXaBU8OT/mQFC438dCVwpji4LrPutJxYQeJ7dTf+VxP+u3
         zInvInYh4EnxysFRQPofCeynn87IIMYWshQArmOWHQVoho53rCFN8ZNfUIeEupDBX+PD
         pgDEPCsXI96sUaCb5FMllexsveMKMs7AqZTr11a4OIP70iyu6so8/OTmMbtio430oAvG
         tSFKvPfhAParBvpOoMO6PT7wC9iJ2g5mw1TTV0/WT3fo8g2DLlqvBo0Cae7ra6/RaWI1
         7J8MMdZ6ubw/VUkzXWw2Mx0E6GC1AYgATNJyIANBUnP1MSd3GOaVgE/ukYuk8ken0dhF
         nrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ClyUAOZa7OFCglp1bjgNnlXnosYgcrxy4Bo5DWX5whw=;
        b=tHkmf9CnN4ZQe6/Pccv5g4qWBRxPnaHnNlS4DIk2E9VKF75P8G3ILioxfB10qLmBqp
         sWfWAXiO1Q3bLubNPAe7TJTkXnm+FArkXy0epx0R89Wda4BJ+N+tdrf2DjF+iy/is+NF
         EE8V7EWa+6HWHtugkIPl549MRZ760XNMq5HeKh9D9nAxnX7O36nBCNW0T8lH30ZWX3gd
         8b4x3nl/iWxZAv1lODnsp7KVbtME29v6DJC9Ity4nWztl6sZdGaE7iKaVGoNuT0gv+wd
         YEUzdMnMR51b9tiOn9U/iYNZoAeVznTn9n2O6hcZs607WBenq0/Ja1hZ7JIRJM9U7IK6
         Hj3g==
X-Gm-Message-State: AOAM5307h/g3GKcqzY3XG2aUjX9uEXRFkRI+NaLX4KWOzaP3iyOZSZ5f
        oVJp3KUrqmN/9nxPF+z1BLq0AA==
X-Google-Smtp-Source: ABdhPJyedZWbZ/VF4fBY6l7VFipJ5IDXzjqxEPVTrm3E52U13xSe3YTO2VmNXl+IpGlsoUFUyN3YCA==
X-Received: by 2002:a37:a50e:: with SMTP id o14mr4388187qke.250.1612532968204;
        Fri, 05 Feb 2021 05:49:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id c5sm9349747qkg.99.2021.02.05.05.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 05:49:27 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l81UF-003qUb-5e; Fri, 05 Feb 2021 09:49:27 -0400
Date:   Fri, 5 Feb 2021 09:49:27 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com
Subject: Re: [PATCH 1/2] mm: provide a sane PTE walking API for modules
Message-ID: <20210205134927.GL4718@ziepe.ca>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205103259.42866-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205103259.42866-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 05:32:58AM -0500, Paolo Bonzini wrote:
> Currently, the follow_pfn function is exported for modules but
> follow_pte is not.  However, follow_pfn is very easy to misuse,
> because it does not provide protections (so most of its callers
> assume the page is writable!) and because it returns after having
> already unlocked the page table lock.
> 
> Provide instead a simplified version of follow_pte that does
> not have the pmdpp and range arguments.  The older version
> survives as follow_invalidate_pte() for use by fs/dax.c.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/s390/pci/pci_mmio.c |  2 +-
>  fs/dax.c                 |  5 +++--
>  include/linux/mm.h       |  6 ++++--
>  mm/memory.c              | 35 ++++++++++++++++++++++++++++++-----
>  4 files changed, 38 insertions(+), 10 deletions(-)

Looks good to me, thanks

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
