Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38CF2A2F9A
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgKBQUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:20:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:56260 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbgKBQUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:20:45 -0500
IronPort-SDR: lBPOiCOVeRd/4N3PiNLiIfEHemN80QXUlojNGFIPaMbr2Yv3lTB6DOLpSXCgoUE9DV0PHyJvW5
 Iw7QA2ATFgTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="148764681"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="148764681"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 08:20:44 -0800
IronPort-SDR: zqX9YTIdbIUuRjrHSgJ5WAS4q9uZjfybMh7HfV9dDWpTM16Kd68N/112AcMLsn1ugcJrOe3hmx
 xsSUf8dJ5zrA==
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="324908109"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 08:20:44 -0800
Date:   Mon, 2 Nov 2020 08:20:43 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201102162043.GB20783@otc-nc-03>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com>
 <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com>
 <20201030204307.GA683@otc-nc-03>
 <87h7qbkt18.fsf@nanos.tec.linutronix.de>
 <20201031235359.GA23878@araj-mobl1.jf.intel.com>
 <20201102132036.GX2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102132036.GX2620339@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

On Mon, Nov 02, 2020 at 09:20:36AM -0400, Jason Gunthorpe wrote:

> > of IDXD for guest drivers. These look and feel like IDXD, not another device 
> > interface. In that sense if we move PF/VF mailboxes as
> > separate drivers i thought it feels a bit odd.
> 
> You need this split anyhow, putting VFIO calls into the main idxd
> module is not OK.
> 
> Plugging in a PCI device should not auto-load VFIO modules.

Yes, I agree that would be a good reason to separate them completely and
glue functionality with private APIs between the 2 modules.

- Separate mdev code from base idxd.
- Separate maintainers, so its easy to review and include. (But remember
  they are heavily inter-dependent. They have to move to-gether)

Almost all SRIOV drivers today are just configured with some form of Kconfig
and those relevant files are compiled into the same module.

I think in *most* applications idxd would be operating in that mode, where
you have the base driver and mdev parts (like VF) compiled in if configured
such.

Creating these private interfaces for intra-module are just 1-1 and not
general purpose and every accelerator needs to create these instances.

I wasn't sure focibly creating this firewall between the PF/VF interfaces
is actually worth the work every driver is going to require. I can see
where this is required when they offer separate functional interfaces
when we talk about multi-function in a more confined definition today.

idxd mdev's are purely a VF extension. It doesn't provide any different
function. For e.g. like an RDMA device that can provide iWarp, ipoib or
even multiplexing storage over IB. IDXD is a fixed function interface.

Sure having separate modules helps with that isolation. But I'm not
convinced if this simplifies, or complicates things more than what is
required for these device types.

Cheers,
Ashok
