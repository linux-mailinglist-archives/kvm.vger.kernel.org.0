Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C004BA573
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiBQQKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:10:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiBQQKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:10:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C02129C129
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645114197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FAWt4czYDNu66iQZT9sCnbsSHD9evPpifQVxgtYTip0=;
        b=Vo/OjV6CgCjES8lf51jpMdA2ZoptDfd6Bkwu07BZ+KPrbPRz3EJmAhtCnQtUW0S5NQQcSM
        Hh3pbZkWN2UeiYbYzwpGl3vQ+KAgADrRsDT0JKZgVuyWNjW50bqK1ASPT8LBaWKSrBY1zE
        bwahuvbvT2jhqjbReK0GL6woNJIpbTY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-kZBkAjCqOn2DD_HqH6pzTA-1; Thu, 17 Feb 2022 11:09:56 -0500
X-MC-Unique: kZBkAjCqOn2DD_HqH6pzTA-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso3789555edt.20
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:09:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FAWt4czYDNu66iQZT9sCnbsSHD9evPpifQVxgtYTip0=;
        b=xWV1mEaBep4+TzbYyMEbSOl2/0Oz1Dzd0hCKBqVaZfsUImzCXCnko+oEUeSd4TweOl
         Lhim+02o9/nELFcF7ixSEPLjZlnV9C5/De2iUCk+FM51kgX6bFkV/jtlp4NNAjpCsY7s
         5Pvihqty0wwiNWawXghTGmg6hjbklNU0zkex/mlOyKHciz3tW0a3VZPmBsunZ6TlcDTH
         OhVqRBYpgnEsqjCJXN2+QsJ3n0W+F7XCoq2y5TWSxJwB6FeEryljO8c25HofWE0tRSK9
         jFt9316g/Fk2X9Opd9N90lao0WIVK1pJGjuVseEPc+Ubv0HsOB2JQBdRXMvEKx7jgaM6
         zMPw==
X-Gm-Message-State: AOAM5303zJs7IWLSVWd/7FTCQp6sGCWyoQqgVqb98g8YbaWygwIO/m0C
        bnaskeJ45gXysXTRaF46f53V5j8W28QfF3Szj0NJZdo/y5YuIuaxNLeV+hPxI+k1Ok9KdFQo8z0
        azhs4mLAWEh/0
X-Received: by 2002:a50:aadc:0:b0:40f:5c06:ebb7 with SMTP id r28-20020a50aadc000000b0040f5c06ebb7mr3337185edc.387.1645114194963;
        Thu, 17 Feb 2022 08:09:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7ls7ajpw46YysTgJxZNPqwUxp3yjkdCBFNPwsR1Py9bMj5lewiOH9H0LY94cCw1zKkSLKlA==
X-Received: by 2002:a50:aadc:0:b0:40f:5c06:ebb7 with SMTP id r28-20020a50aadc000000b0040f5c06ebb7mr3337171edc.387.1645114194800;
        Thu, 17 Feb 2022 08:09:54 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d21sm1313600eja.15.2022.02.17.08.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:09:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anton Romanov <romanton@google.com>, mtosatti@redhat.com,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
In-Reply-To: <Yg5sl9aWzVJKAMKc@google.com>
References: <20220215200116.4022789-1-romanton@google.com>
 <87zgmqq4ox.fsf@redhat.com> <Yg5sl9aWzVJKAMKc@google.com>
Date:   Thu, 17 Feb 2022 17:09:53 +0100
Message-ID: <87pmnlpj8u.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Feb 16, 2022, Vitaly Kuznetsov wrote:

...
>
>> Also, EOPNOTSUPP makes it sound like the hypercall is unsupported, I'd
>> suggest changing this to KVM_EFAULT.
>
> Eh, it's consistent with the above check though, where KVM returns KVM_EOPNOTSUPP
> due to the vclock mode being incompatible.  This is more or less the same, it's
> just a different "mode".  KVM_EFAULT suggests that the guest did something wrong
> and/or that the guest can remedy the problem in someway, e.g. by providing a
> different address.  This issue is purely in the host's domain.

Ack, Paolo's already made the change back to KVM_EOPNOTSUPP upon commit
(but I still mildly dislike using 'EOPNOTSUPP' for a temporary condition
on the host).

-- 
Vitaly

