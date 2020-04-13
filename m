Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89341A6FE6
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 01:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390343AbgDMX4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 19:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390309AbgDMX4D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 19:56:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD804C0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 16:56:02 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f19so11345106iog.5
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 16:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4Lz+XGrNozlOzGsHPZGzl/5NMlzsSNvakDIy1S3BqQ=;
        b=o57SoboRJyYwmqOxCsSq4HNsIDeclF30uNzb+W2PmhRhl2Ej2GQrhZKthrrTRsbgsk
         8G+4T9uJ4YwvgceJm/2wVdixlkyDwXhBe+Aozorpg8Qi7xnQPekSHmewh/Msu3YDwibh
         iLDAMztJMS271qId7jLoDDb+wVy4sI5gOR54dyYospo7cKyA6pq68Jdlui+rpILzsCl3
         jLLoLYOYWahmNEoybJEPdnfmU+gfHFj67hcxph7M6vxElqXt3i0gkC5hwVtGbho0tb0K
         V9iRdDVr51eEJGsNKH0+PBcJoahVXfJI93V7Sjj0URHSAtWasPdUYUo9cLZ4u80F2S3t
         6TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4Lz+XGrNozlOzGsHPZGzl/5NMlzsSNvakDIy1S3BqQ=;
        b=oE3SSifoVF1xq+HN++ZtlPOHVg+ucGdoH2aBUTj7fVLG+YLJEXzOtZ2Ukj8QYxu4+H
         pAbvgsinlNtZU9ewBIgHrJBgo+S0oSgD4SqptnrVCCOX1GSlTrNl0TkLbBgMmmo2VqYo
         ullhPIO+X3G4UW9A8PV4f1AftmCtU0AnM6ArNuYWw6Owpo+jxP6YUwxhp4bPS8kJHg3Y
         4Clp2nf6QsuyWIjRtnkP43CCmfWVFv+2WUgSVmYqubu1WqQZKOcNv1MZEUQ2YJeHi3Za
         XuBp4b7DmpcP3bL7DuVf8vUmjvpEi+K62eRL0KVoIGdf/yY532QVwhiDiL1DiIiL7V3Z
         1Y3g==
X-Gm-Message-State: AGi0PuYUM9Z1DZUuh67ZxhZlOvs6NA01bb5c/6pCnqxoCA0rEs31X0Ro
        dsNBcAOtyeWhnRIwX/Z61TGNW9taUNKvfdr124aBqQ==
X-Google-Smtp-Source: APiQypKgeU2DJV5ImoQMK36H/kESxbju/mMcJsTpjidQdY5rBtxVVmlIPinwoE8bcgCjNGZBAgP7vGW7tsgpetQe8GM=
X-Received: by 2002:a05:6638:bd0:: with SMTP id g16mr11414744jad.48.1586822162000;
 Mon, 13 Apr 2020 16:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200413172432.70180-1-brigidsmith@google.com>
 <20200413235039.GK21204@linux.intel.com> <CALMp9eTagRsDJbQ00OUfdLGvgbOi-a+fwAsPgKWKDCNSdiQSqg@mail.gmail.com>
In-Reply-To: <CALMp9eTagRsDJbQ00OUfdLGvgbOi-a+fwAsPgKWKDCNSdiQSqg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 13 Apr 2020 16:55:51 -0700
Message-ID: <CALMp9eRFUxY8DKxoq5YZ8xPNAVe+K9oZ_Aj5nArRJuz8N=Tcpw@mail.gmail.com>
Subject: Re: [kvm-unit-tests RESEND PATCH] x86: gtests: add new test for
 vmread/vmwrite flags preservation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Simon Smith <brigidsmith@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 4:52 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Apr 13, 2020 at 4:50 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > s/gtest/nVMX for the shortlog.  I thought this was somehow related to the
> > Google Test framework, especially coming from a @google.com address.
> >
> > On Mon, Apr 13, 2020 at 10:24:32AM -0700, Simon Smith wrote:
> > > This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
> > > vmread should not set rflags to specify success in case of #PF")
> > >
> > > The two new tests force a vmread and a vmwrite on an unmapped
> > > address to cause a #PF and verify that the low byte of %rflags is
> > > preserved and that %rip is not advanced.  The cherry-pick fixed a
> > > bug in vmread, but we include a test for vmwrite as well for
> > > completeness.
> >
> > I think some of Google's process is bleeding into kvm-unit-tests, I'm pretty
> > sure the aforementioned commit wasn't cherry-picked into Paolo's tree.  :-D
>
> I see it in Linus' tree.

Oh, I see what you mean. s/cherry-pick/commit/.

> > > Before the aforementioned commit, the ALU flags would be incorrectly
> > > cleared and %rip would be advanced (for vmread).
