Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10C783CEC
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 11:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbjHVJ3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 05:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbjHVJ3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 05:29:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219991AE
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 02:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692696543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqnDBASgyX3R6KiAeimX4VrNNDbZWNbzKzT6G53Cfzs=;
        b=QdKxxCauW6LXTBrcngW+MxdyXqTDpSmDzODo00WvPyEKGBYxur7+1ppHGnkarVdHpiVc0F
        AyJ5S1JW9iVlTe9OofRmbDrOsTRhkRi3uOFwrn6kCVyPAZEPQ2shdrujofXKfcEIlcakJ2
        ZacQPWnw/uT9UEWsCGeo9PbpGAgbMD8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-DLM_6Qs-OaGfJGokMCT8ng-1; Tue, 22 Aug 2023 05:29:01 -0400
X-MC-Unique: DLM_6Qs-OaGfJGokMCT8ng-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30e3ee8a42eso2530941f8f.1
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 02:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692696540; x=1693301340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqnDBASgyX3R6KiAeimX4VrNNDbZWNbzKzT6G53Cfzs=;
        b=LQpIxGRfQ5vk2t6mfxB8lFn17/ZoRADVKkWk1P+z5niICWIG9kzFpXUOL2+uSX8vGF
         +JOuPSaA2h2WFtstrqAYJtBY1cKn5YUe3fa3nVNxhDGpA78vtf7pGEascPAUmdOJFLYa
         +AoAkhF+0PuwLlN8H61WlgpvJ0GBqQY1Nz317uLYtujxKBpI8PCBFothHHt6xeclb2Tq
         e3gh0N64cdhKJ1ymu/Nhth14DLY+NPC2ZEldTnS747D7tNclwut13FfQT3nTu4sqhMy1
         FH6TYrakPimn6CRw8dSesZgdUuihBOhD9amMrha45dL4G/TVyD4DUE+j/Hc0Rz2Chuvd
         KDzg==
X-Gm-Message-State: AOJu0Yyy8buYIIGaxci2qYAsQD4eS4+qv5JvAG4SNNi/eP6rVhiodkFp
        nJWUft/rPm2TzqFMzi+NXcuHc5/AbClCiX5Ox7XGVLfTdg1re+Z7F3DViJo+CaFcCF7Rmk9jBac
        HOTX1C0buRHAyua/dApM3qvE=
X-Received: by 2002:adf:f84c:0:b0:313:f399:6cea with SMTP id d12-20020adff84c000000b00313f3996ceamr6476835wrq.4.1692696540697;
        Tue, 22 Aug 2023 02:29:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGkmwXD28aS3Qpjnasusg2nMKdStET6h2PIPl6DJhX+Q0f63zjz4Q83Iaoi6PV31KvSkqndQ==
X-Received: by 2002:adf:f84c:0:b0:313:f399:6cea with SMTP id d12-20020adff84c000000b00313f3996ceamr6476820wrq.4.1692696540265;
        Tue, 22 Aug 2023 02:29:00 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-178-6.web.vodafone.de. [109.43.178.6])
        by smtp.gmail.com with ESMTPSA id f8-20020adfdb48000000b0031934b035d2sm15387374wrj.52.2023.08.22.02.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 02:28:59 -0700 (PDT)
Message-ID: <e1f51d97-26a9-5991-06ea-8f587b4d62e8@redhat.com>
Date:   Tue, 22 Aug 2023 11:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH] Makefile: Move -no-pie from CFLAGS into
 LDFLAGS
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230822074906.7205-1-thuth@redhat.com>
 <79f8ebd0-e4d0-5e28-f014-5ae0c1f2ec41@linux.ibm.com>
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <79f8ebd0-e4d0-5e28-f014-5ae0c1f2ec41@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2023 10.37, Janosch Frank wrote:
> On 8/22/23 09:49, Thomas Huth wrote:
>> "-no-pie" is an option for linking, not for compiling, so we must put
>> this into the lDFLAGS, not into CFLAGS. Without this change, the linking
>> currently fails on Ubuntu 22.04 when compiling on a s390x host.
>>
>> Reported-by: Janosch Frank <frankja@linux.ibm.com>
>> Fixes: e489c25e ("Rework the common LDFLAGS to become more useful again")
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> Just tested it on my system, this fixes the compile problem.

Great, thanks for checking, so I pushed it now to the repo.

  Thomas

