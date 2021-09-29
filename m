Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE9741C3A6
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 13:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343490AbhI2Lqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 07:46:32 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55258 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245757AbhI2Lqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 07:46:30 -0400
Received: from zn.tnic (p200300ec2f0bd1007899710aba6f35e5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:d100:7899:710a:ba6f:35e5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 630A51EC0570;
        Wed, 29 Sep 2021 13:44:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632915888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMANUNGHYgRrWwPQI7d16Ade76A3xSFS206v9+9viU4=;
        b=TbuNVJDTbHvOoTmnON+IM24sfuJ09eDKxM8LXoSRJOZ6y5xb7M3N4euQcQGsbgnxZhbCxg
        Rnnwxtbyjx2qbCMyCBQOxylLrAmrwzPT92WTcJxaByXoasN8BzMgHbc65+njIxuA1Jz4qh
        dofqPWEeZNw0CHwGo7PyhAiqGXnfBng=
Date:   Wed, 29 Sep 2021 13:44:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@linux.ibm.com" <tobin@linux.ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YVRRsEgjID4CbbRS@zn.tnic>
References: <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com>
 <YUnxa2gy4DzEI2uY@zn.tnic>
 <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic>
 <20210922121008.GA18744@ashkalra_ubuntu_server>
 <YUs1ejsDB4W4wKGF@zn.tnic>
 <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
 <2213EC9B-E3EC-4F23-BC1A-B11DF6288EE3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2213EC9B-E3EC-4F23-BC1A-B11DF6288EE3@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 07:26:32PM +0000, Kalra, Ashish wrote:
> Yes that’s what I mentioned to Boris.

Right, and as far as I'm concerned, the x86 bits look ok to me and I'm
fine with this going through the kvm tree.

There will be a conflict with this:

https://lkml.kernel.org/r/20210928191009.32551-1-bp@alien8.de

resulting in:

arch/x86/kernel/kvm.c: In function ‘setup_efi_kvm_sev_migration’:
arch/x86/kernel/kvm.c:563:7: error: implicit declaration of function ‘sev_active’; did you mean ‘cpu_active’? [-Werror=implicit-function-declaration]
  563 |  if (!sev_active() ||
      |       ^~~~~~~~~~
      |       cpu_active
cc1: some warnings being treated as errors
make[2]: *** [scripts/Makefile.build:277: arch/x86/kernel/kvm.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:540: arch/x86/kernel] Error 2
make: *** [Makefile:1868: arch/x86] Error 2
make: *** Waiting for unfinished jobs....

but Paolo and I will figure out what to do - I'll likely have a separate
branch out which he can merge and that sev_active() will need to be
converted to

	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))

which is trivial.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
