Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0661B7134
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgDXJvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 05:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgDXJvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 05:51:47 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9790A20728;
        Fri, 24 Apr 2020 09:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587721907;
        bh=GlmWL52bv6OnLp9DBrDN1ldUCRy/XQQdtf9ANF1syTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v5nleYikOuIFnS0BI7aR6eooGKKHQ5ItndtMTTMulwEAhRMdR/qpxngv1ZCzwqvD/
         pfCGsm16KpvVb0SiPFO0ntXGzDV3zOVACX2s8lgJFi1mO2VlB+RfR98rDQRHf6mDwI
         BSycbMR0P6QSaPD/xbnQFlMRPuDd/+NVG6xfaCI8=
Date:   Fri, 24 Apr 2020 10:51:42 +0100
From:   Will Deacon <will@kernel.org>
To:     =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH kvmtool v4 1/5] virtio-mmio: Assign IRQ line directly
 before registering device
Message-ID: <20200424095141.GA21141@willie-the-truck>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200423173844.24220-2-andre.przywara@arm.com>
 <20200424084104.GB20801@willie-the-truck>
 <a8b424ed-9c63-bc72-6608-3e7e01dbdbce@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8b424ed-9c63-bc72-6608-3e7e01dbdbce@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 09:50:04AM +0100, André Przywara wrote:
> On 24/04/2020 09:41, Will Deacon wrote:
> > On Thu, Apr 23, 2020 at 06:38:40PM +0100, Andre Przywara wrote:
> >> diff --git a/devices.c b/devices.c
> >> index a7c666a7..2c8b2665 100644
> >> --- a/devices.c
> >> +++ b/devices.c
> >> @@ -1,7 +1,6 @@
> >>  #include "kvm/devices.h"
> >>  #include "kvm/kvm.h"
> >>  #include "kvm/pci.h"
> >> -#include "kvm/virtio-mmio.h"
> >>  
> >>  #include <linux/err.h>
> >>  #include <linux/rbtree.h>
> >> @@ -33,9 +32,6 @@ int device__register(struct device_header *dev)
> >>  	case DEVICE_BUS_PCI:
> >>  		pci__assign_irq(dev);
> >>  		break;
> >> -	case DEVICE_BUS_MMIO:
> >> -		virtio_mmio_assign_irq(dev);
> >> -		break;
> > 
> > Hmm, but then it's a bit ugly to handle these differently to PCI. How
> > difficult is it to add a new bus type instead? e.g. stick the virtio mmio
> > devices on DEVICE_BUS_VIRTIO_MMIO and then add the non-virtio MMIO devices
> > to DEVICE_BUS_MMIO?
> 
> I have another patch to also do the IRQ allocation for PCI devices in
> their callers. This avoids the allocation on an IRQ for vesa, for
> instance, but otherwise doesn't solve a real problem, so I didn't post
> it yet.
> By looking at devices.c, I feel like this should only be handling the
> administrative part of managing the device_header structs in the rbtree.
> Dealing with bus specific things looks out of scope for this file, IMHO.
> 
> If you agree, I will send the patch shortly.

Yes please.

Will
