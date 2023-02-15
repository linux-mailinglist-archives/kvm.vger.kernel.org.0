Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF806988CD
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 00:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjBOXiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 18:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBOXiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 18:38:06 -0500
Received: from out-120.mta1.migadu.com (out-120.mta1.migadu.com [IPv6:2001:41d0:203:375::78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE45F2E80D
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 15:38:05 -0800 (PST)
Date:   Wed, 15 Feb 2023 23:37:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676504283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vwVLRoeRqgxnx8cuSjz2tafLXCrYIoaiIXqNZRNOEVY=;
        b=UqJns25zBmIfCzRBDy3EJC6wKpNhvLPIMpm4BLNQUI9CorkowdQc77jxWNBeTOn/Bo2uy2
        U7Z9nbX3r0r3u+6Hjsvp28pvzfTsCoJtyaYYUXWZ2obPZEaAf1aGGdRmajF5Wkf/HJId03
        545GJ28C+Ep4iI7ikBuQ5bCxppsl4Zk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 7/8] kvm/arm64: Implement KVM_CAP_MEM_FAULT_NOWAIT for
 arm64
Message-ID: <Y+1s1txXLkwdlF6F@linux.dev>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-8-amoorthy@google.com>
 <Y+0jcC/Em/cnYe9t@linux.dev>
 <CAF7b7mpbAdQtvXCQCk5kLrSn0bN=fLYVzEWXVW34OgBSxzHA_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF7b7mpbAdQtvXCQCk5kLrSn0bN=fLYVzEWXVW34OgBSxzHA_g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 03:28:31PM -0800, Anish Moorthy wrote:
> On Wed, Feb 15, 2023 at 10:24 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > All of Sean's suggestions about writing a change description apply here
> > too.
> 
> Ack
> 
> > > +     if (mem_fault_nowait && pfn == KVM_PFN_ERR_FAULT) {
> > > +             vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > > +             vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
> > > +             vcpu->run->memory_fault.size = vma_pagesize;
> > > +             return -EFAULT;
> >
> > We really don't want to get out to userspace with EFAULT. Instead, we
> > should get out to userspace with 0 as the return code to indicate a
> > 'normal' / expected exit.
> >
> > That will require a bit of redefinition on user_mem_abort()'s return
> > values:
> >
> >  - < 0, return to userspace with an error
> >  - 0, return to userspace for a 'normal' exit
> >  - 1, resume the guest
> 
> Ok, easy enough: do you want that patch sent separately or as part
> of the next version of this series?

Roll it into the next spin of the series. Splitting off patches (as asked
in patch 1) is only useful if there's a bugfix or some other reason for
inclusion ahead of the entire series.

-- 
Thanks,
Oliver
