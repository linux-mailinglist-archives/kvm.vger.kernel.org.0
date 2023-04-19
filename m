Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A1F6E83DC
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 23:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjDSVjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 17:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjDSVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 17:39:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E651736
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 14:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681940290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqqRZHP28AKreJPHuhkGouAT+TmrF/0x0xX/UpbfWDw=;
        b=dIUb5Dbae62OgZ1tLvBDdW1z0E2b5fEG9w/iD3qJbuSSVV+ym1NswxIz9kPQ3N3Ee3EJf/
        2sH8CYUrERJni3kVOU8VYoKmsb6Si6XqMDfRmZeilY6N+mZFOE1srTLabjNsgUqXuEKkuc
        aUkTFU74b7SY4RyGNU9k43YbEJbCS6I=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-LQb3J34FO_2ohy2zMCYx7A-1; Wed, 19 Apr 2023 17:38:08 -0400
X-MC-Unique: LQb3J34FO_2ohy2zMCYx7A-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-32b5fe8ab73so1333705ab.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 14:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681940288; x=1684532288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AqqRZHP28AKreJPHuhkGouAT+TmrF/0x0xX/UpbfWDw=;
        b=WGh7cdRFyEnHTWSAqd4J3DLxKqJd1KPchIGnebM6HuoU5beM0QE8nxg3psfYdKx1mi
         tchYUfNU2sMzJfEFHiSwJJntoQV7J8c5YtnRw/WxdFOnQ0sJ6cmnKlvIVv/iNWJ0ANhS
         41XDmdnaSIqDMTB4tp7yXdACCz08z4Wq0PSPILK8WyBRYF45b2ZvJMIu0OhCaj/ux9RD
         QbhjcArmAdEfM/hEjjbKbUXKei4PdsqvAyzWtTvIDDNSPe7aytyYMoxn2ca2CBqVTyYY
         Y4WyyvD6AurunngzkDPAu5Jv2KWE/3cWxCENB5zW4zwZFLQjyAJwq1iEqAa7aY7SCNcF
         hUag==
X-Gm-Message-State: AAQBX9e61mT6hX3MLIzPQvPHDiMfvAJLHkvliCTZ73pg1sFgC1ue4eK+
        H6Hwn+BpKWIRaWTfeveAaxqMi/UyoiTzaVIqk808c0TPoMaM/iZ9sMsyStIDrp07czQAPTNLt9V
        3tJ++aJrrjiZY
X-Received: by 2002:a05:6e02:5d2:b0:324:7d63:8622 with SMTP id l18-20020a056e0205d200b003247d638622mr1145194ils.2.1681940288049;
        Wed, 19 Apr 2023 14:38:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350b0jIdF8z68z0PYApH3f58gNSV3vui25zvEUqgVcQEqVvklD9dHd4IZDMWM8Sq/nH1vfP2PVg==
X-Received: by 2002:a05:6e02:5d2:b0:324:7d63:8622 with SMTP id l18-20020a056e0205d200b003247d638622mr1145181ils.2.1681940287751;
        Wed, 19 Apr 2023 14:38:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n4-20020a056638210400b0040d9a3d54desm4743jaj.170.2023.04.19.14.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 14:38:06 -0700 (PDT)
Date:   Wed, 19 Apr 2023 15:38:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 09/10] vfio/pci: Support dynamic MSI-X
Message-ID: <20230419153804.7ad0b122.alex.williamson@redhat.com>
In-Reply-To: <f0d22db8-213d-92f7-963a-9d015c0a9d79@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
        <86cda5cf2742feff3b14954284fb509863355050.1681837892.git.reinette.chatre@intel.com>
        <20230418163829.149e8881.alex.williamson@redhat.com>
        <f0d22db8-213d-92f7-963a-9d015c0a9d79@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 11:13:29 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 4/18/2023 3:38 PM, Alex Williamson wrote:
> > On Tue, 18 Apr 2023 10:29:20 -0700
> > Reinette Chatre <reinette.chatre@intel.com> wrote:
> >   
> >> Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
> >> enables an individual MSI-X interrupt to be allocated and freed after
> >> MSI-X enabling.
> >>
> >> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
> >> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
> >> the time a valid eventfd is assigned. This is different behavior from
> >> a range provided during MSI-X enabling where interrupts are allocated
> >> for the entire range whether a valid eventfd is provided for each
> >> interrupt or not.
> >>
> >> Do not dynamically free interrupts, leave that to when MSI-X is
> >> disabled.  
> > 
> > But we do, sometimes, even if essentially only on the error path.  Is
> > that worthwhile?  It seems like we could entirely remove
> > vfio_msi_free_irq() and rely only on pci_free_irq_vectors() on MSI/X
> > teardown.  
> 
> Yes, it is only on the error path where dynamic MSI-X interrupts are
> removed. I do not know how to determine if it is worthwhile. On the
> kernel side failure seems unlikely since it would mean memory cannot
> be allocated or request_irq() failed. In these cases it may not be
> worthwhile since user space may try again and having the interrupt
> already allocated would be helpful. The remaining error seems to be
> if user space provided an invalid eventfd. An allocation in response
> to wrong user input is a concern to me. Should we consider
> buggy/malicious users? I am uncertain here so would defer to your
> guidance.

I don't really see that a malicious user can exploit anything here,
their irq allocation is bound by the device support and they're
entitled to make use of the full vector set of the device by virtue of
having ownership of the device.  All the MSI-X allocated irqs are freed
when the interrupt mode is changed or the device is released regardless.

The end result is also no different than if the user had not configured
the vector when enabling MSI-X or configured it and later de-configured
with a -1 eventfd.  The irq is allocated but not attached to a ctx.
We're intentionally using this as a cache.

Also, as implemented here in v3, we might be freeing from the original
allocation rather than a new, dynamically allocated irq.

My thinking is that if we think there's a benefit to caching any
allocated irqs, we should do so consistently.  We don't currently know
if the irq was allocated now or previously.  Tracking that would add
complexity for little benefit.  The user can get to the same end result
of an allocated, unused irq in numerous way, the state itself is not
erroneous, and is actually in support of caching irq allocations.
Removing the de-allocation of a single vector further simplifies the
code as there exists only one path where irqs are freed, ie.
pci_free_irq_vectors().

So I'd lean towards removing vfio_msi_free_irq().
 
> > I'd probably also add a comment in the commit log about the theory
> > behind not dynamically freeing irqs, ie. latency, reliability, and
> > whatever else we used to justify it.  Thanks,  
> 
> Sure. How about something like below to replace the final sentence of
> the changelog:
> 
> "When a guest disables an interrupt, user space (Qemu) does not
> disable the interrupt but instead assigns it a different trigger. A
> common flow is thus for the VFIO_DEVICE_SET_IRQS ioctl() to be 
> used to assign a new eventfd to an already enabled interrupt. Freeing
> and re-allocating an interrupt in this scenario would add unnecessary
> latency as well as uncertainty since the re-allocation may fail. Do
> not dynamically free interrupts when an interrupt is disabled, instead
> support a subsequent re-enable to draw from the initial allocation when
> possible. Leave freeing of interrupts to when MSI-X is disabled."

There are other means besides caching irqs that could achieve the above,
for instance if a trigger is simply swapped from one eventfd to another,
that all happens within vfio_msi_set_vector_signal() where we could
hold the irq for the transition.

I think I might justify it as:

	The PCI-MSIX API requires that some number of irqs are
	allocated for an initial set of vectors when enabling MSI-X on
	the device.  When dynamic MSIX allocation is not supported, the
	vector table, and thus the allocated irq set can only be resized
	by disabling and re-enabling MSIX with a different range.  In
	that case the irq allocation is essentially a cache for
	configuring vectors within the previously allocated vector
	range.  When dynamic MSIX allocation is supported, the API
	still requires some initial set of irqs to be allocated, but
	also supports allocating and freeing specific irq vectors both
	within and beyond the initially allocated range.

	For consistency between modes, as well as to reduce latency and
	improve reliability of allocations, and also simplicity, this
	implementation only releases irqs via pci_free_irq_vectors()
	when either the interrupt mode changes or the device is
	released.

Does that cover the key points for someone that might want to revisit
this decision later?  Thanks,

Alex

