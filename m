Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8876959CCDA
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbiHWAI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238677AbiHWAIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C4EAE44;
        Mon, 22 Aug 2022 17:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D6FB81992;
        Tue, 23 Aug 2022 00:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36841C433D6;
        Tue, 23 Aug 2022 00:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661213301;
        bh=ql3WhYwvtGyV0nnW4S8Tm+rGjMLwd8ee87bzIsZn2ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vRwnTZRxoiSrk0tZjUMMz0NWpy3KJjQW1Gzwl4s5BxfTEsZyNaPKh3ddH+egMSRAD
         2sR4hnNN+xm0NXU8iGalWA3ooH8VIUWkt4psle8L7uIrU6rbO7bDLYXnhrZRLNscHk
         bIFHQN8LlfFrHCUIGNFAHen8hRb613xJNDRLoVjU=
Date:   Mon, 22 Aug 2022 17:08:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count
 secondary page table uses.
Message-Id: <20220822170819.60d888a5d3e23f40fd1b2e16@linux-foundation.org>
In-Reply-To: <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
        <20220628220938.3657876-2-yosryahmed@google.com>
        <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
        <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
        <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Aug 2022 17:04:57 -0700 Yosry Ahmed <yosryahmed@google.com> wrote:

> > SecondaryPageTables is too long (unfortunately), it messes up the
> > formatting in node_read_meminfo() and meminfo_proc_show(). I would
> > prefer "secondary" as well, but I don't know if breaking the format in
> > this way is okay.
> 
> Any thoughts here Andrew? Change to SecondaryPageTables anyway? Change
> all to use "sec" instead of "secondary"? Leave as-is?

Leave as-is, I guess.  
