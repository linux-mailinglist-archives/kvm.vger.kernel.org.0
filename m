Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5C132D2EB
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 13:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbhCDM2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 07:28:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240546AbhCDM2Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 07:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614860818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GV+/hvLdgVZKvT1Z0TKqGD9Co1FMVPmtvKNuz0pZAyQ=;
        b=Pgf8l9Y0hBUSAkYdko00Er/3y9IGO2oTw0iprDbeR/B06vQQHycz0cd3hJTwDcdXjJTfhn
        vD37VOm5egqJ1zCJ/PMXHeoTQH31tsVYUhlYcAoEwEFSeoeFqSjPtikdm623xRCLiJ935Z
        Ax/FeojxJnzCCbiRTy71BHZ6naNv4tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-liIo97nSM8uWX7TMKGzUvA-1; Thu, 04 Mar 2021 07:26:55 -0500
X-MC-Unique: liIo97nSM8uWX7TMKGzUvA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A76F284B7D8;
        Thu,  4 Mar 2021 12:26:53 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DA46100E114;
        Thu,  4 Mar 2021 12:26:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: Move diag308_load_reset to
 stack saving
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210222085756.14396-1-frankja@linux.ibm.com>
 <20210222085756.14396-7-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c26c5d2f-5111-af3e-abde-234f199decc3@redhat.com>
Date:   Thu, 4 Mar 2021 13:26:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222085756.14396-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2021 09.57, Janosch Frank wrote:
> By moving the last user of SAVE/RESTORE_REGS to the macros that use
> the stack we can finally remove these macros.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   s390x/cpu.S | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/cpu.S b/s390x/cpu.S
> index 5267f029..e2ad56c8 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu.S
> @@ -18,7 +18,7 @@
>    */
>   .globl diag308_load_reset
>   diag308_load_reset:
> -	SAVE_REGS
> +	SAVE_REGS_STACK
>   	/* Backup current PSW mask, as we have to restore it on success */
>   	epsw	%r0, %r1
>   	st	%r0, GEN_LC_SW_INT_PSW
> @@ -31,6 +31,7 @@ diag308_load_reset:
>   	ogr	%r0, %r1
>   	/* Store it at the reset PSW location (real 0x0) */
>   	stg	%r0, 0
> +	stg     %r15, GEN_LC_SW_INT_GRS + 15 * 8
>   	/* Do the reset */
>   	diag    %r0,%r2,0x308
>   	/* Failure path */
> @@ -40,7 +41,8 @@ diag308_load_reset:
>   	/* load a cr0 that has the AFP control bit which enables all FPRs */
>   0:	larl	%r1, initial_cr0
>   	lctlg	%c0, %c0, 0(%r1)
> -	RESTORE_REGS
> +	lg      %r15, GEN_LC_SW_INT_GRS + 15 * 8
> +	RESTORE_REGS_STACK
>   	lhi	%r2, 1
>   	larl	%r0, 1f
>   	stg	%r0, GEN_LC_SW_INT_PSW + 8
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

