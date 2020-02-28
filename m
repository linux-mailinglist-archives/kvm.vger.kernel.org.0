Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B81740C5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 21:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgB1UO6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Feb 2020 15:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB1UO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 15:14:58 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Fri, 28 Feb 2020 20:14:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthonysanwo@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-Dzz1bjKQk4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #37 from Anthony (anthonysanwo@googlemail.com) ---
Created attachment 287701
  --> https://bugzilla.kernel.org/attachment.cgi?id=287701&action=edit
Perf_stat_anthony_apicv

(In reply to Suravee Suthikulpanit from comment #32)
> (In reply to Anthony from comment #28)
> > Created attachment 287685 [details]
> > avic_inhibit_reasons-anthony
> > 
> > Hi I also just wanted to give my observations I have found when testing the
> > patches.
> > 
> > I confirm I also don't have don't have crashes relating to the original
> > report. 
> > 
> > I have been trying out the SVM AVIC patches since around the first patch
> > that was submitted but never got round to documentation my testing until
> > recently.
> > 
> > I can't remember the specific patch set/kernel version I tried but I
> > remember having avic apparently working with when synic + stimer where
> > enabled but not without. If my understanding is correctly this shouldn't be
> > the case as synic is meant to be a case when avic is permanently disabled.
> > 
> > This is still the case with current patchset. 
> > 
> > In summary I can get avic reporting it's working according to perf stat and
> > trace logs when synic is on but not working when synic is off. Using
> > EPYC-IBPB or passthrough doesn't change the avic_inhibit_reasons.
> > 
> > With Synic I get avic_inhibit_reasons - 10
> > With Synic+Stimer off I get - 0
> > 
> > 
> > To note I am using arch linux + qemu 4.2 + linux-mainline-5.6.0-rc2.
> > 
> > Please see a small trace log of synic on vs off, domain capabilities, perf
> > stat and patches used.
> > 
> > These were recording once the VM was launched and sitting at the login
> > screen.
> > 
> > Please let me know if there is any other info I get provide to help.
> 
> Thanks for the observation info, and your observation makes sense. AVIC is
> also deactivated w/ synic enabled.
> (https://elixir.bootlin.com/linux/v5.6-rc3/source/arch/x86/kvm/hyperv.c#L773)
> 
> Thanks,
> Suravee

I see. I remember reading through your patchset and trying work things out good
to see my basic understanding wasn't too far off :)

If it's not too much of a bother I was wondering if you could list the
requirements needed to enable avic from a kvm/qemu setup. I just wanted to
check if I am missing anything on my side as I am not 100% sure on how to tell
avic is working looking a trace, perf stat/live. 

I did a perf stat from when the vm was launch via libvirt to about when it gets
to the login screen I about 36 "kvm_apicv_update_request".The attachement has a
full output if that is of use. I also got a trace of this but as I redirected
all the output to a file I ended up with quite a large file(462MB). So I wanted
to see if there is anything I should be looking out for in the trace to see if
avic is working as intended. Also, if you don't mind could you show a sample of
trace where avic is working.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
