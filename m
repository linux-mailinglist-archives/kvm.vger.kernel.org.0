Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC13A6A9BF0
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 17:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjCCQmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 11:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCCQmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 11:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAFA29151
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 08:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677861675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fx5zQVBw7RoxiCBzHcwgsVmUhq/RT3rnLJwLJ+gvwCE=;
        b=HBJDGpsVxqyXK7Kn08eBxECrQuGF0G2jTvsEOG0CXSd8p/cM/frobQv1GG9D65TIp4w0YG
        rmX13yZjeDaEJXPQEMt4ti62A85Kke9Y3EfaCpqLb1KRkSf/09CX9cEH9vJ8sKRK31xfUm
        83W2lTmgNOPlKoC+46jwU1PV0ZLF6Yk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-9bBoa7Y_OXm5KXB4AxouXw-1; Fri, 03 Mar 2023 11:41:14 -0500
X-MC-Unique: 9bBoa7Y_OXm5KXB4AxouXw-1
Received: by mail-io1-f69.google.com with SMTP id c13-20020a0566022d0d00b0074cc4ed52d9so1584085iow.18
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 08:41:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fx5zQVBw7RoxiCBzHcwgsVmUhq/RT3rnLJwLJ+gvwCE=;
        b=LkttH+/TtRjLIjoLbVy+xpiD3fSZ5w42Rb3W4Hm2c/UL04uiD1a6QMytB0m9Sp8OWy
         34T2ZZ82zv7ujExpBDAKo8kAlLShh/pxjJp0tqzGulYGfOlZZBHYZ1x+bRUI9DdtfEKq
         W1/37sPbDlAd6HbeEEEGNQDCpi+by15wQgu3AjKVRibeRMymAAWC7Rir/Vo9zVjeYYhm
         VaMYhQfN/LzhuLGnb1p8rgz/nnrG8+LX94oYCZRYInEeVa4V/vvKqNwRwSjKl1AdIJUa
         nGTxzyP4GfwUSv7jSembVsLqUHw8GGnpgsa1HWadTVk7RiZr1YliGbcSIPa9+zJvkVcq
         sIrA==
X-Gm-Message-State: AO0yUKW9RcaEmSGkNbLKj5GvSpM1ROXscXQaXMoUOqilVJHimSWfdZ+D
        hMMPVVrc+0tTkvYZOPojKavjru2bbqEyFheiNrbCzTpdTO2CsKnkINNklphk8WnY6mvQnrAH831
        pYTzG7aSxKGhK
X-Received: by 2002:a92:ca07:0:b0:315:6e7f:f413 with SMTP id j7-20020a92ca07000000b003156e7ff413mr2593231ils.4.1677861673789;
        Fri, 03 Mar 2023 08:41:13 -0800 (PST)
X-Google-Smtp-Source: AK7set9ILWa7ZSUxptYCW3zLZ+vgJY0MiTP5jp58NZ6iH5vPNgxrklYaTv9myif2wrNgQYHi+Ps+sQ==
X-Received: by 2002:a92:ca07:0:b0:315:6e7f:f413 with SMTP id j7-20020a92ca07000000b003156e7ff413mr2593211ils.4.1677861673422;
        Fri, 03 Mar 2023 08:41:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l24-20020a02a898000000b003a9962a24d1sm838962jam.122.2023.03.03.08.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 08:41:12 -0800 (PST)
Date:   Fri, 3 Mar 2023 09:41:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tasos Sahanidis <tasos@tasossah.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
Subject: Re: Bug: Completion-Wait loop timed out with vfio
Message-ID: <20230303094110.79d34dab.alex.williamson@redhat.com>
In-Reply-To: <5682fc52-d2a3-8fd9-47e8-eb12d5f87c57@tasossah.com>
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
        <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
        <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
        <20230228114606.446e8db2.alex.williamson@redhat.com>
        <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
        <20230301071049.0f8f88ae.alex.williamson@redhat.com>
        <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
        <20230302133655.2966f2e3.alex.williamson@redhat.com>
        <5682fc52-d2a3-8fd9-47e8-eb12d5f87c57@tasossah.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Mar 2023 08:33:14 +0200
Tasos Sahanidis <tasos@tasossah.com> wrote:

> On 2023-03-02 22:36, Alex Williamson wrote:
> > Yes, the fact that the NIC works suggests there's not simply a blatant
> > chip defect where we should blindly disable D3 power state support for
> > this downstream port.  I'm also not seeing any difference in the
> > downstream port configuration between the VM running after the port has
> > resumed from D3hot and the case where the port never entered D3hot.  
> 
> Agreed.
> 
> > But it suddenly dawns on me that you're assigning a Radeon HD 7790,
> > which is one of the many AMD GPUs which is plagued by reset problems.
> > I wonder if that's a factor there.  This particular GPU even has
> > special handling in QEMU to try to manually reset the device, and which
> > likely has never been tested since adding runtime power management
> > support.  In fact, I'm surprised anyone is doing regular device
> > assignment with an HD 7790 and considers it a normal, acceptable
> > experience even with the QEMU workarounds.  
> 
> I had no idea. I always assumed that because it worked out of the box
> ever since I first tried passing it through, it wasn't affected by these
> reset issues. I never had any trouble with it until now.

IIRC, so long as the VM is always booting and cleanly shutting down,
then the QEMU quirk is sufficient, but if you need to kill QEMU the GPU
might be in a bad state that requires a host reboot to recover.

> > I certainly wouldn't feel comfortable proposing a quirk for the
> > downstream port to disable D3hot for an issue only seen when assigning
> > a device with such a nefarious background relative to device
> > assignment.  It does however seem like there are sufficient options in
> > place to work around the issue, either disabling power management at
> > the vfio-pci driver, or specifically for the downstream port via sysfs.
> > I don't really have any better suggestions given our limited ability to
> > test and highly suspect target device.  Any other ideas, Abhishek?
> > Thanks,
> > 
> > Alex  
> 
> This actually gave me an idea on how to check if it's the graphics card
> that's at fault, or if it is QEMU's workarounds.
> 
> I booted up the system as usual and let vfio-pci take over the device.
> Both the device itself and the PCIe port were at D3hot. I manually
> forced the PCIe port to switch to D0, with the GPU remaining at D3hot. I
> then proceeded to start up the VM, and there were no errors in dmesg.
> 
> If it's even possible, it sounds like QEMU might be doing something
> before the PCIe port is (fully?) out of D3hot, and thus the card tries
> to do something which makes the IOMMU unhappy.
> 
> Is there something in either the rpm trace, or elsewhere that can help
> me dig into this further?

That's interesting to find.  There are quirks in the kernel that don't
disable D3hot, but just extend the suspend/resume time.  If you're
slightly comfortable with coding and building the kernel, you could try
something like below.  With the level of information we have, I'd feel
more comfortable only proposing to extend the resume time for the 7790
and not the downstream port, but I've put both in below to play with.

You can comment out one of the DECLARE... lines to disable each.  The 20
value here is in ms and I have no idea what it should be.  There are a
couple quirks that use this 20ms value and a bunch of Intel device IDs
set an equivalent value to 120ms.  Experiment and see if you can find
something that works reliably.  Thanks,

Alex

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 44cab813bf95..d9ae376d9524 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1956,6 +1956,15 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e0, quirk_ryzen_xhci_d3hot);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e1, quirk_ryzen_xhci_d3hot);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1639, quirk_ryzen_xhci_d3hot);
 
+static void quirk_d3hot_test_delay(struct pci_dev *dev)
+{
+	quirk_d3hot_delay(dev, 20);
+}
+/* Radeon HD 7790 */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x665c, quirk_d3hot_test_delay);
+/* Matisse PCIe GPP Bridge Downstream Ports */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x57a3, quirk_d3hot_test_delay);
+
 #ifdef CONFIG_X86_IO_APIC
 static int dmi_disable_ioapicreroute(const struct dmi_system_id *d)
 {

