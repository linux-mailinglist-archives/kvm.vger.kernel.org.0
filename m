Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EAEBBC16
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 21:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbfIWTMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 15:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfIWTMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 15:12:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A92B368DA;
        Mon, 23 Sep 2019 19:12:54 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A2EF5C1B2;
        Mon, 23 Sep 2019 19:12:51 +0000 (UTC)
Date:   Mon, 23 Sep 2019 15:12:50 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923191250.GC19996@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <20190923163746.GE18195@linux.intel.com>
 <24dc5c23-eed8-22db-fd15-5a165a67e747@redhat.com>
 <20190923174244.GA19996@redhat.com>
 <20190923181558.GI18195@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923181558.GI18195@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 23 Sep 2019 19:12:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 11:15:58AM -0700, Sean Christopherson wrote:
> On the flip side, using a switch for the fast-path handlers gives the
> compiler more flexibility to rearrange and combine checks.  Of course that
> doesn't mean the compiler will actually generate faster code for our
> purposes :-)
> 
> Anyways, getting rid of the retpolines is much more important.

Precisely because of your last point, if we throw away the
deterministic priority, then we could drop the whole structure like
Vitaly suggested and we'd rely on gcc to add the indirect jump on a
non-retpoline build.

Solving the nested if we drop the structure and we don't pretend to
make it const, isn't tricky: it only requires one more check if nested
is enabled. The same variable that will have to be checked is also the
variable that needs to be checked in the
kvm_x86_ops->check_nested_events replacement later to drop the
kvm_x86_ops struct as a whole like kvm_pmu_ops was dropped clean.
