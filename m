Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3347AFC32
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 09:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjI0Hik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 03:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjI0Hii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 03:38:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3B911D
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 00:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695800273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzmdkgJVacl611f+REy0nRFcZdf1f4FGc4mWf9kNvKg=;
        b=bOP9XgI+m2HXexDHDrJTYYvdPMv1rVsNTTKhX7yYlx7Kg2xORj6wZFR72csW+khcgkmhRQ
        z0VgKBrm+Kb6vo0hX72rDoUoPFyL+FN1siKDsU1lvFznELZgRddhunHZmla2elWqp47WC4
        iRulFBdPpQSJXWEM2xC1LbOLSS+bLro=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-_F6RJ10SP9SLIkFYJySdiQ-1; Wed, 27 Sep 2023 03:37:51 -0400
X-MC-Unique: _F6RJ10SP9SLIkFYJySdiQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40647c6f71dso1649845e9.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 00:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695800271; x=1696405071;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzmdkgJVacl611f+REy0nRFcZdf1f4FGc4mWf9kNvKg=;
        b=YyGyIPxwW0rZe8MOGxmvcB4idfPsH+RSF7Q76LEA1a/foOhi1sNbvsT06SqrIDFBbB
         Y6rtbA6XpbMHa/GghUUPjloODzZT8iZiEV9sAGl30tMVg1ekcYgqSnp7q+Athh1zRe8Y
         oDz/8CFPyUmpDijZRmQYmL12D7uh3xNZWLuHCEr4Bav6fWZoVi0MABouNMBrxIwT4YOs
         s5+Un65YUGmahZchaDa/QM+PSMYV1vUcMsLMC4cSenoHDnZxgmconjOac6u7h6z00SQW
         rxSXWd8Yzs2ZvEAqSmat8RJzBi4p37cTeN/kD31wMSp7fFCi9mOAlSKbsdPp80lckSrd
         +msA==
X-Gm-Message-State: AOJu0YxuijaY9AroR6BoWkJEpGbWYsK4soZr/l3HZN9MQEn04t4NuYSo
        KbMa83AQD27y8EHSglwkIcIDin6dYUDmYNRyw33WZDRbrLJpzGlMqllqqygl6v4e7Ahrq/vV1ef
        YAudra8fsIK4K
X-Received: by 2002:a05:600c:214:b0:401:bcb4:f133 with SMTP id 20-20020a05600c021400b00401bcb4f133mr1317739wmi.22.1695800270795;
        Wed, 27 Sep 2023 00:37:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6GTWPyjdRalcEyKRa4+1Afbjfckld/pyknV9vE0PjXAKdAdSloWwE+dhutPySlcYVRFQJ4w==
X-Received: by 2002:a05:600c:214:b0:401:bcb4:f133 with SMTP id 20-20020a05600c021400b00401bcb4f133mr1317712wmi.22.1695800270393;
        Wed, 27 Sep 2023 00:37:50 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.19.70])
        by smtp.gmail.com with ESMTPSA id e9-20020adfe7c9000000b003197efd1e7bsm2530401wrn.114.2023.09.27.00.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 00:37:49 -0700 (PDT)
Date:   Wed, 27 Sep 2023 09:37:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v1 12/12] test/vsock: io_uring rx/tx tests
Message-ID: <46h5yyg62ize2woqu6rp5ebffuhrivo4y7fw3iknicozcaxiz5@ojfvm6qeqzam>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <20230922052428.4005676-13-avkrasnov@salutedevices.com>
 <kfuzqzhrgdk5f5arbq4n3vd6vro6533aeysqhdgqevcqxrdm6e@57ylpkc2t4q4>
 <708be048-862f-76ee-6671-16b54e72e5a8@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <708be048-862f-76ee-6671-16b54e72e5a8@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 11:00:19PM +0300, Arseniy Krasnov wrote:
>
>
>On 26.09.2023 16:04, Stefano Garzarella wrote:
>> On Fri, Sep 22, 2023 at 08:24:28AM +0300, Arseniy Krasnov wrote:
>>> This adds set of tests which use io_uring for rx/tx. This test suite is
>>> implemented as separated util like 'vsock_test' and has the same set of
>>> input arguments as 'vsock_test'. These tests only cover cases of data
>>> transmission (no connect/bind/accept etc).
>>>
>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> ---
>>> Changelog:
>>> v5(big patchset) -> v1:
>>>  * Use LDLIBS instead of LDFLAGS.
>>>
>>> tools/testing/vsock/Makefile           |   7 +-
>>> tools/testing/vsock/vsock_uring_test.c | 321 +++++++++++++++++++++++++
>>> 2 files changed, 327 insertions(+), 1 deletion(-)
>>> create mode 100644 tools/testing/vsock/vsock_uring_test.c
>>>
>>> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>>> index 1a26f60a596c..c84380bfc18d 100644
>>> --- a/tools/testing/vsock/Makefile
>>> +++ b/tools/testing/vsock/Makefile
>>> @@ -1,12 +1,17 @@
>>> # SPDX-License-Identifier: GPL-2.0-only
>>> +ifeq ($(MAKECMDGOALS),vsock_uring_test)
>>> +LDLIBS = -luring
>>> +endif
>>> +
>>
>> This will fails if for example we call make with more targets,
>> e.g. `make vsock_test vsock_uring_test`.
>>
>> I'd suggest to use something like this:
>>
>> --- a/tools/testing/vsock/Makefile
>> +++ b/tools/testing/vsock/Makefile
>> @@ -1,13 +1,11 @@
>>  # SPDX-License-Identifier: GPL-2.0-only
>> -ifeq ($(MAKECMDGOALS),vsock_uring_test)
>> -LDLIBS = -luring
>> -endif
>> -
>>  all: test vsock_perf
>>  test: vsock_test vsock_diag_test
>>  vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>>  vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>>  vsock_perf: vsock_perf.o
>> +
>> +vsock_uring_test: LDLIBS = -luring
>>  vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o
>>
>>  CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
>>
>>> all: test vsock_perf
>>> test: vsock_test vsock_diag_test
>>> vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>>> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>>> vsock_perf: vsock_perf.o
>>> +vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o
>>
>> Shoud we add this new test to the "test" target as well?
>
>Ok, but in this case, this target will always depend on liburing.

I think it's fine.

If they want to run all the tests, they need liburing. If they don't
want to build io_uring tests, they can just do `make vsock_test`.

Stefano

