Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B700E70CDD2
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbjEVWZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjEVWZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:25:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D53DB;
        Mon, 22 May 2023 15:25:28 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1684794326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXyFl2M6zB7BoSPtk0XRvDmz4adu2gjPrDf6Yiahe7c=;
        b=oN/J7yVPCxqMdg8QtO8FYGmtSoZtAjYQezMqUaiJ0CiTcm/CRKzSaX3Wav2dlStzR5xxlO
        mEuzTa8ZNSodeBqte59fLv/hBQqf27Gh6USFwgoPoYC8uQt5RDd+2AdLGzhhAp10wvsTim
        OGyVvOEL9c55Pzc8kYvYvftvU2gkmprwzHglNdb3r5Z8wxC58fewvQZmtBl2LAlrnFVhMm
        7gsJl2as7Jz/3tyd9BydBbmBYGyJnR+TXZJwh3Fd3RAhiHa2+gApBLUwWYR7iJNA0cefp1
        LNQ39wgdjn2WuSaJXd5ByfiWs63zYwQTHAW+Qsk9xrbWCLlxC72lxIaSTdkjlQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1684794326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXyFl2M6zB7BoSPtk0XRvDmz4adu2gjPrDf6Yiahe7c=;
        b=TKLDAva3wczux4YvtLzDilhiT8HNyhWnLgkKwmBKv8x0BeyMT+MtcD2k0v2PTrCrUeXj5P
        rBgRDFf6Byi3gLDQ==
To:     Reinette Chatre <reinette.chatre@intel.com>, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, alex.williamson@redhat.com
Cc:     darwi@linutronix.de, kvm@vger.kernel.org, dave.jiang@intel.com,
        jing2.liu@intel.com, ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
Date:   Tue, 23 May 2023 00:25:26 +0200
Message-ID: <875y8kvwa1.ffs@tglx>
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

Reinette!

On Thu, May 11 2023 at 08:44, Reinette Chatre wrote:
> Changes since V4:
> - V4: https://lore.kernel.org/lkml/cover.1682615447.git.reinette.chatre@intel.com/
> - Add Kevin's Reviewed-by tag as applicable.
> - Treat non-existing INTx interrupt context as kernel bug with WARN. This
>   exposed an issue in the scenario where INTx mask/unmask may occur without
>   INTx enabled. This is fixed by obtaining the interrupt context later
>   (right before use) within impacted functions: vfio_pci_intx_mask() and
>   vfio_pci_intx_unmask_handler(). (Kevin)
> - Treat pci_irq_vector() returning '0' for a MSI/MSI-X interrupt as a kernel
>   bug via a WARN instead of ignoring this value. (Kevin)
> - Improve accuracy of comments. (Kevin)
> - Please refer to individual patches for local changes.

I only skimmed the series for obvious hickups vs. the PCI/MSI core (my
virt[io] foo is limited) and I did not find anything to complain about.

Aside of that I really like how this series is built up to restructure
and cleanup things first so that the new functionality falls in place
instead of the popular 'glue it in no matter what' approach.

That's a pleasure to read even for the virt[io] illiterate!

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,

        tglx
