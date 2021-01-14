Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5602F68C1
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 19:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbhANSCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 13:02:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728065AbhANSCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 13:02:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610647250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPOwXiPpI33hw2u5OYDJ4rIdtWWBfrW2gYhDEz40K0Y=;
        b=SUIqVB3mbOjEdwPq6DxRnNeWNlRNgyjbYckinK8LyNeLr8vLl9KDuKvtdchEEch74EZB34
        SZpdNYR6Qv/X2/oCOREg8GG/FhHLUkSU2GGeAWM0Q6D/EQNbYKQJ7pNdNmhfaokZ3QKwQo
        Rw9Hj3dSatozOjB1DqLwZKNtheeyneo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-UM3Y5cjwNZq5qZ3ZC6LI1A-1; Thu, 14 Jan 2021 13:00:45 -0500
X-MC-Unique: UM3Y5cjwNZq5qZ3ZC6LI1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F09A893FCA;
        Thu, 14 Jan 2021 18:00:22 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2702F7D564;
        Thu, 14 Jan 2021 18:00:14 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Xieyingtai <xieyingtai@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        wangxingang <wangxingang5@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        qubingbing <qubingbing@hisilicon.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
 <2de03a797517452cbfeab022e12612b7@huawei.com>
 <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
 <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
 <YACAXaG+opCwDFTL@larix.localdomain>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <8697431a-d30c-c84c-58ff-e2bfcfe19ec2@redhat.com>
Date:   Thu, 14 Jan 2021 19:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <YACAXaG+opCwDFTL@larix.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 1/14/21 6:33 PM, Jean-Philippe Brucker wrote:
> Hi Eric,
> 
> On Thu, Jan 14, 2021 at 05:58:27PM +0100, Auger Eric wrote:
>>>>  The uacce-devel branches from
>>>>> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
>>>>> (they track the latest sva/zip-devel branch
>>>>> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)
>> As I plan to respin shortly, please could you confirm the best branch to
>> rebase on still is that one (uacce-devel from the linux-kernel-uadk git
>> repo). Is it up to date? Commits seem to be quite old there.
> 
> Right I meant the uacce-devel-X branches. The uacce-devel-5.11 branch
> currently has the latest patches

OK thanks!

Eric
> 
> Thanks,
> Jean
> 

