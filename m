Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8361D9D29
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgESQrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 12:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbgESQrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 12:47:05 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84AFF2081A;
        Tue, 19 May 2020 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589906825;
        bh=/IEau0/2D99lWXstXA0V7RFsI5IUWsbfwV/C/SWP7D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAAxzgtw7mBaHu8MdoLi59Ouf6eanaGElAIo6dLQ9buPIwJB78pC3o/GEHiZTOoiI
         sruCjd3kIpbyrDBQw0MQpJZceZHx+Pm4F1CaomGd6siQ/8h0aM9vLu7wH3tXLaoqH3
         lUn88Ypjj4uWmi7Ep7cwq6yO+TlaSLUItXJhbGGI=
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        sami.mujawar@arm.com, andre.przywara@arm.com,
        lorenzo.pieralisi@arm.com, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Subject: Re: [PATCH v4 kvmtool 00/12] Add reassignable BARs
Date:   Tue, 19 May 2020 17:46:57 +0100
Message-Id: <158990628245.2471.9765486874976576804.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 16:38:17 +0100, Alexandru Elisei wrote:
> kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
> it from trying to reassign the BARs. Let's make the BARs reassignable so we
> can get rid of this band-aid.
> 
> During device configuration, Linux can assign a region resource to a BAR
> that temporarily overlaps with another device. This means that the code
> that emulates BAR reassignment must be aware of all the registered PCI
> devices. Because of this, and to avoid re-implementing the same code for
> each emulated device, the algorithm for activating/deactivating emulation
> as BAR addresses change lives completely inside the PCI code. Each device
> registers two callback functions which are called when device emulation is
> activated (for example, to activate emulation for a newly assigned BAR
> address), respectively, when device emulation is deactivated (a previous
> BAR address is changed, and emulation for that region must be deactivated).
> 
> [...]

Applied to kvmtool (master), thanks!

[01/12] ioport: mmio: Use a mutex and reference counting for locking
        https://git.kernel.org/will/kvmtool/c/09577ac58fef
[02/12] pci: Add helpers for BAR values and memory/IO space access
        https://git.kernel.org/will/kvmtool/c/2f6384f924d7
[03/12] virtio/pci: Get emulated region address from BARs
        https://git.kernel.org/will/kvmtool/c/e539f3e425fb
[04/12] vfio: Reserve ioports when configuring the BAR
        https://git.kernel.org/will/kvmtool/c/a05e576f7fd8
[05/12] pci: Limit configuration transaction size to 32 bits
        https://git.kernel.org/will/kvmtool/c/6ea32ebdb84b
[06/12] vfio/pci: Don't write configuration value twice
        https://git.kernel.org/will/kvmtool/c/e1d0285c89ae
[07/12] Don't allow more than one framebuffers
        https://git.kernel.org/will/kvmtool/c/cbf3d16fccba
[08/12] pci: Implement callbacks for toggling BAR emulation
        https://git.kernel.org/will/kvmtool/c/5a8e4f25dd7b
[09/12] pci: Toggle BAR I/O and memory space emulation
        https://git.kernel.org/will/kvmtool/c/46e04130d264
[10/12] pci: Implement reassignable BARs
        https://git.kernel.org/will/kvmtool/c/465edc9d0fab
[11/12] arm/fdt: Remove 'linux,pci-probe-only' property
        https://git.kernel.org/will/kvmtool/c/ad5e9056de0c
[12/12] vfio: Trap MMIO access to BAR addresses which aren't page aligned
        https://git.kernel.org/will/kvmtool/c/b4fc4f605fc6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
