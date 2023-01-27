Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6E67EC3F
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 18:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjA0RPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 12:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbjA0RPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 12:15:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217851F92C;
        Fri, 27 Jan 2023 09:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFEDDB8215A;
        Fri, 27 Jan 2023 17:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CBCC433EF;
        Fri, 27 Jan 2023 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674839704;
        bh=+FwUO0JZnmGc3lcmdy8rNaYdZxIpnVfIlXHCKZ646Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Z7osOjg6I9zdxSBd08l1XGlDTd/qRCvGzxjzXYgYbVHX5yAEDG4uUmjp/GwUI5p92
         UKDfzv5osf07X/TX0HdBQxNOhx0SXvZBESUb2w551GfLFc/vn3q/cG/10K7uNFicRJ
         dbSisYbdwAHnQu0ca6hw4yDgLLws4hR8nrJ6jH1uN3KElYMnrfzLP0Dh/TcZBbOVVO
         h1HI+Rhd5xsynz9/ZSEmc4BEuO39vd1PyjuFDe4643BiTqeclqodjfNkskoqjPX6qq
         mnB1WJ8/UxeQSraJFW9I0j7F2/VLY3t+A//wOpBq6hvBmc98Wf4cgCJotr1HftZ1Lo
         AT2ehK4BqqBBQ==
Date:   Fri, 27 Jan 2023 11:15:02 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, sglee97@dankook.ac.kr
Subject: Re: [Bug 216970] New: When VM using vfio-pci driver to pci device
 passthrough, host can access VM's pci device with libpciaccess library.
Message-ID: <20230127171502.GA1388740@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216970-41252@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 09:02:25AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216970
> 
>             Bug ID: 216970
>            Summary: When VM using vfio-pci driver to pci device
>                     passthrough, host can access VM's pci device with
>                     libpciaccess library.

> Created attachment 303656
>   --> https://bugzilla.kernel.org/attachment.cgi?id=303656&action=edit
> Upload text data to vfio-pci passthrough GPU VRAM with using nvatools
> 
> 1) Release of Ubuntu
>   Host - Ubuntu 20.04.5 LTS / Release : 20.04
>   Guest - Ubuntu 18.04.6 LTS / Release : 18.04
> 
> 2) Kernel version
>   Host - 5.15.0-57-generic
>   Guest - 5.4.0-137-generic
> 
> 3) Version of the package
> libpciaccess0:
>   Installed: 0.16-0ubuntu1
>   Candidate: 0.16-0ubuntu1
> 
> libpciaccess-dev:
>   Installed: 0.16-0ubuntu1
>   Candidate: 0.16-0ubuntu1
> 
> 4) Expected to happen
> When the virtual machine is running, the Host could not access the virtual
> machine's pci passthrough device via libpciaccess.
> 
> 5) Happened instead
> When the virtual machine is running, the host can access the virtual machine's
> pci passthrough device via libpciaccess.
> 
> In this case, host can interrupt passthrough pci device, or access passthrough
> pci device memory to leak virtual machine data.
> 
> We checked this by creating a virtual machine using vfio-pci passthrough GPU in
> QEMU.
> 
> In addition, when running GPU applications such as CUDA in a virtual machine,
> we found that data inside passthrough GPU VRAM can be accessed from the host
> via libpciaccess(nvatools).
> 
> We proceeded as follows.
>  1. Create and run VMs with vfio-pci passthrough GPU.
> 
>  2. Upload text data from the host via nvatools to the VRAM on the passthrough
> GPU.
> 
>  3. The VM can see the text data in the GPU VRAM.

I'm not really familiar with libpciaccess or nvatools, but it looks
like they do both PCI config accesses and MMIO access to PCI BARs.

I expect both types of access to work for the host, even for devices
passed through to a guest.  The VFIO folks can correct me if there's
some mechanism to prevent the host from accessing these devices.

Bjorn
