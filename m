Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F64E409EED
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbhIMVPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346455AbhIMVPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9FC610FB;
        Mon, 13 Sep 2021 21:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631567627;
        bh=0R4PNrboQLkoVUwiljZiE/cGbU8QnNEhm3clfPoC+hw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IhYA9lMTS7q1xnCw+tgtyuNfYPjBN55pzv3diGTYuQEC1vrbreG5QIkbRpkRykjii
         SHR1pYRu9Frs8dq5hlvjRrhhAtqYHz9Utbwyus7e/IIxi+WAWMroYTCAvjuw3ol7/v
         rSpwO5bEzfjhKhG5ZTg3wZKC1hfh2OQ4SrP8scE9c1d/TNGSCdXRsStjqcPHCtG86q
         zaYYrSNj89tsarDmjJFJcmMkMgTevE9O7jUWQwPejwtLg+EOR8KYA4nzXqC1VluK6E
         jtT5rpDa6V/Kh95kjB28Omn+m4xcmVygOLntv7Wv6pI4Yc48qJNDImM6rK1qHKoOrV
         2zRnE+MZ3Qa6Q==
Message-ID: <3409573ac76aad2e7c3363343fc067d5b4621185.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 14 Sep 2021 00:13:45 +0300
In-Reply-To: <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
         <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
         <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
         <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
         <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 17:14 +0200, Paolo Bonzini wrote:
> On 13/09/21 16:55, Dave Hansen wrote:
> > > By "Windows startup" I mean even after guest reboot.  Because another
> > > process could sneak in and steal your EPC pages between a close() and=
 an
> > > open(), I'd like to have a way to EREMOVE the pages while keeping the=
m
> > > assigned to the specific vEPC instance, i.e.*without*  going through
> > > sgx_vepc_free_page().
> > Oh, so you want fresh EPC state for the guest, but you're concerned tha=
t
> > the previous guest might have left them in a bad state.  The current
> > method of getting a new vepc instance (which guarantees fresh state) ha=
s
> > some other downsides.
> >=20
> > Can't another process steal pages via sgxd and reclaim at any time?
>=20
> vEPC pages never call sgx_mark_page_reclaimable, don't they?
>=20
> > What's the extra concern here about going through a close()/open()
> > cycle?  Performance?
>=20
> Apart from reclaiming, /dev/sgx_vepc might disappear between the first=
=20
> open() and subsequent ones.

If /dev/sgx_vepc dissapears, why is it a problem *for the software*, and
not a sysadmin problem?

I think that this is what the whole patch is lacking, why are we talking
about a software problem...

/Jarkko
