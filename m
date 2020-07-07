Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABE216ABF
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 12:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgGGKsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 06:48:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726763AbgGGKsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 06:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594118918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=CYp4kn0v9qGGkA1x1x5XeAFLhj/5lU53SnCPKCFhn7w=;
        b=DyK2PHvECzdtz6bYIYWTpw+dAb5Bjq+FJ/bwYCpM9Qd1ygJ/mf0UuA0h6kglCFH7YijpI3
        j2ymC34ORNh4tbYJb48OpHbl2lHoEUvCJcF9KXQ4ZKcJ4tdPOuGoK4GzRUq84K30t9J/cl
        Ga/soV0QHFWVO8uxJs6VEw02XMYCkvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-WMMdhqflOPWpkeLtLd-9qQ-1; Tue, 07 Jul 2020 06:48:36 -0400
X-MC-Unique: WMMdhqflOPWpkeLtLd-9qQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B91F1B18BD3;
        Tue,  7 Jul 2020 10:48:35 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-77.ams2.redhat.com [10.36.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 059377011F;
        Tue,  7 Jul 2020 10:48:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests v2 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200707104205.25085-1-thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <41724097-ae97-0f1c-6c76-1e5b5efaa9c6@redhat.com>
Date:   Tue, 7 Jul 2020 12:48:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200707104205.25085-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/2020 12.42, Thomas Huth wrote:
> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
> always reports the error about the missing DFP (decimal floating point)
> facility. This is kind of expected, since DFP is not required for
> running Linux and thus nobody is really interested in implementing
> this facility in TCG. Thus let's mark this as an expected error instead,
> so that we can run the kvm-unit-tests also with TCG without getting
> test failures that we do not care about.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2:
>  - Rewrote the logic, introduced expected_tcg_fail flag
>  - Use manufacturer string instead of VM name to detect TCG
> 
>  s390x/cpumodel.c | 49 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 5d232c6..190ceb2 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -11,14 +11,19 @@
>   */
>  
>  #include <asm/facility.h>
> +#include <alloc_page.h>
>  
> -static int dep[][2] = {
> +static struct {
> +	int facility;
> +	int implied;
> +	bool expected_tcg_fail;
> +} dep[] = {
>  	/* from SA22-7832-11 4-98 facility indications */
>  	{   4,   3 },
>  	{   5,   3 },
>  	{   5,   4 },
>  	{  19,  18 },
> -	{  37,  42 },
> +	{  37,  42, true },  /* TCG does not have DFP and won't get it soon */
>  	{  43,  42 },
>  	{  73,  49 },
>  	{ 134, 129 },
> @@ -38,6 +43,36 @@ static int dep[][2] = {
>  	{ 155,  77 },
>  };
>  
> +/*
> + * A hack to detect TCG (instead of KVM): QEMU uses "TCGguest" as guest
> + * name by default when we are running with TCG (otherwise it's "KVMguest")

I forgot to update the comment, it rather should read: "A hack to detect
TCG (instead of KVM): Check the manufacturer string which differs
between TCG and KVM." (or something similar)

 Thomas

