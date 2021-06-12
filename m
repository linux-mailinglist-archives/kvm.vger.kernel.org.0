Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD8E3A5131
	for <lists+kvm@lfdr.de>; Sun, 13 Jun 2021 00:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFLW6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Jun 2021 18:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhFLW6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Jun 2021 18:58:43 -0400
X-Greylist: delayed 444 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Jun 2021 15:56:42 PDT
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BCEC061574
        for <kvm@vger.kernel.org>; Sat, 12 Jun 2021 15:56:41 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id CFF7250E15D5;
        Sun, 13 Jun 2021 01:49:13 +0300 (MSK)
Received: from vla5-c6ba8e81e830.qloud-c.yandex.net (vla5-c6ba8e81e830.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3500:0:640:c6ba:8e81])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id C801ACF40021;
        Sun, 13 Jun 2021 01:49:13 +0300 (MSK)
Received: from vla5-445dc1c4c112.qloud-c.yandex.net (vla5-445dc1c4c112.qloud-c.yandex.net [2a02:6b8:c18:3609:0:640:445d:c1c4])
        by vla5-c6ba8e81e830.qloud-c.yandex.net (mxback/Yandex) with ESMTP id hxNzgSeudK-nDHaYwjn;
        Sun, 13 Jun 2021 01:49:13 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1623538153;
        bh=08FrlLOTUWsUyPHyiT43ePaDnADm/BIL/S9hLpmcaQA=;
        h=Subject:From:To:Message-ID:Cc:Date;
        b=LYBW1PiHx/NmhzydOZUyvQxmulRZOYJnZZ6b02/hDau1N414p0KIufVKMmMv+1a/R
         t6pUhn4dyKtUe6MTqzzbHOwTBdhByTUSWQelviCVUW7bufX6J7tCqJQa9UlBw8SNpq
         B0rJzU4EHMTV7Xk24Aux4T0/4q7Q/phWOImyPf7A=
Authentication-Results: vla5-c6ba8e81e830.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-445dc1c4c112.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id ScOIGr7QIk-nD2OQ1Nx;
        Sun, 13 Jun 2021 01:49:13 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
From:   stsp <stsp2@yandex.ru>
Subject: guest/host mem out of sync on core2duo?
Message-ID: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
Date:   Sun, 13 Jun 2021 01:49:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi kvm developers.

I am having the strange problem
that can only be reproduced on a
core2duo CPU but not AMD FX or
Intel Core I7.

My code has 2 ways of setting the
guest registers: one is the guest's
ring0 stub that just pops all regs
from stack and does iret to ring3.
That works fine.
But sometimes I use KVM_SET_SREGS
and resume the VM directly to ring3.
That randomly results in either a
good run or invalid guest state
return, or a page fault in guest.

I tried to analyze when either of
the above happens exactly, and
I have a very strong suspection
that the problem is in a way I
update LDT. LDT is shared between
guest and host with KVM_SET_USER_MEMORY_REGION,
and I modify it on host.
So it seems like if I just allocated
the new LDT entry, there is a risk
of invalid guest state, as if the
guest's LDT still doesn't have it.
If I modified some LDT entry, there
can be a page fault in guest, as if
the entry is still old.

I've found that the one needs to
check KVM_CAP_SYNC_MMU to
safely write to the guest memory,
but it doesn't seem to be documented
well. Of course maybe my problem
has nothing to do with that, but I
think it does.
So can it be that even though I
check for the KVM_CAP_SYNC_MMU,
writing to the guest memory from
host is still unsafe? What is this
KVM_CAP_SYNC_MMU actually all
about?

