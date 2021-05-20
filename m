Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D43389FFB
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 10:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhETIlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 04:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhETIlF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 04:41:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621499977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyK5ub/paPf5YnH0JrUsrIXNhGEnDH4sjj+bIncOVPg=;
        b=YGW5f8ixLkxIfNDNlGM08cjjPgcw9XDHoWnnNgfsJehvH904X6PIJ7WSVPp3U/DBSp7uWH
        wHH8Bh2IvufBJ4psVGxePZRoe50Bkwlp+outPdIY3VeuZ28gr8tOCK0QIqmvtvr6W7MdsP
        4OCBFj1nqwyS91x+wEeMB8QBM+EOQeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-SLnNQuYqPjyY1rEQ_Z2rBA-1; Thu, 20 May 2021 04:39:33 -0400
X-MC-Unique: SLnNQuYqPjyY1rEQ_Z2rBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60A371A8A74;
        Thu, 20 May 2021 08:39:24 +0000 (UTC)
Received: from [10.36.110.30] (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2EBF6A8E4;
        Thu, 20 May 2021 08:38:53 +0000 (UTC)
To:     Kees Cook <keescook@chromium.org>
Cc:     alex.williamson@redhat.com, jmorris@namei.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
        mjg59@srcf.ucam.org, cohuck@redhat.com
References: <20210506091859.6961-1-maxime.coquelin@redhat.com>
 <202105101955.933F66A@keescook>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: Re: [PATCH] vfio: Lock down no-IOMMU mode when kernel is locked down
Message-ID: <d9138fab-4420-8c80-047d-b83c04eeed8e@redhat.com>
Date:   Thu, 20 May 2021 10:38:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202105101955.933F66A@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/21 4:58 AM, Kees Cook wrote:
> On Thu, May 06, 2021 at 11:18:59AM +0200, Maxime Coquelin wrote:
>> When no-IOMMU mode is enabled, VFIO is as unsafe as accessing
>> the PCI BARs via the device's sysfs, which is locked down when
>> the kernel is locked down.
>>
>> Indeed, it is possible for an attacker to craft DMA requests
>> to modify kernel's code or leak secrets stored in the kernel,
>> since the device is not isolated by an IOMMU.
>>
>> This patch introduces a new integrity lockdown reason for the
>> unsafe VFIO no-iommu mode.
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
>> ---
>>  drivers/vfio/vfio.c      | 13 +++++++++----
>>  include/linux/security.h |  1 +
>>  security/security.c      |  1 +
>>  3 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 5e631c359ef2..fe466d6ea5d8 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/pci.h>
>>  #include <linux/rwsem.h>
>>  #include <linux/sched.h>
>> +#include <linux/security.h>
>>  #include <linux/slab.h>
>>  #include <linux/stat.h>
>>  #include <linux/string.h>
>> @@ -165,7 +166,8 @@ static void *vfio_noiommu_open(unsigned long arg)
>>  {
>>  	if (arg != VFIO_NOIOMMU_IOMMU)
>>  		return ERR_PTR(-EINVAL);
>> -	if (!capable(CAP_SYS_RAWIO))
>> +	if (!capable(CAP_SYS_RAWIO) ||
>> +			security_locked_down(LOCKDOWN_VFIO_NOIOMMU))
> 
> The LSM hook check should come before the capable() check to avoid
> setting PF_SUPERPRIV if capable() passes and the LSM doesn't.

OK, good to know, I'll swap in next revision.

BTW, it seems other places are doing the capable check before the LSM
hook check, for example in ioport [0].

>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 06f7c50ce77f..f29388180fab 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -120,6 +120,7 @@ enum lockdown_reason {
>>  	LOCKDOWN_MMIOTRACE,
>>  	LOCKDOWN_DEBUGFS,
>>  	LOCKDOWN_XMON_WR,
>> +	LOCKDOWN_VFIO_NOIOMMU,
>>  	LOCKDOWN_INTEGRITY_MAX,
>>  	LOCKDOWN_KCORE,
>>  	LOCKDOWN_KPROBES,
> 
> Is the security threat specific to VFIO? (i.e. could other interfaces
> want a similar thing, such that naming this VFIO doesn't make sense?

It could possibly in theory, maybe something like
"LOCKDOWN_UNRESTRICTED_DMA" would be a better fit?

Maxime

[0]:
https://elixir.bootlin.com/linux/v5.13-rc2/source/arch/x86/kernel/ioport.c#L73

