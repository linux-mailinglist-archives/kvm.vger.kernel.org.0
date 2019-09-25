Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057C3BD94B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437689AbfIYHpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395110AbfIYHpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:45:20 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82FBFC0578F8
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 07:45:20 +0000 (UTC)
Received: by mail-pl1-f197.google.com with SMTP id y2so2828428plk.19
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 00:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lGlfVebe14dEyAwlNX/fOfUXOsimPZPypK8xTf2N4Zk=;
        b=Z7ufyLpu9mTjcRc44MepR3atGS1T1Aq2QLaLvMyG6HPhkhOrKq5TzzSk4ODeW06CE0
         DqUJgSg4yThOzzFgdTaw0QuslAH+6rmA3t7JfV23+R9oISPcpnzvmTW+oXuSMrUgqzmj
         mcA8+/dHo2Fl+0UPtIhVBBvzKCOWr2FZ6W6IMvVfuDERYH3mrI7aS95/G1+XhwEi4Bzw
         +8KtxmQ2mb6mOTkXsW3L2fagl+UgY2ROqJqvn2w1GV6jzQlJDou0ChEyxRANzwXQcOyk
         DsywoeJ0LTvlQ55DyiXhFTcH619ulU0VvmXbPNKF8TQZD/WpD9098Ish6K8lLiufqRoH
         Uisg==
X-Gm-Message-State: APjAAAXrsjugZGGswFlCY9A+j/1iy3yQq3jDeqyaU1udlPiRqvmCxxAZ
        hrQ6+VlZWTGVnSqhjPwmQ657/2slJUsqOhZMBrTfBc8RPqXFiRj03t0FcYvfE/K1VfsqXd7PiXU
        VWe6L3m/Oovwd
X-Received: by 2002:a17:902:7c94:: with SMTP id y20mr7255436pll.229.1569397519931;
        Wed, 25 Sep 2019 00:45:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwCHx/3JAR/6+/InK/am42O9UXzLwb84IAvlRe5LPMfo5VvBXJdpQbI+cKfEX19uVulZcYtcw==
X-Received: by 2002:a17:902:7c94:: with SMTP id y20mr7255402pll.229.1569397519622;
        Wed, 25 Sep 2019 00:45:19 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p17sm5670841pfn.50.2019.09.25.00.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 00:45:18 -0700 (PDT)
Date:   Wed, 25 Sep 2019 15:45:07 +0800
From:   Peter Xu <peterx@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
Message-ID: <20190925074507.GP28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
 <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
 <20190925065640.GO28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4A3@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4A3@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 07:21:51AM +0000, Tian, Kevin wrote:
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Wednesday, September 25, 2019 2:57 PM
> > 
> > On Wed, Sep 25, 2019 at 10:48:32AM +0800, Lu Baolu wrote:
> > > Hi Kevin,
> > >
> > > On 9/24/19 3:00 PM, Tian, Kevin wrote:
> > > > > > >       '-----------'
> > > > > > >       '-----------'
> > > > > > >
> > > > > > > This patch series only aims to achieve the first goal, a.k.a using
> > > > first goal? then what are other goals? I didn't spot such information.
> > > >
> > >
> > > The overall goal is to use IOMMU nested mode to avoid shadow page
> > table
> > > and VMEXIT when map an gIOVA. This includes below 4 steps (maybe not
> > > accurate, but you could get the point.)
> > >
> > > 1) GIOVA mappings over 1st-level page table;
> > > 2) binding vIOMMU 1st level page table to the pIOMMU;
> > > 3) using pIOMMU second level for GPA->HPA translation;
> > > 4) enable nested (a.k.a. dual stage) translation in host.
> > >
> > > This patch set aims to achieve 1).
> > 
> > Would it make sense to use 1st level even for bare-metal to replace
> > the 2nd level?
> > 
> > What I'm thinking is the DPDK apps - they have MMU page table already
> > there for the huge pages, then if they can use 1st level as the
> > default device page table then it even does not need to map, because
> > it can simply bind the process root page table pointer to the 1st
> > level page root pointer of the device contexts that it uses.
> > 
> 
> Then you need bear with possible page faults from using CPU page
> table, while most devices don't support it today. 

Right, I was just thinking aloud.  After all neither do we have IOMMU
hardware to support 1st level (or am I wrong?)...  It's just that when
the 1st level is ready it should sound doable because IIUC PRI should
be always with the 1st level support no matter on IOMMU side or the
device side?

I'm actually not sure about whether my understanding here is
correct... I thought the pasid binding previously was only for some
vendor kernel drivers but not a general thing to userspace.  I feel
like that should be doable in the future once we've got some new
syscall interface ready to deliver 1st level page table (e.g., via
vfio?) then applications like DPDK seems to be able to use that too
even directly via bare metal.

Regards,

-- 
Peter Xu
