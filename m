Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D80698246
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjBORgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBORgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:36:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD3C44A3
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676482559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WO+XysgspF8DqSG5kDwuRcRoRdFcJUc3Wr5oeGuvwGQ=;
        b=eIVqVXxuW1BxirBFY3CXKtgcapnKVKch2dczsLffQMN4JZWC6xT1vqdQMmNdvWoDqXZ6Qv
        yb5UF316gU47Ew+bZggM1HGqmMG6hLc44Yx6/I/ikgJTPocGqBv12gRLk6brIPFpqWAtfi
        KdXXrA6RXKsXJkhKUL3askwszgKRtRM=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-xT_pIljfN3mtvhq66HGRtA-1; Wed, 15 Feb 2023 12:35:57 -0500
X-MC-Unique: xT_pIljfN3mtvhq66HGRtA-1
Received: by mail-ua1-f69.google.com with SMTP id f6-20020ab03d06000000b0068a65937391so4098105uax.6
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WO+XysgspF8DqSG5kDwuRcRoRdFcJUc3Wr5oeGuvwGQ=;
        b=QfG5iebUYRMz+KGhqWr1AV+MCpOLZ3NWeN7KMr7AqG7K3dB+B3pcUw1GClq8n+b8lR
         uZBDEy8tsCQnTEBBIyvK2e5dBE6AYLtUKGW27PLTh/QMvlBP5nZFOOxCZIQfr9wtZYra
         Kr5xtL0ZM8iMoV+og+e4olD3Zf2n+Bfxw8MBYDNtfn6nFdwOY+tQTnBRYczDm+MJbwct
         AbK6ZX6zOi5dskfmiOQrEdk7Ww9DQgE06GgJU0n08FY34CtbjKo7H+LxL+touz2zFDii
         DoeOStSRu9UfOAMZ7xDG8vKgGjbO+HaUfSIwcXayvROPcZniEvHyaDkHw43wA/kMOb6p
         D7LA==
X-Gm-Message-State: AO0yUKXQ4RDxfNKSK3EMO7L/XdeY9dA4yxe4CCgZTaJbfjdVBEvQ0Psz
        W90QI7OtfdlOd0QhMB8Vo5LEl2LU7iujtKE5yaVFtftgTlWBcsRA23xxezXKJZxkfqv06UNc3l+
        9k4gRDIV+mdCcP5M++Ayr4JgKVlj5
X-Received: by 2002:a05:6102:5c17:b0:412:c97:4ac8 with SMTP id ds23-20020a0561025c1700b004120c974ac8mr502129vsb.53.1676482556701;
        Wed, 15 Feb 2023 09:35:56 -0800 (PST)
X-Google-Smtp-Source: AK7set8L0sjCkHm2xvfBfZvyQXKAczVR+gQk4t1ZdDhxtXnBjH9xoR9zAR7+Oh0qJAyco9BvrbRFrWse2QE/MMpxhPA=
X-Received: by 2002:a05:6102:5c17:b0:412:c97:4ac8 with SMTP id
 ds23-20020a0561025c1700b004120c974ac8mr502125vsb.53.1676482556440; Wed, 15
 Feb 2023 09:35:56 -0800 (PST)
MIME-Version: 1.0
References: <20230209102300.12254-1-frankja@linux.ibm.com>
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 15 Feb 2023 18:35:45 +0100
Message-ID: <CABgObfbj2GGHxHefb9jdXar3YKMYJxBjJBwzTXhntUQE-xjBNA@mail.gmail.com>
Subject: Re: [GIT PULL 00/18] KVM: s390x: KVM s390x changes for 6.3
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, hca@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 9, 2023 at 11:25 AM Janosch Frank <frankja@linux.ibm.com> wrote:
>
> Hi Paolo,
>
> the following changes are ready for pulling for 6.3:
> * Two more V!=R patches
> * The last part of the cmpxchg patches
> * A few fixes
>
> This pull includes the s390 cmpxchg_user_key feature branch which is
> the base for the KVM cmpxchg patches by Janis.

Pulled, thanks,

Paolo

> Cheers,
> Janosch
>
> The following changes since commit a2ce98d69fabc7d3758063366fe830f682610cf7:
>
>   Merge remote-tracking branch 'l390-korg/cmpxchg_user_key' into kvm-next (2023-02-07 18:04:23 +0100)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.3-1
>
> for you to fetch changes up to 5fc5b94a273655128159186c87662105db8afeb5:
>
>   s390/virtio: sort out physical vs virtual pointers usage (2023-02-08 09:59:46 +0100)
>
> ----------------------------------------------------------------
>
> Alexander Gordeev (1):
>   s390/virtio: sort out physical vs virtual pointers usage
>
> Janis Schoetterl-Glausch (14):
>   KVM: s390: selftest: memop: Pass mop_desc via pointer
>   KVM: s390: selftest: memop: Replace macros by functions
>   KVM: s390: selftest: memop: Move testlist into main
>   KVM: s390: selftest: memop: Add bad address test
>   KVM: s390: selftest: memop: Fix typo
>   KVM: s390: selftest: memop: Fix wrong address being used in test
>   KVM: s390: selftest: memop: Fix integer literal
>   KVM: s390: Move common code of mem_op functions into function
>   KVM: s390: Dispatch to implementing function at top level of vm mem_op
>   KVM: s390: Refactor absolute vm mem_op function
>   KVM: s390: Refactor vcpu mem_op function
>   KVM: s390: Extend MEM_OP ioctl by storage key checked cmpxchg
>   Documentation: KVM: s390: Describe KVM_S390_MEMOP_F_CMPXCHG
>   KVM: s390: selftest: memop: Add cmpxchg tests
>
> Nico Boehr (2):
>   KVM: s390: disable migration mode when dirty tracking is disabled
>   KVM: s390: GISA: sort out physical vs virtual pointers usage
>
> Nina Schoetterl-Glausch (1):
>   KVM: selftests: Compile s390 tests with -march=z10
>
>  Documentation/virt/kvm/api.rst            |  46 +-
>  Documentation/virt/kvm/devices/vm.rst     |   4 +
>  arch/s390/kvm/gaccess.c                   | 109 ++++
>  arch/s390/kvm/gaccess.h                   |   3 +
>  arch/s390/kvm/interrupt.c                 |  11 +-
>  arch/s390/kvm/kvm-s390.c                  | 268 +++++----
>  drivers/s390/virtio/virtio_ccw.c          |  46 +-
>  include/uapi/linux/kvm.h                  |   8 +
>  tools/testing/selftests/kvm/Makefile      |   3 +
>  tools/testing/selftests/kvm/s390x/memop.c | 676 +++++++++++++++++-----
>  10 files changed, 889 insertions(+), 285 deletions(-)
>
> --
> 2.39.1
>

