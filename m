Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1328B214
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfHMINA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:13:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36548 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbfHMIM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:12:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so13151946wrt.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 01:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C4MCH+wiKyoHDLRZTqdi1HE4ZG69Yx/Z30XMFS1Md78=;
        b=oGAergk5AHotFlUrxTobYScSw+/F2hDruHMV073tsrHSEdUzVDFilTuBTpj/6wUwrM
         yL3iwJ0diwDLoJAcFO009y3gAgnqVh1mY9fyekpkQ9CbfLtl4pTVCKWSnDxgBO1hajQ7
         EdSGtsfGB9abjglkA2AyQfq/PmFLz486Y2F9MfqQGU7//K6BeJU/82VMUIY4okTNZtve
         uGHPgGOX3dDjWxUQvb0F5nqDvq0nTHk0gBECDLUKGOBdH5gP+AH+LAEmREEb2ISJUC/Z
         x7rtN/HYiYbNxUmqigQy3hBrVZxcrPC9KfxCyquPhprVddGo+el/7Oj2MxhwayK+YHlI
         WXrQ==
X-Gm-Message-State: APjAAAXGaItKSNffVRCbESxDGlYaFVRt3XELLb9mqHSyHu8B3aaVrQph
        wZGY1WCyvCvh3QtrSEB8LiTc2w==
X-Google-Smtp-Source: APXvYqzTGkTsXHr6zZizzD6ULkYclIovnz3N2V8vDYZOluWG0ibcVz+1hwoKcaSTeMWJVha1MYq4yw==
X-Received: by 2002:adf:c613:: with SMTP id n19mr44936601wrg.109.1565683977128;
        Tue, 13 Aug 2019 01:12:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id a8sm826262wma.31.2019.08.13.01.12.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:12:56 -0700 (PDT)
Subject: Re: [RFC PATCH v6 26/92] kvm: x86: add kvm_mmu_nested_pagefault()
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <ncitu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-27-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a35a1d7c-fa36-c4f2-e8e6-7a242789364e@redhat.com>
Date:   Tue, 13 Aug 2019 10:12:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-27-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> +static bool vmx_nested_pagefault(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GVA_TRANSLATED)
> +		return false;
> +	return true;
> +}
> +

This hook is misnamed; it has nothing to do with nested virtualization.
 Rather, it returns true if it the failure happened while translating
the address of a guest page table.

SVM makes the same information available in EXITINFO[33].

Paolo
