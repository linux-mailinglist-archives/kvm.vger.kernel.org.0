Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F774489F
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjGALC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjGALCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED512199C
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688209327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWFrHF6Dr6V3iHijCVqltW9v2PX7AZPlUbvJxD37MJw=;
        b=dsNvbiy2G73Md1qsMAvOCYlBz0ZELyQRDB1sFn98l9L8PovrUmmsHN8Gz+qOPxfFi4lF5C
        XM4StXhzN80FG3nwRoi0zvpN7s/sg7aSysw4/o5MPEcNb8Zl9ybLZcvw42zRIfFEh4Y052
        kzHXmwGRnfEXpsI27+GMUdXwc/ZqVAg=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-grkSdHmJOhKD6M61aYhFrg-1; Sat, 01 Jul 2023 07:02:07 -0400
X-MC-Unique: grkSdHmJOhKD6M61aYhFrg-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-43f448bda08so355047137.1
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 04:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688209326; x=1690801326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWFrHF6Dr6V3iHijCVqltW9v2PX7AZPlUbvJxD37MJw=;
        b=Lj/7Nh8oHKTKHxi4k7u8IcnNnnoEEcljlsnaDyu2JXmHMgB3Yu6UHSw/6q8wY6y0jl
         S5rkmpJEj88XTkv92rgJdgDqbbHB1zFc3RyVoqoKAiLBQOvwh848hitPaxaL4JJmKJp8
         VNu3DsCUFQ2DoyfeGLPwJVYVbKeF9hxUhl0SHBtlSxRBCscB/5VG2gLeDEGaJnDdUWJO
         pr8pPnA+gQFyCwsd1sAYB1302hCdWpAtnUuVb0YHFAHALTcDxM+wvScs2hnAkXG2tlVW
         fyRT8Bw4pdCaDxOxPUwoeN9TyAt+mMUBf363i2piqRf6i8rYx675rO2Xgdmgf/wZnnU4
         orBg==
X-Gm-Message-State: ABy/qLYmRWa/bhPWEflbRHVSM981ricQmkVLJk7/lkMJ2FYyiG6EqPAO
        Nd8SOCVXa1IJ+GHPJVXS3BR3gmW8eFvYsOHOC5BCkAus3ezZUKdDTsc/wMVTFGPctwDVBoMySYS
        de4sMDjSO92OwCOivWTIYrIc7rLHz
X-Received: by 2002:a05:6102:4a6:b0:443:6457:101 with SMTP id r6-20020a05610204a600b0044364570101mr3130133vsa.7.1688209325949;
        Sat, 01 Jul 2023 04:02:05 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF+VU8iIum472/PFzjbBHx+z3ddIX8eL5RhfRSPX96iQOSLfYp9Wiy7Z02MzMj0/uHNrmwjItkIBYcBw5vIssE=
X-Received: by 2002:a05:6102:4a6:b0:443:6457:101 with SMTP id
 r6-20020a05610204a600b0044364570101mr3130122vsa.7.1688209325635; Sat, 01 Jul
 2023 04:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230621153227.57250-1-frankja@linux.ibm.com>
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 1 Jul 2023 13:01:54 +0200
Message-ID: <CABgObfYJeU5kvwVgS_5bwHrSrnRdW0CD3fXQWXxtXigehd8qag@mail.gmail.com>
Subject: Re: [GIT PULL 00/11] kvm: s390: Changes for 6.5
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, pmorel@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 5:36=E2=80=AFPM Janosch Frank <frankja@linux.ibm.co=
m> wrote:
>
> Dear Paolo,
>
> here are the patches for 6.5 (or later):
> ~80% of the code is a new CMM selftest by Nico.
> ~19% of the code is Steffen's additions to the uvdevice introducing the U=
V secret API.
> The rest are a couple of fixes that we picked up along the way.
>
> I plan to remove the ifdefs and the PROTECTED_VIRTUALIZATION_GUEST
> config in the (near) future so we won't run into the linking problems
> that plagued the uvdevice patches anymore.
>
>
> Please pull:
> The following changes since commit f1fcbaa18b28dec10281551dfe6ed3a3ed80e3=
d6:
>
>   Linux 6.4-rc2 (2023-05-14 12:51:40 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.5-1
>
> for you to fetch changes up to db54dfc9f71cd2df7afd1e88535ef6099cb0333e:
>
>   s390/uv: Update query for secret-UVCs (2023-06-16 11:08:09 +0200)

Done, thanks.

Paolo

> ----------------------------------------------------------------
> * New uvdevice secret API
> * New CMM selftest
> * cmm fix
> * diag 9c racy access of target cpu fix
> * VSIE AP control block fix
> ----------------------------------------------------------------
>
>
> Christian Borntraeger (1):
>   KVM: s390/diag: fix racy access of physical cpu number in diag 9c
>     handler
>
> Nico Boehr (2):
>   KVM: s390: fix KVM_S390_GET_CMMA_BITS for GFNs in memslot holes
>   KVM: s390: selftests: add selftest for CMMA migration
>
> Pierre Morel (1):
>   KVM: s390: vsie: fix the length of APCB bitmap
>
> Steffen Eiden (7):
>   s390/uv: Always export uv_info
>   s390/uvdevice: Add info IOCTL
>   s390/uvdevice: Add 'Add Secret' UVC
>   s390/uvdevice: Add 'List Secrets' UVC
>   s390/uvdevice: Add 'Lock Secret Store' UVC
>   s390/uv: replace scnprintf with sysfs_emit
>   s390/uv: Update query for secret-UVCs
>
>  arch/s390/boot/uv.c                           |   4 +
>  arch/s390/include/asm/uv.h                    |  32 +-
>  arch/s390/include/uapi/asm/uvdevice.h         |  53 +-
>  arch/s390/kernel/uv.c                         | 108 ++-
>  arch/s390/kvm/diag.c                          |   8 +-
>  arch/s390/kvm/kvm-s390.c                      |   4 +
>  arch/s390/kvm/vsie.c                          |   6 +-
>  drivers/s390/char/Kconfig                     |   2 +-
>  drivers/s390/char/uvdevice.c                  | 231 +++++-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  tools/testing/selftests/kvm/s390x/cmma_test.c | 700 ++++++++++++++++++
>  11 files changed, 1100 insertions(+), 49 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/s390x/cmma_test.c
>
> --
> 2.41.0
>

