Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621F922ABF2
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 11:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgGWJwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 05:52:00 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:34609 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgGWJv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 05:51:59 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id AF329300011A0;
        Thu, 23 Jul 2020 11:51:52 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 68E6B36272; Thu, 23 Jul 2020 11:51:52 +0200 (CEST)
Date:   Thu, 23 Jul 2020 11:51:52 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     kernel test robot <lkp@intel.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Michael Haeuptle <michael.haeuptle@hpe.com>,
        Ian May <ian.may@canonical.com>,
        Keith Busch <kbusch@kernel.org>, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Rick Farrington <ricardo.farrington@cavium.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org,
        Govinda Tatti <govinda.tatti@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org
Subject: Re: [PCI] 3233e41d3e:
 WARNING:at_drivers/pci/pci.c:#pci_reset_hotplug_slot
Message-ID: <20200723095152.nf3fmfzrjlpoi35h@wunner.de>
References: <908047f7699d9de9ec2efd6b79aa752d73dab4b6.1595329748.git.lukas@wunner.de>
 <20200723091305.GJ19262@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723091305.GJ19262@shao2-debian>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 05:13:06PM +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-9):
[...]
> commit: 3233e41d3e8ebcd44e92da47ffed97fd49b84278 ("[PATCH] PCI: pciehp: Fix AB-BA deadlock between reset_lock and device_lock")
[...]
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> [    0.971752] WARNING: CPU: 0 PID: 1 at drivers/pci/pci.c:4905 pci_reset_hotplug_slot+0x70/0x80

Thank you, trusty robot.

I botched the call to lockdep_assert_held_write(), it should have been
conditional on "if (probe)".

Happy to respin the patch, but I'd like to hear opinions on the locking
issues surrounding xen and octeon (and the patch in general).

In particular, would a solution be entertained wherein the pci_dev is
reset by the PCI core after driver unbinding, contingent on a flag which
is set by a PCI driver to indicate that the pci_dev is returned to the
core in an unclean state?

Also, why does xen require a device reset on bind?

Thanks!

Lukas
