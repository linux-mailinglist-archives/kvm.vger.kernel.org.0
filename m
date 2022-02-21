Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A14BE36E
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344136AbiBUIl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:41:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbiBUIl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:41:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D5A2F72
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 00:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645432862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hlVYcns2i3en8sGN/yDBFkiICoX0EipiI4snoHN5pA0=;
        b=BzHOp0CwSN+GHwJiHpeUUhAJmnbaQZvkmyw80955mJWSoIcV8svWTnb4BLgJnJJUwfMB6l
        Nf8XbKF9Hxu03zJHx/+aihVtax5V+cY4X7TCAhzly2rh2qdZEb6i4KEElYmMIFpW91cl11
        4yd5I1zNgPb6DyEuHOWkhMoOnbaCaJw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-Bz0QmXYwPIGV_RMLuEurTw-1; Mon, 21 Feb 2022 03:41:00 -0500
X-MC-Unique: Bz0QmXYwPIGV_RMLuEurTw-1
Received: by mail-ej1-f72.google.com with SMTP id sa7-20020a170906eda700b006d1b130d65bso444270ejb.13
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 00:41:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hlVYcns2i3en8sGN/yDBFkiICoX0EipiI4snoHN5pA0=;
        b=skIcuQYeS6SL144XZVQCZEu5W4tWfGZyzaauw/Xy2KWUo6FJjvZx4fS3/nHCkUgxjm
         IzZGO+nis0SGhhAb9UZNeqdDLveuTecpMNdSS8LzpGhOiFWB5y+2Vw2KBnBmhj99FPNJ
         t6B9T230rxkUOAVoqEWeIzA6+25xJ/4wtoJ6avfiADha/hwLSYmzqjfGCj0gAHnqmnJ9
         T4h24FcEvpptFRWTqIqmwnD/r/fjoBHqBI8pYGeHL6ZGZ2epd51nO/Cj1l1OudPk95Nh
         A9yORhA8AFVHs/5UN5z5xhCSa+EJcVEFHp3w+mqWq2JCU6uNWkYKBgMUUFrRWDxKj/hf
         Hg9A==
X-Gm-Message-State: AOAM531G2u/j4QO0vyN58S6IqYDQF3tHza1aUVvMW6rW0Oy28Y6TCKRa
        XYGSiV4pvOxrQ11e9wgBh+CnUOCENttWaJN0Mpb4f3+Lq1O1pR+1Xn4unQ3KMGPYIi9RB9KLVCx
        Sa62fPQRhp73n
X-Received: by 2002:a05:6402:278b:b0:412:80a5:6cb3 with SMTP id b11-20020a056402278b00b0041280a56cb3mr20236233ede.157.1645432859089;
        Mon, 21 Feb 2022 00:40:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7o6Fvh4koCdX3yu1jsuz2N490Wbrrn0GSf9ZLhL7Fyo5uixeW3dIABemTCPbJHy9jPv1CNg==
X-Received: by 2002:a05:6402:278b:b0:412:80a5:6cb3 with SMTP id b11-20020a056402278b00b0041280a56cb3mr20236213ede.157.1645432858870;
        Mon, 21 Feb 2022 00:40:58 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id v23sm5011138ejy.178.2022.02.21.00.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 00:40:58 -0800 (PST)
Date:   Mon, 21 Feb 2022 09:40:56 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v1 0/3] x86 UEFI: pass envs and args
Message-ID: <20220221084056.edgpsgqdm2xph4kv@gator>
References: <20220220224234.422499-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220224234.422499-1-zxwang42@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 20, 2022 at 02:42:31PM -0800, Zixuan Wang wrote:
> Hello,
> 
> This patch series enables kvm-unit-tests to get envs and args under
> UEFI. The host passes envs and args through files:
> 
> 1. The host stores envs into ENVS.TXT and args into ARGS.TXT

EFI already has support for an environment and EFI apps can accept args.
Why not find a way to convert kvm-unit-tests ENV and unit tests args
into the EFI system and then use that?

efi_setup_argv()[*] in my original PoC does that. It uses gnu-efi, but
it should be easy to strip away the gnu-efi stuff and go straight for
the underlining EFI functions.

[*] https://github.com/rhdrjones/kvm-unit-tests/commit/12a49a2e97b457e23af10bb25cd972362b379951#:~:text=static%20void%20efi_setup_argv(EFI_HANDLE%20Image%2C%20EFI_SYSTEM_TABLE%20*SysTab)

If you want to mimic efi_setup_argv(), then you'll also need 85baf398
("lib/argv: Allow environ to be primed") from that same branch.

EFI wrapper scripts for each unit test can be generated to pass the args
to the unit test EFI apps automatically. For the environment, the EFI
vars can be set as usual for the system. For QEMU, that means creating
a VARS.fd and then adding another flash device to the VM to exposes it.

Thanks,
drew


> 2. The guest boots up and reads data from these files through UEFI file
> operation services
> 3. The file data is passed to corresponding setup functions
> 
> As a result, several x86 test cases (e.g., kvmclock_test and vmexit)
> can now get envs/args from the host [1], thus do not report FAIL when
> running ./run-tests.sh.
> 
> An alternative approach for envs/args passing under UEFI is to use
> QEMU's -append/-initrd options. However, this approach requires EFI
> binaries to be passed through QEMU's -kernel option. While currently,
> EFI binaries are loaded from a disk image. Changing this bootup process
> may make kvm-unit-tests (under UEFI) unable to run on bare-metal [2].
> On the other hand, passing envs/args through files should work on
> bare-metal because UEFI's file operation services do not rely on QEMU's
> functionalities, thus working on bare-metal.
> 
> The summary of this patch series:
> 
> Patch #1 pulls Linux kernel's UEFI definitions for file operations.
> 
> Patch #2 implements file read functions and envs setup functions.
> 
> Patch #3 implements the args setup functions.
> 
> Best regards,
> Zixuan
> 
> [1] https://github.com/TheNetAdmin/KVM-Unit-Tests-dev-fork/issues/8
> [2] https://lore.kernel.org/kvm/CAEDJ5ZQLm1rz+0a7MPPz3wMAoeTq2oH9z92sd0ZhCxEjWMkOpg@mail.gmail.com
> 
> Zixuan Wang (3):
>   x86 UEFI: pull UEFI definitions for file operations
>   x86 UEFI: read envs from file
>   x86 UEFI: read args from file
> 
>  lib/efi.c       | 150 ++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/linux/efi.h |  82 +++++++++++++++++++++++++-
>  x86/efi/run     |  36 +++++++++++-
>  3 files changed, 265 insertions(+), 3 deletions(-)
> 
> -- 
> 2.35.1
> 

