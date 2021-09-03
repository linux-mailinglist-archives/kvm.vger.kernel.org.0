Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF609400362
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350060AbhICQfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235714AbhICQe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 12:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7797361051;
        Fri,  3 Sep 2021 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630686839;
        bh=zqdoKVBq18djA8V3ScYrfL8EaQR3NyWRMYGjVKzUVo0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AzcegSOV3RJo60W5zxZsG/IOOcwP8IiyZGeGem99PTVKWw8vMixeIUXGA1lvRXF8F
         uBuKJphjnLJ3cAdeJmgJUu/S5rUvbORnpTxN29pmyn4Ys0JO5kPWEQq6znoD9QSW2G
         LLJQuQkf/wA6ZouAFJSf4mA9qeWgstgU3uAPH2IH5OfIpz4w+KJcIME6MwTPsuhYc/
         43ZNd+qCtRjSWt2IeK+cFLhhJndoxEonlfbPePzRpSdrrNnx8sNC2YAhjTmsn49wNO
         fe64THQFjitC4gVkcN+ddXkED9cw7OYOpg4vsZ6HFkWWYfH3AVkR2UxG4k3V3TZgXo
         VHpL6iLAcfseg==
Message-ID: <34039e709902addcd0067ceffe75e07c9568d266.camel@kernel.org>
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
Date:   Fri, 03 Sep 2021 19:33:56 +0300
In-Reply-To: <f7e6b2f444f34064e34d7bd680d2c863b9ce6a41.camel@kernel.org>
References: <20210903064156.387979-1-jarkko@kernel.org>
         <YTI/dTORBZEmGgux@google.com>
         <f7e6b2f444f34064e34d7bd680d2c863b9ce6a41.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 18:58 +0300, Jarkko Sakkinen wrote:
> On Fri, 2021-09-03 at 15:29 +0000, Sean Christopherson wrote:
> > On Fri, Sep 03, 2021, Jarkko Sakkinen wrote:
> > > Simplify sgx_set_attribute() usage by declaring a fallback
> > > implementation for it rather than requiring to have compilation
> > > flag checks in the call site. The fallback unconditionally returns
> > > -EINVAL.
> > >=20
> > > Refactor the call site in kvm_vm_ioctl_enable_cap() accordingly.
> > > The net result is the same: KVM_CAP_SGX_ATTRIBUTE causes -EINVAL
> > > when kernel is compiled without CONFIG_X86_SGX_KVM.
> >=20
> > Eh, it doesn't really simplify the usage.  If anything it makes it more=
 convoluted
> > because the capability check in kvm_vm_ioctl_check_extension() still ne=
eds an
> > #ifdef, e.g. readers will wonder why the check is conditional but the u=
sage is not.
>=20
> It does objectively a bit, since it's one ifdef less.
>=20
> This is fairly standard practice to do in kernel APIs, used in countless
> places, for instance in Tony's patch set to add MCE recovery for SGX. And
> it would be nice to share common pattern here how we define API now and
> futre.
>=20
> I also remarked that declaration of "sgx_provisioning_allowed" is not fla=
gged,
> which is IMHO even more convolved because without SGX it is spare data.

This should have had RFC tho (my bad forgot --subject-prefix=3D"PATCH
RFC"), given that this makes less sense alone than within context of
patch set. I get that like this it's not worth of applying even if
it makes sense as a change.

I prefer sending patches, rather than attaching patches to responses,
because:

1. They get a lore.kernel.org link.
2. Can be fluently applied to other patch sets with b4:
   https://people.kernel.org/monsieuricon/introducing-4-and-patch-attestati=
on
3. They get a patchwork link.

Attachments are not as nice objects to manage as distinct emails.

/Jarkko

