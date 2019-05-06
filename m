Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5AC147C8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 11:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfEFJuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 05:50:14 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:55888 "EHLO
        6.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfEFJuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 05:50:14 -0400
Received: from player763.ha.ovh.net (unknown [10.108.42.88])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 3EEC416E092
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 11:50:12 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player763.ha.ovh.net (Postfix) with ESMTPSA id CAF4E5725A26;
        Mon,  6 May 2019 09:50:03 +0000 (UTC)
Subject: Re: KVM: Introduce a 'release' method for KVM devices
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Colin Ian King <colin.king@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5a34a77e-d1bf-c630-ef9b-4f94c2c0c221@canonical.com>
 <2e7890d2-e433-8553-c466-5b42f7d7776e@ozlabs.ru>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <457f6636-35da-1cb6-4763-2d717bcc421e@kaod.org>
Date:   Mon, 6 May 2019 11:50:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2e7890d2-e433-8553-c466-5b42f7d7776e@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 239816684356733719
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrjeejgddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/19 4:35 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 02/05/2019 00:42, Colin Ian King wrote:
>> Hi,
>>
>> Static analysis with Coverity picked up an issue in the following commit:
>>
>> commit 2bde9b3ec8bdf60788e9e2ce8c07a2f8d6003dbd
>> Author: Cédric Le Goater <clg@kaod.org>
>> Date:   Thu Apr 18 12:39:41 2019 +0200
>>
>>     KVM: Introduce a 'release' method for KVM devices
>>
>>
>>         struct kvm *kvm = dev->kvm;
>>
>> +       if (!dev)
>> +               return -ENODEV;
>>
>> If dev is null then the dereference of dev->kvm when assigning pointer
>> kvm will cause an null pointer dereference.  This is easily fixed by
>> assigning kvm after the dev null check.
> 
> Yes, this is a bug.

Clearly.

>>
>> +
>> +       if (dev->kvm != kvm)
>> +               return -EPERM;
>>
>> I don't understand the logic of the above check. kvm is the same
>> dev->kvm on the earlier assignment, so dev->kvm != kvm seems to be
>> always false, so this check seems to be redundant. Am I missing
>> something more fundamental here?
> 
> Nope. This looks like unfortunate cut-n-paste which slipped through out
> reviewing process :-D

Yes. My bad :/ I will send a cleanup patch for 5.2

Thanks,

C.
 

