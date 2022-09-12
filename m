Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030485B5D01
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 17:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiILPR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 11:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiILPRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 11:17:55 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B297222AC;
        Mon, 12 Sep 2022 08:17:54 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id bz13so15918481wrb.2;
        Mon, 12 Sep 2022 08:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rSdFp//FgK95mf2it0s18pZ/BW4X/WUoHMbm0UPV7z8=;
        b=H5MwIX+/qBZ7VcVNdZIE7eBVYcN2yREpsdGvKqY1vv7oEIwPQIeJWH840XYpfNnC9l
         AKtiqrgyLKivy5m9FbhmFbSzajG5Ki6ArlLa5ptzkC3C1FTEafPMax6sBzH2zXI0dKHC
         BYODqJn3QvHy9zQRVguXmbcpdvP+9kZ2oen4Al3P0U+XVjJHZoppfGqpUm/Pq11u2fLX
         NPDSlLdk8uvNLBW6UZp0Hl5p8lAMtPqONeuto78hksXVQ2yagYved1hAd38Ej5S6DAgu
         oJ3qGufoZH+75pWMYuBRM86MVbtSVOgOhk9LwrpbC4KThfX6jtX2O6wRaM+GaTiTxSOr
         1hhA==
X-Gm-Message-State: ACgBeo1j+qr0CjmeqFDfqowaCX7kOdwS1l5wSkOZ9oFdwc2JGgSzrVfw
        4yhJ8n5d5g0DogIHG7+A6HU=
X-Google-Smtp-Source: AA6agR6UjoXyeanimEUu/0ShDd2DrSKVf2T+SZlfbgz83s1vDiNVKoZx1p80XujRdnPIWDmjvx62XQ==
X-Received: by 2002:adf:e609:0:b0:22a:a6fd:cfe1 with SMTP id p9-20020adfe609000000b0022aa6fdcfe1mr2001572wrm.0.1662995873048;
        Mon, 12 Sep 2022 08:17:53 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id l128-20020a1c2586000000b003b340f00f10sm10620972wml.31.2022.09.12.08.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 08:17:52 -0700 (PDT)
Date:   Mon, 12 Sep 2022 15:17:46 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     helgaas@kernel.org, bhelgaas@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        willy@infradead.org, namit@vmware.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        jailhouse-dev@googlegroups.com, xen-devel@lists.xenproject.org,
        acrn-dev@lists.projectacrn.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on VMware hypervisor
Message-ID: <Yx9NmjzeiyYsxUPT@liuwe-devbox-debian-v2>
References: <1662448117-10807-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1662448117-10807-1-git-send-email-akaher@vmware.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 12:38:37PM +0530, Ajay Kaher wrote:
> During boot-time there are many PCI config reads, these could be performed
> either using Port IO instructions (PIO) or memory mapped I/O (MMIO).
> 
> PIO are less efficient than MMIO, they require twice as many PCI accesses
> and PIO instructions are serializing. As a result, MMIO should be preferred
> when possible over PIO.
> 
> Virtual Machine test result using VMware hypervisor
> 1 hundred thousand reads using raw_pci_read() took:
> PIO: 12.809 seconds
> MMIO: 8.517 seconds (~33.5% faster then PIO)
> 
> Currently, when these reads are performed by a virtual machine, they all
> cause a VM-exit, and therefore each one of them induces a considerable
> overhead.
> 
> This overhead can be further improved, by mapping MMIO region of virtual
> machine to memory area that holds the values that the “emulated hardware”
> is supposed to return. The memory region is mapped as "read-only” in the
> NPT/EPT, so reads from these regions would be treated as regular memory
> reads. Writes would still be trapped and emulated by the hypervisor.
> 
> Virtual Machine test result with above changes in VMware hypervisor
> 1 hundred thousand read using raw_pci_read() took:
> PIO: 12.809 seconds
> MMIO: 0.010 seconds
> 
> This helps to reduce virtual machine PCI scan and initialization time by
> ~65%. In our case it reduced to ~18 mSec from ~55 mSec.
> 
> MMIO is also faster than PIO on bare-metal systems, but due to some bugs
> with legacy hardware and the smaller gains on bare-metal, it seems prudent
> not to change bare-metal behavior.
> 
> Signed-off-by: Ajay Kaher <akaher@vmware.com>

The subject line should be fixed -- you're changing the behaviour for
all hypervisors, not just VMWare. I almost skipped this because of the
subject line.

Thanks,
Wei.
