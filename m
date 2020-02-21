Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC3E167D9C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 13:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgBUMjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 07:39:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727039AbgBUMjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 07:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582288783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=an3vPyEPyM+bgUqsN4JI9epzCRTa1Pfhj2p4o8nTTOY=;
        b=i9KBbPY8sRZTAYC2mkS2MQwvWQg9bTBw15vV9NOk+j9KyQ2epIvicz+7GfAvlnt7d4P7ie
        a9EJTqEkw/jQJ8Xbviok/tIrVfD3ecnsYndZ9oTARoizRVAJAlOcJ0CnSH/R7jV0JAfcz/
        FxJKXMXWsgauTVWcUwQEYfE3Fp2BYWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277--cotsxi2N5GPbRl4x_SlDg-1; Fri, 21 Feb 2020 07:39:39 -0500
X-MC-Unique: -cotsxi2N5GPbRl4x_SlDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12BC41B18BC1;
        Fri, 21 Feb 2020 12:39:38 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6F725C1B0;
        Fri, 21 Feb 2020 12:39:33 +0000 (UTC)
Date:   Fri, 21 Feb 2020 13:39:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v3 03/37] s390/protvirt: introduce host side setup
Message-ID: <20200221133931.043a7bbb.cohuck@redhat.com>
In-Reply-To: <20200220104020.5343-4-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
        <20200220104020.5343-4-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Feb 2020 05:39:46 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at early boot time. This has to be
> done early, because it needs large amounts of memory and will disable
> some features like STP time sync for the lpar.
> 
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++
>  arch/s390/boot/Makefile                       |  2 +-
>  arch/s390/boot/uv.c                           | 21 +++++++-
>  arch/s390/include/asm/uv.h                    | 46 +++++++++++++++-
>  arch/s390/kernel/Makefile                     |  1 +
>  arch/s390/kernel/setup.c                      |  4 --
>  arch/s390/kernel/uv.c                         | 52 +++++++++++++++++++
>  7 files changed, 123 insertions(+), 8 deletions(-)
>  create mode 100644 arch/s390/kernel/uv.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

