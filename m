Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01B1227993
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 09:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgGUHhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 03:37:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725984AbgGUHhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 03:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595317021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=oksf99ITGFpbsCHdjOcyrbcdYJuUicm3jnYnD8JMZPw=;
        b=Xc8olk5TaJLIcJi0M7jryhMNiGuumhXE7ZFoCbJim0KVtba1393cfeo4exOjoo/Og3XVwF
        pNYQL6k8mnwF24ysyhfLZn7mvUcczxnmrO8/QDDMxZQbldepQ2Vfs1L+0Fg5Fwoo+f1roB
        8Rkf/+dsMDwdSXbdnzFtBSRn2l1a5Uw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-pxUnVv55PK-VXV8JQBcHxA-1; Tue, 21 Jul 2020 03:36:59 -0400
X-MC-Unique: pxUnVv55PK-VXV8JQBcHxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9211C800466;
        Tue, 21 Jul 2020 07:36:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-102.ams2.redhat.com [10.36.112.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 261211001B2C;
        Tue, 21 Jul 2020 07:36:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Ultavisor guest API test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-4-frankja@linux.ibm.com>
 <20200720133559.69898-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <73b1afb9-b4ce-7e1b-a8d2-15b642dea803@redhat.com>
Date:   Tue, 21 Jul 2020 09:36:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200720133559.69898-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/07/2020 15.35, Janosch Frank wrote:
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
>  s390x/uv-guest.c    | 158 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 230 insertions(+)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c
[...]
> +int main(void)
> +{
> +	bool has_uvc = test_facility(158);
> +
> +	report_prefix_push("uvc");
> +	if (!has_uvc) {
> +		report_skip("Ultravisor call facility is not available");
> +		goto done;
> +	}
> +
> +	page = (unsigned long)alloc_page();
> +	test_priv();
> +	test_invalid();
> +	test_query();
> +	test_sharing();
> +	free_page((void *)page);
> +done:

It likely does not matter much, but for cleanliness, please add a
report_prefix_pop() here.

> +	return report_summary();
> +}
> 

 Thomas

