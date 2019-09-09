Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9400ADDD1
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfIIRK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 13:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfIIRKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 13:10:25 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AEFC93DFCD
        for <kvm@vger.kernel.org>; Mon,  9 Sep 2019 17:10:25 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id x1so7666251wrn.11
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 10:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vktWNuZwbJFGpFqKeMcs/0LdSEYrwQogjSjWjrJcDWk=;
        b=lvgDJwONOWneaqQm+olim/iNHX9mX+o+e5Ye90ufItpuxKP+0t3UuAHhx0RVUA/3BB
         Beo64jFMq0VPOEHhFvUHzmzK6R6pLW+pKnonDAOS4rWJIBJmgAgCB+zjDf1V/ec8PLyh
         nJdpOjIlhkedZK5tuScO0i723OtN+fmlmB9ghZIo6++UpkddRDgBHSdxXVgipUUUD45Z
         yUQX5BvFGg0ho7JLmMMG2sR8+RqJxZyaq75vimcN94TlMdXzu40bjrB6fbmWV45KuPXM
         Oj2uMwR1zCsNCTnFzUysdbm3biKMOVCwnGjiLETZ1zR9dVVPsFDPWhUjyhOPDnaAWYDv
         XIKQ==
X-Gm-Message-State: APjAAAUdcn4Cb4WecLsyvHw7ze+R4E5kHB2M5SnnG9yT0SO6as8Yocc2
        dOPRgWWfISoAFpy2Gz5CKVnKHzoKwZkBBU+9Uc4QOWrF4NXlksNWeAerovyaDdoov90D0f1ffu/
        LMfqnN3QT0jZt
X-Received: by 2002:a5d:6703:: with SMTP id o3mr19299891wru.335.1568049024382;
        Mon, 09 Sep 2019 10:10:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz1n8Q55r7pA74Rbm16weqpXyq4cX1HxgIYP07KC/z/TIvITLwn+XU8NsN4rLzMHK0+7mHPAA==
X-Received: by 2002:a5d:6703:: with SMTP id o3mr19299855wru.335.1568049024123;
        Mon, 09 Sep 2019 10:10:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4580:a289:2f55:eec1? ([2001:b07:6468:f312:4580:a289:2f55:eec1])
        by smtp.gmail.com with ESMTPSA id g73sm292338wme.10.2019.09.09.10.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2019 10:10:23 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 8/9] KVM: MMU: Enable Lazy mode SPPT setup
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com, yu.c.zhang@intel.com,
        alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-9-weijiang.yang@intel.com>
 <63f8952b-2497-16ec-ff55-1da017c50a8c@redhat.com>
 <20190820131214.GD4828@local-michael-cet-test.sh.intel.com>
 <20190904134925.GA25149@local-michael-cet-test.sh.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6cdea038-8d6f-6d75-47b2-bb23ff1c9f15@redhat.com>
Date:   Mon, 9 Sep 2019 19:10:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904134925.GA25149@local-michael-cet-test.sh.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/19 15:49, Yang Weijiang wrote:
>>> This would not enable SPP if the guest is backed by huge pages.
>>> Instead, either the PT_PAGE_TABLE_LEVEL level must be forced for all
>>> pages covered by SPP ranges, or (better) kvm_enable_spp_protection must
>>> be able to cover multiple pages at once.
>>>
>>> Paolo
>> OK, I'll figure out how to make it, thanks!
> Hi, Paolo,
> Regarding this change, I have some concerns, splitting EPT huge page
> entries(e.g., 1GB page)will take long time compared with normal EPT page
> fault processing, especially for multiple vcpus/pages,so the in-flight time increases,
> but HW walks EPT for translations in the meantime, would it bring any side effect? 
> or there's a way to mitigate it?

Sub-page permissions are only defined on EPT PTEs, not on large pages.
Therefore, in order to allow subpage permissions the EPT page tables
must already be split.

Paolo
