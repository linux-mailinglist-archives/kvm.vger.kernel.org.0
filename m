Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F9019CBE8
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389072AbgDBUsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:48:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgDBUsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7byunhOigmKgF2sOm4YN5Lry/ZYZDusqM73GCeYnAPo=; b=cqpaQ2QO6mRhZCASxfC8JL0RxH
        gEglXo7uGL17beLgCvsDmXbxPXgizBfS7HDZl2fE2KwNXzcJWeDiGu962SufoVcYPy/U9v/LC0ya1
        uqtjKsqj5I/Sc6KvJ+wsm4TX2jyWeURAU5aTk8zjaCbccgxtXch9L6VBumZLR/jIcxInJRVPbCDf7
        wKEc8s8uJp7f7knqJe5pJK+L+Xl2VzujB4nBuTVWPsZ6g9D4ZEZ4HKmAerVwGmWlt4bq/29q2X6LE
        jL9U4jNyOReHpD3FAXPj7lZc45cFMHdIFI+KI1lBhrvpkA2Sc49sn4Uo+T/9sruSScErzYsnSSzRv
        rPsH3NCA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jK6l9-000322-Ll; Thu, 02 Apr 2020 20:48:19 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E3B6B9834EB; Thu,  2 Apr 2020 22:48:16 +0200 (CEST)
Date:   Thu, 2 Apr 2020 22:48:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>, Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
Message-ID: <20200402204816.GJ2452@worktop.programming.kicks-ass.net>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-4-sean.j.christopherson@intel.com>
 <87sghln6tr.fsf@nanos.tec.linutronix.de>
 <20200402174023.GI13879@linux.intel.com>
 <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 10:07:07PM +0200, Thomas Gleixner wrote:

If we're doing wish lists, I have one more ;-)

> TBH, the more I learn about this, the more I tend to just give up on
> this whole split lock stuff in its current form and wait until HW folks
> provide something which is actually usable:
> 
>    - Per thread
>    - Properly distinguishable from a regular #AC via error code

   - is an actual alignment check.

That is, disallow all unaligned LOCK prefixed ops, not just those that
happen to straddle a cacheline.

