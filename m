Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5400936BB7A
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 00:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbhDZWI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 18:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhDZWI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 18:08:27 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F95C061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 15:07:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c3so21173391pfo.3
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 15:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fjH5kB/JTnA1RzWpA0aE2/CKmQP+jAHV1fszdeb88cc=;
        b=lcMAD9L/KGqn3ZH8e3vkEz/hCqf6bMFTfZ/w3na/YVrVrAUivgkovBpiI9nxJhKXW9
         5BDa1lEy2s40bE/i0KSrmeWYQsNW7XrtJyqNOfdPH8TzHzVFl4/LXBdig3WkY2jB4qrp
         zcVUV9BFz+SRyczkuCMnoYFvy7L+cn9D1oZG2rISLz+jv03utmlrM4WHKLTC3k4L7M1y
         hzPRV2h9zMlxGUcqnSVK2ww2uQnA79T5F1wrEcIuVbWpyv4e6lw1MLb8cWOTagHHk7Hh
         9u1svrCr1D5T/sz7Cz3jO0dUGkQSl9ij/5Of5t1YvTd2M6yrdw0a3S+lOgAgoVzLZ6C5
         VXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fjH5kB/JTnA1RzWpA0aE2/CKmQP+jAHV1fszdeb88cc=;
        b=Y4s1ljAoi8MUDo0lSTst/FuDVg3qSxayRI/37bJTtMBOJzCpf97eLnba/fsvH5wL7d
         5y5HgSTq0chPiWKWTIraehvnEOODEQI58yZ1JYJRCtSsgfqeV28oKFJejjFsqLHcOfVk
         GSZrTJBWBBKWQdnidEBg8N6KvVKX15QwKSzCZhZ+bMBlE8RxbocRbwGMtADQjjPvGSkP
         GJsxUtbcx349PdIFie53uXUJeRyJuncsIiIMwsHggobmBtdiCgckDbkbAKRbi2yLRImf
         B3pwxRxfrf1RkJzL2wg7lg3kUs8k5awkiwG9WX5s8Izr5BfUbUEEmutos7MuUBO53O1z
         YjuQ==
X-Gm-Message-State: AOAM533/MH0JYx/B1OS6Ypup0SGkLPAMX+mB6Z8pwgdNPy3FWaIvXHqa
        q2oYnbMNiOsZKcgLAOIVSe8zwA==
X-Google-Smtp-Source: ABdhPJzetwu16fyU1mEH1IFm4P3+AjGmL+Tzuwf4IkEIw3UlqVw4VqAhZAO5wxSRm+mNTFU39fNFiA==
X-Received: by 2002:a62:1b4d:0:b029:253:ccef:409d with SMTP id b74-20020a621b4d0000b0290253ccef409dmr19847447pfb.4.1619474863914;
        Mon, 26 Apr 2021 15:07:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j24sm506397pjy.1.2021.04.26.15.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 15:07:43 -0700 (PDT)
Date:   Mon, 26 Apr 2021 22:07:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
Message-ID: <YIc5q2WO5JpsDwZt@google.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
 <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
 <YIG6B+LBsRWcpftK@google.com>
 <a9f74546-6ab7-88fc-83d1-382b380f6264@oracle.com>
 <YILuJohrTE+P06tt@google.com>
 <d6bf17a8-029a-37ec-ab96-5e2bebedb88a@redhat.com>
 <0b239edb-acdf-f0c8-3712-6afb38ab86a6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b239edb-acdf-f0c8-3712-6afb38ab86a6@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021, Krish Sadhukhan wrote:
> 
> On 4/23/21 1:31 PM, Paolo Bonzini wrote:
> > On 23/04/21 17:56, Sean Christopherson wrote:
> > > On Thu, Apr 22, 2021, Krish Sadhukhan wrote:
> > > > On 4/22/21 11:01 AM, Sean Christopherson wrote:
> > > > >         offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
> > > > > 
> > > > >         if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value,
> > > > > 4)) <- This reads vmcb12
> > > > >             return false;
> > > > > 
> > > > >         svm->nested.msrpm[p] = svm->msrpm[p] | value; <-
> > > > > Merge vmcb12's bitmap to KVM's bitmap for L2
> > > 
> > > ...
> > > > Getting back to your concern that this patch breaks
> > > > nested_svm_vmrun_msrpm().  If L1 passes a valid address in which
> > > > some bits
> > > > in 11:0 are set, the hardware is anyway going to ignore those bits,
> > > > irrespective of whether we clear them (before my patch) or pass
> > > > them as is
> > > > (my patch) and therefore what L1 thinks as a valid address will
> > > > effectively
> > > > be an invalid address to the hardware. The only difference my
> > > > patch makes is
> > > > it enables tests to verify hardware behavior. Am missing something ?
> > > 
> > > See the above snippet where KVM reads the effectively vmcb12->msrpm
> > > to merge L1's
> > > desires with KVM's desires.  By removing the code that ensures
> > > svm->nested.ctl.msrpm_base_pa is page aligned, the above offset
> > > calculation will
> > > be wrong.
> > 
> > In fact the kvm-unit-test you sent was also wrong for this same reason
> > when it was testing addresses near the end of the physical address
> > space.
> > 
> > Paolo
> > 
> It seems to me that we should clear bits 11:0 in nested_svm_vmrun_msrpm()
> where we are forming  msrpm_base_pa address for vmcb02. 
> nested_svm_check_bitmap_pa() aligns the address passed to it, before
> checking it.
> 
> Should I send a patch for this ?

I don't see any reason to leave the bits set in svm->nested.ctl.msrpm_base_pa
any longer than they absolutely need to be set, i.e.
nested_load_control_from_vmcb12() feels like the best place to clear the offset.

If we really want to change something, we could WARN in the consistency check on
an unaligned address, e.g.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 540d43ba2cf4..56e109d2ea7f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -220,7 +220,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
  */
 static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 {
-       u64 addr = PAGE_ALIGN(pa);
+       WARN_ON_ONCE(!PAGE_ALIGNED(pa));

        return kvm_vcpu_is_legal_gpa(vcpu, addr) &&
            kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
