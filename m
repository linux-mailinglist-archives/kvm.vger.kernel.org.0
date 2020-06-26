Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4290A20B440
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 17:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgFZPOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 11:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgFZPOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 11:14:38 -0400
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E5DC03E979
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 08:14:37 -0700 (PDT)
Received: from kevinolos (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id C7CB71A15487;
        Fri, 26 Jun 2020 15:14:35 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id C5E4D1300346; Fri, 26 Jun 2020 09:14:32 -0600 (MDT)
Date:   Fri, 26 Jun 2020 09:14:32 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
Message-ID: <20200626151432.GA231100@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
References: <20171018174946.GU5109@tassilo.jf.intel.com>
 <3d37ef15-932a-1492-3068-9ef0b8cd5794@redhat.com>
 <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
 <20200625142651.GA154525@kevinolos>
 <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-06-25 at 20:41 +0200, Paolo Bonzini wrote:
> On 25/06/20 16:26, Kevin Locke wrote:
>> 1. Do I understand correctly that the CPU usage is due to counting
>>    RTC periodic timer ticks for replay when the guest is resumed?
> 
> Yes.
> 
>> 2. If so, would it be possible to calculate the number of ticks
>>    required from the time delta at resume, rather than polling each
>>    tick while paused?
> 
> Note that high CPU usage while the guest is paused is a bug.  Only high
> CPU usage as soon as the guest resumes is the unavoidable part.

Although enabling the hv_stimer Hyper-V enlightenment avoids the
issue, I assume high CPU usage while the guest is paused when
hv_stimer is not enabled is still a bug.  It's not important for my
current use cases, but if there is interest in fixing the issue for
others, I was able to find a more minimal reproduction:

Using the Windows 10 May 2020 English 64-bit ISO from
https://www.microsoft.com/en-us/software-download/windows10ISO

If I run

qemu-system-x86_64 \
	-no-user-config \
	-machine pc-q35-5.0,accel=kvm \
	-m 1024 \
	-blockdev driver=file,node-name=win10iso,filename=Win10_2004_English_x64.iso \
	-device ide-cd,drive=win10iso \
	-no-hpet \
	-rtc driftfix=slew

then pause the VM after the "Windows Setup" window appears,
qemu-system-x86_64 uses ~40% CPU indefinitely.  Without
-rtc driftfix=slew, ~10%.  Without -no-hpet, ~1%.

For reference, both of these options are added by virt-manager by
default for Windows 10.

If there's anything else I can do to help, let me know.
Thanks again for all of the help tracking this down.

Best,
Kevin
