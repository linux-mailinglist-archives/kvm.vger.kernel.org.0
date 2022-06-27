Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB42755B600
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 06:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiF0EPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 00:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiF0EPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 00:15:11 -0400
Received: from out0-129.mail.aliyun.com (out0-129.mail.aliyun.com [140.205.0.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C252BE9
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 21:15:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047205;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.ODQQnmo_1656303303;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ODQQnmo_1656303303)
          by smtp.aliyun-inc.com;
          Mon, 27 Jun 2022 12:15:03 +0800
Date:   Mon, 27 Jun 2022 12:15:03 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Message-ID: <20220627041503.GA12292@k08j02272.eu95sqa>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
 <YrZDkBSKwuQSrK+r@google.com>
 <8b3d1e58-fb79-ca84-c396-a44318d3ebd1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b3d1e58-fb79-ca84-c396-a44318d3ebd1@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 25, 2022 at 05:13:22PM +0800, Paolo Bonzini wrote:
> On 6/25/22 01:06, Sean Christopherson wrote:
> >>("KVM: Replace old tlb flush function with new one to flush a specified range.")
> >>replaces old tlb flush function with kvm_flush_remote_tlbs_with_address()
> >>to do tlb flushing. However, the gfn range of tlb flushing is wrong in
> >>some cases. E.g., when a spte is dropped, the start gfn of tlb flushing
> >Heh, "some" cases.  Looks like KVM is wrong on 7 of 15 cases.  And IIRC, there
> >were already several rounds of fixes due to passing "end" instead of "nr_pages".
> >
> >Patches look ok on a quick read through, but I'd have to stare a bunch more to
> >be confident.
> >
> >Part of me wonders if we should just revert the whole thing and then only reintroduce
> >range-based flushing with proper testing and maybe even require performance numbers
> >to justify the benefits.  Give that almost 50% of the users are broken, it's pretty
> >obvious that no one running KVM actually tests the behavior.
> >
> 
> I'm pretty sure it's in use on Azure.  Some of the changes are
> flushing less, for the others it's more than likely that Hyper-V
> treats a 1-page flush the same if the address points to a huge page.
> 
I lookup hyperv_fill_flush_guest_mapping_list(), gpa_list.page.largepage
is always false. Or the behaviour you said is implemented in Hyper-V not
in KVM ? 

> Paolo
