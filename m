Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F96DBD881
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 08:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442353AbfIYGuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 02:50:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442340AbfIYGuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 02:50:19 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0384CC04BD33
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:50:19 +0000 (UTC)
Received: by mail-pl1-f197.google.com with SMTP id c14so2750775plo.12
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 23:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qR/cKb1LH4Ut6XBt6GUfg+wU8+q9TeAgUhlA6c+rO4c=;
        b=EGBduAWVSY6aPqyZSQO4v48ZtfHP4kvmIQ0rjSP3rQcjV8URcysHvXUcI5Mwr3pwgM
         wtfIwNrfyzvEWJRHFKse+QhbjQYdnoTgs4hI3Ue6HJF4A01qXFcboqw8jrJZXB5StigI
         4QMqXcSwQ2A2MB2I0U5KV2zkUaavCGuXTrsuIVCeF+DwM2UQmao3Tji9zPnDWf2uW45M
         MFoRsmxCKBMFm8fCVK+tH1L4kiZoslOoFCkSLUP45aqYWREAQqoNjfx43mShxSIXnujY
         2F7eNAdUOgiAR0yB46j3dSyD19YZz/bKlGFG/dtHFDP/zNRNH3dmPmSTyPgUJjhUEVBZ
         50xg==
X-Gm-Message-State: APjAAAXJDx3w7umfzSM7rXK1xrm5vpkG63RBBsWlRIATj8tz3uev59p5
        BOqHNQX1aRn50dKcJU8diRbRlkksMXTsGBkimibf0hVzyvR1DrBQ4rMCktpOlUPKf+8gU/xq96Z
        uFBfWg8U4+ybz
X-Received: by 2002:a17:90a:32c8:: with SMTP id l66mr4786666pjb.44.1569394218438;
        Tue, 24 Sep 2019 23:50:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqypWllblpMbhsSgwCAwLu+m/4ke343KRyPgiqd/aaN/IjsSQuc6mo4RWHK4cbHfclvFvQlQKQ==
X-Received: by 2002:a17:90a:32c8:: with SMTP id l66mr4786640pjb.44.1569394218177;
        Tue, 24 Sep 2019 23:50:18 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u1sm3296193pgi.28.2019.09.24.23.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 23:50:17 -0700 (PDT)
Date:   Wed, 25 Sep 2019 14:50:06 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 4/4] iommu/vt-d: Identify domains using first level
 page table
Message-ID: <20190925065006.GN28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190923122454.9888-5-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 08:24:54PM +0800, Lu Baolu wrote:
> +/*
> + * Check and return whether first level is used by default for
> + * DMA translation.
> + */
> +static bool first_level_by_default(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +
> +	rcu_read_lock();
> +	for_each_active_iommu(iommu, drhd)
> +		if (!sm_supported(iommu) ||
> +		    !ecap_flts(iommu->ecap) ||
> +		    !cap_caching_mode(iommu->cap))
> +			return false;
> +	rcu_read_unlock();
> +
> +	return true;
> +}

"If no caching mode, then we will not use 1st level."

Hmm, does the vIOMMU needs to support caching-mode if with the
solution you proposed here?  Caching mode is only necessary for
shadowing AFAICT, and after all you're going to use full-nested,
then... then I would think it's not needed.  And if so, with this
patch 1st level will be disabled. Sounds like a paradox...

I'm thinking what would be the big picture for this to work now: For
the vIOMMU, instead of exposing the caching-mode, I'm thinking maybe
we should expose it with ecap.FLTS=1 while we can keep ecap.SLTS=0
then it's natural that we can only use 1st level translation in the
guest for all the domains (and I assume such an ecap value should
never happen on real hardware, am I right?).

Regards,

-- 
Peter Xu
