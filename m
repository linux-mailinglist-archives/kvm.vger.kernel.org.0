Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E392D2777
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgLHJYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHJYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 04:24:42 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F43C061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 01:24:02 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 131so13343119pfb.9
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 01:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OHqJ3KG1UWpGZSt0jEsvGboL5c5qipaNggtbHIaq4Bo=;
        b=tMKOW8L2NvM4LfHycvIET2kMzLCCSUxD8wA9JzGVhCIvwOpnXLgYnXpUpt+faPhFiF
         WU6d4blAEty2ePFtu0PHN2Skeq+XFogC487TJXR+jYAKumofcXJNY9wmnvTK9+wogEtA
         ODD3Vfh0tJ0y11m1JY0eT24ZVi82IW7E+hOC6qCXxCAiB4a4fntzNo+5dR6fFUSpSzSA
         8yaTin1/Naoci1A0IJh/WyI3d6fGDa4ByVMgr4R3PIqjkdRnrpXBf5iNtC4oKlFHy8j5
         gjBQtnhv0XLdDNLJUbNNEqIN0ISGJIbez9QnXBOPCNnoilEQcKD4EZ0J04HONCEeRd5v
         aw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OHqJ3KG1UWpGZSt0jEsvGboL5c5qipaNggtbHIaq4Bo=;
        b=tmSuqNrCokDO3+bju/VVJUU4v8/mvMxoX/rfBoXBRJVrbFq8P3//39krjTU4tfbmVS
         4LWutm7idqtQj/3ClEGW0ZgwqxE65aZ7Vu2aoGwFmY88J5LtDUeu6oWQBcmPFP63UQfv
         a9CyJobPK+tYIMuppdpL1/go/XkNLkIRURgBTGJWrJ8zELceSKXuOtoPqIv2j2liUPw5
         PmdgqG5s0qX02nnrfoJizcXFvbQx+1hSpNwyoAoCeITeyoNbv+fTyajWgL716smqQY/+
         URjLKIdxJdYo9GSMUPiKCvt3cWTN2+thxpTT+9X56N7GZ9t3+6aDr16ZX1O6WcSBOJW5
         bckQ==
X-Gm-Message-State: AOAM532Nq+DxjzAnTE6AEpKDxyqd+2lRIUViKDbThJ8JS5reihUkFTgQ
        mGmNk1Gi1XcUTRSG146Qoa8=
X-Google-Smtp-Source: ABdhPJxfeZ0VKMS1MOZZthrRviSs79H0hDawHz7xlnRSfbOS5t9AOgXks1vIp/MVXUBjHmxx+ZXcRQ==
X-Received: by 2002:a17:90a:c301:: with SMTP id g1mr3393215pjt.150.1607419442191;
        Tue, 08 Dec 2020 01:24:02 -0800 (PST)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id z29sm14618433pgk.88.2020.12.08.01.24.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:24:01 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite of
 the page allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201208101510.4e3866dc@ibm-vm>
Date:   Tue, 8 Dec 2020 01:23:59 -0800
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
 <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
 <20201208101510.4e3866dc@ibm-vm>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 8, 2020, at 1:15 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>=20
> On Mon, 7 Dec 2020 17:10:13 -0800
> Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>>> On Dec 7, 2020, at 4:41 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>>>=20
>>>> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda
>>>> <imbrenda@linux.ibm.com> wrote:
>>>>=20
>>>> This is a complete rewrite of the page allocator. =20
>>>=20
>>> This patch causes me crashes:
>>>=20
>>> lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
>>>=20
>>> It appears that two areas are registered on AREA_LOW_NUMBER, as
>>> setup_vm() can call (and calls on my system) page_alloc_init_area()
>>> twice.
>>>=20
>>> setup_vm() uses AREA_ANY_NUMBER as the area number argument but
>>> eventually this means, according to the code, that
>>> __page_alloc_init_area() would use AREA_LOW_NUMBER.
>>>=20
>>> I do not understand the rationale behind these areas well enough to
>>> fix it. =20
>>=20
>> One more thing: I changed the previous allocator to zero any
>> allocated page. Without it, I get strange failures when I do not run
>> the tests on KVM, which are presumably caused by some intentional or
>> unintentional hidden assumption of kvm-unit-tests that the memory is
>> zeroed.
>>=20
>> Can you restore this behavior? I can also send this one-line fix, but
>> I do not want to overstep on your (hopeful) fix for the previous
>> problem that I mentioned (AREA_ANY_NUMBER).
>=20
> no. Some tests depend on the fact that the memory is being touched for
> the first time.
>=20
> if your test depends on memory being zeroed on allocation, maybe you
> can zero the memory yourself in the test?
>=20
> otherwise I can try adding a function to explicitly allocate a zeroed
> page.

To be fair, I do not know which non-zeroed memory causes the failure, =
and
debugging these kind of failures is hard and sometimes =
non-deterministic. For
instance, the failure I got this time was:

	Test suite: vmenter
	VM-Fail on vmlaunch: error number is 7. See Intel 30.4.

And other VM-entry failures, which are not easy to debug, especially on
bare-metal.

Note that the failing test is not new, and unfortunately these kind of
errors (wrong assumption that memory is zeroed) are not rare, since KVM
indeed zeroes the memory (unlike other hypervisors and bare-metal).

The previous allocator had the behavior of zeroing the memory to avoid =
such
problems. I would argue that zeroing should be the default behavior, and =
if
someone wants to have the memory =E2=80=9Cuntouched=E2=80=9D for a =
specific test (which
one?) he should use an alternative function for this matter.

