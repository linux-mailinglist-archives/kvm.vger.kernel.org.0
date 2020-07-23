Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE63B22B900
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 23:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgGWV4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 17:56:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbgGWV4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 17:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595541381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trSNjsEZ79kQSms1jrHGawiHWSPORXd3ii+S1p8EaA8=;
        b=DiY8N5SXu6Xdtpa+lY0YWLw2CuG8RVFZeEK3fq8iN08kcFUqJh+lLBcjJxpRUNFsV2GjX9
        B1TDCLGDcJmqWXlr7NOEmTzv7bwh2IYICVNxbk1oyFe2SvTb8uWVyLkNV8N8cIl/H6I3mP
        SOfX6DFn/n3z4j0uG4JqsQ39dGqgSAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-uM1OFygfN92MC6XC1ntOMg-1; Thu, 23 Jul 2020 17:56:19 -0400
X-MC-Unique: uM1OFygfN92MC6XC1ntOMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B70A80183C;
        Thu, 23 Jul 2020 21:56:18 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1025637DD;
        Thu, 23 Jul 2020 21:56:18 +0000 (UTC)
Date:   Thu, 23 Jul 2020 15:55:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ross Deleon <rdeleon@marvell.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Could multiple PCIe devices in one IOMMU group be added to
 different KVM VM separately?
Message-ID: <20200723155536.52655375@w520.home>
In-Reply-To: <BY5PR18MB3282589C431572AC89EC531CA3760@BY5PR18MB3282.namprd18.prod.outlook.com>
References: <BY5PR18MB3282589C431572AC89EC531CA3760@BY5PR18MB3282.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jul 2020 21:38:31 +0000
Ross Deleon <rdeleon@marvell.com> wrote:

> Hi:
> I want to know could multiple PCIe devices in one IOMMU group be
> added to different KVM VM separately? Mother board: ASUS 390-A(intel
> supports VT-D) host OS: Ubuntu 18.04 with kernel 4.18.0-15
> KVM-QEMU: version 2.11.1
> I have got failed message like *card1 is used by VM1, and card2 is in
> the card1's group and added to VM2, then VM2 can't boot* I have tried
> vfio driver, but it didn't work, so what should I do? try SR-IOV? or
> update KVM-QEMU or update kernel?

No.  The IOMMU group is the smallest set of devices that are DMA
isolated from other groups.  An IOMMU group is the unit of assignment
for vfio and also the granularity with which we manage IOMMU context.

The processor and chipset support for PCIe ACS (Access Control Services)
plays a significant role in getting the smallest granularity in IOMMU
grouping.  Consumer systems often do not support ACS to the same degree
as a server, therefore if you have independent devices that are grouped
together, the supported answer might be to get new hardware, or
possibly move the device to a different slot.  Intel consumer CPUs do
not support ACS, but the chipsets do make use of several quirks that
can sometime provide ACS equivalent isolation.  Thanks,

Alex

