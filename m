Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348AF78942E
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 09:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjHZHPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 03:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjHZHP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 03:15:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30FD2133
        for <kvm@vger.kernel.org>; Sat, 26 Aug 2023 00:15:25 -0700 (PDT)
Received: from kwepemm600005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RXp2k0304zfbwq;
        Sat, 26 Aug 2023 15:13:49 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 26 Aug 2023 15:15:23 +0800
Subject: Re: [PATCH v13 0/4] add debugfs to migration driver
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
References: <20230816094205.37389-1-liulongfang@huawei.com>
 <20230817164835.5c219dc0.alex.williamson@redhat.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <e9b93a4c-207e-6fa7-cdc7-c8afda7f1ff1@huawei.com>
Date:   Sat, 26 Aug 2023 15:15:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230817164835.5c219dc0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.121.110]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/18 6:48, Alex Williamson wrote:
> On Wed, 16 Aug 2023 17:42:01 +0800
> liulongfang <liulongfang@huawei.com> wrote:
> 
>> Add a debugfs function to the migration driver in VFIO to provide
>> a step-by-step test function for the migration driver.
>>
>> When the execution of live migration fails, the user can view the
>> status and data during the migration process separately from the
>> source and the destination, which is convenient for users to analyze
>> and locate problems.
>>
>> Changes v12 -> v13
>> 	Solve the problem of open and close competition to debugfs.
> 
> Hi,
> 
> I'm not sure if the new To: list is a mistake or if this is an appeal
> to a different set of maintainers for a more favorable response than
> previous postings[1], but kvm@vger.kernel.org remains the list for this
> driver, which is under the perview of vfio [adding the correct list and
> co-maintainer].
>

You are right, the patchset was sent to the wrong email address.

> I believe there is still a concern whether this is a valid and
> worthwhile debugfs interface.  It has been suggested that much of what
> this provides could be done through userspace drivers to exercise the
> migration interfaces and/or userspace debugging techniques to examine
> the device migration data.  I haven't seen a satisfactory conclusion
> for these comments yet.
>

It is reasonable to test live migrations via userspace drivers.
This user-space operation is an unsolicited test.
However, the current operations in this patchset only retain the
function of reading status data. There is no test function,
and this part of the function is no different from the debugfs
function of other IO device drivers.
It should be possible to use debugfs here.

In addition, the debugfs in the driver does not need to rely on
the userspace driver tool. It will be more convenient to use.

> I think we have general consensus that the first couple patches are ok> and useful, exposing the migration state generically and supporting a
> minor cleanup within the hisi_acc driver.  However, the new approach to
> try to lock the device with igate is certainly not the correct (igate
> is used for serializing interrupt configuration) and the proposed
> hisi_acc specific debugfs interfaces themselves are not settled.
> Thanks,
>

Then I will disassemble the patch and send out the front part first.
Thanks,
Longfang.
> Alex
> 
> [1]https://lore.kernel.org/all/20230728072104.64834-1-liulongfang@huawei.com/
> 
> .
> 
