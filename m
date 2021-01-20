Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D152FCEEC
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388938AbhATLOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 06:14:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388211AbhATKu3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 05:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611139743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RvHvFu8tLMqu5uqkDtNhlThCTmTs4Eu9AXXwvK/+6BQ=;
        b=hg+O8yvq9QqUeaRN1z17JsUcKisAcqXXIqLGgIKg0z7qPG6fmgJWLXguefUwC/6KB1+Bex
        xn5tZWrEitpnRmU/qwvZeuUQn7yf1a2asHa43syOnbk3jMWjO03indDD7G7RvswPb2ffJY
        ZmOpONiJ4GNpwft42gQVH77Jk/SfVQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-ZE9jRAHPM7K_6X7ikR51MQ-1; Wed, 20 Jan 2021 05:48:59 -0500
X-MC-Unique: ZE9jRAHPM7K_6X7ikR51MQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62273107ACE3;
        Wed, 20 Jan 2021 10:48:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-135.ams2.redhat.com [10.36.114.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40B1260916;
        Wed, 20 Jan 2021 10:48:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: pv: implement routine to
 share/unshare memory
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-2-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <211a4bd3-763a-f8fc-3c08-8d8d1809cc7c@redhat.com>
Date:   Wed, 20 Jan 2021 11:48:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611085944-21609-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/01/2021 20.52, Pierre Morel wrote:
> When communicating with the host we need to share part of
> the memory.
> 
> Let's implement the ultravisor calls for this.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/s390x/asm/uv.h | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 4c2fc48..1242336 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -71,4 +71,42 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>   	return cc;
>   }
>   
> +static inline int share(unsigned long addr, u16 cmd)
> +{
> +	struct uv_cb_share uvcb = {
> +		.header.cmd = cmd,
> +		.header.len = sizeof(uvcb),
> +		.paddr = addr
> +	};
> +	int cc;
> +
> +	cc = uv_call(0, (u64)&uvcb);
> +	if (!cc && (uvcb.header.rc == 0x0001))

You can drop the innermost parentheses.

> +		return 0;
> +
> +	report_info("cc %d response code: %04x", cc, uvcb.header.rc);
> +	return -1;
> +}
> +
> +/*
> + * Guest 2 request to the Ultravisor to make a page shared with the
> + * hypervisor for IO.
> + *
> + * @addr: Real or absolute address of the page to be shared

When is it real, and when is it absolute?

> + */
> +static inline int uv_set_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
> +}
> +
> +/*
> + * Guest 2 request to the Ultravisor to make a page unshared.
> + *
> + * @addr: Real or absolute address of the page to be unshared

dito

> + */
> +static inline int uv_remove_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
> +}
> +
>   #endif

Apart from the nits:
Acked-by: Thomas Huth <thuth@redhat.com>

