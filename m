Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2837665D325
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbjADMxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjADMxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:53:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C131CFD4
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 04:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672836748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYNFz5lG+kYDjGi1E/lq+t0kEFtTg5TPdF1+zm/FY3g=;
        b=PPbSJo3vGkZSJAdxZKw9OR/N1O7iyyZ5L4qxHU2XWooUql9hLwteZ8OHip0uM0rdRcZW4Z
        kxT25LrD//ws7xRocooxPsD96TuZCfd4ouBm6Fa0Mp4uu3yQ8JqRvrRcYBGYUoPr54QK61
        ySZqb9JJ3JixipBV3nbH/Bi0sCRJpd0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-snnx3LHpPwC7QCOjD14YVg-1; Wed, 04 Jan 2023 07:52:24 -0500
X-MC-Unique: snnx3LHpPwC7QCOjD14YVg-1
Received: by mail-wr1-f69.google.com with SMTP id j27-20020adfa55b000000b0027f710a6ceeso2887476wrb.14
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 04:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYNFz5lG+kYDjGi1E/lq+t0kEFtTg5TPdF1+zm/FY3g=;
        b=1FScI+NuPKIB3Bei4M/RVQhO9ri0SUoNmAHqW3A7CodLXMFdKI3pzmSYfuMussdTgL
         ReNJzBZBEjteTZqdoIuquzOUaOGoTJVy+WL27IiMGuqWc4cECxBfVpFb252JSTCAqM+6
         AIVuGHM+D7N+Q6DH5ob+WW+N+hpm1ZkEEsFHojqko43k92F/DTduKtKgsoMiIZA15f71
         yCg+HCtAUvwWe8ouJ4xVzie/S0dab2E3GPNKXMUc5DMPN6r55eRPlSrIkOuBy6XZpX8j
         TIlaBPYqVG74tHXvhWE8VzFxIIMcDS/yHjJHdNhq7YxfUEKWjzfxO/dKbALwif1HdEiX
         ccwQ==
X-Gm-Message-State: AFqh2kqPZUxiLv3ptUgpMX3bTUUKLbeb/rJu+sYm8fUQqsq/+FpFqWa6
        oy0TVjISm/3YIKiXgQaJNCbaR4WWgglv4ilA14cQC+CWfAdV80Q0atiFAOvOkw7um+VIhQ2GSh5
        bHFbyaEk/FroU
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr34898433wmr.33.1672836743813;
        Wed, 04 Jan 2023 04:52:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsI7BDbIk3e7TMKs7dv63p7QHZP75PdOoxwwUHaKAG0OMucGN1C88ByYC3U5p2YO/eu8WZU0A==
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr34898420wmr.33.1672836743592;
        Wed, 04 Jan 2023 04:52:23 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-239.web.vodafone.de. [109.43.176.239])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c35c900b003d6b71c0c92sm68908045wmq.45.2023.01.04.04.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:52:22 -0800 (PST)
Message-ID: <af8e6828-6342-17d0-858f-20de5ef6e1a6@redhat.com>
Date:   Wed, 4 Jan 2023 13:52:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
 <20221226183634.7qr7f4otucfzat5g@orel>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221226183634.7qr7f4otucfzat5g@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/12/2022 19.36, Andrew Jones wrote:
> On Tue, Dec 20, 2022 at 06:55:08PM +0100, Claudio Imbrenda wrote:
>> A recent patch broke make standalone. The function find_word is not
>> available when running make standalone, replace it with a simple grep.
>>
>> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   scripts/s390x/func.bash | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
>> index 2a941bbb..6c75e89a 100644
>> --- a/scripts/s390x/func.bash
>> +++ b/scripts/s390x/func.bash
>> @@ -21,7 +21,7 @@ function arch_cmd_s390x()
>>   	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>>   
>>   	# run PV test case
>> -	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
>> +	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
> 
> What about the '-F' that find_word has?

"migration" is only one string without regular expressions in it, so I 
assume the -F does not matter here, does it?

  Thomas

