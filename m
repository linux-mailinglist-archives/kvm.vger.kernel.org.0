Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1945ABBD8F
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 23:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbfIWVIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 17:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388040AbfIWVIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 17:08:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67CF530833A8;
        Mon, 23 Sep 2019 21:08:41 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1FA65D71C;
        Mon, 23 Sep 2019 21:08:38 +0000 (UTC)
Date:   Mon, 23 Sep 2019 17:08:38 -0400
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
Message-ID: <20190923210838.GA23063@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
 <20190923202349.GL18195@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923202349.GL18195@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 23 Sep 2019 21:08:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Mon, Sep 23, 2019 at 01:23:49PM -0700, Sean Christopherson wrote:
> The attached patch should do the trick.

The two most attractive options to me remains what I already have
implemented under #ifdef CONFIG_RETPOLINE with direct calls
(optionally replacing the "if" with a small "switch" still under
CONFIG_RETPOLINE if we give up the prioritization of the checks), or
the replacement of kvm_vmx_exit_handlers with a switch() as suggested
by Vitaly which would cleanup some code.

The intermediate solution that makes "const" work, has the cons of
forcing to parse EXIT_REASON_VMCLEAR and the other vmx exit reasons
twice, first through a pointer to function (or another if or switch
statement) then with a second switch() statement.

If we'd use a single switch statement per Vitaly's suggestion, the "if
nested" would better be more simply implemented as:

	switch (exit_reason) {
		case EXIT_REASON_VMCLEAR:
			if (nested)
				return handle_vmclear(vcpu);
			else
				return handle_vmx_instruction(vcpu);
		case EXIT_REASON_VMCLEAR:
			if (nested)
		[..]

This also removes the compiler dependency to auto inline
handle_vmclear in the added nested_vmx_handle_vmx_instruction extern
call.

VMREAD/WRITE/RESUME are the most frequent vmexit in l0 while nested
runs in l2.

Thanks,
Andrea
