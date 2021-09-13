Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932A5409F01
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348232AbhIMVR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241460AbhIMVRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:17:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E38F560EE5;
        Mon, 13 Sep 2021 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631567799;
        bh=C0wLsuXykuiRmyrc5T0ggXJ03eTwpJGDkp0yo3yMhGY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aAeyAGQ0mNqa8u/qTvmX1T1tQTiqBAMNxGECgA0CzMEnqHfSOOHmJMm8jpZ2yGE4E
         va9WEo3sveQZvHusYmgYY+r6BJ18P1CMCtOcuEPLdtXwm6s4TY5DyuDFf2UZ4ux3Vs
         jrjz62ZA+fZ/vKh3wUUPVl00A1setVUG908iHU+rO2tUxkuO4baVHFwSsPsNKpSqoN
         OV85FDepJn5xKfjkpAFRQIGSr9mpZPvFr/LqbnfGN0KwsOAnPYE2BTE46B1ubZWVwV
         ccwY0OH/Qla/nLZ4aBOdafKIwUDBDr0L2HtjP8eLPsV3Pi9lF2x4eQXyeYV9+F4AyS
         NRSiAmgQxeNUw==
Message-ID: <de03361aab108ff481f6472978265e754100c6fb.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 14 Sep 2021 00:16:37 +0300
In-Reply-To: <fa8e8573-d907-11b0-60e1-f31e050beb64@intel.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
         <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
         <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
         <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
         <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
         <480cf917-7301-4227-e1c4-728b52537f46@intel.com>
         <2b595588-eb98-6d30-dc50-794fc396bf7e@redhat.com>
         <fa8e8573-d907-11b0-60e1-f31e050beb64@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 12:25 -0700, Dave Hansen wrote:
> On 9/13/21 11:35 AM, Paolo Bonzini wrote:
> > > > Apart from reclaiming, /dev/sgx_vepc might disappear between the fi=
rst
> > > > open() and subsequent ones.
> > >=20
> > > Aside from it being rm'd, I don't think that's possible.
> > >=20
> >=20
> > Being rm'd would be a possibility in principle, and it would be ugly fo=
r
> > it to cause issues on running VMs.  Also I'd like for it to be able to
> > pass /dev/sgx_vepc in via a file descriptor, and run QEMU in a chroot o=
r
> > a mount namespace.  Alternatively, with seccomp it may be possible to
> > sandbox a running QEMU process in such a way that open() is forbidden a=
t
> > runtime (all hotplug is done via file descriptor passing); it is not ye=
t
> > possible, but it is a goal.
>=20
> OK, so maybe another way of saying this:
>=20
> For bare-metal SGX on real hardware, the hardware provides guarantees
> SGX state at reboot.  For instance, all pages start out uninitialized.
> The vepc driver provides a similar guarantee today for freshly-opened
> vepc instances.
>=20
> But, vepc users have a problem: they might want to run an OS that
> expects to be booted with clean, fully uninitialized SGX state, just as
> it would be on bare-metal.  Right now, the only way to get that is to
> create a new vepc instance.  That might not be possible in all
> configurations, like if the permission to open(/dev/sgx_vepc) has been
> lost since the VM was first booted.

So you maintain your systems in a way that this does not happen?

/Jarkko
