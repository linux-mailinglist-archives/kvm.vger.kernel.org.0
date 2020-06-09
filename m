Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB201F3355
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 07:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgFIFWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 01:22:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25815 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727017AbgFIFWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 01:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591680131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=WHQ8UFZ46VmZPIRBXNrYRjN+az6Pby2qoab4JPg/jJg=;
        b=KrCMZlzYjQWdPP1lb7Yf5H67H6RYGMf3gXw2TJBHwv348N1a6Tk2wxlUcu3z9m9TkmFRiA
        4Wlhf30nhKtJI29mYRW9Zk7ScQpTaMVVLSlYPtn+DmgvAvHq19Az+NcUR40CnvBNu7caJ1
        G/Gk5eRw5l2/uf4D9i+a8eg6mQwqlpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-Zr_1y2IeMC6_TyrBPWae1A-1; Tue, 09 Jun 2020 01:22:06 -0400
X-MC-Unique: Zr_1y2IeMC6_TyrBPWae1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 955A48014D4;
        Tue,  9 Jun 2020 05:22:05 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C83A60BF3;
        Tue,  9 Jun 2020 05:22:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 08/12] s390x: retrieve decimal and
 hexadecimal kernel parameters
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-9-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b013343d-d08d-43c6-1fac-f29d3070b535@redhat.com>
Date:   Tue, 9 Jun 2020 07:21:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-9-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.12, Pierre Morel wrote:
> We often need to retrieve hexadecimal kernel parameters.
> Let's implement a shared utility to do it.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/kernel-args.h | 18 +++++++++++++
>  s390x/Makefile          |  1 +
>  3 files changed, 79 insertions(+)
>  create mode 100644 lib/s390x/kernel-args.c
>  create mode 100644 lib/s390x/kernel-args.h
[...]
> +int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val)
> +{
> +	int i, ret;
> +	char *p;
> +
> +	for (i = 0; i < argc; i++) {
> +		ret = strncmp(argv[i], str, strlen(str));
> +		if (ret)
> +			continue;
> +		p = strchr(argv[i], '=');
> +		if (!p)
> +			return -1;
> +		p = strchr(p, 'x');
> +		if (!p)
> +			*val = atol(p + 1);

If p is NULL, then you call atol(NULL + 1) ... I think you need another
temporary variable here instead to hold the new pointer / NULL value?

 Thomas

