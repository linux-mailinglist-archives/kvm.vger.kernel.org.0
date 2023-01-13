Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2CE66A5E9
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjAMW0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjAMW0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:26:50 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C076E76AE9;
        Fri, 13 Jan 2023 14:26:48 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pGSVY-005JCK-Je; Fri, 13 Jan 2023 23:26:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=2a+4kzQ6dFuhK25afJPp6fpl3dbzUdByM7s2DZ5lNqI=; b=mNbChxh+BQB0p01St8K1jzOgNW
        I7eFp9Y9u9t9oMjl2hZDWCOw1DIBibltPdWqBCJzYRtFiqxZgI5d7/RVHndRx4hLC1B+/DhJJkOzR
        yStOgK0qj8DVi6kV/LkRn+AZsXVJVUjLJH5x8RmBZStNSzz3YyhOpqudd+/zbcecioQVljNjlZNE5
        +qrmmXTBoZYgLR3oINLh9BPETlnjUF34vv1DZw6TtVOh5b6++Q7uBfSmKo41wc3UAtm6KWcUgX7i0
        BLNNp3RyTasGXRAAOLvTRmziZWc39Ckt8883K+PIAAZCvOWQsowr2zvCh3rglazS/1kc7sy23rA0t
        dl/SALbg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pGSVW-0004wp-CD; Fri, 13 Jan 2023 23:26:42 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pGSVE-0008CI-MI; Fri, 13 Jan 2023 23:26:24 +0100
Message-ID: <93e647dc-4465-5e28-e102-3e5fdd6697fe@rbox.co>
Date:   Fri, 13 Jan 2023 23:26:19 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH] Documentation: kvm: fix SRCU locking order docs
Content-Language: pl-PL
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <20230111183031.2449668-1-pbonzini@redhat.com>
 <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
 <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y8EF24o932lcshKs@boqun-archlinux>
 <d1d44f07-558c-e0ed-403e-61a854c868cb@redhat.com>
 <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
 <41fad1dc90c2bef4f2f17f1495c2f85105707d9f.camel@infradead.org>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <41fad1dc90c2bef4f2f17f1495c2f85105707d9f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/23 12:03, David Woodhouse wrote:
> On Fri, 2023-01-13 at 10:33 +0000, David Woodhouse wrote:
>> So everything seems to be working as it should... *except* for the fact
>> that I don't quite understand why xen_shinfo_test didn't trigger the
>> warning. Michal, I guess you already worked that out when you came up
>> with your deadlock-test instead... is there something we should add to
>> xen_shinfo_test that would mean it *would* have triggered?

No, I didn't implement those deadlock selftests out of xen_shinfo_test
because there was some problem. I just wanted to have a cleaner workspace
and then, maybe, move them to xen_shinfo_test, which, well, did not happen
:) I guess there's no need for them filthy races anymore; lockdep does a
better job.

> Got it. It only happens when kvm_xen_set_evtchn() takes the slow path
> when kvm_xen_set_evtchn_fast() fails.

I fully agree. And sorry for late reply.

> Not utterly sure why that works
> in your deadlock_test but I can make it happen in xen_shinfo_test just
> by invalidating the GPC by changing the memslots:

Could it be that deadlocks_test starts with the right conditions, i.e.
invalid KVM_XEN_ATTR_TYPE_SHARED_INFO along with valid
KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO? xen_shinfo_test, on the other hand, have
them both valid, and so the fast path is taken.

I suppose instead of changing memslots, you can invalidate the
KVM_XEN_ATTR_TYPE_SHARED_INFO for that particular test unit, e.g.

	struct kvm_xen_hvm_attr ha = {
		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
		.u.shared_info.gfn = KVM_XEN_INVALID_GFN,
	};
	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ha);

One more thing concerning the lockdep priming you did in kvm_create_vm();

	mutex_lock(&kvm->lock);
	synchronize_srcu(&kvm->srcu);
	mutex_unlock(&kvm->lock)

It seems that deadlocks_test's set_msr_filter() effectively did the same
thanks to kvm_vm_ioctl_set_msr_filter()'s sync-under-mutex (which won't
happen if those I-used-to-be-a-deadlock optimization patches[*] get
merged). Naturally, xen_shinfo_test do not mess with MSR filters, so that
could be another reason for inconsistencies you've noticed before the
priming?

[*] https://lore.kernel.org/kvm/20230107001256.2365304-1-mhal@rbox.co/

Michal

