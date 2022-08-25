Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497B35A1863
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 20:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbiHYSI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 14:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiHYSIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 14:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95B6BD172
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661450927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sge+saFWmsc9Ake5hFoO/H7Br59mHjdbXkD1qmHPntc=;
        b=Eks/QlsuphWMfdug8nZvN7z9IK4AFZWVPYVtyBUSI+Id9o3d7bn5bkCwG9v3c/C4Jlpu8K
        9P4cCxmT4vB9mJ5vwVgrHicasNWPt81MvROgidShay/2OGM3+wtO4GT9pH7OLUg5NX+W8K
        q4JfvPWq9hE6AwnvjWZOLs0xggSy6nc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-577-0xV7a0mAOhSXywoY4Mv3aw-1; Thu, 25 Aug 2022 14:08:46 -0400
X-MC-Unique: 0xV7a0mAOhSXywoY4Mv3aw-1
Received: by mail-ej1-f69.google.com with SMTP id qb39-20020a1709077ea700b0073ddc845586so491288ejc.2
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=Sge+saFWmsc9Ake5hFoO/H7Br59mHjdbXkD1qmHPntc=;
        b=WlK63O57/7Ns3zjeOamzBr6ufgeG/RRAdkrZTwrLne1FhftgGorfcdV3Vd03yFqBnu
         X4uf2Ef1Wyf6Y8hQes/QQ06AITo/IKP1mdmp04P6IAC24XE1hHuJtCKr76Dfg27F14a+
         GHOeaclPj78S21CnfGO8aotCtPWWBTmBOBX8z/On0cDJlkx+RlCrCgcwKd03xAWvL66V
         Sk/pzvXXwui3qgFSE0IYsDvbvIMkG43vHnFP0XlfZ3Igr/sn30pBhfbRIcc+OW7UuEmz
         RP+naF+Cu+AFD8YGDCKD8YFn+gZlyWsJBWJZGkWkxdIeGIsO7+tuU+1wxqRdMYwaoFGt
         DnBg==
X-Gm-Message-State: ACgBeo1VAVGf1BmpcjhVJo8TnpUKj9Nyh6RdJrFweZVHh4zBlzaWHZas
        69ZmGkNzp6QbEFIUzJarjmZYmHi60z2dtPznTl7JBZKopqRMeT0uE7TwDaKM0SCphnqLTgvOUYn
        Gt49zQDfp8NTq
X-Received: by 2002:a17:907:2e01:b0:731:1eb0:b9ff with SMTP id ig1-20020a1709072e0100b007311eb0b9ffmr3409947ejc.728.1661450925111;
        Thu, 25 Aug 2022 11:08:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5+NIEZNfiFhSe59lmw1jrCvX2goqo/o3xFf4lKU3TpsCZvnYSxcEEGMyvYPekQ51zfKP5W4A==
X-Received: by 2002:a17:907:2e01:b0:731:1eb0:b9ff with SMTP id ig1-20020a1709072e0100b007311eb0b9ffmr3409936ejc.728.1661450924883;
        Thu, 25 Aug 2022 11:08:44 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v23-20020aa7cd57000000b0043a61f6c389sm85872edw.4.2022.08.25.11.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 11:08:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v6 00/36] KVM: x86: eVMCS rework
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
Date:   Thu, 25 Aug 2022 20:08:43 +0200
Message-ID: <87fshkw5zo.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> This is what I ended up with as a way to dig ourselves out of the eVMCS
> conundrum.  Not well tested, though KUT and selftests pass.  The enforcement
> added by "KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses"
> is not tested at all (and lacks a changelog).

Trying to enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 in its new shape in
QEMU so I can test it and I immediately stumble upon

~/qemu/build/qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -cpu host,hv-evmcs-2022,hv-evmcs,hv-vpindex,hv-vapic 
qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016
qemu-system-x86_64: ../target/i386/kvm/kvm.c:3107: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

Turns out, at least with "-cpu host" QEMU reads VMX feature MSRs first
and enables eVMCS after. This is fixable, I believe but it makes me
think that maybe eVMCS enablement (or even the whole Hyper-V emulation
thing) should be per-VM as it makes really little sense to have Hyper-V
features enabled on *some* vCPUs only. As we're going to add a new CAP
anyway, maybe it's a good time to make a switch?

-- 
Vitaly

