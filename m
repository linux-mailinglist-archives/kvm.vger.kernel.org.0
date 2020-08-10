Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5EE241281
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgHJVqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 17:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgHJVqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 17:46:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B277C061756;
        Mon, 10 Aug 2020 14:46:48 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597096006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTc7qzlDDZI94ZkS5x0rnSOmtfpFDDsiHIxpgjl1fsM=;
        b=GZZxwgrvXibFJZcaS2R22LnxTO30X96DmFeX8HkungAaeXusRMeaI+cMy8HRudLp8lC370
        COMhOoc+iX/XSzM8k7eiWcZYSS6CBbg/+1WB5c/UGPHJn9H+2MtJDlQFsFMp4bdnZNN/Hx
        bKXqnFwPx5LC9mkOYr0JZvPnzNKOJZH5rmbb5oW5JDkdG4A06mugZ0GVxkpfD3Jbk+AAQz
        bP8dAyGsgaYuHXE5B1YcNBA0tfcxRuB8lAhZ+FX7Bz4nQkuhd2q3daKUJql6z6ppago522
        bTvybQ+2/5SPBCt/c1sw47DlGLMNGlt2kUkiVwEgE6P0s/tj8eRkupZ4r3helQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597096006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTc7qzlDDZI94ZkS5x0rnSOmtfpFDDsiHIxpgjl1fsM=;
        b=65vt/Uja35O19qQR/79tEWmhzsWgvL/QYtGqTWTJlMytEjKBQDIDRXrDXClI2DLPV1oRz/
        GVWzrFvyTO6dqnCQ==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Lin\, Jing" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "Hansen\, Dave" <dave.hansen@intel.com>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <87h7tcgbs2.fsf@nanos.tec.linutronix.de>
References: <87h7tcgbs2.fsf@nanos.tec.linutronix.de>
Date:   Mon, 10 Aug 2020 23:46:45 +0200
Message-ID: <87ft8uxjga.fsf@nanos>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> The infrastructure itself is not more than a thin wrapper around the
> existing msi domain infrastructure and might even share code with
> platform-msi.

And the annoying fact that you need XEN support which opens another can
of worms...
