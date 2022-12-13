Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D5F64B9A5
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 17:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiLMQ1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 11:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbiLMQ1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 11:27:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D09B236
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670948809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwsK9UOCWwUcP7koLbB3FVoDbhA7pYtpF1ZVddB4pb8=;
        b=VdSTmS8Lknj7RhL2CTTsIkH6TrFzfIQ3sQo2tTXgUeIe19xC7Q+1yoeJHz/vOiAuuPdonn
        ZgxxhVBUYvczv2QwDnw4hMfSVCuGqWfuCI6DLVdNMU0xdgU3/EVABqj9ZDomI4TnVRaWQI
        iYHFIPS4EB2fh5DCl9ZcMNzHem7aiDw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-4tVII9tjNTOb8ZJ4UR2GVQ-1; Tue, 13 Dec 2022 11:26:48 -0500
X-MC-Unique: 4tVII9tjNTOb8ZJ4UR2GVQ-1
Received: by mail-wm1-f69.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso5057173wmb.4
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:26:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwsK9UOCWwUcP7koLbB3FVoDbhA7pYtpF1ZVddB4pb8=;
        b=0RoGKa4teMWGp3RTv3kKDmHX2CbkQOupdSkUGrmY4r+RT7pcEeacDvKG4gJ0bIUEYQ
         KzkVRe91G+kDcJr00EoMmTK/eSPAjy5vwtZ2nfos7rjW41Lcru5WokgnyHfNjVFnaHjV
         0+UIyhViM3E7yT/LaO0oh5Nblr2Cp9a3csL9Q0P1y2Snz62+T9S6q1XS2FWDp2DcOh3/
         XZ/6SX6cVJsusV5ZayANg/sW4r6k/mzM8idzUA3yhXNRSXZ6234rlqCUIaj1v7xbYu0S
         cIFP7baB6I+hw7Hu3eZvlypLD5DZUlphw1VKHFeR+cmouS4KAnX5aQdejV5MORMCDxfT
         aH0Q==
X-Gm-Message-State: ANoB5pnGULmZBkvTBVmrAvKvMGUtT6u/i52+KC4jzsKBt1UqeOpSuGxO
        XWlwXSTtiDCWlzKlHEKVhOfHTE7BOKrFyuAQfZa+F3SrwmiM7IDpXY40VqTvOQpDFwzOhjSAtL7
        uIli6h5Dk4o7Z
X-Received: by 2002:a1c:541c:0:b0:3d1:e1f4:21d1 with SMTP id i28-20020a1c541c000000b003d1e1f421d1mr19911880wmb.26.1670948807245;
        Tue, 13 Dec 2022 08:26:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4rxr0nzytbDv/0CYFxAJvV2YnMacE1MJ9TUkIoHHD5hervWTa4KGxn0w9I/0NAKiTpVYbqbA==
X-Received: by 2002:a1c:541c:0:b0:3d1:e1f4:21d1 with SMTP id i28-20020a1c541c000000b003d1e1f421d1mr19911861wmb.26.1670948807064;
        Tue, 13 Dec 2022 08:26:47 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-131.web.vodafone.de. [109.43.178.131])
        by smtp.gmail.com with ESMTPSA id q3-20020a1c4303000000b003cfa81e2eb4sm13067262wma.38.2022.12.13.08.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 08:26:46 -0800 (PST)
Message-ID: <1e75008f-7a3a-3646-a8cc-53fe443687f3@redhat.com>
Date:   Tue, 13 Dec 2022 17:26:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 0/4] lib: add function to request
 migration
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, lvivier@redhat.com
References: <20221212111731.292942-1-nrb@linux.ibm.com>
 <20221213163630.1d9233b9@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221213163630.1d9233b9@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/2022 16.36, Claudio Imbrenda wrote:
> 
> Paolo and/or Thomas: if you do not have objections, could you pick this
> series?
> 
> every affected architecture has been reviewed :)

Done.

  Thanks,
   Thomas


> 
> On Mon, 12 Dec 2022 12:17:27 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
>> v2->v3:
>> ---
>> * s390x: remove unneeded parenthesis (thanks Claudio)
>>
>> v1->v2:
>> ---
>> * arm: commit message gib->gic (thanks Andrew)
>> * arm: remove unneeded {} (thanks Andrew)
>> * s390x: make patch less intrusive (thanks Claudio)
>>
>> With this series, I pick up a suggestion Claudio has brought up in my
>> CMM-migration series[1].
>>
>> Migration tests can ask migrate_cmd to migrate them to a new QEMU
>> process. Requesting migration and waiting for completion is hence a
>> common pattern which is repeated all over the code base. Add a function
>> which does all of that to avoid repetition.
>>
>> Since migrate_cmd currently can only migrate exactly once, this function
>> is called migrate_once() and is a no-op when it has been called before.
>> This can simplify the control flow, especially when tests are skipped.
>>
>> [1] https://lore.kernel.org/kvm/20221125154646.5974cb52@p-imbrenda/
>>
>> Nico Boehr (4):
>>    lib: add function to request migration
>>    powerpc: use migrate_once() in migration tests
>>    s390x: use migrate_once() in migration tests
>>    arm: use migrate_once() in migration tests
>>
>>   arm/Makefile.common     |  1 +
>>   powerpc/Makefile.common |  1 +
>>   s390x/Makefile          |  1 +
>>   lib/migrate.h           |  9 ++++++++
>>   lib/migrate.c           | 34 ++++++++++++++++++++++++++++
>>   arm/debug.c             | 17 +++++---------
>>   arm/gic.c               | 49 ++++++++++++-----------------------------
>>   powerpc/sprs.c          |  4 ++--
>>   s390x/migration-cmm.c   | 24 ++++++--------------
>>   s390x/migration-sck.c   |  4 ++--
>>   s390x/migration-skey.c  | 20 ++++++-----------
>>   s390x/migration.c       |  7 ++----
>>   12 files changed, 85 insertions(+), 86 deletions(-)
>>   create mode 100644 lib/migrate.h
>>   create mode 100644 lib/migrate.c
>>
> 

