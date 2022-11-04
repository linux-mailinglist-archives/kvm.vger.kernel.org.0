Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73561A404
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 23:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiKDWXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 18:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKDWXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 18:23:13 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0612D775
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 15:23:09 -0700 (PDT)
Date:   Fri, 4 Nov 2022 22:23:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667600588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=43rE8449ZA7RnQbWm7rB14AGuyEAs2Cqf2MmYOuEeis=;
        b=KtO70yIWLIG65aNkmLBqbApAYzf4PgA71drYUOQAG8xzy0NEoAqLDq4/w2l90ngnhFpWc/
        yz4Ebn90BVG8oNXY86Y2/ZaEQ/hixZVScNXKqeCwZDFD0IURuVETOP+Gi91qdk5xk0fV+z
        HOA3H4/lWXP8+b4Y+SW+fxTcDgXqRug=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2WQxsgOBZwzWzPq@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
 <Y2RPhwIUsGLQ2cz/@google.com>
 <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
 <Y2RlfkyQMCtD6Rbh@google.com>
 <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
 <Y2VyMwAlg7U9pXzV@google.com>
 <f2d95d47-6411-8d01-14eb-5e17e1a16dbf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2d95d47-6411-8d01-14eb-5e17e1a16dbf@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 05, 2022 at 05:57:33AM +0800, Gavin Shan wrote:
> On 11/5/22 4:12 AM, Oliver Upton wrote:
> > I agree that we should address (1) like this, but in (2) requiring that
> > no memslots were created before enabling the existing capabilities would
> > be a change in ABI. If we can get away with that, great, but otherwise
> > we may need to delete the bitmaps associated with all memslots when the
> > cap is enabled.
> > 
> 
> I had the assumption QEMU and kvm/selftests are the only consumers to
> use DIRTY_RING. In this case, requiring that no memslots were created
> to enable DIRTY_RING won't break userspace.
> Following your thoughts, the tracked dirty pages in the bitmap also
> need to be synchronized to the per-vcpu-ring before the bitmap can be
> destroyed.

Eh, I don't think we'd need to go that far. No matter what, any dirty
bits that were present in the bitmap could never be read again anyway,
as we reject KVM_GET_DIRTY_LOG if kvm->dirty_ring_size != 0.

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 91cf51a25394..420cc101a16e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4588,6 +4588,32 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> >   			return -EINVAL;
> >   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> > +
> > +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> > +		struct kvm_memslots *slots;
> > +		int r = -EINVAL;
> > +
> > +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > +		    !kvm->dirty_ring_size)
> > +			return r;
> > +
> > +		mutex_lock(&kvm->slots_lock);
> > +
> > +		slots = kvm_memslots(kvm);
> > +
> > +		/*
> > +		 * Avoid a race between memslot creation and enabling the ring +
> > +		 * bitmap capability to guarantee that no memslots have been
> > +		 * created without a bitmap.
> > +		 */
> > +		if (kvm_memslots_empty(slots)) {
> > +			kvm->dirty_ring_with_bitmap = cap->args[0];
> > +			r = 0;
> > +		}
> > +
> > +		mutex_unlock(&kvm->slots_lock);
> > +		return r;
> > +	}
> >   	default:
> >   		return kvm_vm_ioctl_enable_cap(kvm, cap);
> >   	}
> > 
> 
> The proposed changes look good to me. It will be integrated to PATCH[v8 4/9].
> By the way, v8 will be posted shortly.

Excellent, thanks!

--
Best,
Oliver
