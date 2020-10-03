Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF892822FC
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCJRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:17:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJCJRy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 05:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601716673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1fzLg32yIxL4nuBAaxGzjjdUPzlfMH4ds5vNoj1mFCc=;
        b=hb1s5csj9gsNyJiw2t9w5ZvXXWJ0k9qsmsXSgkGeSeq27Q/fIAF+sNzIwFO/T6jCvsWSo1
        108zJMg29UejnlOqfslh6hmpR0CmAikXNYzpEjOGysqA2cU3xLBpf4K9h7M1F58EFSa9bD
        urZq4CZDc0Me1hALf4nhDUz6uRy9e84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-XzWEcPFZMJi_MD1bMolAxw-1; Sat, 03 Oct 2020 05:17:50 -0400
X-MC-Unique: XzWEcPFZMJi_MD1bMolAxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB50C1868410;
        Sat,  3 Oct 2020 09:17:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-61.ams2.redhat.com [10.36.112.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3385510013C4;
        Sat,  3 Oct 2020 09:17:45 +0000 (UTC)
Subject: Re: [PATCH v4 04/12] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-5-philmd@redhat.com>
 <971287b0-fd62-21bb-e80e-8b83c8a5c459@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4488d878-09ff-5ea6-bc4b-69dda534131e@redhat.com>
Date:   Sat, 3 Oct 2020 11:17:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <971287b0-fd62-21bb-e80e-8b83c8a5c459@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/2020 10.03, Philippe Mathieu-Daudé wrote:
> On 9/30/20 12:43 AM, Philippe Mathieu-Daudé wrote:
>> KVM requires a cpu based on (at least) the ARMv7 architecture.
>>
>> Only enable the following ARMv4 CPUs when TCG is available:
>>
>>    - StrongARM (SA1100/1110)
>>    - OMAP1510 (TI925T)
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   hw/arm/Kconfig | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
>> index 7d040827af..b546b20654 100644
>> --- a/hw/arm/Kconfig
>> +++ b/hw/arm/Kconfig
>> @@ -1,3 +1,7 @@
>> +config ARM_V4
>> +    bool
>> +    select TCG
> 
> This should be 'depends on TCG' because we can not
> *select* TCG, either we enabled it or not.
> 
> The problem is the machines are already selected in
> default-configs/arm-softmmu.mak, so we can not build
> the current config without TCG.

Is it really a problem? If the users disabled TCG and still have these 
machines in their arm-softmmu.mak, it's a configuration issue on their side, 
so it's ok if they get an error in that case.

  Thomas

