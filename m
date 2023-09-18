Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9D7A5241
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 20:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjIRSnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 14:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjIRSna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 14:43:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24886109;
        Mon, 18 Sep 2023 11:43:23 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695062602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/RQ+MZYYkIGZimhGMzDLvmhGo+fnFrbGeertT/ie31Q=;
        b=N+LJ52EZv2tUrO6xCr1UMKdEay09OpaHz+XKZAUwKx/57FDDFx8OAhect7CtTr/dqVJWS2
        uZ/WPiVG9kqesUZmj+cTOTM8S6DzkqisZXiEW2XgEem3AU8oocZK42RXLdTw8qOGdYEpaW
        cyEtXymmCN4Av7jfcT7X9ZzwwqRqPUuUVFFVDZJlvzCX6GHKfPZaF24wLquJEhyTjvTmt0
        RYC+XKhbH5eNn+oILVnt+p/g55IPJ3WT9cIgaw7PeUYzD6JW5x1udq57LqM+gItsc7K6BV
        QDWaT7drUozGe5HURM9OPH7uJ6mZnRPovbmWw/nbaCHeYwEYtlfwiAnl/syijA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695062602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/RQ+MZYYkIGZimhGMzDLvmhGo+fnFrbGeertT/ie31Q=;
        b=A8Nwf7ugDqcf469ra2fSnXBXHZu4t6IWlloE6yfNFc+izWgC5LSeVcCCclQDGkqyuXA+qR
        4JCaiEkf2YXmKmDA==
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Shannon Nelson <shannon.nelson@amd.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
In-Reply-To: <20230918141705.GE13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
Date:   Mon, 18 Sep 2023 20:43:21 +0200
Message-ID: <87led3xqye.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18 2023 at 11:17, Jason Gunthorpe wrote:
> On Thu, Sep 14, 2023 at 12:14:06PM -0700, Shannon Nelson wrote:
>> The new MSI dynamic allocation machinery is great for making the irq
>> management more flexible.  It includes caching information about the
>> MSI domain which gets reused on each new open of a VFIO fd.  However,
>> this causes an issue when the underlying hardware has flexible MSI-x
>> configurations, as a changed configuration doesn't get seen between
>> new opens, and is only refreshed between PCI unbind/bind cycles.
>> 
>> In our device we can change the per-VF MSI-x resource allocation
>> without the need for rebooting or function reset.  For example,
>> 
>>   1. Initial power up and kernel boot:
>> 	# lspci -s 2e:00.1 -vv | grep MSI-X
>> 	        Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-
>> 
>>   2. Device VF configuration change happens with no reset
>
> Is this an out of tree driver problem?
>
> The intree way to alter the MSI configuration is via
> sriov_set_msix_vec_count, and there is only one in-tree driver that
> uses it right now.

Right, but that only addresses the driver specific issues.

> If something is going wrong here it should be fixed in the
> sriov_set_msix_vec_count() machinery, possibly in the pci core to
> synchronize the msi_domain view of the world.

Right, we should definitely not do that on a per driver basis.

Thanks,

        tglx
