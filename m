Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1904939FDE9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhFHRmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:42:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232376AbhFHRmu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 13:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623174056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uuTEXUh2y4+eVpi9BE2NLF0/TYZeOk1VrPvZH9w4Lo0=;
        b=caqhqDjdM4brGLMnQ8lduf+VnfYCCJ8K7t5auFexx9AD63HP7GeHEQVcj55Hj7OwzhBkdV
        K7Y7W1A+602INe2GntPMzm/eZg1S5bGPpXksnqXuaSqsptZt9le2sU8nrRu6JHcyUF81GN
        1vVAmQtxGT8mYkXfE2YUDyZ5GFJs/yw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-MI4Zwb8INmOvBBF2KMhdlQ-1; Tue, 08 Jun 2021 13:40:55 -0400
X-MC-Unique: MI4Zwb8INmOvBBF2KMhdlQ-1
Received: by mail-wr1-f69.google.com with SMTP id q15-20020adfc50f0000b0290111f48b865cso9721008wrf.4
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 10:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uuTEXUh2y4+eVpi9BE2NLF0/TYZeOk1VrPvZH9w4Lo0=;
        b=t3pWkH1EApApm9HMzJGprwbCd/EB6pgknCqGxTU9Q5KV51aZGTgEMRREOvD+ousNJp
         trgpxF8hVN5cMmiDsi6cx8G5Jh5hmIADzhDvIwdscR5k2tVkH4w4z6JfwX4pKV4MOUmV
         6dZgdcRo3duECwetpt9hT2gwg/1J8TY2Qaw/X9ExXrTdOc1RpNFVWn1VqAmk3lSslLJY
         ox4/h+M7wAP8IlYNkDAr7U6WaiglzUO+xe1lGfaEPdbbfHj1U1tSktlhKAkdU1rfL8Xk
         WjhKO6nlEMMNTPF7VJPtZqqo2VTujl8MEko5mTPWP20ntZRzdsy0FQ1/k9EiSX7/pxiU
         LLbg==
X-Gm-Message-State: AOAM532T2KVjrGbA+7qrZs4sN7ecZR7QuslhPea2JcM7t0ZgJMpJ/0Qs
        2CtyA5B3027dHAkzqO2r6XQdBdmpOzwJua8HQp7lZ93eq2mKZZIWHlgSU5l0P78J2KynX39YFb0
        7N/Yp1ghl9HOk
X-Received: by 2002:a1c:9804:: with SMTP id a4mr23765708wme.34.1623174054279;
        Tue, 08 Jun 2021 10:40:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCg/4Dg2XjHEakG0Gnd75nQyKD/Y6nxzDDphWNa3SRKmaQxg54dFAsRxFHIsqIoOwPd/74gA==
X-Received: by 2002:a1c:9804:: with SMTP id a4mr23765690wme.34.1623174054086;
        Tue, 08 Jun 2021 10:40:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o26sm7824493wms.27.2021.06.08.10.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 10:40:53 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: X86: Let's harden the ipi fastpath condition
 edge-trigger mode
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-3-git-send-email-wanpengli@tencent.com>
 <YL+cX8K3r7EWrk33@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2a643f94-d159-c1ac-6bd2-cc6b45372630@redhat.com>
Date:   Tue, 8 Jun 2021 19:40:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YL+cX8K3r7EWrk33@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/21 18:35, Sean Christopherson wrote:
> Related side topic, anyone happen to know if KVM (and Qemu's) emulation of IPIs
> intentionally follows AMD instead of Intel?  I suspect it's unintentional,
> especially since KVM's initial xAPIC emulation came from Intel.  Not that it's
> likely to matter, but allowing level-triggered IPIs is bizarre, e.g. getting an
> EOI sent to the right I/O APIC at the right time via a level-triggered IPI seems
> extremely convoluted.

QEMU traditionally followed AMD a bit more than Intel for historical 
reasons.  Probably the code went QEMU->Xen->KVM even though it was 
contributed by Intel.

Paolo

