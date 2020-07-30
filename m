Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040FC2330DA
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 13:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgG3LR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 07:17:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54222 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726367AbgG3LR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 07:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596107876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWmDyEUJNIWGFgAmxoCDd0Zsu8Ym8vYf2vNm/NuhUkQ=;
        b=IK3yXUqoHTkK2q+IoQylV5Si+YqbDXgASrfmoeq1M/x//xDxM6CN2XaRbubGPdQrfsrsgG
        yyI0tpy2zKf155IO1vC3AOZBuxrSduNv+dX7bWuzGEU/8X17mRYU9bdBTcUlRz16sxhbX0
        SmSvG1R/pnfnSooll+hIbTqI5xMs504=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-iJezKbNFOuCUc0AwNLjD2A-1; Thu, 30 Jul 2020 07:17:52 -0400
X-MC-Unique: iJezKbNFOuCUc0AwNLjD2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0766E102C7E9;
        Thu, 30 Jul 2020 11:17:51 +0000 (UTC)
Received: from gondolin (ovpn-112-203.ams2.redhat.com [10.36.112.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 956361001B2C;
        Thu, 30 Jul 2020 11:17:46 +0000 (UTC)
Date:   Thu, 30 Jul 2020 13:16:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
Message-ID: <20200730131617.7f7d5e5f.cohuck@redhat.com>
In-Reply-To: <20200727095415.494318-4-frankja@linux.ibm.com>
References: <20200727095415.494318-1-frankja@linux.ibm.com>
        <20200727095415.494318-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jul 2020 05:54:15 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Test the error conditions of guest 2 Ultravisor calls, namely:
>      * Query Ultravisor information
>      * Set shared access
>      * Remove shared access
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/unittests.cfg |   3 +
>  s390x/uv-guest.c    | 159 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 231 insertions(+)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c
> 

(...)

> +static inline int uv_call(unsigned long r1, unsigned long r2)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> +		"		brc	3,0b\n"
> +		"		ipm	%[cc]\n"
> +		"		srl	%[cc],28\n"
> +		: [cc] "=d" (cc)
> +		: [r1] "a" (r1), [r2] "a" (r2)
> +		: "memory", "cc");
> +	return cc;
> +}

This returns the condition code, but no caller seems to check it
(instead, they look at header.rc, which is presumably only set if the
instruction executed successfully in some way?)

Looking at the kernel, it retries for cc > 1 (presumably busy
conditions), and cc != 0 seems to be considered a failure. Do we want
to look at the cc here as well?

(...)

