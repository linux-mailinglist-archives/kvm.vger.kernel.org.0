Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD81A358473
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhDHNSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhDHNSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:18:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CFCC061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 06:18:31 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617887903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=R3zqpOysd+UgmybGo5NkOd2hIbYM3pm4y3c57K63JxA=;
        b=ENEhqGLkUvzI55KKXqGU3V8xzhqVR+tPxf5r7dyk9yRRI7SeIJIaN/+DxQ813iDUkmIjLx
        QXwfKUTPMOCVP+lLCwi17wenWjeNHHO6l84WdKAWYuYBJiwUwZzv1LQJOzGOakQDDII6k/
        4IWVByqdeg1hN8nNAFsSHWR7gdBlaZxiKfGDmLKV89Qoy3lNvtUbpEF6mETNPkEkcgWm6E
        DvOFMMRkRv7wg4kdTCfOcU5LsnEbWohnbfBICbYQFFufPSfVtr6eWVEKsk/vPBqNfIsZ2p
        NqdHOEo76isPI7/BVR37NPHtV874x2mo9eGmTgOl7RBLvreRzQJP06y2zrtmRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617887903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=R3zqpOysd+UgmybGo5NkOd2hIbYM3pm4y3c57K63JxA=;
        b=j0BgA4b2utC5JU1UQGkKE9lOkh/3swaNqVDzrGQ5PbRq2VaxQOjbHjUSPSmzBhoFPBtgM8
        5PzstL9LzDhmDHBQ==
To:     Sean Christopherson <seanjc@google.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke guest time accounting
In-Reply-To: <YGzW/Pa/p7svg5Rr@google.com>
Date:   Thu, 08 Apr 2021 15:18:23 +0200
Message-ID: <874kgg29uo.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06 2021 at 21:47, Sean Christopherson wrote:
> On Tue, Apr 06, 2021, Michael Tokarev wrote:
>> broke kvm guest cpu time accounting - after this commit, when running
>> qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
>> elsewhere) is always 0.
>> 
>> I dunno why it happened, but it happened, and all kernels after 5.9
>> are affected by this.
>> 
>> This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.
>
> Yes :-(
>
> There's a bugzilla[1] and two proposed fixes[2][3].  I don't particularly like
> either of the fixes, but an elegant solution hasn't presented itself.
>
> Thomas/Paolo, can you please weigh in?
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=209831
> [2] https://lkml.kernel.org/r/1617011036-11734-1-git-send-email-wanpengli@tencent.com
> [3] https://lkml.kernel.org/r/20210206004218.312023-1-seanjc@google.com

All of the solutions I looked at so far are ugly as hell. The problem is
that the accounting is plumbed into the context tracking and moving
context tracking around to a different place is just wrong.

I think the right solution is to seperate the time accounting logic out
from guest_enter/exit_irqoff() and have virt time specific helpers which
can be placed at the proper spots in kvm.

Thanks,

        tglx
