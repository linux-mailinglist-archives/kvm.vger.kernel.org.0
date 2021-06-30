Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E593B7DBE
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 08:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhF3HAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 03:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbhF3HAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 03:00:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EF3C061766;
        Tue, 29 Jun 2021 23:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7hjCe6790yJYG2knci/u7lshTqKfgMUWNj9c/qQQmOI=; b=msqZuJMeBAI1Ng4YKMnTEPn4me
        ZUo+C+FnoFV8z/5bZoOnp+CkdeyyLQV2+Ohs+D5B7OcVQhY4BJVc5puoZVPPEFoteqh/AsSe8PoND
        QfH9zFiPJv41TALoDbOZkP/NwW/W9zFeZiEs4t9U+IzXEuU1LXjvWqfFlu9eghIBRbiWzMQHTqVev
        V/LcMCU3NMCcYXJ96J+luawTeg9igB77ulhin/ZRPQt9Osh6dJmDGgxIcF7/5+foNRdc/AFkNzmSC
        fDZ3o5udhRXWu/5GqiIYdAUJlURi62LvWS/L2fhf3Jh0j3RjkA/XiXikszGS3ZXwUz+gbaQGjU/4w
        fCjpyQ0A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyU9N-0050qE-2A; Wed, 30 Jun 2021 06:56:50 +0000
Date:   Wed, 30 Jun 2021 07:56:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNwVrZoR5k3RnWeL@infradead.org>
References: <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <MWHPR11MB1886E95C6646F7663DBA10DD8C389@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886E95C6646F7663DBA10DD8C389@MWHPR11MB1886.namprd11.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 03:25:32AM +0000, Tian, Kevin wrote:
> 
> Possibly just a naming thing, but I feel it's better to just talk about
> no-snoop or non-coherent in the uAPI. Per Intel SDM wbinvd is a
> privileged instruction. A process on the host has no privilege to 
> execute it. Only when this process holds a VM, this instruction matters
> as there are guest privilege levels. But having VFIO uAPI (which is
> userspace oriented) to explicitly deal with a CPU instruction which
> makes sense only in a virtualization context sounds a bit weird...

More importantly the Intel instructions here are super weird.
Pretty much every other architecture just has plan old cache
writeback/invalidate/writeback+invalidate instructions without all these
weird implications.
