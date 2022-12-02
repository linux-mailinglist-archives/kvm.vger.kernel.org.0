Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C826405DC
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiLBLdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiLBLdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:33:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296BAD4AC8
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 03:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669980728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8s4VhY093XdBDMnbMQfPOpwKp9HVxoB6Dr2VMSbWUI=;
        b=bqB+YOkiLMmL40HoY5JIFMPp5dwvRqzZWiaqP4rQF3icU3YmD3NeFRTQ/oOFOMa7Fk9Ep8
        JbeKF/m5MJ0HSG1dnTdoKYAORKbdw5zxE7w71XH4g7ZuRrHnxNypwDa4CHUugtm9WhYw4s
        xqY5xM4939q5hbvY1HAncb6UMyLrX6E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-392-q2JDYuhFMqWronxCPmbvsA-1; Fri, 02 Dec 2022 06:32:07 -0500
X-MC-Unique: q2JDYuhFMqWronxCPmbvsA-1
Received: by mail-wr1-f72.google.com with SMTP id d6-20020adfa346000000b0024211c0f988so997603wrb.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 03:32:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k8s4VhY093XdBDMnbMQfPOpwKp9HVxoB6Dr2VMSbWUI=;
        b=wSm9b5oqZRUKf5G2O166Zo9AXjxS+r5uO+C2wSjxjnsJgsGBOIGuBIBeonRraublsI
         aEzR/qJ68beqzMM4bvo8jPxO0gK+R3uktnsLpWRpueUkdEZ62r3H0nvOFTgt7INt012T
         XT9iqFky3fVvO/LMkVixVEpH5l4OwoHgKB1G6fHSzYifpcQoOPnnNPfZzHXnfeCI7TK1
         rvmT8KweFr3lBV4UtxH22p8Tyghl/Ablspr11E8WygwLs/5BfNP8GXAdYFwxtzNZNycg
         rzh2cTZOPF3F18yUc14O64kz2F+kkFV9YABbi+lIW9fV9puxeivKYD83UiVMDk4/mxqW
         vCcQ==
X-Gm-Message-State: ANoB5pnJ/v/JFLAckgSMDd62GtT86jf6K7YmW1HvEdQ02BgnUROudbdc
        XS4Vib7QBUFkDznMC5So2dH4GnOmJmNfCadyaXEOK/A5PFoY0GPz2SMWyQF3YBNPA3Xa/l9A3CW
        76iJSORS+xkv0
X-Received: by 2002:a05:600c:a56:b0:3cf:77a6:2c2e with SMTP id c22-20020a05600c0a5600b003cf77a62c2emr37053650wmq.179.1669980726114;
        Fri, 02 Dec 2022 03:32:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf45L5uBsrIjhSFu1jEb7MQePSkLmPGbSMns9zIQa2dihJ+lL5v8ClPV7+OctGECa1nZA2XpZw==
X-Received: by 2002:a05:600c:a56:b0:3cf:77a6:2c2e with SMTP id c22-20020a05600c0a5600b003cf77a62c2emr37053644wmq.179.1669980725918;
        Fri, 02 Dec 2022 03:32:05 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-86.web.vodafone.de. [109.43.178.86])
        by smtp.gmail.com with ESMTPSA id y7-20020adfe6c7000000b002423edd7e50sm3100067wrm.32.2022.12.02.03.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 03:32:05 -0800 (PST)
Message-ID: <49c289b2-c7d7-7aec-c975-e056cb42927e@redhat.com>
Date:   Fri, 2 Dec 2022 12:32:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related
 functions
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
 <20221201084642.3747014-2-nrb@linux.ibm.com>
 <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
 <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
 <166997789077.186408.11144216448246779334@t14-nrb.local>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <166997789077.186408.11144216448246779334@t14-nrb.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 11.44, Nico Boehr wrote:
> Quoting Thomas Huth (2022-12-02 10:09:03)
>> On 02/12/2022 10.03, Janosch Frank wrote:
>>> On 12/1/22 09:46, Nico Boehr wrote:
>>>> Upcoming changes will add a test which is very similar to the existing
>>>> skey migration test. To reduce code duplication, move the common
>>>> functions to a library which can be re-used by both tests.
>>>>
>>>
>>> NACK
>>>
>>> We're not putting test specific code into the library.
>>
>> Do we need a new file (in the third patch) for the new test at all, or could
>> the new test simply be added to s390x/migration-skey.c instead?
> 
> Mh, not quite. One test wants to change storage keys *before* migrating, the other *while* migrating. Since we can only migrate once, it is not obvious to me how we could do that in one run.
> 
> Speaking of one run, what we could do is add a command line argument which decides which test to run and then call the same test with different arguments in unittests.cfg.

Yes, that's what I had in mind - use a command line argument to select the 
test ... should be OK as long as both variants are listed in unittests.cfg, 
shouldn't it?

  Thomas

