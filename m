Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B60D2585B4
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 04:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgIACks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 22:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbgIACks (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 22:40:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598928046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8lX4poE02ajQJGxjNbAWozayzDOLmpEFUCaK0JJrN7w=;
        b=L7IuRCf+MPAFLRBEtERKEt/sSMBXRHMpa9L5fFPLsmF62cX4igVBk60rVzyA2n/EVeQNJ3
        fnc04YIav2+KqkWmhqJaFwtzuk/b2uc13LEVCRcu4TjUQkI1lrwB3XYl6FGoph+Quk12q5
        SEjpo5mIhbOZacPbKGJ35/Bqlc/RgwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-RQlift-JMi2mLXeNomZVug-1; Mon, 31 Aug 2020 22:40:44 -0400
X-MC-Unique: RQlift-JMi2mLXeNomZVug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E7A21007B01;
        Tue,  1 Sep 2020 02:40:43 +0000 (UTC)
Received: from [10.72.13.164] (ovpn-13-164.pek2.redhat.com [10.72.13.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF580747B0;
        Tue,  1 Sep 2020 02:40:31 +0000 (UTC)
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0ggVjJdIHZmaW8gZG1hX21h?=
 =?UTF-8?Q?p/unmap=3a_optimized_for_hugetlbfs_pages?=
To:     Peter Xu <peterx@redhat.com>,
        "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
 <20200825205907.GB8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2D9ABB@dggeml524-mbx.china.huawei.com>
 <20200826151509.GD8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2DBE7A@dggeml524-mbx.china.huawei.com>
 <20200828142400.GA3197@xz-x1>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a07f4db3-7680-14ac-dd1e-6851e051aa4e@redhat.com>
Date:   Tue, 1 Sep 2020 10:40:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200828142400.GA3197@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/28 下午10:24, Peter Xu wrote:
> On Fri, Aug 28, 2020 at 09:23:08AM +0000, Maoming (maoming, Cloud Infrastructure Service Product Dept.) wrote:
>> In hugetlb_put_pfn(), I delete unpin_user_pages_dirty_lock() and use some simple code to put hugetlb pages.
>> Is this right?
> I think we should still use the APIs because of the the same reason.  However
> again I don't know the performance impact of that to your patch, but I still
> think that could be done inside gup itself when needed (e.g., a special path
> for hugetlbfs for [un]pinning continuous pages; though if that's the case that
> could be something to be discussed on -mm then as a separate patch, imho).
>
> Thanks,


+1, we should make this as a generic optimization instead of VFIO 
specific consider there're a lot of GUP users.

Thanks


