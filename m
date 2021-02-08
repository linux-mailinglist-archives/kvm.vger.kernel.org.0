Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803AF312A63
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBHGDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:03:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhBHGDu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 01:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612764144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2vTx3E0J0H2n7/sE7CO0zfIM3AOiTiPE3jhEp65l0w=;
        b=GcaqLGipXsJV2awGd1DmENDQ9OrNOAevOI4GqybSpx+QQCrGysm0YWiP4jPmUH655M33Di
        IFffg9k90Goz+LeCPQbcYv0Va3AlbASN3zoIxI99u9qrGNFuI/uiWt1W7WKzsBD87iIDvU
        Y33cSVHOc5g2KYwI9X46Nzx0nrpfcJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-gszUxB_rN16WpLacviXxqw-1; Mon, 08 Feb 2021 01:02:22 -0500
X-MC-Unique: gszUxB_rN16WpLacviXxqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 274561020C20;
        Mon,  8 Feb 2021 06:02:21 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B60C1002388;
        Mon,  8 Feb 2021 06:02:15 +0000 (UTC)
Subject: Re: [RFC v2 0/4] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
References: <cover.1611850290.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3bf222a2-1ce4-9732-1c1d-113333b6271f@redhat.com>
Date:   Mon, 8 Feb 2021 14:02:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1611850290.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/29 上午2:32, Elena Afanasova wrote:
> This patchset introduces a KVM dispatch mechanism which can be used
> for handling MMIO/PIO accesses over file descriptors without returning
> from ioctl(KVM_RUN). This allows device emulation to run in another task
> separate from the vCPU task.
>
> This is achieved through KVM vm ioctl for registering MMIO/PIO regions and
> a wire protocol that KVM uses to communicate with a task handling an
> MMIO/PIO access.
>
> TODOs:
> * Implement KVM_EXIT_IOREGIONFD_FAILURE
> * Add non-x86 arch support
> * Add kvm-unittests


It would be better to log the changes between versions to ease the 
reviewers.

Tanks


>
> Elena Afanasova (4):
>    KVM: add initial support for KVM_SET_IOREGION
>    KVM: x86: add support for ioregionfd signal handling
>    KVM: add support for ioregionfd cmds/replies serialization
>    KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled
>
>   arch/x86/kvm/Kconfig          |   1 +
>   arch/x86/kvm/Makefile         |   1 +
>   arch/x86/kvm/x86.c            | 216 ++++++++++++++-
>   include/kvm/iodev.h           |  14 +
>   include/linux/kvm_host.h      |  34 +++
>   include/uapi/linux/ioregion.h |  32 +++
>   include/uapi/linux/kvm.h      |  23 ++
>   virt/kvm/Kconfig              |   3 +
>   virt/kvm/eventfd.c            |  25 ++
>   virt/kvm/eventfd.h            |  14 +
>   virt/kvm/ioregion.c           | 479 ++++++++++++++++++++++++++++++++++
>   virt/kvm/ioregion.h           |  15 ++
>   virt/kvm/kvm_main.c           |  68 ++++-
>   13 files changed, 905 insertions(+), 20 deletions(-)
>   create mode 100644 include/uapi/linux/ioregion.h
>   create mode 100644 virt/kvm/eventfd.h
>   create mode 100644 virt/kvm/ioregion.c
>   create mode 100644 virt/kvm/ioregion.h
>

