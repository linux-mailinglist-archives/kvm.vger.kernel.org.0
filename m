Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3944B717A
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbiBOPyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 10:54:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiBOPyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 10:54:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20FC29E540
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644940440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNlBcghVIbXcjbdtG1zkQAj56teK/2eSJvPlxSHmjnA=;
        b=JXb44A3VwoYT2uCOHM+9NvIgKNSjnTEAcrXjM/STpZhQahbGUoxkBDqviDLwHC6E96vuxq
        xMbzF2fgFVNr1IYepyMY66rnR+MIBxKFdnv8jN8WNS+/Zh0/JL6HWpNXTxveHyZ2tU2kYZ
        of6PlEtH+QqYL37mPAfW0R8QAz7LAog=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-XD0qOKU0Nk6ce3IRq3EURQ-1; Tue, 15 Feb 2022 10:53:59 -0500
X-MC-Unique: XD0qOKU0Nk6ce3IRq3EURQ-1
Received: by mail-ed1-f70.google.com with SMTP id o8-20020a056402438800b00410b9609a62so78348edc.3
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:53:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YNlBcghVIbXcjbdtG1zkQAj56teK/2eSJvPlxSHmjnA=;
        b=F5FaD515wONo9DLRusHmoKoLJY1otfs2EzF+mV29DRjBnGI83KhoYlxEEKXstlx8H0
         QfcMLdr+z6Wd1QRrnJzk8BuydLFoslg/khCzQhdXubdOyk2xycCbobtYdJu1FXI5dnga
         2qyE2eCmMosKbYHhAwgBaYYbhBmU4Ry2PKmQq5tUACFYCEsWX09Lr5J/yhm5VZfMfAqw
         4kesPS0WlPLco6Ceh/tLrdx3zANhrIc9E6FbixAZosmAM1cM5y59UR5nrCknAcRfYPdc
         JKuryOmEU4CpbIX3mEfXTsa/+MJpTBgE+gQuyAEWSHnpSmcGcoBDl/57GU4qOK639GNq
         xrxw==
X-Gm-Message-State: AOAM533aAOhg44RYmkLBZ3uUoeFWpkl7t0hMrVFWCBdS/PRN8KKgKvsH
        0kHlsUBQirCrlTqAs0NFcN8qpoGmKNpIWF0Q8oGxW1fztwq9AF9AHHx+GzmkDNOyUeETpq6y3ii
        wReI+DFivCG8S
X-Received: by 2002:a17:906:7a43:: with SMTP id i3mr3427403ejo.29.1644940436547;
        Tue, 15 Feb 2022 07:53:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7Ctv27R5bcugasYl/d033ryaYnKxqBpvltKrcvwV/bfqkNXFoCim4i9DPb/SUeRkW99XEUA==
X-Received: by 2002:a17:906:7a43:: with SMTP id i3mr3427387ejo.29.1644940436307;
        Tue, 15 Feb 2022 07:53:56 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id s3sm59600edd.82.2022.02.15.07.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 07:53:55 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:53:53 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220215155353.t5hj7t3i43dj5mkw@gator>
References: <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
 <YgqBPSV+CMyzfNlv@monolith.localdoman>
 <87k0dx4c23.wl-maz@kernel.org>
 <20220215073212.fp5lh4gfxk7clwwc@gator>
 <Ygt7PbS6zW9H1By4@monolith.localdoman>
 <20220215125300.6b5ff3luxikc4jhd@gator>
 <Ygu1q6r4oalKzn0H@monolith.localdoman>
 <YgvFGDEeMKqNldp1@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgvFGDEeMKqNldp1@monolith.localdoman>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 03:22:00PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Tue, Feb 15, 2022 at 02:16:32PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Tue, Feb 15, 2022 at 01:53:00PM +0100, Andrew Jones wrote:
> > > On Tue, Feb 15, 2022 at 10:07:16AM +0000, Alexandru Elisei wrote:
> > > > 
> > > > I've started working on the next iteration of the kvmtool test
> > > > runner support series, I'll do my best to make sure kvmtool wll be able to run
> > > > the tests when kvm-unit-tests has been configured with --arch=arm.
> > > >
> > > 
> > > Excellent!
> > > 
> > > BTW, I went ahead an pushed a patch to misc/queue to improve the initrd
> > > address stuff
> > > 
> > > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/6f8f74ed2d9953830a3c74669f25439d9ad68dec
> > > 
> > > It may be necessary for you if kvmtool shares its fdt creation between
> > > aarch64 and aarch32 guests, emitting 8 byte initrd addresses for both,
> > > even though the aarch32 guest puts the fdt below 4G.
> > 
> > While trying your patch (it works, but with the caveat below), I remembered that
> > kvmtool is not able to run kvm-unit-tests for arm. That's because the code is
> > not relocatable (like it is for arm64) and the text address is hardcoded in the
> > makefile.
> > 
> > In past, to run the arm tests with kvmtool, I was doing this change:
> > 
> > diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> > index 3a4cc6b26234..6c580b067413 100644
> > --- a/arm/Makefile.arm
> > +++ b/arm/Makefile.arm
> > @@ -14,7 +14,7 @@ CFLAGS += $(machine)
> >  CFLAGS += -mcpu=$(PROCESSOR)
> >  CFLAGS += -mno-unaligned-access
> >  
> > -arch_LDFLAGS = -Ttext=40010000
> > +arch_LDFLAGS = -Ttext=80008000
> >  
> >  define arch_elf_check =
> >  endef
> > 
> > Any suggestions how to fix that? One way would be to change the LDFLAGS based on
> > $TARGET. Another way would be to make the arm tests relocatable, I tried to do
> > that in the past but I couldn't make any progress.
> > 
> > Separate from that, I also tried to run the 32 bit arm tests with run_tests.sh.
> > The runner uses qemu-system-arm (because $ARCH_NAME is arm in
> > scripts/arch-run.bash::search_qemu_binary()), but uses kvm as the accelerator
> > (because /dev/kvm exists in scrips/arch-run.bash::kvm_available()). This fails
> > with the error:
> > 
> > qemu-system-arm: -accel kvm: invalid accelerator kvm
> > 
> > I don't think that's supposed to happen, as kvm_available() specifically returns
> > true if $HOST = aarch64 and $ARCH = arm. Any suggestions?
> 
> I managed to run the arm tests on an arm64 machine using qemu-system-aarch64
> (instead of qemu-system-arm)

Yup

> and passing -cpu host,aarch64=off. I'll try to make
> this into a patch.

The '-cpu host,aarch64=off' part should already be getting added for you
by the arm/run script. Hmm, it just occurred to me that your kvmtool work
may not be using arm/run. Anyway, arm/run may serve as inspiration.

Thanks,
drew

