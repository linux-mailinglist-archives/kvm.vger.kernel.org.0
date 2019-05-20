Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB04324239
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 22:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfETUtb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 20 May 2019 16:49:31 -0400
Received: from mail.csgraf.de ([188.138.100.120]:48682 "EHLO
        zulu616.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfETUtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 16:49:31 -0400
Received: from [172.16.70.131] (unknown [70.96.135.254])
        by csgraf.de (Postfix) with ESMTPSA id 9C04139002BA;
        Mon, 20 May 2019 22:49:29 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: #VE support for VMI
From:   Alexander Graf <agraf@csgraf.de>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190520183331.GD28482@linux.intel.com>
Date:   Mon, 20 May 2019 13:49:27 -0700
Cc:     =?utf-8?Q?Mihai_Don=C8=9Bu?= <mdontu@bitdefender.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        KarimAllah Ahmed <karahmed@amazon.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <0A615AC6-C27F-41DA-AC20-7191DAD2CAC7@csgraf.de>
References: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com> <80e0baaf-150b-0966-6920-b36d23a6cdef@csgraf.de> <20190520183331.GD28482@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 20.05.2019 um 11:33 schrieb Sean Christopherson <sean.j.christopherson@intel.com>:
> 
>> On Mon, May 20, 2019 at 11:10:51AM -0700, Alexander Graf wrote:
>>> On 20.05.19 08:48, Mihai Donțu wrote:
>>> Hi Paolo,
>>> 
>>> We are looking at adding #VE support to the VMI subsystem we are
>>> working on. Its purpose is to suppress VMEXIT-s caused by the page
>>> table walker when the guest page tables are write-protected. A very
>>> small in-guest agent (protected by the hypervisor) will receive the EPT
>>> violation events, handle PT-walk writes and turn the rest into VMCALL-
>>> s.
>>> 
>>> A brief presentation of similar work on Xen can be found here:
>>> https://www.slideshare.net/xen_com_mgr/xpdss17-hypervisorbased-security-bringing-virtualized-exceptions-into-the-game-mihai-dontu-bitdefender
>>> 
>>> There is a bit of an issue with using #VE on KVM, though: because the
>>> EPT is built on-the-fly (as the guest runs), when we enable #VE in
>>> VMCS, all EPT violations become virtualized, because all EPTE-s have
>>> bit 63 zero (0: convert to #VE, 1: generate VMEXIT). At the moment, I
>> 
>> Are you 100% sure? Last time I played with #VE, it only triggered on
>> misconfigurations/permission checks (lack of R/W/X, but P=1), not on P=0
>> pages.
> 
> #VEs trigger on RWX=0, but not misconfigurations, i.e. any and all
> EPT_VIOLATION exits (reason 48) are convertible, and EPT_MISCONFIG exits
> (reason 49) are never convertible.  The reasoning behind the logic is
> that an EPT_MISCONFIG is the result of a VMM bug (or in KVM's case, MMIO
> trickery), whereas a RWX=0 EPT_VIOLATION could be a malicious entity in
> the guest probing non-existent pages or pages it doesn't have access to.

I see - I must have forgotten about some change I did on my playground setup then.

Either way, you want a direct deflection path. You can not guarantee that a page is always present on an overcommitted system.

Alex


