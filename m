Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5117A56D6
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 03:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjISBMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 21:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISBMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 21:12:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3B08E
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 18:11:55 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RqNqd5Dmtz15NR0;
        Tue, 19 Sep 2023 09:09:49 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 19 Sep 2023 09:11:53 +0800
Message-ID: <8339e529-928a-a914-6134-567f3dbc55b3@huawei.com>
Date:   Tue, 19 Sep 2023 09:11:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 0/3] vfio: Fix the null-ptr-deref bugs in samples of
 vfio-mdev
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <kwankhede@nvidia.com>, <kraxel@redhat.com>,
        <cjia@nvidia.com>
References: <20230909070952.80081-1-ruanjinjie@huawei.com>
 <20230918163916.539716f4.alex.williamson@redhat.com>
From:   Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <20230918163916.539716f4.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/9/19 6:39, Alex Williamson wrote:
> On Sat, 9 Sep 2023 15:09:49 +0800
> Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
>> There is a null-ptr-deref bug in strchr() of device_add(), if the kstrdup()
>> fails in kobject_set_name_vargs() in dev_set_name(). This patchset fix
>> the issues.
>>
>> Jinjie Ruan (3):
>>   vfio/mdpy: Fix the null-ptr-deref bug in mdpy_dev_init()
>>   vfio/mtty: Fix the null-ptr-deref bug in mtty_dev_init()
>>   vfio/mbochs: Fix the null-ptr-deref bug in mbochs_dev_init()
>>
>>  samples/vfio-mdev/mbochs.c | 4 +++-
>>  samples/vfio-mdev/mdpy.c   | 4 +++-
>>  samples/vfio-mdev/mtty.c   | 4 +++-
>>  3 files changed, 9 insertions(+), 3 deletions(-)
>>
> 
> These all target the wrong goto label, aiui we can't call put_device()
> if we haven't called device_initialize(), so I think there needs to be
> an intermediate label added before class_destroy().  Thanks,

Thank you! Since commit fd6f7ad2fd4d ("driver core: return an error when
dev_set_name() hasn't happened"), the above issues has been fixed.

> 
> Alex
> 
