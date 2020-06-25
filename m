Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B45320A660
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 22:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbgFYUKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 16:10:49 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:42878 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbgFYUKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 16:10:49 -0400
Received: from kevinolos (2600-6c67-5080-46fc-c41a-e0b6-d707-8cad.res6.spectrum.com [IPv6:2600:6c67:5080:46fc:c41a:e0b6:d707:8cad])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 2AD831A0F14F;
        Thu, 25 Jun 2020 20:10:47 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 3C2D61300396; Thu, 25 Jun 2020 14:10:46 -0600 (MDT)
Date:   Thu, 25 Jun 2020 14:10:46 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
Message-ID: <20200625201046.GA179502@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
References: <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
 <20200625142651.GA154525@kevinolos>
 <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
 <20200625185651.GA177472@kevinolos>
 <80754688-d05f-11a3-b25e-955b5ee0ca0b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80754688-d05f-11a3-b25e-955b5ee0ca0b@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-06-25 at 21:17 +0200, Paolo Bonzini wrote:
> On 25/06/20 20:56, Kevin Locke wrote:
>>> Windows 10 can use the Hyper-V synthetic timer instead of the RTC, which
>>> shouldn't have the problem.
>>
>> That's great news!  Since I'm able to reproduce the issue on a
>> recently installed Windows 10 2004 VM on Linux 5.7 with QEMU 5.0, is
>> there anything I can do to help isolate the bug, or is it a known
>> issue?
> 
> You need to enable Hyper-V enlightenments, with something like
> 
> -cpu host,hv_vpindex,hv_runtime,hv_synic,hv_stimer,hv_reset,hv_time,hv_relaxed
> 
> on the QEMU command line.

Bingo!  I was using the defaults from virt-manager:[1]

-cpu $host,hv-time,hv-relaxed,hv-vapic,hv-spinlocks=0x1fff

Using to the enlightenments you suggested solves the high CPU when
paused issue for me.  After a bit of testing, it appears that
hv_stimer is the key.  High CPU when paused does not occur when that
enlightenment is enabled, regardless of which others are
enabled/disabled.

Is there any reason not to add it to the virt-manager defaults for
Windows 10?  Any other suggestions about which enlightenments to
enable or disable by default?

Thanks again,
Kevin

[1]: https://github.com/virt-manager/virt-manager/blob/v2.2.1/virtinst/domain/features.py#L74-L83
