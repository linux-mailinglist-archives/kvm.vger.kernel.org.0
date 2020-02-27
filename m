Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473221717CE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 13:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgB0MsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 07:48:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57187 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728986AbgB0MsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 07:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582807703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQHQp+fMAomVybEW4Laeozki/FbJS39MJ2LdVVufDJ8=;
        b=YroC3TkyQ5QBIZaXtlU5B0IxRwa0djhiPlsN85NAFfXF0p34SZCGF8YYNEhwWx22lPgf+L
        JdZiya7azDJJfNr+jxPI9/RSf0yLnySYJTk1meWm8dsV8+Dd8CYbBFMJaAmKNUoxUqfKOq
        yB1ikCI9SfcWMcZVFxzU8yJM07ip2Tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Ng1ii0SFOCO9RNdVM_7r6Q-1; Thu, 27 Feb 2020 07:48:18 -0500
X-MC-Unique: Ng1ii0SFOCO9RNdVM_7r6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1265F1005512;
        Thu, 27 Feb 2020 12:48:17 +0000 (UTC)
Received: from gondolin (ovpn-117-2.ams2.redhat.com [10.36.117.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED0EB1001B34;
        Thu, 27 Feb 2020 12:48:12 +0000 (UTC)
Date:   Thu, 27 Feb 2020 13:48:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>, frankja@linux.vnet.ibm.com,
        kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: introduce module parameter kvm.use_gisa
Message-ID: <20200227134810.268fc3b5.cohuck@redhat.com>
In-Reply-To: <c16f65a7-5711-96e2-1527-fa13eab9f5ca@de.ibm.com>
References: <20200227091031.102993-1-mimu@linux.ibm.com>
        <c16f65a7-5711-96e2-1527-fa13eab9f5ca@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Feb 2020 13:27:10 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 27.02.20 10:10, Michael Mueller wrote:
> > The boolean module parameter "kvm.use_gisa" controls if newly
> > created guests will use the GISA facility if provided by the
> > host system. The default is yes.
> > 
> >   # cat /sys/module/kvm/parameters/use_gisa
> >   Y
> > 
> > The parameter can be changed on the fly.
> > 
> >   # echo N > /sys/module/kvm/parameters/use_gisa
> > 
> > Already running guests are not affected by this change.
> > 
> > The kvm s390 debug feature shows if a guest is running with GISA.
> > 
> >   # grep gisa /sys/kernel/debug/s390dbf/kvm-$pid/sprintf
> >   00 01582725059:843303 3 - 08 00000000e119bc01  gisa 0x00000000c9ac2642 initialized
> >   00 01582725059:903840 3 - 11 000000004391ee22  00[0000000000000000-0000000000000000]: AIV gisa format-1 enabled for cpu 000
> >   ...
> >   00 01582725059:916847 3 - 08 0000000094fff572  gisa 0x00000000c9ac2642 cleared
> > 
> > In general, that value should not be changed as the GISA facility
> > enhances interruption delivery performance.
> > 
> > A reason to switch the GISA facility off might be a performance
> > comparison run or debugging.
> > 
> > Signed-off-by: Michael Mueller <mimu@linux.ibm.com>  
> 
> Looks good to me. Regarding the other comments, I think allowing for dynamic changes
> and keeping use_gisa vs disable_gisa makes sense. So I would think that the patch
> as is makes sense.

use_gisa vs disable_gisa is more a personal preference; I don't mind
keeping it as use_gisa.

> 
> The only question is: shall we set use_gisa to 0 when the machine does not support
> it (e.g. VSIE?) and then also forbid setting it to 1? Could be overkill.

I don't think you should try to overload a debug knob like that; it's
now simple enough, adding more code also adds to the potential for
errors.

> 
> 
> > ---
> >  arch/s390/kvm/kvm-s390.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index d7ff30e45589..5c2081488024 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -184,6 +184,11 @@ static u8 halt_poll_max_steal = 10;
> >  module_param(halt_poll_max_steal, byte, 0644);
> >  MODULE_PARM_DESC(halt_poll_max_steal, "Maximum percentage of steal time to allow polling");
> >  
> > +/* if set to true, the GISA will be initialized and used if available */
> > +static bool use_gisa  = true;
> > +module_param(use_gisa, bool, 0644);
> > +MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");

Especially as the description explicitly says "if the host supports it"
-- that's good enough for a new knob.

> > +
> >  /*
> >   * For now we handle at most 16 double words as this is what the s390 base
> >   * kernel handles and stores in the prefix page. If we ever need to go beyond
> > @@ -2504,7 +2509,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	kvm->arch.use_skf = sclp.has_skey;
> >  	spin_lock_init(&kvm->arch.start_stop_lock);
> >  	kvm_s390_vsie_init(kvm);
> > -	kvm_s390_gisa_init(kvm);
> > +	if (use_gisa)
> > +		kvm_s390_gisa_init(kvm);
> >  	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
> >  
> >  	return 0;
> >   
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

