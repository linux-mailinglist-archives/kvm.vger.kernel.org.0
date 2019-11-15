Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7DFDB29
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKOKUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:20:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27634 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfKOKUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:20:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=WvkrPFG/BkQlkJSU9ZGd13o6ArqEw2sKNaKwY2NRc/E=;
        b=LYRrEooqrZzCXy4rZMkBO9ffxNikTfgsHeZTrnNl8h9om494dy0kvDRVt6zVAUO8Fs4yWw
        /xyXcL5qgUz6sHbIUbt3KjFkWA40opVvfTM0T7ES0iBzvKeGvyizNObrfvWguny4vB04ek
        rxD0+HcIqk7o+e8W4yzUJRSNZ7NipqY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-N2jY0Dc6MOiIj8eWtiMMNw-1; Fri, 15 Nov 2019 05:20:45 -0500
Received: by mail-wr1-f70.google.com with SMTP id e3so7387724wrs.17
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0HlomJoHlrjM784oArr+x3B0iN591rhHcF/QFBYxsdY=;
        b=cMx+usyZFgoNfJ9IRHdnV6wZXYH7Mj/LUYnhibZdUwVlrftUHdfmReIaYwxcI0B8YX
         qYbUukfMUdH3X8P38ei0rBbBQKx+0HgzMCfRN5UJBhRdtknn1TGXEKRdGeHGzA1me8PI
         gaX/jkH8r62qvh1xr3z7OxMgn5ZHBWyrz8Qp8YKKGJeinTWDwqcaLx99Eg0N5iQImJSm
         S6hIjfMjAsHWxq0a7cTxEwaeJzz3MZqEisGlNm2GM8ienqsdDNjINlIhthL05DbebhTT
         8dht6GHWPm/n31b2MNgRwsrgIVH66qzie9KDUxr5AVijF4TK0FV47s4k7jbMjG8PKbEL
         yD5Q==
X-Gm-Message-State: APjAAAWlhBYg43CRduKR90smlntucSlQ0YvLMId7yvdXt+TccKWUIw2l
        QGoOiXjg+eh9OeQmXJ5jhKgDdnBygMzcDjw7Yr0Zqi/TCvLxvxX/8nPj6YRZ1glL5nUQkBq+1Ei
        4l/0+1B2avGBN
X-Received: by 2002:a1c:7214:: with SMTP id n20mr13374303wmc.126.1573813242962;
        Fri, 15 Nov 2019 02:20:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqzs9UBFonqyBsd9yk6JD7rpkcjvLFIYaHuBXJJ/xlz80PCjVIkVUhOAbMyG8KbM5rCWu6auEg==
X-Received: by 2002:a1c:7214:: with SMTP id n20mr13374273wmc.126.1573813242635;
        Fri, 15 Nov 2019 02:20:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id 189sm10238582wmc.7.2019.11.15.02.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:20:42 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Consume pending LAPIC INIT event when exit on
 INIT_SIGNAL
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, nadav.amit@gmail.com,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <20191111121605.92972-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2579e897-65a6-008d-bf3c-cc448d415a82@redhat.com>
Date:   Fri, 15 Nov 2019 11:20:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111121605.92972-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: N2jY0Dc6MOiIj8eWtiMMNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:16, Liran Alon wrote:
> Intel SDM section 25.2 OTHER CAUSES OF VM EXITS specifies the following
> on INIT signals: "Such exits do not modify register state or clear pendin=
g
> events as they would outside of VMX operation."
>=20
> When commit 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various =
CPU states")
> was applied, I interepted above Intel SDM statement such that
> INIT_SIGNAL exit don=E2=80=99t consume the LAPIC INIT pending event.
>=20
> However, when Nadav Amit run matching kvm-unit-test on a bare-metal
> machine, it turned out my interpetation was wrong. i.e. INIT_SIGNAL
> exit does consume the LAPIC INIT pending event.
> (See: https://www.spinics.net/lists/kvm/msg196757.html)
>=20
> Therefore, fix KVM code to behave as observed on bare-metal.
>=20
> Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU s=
tates")
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0e7c9301fe86..2c4336ac7576 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3461,6 +3461,7 @@ static int vmx_check_nested_events(struct kvm_vcpu =
*vcpu, bool external_intr)
>  =09=09test_bit(KVM_APIC_INIT, &apic->pending_events)) {
>  =09=09if (block_nested_events)
>  =09=09=09return -EBUSY;
> +=09=09clear_bit(KVM_APIC_INIT, &apic->pending_events);
>  =09=09nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
>  =09=09return 0;
>  =09}
>=20

Queued, thanks.

Paolo

