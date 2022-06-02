Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163AE53B912
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiFBMmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 08:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiFBMmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 08:42:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DD77DF61
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 05:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654173726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nBg/5xRiU6uzAW+rDXEx1Vx7mG3Isn80CN+n2H1hmi8=;
        b=MaycylGIvyqxUhILXm0/9I9d7bA3lwsxiFzKwAsMRqSV7SfP9NyWLhOWwN6DCyNefIKVwI
        WA3w3iHrFGnladWadPYKy4sRhCV3PfXTwhFIWi0x+qWshtnLWcIKZep0Ze4t2ZYbtYgrdn
        KYjeSLHT9GMe/wK1efLaXGwz4PwTrfs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-mqOC-sHJMOu9P39Zo_sj6A-1; Thu, 02 Jun 2022 08:42:04 -0400
X-MC-Unique: mqOC-sHJMOu9P39Zo_sj6A-1
Received: by mail-wm1-f70.google.com with SMTP id i1-20020a05600c354100b003976fc71579so2780322wmq.8
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 05:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nBg/5xRiU6uzAW+rDXEx1Vx7mG3Isn80CN+n2H1hmi8=;
        b=XckGjUUQrxVPjpBikihFpFwwnwvYgBHUPFGLiCFVUE4ma1SwPGQE/vpC8OvCldElVs
         sak/x02KS9GDfWhdqYRi1blX/FzJD5Q6WyAEoTg10yyuKqVRtKdNzcovUcbMa96qjImD
         sNLjZfqFeuN4PTSs3jH3ZmdvMGcu0NtUz1+7FDSmGU29yTbr7SUKUqImFmVkqvjyymTa
         wkSou4Ra9hGX6Im0B18ELa3/Q8GJHe7gtpbo/P6c6/UdlTz/eKu3MBcpmoRMxjd905ET
         ph1ao9T/kITe+VhP7gPhW/MRxJ88Dj9hHZ4diDn4CgoyUSCSKRMvRuODd6vrcBL9RqnE
         BDfg==
X-Gm-Message-State: AOAM530wrCTUpXl3tmkFS0VyTYk2cA5WuU5KdRNXdR4eOwt2r7xwW3XW
        dewtx6IYEy+cjUmfZ4rsCgWoiaBLqV2FuY4kjzh6yhOp6Hxqr2DUfEhA1ErQcH+EBu/MY1ZuICy
        KKI0kHGDDrTPD
X-Received: by 2002:a05:600c:19cc:b0:39c:3022:1b23 with SMTP id u12-20020a05600c19cc00b0039c30221b23mr2289492wmq.106.1654173722483;
        Thu, 02 Jun 2022 05:42:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAjCkOgob+Eti5VchWBxPKPjO2u0agwyw0nJTIdmPiA6g2uFHVZ0eL2p/7PAqnehNluuvRAg==
X-Received: by 2002:a05:600c:19cc:b0:39c:3022:1b23 with SMTP id u12-20020a05600c19cc00b0039c30221b23mr2289476wmq.106.1654173722233;
        Thu, 02 Jun 2022 05:42:02 -0700 (PDT)
Received: from localhost (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id t12-20020a5d49cc000000b00210352bf36fsm4073875wrs.33.2022.06.02.05.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 05:42:01 -0700 (PDT)
Date:   Thu, 2 Jun 2022 14:42:00 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     mike tancsa <mike@sentex.net>
Cc:     kvm@vger.kernel.org, Leonardo Bras <leobras@redhat.com>
Subject: Re: Guest migration between different Ryzen CPU generations
Message-ID: <20220602144200.1228b7bb@redhat.com>
In-Reply-To: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 May 2022 13:00:07 -0400
mike tancsa <mike@sentex.net> wrote:

> Hello,
>=20
>  =C2=A0=C2=A0=C2=A0 I have been using kvm since the Ubuntu 18 and 20.x LT=
S series of=20
> kernels and distributions without any issues on a whole range of Guests=20
> up until now. Recently, we spun up an Ubuntu LTS 22 hypervisor to add to=
=20
> the mix and eventually upgrade to. Hardware is a series of Ryzen 7 CPUs=20
> (3700x).=C2=A0 Migrations back and forth without issue for Ubuntu 20.x=20
> kernels.=C2=A0 The first Ubuntu 22 machine was on identical hardware and =
all=20
> was good with that too. The second Ubuntu 22 based machine was spun up=20
> with a newer gen Ryzen, a 5800x.=C2=A0 On the initial kernel version that=
=20
> came with that release back in April, migrations worked as expected=20
> between hardware as well as different kernel versions and qemu / KVM=20
> versions that come default with the distribution. Not sure if migrations=
=20
> between kernel and KVM versions "accidentally" worked all these years,=20
> but they did.=C2=A0 However, we ran into an issue with the kernel=20
> 5.15.0-33-generic (possibly with 5.15.0-30 as well) thats part of=20
> Ubuntu.=C2=A0 Migrations no longer worked to older generation CPUs.=C2=A0=
 I could=20
> send a guest TO the box and all was fine, but upon sending the guest to=20
> another hypervisor, the sender would see it as successfully migrated,=20
> but the VM would typically just hang, with 100% CPU utilization, or=20
> sometimes crash.=C2=A0 I tried a 5.18 kernel from May 22nd and again the=
=20
> behavior is different. If I specify the CPU as EPYC or EPYC-IBPB, I can=20
> migrate back and forth.

perhaps you are hitting issue fixed by:
https://lore.kernel.org/lkml/CAJ6HWG66HZ7raAa+YK0UOGLF+4O3JnzbZ+a-0j8GNixOh=
Lk9dA@mail.gmail.com/T/


> Quick summary
>=20
> On Ubuntu 20.04 LTS with latest Ubuntu updates, I can migrate VMs back=20
> and forth between a 3700x and a 5800x without issue. Guests are a mix of=
=20
> Ubuntu, Fedora and FreeBSD
> On Ubuntu 22 LTS, with the original kernel from release day, I can=20
> migrate VMs back and forth between a 3700x and a 5800x without issue
> On Ubuntu 22 LTS with everything up to date as of mid May 2022, I can=20
> migrate from the 3700X to the 5800x without issue. But going from the=20
> 5800x to the 3700x results in a migrated VM that either crashes inside=20
> the VM or has the CPU pegged at 100% spinning its wheels with the guest=20
> frozen and needing a hard reset. This is with --live or without and with=
=20
> --unsafe or without. The crash / hang happens once the VM is fully=20
> migrated with the sender thinking it was successfully sent and the=20
> receiver thinking it successfully arrived in.
> On stock Ubuntu 22 (5.15.0-33-generic) I can migrate back and forth to=20
> Ubuntu 20 as long as the hardware / cpu is identical (in this case, 3700x)
> On Ubuntu 22 LTS with everything up to date as of mid May 2022 with=20
> 5.18.0-051800-generic #202205222030 SMP PREEMPT_DYNAMIC Sun May 22. I=20
> can migrate VMs back and forth that have as its CPU def EPYC or=20
> EPYC-IBPB. If the def (in my one test case anyways) is Nehalem then I=20
> get a frozen VM on migration back to the 3700X.
>=20
> Some more details at
>=20
> https://ubuntuforums.org/showthread.php?t=3D2475399
>=20
> Is this a bug ? Expected behavior ?=C2=A0 Is there a better place to ask=
=20
> these questions ?
>=20
> Thanks in advance!
>=20
>  =C2=A0=C2=A0=C2=A0 ---Mike
>=20

