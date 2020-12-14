Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161AE2DA283
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503619AbgLNVVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgLNVVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 16:21:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172F6C0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=KvyITt9SumauwIQpzwk5tm1fPNAvAS4BDglppUVMRm4=; b=XjX4pzUAtVjR2FBkO7u/G7vl2J
        2eIyBlYFp5USCZC+NTFNfV7WZVkkv7oGk/fhE9K0hh1wtLb2kPMl1DtV7QZ6I+iSVt+QJHpqNHkVg
        BkuTwLR25hb4wl6nwk8e8s1lfyyosIW2rDWf8p0Bhg+G+9vxUl2GSW9UeFpG3CB6VlqUWrSHm/0OA
        w648l6GUN519csIJY37ibop+2Tsd2Np/dMxaE/mPuUE9Er0ZxRwGzKcy26lwpsPJht4prRD9iRqIp
        VAFnxf6C2vmEL2bct23zryHiEjZJc75ZLNTMZ8z7rbvrbSXuX3Z/1ybgdsWKc2mX1mFRoHiUb1N+g
        2hthGMyQ==;
Received: from [2001:8b0:10b:1:4d32:84d8:690e:d301]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kovHE-0000XO-EY; Mon, 14 Dec 2020 21:21:04 +0000
Date:   Mon, 14 Dec 2020 21:21:00 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <87ft48w0or.fsf@vitty.brq.redhat.com>
References: <20201214083905.2017260-1-dwmw2@infradead.org> <20201214083905.2017260-2-dwmw2@infradead.org> <87ft48w0or.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 01/17] KVM: Fix arguments to kvm_{un,}map_gfn()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <6E8FD19B-7ABD-4BF1-84C5-26EDD327F01D@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14 December 2020 21:13:40 GMT, Vitaly Kuznetsov <vkuznets@redhat=2Ecom>=
 wrote:
>What about different address space ids?=20
>
>gfn_to_memslot() now calls kvm_memslots() which gives memslots for
>address space id =3D 0 but what if we want something different? Note,
>different vCPUs can (in theory) be in different address spaces so we
>actually need 'vcpu' and not 'kvm' then=2E

Sure, but then you want a different function; this one is called 'kvm_map_=
gfn()' and it operates on kvm_memslots()=2E It *doesn't* operate on the vcp=
u at all=2E

Which is why it's so bizarre that its argument is a 'vcpu' which it only e=
ver uses to get vcpu->kvm from it=2E It should just take the kvm pointer=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
