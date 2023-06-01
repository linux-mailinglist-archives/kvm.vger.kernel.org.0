Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5131571F62F
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 00:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjFAWnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 18:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjFAWnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 18:43:33 -0400
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D9A136
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 15:43:31 -0700 (PDT)
Date:   Thu, 1 Jun 2023 22:43:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685659409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwwcO93XUsSL6ykN5XfObGDM2dVn0PA2p876+g1yYcU=;
        b=K2WfBTvSAHfrUiKalALQGQq2zayiZCV9KlBLhF4Krhjs82D/jAE3o9JTggvR2fvpxbqIq3
        NQnh6Hu5F7XLykhAGbO5ynhU5yErAcvseO1npOikikhhj4kqPakjdnTqiphYCT7mVbu57A
        CHD07ERWGhSRfFVZKVuSj34pCzcY0cE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
        maz@kernel.org, jthoughton@google.com, bgardon@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZHkfDCItA8HUxOG1@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZFrG4KSacT/K9+k5@google.com>
 <ZFwcRCSSlpCBspxy@google.com>
 <CAF7b7moF1URFC2yZXymPCwvDME8oJafCse12DSf0Rwo43JEDVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7moF1URFC2yZXymPCwvDME8oJafCse12DSf0Rwo43JEDVg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 10:49:04AM -0700, Anish Moorthy wrote:
> On Wed, May 10, 2023 at 4:44 PM Anish Moorthy <amoorthy@google.com> wrote:
> >
> > On Wed, May 10, 2023 at 3:35 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Yeah, when I speed read the series, several of the conversions stood out as being
> > > "wrong".  My (potentially unstated) idea was that KVM would only signal
> > > KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user access,
> > > i.e. when the fault _might_ be resolvable by userspace.
> >
> > Sean, besides direct_map which other patches did you notice as needing
> > to be dropped/marked as unrecoverable errors?
> 
> I tried going through on my own to try and identify the incorrect
> annotations: here's my read.
> 
> Correct (or can easily be corrected)
> -----------------------------------------------
> - user_mem_abort
>   Incorrect as is: the annotations in patch 19 are incorrect, as they
> cover an error-on-no-slot case and one more I don't fully understand:

That other case is a wart we endearingly refer to as MTE (Memory Tagging
Extension). You theoretically _could_ pop out an annotated exit here, as
userspace likely messed up the mapping (like PROT_MTE missing).

But I'm perfectly happy letting someone complain about it before we go
out of our way to annotate that one. So feel free to drop.

-- 
Thanks,
Oliver
