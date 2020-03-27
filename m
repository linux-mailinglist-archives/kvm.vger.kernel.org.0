Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8BA195574
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 11:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgC0KkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 06:40:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:23647 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgC0KkG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 06:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585305606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bAx4LSiTVAe+JJHOMS6mf3dp81QI1Kq6wFsxM3gKX/o=;
        b=ZbCgyWAoO3LpBOJZpm/rFRnm4X/lme0T6j7IjPtjWPWNDbb8NYevdLASY7twIHipJ+e1XZ
        h7Cg0UxJYaOhfzZVQpcNkK0PTy0zFnF4LCvVuuce9I1EEyoDg7tMLoV/xgGmHZsACX5+Tz
        J/9gDSjsFwXHnsgACzOuiQRhksaVLeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-UtBVHiIzNF2CfGc-jV1OXA-1; Fri, 27 Mar 2020 06:40:02 -0400
X-MC-Unique: UtBVHiIzNF2CfGc-jV1OXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD92DBA5;
        Fri, 27 Mar 2020 10:40:01 +0000 (UTC)
Received: from gondolin (ovpn-113-83.ams2.redhat.com [10.36.113.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 369F65C1BA;
        Fri, 27 Mar 2020 10:39:57 +0000 (UTC)
Date:   Fri, 27 Mar 2020 11:39:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] s390/gmap: return proper error code on ksm unsharing
Message-ID: <20200327113954.6d7c31e6.cohuck@redhat.com>
In-Reply-To: <859b9810-eb50-6f81-ec12-3f22cc5c1d2c@de.ibm.com>
References: <20200327092356.25171-1-borntraeger@de.ibm.com>
        <859b9810-eb50-6f81-ec12-3f22cc5c1d2c@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Mar 2020 11:23:33 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 27.03.20 10:23, Christian Borntraeger wrote:

> After the qemu patch discussion I would add
> 
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0e268b3d1591..ba8f9cbe4376 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4680,6 +4680,12 @@ KVM_PV_ENABLE
>    command has succeeded, any CPU added via hotplug will become
>    protected during its creation as well.
>  
> +  Errors:
> +
> +  =====      =============================
> +  EINTR      an unmasked signal is pending
> +  =====      =============================
> +
>  KVM_PV_DISABLE
>  
>    Deregister the VM from the Ultravisor and reclaim the memory that
> 
> 
> and change the patch description to something like
> 
> 
>     s390/gmap: return proper error code on ksm unsharing
>     
>     If a signal is pending we might return -ENOMEM instead of -EINTR.
>     We should propagate the proper error during KSM unsharing.
>     unmerge_ksm_pages returns -ERESTARTSYS on signal_pending. This gets
>     translated by entry.S to -EINTR. It is important to get this error
>     code so that userspace can retry.
>     
>     Fixes: 3ac8e38015d4 ("s390/mm: disable KSM for storage key enabled pages")
>     Reviewed-by: Janosch Frank <frankja@linux.vnet.ibm.com>
>     Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>     Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>     Reviewed-by: David Hildenbrand <david@redhat.com>
>     Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 

LGTM

