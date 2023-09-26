Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0777AEF06
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbjIZOuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 10:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbjIZOuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 10:50:11 -0400
X-Greylist: delayed 68922 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Sep 2023 07:50:01 PDT
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [IPv6:2a02:6b8:c03:500:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D7116
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 07:50:01 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:5429:0:640:6285:0])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 415FF613D7;
        Tue, 26 Sep 2023 17:49:54 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b41d::1:39] (unknown [2a02:6b8:b081:b41d::1:39])
        by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id rnQImn0Oca60-StuCL6yV;
        Tue, 26 Sep 2023 17:49:53 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
        s=default; t=1695739793;
        bh=52P7ivRmreoIBrospgFGRtv2ATCZjDAvi7vkNLxLgx8=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=ITbSJkEGeoFb2fVYWQNALUQ2twPUqDf3ILK/EiwDduVBiqbvwo0kt8Kz8mbLuouGL
         SPuAHW/qkLK07mQPYxNKlbK3hwQnLCZ5HJTmYNdEj8MFGZMHWsXVe50OeuKiIHiaxy
         dZ8AeHAiCmGfIzy5+eJXo1HqkRQwI9C7O4SitF4Y=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <ca305dae-9e1d-bb76-36e6-fd007a817d0c@yandex-team.ru>
Date:   Tue, 26 Sep 2023 17:49:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 09/12] kvm-all: introduce limits for name_size and
 num_desc
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20230925194040.68592-1-vsementsov@yandex-team.ru>
 <20230925194040.68592-10-vsementsov@yandex-team.ru>
 <CAFEAcA8CXa1fyyGtZRwbyPch9wwmgMrg8wbWEPZ3pL3GW6n1dg@mail.gmail.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <CAFEAcA8CXa1fyyGtZRwbyPch9wwmgMrg8wbWEPZ3pL3GW6n1dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.09.23 14:05, Peter Maydell wrote:
> On Mon, 25 Sept 2023 at 20:43, Vladimir Sementsov-Ogievskiy
> <vsementsov@yandex-team.ru> wrote:
>>
>> Coverity doesn't like when the value with unchecked bounds that comes
>> from fd is used as length for IO or allocation. And really, that's not
>> a good practice. Let's introduce at least an empirical limits for these
>> values.
>>
>> Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
>> ---
>>   accel/kvm/kvm-all.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index ff1578bb32..6d0ba7d900 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -3988,6 +3988,9 @@ typedef struct StatsDescriptors {
>>   static QTAILQ_HEAD(, StatsDescriptors) stats_descriptors =
>>       QTAILQ_HEAD_INITIALIZER(stats_descriptors);
>>
>> +
>> +#define KVM_STATS_QEMU_MAX_NAME_SIZE (1024 * 1024)
>> +#define KVM_STATS_QEMU_MAX_NUM_DESC (1024)
> 
> These seem arbitrary. Why these values in particular?
> Does the kernel have any limitation on the values it passes us?

Documentation doesn't say about limits

> Do we have any particular limit on what we can handle?
> 

Hmm. At least, we don't arithmetic operations with these values to overflow. But in this case g_malloc0_n should crash anyway.

So we may rely on g_malloc0_n as on assertion that the values are good enough and further doubts are false-positives. Will drop this patch.

-- 
Best regards,
Vladimir

