Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7974EBEF91
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 12:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfIZK0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 06:26:44 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbfIZK0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Sep 2019 06:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569493602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=mNG10gBF6wOW4DTrJOiYKEDnUnRCCHO24n0QfJhKwcA=;
        b=Iqr5jA5Nhbp6YZY2mQdJimOJPVCEKf4RluyqhWnZ7JhtNAkhBr5whcsAq4Hp46A4342fzd
        up1uVYsfDAzJzhsqRX13c0oatIBQ/8oW+TtEoTAmF4ykR3/RzLjgtfOOWHN5VjPBa5JN15
        SD4c7nZXb5mbuht8XpkerSsfSFKWU44=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-DR46AFP2PZynIMed95CCPQ-1; Thu, 26 Sep 2019 06:26:40 -0400
Received: by mail-wm1-f70.google.com with SMTP id o8so955102wmc.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jhgtNMeBQuXrr5x5dyya1MaD3NyvL+WMHqX9MZMtA+s=;
        b=D3g56su/l4821I0wUDyEgqdX5quRwkcAzxmEbqqusY74cpdlzpfXBYdkIFVuayG46i
         URHHeinb1NTm13oLU0sG+salLHvGgK7VXw96uXN6uUSMbZCbtXFscPNr8lPyPsXPKftT
         Sr2n+C/IRYRVLtryWxV7HMXGrvrGy3ZK8rEYzEXqieLDTqnjcT62NuQdc5uGypeGEpKo
         WMvfYS3eQnKUWhWh2En1QULFdRomLkKdrdVUu27xJlSnOOwyBbvtn/A/jFNCvHsynWX4
         CUxM4MfoIhoJxbN85sBFr/ZNvYvm1lei98tVscpF1RQlSJ9VQPfqCpH6t3Rq87DIbslq
         MAdg==
X-Gm-Message-State: APjAAAUq22eHlkHCee0cUKMDaE3XBTOSVl+bBxtFjA5uxsnx17+LX3N2
        R9qx8xwwGuADXmtPcmbUPabJ60eFQZHttvkX8Y8Ta+Iy18/youB0iXW5hhhBeobiYkbpmeQ0h82
        RoUClfnF0cZut
X-Received: by 2002:adf:84c6:: with SMTP id 64mr2519661wrg.287.1569493598825;
        Thu, 26 Sep 2019 03:26:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyIlAt9KhYlAiFQa2Dj6amqe/I1xxXteE8hBI46+eRgahILyA+ZuOSNF7d0wkq4f8evd/l9Qw==
X-Received: by 2002:adf:84c6:: with SMTP id 64mr2519640wrg.287.1569493598532;
        Thu, 26 Sep 2019 03:26:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id r13sm4090939wrn.0.2019.09.26.03.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:26:38 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>
References: <20190925181714.176229-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f0e0e562-7e3a-9abe-33e0-13134e9bc50b@redhat.com>
Date:   Thu, 26 Sep 2019 12:26:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925181714.176229-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: DR46AFP2PZynIMed95CCPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 20:17, Jim Mattson wrote:
> Don't return -E2BIG from __do_cpuid_func when processing function 0BH
> or 1FH and the last interesting subleaf occupies the last allocated
> entry in the result array.
>=20
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: 831bf664e9c1fc ("KVM: Refactor and simplify kvm_dev_ioctl_get_supp=
orted_cpuid")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index dd5985eb61b4c..a3ee9e110ba82 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -612,16 +612,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_=
entry2 *entry, u32 function,
>  =09 */
>  =09case 0x1f:
>  =09case 0xb: {
> -=09=09int i, level_type;
> +=09=09int i;
> =20
> -=09=09/* read more entries until level_type is zero */
> -=09=09for (i =3D 1; ; ++i) {
> +=09=09/*
> +=09=09 * We filled in entry[0] for CPUID(EAX=3D<function>,
> +=09=09 * ECX=3D00H) above.  If its level type (ECX[15:8]) is
> +=09=09 * zero, then the leaf is unimplemented, and we're
> +=09=09 * done.  Otherwise, continue to populate entries
> +=09=09 * until the level type (ECX[15:8]) of the previously
> +=09=09 * added entry is zero.
> +=09=09 */
> +=09=09for (i =3D 1; entry[i - 1].ecx & 0xff00; ++i) {
>  =09=09=09if (*nent >=3D maxnent)
>  =09=09=09=09goto out;
> =20
> -=09=09=09level_type =3D entry[i - 1].ecx & 0xff00;
> -=09=09=09if (!level_type)
> -=09=09=09=09break;
>  =09=09=09do_host_cpuid(&entry[i], function, i);
>  =09=09=09++*nent;
>  =09=09}
>=20

Queued, thanks.

Paolo

