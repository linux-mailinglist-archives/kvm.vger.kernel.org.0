Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1AE10246A
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 13:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfKSMa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 07:30:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21513 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfKSMa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 07:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574166655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWZOGr5ICtq/aFztFxDmqbltsTGcVUJoo42VEG8Z8eA=;
        b=dx7INcFykD6/GYdBnfimHoGFU8HbjVx4mCP6Jy7FYLRKtqBdgOfrrc6HV7vv9HsULxIuxi
        hsCwEps+OF27Q1TLr6ja0FUoXv8DYg2+1Phhqn2WAGkVga6nNBoGyknDgjXjsJyB3DQD38
        Qfj5USCPCOvRab+dKs1y/5bqddS/DLU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-B4mpKUnBM2GU6URzmPPrkA-1; Tue, 19 Nov 2019 07:30:54 -0500
Received: by mail-wm1-f69.google.com with SMTP id t203so2167949wmt.7
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:30:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RazlY/9nz4KoV9qfY9wjDTyNIJkVhpBG9ExwMYnQ8lM=;
        b=bk2esAUTOEMy7GwXNkBW+GYU9ios37aUFzAddaXnzBP9ySqM9grQ91LS4+GHDNppbj
         RLWBds0bt3Azr0JgAapRaqDBBB68Lqd0EC7v7FqSWcavRGvFnkWrWvNHN1wiqSChZ99K
         4miBKfw0LuOHrLtld6bWHt2pGcsTTLreopDfZnnPxG0HcO5mVD2AHDJ0FbS5J5rntq1o
         45B/46WqKs8DNeBEIMYGBxI1bIRXMX88PS0nCmaIMgsd7lEsQaWAlRb567oJQifJWVIP
         wIUdKvWjv73pymRXXa4KFF7qOPcponjVrkxgRYx06xbIUJEnlqtLKEAmnC5zmmD+cPVn
         iIFA==
X-Gm-Message-State: APjAAAVCFwGVWx/FTVrcH9kq3ZPexR3O/kKbeLaZAvQ/N1ld5Pl/3uEM
        fUtzD8KZ77TCUd1GWeaLuAvWO6E9bVGIVvyv67EUntc4QQ/mzwZn7y5eIg+wYdr/83LmnqZd0+T
        SKGnFQeZMagA0
X-Received: by 2002:a1c:e915:: with SMTP id q21mr4865234wmc.148.1574166653491;
        Tue, 19 Nov 2019 04:30:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqygc3CcuPmuW58xvsaNQTInQ+tUdBGRNtCe4OxO/jnIonOfBXAKMuZVmzxyZcbbbXRG84qTqQ==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr4865213wmc.148.1574166653264;
        Tue, 19 Nov 2019 04:30:53 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b14sm2913431wmj.18.2019.11.19.04.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 04:30:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        Liran Alon <liran.alon@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH] KVM: x86: Unexport kvm_vcpu_reload_apic_access_page()
In-Reply-To: <20191118172702.42200-1-liran.alon@oracle.com>
References: <20191118172702.42200-1-liran.alon@oracle.com>
Date:   Tue, 19 Nov 2019 13:30:51 +0100
Message-ID: <87ftikgi9w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: B4mpKUnBM2GU6URzmPPrkA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> The function is only used in kvm.ko module.
>
> Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb992f5d299f..7e7a0921d92a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7916,7 +7916,6 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vc=
pu *vcpu)
>  =09 */
>  =09put_page(page);
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
> =20
>  void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>  {

It doesn't seem that we need the declaration in
arch/x86/include/asm/kvm_host.h either (and the function can become
local). Anyway,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

