Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC068D94DD
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 17:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393449AbfJPPDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 11:03:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50517 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfJPPDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 11:03:31 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKkpa-0007KE-6E; Wed, 16 Oct 2019 17:03:18 +0200
Date:   Wed, 16 Oct 2019 17:03:17 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Paolo Bonzini' <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
In-Reply-To: <053924e2d08b4744b9fd10337e83ab2d@AcuMS.aculab.com>
Message-ID: <alpine.DEB.2.21.1910161651290.2046@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de> <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de> <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com> <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com> <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
 <053924e2d08b4744b9fd10337e83ab2d@AcuMS.aculab.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019, David Laight wrote:

> For the smt case, can you make #AC enable a property of the process?
> Then disable it on the core if either smt process requires it be disabled?

That would be feasible if the logic of the TEST_CTRL_MSR would be AND, but
it's OR.

Thread0	#AC-EN	Thread1 #AC-EN	#AC enabled on core
	0		0		0
	1		0		1
	0		1		1
	1		1		1

So in order to do flips on VMENTER you'd need to IPI the other thread and
handle all the interesting corner cases.

The 'Rescue SMT' mitigation stuff on top of core scheduling is ugly enough
already, but there the state can be transitionally 'unmitigated' while with
#AC you run into trouble immediately if the transitional state is ON at the
wrong point.

Thanks,

	tglx
