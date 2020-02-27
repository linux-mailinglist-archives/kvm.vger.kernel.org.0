Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA53C17144F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 10:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgB0Jrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 04:47:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728616AbgB0Jrp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 04:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582796863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WEnGFbfkwI7Jox6BYPhDnaeysQO8vyxt3F93Qglbztk=;
        b=P9JttuxiCz6CGajCT2gGINxTYBcGxxkB06PV4/HRDXO53lkB6S4YIHVkHuNfWInm73ywhB
        f39WrXJDLuGRKxctQ5JEA7uiqyovD6e036Iys13hRuv0aKytarDZr1XNxrpIv1LTH7j6S3
        T5Z4XTd2trXgdgsDwBX/Bh6Qo0nFeE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-DPN6SxgENaimuboqxgljRQ-1; Thu, 27 Feb 2020 04:47:40 -0500
X-MC-Unique: DPN6SxgENaimuboqxgljRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEE41800D50;
        Thu, 27 Feb 2020 09:47:38 +0000 (UTC)
Received: from gondolin (ovpn-117-2.ams2.redhat.com [10.36.117.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DCB89298D;
        Thu, 27 Feb 2020 09:47:34 +0000 (UTC)
Date:   Thu, 27 Feb 2020 10:47:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, frankja@linux.vnet.ibm.com,
        kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: introduce module parameter kvm.use_gisa
Message-ID: <20200227104731.17166768.cohuck@redhat.com>
In-Reply-To: <20200227091031.102993-1-mimu@linux.ibm.com>
References: <20200227091031.102993-1-mimu@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Feb 2020 10:10:31 +0100
Michael Mueller <mimu@linux.ibm.com> wrote:

> The boolean module parameter "kvm.use_gisa" controls if newly
> created guests will use the GISA facility if provided by the
> host system. The default is yes.
> 
>   # cat /sys/module/kvm/parameters/use_gisa
>   Y
> 
> The parameter can be changed on the fly.
> 
>   # echo N > /sys/module/kvm/parameters/use_gisa
> 
> Already running guests are not affected by this change.
> 
> The kvm s390 debug feature shows if a guest is running with GISA.
> 
>   # grep gisa /sys/kernel/debug/s390dbf/kvm-$pid/sprintf
>   00 01582725059:843303 3 - 08 00000000e119bc01  gisa 0x00000000c9ac2642 initialized
>   00 01582725059:903840 3 - 11 000000004391ee22  00[0000000000000000-0000000000000000]: AIV gisa format-1 enabled for cpu 000
>   ...
>   00 01582725059:916847 3 - 08 0000000094fff572  gisa 0x00000000c9ac2642 cleared

Maybe log something as well if it is off due to this kernel parameter?

> 
> In general, that value should not be changed as the GISA facility
> enhances interruption delivery performance.
> 
> A reason to switch the GISA facility off might be a performance
> comparison run or debugging.
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d7ff30e45589..5c2081488024 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -184,6 +184,11 @@ static u8 halt_poll_max_steal = 10;
>  module_param(halt_poll_max_steal, byte, 0644);
>  MODULE_PARM_DESC(halt_poll_max_steal, "Maximum percentage of steal time to allow polling");
>  
> +/* if set to true, the GISA will be initialized and used if available */
> +static bool use_gisa  = true;
> +module_param(use_gisa, bool, 0644);
> +MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");

I probably would have inverted the logic (i.e. introduce a disable_gisa
parameter that is off by default), as you want KVM to use the gisa,
except in special circumstances.

> +
>  /*
>   * For now we handle at most 16 double words as this is what the s390 base
>   * kernel handles and stores in the prefix page. If we ever need to go beyond
> @@ -2504,7 +2509,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.use_skf = sclp.has_skey;
>  	spin_lock_init(&kvm->arch.start_stop_lock);
>  	kvm_s390_vsie_init(kvm);
> -	kvm_s390_gisa_init(kvm);
> +	if (use_gisa)
> +		kvm_s390_gisa_init(kvm);

I assume we're fine with no gisa but a gib (i.e. doesn't hurt?)

>  	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
>  
>  	return 0;

