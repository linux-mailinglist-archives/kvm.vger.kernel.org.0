Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50218B503
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 12:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfHMKJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 06:09:27 -0400
Received: from ozlabs.org ([203.11.71.1]:43117 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbfHMKJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 06:09:26 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4677jc34qTz9sNk; Tue, 13 Aug 2019 20:09:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565690964; bh=lkQErqq2LggBXUmI28o57yvUkVxgeWvgJahOWziULOo=;
        h=Date:From:To:Cc:Subject:From;
        b=m4llgH2rlAYympdshVOV79m+3UqrNgy+kEuLMIDXzG2jfZp3kPjGHrIV8vK5soz8D
         wwQumHYK7E+KDsZwrIWMYGBkUZak3hMwSc+HNxaZ1lrn2LZaqt5NZrEHgj6IAujEjN
         D99Nu9mxtpxiuEPZ35eepsplGgIbmoGXnONyecEgCo9WOHXp9cPnLu1Sayd3qb77FX
         C7VOunYKUpCoHW9I9yiZxNhC0b9X+kBunz98NZYxVcLlqpmP15ce07qpYacMy7FWYO
         muI6L0cvOaSlYj0bJ70hqKyxx9BDB4mpYiCBAkayGbBzn7/Zr994lv8+THkIuzAp5h
         xW0KJnGJVuFXg==
Date:   Tue, 13 Aug 2019 19:58:45 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH v2 0/3] powerpc/xive: Fix race condition leading to host
 crashes and hangs
Message-ID: <20190813095845.GA9567@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.24 (2015-08-30)
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

V2 of this patch series adds a patch fixing a bug noticed by Cédric,
and also fixes a bug in patch 1/2 of the v1 series.

Paul.

 arch/powerpc/include/asm/xive.h         |  8 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 38 +++++++++-----
 arch/powerpc/kvm/book3s_xive.c          | 42 +++++++++++++++-
 arch/powerpc/kvm/book3s_xive.h          |  2 +
 arch/powerpc/kvm/book3s_xive_native.c   |  6 +++
 arch/powerpc/sysdev/xive/common.c       | 87 ++++++++++++++++++++++++---------
 6 files changed, 146 insertions(+), 37 deletions(-)
