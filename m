Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E89BD7BD
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411749AbfIYFYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26319 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411744AbfIYFYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:24:15 -0400
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1177989AC0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:24:15 +0000 (UTC)
Received: by mail-pg1-f197.google.com with SMTP id r25so2844929pgu.11
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 22:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/HNMfngrL2dVAv5oEf18q1bL4tnGnZHoARTtclw/zOQ=;
        b=pTrevaA/u376UAzxJds+O4KRlv28wtarFZMtO+w4KzJqYqGaiZw6vMxSWF8FW7PF7K
         sjg6vpJqXt0XjsC69hFqHKIdYvf6WZOOBVEKpMNyqlpEsP9sskzO0t19g1PsWlZboxmK
         yKpicFRh3gz/HkHiUzahKeGc1zOs/TDvwC5bO7gmqdGKrvpiE7OO3RAhmMRw/T9VvnNk
         uQZDJ2dkvXHkzsZEh+Q6n7t0sisvO8sBbxlzFoh4jdlWc6ZupZXMRnu6BhschLcfnrYg
         24s64kr1tlwuEj9mAIZfIqQmSs5i2oMML0oD9Tcez/2z+pykWdAyIqoaJDO8+bAqG73B
         n/Cw==
X-Gm-Message-State: APjAAAWfgYOjvsDZTCSx95u/Xra/ghliq3S5d0sWExZYXKaHHArZ5G0t
        S7uX8xUzCVc6oOQWMXmQnTmR7QlLvvZkKOqz513qJmJy5L31phZV9Ley2Y3vYLHmp2EoBPvFviB
        EDH5p5RzQMp2O
X-Received: by 2002:a62:5e42:: with SMTP id s63mr6745435pfb.96.1569389054615;
        Tue, 24 Sep 2019 22:24:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxwAC3wXoJ2PHgPRN3g8rZaANg2eV6wPnk6cDT4cSKrtUcaQ5efDKrefQ8BuOVG39h90nRsFQ==
X-Received: by 2002:a62:5e42:: with SMTP id s63mr6745421pfb.96.1569389054455;
        Tue, 24 Sep 2019 22:24:14 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d76sm9015810pga.80.2019.09.24.22.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 22:24:13 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:24:02 +0800
From:   Peter Xu <peterx@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190925052402.GM28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
 <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
 <20190925043050.GK28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F018@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F018@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 04:38:31AM +0000, Tian, Kevin wrote:
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Wednesday, September 25, 2019 12:31 PM
> > 
> > On Tue, Sep 24, 2019 at 09:38:53AM +0800, Lu Baolu wrote:
> > > > > intel_mmmap_range(domain, addr, end, phys_addr, prot)
> > > >
> > > > Maybe think of a different name..? mmmap seems a bit weird :-)
> > >
> > > Yes. I don't like it either. I've thought about it and haven't
> > > figured out a satisfied one. Do you have any suggestions?
> > 
> > How about at least split the word using "_"?  Like "mm_map", then
> > apply it to all the "mmm*" prefixes.  Otherwise it'll be easily
> > misread as mmap() which is totally irrelevant to this...
> > 
> 
> what is the point of keeping 'mm' here? replace it with 'iommu'?

I'm not sure of what Baolu thought, but to me "mm" makes sense itself
to identify this from real IOMMU page tables (because IIUC these will
be MMU page tables).  We can come up with better names, but IMHO
"iommu" can be a bit misleading to let people refer to the 2nd level
page table.

Regards,

-- 
Peter Xu
