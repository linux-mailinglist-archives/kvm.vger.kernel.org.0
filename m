Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2B7D7C99
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 07:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbjJZFzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 01:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjJZFzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 01:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64852137
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698299703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cjg6DeVHVHA93PGNMB0fOahjVGtCb1cn+p/l3CnIPTk=;
        b=BPdD29I4/53IG6WPmyYPnClukfFB/E5MvSq55neTTuXk3uKJXT7tWb5FACjSM/75aG3R6O
        r9iZufqaTn21tC85xOUBYa8BMykCh03IFIicz7tCLzp/BLh8qDZZ6ic3kZBbHTOhhBCh4q
        iHSHletEAPuPhMOTAdnpinze5iZsy2g=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-8vdqlEEEPa6L-ocpP4bMoQ-1; Thu, 26 Oct 2023 01:55:00 -0400
X-MC-Unique: 8vdqlEEEPa6L-ocpP4bMoQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-694d7f694a4so164244b3a.0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698299699; x=1698904499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cjg6DeVHVHA93PGNMB0fOahjVGtCb1cn+p/l3CnIPTk=;
        b=eqKPgSWYG+A//rXkDRE9Qe6LXYy0IcD0lLa+Gvx7EZvoIxH2RA7Plk9cMlO7hkwuEh
         YPVuVqPqt5KBNyXQp4qt9EO2vtobpi5dY8Vb6gBzmw8cFp887D/ZFcVRkeTceGEoAQsE
         JKutSsWTpj/hJIvpvMYzu/F0RgREPRdP5exEwFvh4Gwx9Xj4+1DXjsxC6o41Z83nzBpi
         0/O6C142mAlXpvWWCCtkK+PWiKYXF2W68agpW9R1eu6B2YLu8gCvFbiV4mhJ9DR3bxPS
         gsQ6r9p7B4Yu0BotyawWc187a3Z6T9HtgxhLkvIPH1S8GpMHD1UbDmSkoXnK8jdH60qY
         mPsA==
X-Gm-Message-State: AOJu0YyJb2oar+p82Z/S5dYSquVQ7EZBwp3A3rG+LiXlxGHuv2sCObYd
        2tnDO7v18JnA6QLf2OCw3M0E7lQpn7vIYMU+2gjSu09UHhybgW54tkhNPaCtE3TzDU0zlACC2bX
        mHlcrG3OpAh89
X-Received: by 2002:a05:6a20:c188:b0:15a:2c0b:6c81 with SMTP id bg8-20020a056a20c18800b0015a2c0b6c81mr20697456pzb.3.1698299699294;
        Wed, 25 Oct 2023 22:54:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZIE9oSBGnpBc+/dOEbUzvR6MHa5tqGFrzsXG6ZL6CNPU7Mv41W8vbMDxYflPpTKr3D98sTg==
X-Received: by 2002:a05:6a20:c188:b0:15a:2c0b:6c81 with SMTP id bg8-20020a056a20c18800b0015a2c0b6c81mr20697446pzb.3.1698299698974;
        Wed, 25 Oct 2023 22:54:58 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iy10-20020a170903130a00b001c613091aeesm10171465plb.293.2023.10.25.22.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 22:54:58 -0700 (PDT)
Message-ID: <9052ed87-e5cf-4d89-b480-54da4d8216c7@redhat.com>
Date:   Thu, 26 Oct 2023 13:54:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1] configure: arm64: Add support for
 dirty-ring in migration
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, andrew.jones@linux.dev,
        kvmarm@lists.linux.dev
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
References: <20231026034042.812006-1-shahuang@redhat.com>
 <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/26/23 13:12, Thomas Huth wrote:
> On 26/10/2023 05.40, Shaoqin Huang wrote:
>> Add a new configure option "--dirty-ring-size" to support dirty-ring
>> migration on arm64. By default, the dirty-ring is disabled, we can
>> enable it by:
>>
>>    # ./configure --dirty-ring-size=65536
>>
>> This will generate one more entry in config.mak, it will look like:
>>
>>    # cat config.mak
>>      :
>>    ACCEL=kvm,dirty-ring-size=65536
>>
>> With this configure option, user can easy enable dirty-ring and specify
>> dirty-ring-size to test the dirty-ring in migration.
> 
> Do we really need a separate configure switch for this? If it is just 
> about setting a value in the ACCEL variable, you can also run the tests 
> like this:
> 
> ACCEL=kvm,dirty-ring-size=65536 ./run_tests.sh
> 
>   Thomas
> 

Hi Thomas,

You're right. We can do it by simply set the ACCEL when execute 
./run_tests.sh. I think maybe add a configure can make auto test to set 
the dirty-ring easier? but I'm not 100% sure it will benefit to them.

Thanks,
Shaoqin

-- 
Shaoqin

