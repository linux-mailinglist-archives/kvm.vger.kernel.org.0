Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309E363397
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfGIJjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 05:39:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfGIJjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 05:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kdQyODxMxUBFZB4Kjn197QaK8uIbLjFv68+mwzodhVw=; b=FxFjnWqpvev7+jPKMw6Lk98xS
        6inWU1fgQUGSNvm+eGU6I7r7b3pvGbgtpjIdae0F69E9HbsXbecsKS0KF6UCHSc3hgQlkjlfLdoWS
        kqt8XS9EErTQFa724v3i424FqUuzbU+u2OC39nZl0RDlXEbO7r6uoJyrMO875ZRl2HEZIbu52kb3Z
        /ButXDHDP/kZRdK+MmfnRAqdk0Irc+mFTgTWV1469vcgOOW5l0QjwjUeif8vzu16Ds7cSsoZDuVrc
        ewln0dLbVVPAKSYw/OXD22D7JqlxCznlfNCAlQ7KDI4cEsggaPDJojGUOLueewTDcOYdjO610uc7P
        sxhO128yA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkmal-0006ZR-7N; Tue, 09 Jul 2019 09:39:19 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 84C1C20120CB1; Tue,  9 Jul 2019 11:39:17 +0200 (CEST)
Date:   Tue, 9 Jul 2019 11:39:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 08/12] KVM/x86/vPMU: Add APIs to support host
 save/restore the guest lbr stack
Message-ID: <20190709093917.GS3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-9-git-send-email-wei.w.wang@intel.com>
 <20190708144831.GN3402@hirez.programming.kicks-ass.net>
 <5D240435.2040801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D240435.2040801@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 09, 2019 at 11:04:21AM +0800, Wei Wang wrote:
> On 07/08/2019 10:48 PM, Peter Zijlstra wrote:

> > *WHY* does the host need to save/restore? Why not make VMENTER/VMEXIT do
> > this?
> 
> Because the VMX transition is much more frequent than the vCPU switching.
> On SKL, saving 32 LBR entries could add 3000~4000 cycles overhead, this
> would be too large for the frequent VMX transitions.
> 
> LBR state is saved when vCPU is scheduled out to ensure that this
> vCPU's LBR data doesn't get lost (as another vCPU or host thread that
> is scheduled in may use LBR)

But VMENTER/VMEXIT still have to enable/disable the LBR, right?
Otherwise the host will pollute LBR contents. And you then rely on this
'fake' event to ensure the host doesn't use LBR when the VCPU is
running.

But what about the counter scheduling rules; what happens when a CPU
event claims the LBR before the task event can claim it? CPU events have
precedence over task events.

Then your VCPU will clobber host state; which is BAD.

I'm missing all these details in the Changelogs. Please describe the
whole setup and explain why this approach.
