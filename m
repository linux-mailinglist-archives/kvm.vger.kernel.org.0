Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF46608207
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 01:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJUXUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 19:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJUXUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 19:20:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D7013A7C5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 16:20:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so8050761pji.1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 16:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFADivTYXt0iKSYFDxxhriwNslLr2BBs3QCrxCOrPv0=;
        b=JMpqIw8HrIHaARoGbz2ckXu5phVBgKB2SlFp+CU7/Tdp/eJmEYUhUuylltTlK0rSCE
         /n/X12NN/OLNE/HUMBpRD03hTsarM5CErCaIaw4KnuQXKr6eQI5H2UyPP3kUcowR3Ryq
         bBPJdRLBfZtNDyln1wKS7dawow7EoynVjYlsQb2wlT75jtTw51/3hzRy+IJ9VUeXALBm
         kVAN9zmns5pt9dWue2xuwvach+sF8Ps+AIgC2HSMWOdhVxKwH/Bo6rYE49wNTojhX4lm
         Wcr1Rg96YMiFOykzWWWsmI89XCrxImvrbYWDn5dSHZKDeJy63A59BSE0VLMn1vEAf9Ua
         bxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFADivTYXt0iKSYFDxxhriwNslLr2BBs3QCrxCOrPv0=;
        b=qD6Oblnv2wlMVhZr/Nm6VCqpnGgdmpBQJJyayoSOyYZ8Tr3xYSMtyNpIMaoXzLZ9l7
         ThFComu/txiP8zCUdETbkB6FEYJIyIv2OgPZLRRAwyHYqfJxnt5GmARx6R+VThofNrhO
         dY3y+hcsENszxGa/OmOu9bXY45yAgenqfTRt2VCQZqKJvTFQi4piL7K69/BBXEEl33I/
         Q4FefR/YjSpWRVB1Jtz+h45qS+5jyr+Vyu7k8Z2XVSH7YMnBUr9NGjQcAV6KHDMzKglu
         mJoZlxE9B/n0QsuCEgdcRo+pLK3NzrQnFUUdwhSRyYzSrk44FfbYXedxZmUziXo8w3FH
         QwUA==
X-Gm-Message-State: ACrzQf1jeNlsEnxuqLVl1JKDWpzk7BwWx4Uvhkp8rlO44tO3iLUc8otl
        h4mEeIivCqOB3WcTDaBUtRvaOA==
X-Google-Smtp-Source: AMsMyM4YaAa0ABZCj2ASInN0Xf13/04WyHFeFgtdb7Q3O6eD2rm1C4Ul/kgrQ1rH0j4m8Rhz7mpeMg==
X-Received: by 2002:a17:902:d542:b0:186:6399:6b4f with SMTP id z2-20020a170902d54200b0018663996b4fmr10731662plf.162.1666394437621;
        Fri, 21 Oct 2022 16:20:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l10-20020a170902f68a00b0017834a6966csm15645992plg.176.2022.10.21.16.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 16:20:37 -0700 (PDT)
Date:   Fri, 21 Oct 2022 23:20:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1MpQTprxk+XdYFb@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <0adc538b-594e-c662-5a38-3ca6b98ab059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0adc538b-594e-c662-5a38-3ca6b98ab059@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022, Gavin Shan wrote:
> > What about inverting the naming to better capture that this is about the dirty
> > bitmap, and less so about the dirty ring?  It's not obvious what "exclusive"
> > means, e.g. I saw this stub before reading the changelog and assumed it was
> > making a dirty ring exclusive to something.
> > 
> > Something like this?
> > 
> > bool kvm_use_dirty_bitmap(struct kvm *kvm)
> > {
> > 	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
> > }
> > 
> 
> If you agree, I would rename is to kvm_dirty_ring_use_bitmap(). In this way,
> we will have "kvm_dirty_ring" prefix for the function name, consistent with
> other functions from same module.

I'd prefer to avoid "ring" in the name at all, because in the common case (well,
legacy case at least) the dirty ring has nothing to do with using the dirty
bitmap, e.g. this code ends up being very confusing because the "dirty_ring"
part implies that KVM _doesn't_ need to allocate the bitmap when the dirty ring
isn't being used.

		if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
			new->dirty_bitmap = NULL;
		else if (old && old->dirty_bitmap)
			new->dirty_bitmap = old->dirty_bitmap;
		else if (kvm_dirty_ring_use_bitmap(kvm) {
			r = kvm_alloc_dirty_bitmap(new);
			if (r)
				return r;

			if (kvm_dirty_log_manual_protect_and_init_set(kvm))
				bitmap_set(new->dirty_bitmap, 0, new->npages);
		}

The helper exists because the dirty ring exists, but the helper is fundamentally
about the dirty bitmap, not the ring.

> > But dirty_ring_with_bitmap really shouldn't need to exist.  It's mandatory for
> > architectures that have HAVE_KVM_DIRTY_RING_WITH_BITMAP, and unsupported for
> > architectures that don't.  In other words, the API for enabling the dirty ring
> > is a bit ugly.
> > 
> > Rather than add KVM_CAP_DIRTY_LOG_RING_ACQ_REL, which hasn't been officially
> > released yet, and then KVM_CAP_DIRTY_LOG_ING_WITH_BITMAP on top, what about
> > usurping bits 63:32 of cap->args[0] for flags?  E.g.
> > 
> > Ideally we'd use cap->flags directly, but we screwed up with KVM_CAP_DIRTY_LOG_RING
> > and didn't require flags to be zero :-(
> > 
> > Actually, what's the point of allowing KVM_CAP_DIRTY_LOG_RING_ACQ_REL to be
> > enabled?  I get why KVM would enumerate this info, i.e. allowing checking, but I
> > don't seen any value in supporting a second method for enabling the dirty ring.
> > 
> > The acquire-release thing is irrelevant for x86, and no other architecture
> > supports the dirty ring until this series, i.e. there's no need for KVM to detect
> > that userspace has been updated to gain acquire-release semantics, because the
> > fact that userspace is enabling the dirty ring on arm64 means userspace has been
> > updated.
> > 
> > Same goes for the "with bitmap" capability.  There are no existing arm64 users,
> > so there's no risk of breaking existing userspace by suddenly shoving stuff into
> > the dirty bitmap.
> > 
> > KVM doesn't even get the enabling checks right, e.g. KVM_CAP_DIRTY_LOG_RING can be
> > enabled on architectures that select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL but not
> > KVM_CAP_DIRTY_LOG_RING.  The reverse is true (ignoring that x86 selects both and
> > is the only arch that selects the TSO variant).
> > 
> > Ditto for KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP...
> 
> If I didn't miss anything in the previous discussions, we don't want to make
> KVM_CAP_DIRTY_LOG_RING_ACQ_REL and KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
> architecture dependent. If they become architecture dependent, the userspace
> will have different stubs (x86, arm64, other architectures to support
> dirty-ring in future) to enable those capabilities. It's not friendly to
> userspace. So I intend to prefer the existing pattern: advertise, enable. To
> enable a capability without knowing if it's supported sounds a bit weird to
> me.

Enabling without KVM advertising that it's supported would indeed be odd.  Ugh,
and QEMU doesn't have existing checks to restrict the dirty ring to x86, i.e. we
can't make the ACQ_REL capability a true attribute without breaking userspace.

Rats.

> I think it's a good idea to enable KVM_CAP_DIRTY_LOG_RING_{ACQ_REL, WITH_BITMAP} as
> flags, instead of standalone capabilities. In this way, those two capabilities can
> be treated as sub-capability of KVM_CAP_DIRTY_LOG_RING. The question is how these
> two flags can be exposed by kvm_vm_ioctl_check_extension_generic(), if we really
> want to expose those two flags.
> 
> I don't understand your question on how KVM has wrong checks when KVM_CAP_DIRTY_LOG_RING
> and KVM_CAP_DIRTY_LOG_RING_ACQ_REL are enabled.

In the current code base, KVM only checks that _a_ form of dirty ring is supported,
by way of kvm_vm_ioctl_enable_dirty_log_ring()'s check on KVM_DIRTY_LOG_PAGE_OFFSET.

The callers don't verify that the "correct" capability is enabled.

	case KVM_CAP_DIRTY_LOG_RING:
	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);

E.g. userspace could do

	if (kvm_check(KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
		kvm_enable(KVM_CAP_DIRTY_LOG_RING)

and KVM would happily enable the dirty ring.  Functionally it doesn't cause
problems, it's just weird.

Heh, we can fix without more ifdeffery by using the check internally.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4ecfa5..300489a0eba5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4585,6 +4585,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
        }
        case KVM_CAP_DIRTY_LOG_RING:
        case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
+               if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap))
+                       return -EINVAL;
                return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
        default:
                return kvm_vm_ioctl_enable_cap(kvm, cap);
