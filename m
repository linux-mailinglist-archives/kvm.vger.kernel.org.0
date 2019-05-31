Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DD930A7C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 10:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEaIj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 04:39:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:21919 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaIj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 04:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559291996; x=1590827996;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=JRSONXEOsKHxpdgDwwuGcZffixzQM8sVhSzD8ajirKc=;
  b=bDXn8O2TqdmZuhLTYvn33EPBtjNpoDy4i3rJhS6hldfH7l9KLoq933rO
   AvRiZXE8ePqRjx7IIqVt66tna4vGTzW46cW7EWs0VRyjMHaE7UGg5zffK
   NJSpqXrNKSKQ2OEonNOVP/6khFfoBCotlEJRMu3YxR9RpoL54lqzsqbbE
   U=;
X-IronPort-AV: E=Sophos;i="5.60,534,1549929600"; 
   d="scan'208";a="398795852"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 May 2019 08:39:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 1201528262D;
        Fri, 31 May 2019 08:39:51 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 08:39:49 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.69) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 08:39:45 +0000
Subject: Re: x86 instruction emulator fuzzing
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190521153924.15110-1-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <6f9f4746-7850-0de0-b531-0ea0e6d7ca82@amazon.com>
Date:   Fri, 31 May 2019 10:39:43 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190521153924.15110-1-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.69]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 21.05.19 17:39, Sam Caccavale wrote:
> Dear all,
>
> This series aims to provide an entrypoint for, and fuzz KVM's x86 instruction
> emulator from userspace.  It mirrors Xen's application of the AFL fuzzer to
> it's instruction emulator in the hopes of discovering vulnerabilities.
> Since this entrypoint also allows arbitrary execution of the emulators code
> from userspace, it may also be useful for testing.
>
> The current 3 patches build the emulator and 2 harnesses: simple-harness is
> an example of unit testing; afl-harness is a frontend for the AFL fuzzer.
> They are early POC and include some issues outlined under "Issues."
>
> Patches
> =======
>
> - 01: Builds and links afl-harness with the required kernel objects.
> - 02: Introduces the minimal set of emulator operations and supporting code
> to emulate simple instructions.
> - 03: Demonstrates simple-harness as a unit test.
>
> Issues
> =======
>
> 1. Currently, building requires manually running the `make_deps` script
> since I was unable to make the kernel objects a dependency of the tool.
> 2. The code will segfault if `CONFIG_STACKPROTECTOR=y` in config.
> 3. The code requires stderr to be buffered or it otherwise segfaults.
>
> The latter two issues seem related and all of them are likely fixable by
> someone more familiar with the linux than me.
>
> Concerns
> =======
>
> I was able to carve the `arch/x86/kvm/emulate.c` code, but the emulator is
> constructed in such a way that a lot of the code which enforces expected
> behavior lives in the x86_emulate_ops supplied in `arch/x86/kvm/x86.c`.
> Testing the emulator is still valuable, but a reproducible way to use the kvm
> ops would be useful.
>
> Any comments/suggestions are greatly appreciated.


First off, thanks a lot for this :). The x86 emulator has been a sore 
(bug prone) point in KVM for a long time and I'm surprised it's not 
covered by fuzzing yet. It's great to see that finally happening.

A few nits:

   1) Cover letter should be [PATCH 0/3]. Just generate it with git 
format-patch --cover-letter.
   2) The directory name "x86_instruction_emulation" is a bit long, no?
   3) I think the cover letter should also detail how this relates to 
other fuzzing efforts and why we need another, separate one.


Alex


