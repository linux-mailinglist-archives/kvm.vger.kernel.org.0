Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD770C4AF
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 19:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjEVRvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 13:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbjEVRvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 13:51:45 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D71C118
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:51:42 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d413b27a1so1643896b3a.2
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684777902; x=1687369902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2UjMNtojrW/qrTrI17UCkfJw9PMPQf1c8uRjRPa1hgo=;
        b=WbRMKZ+lB6YkCfS92JX7T2JKrlVxEvqXFigAjOjqgg9uHzs1zcgLU85aEmke/nHXZ6
         /0Pu5kfQJR1lF5z+AywWkTmtQbFqRQfral+EWIgJX3/0tCgMdEcHSiZ8UjLlWuemDE6C
         0QwhqtKLE226uUMckA1Mo+z+8vp/oqervlDZb/GCAhWDbnCApCxAWCFG79iI4s9pJOMg
         C7PEYvWhatxe8yIJVxPk3BTz8zKPjQJmL8tt9sXncRCBZlmIe55QIYNnpnBBDuTgdTKF
         f5aewGWKGQJ+S6Kc8PUI7f661bRgl6+Ph83tiSD6fjVmuRWy14LL1j6GMTsGsIDcAZzj
         PZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684777902; x=1687369902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UjMNtojrW/qrTrI17UCkfJw9PMPQf1c8uRjRPa1hgo=;
        b=Ir+XNbe0wTzbfYO926Pfx6ddH3S1ZBYitl8SzFEx/3ubw7apwrRY8q8pl3veO47NAz
         4eXXFO628HU0h/jVQd5dWhUo7OSKHq+loOaqgazJm76DbZC5rcb3XRkTx7XrjUdZOT3c
         /hPKNRkB/O2aGKO/PfEFXPnZF2zVaMu5qNNBc6pkj9rgvR1h28T3ZFlNvg65USy9TpWZ
         tjoYbt4rOUNeO+cmi+HziVUCAECrk9QXppr7IutUwzXPJLhXK/6Ol/O2mmF5j2d1Gn4O
         y85YjF0NXlKDotmF7K+5TcXr8rrwldv/HhmMNVETXYlME6g6xEs+U6qfmSGxk+0lvJWF
         ZETw==
X-Gm-Message-State: AC+VfDwiwn4ed7kxl51ZK0UVVmUFcEBbt3hW7j8dVaK2tr7Fx0p+Y112
        Gj/9DhYejF4UpL/05P6SN6eWFntUvdE=
X-Google-Smtp-Source: ACHHUZ7Bq43enaocbWto/QJGkbIVxTEMmGyZPOOip/KVM5nl0hVcdgsj6hgll5ji2ugIu4ii+yN5mY1a0t8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1814:b0:64d:2cb0:c60c with SMTP id
 y20-20020a056a00181400b0064d2cb0c60cmr4967667pfa.5.1684777901822; Mon, 22 May
 2023 10:51:41 -0700 (PDT)
Date:   Mon, 22 May 2023 10:51:40 -0700
In-Reply-To: <babc4cb3856dd5fc1bc6fa742e484667dc02c054.camel@intel.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com> <20230512235026.808058-6-seanjc@google.com>
 <babc4cb3856dd5fc1bc6fa742e484667dc02c054.camel@intel.com>
Message-ID: <ZGurrDEdMj6rJ6dU@google.com>
Subject: Re: [PATCH v3 05/18] x86/reboot: Disable virtualization during reboot
 iff callback is registered
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Kai Huang wrote:
> On Fri, 2023-05-12 at 16:50 -0700, Sean Christopherson wrote:
> > Attempt to disable virtualization during an emergency reboot if and only
> > if there is a registered virt callback, i.e. iff a hypervisor (KVM) is
> > active.  If there's no active hypervisor, then the CPU can't be operating
> > with VMX or SVM enabled (barring an egregious bug).
> > 
> > Note, IRQs are disabled, which prevents KVM from coming along and enabling
> > virtualization after the fact.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kernel/reboot.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > index 92b380e199a3..20f7bdabc52e 100644
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -22,7 +22,6 @@
> >  #include <asm/reboot_fixups.h>
> >  #include <asm/reboot.h>
> >  #include <asm/pci_x86.h>
> > -#include <asm/virtext.h>
> >  #include <asm/cpu.h>
> >  #include <asm/nmi.h>
> >  #include <asm/smp.h>
> > @@ -545,7 +544,7 @@ static void emergency_reboot_disable_virtualization(void)
> >  	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
> >  	 * other CPUs may have virtualization enabled.
> >  	 */
> > -	if (cpu_has_vmx() || cpu_has_svm(NULL)) {
> > +	if (rcu_access_pointer(cpu_emergency_virt_callback)) {
> >  		/* Safely force _this_ CPU out of VMX/SVM operation. */
> >  		cpu_emergency_disable_virtualization();
> 
> 
> IIUC, for cpu_emergency_disable_virtualization() itself, looks it's OK to not
> having the pointer check, since it internally will do rcu_dereference() inside
> RCU critical section anyway.
> 
> But nmi_shootdown_cpus_on_restart() is called after
> cpu_emergency_disable_virtualization(), and having the pointer check here can
> avoid sending NMI to remote cpus if there's no active hypervisor.
> 
> Am I missing something?  If not, is it worth to call this out in changelog?

No, you're not missing anything.  I agree it's worth a line in the changelog.
Dropping the "spurious" NMI should be a-ok, but explicitly calling out the side
effect could be helpful for debug if something is silently relying on the NMI.
