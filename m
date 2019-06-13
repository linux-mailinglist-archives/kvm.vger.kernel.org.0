Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A1D43D6A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfFMPlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731871AbfFMJtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 05:49:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2278030860BC;
        Thu, 13 Jun 2019 09:49:52 +0000 (UTC)
Received: from dhcp-4-67.tlv.redhat.com (dhcp-4-67.tlv.redhat.com [10.35.4.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1F9060BE2;
        Thu, 13 Jun 2019 09:49:50 +0000 (UTC)
Message-ID: <e4f39694a809461702f3eaae1c12e89ba35976dc.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: LAPIC: Implement Exitless Timer
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Date:   Thu, 13 Jun 2019 12:49:49 +0300
In-Reply-To: <CANRm+CxTNBAEpay=Gf25vV_aCtzRrtgz1N5CtGEwu_kg=F51+Q@mail.gmail.com>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
         <a078b29ebc0a2323c89b5877bf2ba4005eef3485.camel@redhat.com>
         <CANRm+CxTNBAEpay=Gf25vV_aCtzRrtgz1N5CtGEwu_kg=F51+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 13 Jun 2019 09:49:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-06-13 at 16:25 +0800, Wanpeng Li wrote:
> On Thu, 13 Jun 2019 at 15:59, Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > 
> > On Tue, 2019-06-11 at 20:17 +0800, Wanpeng Li wrote:
> > > Dedicated instances are currently disturbed by unnecessary jitter due
> > > to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> > > There is no hardware virtual timer on Intel for guest like ARM. Both
> > > programming timer in guest and the emulated timer fires incur vmexits.
> > > This patchset tries to avoid vmexit which is incurred by the emulated
> > > timer fires in dedicated instance scenario.
> > > 
> > > When nohz_full is enabled in dedicated instances scenario, the unpinned
> > > timer will be moved to the nearest busy housekeepers after commit 444969223c8
> > > ("sched/nohz: Fix affine unpinned timers mess"). However, KVM always makes
> > > lapic timer pinned to the pCPU which vCPU residents, the reason is explained
> > > by commit 61abdbe0 (kvm: x86: make lapic hrtimer pinned). Actually, these
> > > emulated timers can be offload to the housekeeping cpus since APICv
> > > is really common in recent years. The guest timer interrupt is injected by
> > > posted-interrupt which is delivered by housekeeping cpu once the emulated
> > > timer fires.
> > > 
> > > The host admin should fine tuned, e.g. dedicated instances scenario w/
> > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> > > for housekeeping, disable mwait/hlt/pause vmexits to occupy the pCPUs,
> > > fortunately preemption timer is disabled after mwait is exposed to
> > > guest which makes emulated timer offload can be possible.
> > > ~3% redis performance benefit can be observed on Skylake server.
> > 
> > I don't yet know the kvm well enough to review this patch series, but overall I really like the idea.
> 
> Thank you. :)
> 
> > I researched this area some time ago, to see what can be done to reduce the number of vmexits,
> > to an absolute minimum.
> > 
> > I have one small question, just out of curiosity.
> > 
> > Why do you require mwait in the guest to be enabled?
> > 
> > If I understand it correctly, you say
> > that when mwait in the guest is disabled, then vmx preemption timer will be used,
> > and thus it will handle the apic timer?
> 
> Actually we don't have this restriction in v3, the patchset
> description need to update. The lapic timer which guest use can be
> emulated by software(a hrtimer on host) or VT-x hardware (VMX
> preemption timer). VMX preemption timer triggers vmexit when the timer
> fires on the same pCPU which vCPU is running on, so the injection
> vmexit can't be avoided. The hrtimer on host is used to emulate the
> lapic timer when VMX preemption timer is disabled. After commit
> 9642d18eee2cd(nohz: Affine unpinned timers to housekeepers), unpinned
> timers will be moved to nearest busy housekeepers, which means that we
> can offload the hrtimer to the housekeeping cpus instead of running on
> the pCPU which vCPU residents, the timer fires on the housekeeping
> cpus and be injected by posted-interrupt to the vCPU w/o incur
> vmexits. In patchset v3, the preemption timer will be disarmed if
> lapic timer is injected by posted-interrupt. VMX preemption timer stop
> working in C-states deeper than C2, that's why I utilize mwait expose
> before. (commit 386c6ddbda1 X86/VMX: Disable VMX preemption timer if
> MWAIT is not intercepted)

That explains it very well. Thank you!

Best regards,
	Maxim Levitsky

