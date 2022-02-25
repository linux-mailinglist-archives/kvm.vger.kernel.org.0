Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5404C44F6
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbiBYMxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbiBYMxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:53:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D9D175850;
        Fri, 25 Feb 2022 04:52:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C786B82FE1;
        Fri, 25 Feb 2022 12:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22AEC340E7;
        Fri, 25 Feb 2022 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645793568;
        bh=k70Mm1upOxGWmsfQxSUf0akmkVM2raW07xRde9JsJKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T5TGdmUfWYwiM40dkWqh42IVnuCj4XBrMYt/8xkHE3INhGb0RcLcrKgWBpasl5Jco
         ODZYMZ03HmZ6KUnRGTpiSiCixKNgP/lHMkBCJUVWX/denDe4MKXhQws+z9fo7YJHTA
         UqqeN6ei8Wvh5P86Uw9+qrv80O1PbBQjyQEB09TA=
Date:   Fri, 25 Feb 2022 13:52:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        adrian@parity.io, ardb@kernel.org, ben@skyportsystems.com,
        berrange@redhat.com, colmmacc@amazon.com, decui@microsoft.com,
        dwmw@amazon.co.uk, ebiggers@kernel.org, ehabkost@redhat.com,
        graf@amazon.com, haiyangz@microsoft.com, imammedo@redhat.com,
        jannh@google.com, kys@microsoft.com, lersek@redhat.com,
        linux@dominikbrodowski.net, mst@redhat.com, qemu-devel@nongnu.org,
        raduweis@amazon.com, sthemmin@microsoft.com, tytso@mit.edu,
        wei.liu@kernel.org
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <YhjRHW0t/sxjb7Hi@kroah.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220225124848.909093-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 01:48:48PM +0100, Jason A. Donenfeld wrote:
> VM Generation ID is a feature from Microsoft, described at
> <https://go.microsoft.com/fwlink/?LinkId=260709>, and supported by
> Hyper-V and QEMU. Its usage is described in Microsoft's RNG whitepaper,
> <https://aka.ms/win10rng>, as:
> 
>     If the OS is running in a VM, there is a problem that most
>     hypervisors can snapshot the state of the machine and later rewind
>     the VM state to the saved state. This results in the machine running
>     a second time with the exact same RNG state, which leads to serious
>     security problems.  To reduce the window of vulnerability, Windows
>     10 on a Hyper-V VM will detect when the VM state is reset, retrieve
>     a unique (not random) value from the hypervisor, and reseed the root
>     RNG with that unique value.  This does not eliminate the
>     vulnerability, but it greatly reduces the time during which the RNG
>     system will produce the same outputs as it did during a previous
>     instantiation of the same VM state.
> 
> Linux has the same issue, and given that vmgenid is supported already by
> multiple hypervisors, we can implement more or less the same solution.
> So this commit wires up the vmgenid ACPI notification to the RNG's newly
> added add_vmfork_randomness() function.
> 
> It can be used from qemu via the `-device vmgenid,guid=auto` parameter.
> After setting that, use `savevm` in the monitor to save the VM state,
> then quit QEMU, start it again, and use `loadvm`. That will trigger this
> driver's notify function, which hands the new UUID to the RNG. This is
> described in <https://git.qemu.org/?p=qemu.git;a=blob;f=docs/specs/vmgenid.txt>.
> And there are hooks for this in libvirt as well, described in
> <https://libvirt.org/formatdomain.html#general-metadata>.
> 
> Note, however, that the treatment of this as a UUID is considered to be
> an accidental QEMU nuance, per
> <https://github.com/libguestfs/virt-v2v/blob/master/docs/vm-generation-id-across-hypervisors.txt>,
> so this driver simply treats these bytes as an opaque 128-bit binary
> blob, as per the spec. This doesn't really make a difference anyway,
> considering that's how it ends up when handed to the RNG in the end.
> 
> Cc: Adrian Catangiu <adrian@parity.io>
> Cc: Daniel P. Berrangé <berrange@redhat.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
