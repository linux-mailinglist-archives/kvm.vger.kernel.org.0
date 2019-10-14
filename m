Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0BD65AE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbfJNO5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 10:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732518AbfJNO5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 10:57:18 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0138F796FF
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 14:57:18 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id v18so8580162wro.16
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 07:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DkYmESCvkqzPI8cu0bSgZGf7oLIsgWwrCSCE1AMG5A0=;
        b=IiIBwltzQeM0cs1xqii7G5GeJSJmMSE5tvh8WBnR+xXgJgdMLHOmaDVAncXdnLflte
         JAV9ZAetP5FaTjd4tEB0R3Bk+x/03/JHYbzKprkgYuKFSGTVojkc4gwoPmSo/5NQaKJL
         OZmfSkZHevI8A7y4X/Q2XJBD/bkn125E+1YK9fjSTUO261hPcucosuU5BCXh16o7PvI/
         WF8uuHqgsoZtOmxyEvqU5xZtsge6rj5+DEchJadrX4kcFVnc+fkFDeLEEtB+yKtJenaL
         YbCs1y+O55NCjBvAr7FBFwQUZpAhHadViuG5yUfZws4MB7WCUdifKmMMVqqz8+EKMCJG
         MzYw==
X-Gm-Message-State: APjAAAX6CHECMGXAymbl5VlPU3okxCpx/GeXAcYx4d+bZj/xUYfeU4P5
        icaNVAXhEJ625fj2tZ6qttLIJFn8+3BLk9Q7/1L9Upxj8ojJuwdo2KYVMg0tfuZtrX5lb4QFcol
        RV5Bro5qSH/yc
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr14371408wmi.132.1571065036698;
        Mon, 14 Oct 2019 07:57:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw4xINcheBC8vgbQy7E0ixh7c7nKSa/MD6EfRy6mNcx99/7Gzvtdv8Al1WAYd/C2tuPgoMoNg==
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr14371386wmi.132.1571065036468;
        Mon, 14 Oct 2019 07:57:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 59sm40931491wrc.23.2019.10.14.07.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 07:57:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "lantianyu1986\@gmail.com" <lantianyu1986@gmail.com>
Cc:     "qemu-devel\@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst\@redhat.com" <mst@redhat.com>,
        "cohuck\@redhat.com" <cohuck@redhat.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rth\@twiddle.net" <rth@twiddle.net>,
        "ehabkost\@redhat.com" <ehabkost@redhat.com>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH] target/i386/kvm: Add Hyper-V direct tlb flush support
In-Reply-To: <KL1P15301MB02611D1F7C54C4A599766B8D92900@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
References: <20191012034153.31817-1-Tianyu.Lan@microsoft.com> <87r23h58th.fsf@vitty.brq.redhat.com> <KL1P15301MB02611D1F7C54C4A599766B8D92900@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
Date:   Mon, 14 Oct 2019 16:57:14 +0200
Message-ID: <875zkr5q9h.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tianyu Lan <Tianyu.Lan@microsoft.com> writes:

>> > --- a/linux-headers/linux/kvm.h
>> > +++ b/linux-headers/linux/kvm.h
>> > @@ -995,6 +995,7 @@ struct kvm_ppc_resize_hpt {
>> >  #define KVM_CAP_ARM_SVE 170
>> >  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>> >  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
>> > +#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 174
>>
>> I was once told that scripts/update-linux-headers.sh script is supposed
>> to be used instead of cherry-picking stuff you need (adn this would be a
>> separate patch - update linux headers to smth).
>>
>
> Thanks for suggestion. I just try the update-linux-headers.sh and there are a lot
> of changes which are not related with my patch. I also include these
> changes in my patch, right?
>

Yes, see e.g.

commit d9cb4336159a00bd0d9c81b93f02874ef3626057
Author: Cornelia Huck <cohuck@redhat.com>
Date:   Thu May 16 19:10:36 2019 +0200

    linux headers: update against Linux 5.2-rc1

as an example.

-- 
Vitaly
