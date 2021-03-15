Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B733C9FE
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhCOXiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:38:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:47444 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233779AbhCOXhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:37:51 -0400
IronPort-SDR: xC46zmYawu1Ti+Z7aGKkw/MlCzzWoVdaA2whKmWXYvwtAbCBHBkAF03p8BAxyVxF/wOVsHCNfM
 nlRkqnXA2bFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="250534644"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="250534644"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 16:37:51 -0700
IronPort-SDR: Arp01YLngEKK/mATz7xeSEqowA0Khd72bSSt/H+r5puobLJP6QT2p1qIcoV2q13QyL/MIlM9d6
 1Agfyzc8fi9w==
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="412010634"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 16:37:51 -0700
Date:   Mon, 15 Mar 2021 16:40:12 -0700
From:   Jacob Pan <jacob.jun.pan@intel.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        jacob.jun.pan@intel.com
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <20210315164012.4adeabe8@jacob-builder>
In-Reply-To: <YE/ddx5+ToNsgUF0@slm.duckdns.org>
References: <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
        <20210312125821.22d9bfca@jacob-builder>
        <YEvZ4muXqiSScQ8i@google.com>
        <20210312145904.4071a9d6@jacob-builder>
        <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
        <20210313085701.1fd16a39@jacob-builder>
        <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
        <20210315151155.383a7e6e@jacob-builder>
        <YE/ddx5+ToNsgUF0@slm.duckdns.org>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tejun,

On Mon, 15 Mar 2021 18:19:35 -0400, Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Mon, Mar 15, 2021 at 03:11:55PM -0700, Jacob Pan wrote:
> > > Migration itself doesn't have restrictions but all resources are
> > > distributed on the same hierarchy, so the controllers are supposed to
> > > follow the same conventions that can be implemented by all
> > > controllers. 
> > Got it, I guess that is the behavior required by the unified hierarchy.
> > Cgroup v1 would be ok? But I am guessing we are not extending on v1?  
> 
> A new cgroup1 only controller is unlikely to be accpeted.
> 
> > The IOASIDs are programmed into devices to generate DMA requests tagged
> > with them. The IOMMU has a per device IOASID table with each entry has
> > two pointers:
> >  - the PGD of the guest process.
> >  - the PGD of the host process
> > 
> > The result of this 2 stage/nested translation is that we can share
> > virtual address (SVA) between guest process and DMA. The host process
> > needs to allocate multiple IOASIDs since one IOASID is needed for each
> > guest process who wants SVA.
> > 
> > The DMA binding among device-IOMMU-process is setup via a series of user
> > APIs (e.g. via VFIO).
> > 
> > If a process calls fork(), the children does not inherit the IOASIDs and
> > their bindings. Children who wish to use SVA has to call those APIs to
> > establish the binding for themselves.
> > 
> > Therefore, if a host process allocates 10 IOASIDs then does a
> > fork()/clone(), it cannot charge 10 IOASIDs in the new cgroup. i.e. the
> > 10 IOASIDs stays with the process wherever it goes.
> > 
> > I feel this fit in the domain model, true?  
> 
> I still don't get where migration is coming into the picture. Who's
> migrating where?
> 
Sorry, perhaps I can explain by an example.

There are two cgroups: cg_A and cg_B with limit set to 20 for both. Process1
is in cg_A. The initial state is:
cg_A/ioasid.current=0, cg_A/ioasid.max=20
cg_B/ioasid.current=0, cg_B/ioasid.max=20

Now, consider the following steps:

1. Process1 allocated 10 IOASIDs,
cg_A/ioasid.current=10,
cg_B/ioasid.current=0

2. then we want to move/migrate Process1 to cg_B. so we need uncharge 10 of
cg_A, charge 10 of cg_B

3. After the migration, I expect
cg_A/ioasid.current=0,
cg_B/ioasid.current=10

We don't enforce the limit during this organizational change since we can't
force free IOASIDs. But any new allocations will be subject to the limit
set in ioasid.max.

> Thanks.
> 


Thanks,

Jacob
