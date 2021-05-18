Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14578387BE9
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 17:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344573AbhERPHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 11:07:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244699AbhERPHI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 11:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621350350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STXxttVWUuxEk4dKEc/75iAMgKsQFPcICY7qFMTjQ80=;
        b=PNvhvoYjuuE4ZdSgim52NMBH+eWudEeEwDgDY5hVS+sKZfrhDyPEDA7bRrgt9VzS483pkB
        iYuuN/Os4WcR6oMfF5Uge1bqrzDYmiwD4Bq82D83dC861C+xj//l4HxeRBv3zBfH/CHW9e
        VTTQmuNmF2VHZHHmoHw5kW/kPCIRa8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-6HoZWoUtPCyrttgjBR-1_A-1; Tue, 18 May 2021 11:05:48 -0400
X-MC-Unique: 6HoZWoUtPCyrttgjBR-1_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 899A0107ACFB;
        Tue, 18 May 2021 15:05:47 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-74.ams2.redhat.com [10.36.113.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7411060855;
        Tue, 18 May 2021 15:05:40 +0000 (UTC)
Date:   Tue, 18 May 2021 17:05:37 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518170537.58b32ffe.cohuck@redhat.com>
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 May 2021 22:07:47 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> Previously, when a protected VM was rebooted or when it was shut down,
> its memory was made unprotected, and then the protected VM itself was
> destroyed. Looping over the whole address space can take some time,
> considering the overhead of the various Ultravisor Calls (UVCs).  This
> means that a reboot or a shutdown would take a potentially long amount
> of time, depending on the amount of used memory.
> 
> This patchseries implements a deferred destroy mechanism for protected
> guests. When a protected guest is destroyed, its memory is cleared in
> background, allowing the guest to restart or terminate significantly
> faster than before.
> 
> There are 2 possibilities when a protected VM is torn down:
> * it still has an address space associated (reboot case)
> * it does not have an address space anymore (shutdown case)
> 
> For the reboot case, the reference count of the mm is increased, and
> then a background thread is started to clean up. Once the thread went
> through the whole address space, the protected VM is actually
> destroyed.
> 
> For the shutdown case, a list of pages to be destroyed is formed when
> the mm is torn down. Instead of just unmapping the pages when the
> address space is being torn down, they are also set aside. Later when
> KVM cleans up the VM, a thread is started to clean up the pages from
> the list.

Just to make sure, 'clean up' includes doing uv calls?

> 
> This means that the same address space can have memory belonging to
> more than one protected guest, although only one will be running, the
> others will in fact not even have any CPUs.

Are those set-aside-but-not-yet-cleaned-up pages still possibly
accessible in any way? I would assume that they only belong to the
'zombie' guests, and any new or rebooted guest is a new entity that
needs to get new pages?

Can too many not-yet-cleaned-up pages lead to a (temporary) memory
exhaustion?

