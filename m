Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DD12AAE29
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 00:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgKHXIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 18:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKHXIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 18:08:41 -0500
X-Greylist: delayed 3505 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 08 Nov 2020 15:08:41 PST
Received: from twosheds.infradead.org (twosheds.infradead.org [IPv6:2001:8b0:10b:1:21d:7dff:fe04:dbe2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24754C0613CF;
        Sun,  8 Nov 2020 15:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=twosheds.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Cc:To:From:Subject:Date:References:In-Reply-To:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ip8hF5BftOjZIayundc04w+NG5HSfhZUwkO7oX7/MuE=; b=NiBdShb0quc3A87cncLeElMkU
        Cri9O/nbA3Q+cNPO5g/LWL4pRN8LVSIPCprSE7pkDC1/SD+RCusucXgeaGh083P9AzPmUcSurgctN
        65DwvYtYuTDYLCGpw0sFErehScpOJwI5U+OjZs5j2fKo66NvnHgjrLxy+16yxG8HAbhbpHOsW3g3Q
        DH1Xx6+f/SMU1g87foW1UhUlpzDmkWdfoeqoQwmj9FvQVJEqZJtl/dikNVCxzNLdSAg3rmyg22Djm
        EvYat3/TMQuvYHlgDzjAPBV9dYu8A0rQ/uebwa1ueCrRheDuAUIf4sOmDgctB+CIy55cyaOOZieDl
        bs9trAlLA==;
Received: from localhost ([127.0.0.1] helo=twosheds.infradead.org)
        by twosheds.infradead.org with esmtp (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kbssT-00CBlH-SM; Sun, 08 Nov 2020 22:09:38 +0000
Received: from 2001:8b0:10b:1:b16b:5d8a:941b:e15c
        (SquirrelMail authenticated user dwmw2)
        by twosheds.infradead.org with HTTP;
        Sun, 8 Nov 2020 22:09:38 -0000
Message-ID: <59034a932606e25c0b260540fff0b6dc.squirrel@twosheds.infradead.org>
In-Reply-To: <87k0uvk0oc.fsf@nanos.tec.linutronix.de>
References: <20201030224534.GN2620339@nvidia.com>
    <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
    <20201102132158.GA3352700@nvidia.com>
    <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
    <20201103124351.GM2620339@nvidia.com>
    <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
    <20201104124017.GW2620339@nvidia.com>
    <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
    <20201104135415.GX2620339@nvidia.com>
    <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
    <20201106131415.GT2620339@nvidia.com>
    <87k0uvk0oc.fsf@nanos.tec.linutronix.de>
Date:   Sun, 8 Nov 2020 22:09:38 -0000
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
From:   "David Woodhouse" <dwmw2@infradead.org>
To:     "Thomas Gleixner" <tglx@linutronix.de>
Cc:     "Jason Gunthorpe" <jgg@nvidia.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Bjorn Helgaas" <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "jing.lin\@intel.com" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
User-Agent: SquirrelMail/1.4.23 [SVN]-1.fc30.20190710
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Fri, Nov 06 2020 at 09:14, Jason Gunthorpe wrote:
>> On Fri, Nov 06, 2020 at 09:48:34AM +0000, Tian, Kevin wrote:
>> For instance you could put a "disable IMS" flag in the ACPI tables, in
>> the config space of the emuulated root port, or any other areas that
>> clearly belong to the platform.
>>
>> The OS logic would be
>>  - If no IMS information found then use IMS (Bare metal)
>>  - If the IMS disable flag is found then
>>    - If (future) hypercall available and the OS knows how to use it
>>      then use IMS
>>    - If no hypercall found, or no OS knowledge, fail IMS
>
> That does not work because an older hypervisor would not have that
> disable flag and the guest kernel would assume to be on bare metal (if
> no other indicators are there).

In the absence of a forward-thinking design from Intel perhaps we could
use the existence of an IOMMU with interrupt remapping and not caching
mode as the indication that it's bare metal?

-- 
dwmw2

