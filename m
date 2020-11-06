Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD1A2AA183
	for <lists+kvm@lfdr.de>; Sat,  7 Nov 2020 00:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgKFXrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 18:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgKFXrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 18:47:13 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAD6C0613D3
        for <kvm@vger.kernel.org>; Fri,  6 Nov 2020 15:47:13 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id ay21so2974405edb.2
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 15:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ld/AFos27KlKPC12X38aMGZUocKXd6SaJrBUuNVGmN0=;
        b=tkdRkau4k4qjSOcL+lCqzMeF+zlmlKnfIhzdIaXGkB93zPzYnQCCykbyAg5/beJ7x1
         HgU3JBNk6olMLPuuM02azIWJ//sqvEgCfm3ZkRkYahGBfztBEZIuwB0a+2QXERVQpzZb
         LQsrQk8z7NgBJNN1hwTtGdI2NqjcbW5QMvB/MXhBjVqRCt4Lugw2PNQV574teL+vJ8Gb
         Rr47XEeICg3VZuwo9nltfAwQsb+AnZV93sF2wQ1ynN2NooVyHpU1Hje/5WOxFo9IPy+C
         EKNk1Xh660oMB9+fPeQ1LRRC/oblHCBovC7ZPkhP5ZKEZoASeAS6xILfFyPOg4Y+PM7b
         zEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ld/AFos27KlKPC12X38aMGZUocKXd6SaJrBUuNVGmN0=;
        b=VmWeZqUNW/QExDIHoEt3qShCln+dnOT+VIxi4V3yc4bKwtNTFFIIy8W8kJO16Vfh41
         ZPUj4o6pk88BMn0hcHFQn83b79xv8EWUgWlV3DEfXfS58Bj/mLCsCF8NmIOnVWQrF0KS
         dueoIgXXaos0D0GU58uLxlQiQG+5DO/vbZdQ+90nsx0OX3fvf2xsIPQ/HIfQit8eMDXd
         NpjhzEmSyP0YKkAtn2BOnwYgEBD1YcbmoWgS+fUjQ2VfeCL6n9LYlSg7aFG/hm9twf88
         f1KyWVH89vy3LCHshM7kRMRzJcty36OEqRq0bnrL2r7HbbcR7B8AGG7pPV3QfyAMrEa5
         90Hw==
X-Gm-Message-State: AOAM5316CxbBoKqfV+yP9GIdsrUmXi1ktPvdtblwDr+u3rnosdJQm5g2
        qmmdoW3EMnmeR+GnB0Z6Us23ELRW4ZdyrEm2wW9WAQ==
X-Google-Smtp-Source: ABdhPJy/RVV3sqTqc4xE+GihNiS1eS50AdCrqwgYd+vRMib4fmp3nZlcH77SGQmU6AM1MQg85qDtVq7mK+6+ZFe4bSI=
X-Received: by 2002:aa7:d843:: with SMTP id f3mr4792654eds.354.1604706432202;
 Fri, 06 Nov 2020 15:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20201102132158.GA3352700@nvidia.com> <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com> <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com>
In-Reply-To: <20201106175131.GW2620339@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 6 Nov 2020 15:47:00 -0800
Message-ID: <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 6, 2020 at 9:51 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
[..]
> > This is true for IMS as well. But probably not implemented in the kernel as
> > such. From a HW point of view (take idxd for instance) the facility is
> > available to native OS as well. The early RFC supported this for native.
>
> I can't follow what you are trying to say here.

I'm having a hard time following the technical cruxes of this debate.
I grokked your feedback on the original IMS proposal way back at the
beginning of this effort (pre-COVID even!), so maybe I can mediate
here as well. Although, SIOV is that much harder for me to spell than
IMS, so bear with me.

> Dave said the IMS cap was to indicate that the VMM supported emulation
> of IMS so that the VMM can do the MSI addr/data translation as part of
> the emulation.
>
> I'm saying emulation will be too horrible for our devices that don't
> require *any* emulation.

This part I think I understand, i.e. why spend any logic emulating IMS
as MSI since the IMS capability can be a paravirtualized interface
from guest to VMM with none of the compromises that MSI would enforce.
Did I get that right?

> It is a bad architecture. The platform needs to handle this globally
> for all devices, not special hacky emulations things custom made for
> every device out there.

I confess I don't quite understand the shape of what "platform needs
to handle this globally" means, but I understand the desired end
result of "no emulation added where not needed". However, would this
mean that the bare-metal idxd driver can not be used directly in the
guest without modification? For example, as I understand from talking
to Ashok, idxd has some device events like error notification hard
wired to MSI while data patch interrupts are IMS. So even if the IMS
side does not hook up MSI emulation doesn't idxd still need MSI
emulation to reuse the bare metal driver directly?

> > Native devices can have both MSIx and IMS capability. But as I
> > understand this isn't how we have partitioned things in SW today. We
> > left IMS only for mdev's. And I agree this would be very useful.
>
> That split is just some decision idxd did, we are thinking about doing
> other things in our devices.

Where does the collision happen between what you need for a clean
implementation of an IMS-like capability (/me misses his "dev-msi"
name that got thrown out in the Thomas rewrite), and emulation needed
to not have VF special casing in the idxd driver.

Also feel free to straighten me out (Jason or Ashok) if I've botched
the understanding of this.
