Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B1B5EE11B
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 17:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiI1P70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 11:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiI1P7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 11:59:03 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C299797EDF
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 08:58:46 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q9so12592215pgq.8
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 08:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=L3QchRnIwNtjYNnJS8opK3mIqahWmFCOi7dCIaQNGpQ=;
        b=RaKb42er+MjS42RMxVXedUMDvhhxKAIdOGmh/mFTePqClPo9pGhZyQdD9An6qSCOUQ
         HQ3EQJ4FYjKsdBIH0zKQVFKYyE/5rZThQKY0FT+1YnmmRBgIkGVjMh4WPBA0tbA+VNBu
         HV3JMXYCGrT5FjEYJjxO1w2Qp+ACW/7KJQpJ8/YCUtlAKJcY5/pea/dmNbm9p7NY3Vjt
         JxarsJ1pHxv5WyfTd7qvVuSOVhSKW13GDDJsA6E1GMAejclyTZp0PW5DSUhDtf9lIg2D
         TYAlpTqriEplL8CmzvuqxaP0R7CIG4Mkv0a2pxzB9j4ETVM6kT3LdUwiqPwvtiXh9Lov
         tduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=L3QchRnIwNtjYNnJS8opK3mIqahWmFCOi7dCIaQNGpQ=;
        b=0033Wo6UE/WUTIdsc7tWLr9VilbD2vWNvDiBWL6QKTmEG7vK4Bvh4SY+vNXk4HBnE+
         E2Rukl6hA1g+ru9OlKKFpuGddaOwxaw7Uo7He69vJ1pmQDHCs86SG2gc4fN0jplh06hC
         MTTD9NouRk64NBT7I30WVb2P2OPKXUe+/NMIvIUpMScZG4dJXN6nSaplWGuKnCzg2WXW
         7xINq8oRDsqLmBTSgbNTaTzXrzrreeJCGrr0BeG+jBZeP1coPSi+i+5HTrSV0rDADzYj
         ZN7kiehqnz8Qh1bgqomj1trZoG+SKQ8JkOzgRSBJ5LCtsfAI7mAqcaD5LGaZ1PHkVlpe
         PZaA==
X-Gm-Message-State: ACrzQf38QMIhG3oVLYxHNhBWhgDNN3OcKIyg/EYQaQ5y8XGYjiNHQSfT
        GSBkLW8yuJQQoH9SoTYPUR70ItLXJBREbQ==
X-Google-Smtp-Source: AMsMyM5SJmLnZCdCUJ8z8qBS6CbX5hvrwt1UHPHDFcOUfquiSbTmDTGbJJDQJKdCWHc/q7apaDcuAA==
X-Received: by 2002:aa7:952f:0:b0:540:e8ee:a077 with SMTP id c15-20020aa7952f000000b00540e8eea077mr35369339pfp.34.1664380726165;
        Wed, 28 Sep 2022 08:58:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l2-20020a622502000000b00541206f9379sm4287727pfl.99.2022.09.28.08.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:58:45 -0700 (PDT)
Date:   Wed, 28 Sep 2022 15:58:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Message-ID: <YzRvMZDoukMbeaxR@google.com>
References: <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
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

On Wed, Sep 28, 2022, Paolo Bonzini wrote:
> On 9/27/22 17:58, Sean Christopherson wrote:
> > I'm pretty sure this patch will Just Work for QEMU, because QEMU simply resumes
> > the vCPU if mmio.len==0.  It's a bit of a hack, but I don't think it violates KVM's
> > ABI in any way, and it can even become "official" behavior since KVM x86 doesn't
> > otherwise exit with mmio.len==0.
> 
> I think this patch is not a good idea for two reasons:
> 
> 1) we don't know how userspace behaves if mmio.len is zero.  It is of course
> reasonable to do nothing, but an assertion failure is also a valid behavior

Except that KVM currently does neither.  If the fetch happens at CPL>0 and/or in
L2, KVM injects #UD.  That's flat out architecturally invalid.  If it's a sticking
point, the mmio.len==0 hack can be avoided by defining a new exit reason.

> 2) more important, there is no way to distinguish a failure due to the guest
> going in the weeds (and then KVM_EXIT_INTERNAL_ERROR is fine) from one due
> to the KVM_SET_USER_MEMORY_REGION race condition.  So this will cause a
> guest that correctly caused an internal error to loop forever.

Userspace has the GPA and absolutely should be able to detect if the MMIO may have
been due to its memslot manipulation versus the guest jumping into the weeds.

> While the former could be handled in a "wait and see" manner, the latter in
> particular is part of the KVM_RUN contract.  Of course it is possible for a
> guest to just loop forever, but in general all of KVM, QEMU and upper
> userspace layers want a crashed guest to be detected and stopped forever.
> 
> Yes, QEMU could loop only if memslot updates are in progress, but honestly
> all the alternatives I have seen to atomic memslot updates are really
> *awful*.  David's patches even invent a new kind of mutex for which I have
> absolutely no idea what kind of deadlocks one should worry about and why
> they should not exist; QEMU's locking is already pretty crappy, it's
> certainly not on my wishlist to make it worse!
> 
> This is clearly a deficiency in the KVM kernel API, and (thanks to SRCU) the
> kernel is the only place where you can have a *good* fix.  It should have
> been fixed years ago.

I don't disagree that the memslots API is lacking, but IMO that is somewhat
orthogonal to fixing KVM x86's "code fetch to MMIO" mess.  Such a massive new API
should be viewed and prioritized as a new feature, not as a bug fix, e.g. I'd
like to have the luxury of being able to explore ideas beyond "let userspace
batch memslot updates", and I really don't want to feel pressured to get this
code reviewed and merge.

E.g. why do a batch update and not provide KVM_SET_ALL_USER_MEMORY_REGIONS to
do wholesale replacement?  That seems like it would be vastly simpler to handle
on KVM's end.  Or maybe there's a solution in the opposite direction, e.g. an
API that allows 1->N or N->1 conversions but not arbitrary batching.

And just because QEMU's locking is "already pretty crappy", that's not a good
reason to drag KVM down into the mud.  E.g. taking a lock and conditionally
releasing it...  I get that this is an RFC, but IMO anything that requires such
shenanigans simply isn't acceptable.

  /*
   * Takes kvm->slots_arch_lock, and releases it only if
   * invalid_slot allocation, kvm_prepare_memory_region failed
   * or batch->is_move_delete is true.
   */
  static int kvm_prepare_memslot(struct kvm *kvm,
			         struct kvm_internal_memory_region_list *batch)
