Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15882468428
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 11:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384646AbhLDKsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 05:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384654AbhLDKr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 05:47:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0736BC061A83;
        Sat,  4 Dec 2021 02:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4DwiWocxoqHSGz1u4qAh5y9ItqoTFtIB/ysJofOf7YQ=; b=l+OyV1xGlNckqnaPS9/kYVtFUk
        wBPCWfz+jNfVR8PbFFt8o7Taza9gSNwWxTz+YPPTeMz4qmT5R9WOCW5n1W/0Nu97Qt7y3/TSEfqKn
        5vo9DXDVDRyMm3N2Ghsf/LzgnifpX/vDz/WlWMw3h9brUGYmAxGleuc6OQwN8UJpKBg4MdnAE7PNI
        zHqH7R3q4eaGhGpTsel15sRc0h2OK5z4knDVvdyD91YXj2ZY17rwRemzq4xLZOknYtUBvGO23J9Yo
        GF/3OCav8htY02KaCDtX7phuXrLc2aHfolCk8L479IE4GylxF1M2rP2P4SZDqMUgDD+4PWKA0dUKH
        a1fMDSIA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mtSWn-00CgMm-CK; Sat, 04 Dec 2021 10:44:26 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B3C5B98106D; Sat,  4 Dec 2021 11:44:25 +0100 (CET)
Date:   Sat, 4 Dec 2021 11:44:25 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        Thomas Gleixner <tglx@linutronix.de>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Re: [PATCH v2 2/2] KVM: x86: use x86_get_freq to get freq for
 kvmclock
Message-ID: <20211204104425.GS16608@worktop.programming.kicks-ass.net>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
 <20211201024650.88254-3-pizhenwei@bytedance.com>
 <877dcn7md2.ffs@tglx>
 <b37ffc3d-4038-fc5e-d681-b89c04a37b04@bytedance.com>
 <ffbb8a16f267e73316084d1252696edaf81e35a9.camel@redhat.com>
 <20211202224555.GE16608@worktop.programming.kicks-ass.net>
 <ce49cc3e3ae5885d992261589cd0f4adad118776.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce49cc3e3ae5885d992261589cd0f4adad118776.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 03, 2021 at 09:53:53AM +0200, Maxim Levitsky wrote:

> > Perf exposes it, it's not really convenient if you're not using perf,
> > but it can be found there.
> That is good to know! I will check out the source but if you remember,
> is there cli option in perf to show it, or it only uses it for internal
> purposes?

perf tool doesn't expose it I think, it's stuffed in
perf_event_mmap_page::time_* fields, see
include/uapi/linux/perf_event.h, it has comments on.
