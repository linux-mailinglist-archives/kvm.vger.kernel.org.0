Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC2318A778
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 22:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgCRV6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 17:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRV6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 17:58:53 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EADC32076C;
        Wed, 18 Mar 2020 21:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584568732;
        bh=fwb6/1fl+qNWmdBmMiFQ8pSoakKvLGgyes9mRnF7u2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iXspVkpnNVO09YFjhzaEWdYDvt1usZAPfrJ2RQL2f3zpxwByHpOjc+QPpyTTvVNJk
         fRhTMX4fIg5OHKVaB9/BPg0aRQySOWuEoOw7OAhLKWd5kSRxpBkRoywrWBYZu7OK+B
         PAINfI9FfrQ0FVsS9z4hGvsl96KHzUXa3BOIlzVk=
Date:   Wed, 18 Mar 2020 21:58:47 +0000
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
Message-ID: <20200318215847.GC8477@willie-the-truck>
References: <20200221165532.90618-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221165532.90618-1-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 04:55:32PM +0000, Andre Przywara wrote:
> From: Raphael Gault <raphael.gault@arm.com>
> 
> The EDK II UEFI firmware implementation requires some storage for the EFI
> variables, which is typically some flash storage.
> Since this is already supported on the EDK II side, we add a CFI flash
> emulation to kvmtool.
> This is backed by a file, specified via the --flash or -F command line
> option. Any flash writes done by the guest will immediately be reflected
> into this file (kvmtool mmap's the file).
> The flash will be limited to the nearest power-of-2 size, so only the
> first 2 MB of a 3 MB file will be used.
> 
> This implements a CFI flash using the "Intel/Sharp extended command
> set", as specified in:
> - JEDEC JESD68.01
> - JEDEC JEP137B
> - Intel Application Note 646
> Some gaps in those specs have been filled by looking at real devices and
> other implementations (QEMU, Linux kernel driver).
> 
> At the moment this relies on DT to advertise the base address of the
> flash memory (mapped into the MMIO address space) and is only enabled
> for ARM/ARM64. The emulation itself is architecture agnostic, though.
> 
> This is one missing piece toward a working UEFI boot with kvmtool on
> ARM guests, the other is to provide writable PCI BARs, which is WIP.
> 
> Signed-off-by: Raphael Gault <raphael.gault@arm.com>
> [Andre: rewriting and fixing]
> Signed-off-by: Andre Przywra <andre.przywara@arm.com>
> ---
> Hi,
> 
> an update fixing Alexandru's review comments (many thanks for those!)
> The biggest change code-wise is the split of the MMIO handler into three
> different functions. Another significant change is the rounding *down* of
> the present flash file size to the nearest power-of-two, to match flash
> hardware chips and Linux' expectations.

Alexandru -- are you happy with this now?

Will
