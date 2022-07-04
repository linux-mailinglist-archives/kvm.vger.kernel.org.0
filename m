Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A7E565F7F
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 00:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiGDWsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 18:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGDWsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 18:48:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63819C65;
        Mon,  4 Jul 2022 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tVbYeuMqVTWB9+a2w9YagXruu2c1wBOJ3lmVRIIQvTA=; b=JM20klr5daeztXsLkAIPypjiXc
        hPsm6SIhSFP5fQ86Mso2LQlakk4+El9lKuq9za+WkTrMp3B10VnWxUfx83ViFaLxnZm29m7CBziOQ
        Uce+U9p/xia1JMhj545L/PI1GqLBr/q3SzUKHYfM6gkY0ZLIfAKo9y/7reOoRPbjiQnpU0YUkug7T
        j5Djr02CkG5bv9LMDFJrkBSo+Yypb1GtSuiL6DuyPR9yKS1uM9fJbOu+0+96GtmDz7gTVVTWMn5wg
        6qT3Cv4BhyZY0vwx6R6fWsKifRfZH3f7O1uh+Tcmqj4KSGTcEdVpXJaXAMYZTub3T8O46YRA17rCR
        2OMxWtqw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8Ura-00031u-0w; Mon, 04 Jul 2022 22:48:18 +0000
Date:   Mon, 4 Jul 2022 23:48:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <YsNuMSuneND6KW3o@casper.infradead.org>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622213656.81546-2-peterx@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 05:36:53PM -0400, Peter Xu wrote:
> +/*
> + * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
> + * specified, it'll also respond to generic signals.  The caller of GUP
> + * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
> + */
> +static bool gup_signal_pending(unsigned int flags)
> +{
> +	if (fatal_signal_pending(current))
> +		return true;
> +
> +	if (!(flags & FOLL_INTERRUPTIBLE))
> +		return false;
> +
> +	return signal_pending(current);
> +}

This should resemble signal_pending_state() more closely, if indeed not
be a wrapper of signal_pending_state().
