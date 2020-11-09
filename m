Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA02ABE3F
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 15:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgKIOIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 09:08:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51470 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgKIOIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 09:08:19 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604930897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Za9y7vEVZbcDkAkC7l7dzQWgdMKeP4nlkFK2BA7cwS8=;
        b=hSDIbLVtm/ANSBZsSoQ0B1BPQJALf1e3Gm9+rr/beaSXG9ZhGPP36aaUEGXMKjCRg6N+px
        0keE0c4Wnelx1v0FWQ1vkLYGusenOw61vdBfmdIsCZ2JfclTjyKTKsuemdGZMT/BK03BJX
        yTr/cQEhWxRBSYR+ui5FmPFV7vt04XVhAvduv8WDSAUiyWXboZd3CA0/NKHEimulpxhiNy
        u3b8izFPHXOqZX86NYlngvxMjUuYv6XZ4T9NH5vQKRQ9AQiqiSfIV8/9qdrioIk6B6D3le
        Toe/vMFXsSuqXYYSS6k8rnEVZ4oKHh6LKqmG9uCHfNduQKQTXGcydgQbCAW0yA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604930897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Za9y7vEVZbcDkAkC7l7dzQWgdMKeP4nlkFK2BA7cwS8=;
        b=29SYYngZN3K6tp0wh7XnzjkglnmzPe5zF+Bh/pZRJabS3DucWRsFYJrbFsVyaI0vJ7phI1
        wQWk/joCQQXXJkBA==
To:     "Raj\, Ashok" <ashok.raj@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <draft-875z6ekcj5.fsf@nanos.tec.linutronix.de>
References: <draft-875z6ekcj5.fsf@nanos.tec.linutronix.de>
Date:   Mon, 09 Nov 2020 15:08:17 +0100
Message-ID: <87y2jaipwu.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09 2020 at 12:14, Thomas Gleixner wrote:
> On Sun, Nov 08 2020 at 15:58, Ashok Raj wrote:
>> On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
>> But for SIOV devices there is no PASID filtering at the remap level since
>> interrupt messages don't carry PASID in the TLP.
>
> Why do we need PASID for VMM integrity?
>
> If the device sends a message then the remap unit will see the requester
> ID of the device and if the message it sends is not 

That made me look at patch 4/17 which adds DEVMSI support to the
remap code:

> +       case X86_IRQ_ALLOC_TYPE_DEV_MSI:
> +              irte_prepare_msg(msg, index, sub_handle);
>                break;

It does not setup any requester-id filter in IRTE. How is that supposed
to be correct?

Thanks,

        tglx
