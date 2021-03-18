Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B373407B3
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhCROSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:18:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231423AbhCROSP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 10:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616077095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TrKwjdU4slFUVHR4iH/3m1Ehka6sNgwhoA+WBPtWiXE=;
        b=TDJYvw9ZVgt7LgoTlX8qFhiXOEXIAnmF346ReHCdIn/XPqbpspd5A1TCjXNzxZR+d6H1eR
        DcCSYRsYIYQfjTEj5BmESMqh534ouRzmPWO62iGiQwAV3A6crQeOJqdFrCMzhQGj0XEt/q
        t/tFkdgdasX00UHDHH85CQ+PwkTEM/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-_xDkkjXiNDObo4T5Wkp6Iw-1; Thu, 18 Mar 2021 10:18:13 -0400
X-MC-Unique: _xDkkjXiNDObo4T5Wkp6Iw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C5B119251A1;
        Thu, 18 Mar 2021 14:18:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.196.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 797DB1F070;
        Thu, 18 Mar 2021 14:18:05 +0000 (UTC)
Date:   Thu, 18 Mar 2021 15:18:02 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests RFC 1/2] scripts: Check kvm availability by
 asking qemu
Message-ID: <20210318141802.q5lntsxt4kywolut@kamzik.brq.redhat.com>
References: <20210318124500.45447-1-frankja@linux.ibm.com>
 <20210318124500.45447-2-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318124500.45447-2-frankja@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:44:59PM +0000, Janosch Frank wrote:
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5997e384..8cc9a61e 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -342,8 +342,11 @@ trap_exit_push ()
>  
>  kvm_available ()
>  {
> -	[ -c /dev/kvm ] ||
> -		return 1
> +	if $($qemu -accel kvm 2> /dev/null); then
> +		return 0;
> +	else
> +		return 1;
> +	fi
>

Hi Janosch,

Are we sure that even old QEMU supports this type of probing? If not,
then we should probably keep the /dev/kvm test as a fallback.

Thanks,
drew

