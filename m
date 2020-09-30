Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02E227F60C
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 01:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgI3XfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 19:35:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730338AbgI3XfA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 19:35:00 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601508898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlnOJSN7jtIyA5UuOYpzxC90dJDluDPDVDlZFnKVX1I=;
        b=cUZ7TufYvN3QKs01Abt3+g8NRdulpNZjryJujG+pZBQSFTQI6HceGyUSOq3jj9cBaKTejq
        Go/a3J7SMdXxRSTGIj52ooO4+XAfyy1km+GJl3hv4iUgHRbERl4v0XatN3m2JdZHKOiCRH
        uWiyx2VovtE8sZ+hGIYHyFcaMV2Jrp0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-01K0kZz9N7ifeV08zx0AdA-1; Wed, 30 Sep 2020 19:34:57 -0400
X-MC-Unique: 01K0kZz9N7ifeV08zx0AdA-1
Received: by mail-wr1-f70.google.com with SMTP id v5so1236777wrs.17
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wlnOJSN7jtIyA5UuOYpzxC90dJDluDPDVDlZFnKVX1I=;
        b=gCM94/LPIZUeoW5fW8s8g/JGITtdfb1DnihtK7pBgNfqR7NS7Ua7iVlPOoX3cR/mB7
         Ojap1V/XlnAD5AwJiL0Z6u3EbPdPtAnhLF3KZrLepSsWBm+OQYN04+Yb3Fh9pKGorujT
         koTd68dORNTPtYBayRJ9YbJ0Y+qgWAxNPEpH1jb21tTqy6z9UCnY7+er4Q7nibRHh+47
         04YFHVI5YyQcCl+FYjClR7DFaCD9lvcXG2LrQ7cgGh2FLwX0yTVdGsjZTWYGMvPLCwkY
         zszL4eN5L+/SJ4Uy5nOiML+jIo18/864HoO/6xW925MecoCm6YAJridnb/5HHYu/w79H
         WR4Q==
X-Gm-Message-State: AOAM532keS892VYEdbmQ2kwqgaYtQQSvxiOtY7rcD+Y+7saM+mkXyfTe
        IxG1camPXkeqidC6maR2e61BYgaf3walN9DMBms5iMCuqHjUyPi9Jx17g/0V+OJsTw9yhJMPHm0
        g1Y1vUW/gkJul
X-Received: by 2002:a1c:c906:: with SMTP id f6mr5669767wmb.9.1601508895756;
        Wed, 30 Sep 2020 16:34:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKn6uKUCblewMLqqfaHFaoCFp4t4CwvbbE55rUiCAz+ic2k4Fli2bDYK8jRAyxLTah9/YmTA==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr5669750wmb.9.1601508895573;
        Wed, 30 Sep 2020 16:34:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id f23sm1425248wmc.3.2020.09.30.16.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 16:34:55 -0700 (PDT)
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
To:     Eric van Tassell <evantass@amd.com>,
        Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
 <4a74aafe-9613-4bf2-47a1-cad0aad34323@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d43d29f-d29c-3dd7-1709-4414f34d27da@redhat.com>
Date:   Thu, 1 Oct 2020 01:34:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <4a74aafe-9613-4bf2-47a1-cad0aad34323@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 01:20, Eric van Tassell wrote:
>>
>> +int is_shadow_present_pte(u64 pte)
>>   {
>>       return (pte != 0) && !is_mmio_spte(pte);
> From <Figure 28-1: Formats of EPTP and EPT Paging-Structure Entries" of
> the manual I don't have at my fingertips right now, I believe you should
> only check the low 3 bits(mask = 0x7). Since the upper bits are ignored,
> might that not mean they're not guaranteed to be 0?

No, this a property of the KVM MMU (and how it builds its PTEs) rather
than the hardware present check.

Paolo

