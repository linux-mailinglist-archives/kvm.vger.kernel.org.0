Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BFF409EF7
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbhIMVQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243974AbhIMVQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2421460EE5;
        Mon, 13 Sep 2021 21:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631567717;
        bh=LBL36NH+MerZ8AMiXfz7v99JfYsvflRoDEGxoPCaerA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gV5WXBLWnqgqJfVQEUiH4zM3eA5sCnH4r3nZTh++AKUj/toiuABtDOgcr8/0jBi7T
         VQh8+TnibR0+R6CgbJK7qlsC0f9S01IUI+zqcr6KrxD9W7USCXLGaicKm/PKusrVch
         728ztGqR0tlmYvR80gD0ZIYjMb9n7ER07UtjUdsVqMaPWu6w+RN+Uk2WkGN0ZZOSae
         TrJqBGaAAJbahruVsawhLEIB6DN6cpnp254jz/um0Y6LQR+x7jCXuadEhcTo04ngq+
         V0C/YEvCUoFMUnMQy74CZuFhG9wFJUTI6lrRjPjC0254OF3hv8RuGM3uhchnRgPhw3
         pCjW4PNJHb6vg==
Message-ID: <8714f53383b5972da51824ae9ded23b94fa04d4d.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 14 Sep 2021 00:15:15 +0300
In-Reply-To: <2b595588-eb98-6d30-dc50-794fc396bf7e@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
         <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
         <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
         <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
         <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
         <480cf917-7301-4227-e1c4-728b52537f46@intel.com>
         <2b595588-eb98-6d30-dc50-794fc396bf7e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 20:35 +0200, Paolo Bonzini wrote:
> On 13/09/21 17:29, Dave Hansen wrote:
> > On 9/13/21 8:14 AM, Paolo Bonzini wrote:
> > > On 13/09/21 16:55, Dave Hansen wrote:
> > > > > By "Windows startup" I mean even after guest reboot.  Because ano=
ther
> > > > > process could sneak in and steal your EPC pages between a close()=
 and an
> > > > > open(), I'd like to have a way to EREMOVE the pages while keeping=
 them
> > > > > assigned to the specific vEPC instance, i.e.*without*  going thro=
ugh
> > > > > sgx_vepc_free_page().
> > > > Oh, so you want fresh EPC state for the guest, but you're concerned=
 that
> > > > the previous guest might have left them in a bad state.  The curren=
t
> > > > method of getting a new vepc instance (which guarantees fresh state=
) has
> > > > some other downsides.
> > > >=20
> > > > Can't another process steal pages via sgxd and reclaim at any time?
> > >=20
> > > vEPC pages never call sgx_mark_page_reclaimable, don't they?
> >=20
> > Oh, I was just looking that they were on the SGX LRU.  You might be rig=
ht.
> > But, we certainly don't want the fact that they are unreclaimable today
> > to be part of the ABI.  It's more of a bug than a feature.
>=20
> Sure, that's fine.
>=20
> > > > What's the extra concern here about going through a close()/open()
> > > > cycle?  Performance?
> > >=20
> > > Apart from reclaiming, /dev/sgx_vepc might disappear between the firs=
t
> > > open() and subsequent ones.
> >=20
> > Aside from it being rm'd, I don't think that's possible.
> >=20
>=20
> Being rm'd would be a possibility in principle, and it would be ugly for=
=20
> it to cause issues on running VMs.  Also I'd like for it to be able to=
=20
> pass /dev/sgx_vepc in via a file descriptor, and run QEMU in a chroot or=
=20
> a mount namespace.  Alternatively, with seccomp it may be possible to=20
> sandbox a running QEMU process in such a way that open() is forbidden at=
=20
> runtime (all hotplug is done via file descriptor passing); it is not yet=
=20
> possible, but it is a goal.

AFAIK, as long you have open files for a device, they work
as expected.

/Jarkko
