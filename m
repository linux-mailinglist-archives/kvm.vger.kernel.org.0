Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA6F4D9D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 14:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfKHN4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 08:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfKHN4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 08:56:40 -0500
Received: from linux-8ccs (x2f7fce5.dyn.telefonica.de [2.247.252.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56B7214DB;
        Fri,  8 Nov 2019 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573221399;
        bh=n9ystWPITpLlZG9fAxteJieqtPVAxlo0c6o7Uuvsikw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FojtLrtALDOI9gVhEgdOdfgo9H8nnaaqZlSjepLU7bnBYMXgCFTVqA/8RxEPPkQ4C
         gxzMDjTKKqrGgLB9785qbuuxp7Np3WO575y5i610Bq46Xxmy6C/XGY+WouXnhoVm/4
         2jqdx3/gokNhHxPe1+TdeK7g1iOEw7NnqRCBx5bE=
Date:   Fri, 8 Nov 2019 14:56:31 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
Message-ID: <20191108135631.GA22507@linux-8ccs>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com>
 <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+++ Paolo Bonzini [05/11/19 16:10 +0100]:
>On 05/11/19 15:56, Andrea Arcangeli wrote:
>>>> I think we should:
>>>>
>>>> 1) whitelist to shut off the warnings on demand
>>>
>>> Do you mean adding a whitelist to modpost?  That would work, though I am
>>> not sure if the module maintainer (Jessica Yu) would accept that.
>>
>> Yes that's exactly what I meant.
>
>Ok, thanks.  Jessica, the issue here is that we have two (mutually
>exclusive) modules providing the same interface to a third module.

>Andrea will check that, when the same symbol is exported by two modules,
>the second-loaded module correctly fails insmod.

Hi Paolo, thanks for getting me up to speed.

The module loader already rejects loading a module with
duplicate exported symbols.

> If that is okay, we will also need modpost not to warn for these
> symbols in sym_add_exported.

I think it's certainly doable in modpost, for example we could pass a
list of whitelisted symbols and have modpost read them in and not warn
if it encounters the whitelisted symbols more than once.  Modpost will
also have to be modified to accomodate duplicate symbols.  I'm not
sure how ugly this would be without seeing the actual patch.  And I am
not sure what Masahiro (who takes care of all things kbuild-related)
thinks of this idea. But before implementing all this, is there
absolutely no way around having the duplicated exported symbols? (e.g.,
could the modules be configured/built in a mutally exclusive way? I'm
lacking the context from the rest of the thread, so not sure which are
the problematic modules.)

Thanks,

Jessica
