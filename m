Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE54E31527E
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 16:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhBIPQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 10:16:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232076AbhBIPQX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 10:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612883697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p3nl8khMJqHiquy1CLRZQYryAyuIGVAlN0rUYVos1sI=;
        b=JImP1RO3tqaYMg3IV+cmrpRJ27C6rvj+Ipyl4u8dVYe+RehZE51p5a9gMizrnJHJ5DZXP3
        lsi8t4xUEeTp7M4y0dhZmrl1wmRjjCRKZk83HeVmHlrUJs4oSYIE3uTqO7PH1N6uB7CRBn
        JJGTdawXb53VGsWx1hOXi8qWL0AP9JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-N8mkZGdVMnWJgYLXU-Mr7g-1; Tue, 09 Feb 2021 10:14:53 -0500
X-MC-Unique: N8mkZGdVMnWJgYLXU-Mr7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F88B1005501;
        Tue,  9 Feb 2021 15:14:52 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-56.ams2.redhat.com [10.36.114.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 296DD60C5C;
        Tue,  9 Feb 2021 15:14:46 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: Fix fpc store address in
 RESTORE_REGS_STACK
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, pmorel@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210209134925.22248-1-frankja@linux.ibm.com>
 <20210209134925.22248-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <eff04587-8499-b987-d4a8-a7a2e20fb63a@redhat.com>
Date:   Tue, 9 Feb 2021 16:14:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209134925.22248-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 14.49, Janosch Frank wrote:
> The efpc stores in bits 32-63 of a register and we store a full 8
> bytes to have the stack 8 byte aligned. This means that the fpc is
> stored at offset 4 but we load it from offset 0. Lets replace efpc
> with stfpc and get rid of the stg to store at offset 0.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   s390x/macros.S | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/s390x/macros.S b/s390x/macros.S
> index 37a6a63e..e51a557a 100644
> --- a/s390x/macros.S
> +++ b/s390x/macros.S
> @@ -54,8 +54,7 @@
>   	.endr
>   	/* Save fpc, but keep stack aligned on 64bits */
>   	slgfi   %r15, 8
> -	efpc	%r0
> -	stg	%r0, 0(%r15)
> +	stfpc	0(%r15)
>   	.endm

Reviewed-by: Thomas Huth <thuth@redhat.com>

