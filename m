Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8678DBBF67
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 02:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503662AbfIXAiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 20:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503655AbfIXAiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 20:38:25 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1663910CC1ED;
        Tue, 24 Sep 2019 00:38:25 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B0A710013A1;
        Tue, 24 Sep 2019 00:38:22 +0000 (UTC)
Date:   Mon, 23 Sep 2019 20:38:21 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190924003821.GA4230@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
 <20190923202349.GL18195@linux.intel.com>
 <ccfa85b7-b484-7052-f991-78ad05ce7fe7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccfa85b7-b484-7052-f991-78ad05ce7fe7@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Tue, 24 Sep 2019 00:38:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Sep 24, 2019 at 02:15:39AM +0200, Paolo Bonzini wrote:
> Do you really need that?  Why couldn't the handle_* functions simply be
> exported from nested.c to vmx.c?

I prefer the direct call too indeed.

If Sean doesn't want to export those generic names to the whole kernel
it would be enough to #include "nested.c" from vmx.c, and you'd still
have it private but with no additional checks and no additional extern
call. It's not like kvm-intel can be built without linking nested.o
anyway.

This overall is a C shortcoming of some sort if you've to resort to
#include "nested.c" to keep the function hidden in kvm-intel.o
despite it's implemented in two different object files. One should be
able to limit the scope of an extern function declaration per a group
of object files and to drop the declaration before linking that object
beyond that initial group.

Thanks,
Andrea
