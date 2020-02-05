Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC2B15293F
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 11:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgBEKfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 05:35:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728326AbgBEKfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 05:35:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580898933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86nRbPB17Rpx5sftghR+HRhj/x2mXpTYA88mJxOXZ8M=;
        b=fOqBb0iUw1miMmCJl+qrPqJ61vNMY6AHBk8mz/7cPgjJx4dq/ViyTfl6MMdz6oDun3Jg6v
        nH8c8DQINhwxRIksyNXZyL5gPcPXOCPf/8JccOlVw+PdM0GN/5qCfa6zwd0gZZ4VHFY+rq
        xYtguppYYH/G5QjpAvjCtwbrd00alrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-m6loMD6bNWG8bYvRxfIO3A-1; Wed, 05 Feb 2020 05:35:28 -0500
X-MC-Unique: m6loMD6bNWG8bYvRxfIO3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 621B91075920;
        Wed,  5 Feb 2020 10:35:27 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EF8D60BF4;
        Wed,  5 Feb 2020 10:35:23 +0000 (UTC)
Date:   Wed, 5 Feb 2020 11:35:20 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 11/37] KVM: s390/mm: Make pages accessible before
 destroying the guest
Message-ID: <20200205113520.1a90f3d1.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-12-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-12-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:31 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Before we destroy the secure configuration, we better make all
> pages accessible again. This also happens during reboot, where we reboot
> into a non-secure guest that then can go again into a secure mode. As

s/a secure/secure/

> this "new" secure guest will have a new ID we cannot reuse the old page
> state.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/pgtable.h |  1 +
>  arch/s390/kvm/pv.c              |  2 ++
>  arch/s390/mm/gmap.c             | 35 +++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+)

(...)

> +void s390_reset_acc(struct mm_struct *mm)
> +{
> +	/*
> +	 * we might be called during
> +	 * reset:                            we walk the pages and clear
> +	 * close of all kvm file descriptor: we walk the pages and clear

s/descriptor/descriptors/

> +	 * exit of process on fd closure:    vma already gone, do nothing
> +	 */
> +	if (!mmget_not_zero(mm))
> +		return;
> +	down_read(&mm->mmap_sem);
> +	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
> +	up_read(&mm->mmap_sem);
> +	mmput(mm);
> +}
> +EXPORT_SYMBOL_GPL(s390_reset_acc);

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

