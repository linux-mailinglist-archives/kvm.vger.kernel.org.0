Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D58CF8BA9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 10:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfKLJ0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 04:26:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727058AbfKLJ0M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 04:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573550771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nyz0R0JFcm91sDUPNxPXHhLmYMpB12ASJ5cBmfOUd6o=;
        b=LduT4gRlFjzWQ/AYQSZxnVdT7cKLP8PgKZghMvJ/Xa2QgCsJoILJJzMc6yG/PtLg0yZihd
        8CvlRDkLIkhtBzY6Si94taxp72STqjk7qDhBA3MJt8aLgzvvMuWGAEze1+8XSmovbXA60U
        TVJMYK0+k2xze0c/1GlQpCZEatSRPac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-jlcQUFOLO-Ot6r267mUkDA-1; Tue, 12 Nov 2019 04:26:07 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53DEE91267;
        Tue, 12 Nov 2019 09:26:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B03162671;
        Tue, 12 Nov 2019 09:26:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/3] s390x: Fix initial cr0 load
 comments
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20191111153345.22505-1-frankja@linux.ibm.com>
 <20191111153345.22505-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <55d20cae-aa91-beec-a7b2-b1145b9983b0@redhat.com>
Date:   Tue, 12 Nov 2019 10:25:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191111153345.22505-2-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: jlcQUFOLO-Ot6r267mUkDA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/2019 16.33, Janosch Frank wrote:
> We need to load cr0 to have access to all fprs during save and restore
> of fprs. Saving conditionally on basis of the CR0 AFP bit would be a
> pain.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/cstart64.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 8e2b21e..043e34a 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -94,7 +94,7 @@ memsetxc:
>  =09stmg=09%r0, %r15, GEN_LC_SW_INT_GRS
>  =09/* save cr0 */
>  =09stctg=09%c0, %c0, GEN_LC_SW_INT_CR0
> -=09/* load initial cr0 again */
> +=09/* load a cr0 that has the AFP control bit which enables all FPRs */
>  =09larl=09%r1, initial_cr0
>  =09lctlg=09%c0, %c0, 0(%r1)
>  =09/* save fprs 0-15 + fpc */
> @@ -139,7 +139,7 @@ diag308_load_reset:
>  =09xgr=09%r2, %r2
>  =09br=09%r14
>  =09/* Success path */
> -=09/* We lost cr0 due to the reset */
> +=09/* load a cr0 that has the AFP control bit which enables all FPRs */
>  0:=09larl=09%r1, initial_cr0
>  =09lctlg=09%c0, %c0, 0(%r1)
>  =09RESTORE_REGS
>=20

Reviewed-by: Thomas Huth <thuth@redhat.com>

