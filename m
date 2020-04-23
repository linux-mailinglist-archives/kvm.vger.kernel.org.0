Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA051B5F4B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgDWPda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDWPd3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 11:33:29 -0400
Received: from chronos.abteam.si (chronos.abteam.si [IPv6:2a01:4f8:140:90ea::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47EBC09B040
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:33:29 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by chronos.abteam.si (Postfix) with ESMTP id 7764C5D00090;
        Thu, 23 Apr 2020 17:33:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bstnet.org; h=
        content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:from:from:references:subject:subject; s=default; t=
        1587656006; x=1589470407; bh=1WIvFSXmtMM9Yp5tE2vZWpIna/XHKN/+oYk
        YGDyAYJY=; b=eMS7Ylg5SXqqHk8z0anyLf+QHoXtxvVViGEWFJilIVvmx+M+YVO
        6n3s5xpHHvLrozO0CzXthX79fhIzX39OKpvfFPSBCTdEejHFdhhaI43sTXzi8+DG
        og01epYiufzZ7die7YTeHTPPEYeqr8m9w4edwJs4KBRKrAYaQOhjk3m8=
Received: from chronos.abteam.si ([127.0.0.1])
        by localhost (chronos.abteam.si [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rKebhu9E2b9Z; Thu, 23 Apr 2020 17:33:26 +0200 (CEST)
Received: from bst-slack.bstnet.org (unknown [IPv6:2a00:ee2:4d00:602:d782:18ef:83c9:31f5])
        (Authenticated sender: boris@abteam.si)
        by chronos.abteam.si (Postfix) with ESMTPSA id 9CDDC5D00084;
        Thu, 23 Apr 2020 17:33:24 +0200 (CEST)
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
 <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
From:   "Boris V." <borisvk@bstnet.org>
Message-ID: <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
Date:   Thu, 23 Apr 2020 17:33:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-23 13:54, Suravee Suthikulpanit wrote:
> Boris,
>
> On 4/22/20 12:43 PM, Boris V. wrote:
>> Hello,
>>
>> when running qemu with GPU passthrough it crashes with 5.6 and also=20
>> 5.7-rc kernels, it works with 5.5 and lower.
>> Without GPU passthrough I don't see this crash.
>> With bisecting, I found commit that causes this BUG.
>> It seems bad commit is f458d039db7e8518041db4169d657407e3217008, if I=20
>> revert this patch it works.
>
> Could you please try the following patch?
>
> Thanks,
> Suravee
>
> --- BEGIN PATCH ---
> commit 5a605d65a71583195f64d42f39a29c771e2c763a
> Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Date:=C2=A0=C2=A0 Thu Apr 23 06:40:11 2020 -0500
>
> =C2=A0=C2=A0=C2=A0 kvm: ioapic: Introduce arch-specific check for lazy =
update EOI=20
> mechanism
>
> =C2=A0=C2=A0=C2=A0 commit f458d039db7e ("kvm: ioapic: Lazy update IOAPI=
C EOI")=20
> introduces
> =C2=A0=C2=A0=C2=A0 a regression on Intel VMX APICv since it always forc=
e IOAPIC lazy=20
> update
> =C2=A0=C2=A0=C2=A0 EOI mechanism when APICv is activated, which is need=
ed to support AMD
> =C2=A0=C2=A0=C2=A0 SVM AVIC.
>
> =C2=A0=C2=A0=C2=A0 Fixes by introducing struct kvm_arch.use_lazy_eoi va=
riable to specify
> =C2=A0=C2=A0=C2=A0 whether the architecture needs lazy update EOI suppo=
rt.
>
> =C2=A0=C2=A0=C2=A0 Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPI=
C EOI")
> =C2=A0=C2=A0=C2=A0 Signed-off-by: Suravee Suthikulpanit <suravee.suthik=
ulpanit@amd.com>
> ---
> =C2=A0arch/x86/include/asm/kvm_host.h | 2 ++
> =C2=A0arch/x86/kvm/ioapic.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 3 +++
> =C2=A0arch/x86/kvm/svm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1 +
> =C2=A03 files changed, 6 insertions(+)
>

Yes, this this patch works, there is no longer kernel BUG.

Thanks,
Boris

