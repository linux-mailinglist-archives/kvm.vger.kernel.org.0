Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC157251F3
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240659AbjFGCIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 22:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240646AbjFGCIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 22:08:18 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2BB19AB;
        Tue,  6 Jun 2023 19:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686103698; x=1717639698;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xd78RHAM8jVz61Q9dpqClzsKAAlKstrsKx333pJSKmA=;
  b=RXs39d59GE56UVn84KEOBSuu/6EEV5uZizqXzw3pMYsESC22Talvectl
   Zi6RHPRQWYlb7OoQAK9B3umaTmXcy/ry8B1KzrOSQlbxi9xTMjPhvl5uw
   5tSLPJi7q/dhhbXNJ1Dkgr4VIV9kCrYbpZ6D9WcYt2yQZ/Z7QZEU/9lkW
   0=;
X-IronPort-AV: E=Sophos;i="6.00,222,1681171200"; 
   d="scan'208";a="332577700"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 02:08:15 +0000
Received: from EX19MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id B26908069E;
        Wed,  7 Jun 2023 02:08:12 +0000 (UTC)
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Jun 2023 02:08:11 +0000
Received: from dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com (10.39.210.33)
 by mail-relay.amazon.com (10.252.134.102) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 7 Jun 2023 02:08:11 +0000
Received: by dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com (Postfix, from userid 23276196)
        id B7CF623; Wed,  7 Jun 2023 02:08:11 +0000 (UTC)
Date:   Wed, 7 Jun 2023 02:08:11 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Message-ID: <20230607020743.GA53474@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
References: <20230602005859.784190-1-seanjc@google.com>
 <20230606202557.GA71782@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
 <ZH+tOj7lRAGsua9X@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZH+tOj7lRAGsua9X@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 03:03:38PM -0700, Sean Christopherson wrote:
> 
> 
> 
> On Tue, Jun 06, 2023, Luiz Capitulino wrote:
> > On Thu, Jun 01, 2023 at 05:58:59PM -0700, Sean Christopherson wrote:
> > However, why don't we make nx_huge_pages=never the default behavior if the
> > CPU is not vulnerable?
> 
> Mainly because the mitigation has been around for 3.5 years, and there's a non-zero
> chance that making "never" the default could cause hiccups for unsuspecting users.
> If this were brand new code, I would definitely opt for "never" as the default.

OK.

> > If there are concerns about not being able to restart the worker thread, then
> > maybe we could make this a .config option?
> 
> Eh, a Kconfig is unnecessarily complex, and wouldn't really change anything, e.g.
> for users in the know, it's just as easy to force a module param as it is to force
> a Kconfig, and to gain any benefit from the param being !never by default, the
> Kconfig would also have to be off by default.

I agree it adds some complexity. The benefit is to allow shipping a kernel with
a good default where KVM users with non-vulnerable CPUs get low latency out
of the box (vs. having to figure out if they are vulnerable or not and changing
a run-time configuration).

But the idea would be to set "never" by default as long as the CPU is not vulnerable.

> If "everyone" wants never to be the default, and Paolo doesn't object, I'd rather
> just tack on a patch to make that happen, and cross my fingers there's no fallout :-)

This would work too :)
