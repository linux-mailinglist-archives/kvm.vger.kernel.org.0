Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00C820A529
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406247AbgFYSo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 14:44:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728204AbgFYSoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 14:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593110663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bz0DcoUt/GEkUm1L3M53l7xA0v5o3+zCrwD/K63P38U=;
        b=aBSElJk60xKF15YP2xZd1o0KL8GOGzqdBtFquf0j9MKI3fHu9OtjDVJgwmVHr17bRn+Ugb
        KGkHsgPxF5xs37VPuYwjqidG1T4fiy2LdYpLZb5BsJZuMvCkNN5A40QI18QvHZP6Ba11nk
        2OmhQ7pWitLkJwoX4Fm6cxWkCGqnork=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-oZa_eVGmMc2ldOO25BktBg-1; Thu, 25 Jun 2020 14:44:22 -0400
X-MC-Unique: oZa_eVGmMc2ldOO25BktBg-1
Received: by mail-wr1-f69.google.com with SMTP id i14so7644319wru.17
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 11:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bz0DcoUt/GEkUm1L3M53l7xA0v5o3+zCrwD/K63P38U=;
        b=Pq6zTJocwZMLdqX8Xl88eSDayykZJ/sjLZACrGTdxB1B4ZsSoL26ELD+HPMgfREaLH
         uUGn2w6DjQwqs4Ba7FPItxP1XLNsFl59RyiHP2p9JqQYxun7dU15ZxBrkchND88KcrFx
         C+e2Cw+n25KhCnVFs6s5hdEbL5TUDf3JSF+2lxG68VmWP1GQlFWCgC+oseH1zzSeNEZc
         zX5OzpFno9lKAPhIKVKvzJsRkUTFYwvquAkIgxDxiIeX9o6UV4K6shRz/ZrZ4yaKJ4cR
         RoSSDaeWETTuGRioeYsQcnVRVamuVzPt72bRu1o7o1wHZ32b5c0LaHR6cDZdREDk4FeR
         BKhg==
X-Gm-Message-State: AOAM533FTUDuWHms/B8DllqnE8ddJvV+e+7tA34EIDbPLvDjmwkLNse+
        AqpM+bEoIcgg+i0CKW2IXJ7pdep6JJgbVtWWcMsL6+So1Aoz5qApetGhlp220AY/x8yYgq22h/m
        I/UymcJJLaoao
X-Received: by 2002:adf:ea06:: with SMTP id q6mr32695721wrm.69.1593110660857;
        Thu, 25 Jun 2020 11:44:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrgg/PEY410CP4hdZskO+84trrFvrrZMUq4hsvdqChoqu2wlgLOz4Hq4TsNc62TvpFAkj7ZA==
X-Received: by 2002:adf:ea06:: with SMTP id q6mr32695701wrm.69.1593110660616;
        Thu, 25 Jun 2020 11:44:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id c17sm11175701wmd.10.2020.06.25.11.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 11:44:19 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <df859fb0-a665-a82a-0cf1-8db95179cb74@redhat.com>
Date:   Thu, 25 Jun 2020 20:44:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200625162540.GC3437@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 18:25, Sean Christopherson wrote:
> I get the "what" of the change, and even the "why" to some extent, but I
> dislike the idea of supporting/encouraging blind reads/writes to MSRs.
> Blind writes are just asking for problems, and suppressing warnings on reads
> is almost guaranteed to be suppressing a KVM bug.

Right, that's why this patch does not just suppress warnings: it adds a
different return value to detect the case.

> TSC_CTRL aside, if we insist on pointing a gun at our foot at some point,
> this should be a dedicated flavor of MSR access, e.g. msr_data.kvm_initiated,
> so that it at least requires intentionally loading the gun.

With this patch, __kvm_get_msr does not know about ignore_msrs at all,
that seems to be strictly an improvement; do you agree with that?  What
would you think about adding warn_unused_result to __kvm_get_msr?

Paolo

