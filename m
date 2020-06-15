Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687741F9942
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 15:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgFONrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 09:47:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20786 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728326AbgFONrJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 09:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592228827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weheyMNu1Wo9nH5YiVxVjdHICGi6lkG7Hb/LLVN60N8=;
        b=AmSwvQ+RJ5ErYR37ToKXOlgWHVj2MG0GBjwzcO2KpgT0LfwgnFSLmKN6Qb8Aj2fmTAZOqY
        Zsft+Bz8N0T3lZ64eG0sAuSjPHYODtH0VuFXnPjiAnin4EROjwvw8s/czYCFcvnh2myvqI
        0KeFuSNwBORB8wqpAZPGfrN8CFlbD7s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-GbxoDgSBNIKhpRSoMxL63w-1; Mon, 15 Jun 2020 09:46:56 -0400
X-MC-Unique: GbxoDgSBNIKhpRSoMxL63w-1
Received: by mail-wr1-f70.google.com with SMTP id j16so7013631wre.22
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 06:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=weheyMNu1Wo9nH5YiVxVjdHICGi6lkG7Hb/LLVN60N8=;
        b=aX01uIOI2rGoxzvoRrFgbYegnF0qoAWjP4z9IIoX1xQx7A5MyD+fzRz4SsyE1j7qlI
         u2OWJcrPd6VM+6m5jGR5k7lfJ0MBlTV9kXCdXonve7V7FEznGRhZB0OUtMDyvUTtO7dM
         oGUT2O+QwEnrC1KxIuY2oY0OkKWUnVcQOE8mrYcXLWCohfd6gtjYwf827K2+KRvgg1vK
         2xR0aG1GtAtvEUxKm2xIGi7KcuCMw3USlauMIfIXf4cfQ9MRm6ZITeawV5H0zG9XSotU
         xuun/UhPjjYN+4kW2O6PIUx4Kv2hrjCOV9JTnHl24uf/5WItPDmR7JTY86noQ+aXt+vg
         ZGtw==
X-Gm-Message-State: AOAM532bmIJ4CHolS6ifs5L3T/HzPIp1z2K6UFVTQjvDn1PnatTLxZq2
        6Sn91t9cCzd3AVmnn1HJ08B94zJFwNyZ8cgquGxFP1hhCIzCwZPsriICV41cY1oqnPLtrt7lNQQ
        IVxA5ojrYIAqa
X-Received: by 2002:a5d:4488:: with SMTP id j8mr28281432wrq.242.1592228815045;
        Mon, 15 Jun 2020 06:46:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz08cj7iJ9yvZ/uENIDqMPzdJxASRATbeR9Y8pLU9H+iaXbLfMqZsJsrO1NZQZnvvXuWuEUAw==
X-Received: by 2002:a5d:4488:: with SMTP id j8mr28281411wrq.242.1592228814812;
        Mon, 15 Jun 2020 06:46:54 -0700 (PDT)
Received: from [192.168.178.58] ([151.48.99.33])
        by smtp.gmail.com with ESMTPSA id w3sm24300473wmg.44.2020.06.15.06.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 06:46:54 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
To:     Jim Mattson <jmattson@google.com>, Babu Moger <babu.moger@amd.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
 <159191213022.31436.11150808867377936241.stgit@bmoger-ubuntu>
 <CALMp9eSC-wwP50gtprpakKjPYeZ5LdDSFS6i__csVCJwUKmqjA@mail.gmail.com>
 <d0b09992-eb87-651a-3b97-0787e07cc46d@amd.com>
 <CALMp9eRZQXgJvt3MGreq47ApM5ObTU7YFQV_GcY5N+jozGK1Uw@mail.gmail.com>
 <d0c38022-2d82-aacc-4829-02c557edddc0@amd.com>
 <CALMp9eSn36W=YK5XtaVATJis-J--udGK4ZOESDhYyT0zJ4YZ9A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f5a7fca-02b3-4cd9-159c-59fcda3debd0@redhat.com>
Date:   Mon, 15 Jun 2020 15:46:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSn36W=YK5XtaVATJis-J--udGK4ZOESDhYyT0zJ4YZ9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/06/20 02:04, Jim Mattson wrote:
>> I think I have misunderstood this part. I was not inteding to change the
>> #GP behaviour. I will remove this part. My intension of these series is to
>> handle invpcid in shadow page mode. I have verified that part. Hope I did
>> not miss anything else.
> You don't really have to intercept INVPCID when tdp is in use, right?
> There are certainly plenty of operations for which kvm does not
> properly raise #UD when they aren't enumerated in the guest CPUID.
> 

Indeed; for RDRAND and RDSEED it makes sense to do so because the
instructions may introduce undesirable nondeterminism (or block all the
packages in your core as they have been doing for a few weeks).
Therefore on Intel we trap them and raise #UD; on AMD this is not
possible because RDRAND has no intercept.

In general however we do not try to hard to raise #UD and that is
usually not even possible.

Paolo

