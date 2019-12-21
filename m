Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25744128913
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 13:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfLUMf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 07:35:57 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726182AbfLUMf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Dec 2019 07:35:57 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5BEC98C9039688F26A78;
        Sat, 21 Dec 2019 20:35:53 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Sat, 21 Dec 2019
 20:35:46 +0800
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
To:     Igor Mammedov <imammedo@redhat.com>,
        Xiang Zheng <zhengxiang9@huawei.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-6-zhengxiang9@huawei.com>
 <20191115173713.795e5f63@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <38f13f15-960d-3e56-78f5-42b1ec61a322@huawei.com>
Date:   Sat, 21 Dec 2019 20:35:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20191115173713.795e5f63@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/11/16 0:37, Igor Mammedov wrote:
>> +
>> +        /* zero means OSPM does not acknowledge the error */
>> +        if (!read_ack_register) {
>> +            if (loop < 3) {
>> +                usleep(100 * 1000);
>> +                loop++;
>> +                goto retry;
> as minimum this loop can stall guest repeatedly for 0.3s if guest triggers BQL,
> until it handles error.

I think reparations for 0.3s is reasonable.
1. 0.3s is the worst case to repeat, if guest acknowledge it in before 0.3s, the guest can not stall
2. if the previous error is not acknowledged, the next error will be lost, error handling(safety) is more important than others.


>
> (not sure what to suggest here though)
> 
> (not sure what to suggest here though)
> 

