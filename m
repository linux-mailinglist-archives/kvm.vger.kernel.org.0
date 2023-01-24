Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB74679CB8
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbjAXO5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbjAXO5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:57:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CFB11E9F
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674572180;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=ChITr7Qhr9nwz/X+4II6I4+FYa5Bsc0VGpOVDoqL48s=;
        b=b/USpkjfaYJDpsizv72WVgMRHxapesFVyIHGslWp+x4vBQ24NcWfj6SG+c1l9CSqqsXLGf
        sLeclDc7oKNkbTy5tjD63MMEA65FNxmAHAOeqhq3vCzTQ3oxEc395tETcfMUerMCsFvAZy
        fdu088MqHLWYm6dn5CmXdF7GH3NO2/8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-300-KKE1-BKlN9uCtoKc_2Ox_g-1; Tue, 24 Jan 2023 09:56:19 -0500
X-MC-Unique: KKE1-BKlN9uCtoKc_2Ox_g-1
Received: by mail-wr1-f72.google.com with SMTP id l8-20020adfc788000000b002bdfe72089cso2683250wrg.21
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:56:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ChITr7Qhr9nwz/X+4II6I4+FYa5Bsc0VGpOVDoqL48s=;
        b=bWgmnZ19OzV64tgIWv1DJ1BHAYtSEAEMpZnAfcUXo3rxFQxbPGQkOKvUndxxuG1p4A
         XPRiagTjSLLAmTCE307GvdE+0bohwi0vAGZf3rheomAyhpZcI8kya4URuYAsmCb18NZ8
         VxyvBVeDgOpEzHNWO7aDrA8cGYPRDu8Qj6l0hCQcUlb27xIzc+p0p2oTiiPrOEPBJD26
         kKVrfJRljGkjNnKxtaZIgNl8UYwCkNBIi/NO0c06asW0L9uT/FRed3msOF7ybXZQ5o/z
         FlXHwUA/OYzcUZXXXdFeI3Wntq0Zm2U1S6JgyAoz4N6tSwhcjNaJZzRdirH+7+TowCBC
         GvIA==
X-Gm-Message-State: AFqh2kprRZsVF3AttdgyWD3Ch0G+2UHAqIFPVhQA9p7op2ba2r+XLIZR
        S2+r3TBL5nGfmjCcqBLq2pjWVa8OiZGmvBYAKblfAJ8JzSYh1J7YKFFDcSAoUKpwAmv8xc/Idkn
        PYxKfURvaYf607633xceGV8cZEzVCdfoah9Ym7vAaezBgR4vHa4zzv83p7FYEf1bN
X-Received: by 2002:a05:6000:1816:b0:2bd:fe5a:b579 with SMTP id m22-20020a056000181600b002bdfe5ab579mr22886679wrh.70.1674572177346;
        Tue, 24 Jan 2023 06:56:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsHe1YzvNCX46JuK4XR/df1BCMeEfzavFFDAocn1pipZmxAFxwf6Qb/tkqZ0rBblq2hSVdj5Q==
X-Received: by 2002:a05:6000:1816:b0:2bd:fe5a:b579 with SMTP id m22-20020a056000181600b002bdfe5ab579mr22886656wrh.70.1674572176977;
        Tue, 24 Jan 2023 06:56:16 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id d2-20020adfa402000000b002bdfb97e029sm2122358wra.19.2023.01.24.06.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 06:56:16 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Fortnightly KVM call minutes for 2023-01-24
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 24 Jan 2023 15:56:15 +0100
Message-ID: <87zga8f0c0.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org





First part stolen from: https://etherpad.opendev.org/p/qemu-emulation-bof%402023-01-24
      thanks Phillippe

Single QEMU-system binary and Dynamic Machine Models

Meeting link: https://meet.jit.si/kvmcallmeeting
Just want to dial in on your phone? Dial-in: +1.512.647.1431 PIN: 1518845548#
Click this link to see the dial in phone numbers for this meeting https://meet.jit.si/static/dialInInfo.html?room=kvmcallmeeting

What needs to be done?

    TCG

    How to use different page sizes

    -> convert to page-vary (already used by ARM/MIPS)

    ref: https://lore.kernel.org/qemu-devel/20221228171617.059750c3@orange/


    HW models / machine


    How to create/realize 2 QOM objects which depend on each other?

    what (properties) need to be wired? IRQ, reset lines, MR?


    Sysbus: Demote it to plain qdev?

    con:

    sysbus helpful to remove qdev boilerplace/verbose code

    sysbus tree does the resets [currently blocking qdev conversion]

    pro:

    sysbus IRQ API

    too abstract, not very helpful, "named gpios" API is clearer

    sysbus MMIO API

    also kinda abstract, MRs indexed. No qdev equivalent

    sysbus IO API:

    not very used. first we need to get rid of ISA bus singleton


    Single 32/64 *targets* binary

    Which 32-bit hosts are still used? OK to deprecate them?

    Some targets need special care i.e. KVM 32-bit ARM vCPU on 64-bit Aarch64 host


Previous notes:
    https://etherpad.opendev.org/p/qemu-emulation-bof%402022-12-13
    https://etherpad.opendev.org/p/qemu-emulation-bof%402022-11-29


Do we care about this?

64 bits guests on 32 bits hosts: OK to deprecate
32 bits hosts: still in (some) use

Creating and realizing two objects than need to be linked together.

We can't do it with realize, perhaps we need an intermediate state to
do the link, and then realize.

Can we get Peter or Markus or Paolo for the next call?
waiting to get some patches into the list for discussing.

Problem for Phillipe is that he has to do changes to the API's and
want to be sure that they are agreed before he changes all
devices/targets, a multi month task.

For removing sysbus, we need to wait for reset rework from Peter?

Expose the memory API to external processes.

Under what circumstances you should be able to create/destroy a memory
region?



Later, Juan.

