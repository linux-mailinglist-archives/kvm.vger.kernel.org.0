Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463A3243B69
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 16:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHMOTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 10:19:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53921 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726522AbgHMOT0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 10:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597328365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EVVaCgXcjbFi+DRQRD3jHW6JoaEa6ENlRJBReAb9qcI=;
        b=IG4ael9Tt5byEovJ/w2Ga/vLtqsxujck9BOf85u2DxpePnMeeF7lwt6rbMm4oF+vCCHnfC
        5sGdv3WWkJJNdebBFhYbbL7RfayitM6zrl7CS0YJhFfetEHdhHmH4/veroQwKgX5DttxoN
        Lrzi/3lZNkvyjJh4I9VxkV3K7pTlhXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-gEz4EjWENFClGnnKKDc-Pw-1; Thu, 13 Aug 2020 10:19:21 -0400
X-MC-Unique: gEz4EjWENFClGnnKKDc-Pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E922B1005504;
        Thu, 13 Aug 2020 14:19:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2621D1014160;
        Thu, 13 Aug 2020 14:19:17 +0000 (UTC)
Date:   Thu, 13 Aug 2020 16:19:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, zhang.zhanghailiang@huawei.com,
        kvm@vger.kernel.org, maz@kernel.org, will@kernel.org
Subject: Re: [RFC 0/4] kvm: arm64: emulate ID registers
Message-ID: <20200813141915.wagalfqn67azowu5@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813060517.2360048-1-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 02:05:13PM +0800, Peng Liang wrote:
> In AArch64, guest will read the same values of the ID regsiters with
> host.  Both of them read the values from arm64_ftr_regs.  This patch
> series add support to emulate and configure ID registers so that we can
> control the value of ID registers that guest read.
> 
> Peng Liang (4):
>   arm64: add a helper function to traverse arm64_ftr_regs
>   kvm: arm64: emulate the ID registers
>   kvm: arm64: make ID registers configurable
>   kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
> 
>  arch/arm64/include/asm/cpufeature.h |  2 ++
>  arch/arm64/include/asm/kvm_host.h   |  2 ++
>  arch/arm64/kernel/cpufeature.c      | 13 ++++++++
>  arch/arm64/kvm/arm.c                | 21 ++++++++++++
>  arch/arm64/kvm/sys_regs.c           | 50 ++++++++++++++++++++++-------
>  include/uapi/linux/kvm.h            | 12 +++++++
>  6 files changed, 89 insertions(+), 11 deletions(-)
> 
> -- 
> 2.18.4
> 

Hi Peng,

After having looked at the QEMU series I don't believe this is the right
approach to CPU models. As stated in my reply [*] this approach appears
to just be shifting the problem wholesale to the user. On the KVM side,
I think we should start by auditing all the ID registers to see what
should be masked and what should be under user control. Then, we need
to consider what MIDR a guest that can migrate between hosts of different
MIDRs should have. And that'll require addressing the errata problem in
one way or another.

[*] https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg02587.html

Thanks,
drew

