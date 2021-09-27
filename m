Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEB419FBC
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 22:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhI0UHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 16:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbhI0UG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 16:06:57 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C51C061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 13:05:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 17so18814859pgp.4
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 13:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J1OTP+7DOGmeKvtWkpynSAHibvAphxBoBf7TlJ1W75g=;
        b=nJh8y9Ji6F34ZL+jQC5GvuQsdn5mLwOEp8jloJUDmMe6dn3HrdoI/S/FslqkPVgtgh
         xKjv46ot3H+sEkrUr3qHSBTFbHa+owZkstZR5JBmM58W4ka0J3+XU890WfZgQ92ELms3
         7Ifyncde5P2FEeumN+HL3eg3VYKdnsuCVs905IJP3D9NGkuCAk49lQ286dmIV/zoeuY1
         OH5jdcRW0CDNLKmGnDLvIbx0GIPiSvh6mteEIVaa2231AnsJFSjZHYarcSnZexORgcFx
         ipYHtuIOyhe5oHruK/O8EBryz6Vd9zZzKrqJ894QDcOvAG845h6P2g9WYbpb5HD74Ui/
         IKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J1OTP+7DOGmeKvtWkpynSAHibvAphxBoBf7TlJ1W75g=;
        b=jSCBIIs4okvvT5Qk1+Flek7zqIJnvX83gtatjjCoYB3syT1khv2eGIOatseYWYbIIT
         9bNwH0784/vosOReLQhUmZfwT6nmtWqg6wi/IjdZtAD8wTQaxmC70HDB/8cbbqZzefB3
         zUGcdM2fUq2OSqz1jOWai/BVjc1w05RKfHSGLXUPk2WFINpG3LTgnd+QHeSNqKBHKy7E
         7WH+ZEaRMj1ZieWTxmtN0yJkc0keOjvmjgxZEmx6pAr5Hsx31lDaSTceCqeYBzO6Ai0X
         TZyQQ25TL8mgz9bGJtenV1UBinp+jKmJehEAAhb27oMMoQSvsEdmYQQKK60E4PA6XXxE
         qn3w==
X-Gm-Message-State: AOAM531Q5sFdWCMWEUEtYN5Z6svEUHPsjkkeNTJQIprPggJ0NVzaKNBa
        yfVWZjxq4zuXVWOBWPx4cqzDMg==
X-Google-Smtp-Source: ABdhPJxTlxHvtc5rugG/tFQUBdwxNnPR3lb994WAssd3KxL7MTB0W9h/Ymf1p6dZMMoJeUKmlzLzpA==
X-Received: by 2002:a63:4f0f:: with SMTP id d15mr1226386pgb.464.1632773118918;
        Mon, 27 Sep 2021 13:05:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 2sm252633pjt.23.2021.09.27.13.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 13:05:18 -0700 (PDT)
Date:   Mon, 27 Sep 2021 20:05:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <YVIj+gExrHrjlQEm@google.com>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <20210924064732.xqv2xjya3pxgmwr2@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924064732.xqv2xjya3pxgmwr2@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021, Andrew Jones wrote:
> On Fri, Sep 24, 2021 at 12:09:06AM +0000, Sean Christopherson wrote:
> > On Thu, Sep 23, 2021, Oliver Upton wrote:
> > > While x86 does not require any additional setup to use the ucall
> > > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > > ucall to userspace. rseq_test does not initialize the MMIO address,
> > > resulting in the test spinning indefinitely.
> > > 
> > > Fix the issue by calling ucall_init() during setup.
> > > 
> > > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > > index 060538bd405a..c5e0dd664a7b 100644
> > > --- a/tools/testing/selftests/kvm/rseq_test.c
> > > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> > >  	 * CPU affinity.
> > >  	 */
> > >  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> > > +	ucall_init(vm, NULL);
> > 
> > Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> > going to remember to add this next time I write a common selftest, arm64 is the
> > oddball here.

Ugh, reading through arm64's ucall_init(), moving this to vm_create() is a bad
idea.  If a test creates memory regions at hardcoded address, the test could
randomly fail if ucall_init() selects a conflicting address.  More below.

> Yes, please. But, it'll take more than just adding a ucall_init(vm, NULL)
> call to vm_create. We should also modify aarch64's ucall_init to allow
> a *new* explicit mapping to be made. It already allows an explicit mapping
> when arg != NULL, but we'll need to unmap the default mapping first, now.
> The reason is that a unit test may not be happy with the automatically
> selected address (that hasn't happened yet, but...) and want to set its
> own.

My vote would be to rework arm64's ucall_init() as a prep patch and drop the param
in the process.  There are zero tests that provide a non-NULL value, but that's
likely because tests that care deliberately defer ucall_init() until after memory
regions and page tables have been configured.

IMO, arm64's approach is unnecessarily complex (that's a common theme for KVM's
selftests...).  The code attempts to avoid magic numbers by not hardcoding the MMIO
range, but in doing so makes the end result even more magical, e.g. starting at
5/8ths of min(MAX_PA, MAX_VA).

E.g. why not put the ucall MMIO range immediately after the so called "default"
memory region added at the end of vm_create()?  That way the location of the ucall
range is completely predictable, and while still arbitrary, less magical.
