Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB0489699
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 07:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfHLFIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 01:08:01 -0400
Received: from ozlabs.org ([203.11.71.1]:42347 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfHLFIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 01:08:01 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 466P4H5sBqz9sPL; Mon, 12 Aug 2019 15:07:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565586479; bh=CU/IVBOZY4ovRPGfmMIyzlhYIcx/FjkhGpipSlv0MnU=;
        h=Date:From:To:Cc:Subject:From;
        b=oDvVG3FsOHrDwZDr66JuqL1WwKGgQFW6D2OqL5M32C4J4kpnKhiw0P0bXns46W2s6
         xRO15mubH/r6hBVcJpWjZg/eO8235otESO3Mjc5kZMuDrYA/cn2ZPzj/yZxbNtlxMi
         +jhb4XRyGNz1w4+8kvE9eoG8t3iwKZx5jSxL71pEVi9OKs5XsZdlhx7BuLT5lSd7Cl
         d3meypCKZclN+RxAIA6zmZc1Cysfp8qPDq6w3XEpL6UdCNIMMN0hN7pnAbTT3YYoOm
         jPYflPall27X7CLD6pt3f6cCPHW2FrB+NTKy60ronObIPyrEIIeluKXwe8nvN/ITfM
         b8KaranTZVs0w==
Date:   Mon, 12 Aug 2019 15:06:23 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 0/2] powerpc/xive: Fix race condition leading to host crashes
 and hangs
Message-ID: <20190812050623.ltla46gh5futsqv4@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes a race condition that has been observed in testing
on POWER9 machines running KVM guests.  An interrupt being freed by
free_irq() can have an instance present in a XIVE interrupt queue,
which can then be presented to the generic interrupt code after the
data structures for it have been freed, leading to a variety of
crashes and hangs.

This series is based on current upstream kernel source plus Cédric Le
Goater's patch "KVM: PPC: Book3S HV: XIVE: Free escalation interrupts
before disabling the VP", which is a pre-requisite for this series.
As it touches both KVM and generic PPC code, this series will probably
go in via Michael Ellerman's powerpc tree.

Paul.

 arch/powerpc/include/asm/xive.h         |  8 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 23 ++++++---
 arch/powerpc/kvm/book3s_xive.c          | 31 ++++++++++++
 arch/powerpc/sysdev/xive/common.c       | 87 ++++++++++++++++++++++++---------
 4 files changed, 119 insertions(+), 30 deletions(-)
