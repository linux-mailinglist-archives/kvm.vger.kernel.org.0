Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACB1409EE8
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244609AbhIMVN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243266AbhIMVNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:13:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CC960FC1;
        Mon, 13 Sep 2021 21:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631567559;
        bh=esNWxy/m7Hw30qpJ3+NqaN8g/JzsKU9VYxDHqak6ei8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LeoNwpF2nERjyFxzq0TGmq/582irwWYVxgFG/ACwahMUXi4D5zU/GI0J2FITNlmLf
         U7zPMhaFvZWz+nUdFnUvV5RdS6S16mV87UA01WaSm3HaDiUdioAUxbr5mlgYru90si
         vy3XAqNZxtNJM2XoY/ScXZrzezUI485800cxz9JDh2s0Ug0jydLHCd0UFT3hgDZSQ1
         xe7lw/uwWls4X5Y53rfhkhEnf0u7c2v/Z9ZAOfmgxP/u6LGXwhJKXNMemBqyB48+mt
         MQUS72SCFuzmVxQG7RNF5Uj4bYasMPFp3L31cvhBDkEKKl6+hx0RdsVFmLo5HpS9qQ
         8Wjbp9w9tvTIA==
Message-ID: <fdf41507948023b600ef7febfd27951d8435a7dd.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 14 Sep 2021 00:12:36 +0300
In-Reply-To: <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
         <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
         <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
         <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 07:55 -0700, Dave Hansen wrote:
> On 9/13/21 7:24 AM, Paolo Bonzini wrote:
> > > How does this end up happening in the first place?
> > >=20
> > > All enclave pages should start out on 'sgx_dirty_page_list' and
> > > ksgxd sanitizes them with EREMOVE before making them available.  That
> > > should cover EREMOVE after reboots while SGX pages are initialized,
> > > including kexec().
> >=20
> > By "Windows startup" I mean even after guest reboot.  Because another
> > process could sneak in and steal your EPC pages between a close() and a=
n
> > open(), I'd like to have a way to EREMOVE the pages while keeping them
> > assigned to the specific vEPC instance, i.e. *without* going through
> > sgx_vepc_free_page().
>=20
> Oh, so you want fresh EPC state for the guest, but you're concerned that
> the previous guest might have left them in a bad state.  The current
> method of getting a new vepc instance (which guarantees fresh state) has
> some other downsides.
>=20
> Can't another process steal pages via sgxd and reclaim at any time?
> What's the extra concern here about going through a close()/open()
> cycle?  Performance?

sgxd does not steal anything from vepc regions.

They are not part of the reclaiming process.

/Jarkko
