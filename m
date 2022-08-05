Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BE758ADDE
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiHEQF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241235AbiHEQFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:05:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B8E402CA;
        Fri,  5 Aug 2022 09:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4734CE2ABB;
        Fri,  5 Aug 2022 16:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9298C433D7;
        Fri,  5 Aug 2022 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659715548;
        bh=meLN3iFq0dB6/cRPWbxA3YaJYvQo+JhwHofyvaOjkjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=NbUpIVz3tIzfFG4V82gy2lgVrqrJgDHgNQKYqnqcc9wsh8f3ZCxDp8t9FlJDYylzv
         +Iu3a5h4Oa/48zEzWvJ5n7fxdlhFiaayxvOGAM5zduVXc1ew5pkQOhCIyGAheh+wto
         mECOAk/aaIKLCzR5MmhxOm+Z552Te38YesDwSMU1fG3u/gCBrGCxfL9anSCux5Irjg
         noqkXknHkKnRo3zvoeWuisCJfsbbCMEn5aaPr74JUaV9r1kY3/5YAMIxPnZqsCwjvh
         SrSvXLJziQ3ZRqApUsruuxrCVwbyFKklJ4dYx1zMJl1i/+XBwGXy+kTfIzRPME+C1I
         hI0cNl8b7GJPg==
Date:   Fri, 5 Aug 2022 11:05:45 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Arinzon, David" <darinzon@amazon.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Brandes, Shai" <shaibran@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "mk@semihalf.com" <mk@semihalf.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: vfio/pci - uAPI for WC
Message-ID: <20220805160545.GA1020364@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d42f195bffa444719065f4e84098fe0c@EX13D47EUB004.ant.amazon.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc Alex, Cornelia, kvm, lkml (from "get_maintainer.pl drivers/vfio")
and rewrapped for plain-text readability]
On Thu, Aug 04, 2022 at 09:47:36AM +0000, Arinzon, David wrote:
> Hi,
> 
> There's currently no mechanism for vfio that exposes WC-related
> operations (check if memory is WC capable, ask to WC memory) to user
> space module entities, such as DPDK, for example.
>
> This topic has been previously discussed in [1], [2] and [3], but
> there was no follow-up.
>
> This capability is very useful for DPDK, specifically to the DPDK
> ENA driver that uses vfio-pci, which requires memory to be WC on the
> TX path. Without WC, higher CPU utilization and performance
> degradation are observed.
>
> In the above mentioned discussions, three options were suggested:
> sysfs, ioctl, mmap extension (extra attributes).
> 
> Was there any progress on this area? Is there someone who's looking
> into this?
>
> We're leaning towards the ioctl option, if there are no objections,
> we'd come up with an RFC.

> [1]: https://patchwork.kernel.org/project/kvm/patch/20171009025000.39435-1-aik@ozlabs.ru/
> [2]: https://lore.kernel.org/linux-pci/2b539df4c9ec703458e46da2fc879ee3b310b31c.camel@kernel.crashing.org/
> [3]: https://lore.kernel.org/lkml/20210429162906.32742-2-sdonthineni@nvidia.com/
> 
> Thanks,
> David
