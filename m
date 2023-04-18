Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA0F6E5E69
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjDRKQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDRKQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:16:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BB43580
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681812940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzOfbIO5bOqjfu9Ib99/kh3hbnxQwZKu2ebFntng39Q=;
        b=R7PysgfvuBsQhkqKeJLZGpdkyiRZaXT9Srxbuu4QxHBUGRPS9rVZVXLTGdhA8+akennPQW
        lNbW6C5lEhoom4Io+Sz4nTfY2lbbRTmYXITf55BaA3aFqrjDHgHxcWPc5gkRTQ/NNkPWED
        +ZESt65O7lGNi6ld02ZQMle7aNFez3s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-tAdCrEaWNHK4L4jA5Iud7Q-1; Tue, 18 Apr 2023 06:15:39 -0400
X-MC-Unique: tAdCrEaWNHK4L4jA5Iud7Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2f831f6e175so1102775f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681812938; x=1684404938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzOfbIO5bOqjfu9Ib99/kh3hbnxQwZKu2ebFntng39Q=;
        b=akJLaEsLI2J2ngq3Kkrg2jTuW3raZF+/Sjy1BBjyPlmvQ218AqI0/eVMlq23HLiVIE
         AcVL7+IfZI0yI0WkzSVpUAQHLkvbnOpci1Oms/JUgrn0ASxYwZe6lUYcV+xWtcmdBm7u
         0WSom0vMSvCGRwVd0ZlN5kd353FwrRKsLF7YFIYAIe0KWd98ZLNNp1HnGORFTQhprO+2
         NEe1+YPWHbJ8nhEagq6tc2YFuJevxEKX/UHow33DSU/iUPxhKHGAhQe0hcVcA9iRdlDK
         HSYYyIXC9havFj8e9oj3Hk40Go4N072qs5hRleDvqlk8t69rmwi0pLekOAgECqYGcJ69
         nzQw==
X-Gm-Message-State: AAQBX9chxdCzEoqwW7A/8L3pdFlYbKORmx+mEgbt9S02dtDQ7Lal0Sqs
        kwgDvE1rp80/W5yFHDmOitMVO4tZD9vfUkyEEQLi1xgKlEKMcvBQRYFOkQAHlhU2MUume6TEVYs
        u06+lka+sxA7X
X-Received: by 2002:adf:eb91:0:b0:2fc:b3be:7436 with SMTP id t17-20020adfeb91000000b002fcb3be7436mr1443470wrn.25.1681812938550;
        Tue, 18 Apr 2023 03:15:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZJEyY6xoKQeFhLWcqB9Jp1d7Fo8Yyu1vap0e108ePZWOzD5VVWtvbm8h8dxiw3fa78qvUVlw==
X-Received: by 2002:adf:eb91:0:b0:2fc:b3be:7436 with SMTP id t17-20020adfeb91000000b002fcb3be7436mr1443445wrn.25.1681812938278;
        Tue, 18 Apr 2023 03:15:38 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-59.web.vodafone.de. [109.43.176.59])
        by smtp.gmail.com with ESMTPSA id d2-20020adffbc2000000b002fddcb73162sm909475wrs.71.2023.04.18.03.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 03:15:37 -0700 (PDT)
Message-ID: <80fce082-b468-2c9b-b370-a9de349d0860@redhat.com>
Date:   Tue, 18 Apr 2023 12:15:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
 <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/2023 12.01, Pierre Morel wrote:
> 
> On 4/18/23 10:53, Nina Schoetterl-Glausch wrote:
>> On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
>>> S390 adds two new SMP levels, drawers and books to the CPU
>>> topology.
>>> The S390 CPU have specific topology features like dedication
>>> and entitlement to give to the guest indications on the host
>>> vCPUs scheduling and help the guest take the best decisions
>>> on the scheduling of threads on the vCPUs.
>>>
>>> Let us provide the SMP properties with books and drawers levels
>>> and S390 CPU with dedication and entitlement,
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>   MAINTAINERS                     |  5 ++++
>>>   qapi/machine-common.json        | 22 ++++++++++++++
>>>   qapi/machine-target.json        | 12 ++++++++
>>>   qapi/machine.json               | 17 +++++++++--
>>>   include/hw/boards.h             | 10 ++++++-
>>>   include/hw/s390x/cpu-topology.h | 15 ++++++++++
>> Is hw/s390x the right path for cpu-topology?
>> I haven't understood the difference between hw/s390x and target/s390x
>> but target/s390x feels more correct, I could be mistaken though.
> 
> AFAIK target/s390 is for CPU emulation code while hw/s390 is for other 
> emulation.
> 
> So it depends how we classify the CPU topology, it is related to CPU but it 
> is no emulation.

Normally I'd say target/ is for everything what happens within a CPU chip, 
and hw/ is for everything that happens outside of a CPU chip, i.e. machine 
definitions and other devices.
Now CPU topology is borderline - drawers and books are rather a concept of 
the machine and not of the CPU, but things like dies and threads rather 
happen within a CPU chip.
So I don't mind too much either way, but I think it's certainly ok to keep 
it in hw/s390x/ if you prefer that.

  Thomas

