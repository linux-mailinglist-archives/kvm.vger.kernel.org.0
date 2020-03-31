Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2132D198C86
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 08:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgCaGt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 02:49:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37698 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgCaGt2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 02:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585637367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vr+P7AE3WRAzHQofs1wx/Zyi3JrkyQjOoO1yXG2SIk=;
        b=gJC2YPXRX/iXR40Y/+q0QP5/vQeXT28cvxSkZAs9Hle1Y1Q0xuQ3pPTrYhosM4MNjZIfqf
        K5P4s52GDv556HbElCubDKVgIqgOSielDz+o4tptbcZ7t67EFbGfU7lPs9egAlpTndKMJk
        /WotdMpCgTKS45zwX+/Bx4+/M+UfS1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-EYXG8K8OP7Gw_3ldLJlmVw-1; Tue, 31 Mar 2020 02:49:25 -0400
X-MC-Unique: EYXG8K8OP7Gw_3ldLJlmVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F991107ACC9;
        Tue, 31 Mar 2020 06:49:24 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 766DA19C6A;
        Tue, 31 Mar 2020 06:49:20 +0000 (UTC)
Date:   Tue, 31 Mar 2020 08:49:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests 1/2] s390x/smp: fix detection of "running"
Message-ID: <20200331084917.4ab3f405.cohuck@redhat.com>
In-Reply-To: <20200330084911.34248-2-borntraeger@de.ibm.com>
References: <20200330084911.34248-1-borntraeger@de.ibm.com>
        <20200330084911.34248-2-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Mar 2020 04:49:10 -0400
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On s390x hosts with a single CPU, the smp test case hangs (loops).
> The check is our restart has finished is wrong.

s/is/if/

> Sigp sense running status checks if the CPU is currently backed by a
> real CPU. This means that on single CPU hosts a sigp sense running
> will never claim that a target is running. We need to check for not
> being stopped instead.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  lib/s390x/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 2555bf4..5ed8b7b 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -128,7 +128,7 @@ static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
>  	 * The order has been accepted, but the actual restart may not
>  	 * have been performed yet, so wait until the cpu is running.
>  	 */
> -	while (!smp_cpu_running(addr))
> +	while (smp_cpu_stopped(addr))
>  		mb();
>  	cpu->active = true;
>  	return 0;

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

