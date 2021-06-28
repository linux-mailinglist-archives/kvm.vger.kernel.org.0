Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575F93B6B13
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhF1Wyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:54:54 -0400
Received: from forward100j.mail.yandex.net ([5.45.198.240]:48682 "EHLO
        forward100j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234674AbhF1Wyw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 18:54:52 -0400
Received: from iva5-8cd627e71aff.qloud-c.yandex.net (iva5-8cd627e71aff.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:7b87:0:640:8cd6:27e7])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id AC42350E077F;
        Tue, 29 Jun 2021 01:52:22 +0300 (MSK)
Received: from iva6-2d18925256a6.qloud-c.yandex.net (iva6-2d18925256a6.qloud-c.yandex.net [2a02:6b8:c0c:7594:0:640:2d18:9252])
        by iva5-8cd627e71aff.qloud-c.yandex.net (mxback/Yandex) with ESMTP id vwpJntTCq3-qLIK4PAV;
        Tue, 29 Jun 2021 01:52:22 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624920742;
        bh=T9G7dRz6CqpcTUA26MtrxR6s3izNdLMGGegdrGiyyXw=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=npMWpAv8OTz7oEH5MujaWYP98mdoqsvlzOQxPjphAE27YNEdmIeZnePmRw+ogWlpR
         arirb9ylhu2DL/iGtgVXOQbUjJFVsijRsFg8G/h0AYNLIpCZSfnBW2bvTQ0Lgb2Z37
         cv6fhOuHQJ2ES2nyNWDmPAJcxLdklFMxrZwHDxzw=
Authentication-Results: iva5-8cd627e71aff.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva6-2d18925256a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id DCRaTQApGE-qK2qjSOO;
        Tue, 29 Jun 2021 01:52:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <CALMp9eQdxTy4w6NBPbXbJEpyatYB_zhiwykRKCpeoC9Cbuv5gw@mail.gmail.com>
 <de0a87e6-6e2a-bb0c-d3ef-3a70347d59c0@yandex.ru>
 <CALMp9eSW6ZuLbbrosJtG=ejjQCRDuPBs_g4j3SXPZXHjQ7zqDg@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <b019a84a-fa9e-314c-93cd-4e2031fc10d4@yandex.ru>
Date:   Tue, 29 Jun 2021 01:52:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSW6ZuLbbrosJtG=ejjQCRDuPBs_g4j3SXPZXHjQ7zqDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

29.06.2021 01:35, Jim Mattson пишет:
> How long are you willing to defer the EINTR? What if you're running at
> the target of a live migration, and the guest's IDT page needs to be
> demand-fetched over the network? It may be quite some time before you
> can actually deliver that exception.

OK, understood, thank you.
I wonder how many other non-atomic
things are there in KVM, but probably
that doesn't matter much, if
run->ready_for_injection covers them
all at once...

