Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FEB6BEDF4
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCQQVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 12:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjCQQVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 12:21:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E0B26C3A
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 09:21:00 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x4-20020a170902ec8400b001a1a5f6f272so1501929plg.1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 09:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679070060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7o24l6fiOGywvlphm2ivpMOdYXRizefraPoQnT9L//E=;
        b=Q6gE273gkihi8mp0lUkxiT8ezb4i1bDN5mWojYXiFSbCt1gdV+GSm119e73GRHWveU
         BX7oyl+NnMHXsGN0MoPCc5ADNRD9sMejdGVqQyg1BFFO+uKHTSqgfBCRkwOUFIMy3VRm
         e9vrQ82Ak82Vfdr9u6yGZj6llbXvEMnk70DuJ6YhG9BhuixwafqpMoEX7hMO/92chbuY
         bowzGc908/CczWahD6JUJnaErwDYpFxrNsajMOceS8iF7nwQloz2BK0RucdP6gGBXynX
         TFjqAiKOslA8OqK+bdesF3cFxwkvsaaR83lJqgaTZQjWZJ8ETLkbSOmv3RxQ5lOu3Quv
         FfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7o24l6fiOGywvlphm2ivpMOdYXRizefraPoQnT9L//E=;
        b=2dt/lwAClznl7pAqHLDIvwnSsLNsOLlq3wJaS2nH65AKYgscGfsrq/+up57T1Dtl3E
         x8Cw3+alutKTFJVMrmUCtfO58apr4HbMcgiYFj9d0tsp2+xxSW5kZT7WvG7VRByY5gP5
         l1K7wpzhq0jLtYmFp3IgEG6o5FIhWpql1LUlFB6be8xfs4XdwKM2oW+p7HAwNFRiKIdA
         wjfOQ6Nupn1rvVDefZ57ldJoD8GpOPVQnm8kiUwD1+Q7WHw5OrMRr3MiMGhmAY4pqa4N
         AtourQ3XZOIKzN8DG/y/USwaajTHa8D6cuB98f/1K9//pqJuXtMPLmHn8XTw7+EXAOtS
         QFfA==
X-Gm-Message-State: AO0yUKX2EyfluqRnUb2n5QtwAV93KZURicGTbxrWSmXcGvenVBdH9wER
        5njiHHFDk4Gf9gJEL68uS7DAbxnT97c=
X-Google-Smtp-Source: AK7set/8zojERNqCXTgL/pFzMwr+KZPa+uB5aM7ijsiHAnfP0EdMkqyDGbo32YXbT/II5YP93V991/QrGl8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:17a7:b0:23d:34db:f5be with SMTP id
 q36-20020a17090a17a700b0023d34dbf5bemr2467306pja.4.1679070059931; Fri, 17 Mar
 2023 09:20:59 -0700 (PDT)
Date:   Fri, 17 Mar 2023 09:20:58 -0700
In-Reply-To: <ZBQaFRdRawenuEan@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-17-seanjc@google.com>
 <ZBQaFRdRawenuEan@yzhao56-desk.sh.intel.com>
Message-ID: <ZBSTapUu+VzWmIfQ@google.com>
Subject: Re: [PATCH v2 16/27] KVM: x86: Add a new page-track hook to handle
 memslot deletion
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Yan Zhao wrote:
> On Fri, Mar 10, 2023 at 04:22:47PM -0800, Sean Christopherson wrote:
> > From: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > Add a new page-track hook, track_remove_region(), that is called when a
> > memslot DELETE operation is about to be committed.  The "remove" hook
> > will be used by KVMGT and will effectively replace the existing
> > track_flush_slot() altogether now that KVM itself doesn't rely on the
> > "flush" hook either.
> > 
> > The "flush" hook is flawed as it's invoked before the memslot operation
> > is guaranteed to succeed, i.e. KVM might ultimately keep the existing
> > memslot without notifying external page track users, a.k.a. KVMGT.  In
> > practice, this can't currently happen on x86, but there are no guarantees
> > that won't change in the future, not to mention that "flush" does a very
> > poor job of describing what is happening.
> > 
> > Pass in the gfn+nr_pages instead of the slot itself so external users,
> > i.e. KVMGT, don't need to exposed to KVM internals (memslots).  This will
> > help set the stage for additional cleanups to the page-track APIs.
> > 
> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> ...
> 
> > +void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +{
> > +	struct kvm_page_track_notifier_head *head;
> > +	struct kvm_page_track_notifier_node *n;
> > +	int idx;
> > +
> > +	head = &kvm->arch.track_notifier_head;
> > +
> > +	if (hlist_empty(&head->track_notifier_list))
> > +		return;
> > +
> > +	idx = srcu_read_lock(&head->track_srcu);
> > +	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > +				srcu_read_lock_held(&head->track_srcu))
> Sorry, not sure why the alignment here is not right.
> Patchwork just sent me a mail to complain about it.
> Would you mind helping fix it in the next version?

Ah, it's off by two spaces, should be 

	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
				  srcu_read_lock_held(&head->track_srcu))

I'll get it fixed in the next version.
