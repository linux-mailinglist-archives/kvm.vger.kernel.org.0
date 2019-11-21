Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A73105093
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUKcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:32:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48217 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726716AbfKUKca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 05:32:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U2LDZt6nZQHHH1FrYL2g9MKCC3YAvWLT/E1GHIFcizM=;
        b=C1+Tbnl7I6a8Bc59PWwycXQAnhkM51LhLdlO7vWQfVLlvtZU5HXZE69ucHMh6Bd8W2T6rF
        1jJDd58wX2uxOcScDHl2IHBK65nTO9iBpbwBLQ/5TJW10qMSX39DlTRHvjO3533Al1+68l
        m/jyyr5aTURMpFsiiCXDH1bEBK5cG4o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310--X6s9opwP4a59U19p1SjqQ-1; Thu, 21 Nov 2019 05:32:24 -0500
Received: by mail-wr1-f70.google.com with SMTP id j12so1822148wrw.15
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:32:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RCefIYme6aC+9QN5HQO2IUHc5f9eX+/leRuEDcD7AXs=;
        b=UHDrcuin2hi8009TQeA6LHvwSswh4O1PnOJzg9CMOn8//E8nE6FGR0Xa8CaVfHcaFe
         0jH0+Mwm4oXIYLZgtuRylwLDkU+GiEgOhZhzZum3jxxAZcl8QaFXX+UCn7lCSekCz1G6
         cUUgTFB2Yg5kbngM4mc0PdN757bbzuajMAe7xc57Xon3pMgTYNgbNWvQ0N2ArAmOT6yb
         s8u/7kIIXw2t03vJ5Dpxz24/IKe3wx1eThzkuKTB4Y3uX7h5ucwun1ZpjTrDwLGGbOEh
         r6W1aTwL4qgsiEjRu7Vr67j8ysLwoskCtQBALVXhjmwg6V0p8vXCgg4D1oseGrzgAn3u
         m8NQ==
X-Gm-Message-State: APjAAAX22q176ghZMEP3Qg123rMvsmFuMJYUQVn3MslnM75+15yVvFxG
        GJJOOc2JiIm2Ez8rTESHTCgAYmIDTnjYSgsFbgEjPJPBl8MbSjyYHG+256J2Y0ITJ9nRkRJTQDR
        Cv8mHSb0wv0ao
X-Received: by 2002:a1c:e915:: with SMTP id q21mr9238794wmc.164.1574332343497;
        Thu, 21 Nov 2019 02:32:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqzvXDq5rFnE9rr8q7oymU/5CiGqw7gSv8pDuc8DAo5L5cbB5Pc0QJ+smg7kQvVgP8C6NIlFSg==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr9238755wmc.164.1574332343227;
        Thu, 21 Nov 2019 02:32:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id g74sm2153099wme.5.2019.11.21.02.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:32:22 -0800 (PST)
Subject: Re: [PATCH v7 6/9] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-7-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b67b07bf-7051-7dbc-2911-9268d72f0b70@redhat.com>
Date:   Thu, 21 Nov 2019 11:32:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-7-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: -X6s9opwP4a59U19p1SjqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> @@ -5400,6 +5434,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_=
t cr2, u64 error_code,
>  =09=09r =3D vcpu->arch.mmu->page_fault(vcpu, cr2,
>  =09=09=09=09=09       lower_32_bits(error_code),
>  =09=09=09=09=09       false);
> +
> +=09=09if (vcpu->run->exit_reason =3D=3D KVM_EXIT_SPP)
> +=09=09=09return 0;
> +

Instead of this, please add a RET_PF_USERSPACE case to the RET_PF_* enum
in mmu.c.

Paolo

