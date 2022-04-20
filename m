Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDCD508031
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 06:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359308AbiDTEj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 00:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359303AbiDTEj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 00:39:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B5631A05F
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 21:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650429430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQOHNPZTUOaysYmSTDrA55i6Fl6EOOvTznA+1gLQJg4=;
        b=Os15Awv8vZ3SWOoPX3Pi6Q/X8qeshLMVTh6mPeDJNW3KQ6gR5gq+aMje9u9pbNw/XXZH3o
        Repa3jKGLi75k2XlR2oJ2eHjF6Efk2ze1rhTb1pns2PKo+yvYF7hVZHPPVBMxyf1NABoGm
        zGdTI9yfxQ56MWdR6V8o1pkc4reMfrU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-QZo87eu1MGGvqboxyXWg5g-1; Wed, 20 Apr 2022 00:37:05 -0400
X-MC-Unique: QZo87eu1MGGvqboxyXWg5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 109D3800B28;
        Wed, 20 Apr 2022 04:37:04 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB67214583EE;
        Wed, 20 Apr 2022 04:36:58 +0000 (UTC)
Message-ID: <ad0023fd2ea0297e7bfb8a6a9535b2b8b8f56093.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: Add helpers to wrap vcpu->srcu_idx and yell if
 it's abused
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 20 Apr 2022 07:36:57 +0300
In-Reply-To: <Yl7ZMJ/takmHh7tY@google.com>
References: <20220415004343.2203171-1-seanjc@google.com>
         <20220415004343.2203171-4-seanjc@google.com>
         <5b561bf1a0bbf140ea09d516f946a4e8fee8dd2d.camel@redhat.com>
         <Yl7ZMJ/takmHh7tY@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-19 at 15:45 +0000, Sean Christopherson wrote:
> On Tue, Apr 19, 2022, Maxim Levitsky wrote:
> > On Fri, 2022-04-15 at 00:43 +0000, Sean Christopherson wrote:
> > > Add wrappers to acquire/release KVM's SRCU lock when stashing the index
> > > in vcpu->src_idx, along with rudimentary detection of illegal usage,
> > > e.g. re-acquiring SRCU and thus overwriting vcpu->src_idx.  Because the
> > > SRCU index is (currently) either 0 or 1, illegal nesting bugs can go
> > > unnoticed for quite some time and only cause problems when the nested
> > > lock happens to get a different index.
> > > 
> > > Wrap the WARNs in PROVE_RCU=y, and make them ONCE, otherwise KVM will
> > > likely yell so loudly that it will bring the kernel to its knees.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> 
> ...
> 
> > Looks good to me overall.
> > 
> > Note that there are still places that acquire the lock and store the idx into
> > a local variable, for example kvm_xen_vcpu_set_attr and such.
> > I didn't check yet if these should be converted as well.
> 
> Using a local variable is ok, even desirable.  Nested/multiple readers is not an
> issue, the bug fixed by patch 1 is purely that kvm_vcpu.srcu_idx gets corrupted.

Makes sense. I still recal *that* bug in AVIC inhibition where that srcu lock was
a major PITA, but now I remember that it was not due to nesting of the lock,
but rather fact that we attempted to call syncronize_srcu or something like that
with it held.


> 
> In an ideal world, KVM would _only_ track the SRCU index in local variables, but
> that would require plumbing the local variable down into vcpu_enter_guest() and
> kvm_vcpu_block() so that SRCU can be unlocked prior to entering the guest or
> scheduling out the vCPU.
> 
It all makes sense now - thanks.

Best regards,
	Maxim Levistky

