Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5BC40AD
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 21:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfJATIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 15:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfJATIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 15:08:39 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E158C0546FB
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 19:08:39 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id x62so15628192qkb.7
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 12:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tyDOxDob+igviijoSMOJYC51FLEyIymiVWHSujSRqsg=;
        b=XLeOu5UfwtJZr2oFG1G/Pg592rFO+/tkkZ4iPuY39MEDVD2sUralgDHaQ4dTALqlHq
         2m3tqZwDtSZItjkBIBjssZtwlzajoNGtszdsXXbj5SYypA60B1XOcSMljuygXZO4/Y97
         6trJjRa6Dw2rRGGQ9INoYI3MuWPqWQlusniKnw+nyuXSzrupH+yIrhfJ4isCV6Mrh24W
         iaJBp8mQwRkxQYqiE29UjibHMdUOj5Y4m2DZ5SZbBMpuWB7Ldq8bf1JcsdJdDGXmBTS7
         1dDPlH2BmmWvaG+LwCgGnLyt2HUGeBtZ+hxTSsoQez3ROjQixsA2eTeII85CLk6dPKYV
         tAMw==
X-Gm-Message-State: APjAAAUD00OoyT1R0E0BHKRwr5uJV2uQsEamhNHdYNMhPrd+d4OCoBA4
        E0fJ1a4xI20g7YUWN4f+lN4UKCZc96ksblvMGDLj6vQbL+SRE+Z7u/ua7WYSviylxI+f8gF6AWr
        rxHEFfIMbmj85
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr7940564qkb.410.1569956918112;
        Tue, 01 Oct 2019 12:08:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxqlzM9Ty0JvR982/ZKv1347lkHYUf56yBEMeBfEE56A9YdRL50Yn8F7mKtdi+zcUYu2r/EBA==
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr7940534qkb.410.1569956917887;
        Tue, 01 Oct 2019 12:08:37 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id n42sm10811959qta.31.2019.10.01.12.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:08:36 -0700 (PDT)
Date:   Tue, 1 Oct 2019 15:08:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz, osalvador@suse.de, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, konrad.wilk@oracle.com, nitesh@redhat.com,
        riel@surriel.com, lcapitulino@redhat.com, wei.w.wang@intel.com,
        aarcange@redhat.com, pbonzini@redhat.com, dan.j.williams@intel.com
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
Message-ID: <20191001144331-mutt-send-email-mst@kernel.org>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
 <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 01, 2019 at 09:21:46AM -0700, Alexander Duyck wrote:
> I thought what Michal was asking for was what was the benefit of using the
> boundary pointer. I added a bit up above and to the description for patch
> 3 as on a 32G VM it adds up to about a 18% difference without factoring in
> the page faulting and zeroing logic that occurs when we actually do the
> madvise.

Something maybe worth adding to the log:

one disadvantage of the tight integration with the mm core is
that only a single reporting device is supported.
It's not obvious that more than one is useful though.

-- 
MST
