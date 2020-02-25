Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7F16EBE9
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgBYQ7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:59:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728051AbgBYQ7a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 11:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582649969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TjwoM0/StVfrn5wh2Yyffw44qkAt+KuH9t4IFN7loIA=;
        b=LJLhK4Pc7nTo4TFcYmZN3bMMOEwHlccghJMOfjxbX8myvrdvBJBuYJ+kNbG2Zd5q38SE9I
        0lA0QW63xIl4EU5KjaaZ99LwVQY3BGzUfLFTnIV7ix8ba6qCT0dv0KTkdPZgv920upVC8A
        +ABq9dpEIx43qzCtui/CjUDXgzWeHSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-gdSoGWxPPvK1FVQkeAeWDQ-1; Tue, 25 Feb 2020 11:59:27 -0500
X-MC-Unique: gdSoGWxPPvK1FVQkeAeWDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A9751005F72;
        Tue, 25 Feb 2020 16:59:25 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8651590F5F;
        Tue, 25 Feb 2020 16:59:19 +0000 (UTC)
Date:   Tue, 25 Feb 2020 17:59:18 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        James Morse <james.morse@arm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>
Subject: Re: [PATCH v24 00/10] Add ARMv8 RAS virtualization support in QEMU
Message-ID: <20200225175918.5a81506f@redhat.com>
In-Reply-To: <acd194e5-81d8-afa7-fb6d-6b7d744b5d81@huawei.com>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
        <CAFEAcA9xd8fHiigZFFM7Symh0Mkm-jQ_aGJ7ifRCrXZvFY4DqQ@mail.gmail.com>
        <acd194e5-81d8-afa7-fb6d-6b7d744b5d81@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 16:37:44 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> On 2020/2/21 22:09, Peter Maydell wrote:
> > On Mon, 17 Feb 2020 at 13:10, Dongjiu Geng <gengdongjiu@huawei.com> wrote:  
> >>
> >> In the ARMv8 platform, the CPU error types includes synchronous external abort(SEA) and SError Interrupt (SEI). If exception happens in guest, host does not know the detailed information of guest, so it is expected that guest can do the recovery.
> >> For example, if an exception happens in a guest user-space application, host does
> >> not know which application encounters errors, only guest knows it.
> >>
> >> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
> >> After user space gets the notification, it will record the CPER into guest GHES
> >> buffer and inject an exception or IRQ to guest.
> >>
> >> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
> >> treat it as a synchronous exception, and notify guest with ARMv8 SEA
> >> notification type after recording CPER into guest.  
> > 
> > Hi; I have reviewed the remaining arm bit of this series (patch 9),
> > and made some comments on patch 1. Still to be reviewed are
> > patches 4, 5, 6, 8: I'm going to assume that Michael or Igor
> > will look at those.  
> 
> Thanks very much for Peter's review.
> Michael/Igor, hope you can review patches 4, 5, 6, 8, thank you very much in advance.

done

> > 
> > thanks
> > -- PMM
> > 
> > .
> >   
> 

