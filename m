Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789C02427B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 23:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfETVF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 17:05:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfETVF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 17:05:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1CF63086272;
        Mon, 20 May 2019 21:05:27 +0000 (UTC)
Received: from localhost (ovpn-116-14.gru2.redhat.com [10.97.116.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 214361001DE7;
        Mon, 20 May 2019 21:05:26 +0000 (UTC)
Date:   Mon, 20 May 2019 18:05:25 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] i386: Enable IA32_MISC_ENABLE MWAIT bit when exposing
 mwait/monitor
Message-ID: <20190520210525.GE10764@habkost.net>
References: <1557813999-9175-1-git-send-email-wanpengli@tencent.com>
 <dcbf44c3-2fb9-02c0-79cc-c8a30373d35a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcbf44c3-2fb9-02c0-79cc-c8a30373d35a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 20 May 2019 21:05:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 02:59:53PM +0200, Paolo Bonzini wrote:
> On 14/05/19 08:06, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> > 
> > The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR 
> > IA32_MISC_ENABLE MWAIT bit and as userspace has control of them 
> > both, it is userspace's job to configure both bits to match on 
> > the initial setup.
> 
> Queued, thanks.
> 
> Paolo
> 
> > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  target/i386/cpu.c | 3 +++
> >  target/i386/cpu.h | 1 +
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 722c551..40b6108 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -4729,6 +4729,9 @@ static void x86_cpu_reset(CPUState *s)
> >  
> >      env->pat = 0x0007040600070406ULL;
> >      env->msr_ia32_misc_enable = MSR_IA32_MISC_ENABLE_DEFAULT;
> > +    if (enable_cpu_pm) {
> > +        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
> > +    }

What if enable_cpu_pm is false but we're running TCG, or if
enable_cpu_pm is true but we're not using -cpu host?

Shouldn't this be conditional on
  (env->features[FEAT_1_ECX] & CPUID_EXT_MONITOR)
instead?

> >  
> >      memset(env->dr, 0, sizeof(env->dr));
> >      env->dr[6] = DR6_FIXED_1;
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index 0128910..b94c329 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -387,6 +387,7 @@ typedef enum X86Seg {
> >  #define MSR_IA32_MISC_ENABLE            0x1a0
> >  /* Indicates good rep/movs microcode on some processors: */
> >  #define MSR_IA32_MISC_ENABLE_DEFAULT    1
> > +#define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
> >  
> >  #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))
> >  #define MSR_MTRRphysMask(reg)           (0x200 + 2 * (reg) + 1)
> > 
> 

-- 
Eduardo
