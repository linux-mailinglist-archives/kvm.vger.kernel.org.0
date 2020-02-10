Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF2157264
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 11:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBJKDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 05:03:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgBJKDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 05:03:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581329026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=kFLzp+0Tyi01pcoK8tEnl5P8h+hs+naa8PNor6P/giQ=;
        b=fkZ75RrB8QULvx3eZ3xrdkY3mblsR2v6Hj0xJavqWNXretda/lPwCtIHst52rCi8Ie1B4c
        xYmCvYdALWkLDdVTdkgy/BGGwZ0jwanUQg/eC9acI5VLmIbR5WvBZNOhQeXGzmvRUQ7axt
        9XghQUrMP4UfBHWT2K332GZb/G8jIKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-MzBehuoIPkaei-d6_x8lPw-1; Mon, 10 Feb 2020 05:03:42 -0500
X-MC-Unique: MzBehuoIPkaei-d6_x8lPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD833800D48;
        Mon, 10 Feb 2020 10:03:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C034589F0D;
        Mon, 10 Feb 2020 10:03:35 +0000 (UTC)
Subject: Re: [PATCH 15/35] KVM: s390: protvirt: Implement interruption
 injection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-16-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f25f7092-3410-bdcd-8b4a-994b84d37efa@redhat.com>
Date:   Mon, 10 Feb 2020 11:03:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-16-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> The patch implements interruption injection for the following
> list of interruption types:
> 
>    - I/O (uses inject io interruption)
>      __deliver_io
> 
>    - External (uses inject external interruption)
>      __deliver_cpu_timer
>      __deliver_ckc
>      __deliver_emergency_signal
>      __deliver_external_call
> 
>    - cpu restart (uses inject restart interruption)
>      __deliver_restart
> 
>    - machine checks (uses mcic, failing address and external damage)
>      __write_machine_check
> 
> Please note that posted interrupts (GISA) are not used for protected
> guests as of today.
> 
> The service interrupt is handled in a followup patch.
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |   6 ++
>  arch/s390/kvm/interrupt.c        | 106 +++++++++++++++++++++++--------
>  2 files changed, 86 insertions(+), 26 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

