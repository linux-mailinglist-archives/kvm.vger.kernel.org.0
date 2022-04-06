Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B25D4F5E33
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiDFMmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 08:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiDFMll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 08:41:41 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9752A1E6F9D
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 01:42:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id E096F220002;
        Wed,  6 Apr 2022 10:37:03 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wm3KiR0YfLUt; Wed,  6 Apr 2022 10:37:02 +0200 (CEST)
Received: from skyhawk.codelabs.local (unknown [IPv6:2a02:169:803:0:f7fb:8040:b3e4:bffe])
        by mail.codelabs.ch (Postfix) with ESMTPSA id A7A93220001;
        Wed,  6 Apr 2022 10:37:02 +0200 (CEST)
From:   Reto Buerki <reet@codelabs.ch>
To:     dwmw2@infradead.org
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        maz@misterjones.org, decui@microsoft.com
Subject: Re: [PATCH v3 12/35] x86/msi: Provide msi message shadow structs
Date:   Wed,  6 Apr 2022 10:36:23 +0200
Message-Id: <20220406083624.38739-1-reet@codelabs.ch>
In-Reply-To: 20201024213535.443185-13-dwmw2@infradead.org
References: <20201024213535.443185-13-dwmw2@infradead.org>
MIME-Version: 1.0
GIT:    Lines beginning in "GIT:" will be removed.
GIT:    Consider including an overall diffstat or table of contents
GIT:    for the patch you are writing.
GIT:    Clear the body content if you don't wish to send a summary.
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While working on some out-of-tree patches, we noticed that assignment to
dmar_subhandle of struct x86_msi_data lead to a QEMU warning about
reserved bits in MSI data being set:

qemu-system-x86_64: vtd_interrupt_remap_msi: invalid IR MSI (sid=256, address=0xfee003d8, data=0x10000)

This message originates from hw/i386/intel_iommu.c in QEMU:

#define VTD_IR_MSI_DATA_RESERVED (0xffff0000)
if (origin->data & VTD_IR_MSI_DATA_RESERVED) { ... }

Looking at struct x86_msi_data, it appears that it is actually 48-bits in size
since the bitfield containing the vector, delivery_mode etc is 2 bytes wide
followed by dmar_subhandle which is 32 bits. Thus assignment to dmar_subhandle
leads to bits > 16 being set.

If I am not mistaken, the MSI data field should be 32-bits wide for all
platforms (struct msi_msg, include/linux/msi.h). Is this analysis
correct or did I miss something wrt. handling of dmar_subhandle?

The attached patch fixes the issue for us.

Regards,
- reto
