Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CD34857CF
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbiAER7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 12:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbiAER7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 12:59:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9949CC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 09:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=LH188t69kYoSto78/6JphsUM2uIbKLapdy4lhXGxmNw=; b=tP7RG6tr2VI+ArwmrhZbG7t65d
        VUbfYJW0Pg0otwF5LU+OBd76sb9xI5Elp63cCDrIbopUYB/SR1zjzp0GvJFWmxx9R1dndCICoa96+
        K+AhkPwdq+E6iYCrcr1CZWiNlQJp1akLFcLrP0/akqT9ccfxITjR4lLSejnIM6W6/fPoVnq9aZH+5
        M/IDVWW02z99wDwaPJI4e2Y+MNLm28KHeqzCDx+KcxU5xa5njqCJyvK6ILyFl/2QkmEJHw5CW3pom
        s5/KSeaVdhnkWEa1QU4phziPCPLkvaL9n4xFNnV3o7MBEI7s7p3rPEGyZb6bvSZbHUOHwYXeA40Js
        Y6tcEA+A==;
Received: from [2001:8b0:10b:1:4a2a:e3ff:fe14:8625] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n5AYg-00FXaK-BV; Wed, 05 Jan 2022 17:58:46 +0000
Message-ID: <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Wed, 05 Jan 2022 17:58:43 +0000
In-Reply-To: <YcTpJ369cRBN4W93@google.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
         <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
         <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
         <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
         <YcTpJ369cRBN4W93@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-23 at 21:24 +0000, Sean Christopherson wrote:
> Commit e880c6ea55b9 ("KVM: x86: hyper-v: Prevent using not-yet-updated TSC page
> by secondary CPUs") is squarely to blame as it was added after dirty ring, though
> in Vitaly's defense, David put it best: "That's a fairly awful bear trap".

Even with the WARN to keep us honest, this is still awful.

We have kvm_vcpu_write_guest()... but the vcpu we pass it is ignored
and only vcpu->kvm is used. But you have to be running on a physical
CPU which currently owns *a* vCPU of that KVM, or you might crash.

There is also kvm_write_guest() which doesn't take a vCPU as an
argument, and looks for all the world like it was designed for you not
to need one... but which still needs there to be a vCPU or it might
crash.

I think I want to kill the latter, make the former use the vCPU it's
given, add a spinlock to the dirty ring which will be uncontended
anyway in the common case so it shouldn't hurt (?), and then let people
use kvm->vcpu[0] when they really need to, with a documented caveat
that when there are *no* vCPUs in a KVM, dirty tracking might not work.
Which is fine, as migration of a KVM that hasn't been fully set up yet
is silly.


