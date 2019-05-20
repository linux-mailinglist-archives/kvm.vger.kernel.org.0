Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D3A23C99
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfETPye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:54:34 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:56142 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732031AbfETPye (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 May 2019 11:54:34 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 11:54:33 EDT
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3B07330747C6;
        Mon, 20 May 2019 18:48:09 +0300 (EEST)
Received: from [10.17.91.220] (unknown [195.210.5.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 308B7306E4AC;
        Mon, 20 May 2019 18:48:09 +0300 (EEST)
Message-ID: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com>
Subject: #VE support for VMI
From:   Mihai =?UTF-8?Q?Don=C8=9Bu?= <mdontu@bitdefender.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Date:   Mon, 20 May 2019 18:48:09 +0300
Organization: Bitdefender
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We are looking at adding #VE support to the VMI subsystem we are
working on. Its purpose is to suppress VMEXIT-s caused by the page
table walker when the guest page tables are write-protected. A very
small in-guest agent (protected by the hypervisor) will receive the EPT
violation events, handle PT-walk writes and turn the rest into VMCALL-
s.

A brief presentation of similar work on Xen can be found here:
https://www.slideshare.net/xen_com_mgr/xpdss17-hypervisorbased-security-bringing-virtualized-exceptions-into-the-game-mihai-dontu-bitdefender

There is a bit of an issue with using #VE on KVM, though: because the
EPT is built on-the-fly (as the guest runs), when we enable #VE in
VMCS, all EPT violations become virtualized, because all EPTE-s have
bit 63 zero (0: convert to #VE, 1: generate VMEXIT). At the moment, I
see two solutions:

(a) have the in-guest agent generate a VMCALL that KVM will interpret
as EPT-violation and call the default page fault handler;
(b) populate the EPT completely before entering the guest;

The first one requires adding dedicated code for KVM in the agent used
for handling #VE events, something we are trying to avoid. The second
one has implications we can't fully see, besides migration with which
we don't interact (VMI is designed to be disabled before migration
starts, implicitly #VE too).

I would appreciate any opinion / suggestion you have on a proper
approach to this issue.

Regards,

-- 
Mihai Donțu


