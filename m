Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D7824029
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfETSUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 14:20:15 -0400
Received: from mail.csgraf.de ([188.138.100.120]:48634 "EHLO
        zulu616.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfETSUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 14:20:15 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 14:20:14 EDT
Received: from macbook-2.local (unknown [70.96.135.254])
        by csgraf.de (Postfix) with ESMTPSA id 1B6C839002BA;
        Mon, 20 May 2019 20:10:56 +0200 (CEST)
Subject: Re: #VE support for VMI
To:     =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>
References: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com>
From:   Alexander Graf <agraf@csgraf.de>
Message-ID: <80e0baaf-150b-0966-6920-b36d23a6cdef@csgraf.de>
Date:   Mon, 20 May 2019 11:10:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.05.19 08:48, Mihai Donțu wrote:
> Hi Paolo,
> 
> We are looking at adding #VE support to the VMI subsystem we are
> working on. Its purpose is to suppress VMEXIT-s caused by the page
> table walker when the guest page tables are write-protected. A very
> small in-guest agent (protected by the hypervisor) will receive the EPT
> violation events, handle PT-walk writes and turn the rest into VMCALL-
> s.
> 
> A brief presentation of similar work on Xen can be found here:
> https://www.slideshare.net/xen_com_mgr/xpdss17-hypervisorbased-security-bringing-virtualized-exceptions-into-the-game-mihai-dontu-bitdefender
> 
> There is a bit of an issue with using #VE on KVM, though: because the
> EPT is built on-the-fly (as the guest runs), when we enable #VE in
> VMCS, all EPT violations become virtualized, because all EPTE-s have
> bit 63 zero (0: convert to #VE, 1: generate VMEXIT). At the moment, I

Are you 100% sure? Last time I played with #VE, it only triggered on
misconfigurations/permission checks (lack of R/W/X, but P=1), not on P=0
pages.

Or are you referring to the MMIO misconfiguration trick that KVM does?

> see two solutions:
> 
> (a) have the in-guest agent generate a VMCALL that KVM will interpret
> as EPT-violation and call the default page fault handler;

... in that case yes, I would like to see a VMCALL to just bounce that
trap back into KVM.

> (b) populate the EPT completely before entering the guest;

... because this will not help you in any way :).


Alex

> 
> The first one requires adding dedicated code for KVM in the agent used
> for handling #VE events, something we are trying to avoid. The second
> one has implications we can't fully see, besides migration with which
> we don't interact (VMI is designed to be disabled before migration
> starts, implicitly #VE too).
> 
> I would appreciate any opinion / suggestion you have on a proper
> approach to this issue.
> 
> Regards,
> 

