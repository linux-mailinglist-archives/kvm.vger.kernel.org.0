Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE94A4F6DA8
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 00:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiDFWJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 18:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiDFWJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 18:09:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDF32A71C;
        Wed,  6 Apr 2022 15:07:20 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649282839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=52XeoShnHmdAQ+XobvAW3OjjBZFsGfa67mgB/KHswHw=;
        b=rTC+MTir7K3GQwjDaTnq/Dtgs9ZArTDUo8SEVZ8/M7l0Ij82aZQsxfxt4MSQvDZPqhzjbe
        KmAvC/1zLhXu9TrKuiWPVKsLn5MkyxZifWmaI51hUsVzMe0GDKkIWnzWUHhVTGRrnRGhjq
        CPvfqO/kjVbIhCUE1MYr/B7f0pAb0dfqz4tJo1i3kltxcKiulF8Amz9MStp5aiBF/OTg59
        bXSaUVq2t1wWWpZbtctl9uOmg1cKLed7IhXjmITB4bhTVpfo6majJv+iwx1LHnCAkSm1k1
        9jlnuq5Tg7dEz82ISrh4peEjS5Xc3bEjIsKWPZv3e/zZ+bMPHUImxf/kov3uWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649282839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=52XeoShnHmdAQ+XobvAW3OjjBZFsGfa67mgB/KHswHw=;
        b=l/De9Ow9qS0nayBe3dC2SF/mqKKOsu2s5yJnnCR+HzzwO6gGPHvUKa7HHa8ezn5dzKZ2ry
        un2P6HyZnfHvUxAg==
To:     Reto Buerki <reet@codelabs.ch>, dwmw2@infradead.org
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        decui@microsoft.com
Subject: Re: [PATCH v3 12/35] x86/msi: Provide msi message shadow structs
In-Reply-To: <20220406083624.38739-1-reet@codelabs.ch>
References: <20201024213535.443185-13-dwmw2@infradead.org>
 <20220406083624.38739-1-reet@codelabs.ch>
Date:   Thu, 07 Apr 2022 00:07:18 +0200
Message-ID: <87sfqpzx0p.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 06 2022 at 10:36, Reto Buerki wrote:
> While working on some out-of-tree patches, we noticed that assignment to
> dmar_subhandle of struct x86_msi_data lead to a QEMU warning about
> reserved bits in MSI data being set:
>
> qemu-system-x86_64: vtd_interrupt_remap_msi: invalid IR MSI (sid=256, address=0xfee003d8, data=0x10000)
>
> This message originates from hw/i386/intel_iommu.c in QEMU:
>
> #define VTD_IR_MSI_DATA_RESERVED (0xffff0000)
> if (origin->data & VTD_IR_MSI_DATA_RESERVED) { ... }
>
> Looking at struct x86_msi_data, it appears that it is actually 48-bits in size
> since the bitfield containing the vector, delivery_mode etc is 2 bytes wide
> followed by dmar_subhandle which is 32 bits. Thus assignment to dmar_subhandle
> leads to bits > 16 being set.
>
> If I am not mistaken, the MSI data field should be 32-bits wide for all
> platforms (struct msi_msg, include/linux/msi.h). Is this analysis
> correct or did I miss something wrt. handling of dmar_subhandle?

It's correct and I'm completely surprised that this went unnoticed
for more than a year. Where is that brown paperbag...

Thanks,

        tglx

