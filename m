Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0541AE0E2
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 17:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgDQPRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 11:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgDQPRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 11:17:35 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF4BF20936;
        Fri, 17 Apr 2020 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587136654;
        bh=vQgeSTHLqbr1xYIfLpTqXiGzbSQwUSK/Dh+Du7ZzrJM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=dYtXIG1+vvN9Iy2/NkryyGIHTTGUWKdGSP2OTrBYd7dCxY0qcz733yrAeMG0CI+KC
         fT6eMWMO2Gk76Cs5s83AJVUXA3xITdx3n6skgAHiaM5uDx85rHUCzOYIep4+/bmXFC
         d5YVx5DFzKAPGOFGhx7j5WC+ZNklgnfGWv/GPk2M=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id B63573523234; Fri, 17 Apr 2020 08:17:34 -0700 (PDT)
Date:   Fri, 17 Apr 2020 08:17:34 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     Elver Marco <elver@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kasan-dev <kasan-dev@googlegroups.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH -next] kvm/svm: disable KCSAN for svm_vcpu_run()
Message-ID: <20200417151734.GJ17661@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200415153709.1559-1-cai@lca.pw>
 <f02ca9b9-f0a6-dfb5-1ca0-32a12d4f56fb@redhat.com>
 <1F15D565-D34D-41F5-B1C5-B9A04626EE97@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1F15D565-D34D-41F5-B1C5-B9A04626EE97@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 09:21:59AM -0400, Qian Cai wrote:
> 
> 
> > On Apr 15, 2020, at 11:57 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 15/04/20 17:37, Qian Cai wrote:
> >> For some reasons, running a simple qemu-kvm command with KCSAN will
> >> reset AMD hosts. It turns out svm_vcpu_run() could not be instrumented.
> >> Disable it for now.
> >> 
> >> # /usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host
> >> 	-smp 2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2
> >> 
> >> === console output ===
> >> Kernel 5.6.0-next-20200408+ on an x86_64
> >> 
> >> hp-dl385g10-05 login:
> >> 
> >> <...host reset...>
> >> 
> >> HPE ProLiant System BIOS A40 v1.20 (03/09/2018)
> >> (C) Copyright 1982-2018 Hewlett Packard Enterprise Development LP
> >> Early system initialization, please wait...
> >> 
> >> Signed-off-by: Qian Cai <cai@lca.pw>
> >> ---
> >> arch/x86/kvm/svm/svm.c | 2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index 2be5bbae3a40..1fdb300e9337 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -3278,7 +3278,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
> >> 
> >> bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
> >> 
> >> -static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >> +static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >> {
> >> 	struct vcpu_svm *svm = to_svm(vcpu);
> >> 
> >> 
> > 
> > I suppose you tested the patch to move cli/sti into the .S file.  Anyway:
> > 
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Paul, can you pick this up along with other KCSAN fixes?

Queued and pushed, thank you both!

							Thanx, Paul
