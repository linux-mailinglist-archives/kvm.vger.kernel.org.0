Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CD16497A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSQIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 11:08:01 -0500
Received: from goliath.siemens.de ([192.35.17.28]:36234 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgBSQIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 11:08:01 -0500
X-Greylist: delayed 1242 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2020 11:08:00 EST
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 01JFkkEi023113
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 16:46:46 +0100
Received: from [139.25.68.37] ([139.25.68.37])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 01JFkgTh026670;
        Wed, 19 Feb 2020 16:46:42 +0100
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm list <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Anders Berg <anders.berg@lsi.com>,
        jailhouse-dev@googlegroups.com, jean-philippe.brucker@arm.com
References: <20200210141324.21090-1-maz@kernel.org>
 <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <ea7bc1d0-0a11-8ed6-da70-d603d8107bf6@siemens.com>
Date:   Wed, 19 Feb 2020 16:46:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.02.20 16:09, Arnd Bergmann wrote:
> On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
>>
>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>> life so far. It mostly works if you're prepared to deal with its
>> limitations, it has been a good prototype for the arm64 version,
>> but it suffers a few problems:
>>
>> - It is incomplete (no debug support, no PMU)
>> - It hasn't followed any of the architectural evolutions
>> - It has zero users (I don't count myself here)
>> - It is more and more getting in the way of new arm64 developments
>>
>> So here it is: unless someone screams and shows that they rely on
>> KVM/arm to be maintained upsteam, I'll remove 32bit host support
>> form the tree. One of the reasons that makes me confident nobody is
>> using it is that I never receive *any* bug report. Yes, it is perfect.
>> But if you depend on KVM/arm being available in mainline, please shout.
>>
>> To reiterate: 32bit guest support for arm64 stays, of course. Only
>> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
>> arm64, and cleanup all the now unnecessary abstractions.
>>
>> The patches have been generated with the -D option to avoid spamming
>> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
>> my kernel.org repository.
> 
> Just one more thought before it's gone: is there any shared code
> (header files?) that is used by the jailhouse hypervisor?
> 
> If there is, are there any plans to merge that into the mainline kernel
> for arm32 in the near future?
> 
> I'm guessing the answer to at least one of those questions is 'no', so
> we don't need to worry about it, but it seems better to ask.

Good that you mention it: There is one thing we share on ARM (and 
ARM64), and that is the hypervisor enabling stub, to install our own 
vectors. If that was to be removed as well, we would have to patch it 
back downstream. So far, we only carry few EXPORT_SYMBOL patches for 
essential enabling.

That said, I was also starting to think about how long we will continue 
to support Jailhouse on 32-bit ARM. We currently have no supported SoC 
there that comes with an SMMU, and I doubt to see one still showing up. 
So, Jailhouse on ARM is really just a testing/demo case, maybe useful 
(but I didn't get concrete feedback) for cleaner collaborative AMP for 
real-time purposes, without security concerns. I assume 32-bit ARM will 
never be part of what would be proposed of Jailhouse for upstream.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
