Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A3D8D592
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 16:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfHNOGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 10:06:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51102 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfHNOGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 10:06:11 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so4720933wml.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 07:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n/0MfT9EW0M7U/nklrG8V8Yd0Iltg4541JOgSCkjXGo=;
        b=thuQsysBCfVfpItumEriCTQsi53mWm9hxO3CHz3AJABtleeV8mTDGvgq0AT5IiyX0J
         R0ivWmCTYNyr/IO+9Xbh4/QaN6XE0gg+zcoryYPCaRK/oQtZcaxAKJihwnNapXQgFV1h
         oIDUa+C6vR+QaOXxv7ngiZN4NmbrlFezq/EtiDTxq617mSLKza0odCpgHtq9BDrds0rD
         ETxX7vsTi15AGuDQguwcvE/lmM+lrS1mdCeOJVCskHzkypwUjCSbU/1b9esKvypMDODt
         egzwl20IlXlSr13HJe3dA+flTXzHhCJTmpb8+AmIDPgR99c6HzRB7er7bPfKJX4nSj5t
         Uv5Q==
X-Gm-Message-State: APjAAAVBVf3dBljCAkllYhgZk1Zl+IX1f/Rf3xp0X1qnpgD5kZB+RBBa
        nLtImIRw1Kdydku8xv2QZosA8A==
X-Google-Smtp-Source: APXvYqw1g1qwuCJNGkBsiX37aXDH6JmSJEsTuDmzKjkDGFxI//+egmhqlEn3vwikitpSoO6kzQKyPg==
X-Received: by 2002:a7b:c313:: with SMTP id k19mr8451686wmj.2.1565791568531;
        Wed, 14 Aug 2019 07:06:08 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k1sm17685794wru.49.2019.08.14.07.06.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:06:07 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 0/9] Enable Sub-page Write Protection Support
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com, yu.c.zhang@intel.com,
        alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <5db7a1fc-994f-f95b-5813-ffe1801dbfbc@redhat.com>
 <20190814140212.GA7625@local-michael-cet-test.sh.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <11c4dd6e-2d4f-f989-6fc8-a126550dce72@redhat.com>
Date:   Wed, 14 Aug 2019 16:06:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814140212.GA7625@local-michael-cet-test.sh.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 16:02, Yang Weijiang wrote:
> On Wed, Aug 14, 2019 at 02:36:30PM +0200, Paolo Bonzini wrote:
>> On 14/08/19 09:03, Yang Weijiang wrote:
>>> EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
>>> Virtual Machine Monitor(VMM) to specify write-permission for guest
>>> physical memory at a sub-page(128 byte) granularity. When this
>>> capability is enabled, the CPU enforces write-access check for sub-pages
>>> within a 4KB page.
>>>
>>> The feature is targeted to provide fine-grained memory protection for
>>> usages such as device virtualization, memory check-point and VM
>>> introspection etc.
>>>
>>> SPP is active when the "sub-page write protection" (bit 23) is 1 in
>>> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
>>> Permission Table(SPPT), SPPT is referenced via a 64-bit control field
>>> called Sub-Page Permission Table Pointer (SPPTP) which contains a
>>> 4K-aligned physical address.
>>>
>>> Right now, only 4KB physical pages are supported for SPP. To enable SPP
>>> for certain physical page, we need to first make the physical page
>>> write-protected, then set bit 61 of the corresponding EPT leaf entry. 
>>> While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
>>> physical address to find out the sub-page permissions at the leaf entry.
>>> If the corresponding bit is set, write to sub-page is permitted,
>>> otherwise, SPP induced EPT violation is generated.
>>
>> Still no testcases?
>>
>> Paolo
> 
> Hi, Paolo,
> The testcases are included in selftest: https://lkml.org/lkml/2019/6/18/1197
> 

Good, thanks!

Paolo
