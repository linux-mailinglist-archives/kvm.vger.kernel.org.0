Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0D92CF481
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgLDTF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLDTF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 14:05:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C760C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 11:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=kPqXbu8ArMczX787kSyHe0QSLGZSoxLtTzDM6rGhcKo=; b=SsRqSZI7GMDJZnoFEBtB/0oBQP
        WCJvqwoZAVxyJ6JuqyD5iyQDkANC3HQV9YVC+x1CbaVGE9POWqYVYGb5y0EnSO+MXHh1CCrnrNSSi
        T+bizUwzgZbNDVU+R9dHgLBFG6r6Zh0cG4mOetdSdcmRcNTAa295rKtjl9rb88yCkuXReUm/Tdkow
        k8n2dg/EXnNajSBf+TTI7Xrsi3DVrUs2FFt+hXCqpaMamZ+VdCaYlYZzbE8nmz9znZ24q3LgeqBqn
        UGrIbtCJZgpESelb7ASzcydHXeoSwLD6m+RxNBvzFegD4T0N9Yt9HxlhCHoFNuXCn/Mmh4l19ltvo
        qxU3kjVQ==;
Received: from [2001:8b0:10b:1:782d:346f:3c1:eeee]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klGNo-0001EA-H6; Fri, 04 Dec 2020 19:04:45 +0000
Date:   Fri, 04 Dec 2020 19:04:43 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <b49acc58-70e0-a684-9457-555b059b4761@amazon.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org> <20201204011848.2967588-5-dwmw2@infradead.org> <b49acc58-70e0-a684-9457-555b059b4761@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 04/15] KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <29B9E7DB-CB61-48DC-850A-DA08CC0F19EB@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 December 2020 18:34:40 GMT, Alexander Graf <graf@amazon=2Ecom> wrote:
>On 04=2E12=2E20 02:18, David Woodhouse wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> Disambiguate Xen vs=2E Hyper-V calls by adding 'orl $0x80000000, %eax'
>> at the start of the Hyper-V hypercall page when Xen hypercalls are
>> also enabled=2E
>>=20
>> That bit is reserved in the Hyper-V ABI, and those hypercall numbers
>> will never be used by Xen (because it does precisely the same trick)=2E
>>=20
>> Switch to using kvm_vcpu_write_guest() while we're at it, instead of
>> open-coding it=2E
>>=20
>> Signed-off-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>
>I'm not a big fan of the implicit assumption that "xen hypercall=20
>enabled" means "this will be the offset"=2E Can we make that something=20
>more explicit, say through an ENABLE_CAP?

Nah=2E The kernel owns the ABI, and it would be complete overkill to allow=
 more gratuitous tweakable options here=2E

Can you explain a reason why anyone would ever want to change it?
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
