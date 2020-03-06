Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DE417B42A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgCFCJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:09:59 -0500
Received: from terminus.zytor.com ([198.137.202.136]:47713 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgCFCJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:09:58 -0500
Received: from [IPv6:2601:646:8600:3281:d841:929b:f37:3a31] ([IPv6:2601:646:8600:3281:d841:929b:f37:3a31])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 02629Jmv816866
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 5 Mar 2020 18:09:20 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 02629Jmv816866
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020022001; t=1583460561;
        bh=u42XpQkEklwk2jgju0E0ou84vbvPEJiWthnbO8cPS3A=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=dVhLHqkoS7wQ5iiiNvkSuJ7TeTy9eTtrM72qtwVXXmBWXvq6x/puyEvZ3QWgVOXJi
         H7CLZxQ0/bxM+BNhQqi+KAFnYuny7P7VlRi41ATfnDjvRgF/OSOMGT1wckQ4LKFs0O
         eQkPF/mSRKwk2d6aFiJt9FzzB28orhc0XG9UhxQy7okGS1hjo8G9LzeDq1uCWzhHEu
         Xa80YmRLKkhpa5d0myzE/8LYZ9ujCJ4E3uKB3JJhf98eqX9Qj7mUGy8DLFmPHwfxVH
         w1XDQIKVqD6XsghK7mkdIyrR9arhNGky2KqnQbarq1yEJHzrv7BZrUw12L1NRwZRdg
         KmSX8YiSAzz4A==
Date:   Thu, 05 Mar 2020 18:09:10 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <82b7d2d8c75e4c80a7704ae43940392a@huawei.com>
References: <82b7d2d8c75e4c80a7704ae43940392a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
To:     linmiaohe <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>
From:   hpa@zytor.com
Message-ID: <9209A69A-899B-47A9-8483-E3E5F545D2C4@zytor.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 5, 2020 6:05:40 PM PST, linmiaohe <linmiaohe@huawei=2Ecom> wrote:
>Hi,
>Paolo Bonzini <pbonzini@redhat=2Ecom> wrote:
>>On 05/03/20 03:48, linmiaohe wrote:
>>> From: Miaohe Lin <linmiaohe@huawei=2Ecom>
>>>=20
>>> We can get is_mtrr_mask by calculating (msr - 0x200) % 2 directly=2E
>>>  		index =3D (msr - 0x200) / 2;
>>> -		is_mtrr_mask =3D msr - 0x200 - 2 * index;
>>> +		is_mtrr_mask =3D (msr - 0x200) % 2;
>>>  		if (!is_mtrr_mask)
>>>  			*pdata =3D vcpu->arch=2Emtrr_state=2Evar_ranges[index]=2Ebase;
>>>  		else
>>>=20
>>
>>If you're going to do that, might as well use ">> 1" for index instead
>of "/ 2", and "msr & 1" for is_mtrr_mask=2E
>>
>
>Many thanks for suggestion=2E What do you mean is like this ?
>
>	index =3D (msr - 0x200) >> 1;
>	is_mtrr_mask =3D msr & 1;
>
>Thanks again=2E

You realize that the compiler will probably produce exactly the same code,=
 right? As such, it is about making the code easy for the human reader=2E

Even if it didn't, this code is as far from performance critical as one ca=
n possibly get=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
