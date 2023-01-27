Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEEF67EC80
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 18:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbjA0RdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 12:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjA0RdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 12:33:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8ED7BBFD
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 09:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674840731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nV5PVEexFRTCEYgn3s3CxSGrrslwGO/8JvUDWaGn4vs=;
        b=QLUWcDUpbOaMnZTg+LT+Qh+g1h7q344HpaJGTFpWoeyD++JtTbsR2ZCbm2R5DDE1ovKnEb
        namXbacNHvEYD9GLqkjmEiCIUPleYNx3t4ZmhEDlq5biwsS5/jYhxJBQbiU8iOvDrlhOV5
        9myOL/UYF+IvhMaYmEaC814tiUX+cXk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-101-rB5xKTBJPea6tG0ss1k6dg-1; Fri, 27 Jan 2023 12:32:09 -0500
X-MC-Unique: rB5xKTBJPea6tG0ss1k6dg-1
Received: by mail-io1-f70.google.com with SMTP id d22-20020a5d9656000000b00704d3bd8c07so3026629ios.8
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 09:32:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nV5PVEexFRTCEYgn3s3CxSGrrslwGO/8JvUDWaGn4vs=;
        b=zy55B4jqVDiVtsnSSEubdsfpZQhO6Tccn4VSClFrit9h6iZXGkW/ZtYTZ3voZEP2/g
         Nyp9Xn0fWV5RyIK02prpOqI9FFNvMpGDvIcv6FbhOfYoQLtJ5WI+3PVHiWgmEMX62CK7
         NdV5oQp2Eiq3PZOz2v40MVc0umk6FFBVqK6oa2a0uBeFRgK14ZP+QgDXa4zxLABuDTL+
         8MAjkQElaLkS0dftq0Y+ZV1uorG8xnUJDcvWiCK6VhwV4aM4bNo4aog6GK58YJqc1VXW
         4ngHQUIMtUI8bVXywqsboJQj+QeMvpeHqDeNMZKrTFC8pHE2NAqQKhFjTIJXgsQXYe//
         wZ5w==
X-Gm-Message-State: AO0yUKXmJXTWxB6/70GuEo9RBf/I+4SnebaLL1YZo3tSR1435PU1yCSa
        XiMlD2O5sbT4LENj+OnD4tlKcP/UuptoWKQrH88Bz9mdSNNmEobC1QCNYhl6rp6z3NcR6lTJc/l
        pLasAhRk6v6jm
X-Received: by 2002:a92:c54f:0:b0:310:af8b:aaa2 with SMTP id a15-20020a92c54f000000b00310af8baaa2mr6736918ilj.15.1674840729113;
        Fri, 27 Jan 2023 09:32:09 -0800 (PST)
X-Google-Smtp-Source: AK7set/wdRa6G/aQBqbaoXHP3HPpOxGpFgvsam+eJRxv1rG1uSYBts+PXV4F7K1rY6E8MFQq+MQHdA==
X-Received: by 2002:a92:c54f:0:b0:310:af8b:aaa2 with SMTP id a15-20020a92c54f000000b00310af8baaa2mr6736905ilj.15.1674840728808;
        Fri, 27 Jan 2023 09:32:08 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p15-20020a92c60f000000b0031095196189sm1406006ilm.54.2023.01.27.09.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 09:32:07 -0800 (PST)
Date:   Fri, 27 Jan 2023 10:32:05 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, sglee97@dankook.ac.kr
Subject: Re: [Bug 216970] New: When VM using vfio-pci driver to pci device
 passthrough, host can access VM's pci device with libpciaccess library.
Message-ID: <20230127103205.50795e59.alex.williamson@redhat.com>
In-Reply-To: <20230127171502.GA1388740@bhelgaas>
References: <bug-216970-41252@https.bugzilla.kernel.org/>
        <20230127171502.GA1388740@bhelgaas>
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

On Fri, 27 Jan 2023 11:15:02 -0600
Bjorn Helgaas <helgaas@kernel.org> wrote:

> On Fri, Jan 27, 2023 at 09:02:25AM +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=216970
> > 
> >             Bug ID: 216970
> >            Summary: When VM using vfio-pci driver to pci device
> >                     passthrough, host can access VM's pci device with
> >                     libpciaccess library.  
> 
> > Created attachment 303656  
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=303656&action=edit  
> > Upload text data to vfio-pci passthrough GPU VRAM with using nvatools
> > 
> > 1) Release of Ubuntu
> >   Host - Ubuntu 20.04.5 LTS / Release : 20.04
> >   Guest - Ubuntu 18.04.6 LTS / Release : 18.04
> > 
> > 2) Kernel version
> >   Host - 5.15.0-57-generic
> >   Guest - 5.4.0-137-generic
> > 
> > 3) Version of the package
> > libpciaccess0:
> >   Installed: 0.16-0ubuntu1
> >   Candidate: 0.16-0ubuntu1
> > 
> > libpciaccess-dev:
> >   Installed: 0.16-0ubuntu1
> >   Candidate: 0.16-0ubuntu1
> > 
> > 4) Expected to happen
> > When the virtual machine is running, the Host could not access the virtual
> > machine's pci passthrough device via libpciaccess.
> > 
> > 5) Happened instead
> > When the virtual machine is running, the host can access the virtual machine's
> > pci passthrough device via libpciaccess.
> > 
> > In this case, host can interrupt passthrough pci device, or access passthrough
> > pci device memory to leak virtual machine data.
> > 
> > We checked this by creating a virtual machine using vfio-pci passthrough GPU in
> > QEMU.
> > 
> > In addition, when running GPU applications such as CUDA in a virtual machine,
> > we found that data inside passthrough GPU VRAM can be accessed from the host
> > via libpciaccess(nvatools).
> > 
> > We proceeded as follows.
> >  1. Create and run VMs with vfio-pci passthrough GPU.
> > 
> >  2. Upload text data from the host via nvatools to the VRAM on the passthrough
> > GPU.
> > 
> >  3. The VM can see the text data in the GPU VRAM.  
> 
> I'm not really familiar with libpciaccess or nvatools, but it looks
> like they do both PCI config accesses and MMIO access to PCI BARs.
> 
> I expect both types of access to work for the host, even for devices
> passed through to a guest.  The VFIO folks can correct me if there's
> some mechanism to prevent the host from accessing these devices.

Yes, this is expected.  The host would need privileged access in order
to interfere or access assigned device data.  Sounds like this is
looking more for confidential computing type protection, which like
protecting VM memory from host access, requires specific technologies
that are under development.  Thanks,

Alex

