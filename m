Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A081ADE2B
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgDQNWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729760AbgDQNWD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 09:22:03 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0030FC061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:22:02 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z90so1828812qtd.10
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Hprasaok50MZK/a/feo2e2oclDOFVapOraKUc6PEaaw=;
        b=Cy4c1ZQe4G9SMrIOkfvW/lXRdE7J7My+efjCR36dpGMsNWVjE2WF0RjP/1LyW0EE9V
         jLhFL2HqJbxsByPjW/xGuaB6H6DHwIQD3vnU5KqfqaUl4DpVTu6oCF82+AJTCKoZzA9b
         eu1wuX9DIqmpGHx2mbpbKznE3HXjwCGDmt4dE5QrzkJVZVj2rpXlqnURyx4Nr0o5muN0
         mIMyTNlbP2Ihpcvo93Z54eXzBKQQ6yvBCGjhHBY7fKT7pfp42Ac7OVhgA3rjiG+O6pej
         WQlV44x9fx+V/4JTeeIrXd9P6rcUuL27qT16PaaKso5mO9s0mK+noBJW2bCVEvN/41Tm
         e73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Hprasaok50MZK/a/feo2e2oclDOFVapOraKUc6PEaaw=;
        b=dKTwq8LI9YZ/ZBy8CU113cwIJyJtkMqfpR5HtacFTNAvWoEouurACnJHgBIyZZ7CGi
         8JWQkdyjTt2U4LP0V62IOglLP84Hz2niegQozkRowbokHFyXje+NjAoqsKRwdNz3KqwM
         RFvNqdkhCG5PoCAdetxtK/UbkdsIPQo6vpxFWg4VI4UiBcK6sW3295E47/XpBDIBHNhf
         V67XUKuKH+cGsj3Parykmtt9j93KDc6qdhhuD3c5MJU+YiGfP2Nv4wmaFhphfTT8iGFA
         MSZMSzW3RB2FUfItTxKCGYCuTGdKVjKZg047vqreL1hl3Wn6p17ZDVRSaaFeLGxWzBUD
         lRLA==
X-Gm-Message-State: AGi0PuZqgzP/kvyXg7UO0Wh6wKk5Nv6UmsOmTX9E+/XnvbQdzoCgj9ye
        9qPqRdqAOFPNUmkfhA/Au6idEg==
X-Google-Smtp-Source: APiQypLINBcGF72yF2OOfhsB7LCEXiY/71TAZiQ84OPjbI8O9xMYQgnMX9Pqn8PJ85t59l4ixc587Q==
X-Received: by 2002:ac8:46d8:: with SMTP id h24mr2932189qto.352.1587129722173;
        Fri, 17 Apr 2020 06:22:02 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id v76sm17479205qka.32.2020.04.17.06.22.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 06:22:01 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH -next] kvm/svm: disable KCSAN for svm_vcpu_run()
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <f02ca9b9-f0a6-dfb5-1ca0-32a12d4f56fb@redhat.com>
Date:   Fri, 17 Apr 2020 09:21:59 -0400
Cc:     Elver Marco <elver@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kasan-dev <kasan-dev@googlegroups.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F15D565-D34D-41F5-B1C5-B9A04626EE97@lca.pw>
References: <20200415153709.1559-1-cai@lca.pw>
 <f02ca9b9-f0a6-dfb5-1ca0-32a12d4f56fb@redhat.com>
To:     "paul E. McKenney" <paulmck@kernel.org>
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
>=20
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paul, can you pick this up along with other KCSAN fixes?

