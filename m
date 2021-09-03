Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A8B4002C2
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349826AbhICP76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235851AbhICP75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14B516054E;
        Fri,  3 Sep 2021 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630684737;
        bh=Km412k9TxdN2OI2AHmk0Z+VNMot6URwk5SBYdwiMiPM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RTLMu/63cCk7wD5IBS+q01tUNz85Lil8FNk/E8kJq+kezRqUSIZ/nrYjOFrkYkhgP
         3jpb7dji4lBW//qveGawND5PUruVOruiEwKGVJq10L2mGWP5x0rHBopQjoohuIfmRd
         yZcq0nxcHKWJkxXrmirPx2PaKcqN4BNbWKLkdo7/nVcUmmWlPRUB/mJT29g2GhsXis
         1vOJSevR/Qt4sr+yyeKU7rg8A3PA5df6UMmRlM9Aw9eA2QM3XJC4zudnrU+OsZBIXt
         F/3fSNTPDFQU+Cc6CVwLAwbnEjIghCTa/oRcjedMPLM5sDM+GPPfm0/T8D5wSfjgwh
         jw8q9ZK3oYH+w==
Message-ID: <f7e6b2f444f34064e34d7bd680d2c863b9ce6a41.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Declare sgx_set_attribute() for !CONFIG_X86_SGX
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 03 Sep 2021 18:58:55 +0300
In-Reply-To: <YTI/dTORBZEmGgux@google.com>
References: <20210903064156.387979-1-jarkko@kernel.org>
         <YTI/dTORBZEmGgux@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 15:29 +0000, Sean Christopherson wrote:
> On Fri, Sep 03, 2021, Jarkko Sakkinen wrote:
> > Simplify sgx_set_attribute() usage by declaring a fallback
> > implementation for it rather than requiring to have compilation
> > flag checks in the call site. The fallback unconditionally returns
> > -EINVAL.
> >=20
> > Refactor the call site in kvm_vm_ioctl_enable_cap() accordingly.
> > The net result is the same: KVM_CAP_SGX_ATTRIBUTE causes -EINVAL
> > when kernel is compiled without CONFIG_X86_SGX_KVM.
>=20
> Eh, it doesn't really simplify the usage.  If anything it makes it more c=
onvoluted
> because the capability check in kvm_vm_ioctl_check_extension() still need=
s an
> #ifdef, e.g. readers will wonder why the check is conditional but the usa=
ge is not.

It does objectively a bit, since it's one ifdef less.

This is fairly standard practice to do in kernel APIs, used in countless
places, for instance in Tony's patch set to add MCE recovery for SGX. And
it would be nice to share common pattern here how we define API now and
futre.

I also remarked that declaration of "sgx_provisioning_allowed" is not flagg=
ed,
which is IMHO even more convolved because without SGX it is spare data.

/Jarkko

