Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC1110505A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfKUKS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:18:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31609 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbfKUKS4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 05:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574331535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gek0hQ8ZLdLms7wGQFlBpywg0Dh4Rzi7CF4EhMq+qI=;
        b=hFzV9mhHRxO/DZs4lCxQlSxVOOuYrX1ZeeJL9gqobRgVUojk2EKXban9y/bgKGqQcLpSql
        Nn8mqsF1KCKnjvCRfYmZJRJ4HJK5O7uSYI4m7wm0i/67ChfSKAqhoRrwGYkEE2HnmZ2U1k
        IgPMKoFUWnsLolr+GwG9xpWGTjEOxEg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-poTt-IUCO6CQqvMzofZl2Q-1; Thu, 21 Nov 2019 05:18:52 -0500
Received: by mail-wm1-f69.google.com with SMTP id i23so1347996wmb.3
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:18:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YLr6hs+2kbTqnRRA4/wKkKRGchRZdYPhFr9/x9KHzBY=;
        b=YHXCiWIpqsX/YIA20lpAXZUvNBWi+THhjeXyCXKdQcQqQyb74oNwF/cmjXo2qY/dVp
         eVRqj+vZuvAsZ9y79cple+a0ItKO6NNrbO34dElxdDn/rKKHuQX+rSldHqfddAM79Zgn
         BM0UogqHeYzEz7jZgyl57FTSEYRBOKIbimSrwVCZ01KBM1wXaJrcomQOlQDO6gBTqITp
         7PZNvx1T0hzNvEpk9Nm2tRhehNT5vNdzRUBg/fvxZuLjHp+rqhP5Piy5ambNG3thE01p
         s86QgXTUiM0vMJxtJIGPkmVaupRvePbI/OudiKYqiRT9xSKdmtYihpIEc15IKIzfYIBd
         debA==
X-Gm-Message-State: APjAAAVA1aLwmXTQRljF92NZwn3kk+9OV/6NR4k7bkZtIeaJ7bpCVLG0
        luxtpeP/aIlBkj4BHCKdoN7YBhsdD/Sv0CsdJva/dbOk41c5VHqb4zeb/xIBvGoV9BRVQXzKH6v
        k5/3Uq1NFKYRh
X-Received: by 2002:a1c:3d08:: with SMTP id k8mr8486652wma.119.1574331530232;
        Thu, 21 Nov 2019 02:18:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1iABHZAx/K/IiCjLw7xRZnkNUg1zfGJVjoWHiAW0VkGqID4bxFvDIq/LBBkZR+P28g3p1Lg==
X-Received: by 2002:a1c:3d08:: with SMTP id k8mr8486628wma.119.1574331529928;
        Thu, 21 Nov 2019 02:18:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id t134sm2468758wmt.24.2019.11.21.02.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:18:49 -0800 (PST)
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
Message-ID: <a7ce232b-0a54-0039-7009-8e92e8078791@redhat.com>
Date:   Thu, 21 Nov 2019 11:18:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-7-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: poTt-IUCO6CQqvMzofZl2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> +=09=09=09if (spte & PT_SPP_MASK) {
> +=09=09=09=09fault_handled =3D true;
> +=09=09=09=09vcpu->run->exit_reason =3D KVM_EXIT_SPP;
> +=09=09=09=09vcpu->run->spp.addr =3D gva;
> +=09=09=09=09kvm_skip_emulated_instruction(vcpu);

Do you really want to skip the current instruction?  Who will do the write?

> +=09=09pr_info("SPP - SPPT entry missing! gfn =3D 0x%llx\n", gfn);

Please replace pr_info with a tracepoint.

> +=09=09slot =3D gfn_to_memslot(vcpu->kvm, gfn);
> +=09=09if (!slot)
> +=09=09=09return -EFAULT;

You want either a goto to the misconfig case, so that there is a warn

> +=09=09spp_info.base_gfn =3D gfn;
> +=09=09spp_info.npages =3D 1;
> +
> +=09=09spin_lock(&vcpu->kvm->mmu_lock);
> +=09=09ret =3D kvm_spp_get_permission(vcpu->kvm, &spp_info);
> +=09=09if (ret =3D=3D 1) {

Can you clarify when ret will not be 1?  In this case you already have a
slot, so it seems to me that you do not need to go through
kvm_spp_get_permission and you can just test "if
(kvm->arch.spp_active)".  But then, spp_active should be 1 if you get
here, I think?

> +=09pr_alert("SPP - SPPT Misconfiguration!\n");
> +=09return 0;


pr_alert not needed since you've just warned.

Paolo

