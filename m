Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8995724ED2
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 23:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbjFFVcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 17:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbjFFVb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 17:31:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D010D1
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 14:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686087063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VJ+V0Hfruw/Wph/fU0GpZA9OwC0hrRZ/Fau+4kHL1KQ=;
        b=Yt9eTcw+j8aojLBD7Q4iXdf4jnOwGQ4TNd3o3QxzLKKGFqYqsnboKYcwBbj+WXA2j455cr
        DJRfdyQPBGbL2uA0g4d9dIzIiLWbG7LNYAJrgBcSeLeJSenm7PToK/76xdsezxqyE3KaIU
        9YGeeu3dJj+HoqsEZQzCk2lD9kKs9eg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-3DMMkx8UOB2DJlaEkoluYQ-1; Tue, 06 Jun 2023 17:31:01 -0400
X-MC-Unique: 3DMMkx8UOB2DJlaEkoluYQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-76ce93a10f3so438897339f.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 14:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686087061; x=1688679061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VJ+V0Hfruw/Wph/fU0GpZA9OwC0hrRZ/Fau+4kHL1KQ=;
        b=lsV2EsH5MF8BLcKt7IXZGc1mTR6ajGmCv/cMxvWP2zVBOMWXFUa4rM/6j/liPH7QrP
         M1ctn18/d7H+d+qLiwzcIXDLwhu8GNmpx6hMFRdxSX8GN3e+EAyGqoXA4Y4RDSTQ0lzw
         og98FbIE+97eGg1HpHeYvjPSPQidaJWD6tC7O/kdszGN5y3xFhDyeOxbB3g/pd4vLspG
         L82eGfRg1T29s2zCSZ+HKZ9VbnNHSLC7cbScMLNK5b/pImAoIAXBTlNJVo2/EUu4amjW
         BNoSqcXg32WYiq5fsFCPfExjmdYpkFzTP9yXgS2G/kkHUeJ+5wQoJ+MDcQfrg/RN9HGD
         TkiA==
X-Gm-Message-State: AC+VfDyltwkYS4jwMvZcW06PSwuxJ6WThW8iyc9qpg5eJBKMviTEfLV6
        umMdpG8To3UvjKu9jcTIkurJ36dd5ay//CujIDtrUfMjAl5r3fHYwRnw09lFnWoz2801Dd2N32A
        +i11v1Lttun7m
X-Received: by 2002:a6b:4f19:0:b0:779:1e26:2fef with SMTP id d25-20020a6b4f19000000b007791e262fefmr4026387iob.0.1686087060964;
        Tue, 06 Jun 2023 14:31:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7QaU6RMqVU5lKsAiUvzQ4Uq2Ly0rnNBLXej0nHlQ68rfp0rLwzgi7nQooX1tyDOrPwAZjWkA==
X-Received: by 2002:a6b:4f19:0:b0:779:1e26:2fef with SMTP id d25-20020a6b4f19000000b007791e262fefmr4026377iob.0.1686087060658;
        Tue, 06 Jun 2023 14:31:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k9-20020a6b3c09000000b00774efe6fa24sm3354498iob.10.2023.06.06.14.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 14:31:00 -0700 (PDT)
Date:   Tue, 6 Jun 2023 15:30:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230606153057.4cbc36a0.alex.williamson@redhat.com>
In-Reply-To: <ZH+DdVIyZ6hHCDaK@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
        <20230606083238.48ea50e9.alex.williamson@redhat.com>
        <ZH9RfXhbuED2IUgJ@nvidia.com>
        <20230606110510.0f87952c.alex.williamson@redhat.com>
        <ZH9p+giEs6bCYfw8@nvidia.com>
        <20230606121348.670229ff.alex.williamson@redhat.com>
        <ZH+DdVIyZ6hHCDaK@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Jun 2023 16:05:25 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 06, 2023 at 12:13:48PM -0600, Alex Williamson wrote:
> > On Tue, 6 Jun 2023 14:16:42 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Jun 06, 2023 at 11:05:10AM -0600, Alex Williamson wrote:
> > >   
> > > > It actually seems more complicated this way.  We're masquerading this
> > > > region as a BAR, but then QEMU needs to know based on device IDs that
> > > > it's really not a BAR, it has special size properties, mapping
> > > > attributes, error handling, etc.      
> > > 
> > > This seems like something has gone wrong then. ie the SIGUBS error
> > > handling stuff should be totally generic in the qemu side. Mapping
> > > attributes are set by the kernel, qemu shouldn't know, doesn't need to
> > > know.  
> > 
> > You asked me to look at the v1 posting to see why there's so much more
> > going on here than a quirk.  That's what I read from the first public
> > posting, a coherent memory region masqueraded as a BAR which requires
> > different memory mapping and participates in ECC.  I agree that the
> > actual mapping is done by the kernel, but it doesn't really make a
> > difference if that's a vfio-pci variant driver providing a different
> > mmap callback for a BAR region or a device specific region handler.  
> 
> The ECC stuff is generic too.
> 
> Even the non-power-2 size thing is *generic*, even if isn't following
> PCI SIG.

Generic yes, but exposing a non-power-of-2 size region for a BAR is...
well, wrong.

> > > The size issue is going to a be a problem in future anyhow, I expect
> > > some new standards coming to support non-power-two sizes and they will
> > > want to map to PCI devices in VMs still.  
> > 
> > Ok, but a PCI BAR has specific constraints and a non-power-of-2 BAR is
> > not software compatible with those constraints.  That's obviously not
> > to say that a new capability couldn't expose arbitrary resources sizes
> > on a PCI-like device though.  I don't see how a non-power-of-2 BAR at
> > this stage helps or fits within any spec, which is exactly what's
> > being proposed through this BAR masquerade.  
> 
> To emulate PCI, someone, somewhere, has to fix this mismatch up.
> 
> So given choices
>   1) Qemu sees a special NVIDIA thing and fixes it
>   2) Qemu sees a VFIO_PCI_BAR0_REGION with an odd size and fixes it
>   3) Kernel lies and makes a power-2 size and it fixes it
> 
> 2 seems the most forward looking and reusable.

What?!  It's not just a matter of fixing it.  The vfio-pci uAPI should
never return a BAR region that's not compatible as a BAR.  It's
incorrectly sized, it does special things with mmap under the covers,
and it doesn't honor the memory enable bit.  And then QEMU goes on to
ignore this peculiarity when setting up all the ACPI features, instead
relying on the PCI vendor/device ID when it could be using a device
specific region to initiate that support.

> I definately don't think this is important enough to stick a vendor
> label on it.

How high is the bar for a device specific region?  This certainly looks
and smells like one to me.

> Broadly, we are looking toward a way for the kernel VFIO variant
> driver to provide the majority of the "PCI emulation" and the VMM can
> be general. It is not nice if every PCI emulation type driver needs
> unique modifications to the VMM to support it. We are planning more
> than one of these things already, and there are industry standards
> afoot that will widly open the door here.

Meanwhile every VMM needs a hook to extend non-compliant BAR sizes,
assuming the kernel will fixup mappings beyond the region extent, and
pretend that none of this is a device bug?  It really is a very small
amount of code in QEMU to setup a MemoryRegion based on a device
specific region and register it as a PCI BAR.  The non-standard size is
a factor here when mapping to the VM address space, but I'm a bit
surprised to hear an argument for hacking that in the kernel rather
than userspace.

> > > It seems OK to me if qemu can do this generically for any "BAR"
> > > region, at least creating an entire "nvidia only" code path just for
> > > non power 2 BAR sizing seems like a bad ABI choice.  
> > 
> > Have you looked at Ankit's QEMU series?   
> 
> Not well, I haven't seen any versions of it till it was posted
> 
> > It's entirely NVIDIA-only code paths.  Also nothing here precludes
> > that shared code in QEMU might expose some known arbitrary sized
> > regions as a BAR, or whatever spec defined thing allows that in the
> > future.  
> 
> It should not be like that. From a kernel perspective this is
> basically all generic VMM code that can apply to any VFIO driver. The
> kernel side was ment to be a general purpose API for the VMM.
> 
> The only special bit is emulating the weird Grace FW ACPI stuff.

And a device specific region seems like the ideal jumping off point to
create that memory-only node for this thing.
 
> > > > coherent memory which requires use of special mapping attributes vs a
> > > > standard PCI BAR and participates in ECC.  All of which seems like it
> > > > would be easier to setup in QEMU if the vfio-pci representation of the
> > > > device didn't masquerade this regions as a standard BAR.  In fact it
> > > > also reminds me of NVlink2 coherent RAM on POWER machines that was
> > > > similarly handled as device specific regions.      
> > > 
> > > It wasn't so good on POWER and if some of that stuff has been done
> > > more generally we would have been further ahead here..  
> > 
> > Specifics?  Nothing here explained why masquerading the coherent memory
> > as a BAR in the vfio-pci ABI is anything more than a hack that QEMU
> > could assemble on its own with a device specific region.  Thanks,  
> 
> Well, we deleted all the POWER stuff and got nothing general out of
> it. Isn't that enough to say it was a bad idea? Here we are again with
> the same basic CXLish hardware design and the answer should not be
> keep making more vendor ABI.
> 
> I think this is the direction things are trending in the
> industry. There is nothing particuarlly special, and certainly nothing
> *nvidia specific* about these things.
> 
> So lets find a way to give these things appropriate generic names at
> the ABI level please..

What is the generic feature that "these things" implement?

There's a lot of vendor specific things going on here.  Not only is all
that "weird Grace FW ACPI stuff" based on this region, but also if we
are exposing it as a BAR, which BAR index(s) for a given device.

If "the industry" does come out with a spec for "these things",
couldn't QEMU optionally plug a device specific region into the
implementation of that spec, potentially along with some commonly
defined region to make this device appear to honor that new spec?
Versus with the in-kernel variant driver masquerading the BAR, we're
stuck with what the kernel implements.  Would future hardware
implementing to this new spec require a variant driver or would we
extend vfio-pci to support them with extended regions and expect the
VMM to compose them appropriately?  Thanks,

Alex

