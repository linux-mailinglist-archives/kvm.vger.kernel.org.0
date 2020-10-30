Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214E72A10AF
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 23:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgJ3WKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 18:10:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45148 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgJ3WKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 18:10:30 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604095827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klXJ/WXtTytKUiQGB3XZESrGsz1LgUOMEvT9bEWOEKU=;
        b=WNmyK9g9+zOKC2n9bCFKw70tGfhqhtaqGIKV9AJF46wvVQLVIAtGozw7FpwHMbYcFuNgHh
        wiaDeeqKYgC43rzKZNCGZ7iXoKe7gxlt/yH5D1HCfk9wDr+IkKWrMALxp3V+PVwjoWIfkB
        4pQ2pLLf2/m7gOMOSetI381GPAEz7CiRJjtsyhzttFDTGKZ9BEpg+i678TOdiio9eQSBmM
        kNsujhuairxC1FpE55MpCHHKF6jEndW/pLyllOnSrHmilJGsWLAm+lPHSDOW5CaMroNRLe
        zVW9s83Xwp2gu9W0oSx7MIscQOnCGUm3oNQi2PfpPfkJF4uWv6ETvcJlwJrRZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604095827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klXJ/WXtTytKUiQGB3XZESrGsz1LgUOMEvT9bEWOEKU=;
        b=qc/Agod+1u+5jo+I3HYB7zsQ/MfLXfaXAZwOx7iN2PfRWtSiSBBaFCCCApEJNhCVoVGQRg
        6U/TJAcUlkSU+KCg==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     Megha Dey <megha.dey@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI support for the idxd driver
In-Reply-To: <9430e488-e6fc-0101-85dc-b3d8a1a40899@intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com> <878sbnmodd.fsf@nanos.tec.linutronix.de> <9430e488-e6fc-0101-85dc-b3d8a1a40899@intel.com>
Date:   Fri, 30 Oct 2020 23:10:27 +0100
Message-ID: <87y2jnl60c.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30 2020 at 13:59, Dave Jiang wrote:
> On 10/30/2020 1:48 PM, Thomas Gleixner wrote:
>> On Fri, Oct 30 2020 at 11:50, Dave Jiang wrote:
>>> The code has dependency on Thomas=E2=80=99s MSI restructuring patch ser=
ies:
>>> https://lore.kernel.org/lkml/20200826111628.794979401@linutronix.de/
>>=20
>> which is outdated and not longer applicable.
>
> Yes.... I wasn't sure how to point to these patches from you as a depende=
ncy.
>
> irqdomain/msi: Provide msi_alloc/free_store() callbacks
> platform-msi: Add device MSI infrastructure
> genirq/msi: Provide and use msi_domain_set_default_info_flags()
> genirq/proc: Take buslock on affinity write
> platform-msi: Provide default irq_chip:: Ack
> x86/msi: Rename and rework pci_msi_prepare() to cover non-PCI MSI
> x86/irq: Add DEV_MSI allocation type

How can you point at something which is not longer applicable?

> Do I need to include these patches in my series? Thanks!

No. They are NOT part of this series. Prerequisites are seperate
entities and your series can be based on them.

So for one you want to make sure that the prerequisites for your IDXD
stuff are going to be merged into the relevant maintainer trees.

To allow people working with your stuff you simply provide an
aggregation git tree which contains all the collected prerequisites.
This aggregation tree needs to be rebased when the prerequisites change
during review or are merged into a maintainer tree/branch.

It's not rocket science and a lot of people do exactly this all the time
in order to coordinate changes which have dependencies over multiple
subsystems.

Thanks,

        tglx
