Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9773AB01FA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfIKQsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30941 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbfIKQsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:48:13 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C22FB806CD
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 16:48:12 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id n2so10774277wru.9
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BO7lB0teGfLWwRtEdXcpcGWko7IP8lJOAHFsSuKd+pY=;
        b=QJBWVBFQAtewd1RaeWdI4VJzJm0jAgKs3qzzY2iI8i/cibzpbzDb3LWjaJV2k7aQd3
         3fQw5KnTEOYpxhzPR29aRemGpiQELD8o1c6DLaY3rcXx9AgUrqrGx4f/NfqHWyCm/Cyo
         WiNj1qC/2S173JUbLdv4GDYdkeVLoCaoflr5sk11i0UXtZCPFF8mYx3tiR41pAG7rYYH
         mxXQP9WTLar7HKiZ/S/YaYj1qVf/tdkUDsAx/kcf+cpQYS3Q0a0n3G6dDb+OWFTau4Vj
         NymbL7VnlMXXI/heVOM58hmyjcOT+iXdFeeMN8q2RsXaYLoLLNaNSorWGHO7IcqEvqVJ
         9mXA==
X-Gm-Message-State: APjAAAXxFUiBSJG6QghBxK3wgE9YyaG+g0vMzyKvYII0Od3gE1pMwFGw
        +EJkWAlX4YomZALnutldg1gqoryn8PTb6cznhB7ZYUeCZt/VRBszNsOA7gAEDBQserfXBeQLRT5
        cXStOOnKlP7O+
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr4418367wme.22.1568220491499;
        Wed, 11 Sep 2019 09:48:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwuPNmziyKvSmlV8QfI6A3VbJhs/9zPmUtVx47VHpaK4L9iXjYrRUF1jJnV9zBKt0wFtkNGyg==
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr4418353wme.22.1568220491281;
        Wed, 11 Sep 2019 09:48:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id g24sm34062672wrb.35.2019.09.11.09.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:48:10 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <2a36ca45-56fa-5d4e-7b8c-157190f29f82@redhat.com>
 <5253F0DE-D2E3-4475-9B02-092B7A44D776@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e7a7252e-68fe-b396-2801-e740920fd9f6@redhat.com>
Date:   Wed, 11 Sep 2019 18:48:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5253F0DE-D2E3-4475-9B02-092B7A44D776@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/19 18:42, Liran Alon wrote:
> The code change below seems good to me. (The only thing you changed
> is moving is_smm(vcpu) to the non-vendor specific part and rephrased
> comments right?)

Yes.

> I plan to submit a patch for the latched_init changes soon. (And
> respective kvm-unit-test which I already have ready and working).

Very good, thanks.

Paolo
