Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC001AAE51
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416076AbgDOQbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 12:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1416071AbgDOQbC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 12:31:02 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13B7C061A0E
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 09:31:01 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id f13so13622222qti.5
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 09:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Pe2rnVHnSWvKL1ikgOoLe3CQ+A3ETgzCQ267TJC22Kk=;
        b=OIbcbV2EMLoeLU7gyZs0jWK9V/PN+6oiYh1/Ce5GKPXRrYrYQWDvFfCjxOx+6rNBNP
         ApB7jwUUs28tY0jE5+HKVsRRJw7XanGsnQ62FimwaHVB2+ME9AozVl7bPe939/bVljeC
         DayP8uZwWIn3Uid9fK6iQxKIEoX/bYOuKxJJRp3npN1BC2DMZq6SfFGu2qiUB51xLDPk
         pRnad5nkRJYxYXn12rOAkcJ7d73kmOvQLjLeB/vJBD6BJ9nCafddthf2Q+z/PcjbHIPp
         QMbwXA5ND0o4T8WUOhY7pMuAzmz/vqohZjf+bCWQbp0baSveuxmTU1Pc/4wFjUXkeN9G
         owtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Pe2rnVHnSWvKL1ikgOoLe3CQ+A3ETgzCQ267TJC22Kk=;
        b=hnlHHTi/Lbr3Sg7znGzGnHrzne0+JVxWHvbGE1rF0Q1MrPax1+8NzZeGFRacXUD5lI
         cGc+d6KqNoPpv+6H43ojdJMOhIFD6W9CXYBbFqsBkFH12UgOkXezojB1lhkMVzAF9PkB
         39hvq7LKY1Kp3g+rzAB64HoL2vNGecTbESfEKrRcDTFakMZtUDGQgEo8QsjcUpBZIOas
         Js/PBTjRj5FWudu0ZVm9/m+Pd2+s/usifVpxC4YSLXC086PfzeddrXuF0bWSVZH9+1C1
         jgC/Pq/dJAh8u2bMNBoz5tm8F7HrNM3mcwnitid6SQvS/1jCRwLVLi8LH++uxyTsDHbX
         oG5Q==
X-Gm-Message-State: AGi0PuZ0Q7ufmALISr9055q7wxFIe77MXXwZ9CgfsU+psR83lfyWZXak
        L3CtoyYQ53it3I8T7TcI1mMmCA==
X-Google-Smtp-Source: APiQypJ9FVEMMRCXJ71iXDSoma3WW0qBcT6SvxXFQAX/LV5sygozgV13wU/1c0u1RUmblhYgrcWiQQ==
X-Received: by 2002:ac8:4e2c:: with SMTP id d12mr2252732qtw.204.1586968259960;
        Wed, 15 Apr 2020 09:30:59 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id n64sm12808792qka.18.2020.04.15.09.30.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 09:30:59 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH -next] kvm/svm: disable KCSAN for svm_vcpu_run()
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <f02ca9b9-f0a6-dfb5-1ca0-32a12d4f56fb@redhat.com>
Date:   Wed, 15 Apr 2020 12:30:58 -0400
Cc:     "paul E. McKenney" <paulmck@kernel.org>,
        Elver Marco <elver@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kasan-dev <kasan-dev@googlegroups.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <94BC9E64-A189-4475-9C75-240F732C078D@lca.pw>
References: <20200415153709.1559-1-cai@lca.pw>
 <f02ca9b9-f0a6-dfb5-1ca0-32a12d4f56fb@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 15, 2020, at 11:57 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 15/04/20 17:37, Qian Cai wrote:
>> For some reasons, running a simple qemu-kvm command with KCSAN will
>> reset AMD hosts. It turns out svm_vcpu_run() could not be =
instrumented.
>> Disable it for now.
>>=20
>> # /usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host
>> 	-smp 2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2
>>=20
>> =3D=3D=3D console output =3D=3D=3D
>> Kernel 5.6.0-next-20200408+ on an x86_64
>>=20
>> hp-dl385g10-05 login:
>>=20
>> <...host reset...>
>>=20
>> HPE ProLiant System BIOS A40 v1.20 (03/09/2018)
>> (C) Copyright 1982-2018 Hewlett Packard Enterprise Development LP
>> Early system initialization, please wait...
>>=20
>> Signed-off-by: Qian Cai <cai@lca.pw>
>> ---
>> arch/x86/kvm/svm/svm.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 2be5bbae3a40..1fdb300e9337 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3278,7 +3278,7 @@ static void svm_cancel_injection(struct =
kvm_vcpu *vcpu)
>>=20
>> bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>>=20
>> -static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>> +static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
>> {
>> 	struct vcpu_svm *svm =3D to_svm(vcpu);
>>=20
>>=20
>=20
> I suppose you tested the patch to move cli/sti into the .S file.  =
Anyway:

Yes, tested that without any luck.

