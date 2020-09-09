Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F204A2636C4
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 21:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIIToY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 15:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIIToX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 15:44:23 -0400
Received: from forward101j.mail.yandex.net (forward101j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDFAC061573
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 12:44:22 -0700 (PDT)
Received: from mxback3j.mail.yandex.net (mxback3j.mail.yandex.net [IPv6:2a02:6b8:0:1619::10c])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id 7875C1BE2CFC;
        Wed,  9 Sep 2020 22:44:18 +0300 (MSK)
Received: from sas2-e7f6fb703652.qloud-c.yandex.net (sas2-e7f6fb703652.qloud-c.yandex.net [2a02:6b8:c14:4fa6:0:640:e7f6:fb70])
        by mxback3j.mail.yandex.net (mxback/Yandex) with ESMTP id xZZNAloQOt-iIGKoKkd;
        Wed, 09 Sep 2020 22:44:18 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1599680658;
        bh=KZbIi5WWp+2ki2+2jmzckVbqkcW29omHRUmKorrVMgQ=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=ViRwA5c00S8CyzmxevDTpw+wvOtqR1khQ+P7ECTWB9ASjaVbqH+bCOPSmKRrNkC6+
         Gmeq7TDf+xVh0PySWLi7XhQGViw12PMxay6absXPU7q7zGVUyS29tSRB7BVfMtlkTb
         K8uIKjYpmFFIksExtYCPPEOXOyBClJu8Hl8H+tMQ=
Authentication-Results: mxback3j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas2-e7f6fb703652.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id fcVSDzuE8j-iHIKtCrL;
        Wed, 09 Sep 2020 22:44:17 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: KVM_SET_SREGS & cr4.VMXE problems
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
References: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
 <20200909163023.GA11727@sjchrist-ice>
 <fdeb1ecb-abee-2197-4449-88d33480c5fe@yandex.ru>
 <4b019c3e-e880-1409-c907-0dc2a3742813@yandex.ru>
 <20200909191748.GA11909@sjchrist-ice>
From:   stsp <stsp2@yandex.ru>
Message-ID: <ecab2111-1980-bf94-b339-4892224cb8c9@yandex.ru>
Date:   Wed, 9 Sep 2020 22:44:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200909191748.GA11909@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

09.09.2020 22:17, Sean Christopherson пишет:
> On Wed, Sep 09, 2020 at 09:37:08PM +0300, stsp wrote:
>> A bit of update.
>>
>> 09.09.2020 21:04, stsp пишет:
>>> As for the original problem: there are at least
>>> 2 problems.
>>>
>>> On OLD intel:
>>> - KVM fails with invalid guest state unless
>>> you set VMXE in guest's cr4, and do it from
>>> the very first attempt!
>> This happens only on nested execution!
>> Under qemu/kvm.
> Ah, that makes a lot more sense.  So is QEMU+KVM your L0, and dosemu2 is
> L1, and the DOS guest is L2?  And assuming that's the case, you observe
> the weird behavior in L1, i.e. when doing KVM_SET_SREGS from dosemu2?

Argh, not that simple! :)
Only one of the problems, namely,
"invalid guest state" w/o VMXE, is
specific to the nested exec. And
also to an OLD Intel CPU.

All other problems I described, are
reproducible anywhere: on any CPU
(including AMD FX CPU), and w/o any
nesting.
So there are really 2 or 3 very
different problems here, really.

The problems below are generic:
- VMXE kills VME in CR4 on any CPU
- VMXE can only be set on the very
first call to KVM_SET_SREGS on any CPU.

The problem below is nested+Intel-specific:
- invalid guest state if L2 has no VMXE.

