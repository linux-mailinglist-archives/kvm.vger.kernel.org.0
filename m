Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB21826D5C2
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 10:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIQIH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 04:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbgIQIGq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 04:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600330002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2KPrQh5EWErmHM86gwG9SLynueQ4HadaDegVq2gjLUI=;
        b=UuG0TvfCu0wQbHJevWqrB+vj8ASM7LZ/4g+Nr12avP/r9f8A1Sq/AOkJKVi+K1KSBJEaEq
        p5etqcLKLasrqaZpE3M0TLGMnCPwuC8ztyeftZgHaHBDZ7Nvna3ygWM/MWpfOTLZiCtvRC
        2jsHhv81H8gmIYH02AdnCQxerUWdiKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-2PYnQhV6PN6MlWP3Yq4itA-1; Thu, 17 Sep 2020 04:04:36 -0400
X-MC-Unique: 2PYnQhV6PN6MlWP3Yq4itA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C76185C733;
        Thu, 17 Sep 2020 08:04:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3021101416C;
        Thu, 17 Sep 2020 08:04:32 +0000 (UTC)
Date:   Thu, 17 Sep 2020 10:04:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ying Fang <fangying1@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
Message-ID: <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:47:42AM +0100, Marc Zyngier wrote:
> On 2020-09-17 03:30, Ying Fang wrote:
> > Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
> > so that we can support cpu topology for arm.
> 
> MPIDR has *nothing* to do with CPU topology in the ARM architecture.
> I encourage you to have a look at the ARM ARM and find out how often
> the word "topology" is used in conjunction with the MPIDR_EL1 register.
>

Hi Marc,

I mostly agree. However, the CPU topology descriptions use MPIDR to
identify PEs. If userspace wants to build topology descriptions then
it either needs to

1) build them after instantiating all KVM VCPUs in order to query KVM
   for each MPIDR, or
2) have a way to ask KVM for an MPIDR of given VCPU ID in advance
   (maybe just a scratch VCPU), or
3) have control over the MPIDRs so it can choose them when it likes,
   use them for topology descriptions, and then instantiate KVM VCPUs
   with them.

I think (3) is the most robust approach, and it has the least overhead.

Thanks,
drew

