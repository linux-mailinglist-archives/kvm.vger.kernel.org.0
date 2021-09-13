Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738EF409EBC
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245321AbhIMVCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231573AbhIMVCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B254A610CE;
        Mon, 13 Sep 2021 21:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631566851;
        bh=rFY2PWPC5wCDPh+eox6ipiA6Zlzg4L9SwzJYI1oxCog=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wj7Hf/o1pby3OBYSjqKkO7+Mt5zqskFYo/tau6Z9R3y5Ld1q4u4K7xBEcmovOoqTf
         sEO8r32cWqCpp3u1qNI7VBv7YRz8rjfCsiwMYwnDUpkCw1oCfrrCr6acHDDymFJxjr
         f3B8FrQiYrj2MRkGR8d0lsN+C9x/vasekFwEdMnqmL05iKz5ymv2xVN/Qs7/470G14
         FqENyR0VoFloQEkuhYg0r+FUIcMPbZ7K7RiOG3kSsJIjfW+5e3hkLwPoA50C8f/1ZD
         PoiPd09bf+9j8VAGPGg3IAzlraC3i5wzxuuEklz+KwZmMKMfYS9/slx0Xt5kUpDl5z
         BHYV2WUfTaojg==
Message-ID: <60c3081434f324a84a565e55a1817510618faf64.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 14 Sep 2021 00:00:48 +0300
In-Reply-To: <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
         <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
         <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 16:24 +0200, Paolo Bonzini wrote:
> On 13/09/21 16:05, Dave Hansen wrote:
> > On 9/13/21 6:11 AM, Paolo Bonzini wrote:
> > > Windows expects all pages to be in uninitialized state on startup.
> > > In order to implement this, we will need a ioctl that performs
> > > EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
> > > other possibilities, such as closing and reopening the device,
> > > are racy.
> >=20
> > Hi Paolo,
> >=20
> > How does this end up happening in the first place?
> >=20
> > All enclave pages should start out on 'sgx_dirty_page_list' and
> > ksgxd sanitizes them with EREMOVE before making them available.  That
> > should cover EREMOVE after reboots while SGX pages are initialized,
> > including kexec().
>=20
> By "Windows startup" I mean even after guest reboot.  Because another=20
> process could sneak in and steal your EPC pages between a close() and an=
=20
> open(), I'd like to have a way to EREMOVE the pages while keeping them=
=20
> assigned to the specific vEPC instance, i.e. *without* going through=20
> sgx_vepc_free_page().

Isn't "other process in and steal your EPC pages" more like sysadmin
problem, rather than software?

I'm lacking of understanding what would be the collateral damage in
the end.

/Jarkko
