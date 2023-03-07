Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572906AFA57
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 00:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCGX3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 18:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCGX3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 18:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0278432527
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 15:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678231724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2yRyaL4Cdt0nv2G/McwhWPHJse7+eFAUs/kNScOsNI=;
        b=GGMdslF9KA2a9CGQNlU9vFVm95ydrfiFzFkVIHX5o2PadGwtygQq8vsABbcSfj8K94S9PK
        oWLyNKobXV7KW9YrZ3zf/uF2UEuV6I8jN8IJhjsoCUhowuHvwffBCo7enRELO6wAOqX+2A
        +YfMr/RhcR5I1poYNDnucUNaRoNBEt4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-eEELdkGKMAG7Vst6tAXK2w-1; Tue, 07 Mar 2023 18:28:42 -0500
X-MC-Unique: eEELdkGKMAG7Vst6tAXK2w-1
Received: by mail-io1-f72.google.com with SMTP id 9-20020a5ea509000000b0074ca36737d2so7709375iog.7
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 15:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678231722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2yRyaL4Cdt0nv2G/McwhWPHJse7+eFAUs/kNScOsNI=;
        b=kC/asIN0uutGW6UarHAfV6TBAj8bqTP2ZTwlnP0tOWSk4jO0cM5Aj7NkkaAf2wrp+N
         /udmF+RiI9G43z9RPhfBShGftAeQIAJPRiLIKtRix11jQLP1hwI7t5ZDpcoqNwveJLO4
         TfJBTNg5kBuLCnGB9fu9aUXOrKCTstpnlUg5aTUjthoBNS1IHKBEVXXhWHy9LizKgw54
         uFRotibWTm6g6XYKBLSCae1jvejlzXtHk+1kRTRW3410Y8lg8kfZOUGHFG1Crea491zG
         w9bK30SQE1U7cifHhYNS20xd6/w9snvJ7j4QW7XLM2U/gghYjokwCupTRvb/GN11jHLE
         YfeQ==
X-Gm-Message-State: AO0yUKXtTndjm6FYa9wLW9dc0AoP9MeLZ3ayV3j4p+Ho4AGUW+cBhmjq
        9MgFXHQ2/L15XQ0sZ0qLFxlvcxaqpAAjktjVOYTMEENfCkybeDk4l99da8AuGN69x2SHwVDeMbs
        /WnDOG4JNHd6J
X-Received: by 2002:a6b:610b:0:b0:74c:b52a:4176 with SMTP id v11-20020a6b610b000000b0074cb52a4176mr13160506iob.3.1678231721888;
        Tue, 07 Mar 2023 15:28:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/ZSaStFtuAniVvnUczY6tbm/AadxBDJfjTKQ8+27dLYnvlWQY7Dk5xsND07ZUEJebO3m78uQ==
X-Received: by 2002:a6b:610b:0:b0:74c:b52a:4176 with SMTP id v11-20020a6b610b000000b0074cb52a4176mr13160497iob.3.1678231721655;
        Tue, 07 Mar 2023 15:28:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a14-20020a5d958e000000b00746c45ff173sm4581387ioo.5.2023.03.07.15.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 15:28:41 -0800 (PST)
Date:   Tue, 7 Mar 2023 16:28:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Message-ID: <20230307162839.2236640d.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52764ABF8381FCDB8CE0FFF78CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
        <ZAXxTiWU489dDssW@ziepe.ca>
        <BN9PR11MB52764ABF8381FCDB8CE0FFF78CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Mar 2023 05:54:46 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Monday, March 6, 2023 9:58 PM
> > 
> > On Fri, Mar 03, 2023 at 05:54:26AM +0000, K V P, Satyanarayana wrote:  
> > > Intel Platform Monitoring Technology (PMT) support is indicated by  
> > presence  
> > > of an Intel defined PCIe Designated Vendor Specific Extended Capabilities
> > > (DVSEC) structure with a PMT specific ID.However DVSEC structures may  
> > also  
> > > be used by Intel to indicate support for other features. The Out Of Band  
> > Management  
> > > Services Module (OOBMSM) uses DVSEC to enumerate several features,  
> > including PMT.  
> > >
> > > The current VFIO driver does not pass DVSEC capabilities to virtual machine  
> > (VM)  
> > > which makes intel_vsec driver not to work in the VM. This series adds  
> > DVSEC  
> > > capability to user visible list to allow its use with VFIO.
> > >
> > > Signed-off-by: K V P Satyanarayana <satyanarayana.k.v.p@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_config.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)  
> > 
> > Wasn't the IDXD/SIOV team proposing to use the fact that DVSEC doesn't
> > propogate to indicate that IMS doesn't work?
> > 
> > Did this plan get abandoned? It seems at odds with this patch.  
> 
> No. Guest IMS will be indicated via hypercall/vIR as planned. 

Thank goodness, basing a feature on the absence of a capability that's
subject to change would have really put us, or IMS, in a corner.

> > Why would you use a "Platform Monitoring Technology" device with VFIO
> > anyhow?  
> 
> Ack. I guess it's a monitoring capability per PCI device to form a
> platform-level monitoring technology. But w/o all those background
> and usage description it's really strange to pass a 'platform' capability
> into a guest.

Is this perhaps for validation of the device, because yes, assigning
platform devices to a VM doesn't seem like something a system vendor
would tend to promote.

> > Honestly I'm a bit reluctant to allow arbitary config space, some of
> > the stuff people put there can be dangerous.
> >   
> 
> Probably an allowed list to manage which DVSEC ID can be exposed
> to userspace via vfio-pci, e.g. if the PMT ID in this patch is proved
> to be safe for a meaningful usage?

Well, let me take this a different direction because the support
proposed here only allows read-only access to the DVSEC capability.  Is
that actually useful?  Drivers making use of write access to DVSEC are
going to fail in unpredictable ways if their writes are dropped.  That
seems worse than our current state of hiding it.

We already provide raw write access to both the standard and extended
vendor specific capabilities, why wouldn't we by default do the same
for DVSEC?  Devices aren't limited to config space if they want to do
something dangerous, at some point we need to rely on platform
isolation.

If there are underlying concerns here, then we probably need some sort
of opt-in policy which restricts vfio-pci from binding to anything but
VFs.  Thanks,

Alex

