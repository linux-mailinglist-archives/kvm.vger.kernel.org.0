Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C312C5A2D4E
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbiHZRTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 13:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242903AbiHZRTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 13:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE101E1141
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 10:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661534359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KNtDntk3ILRkVsRUqlZtymDlMNGzf32/o/DGAYxJZSM=;
        b=KVZfLVNyqNCNr34rWzw0N/cRuuC3ySySs8szAYKytoXZIC7N4cyEkN11jbdnoEwtUWIzg3
        UUNWaAqLoacP+pInNjGUzL8+bfvdF5mS7nbJm26oevaQbxttawBg+6nuovP30w8oMQQypq
        0VRN3kwBAYhW8xBgVnA8GNSEAOyyYrA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-274-xbDrAOMYOxaoVeUPu7WB9g-1; Fri, 26 Aug 2022 13:19:18 -0400
X-MC-Unique: xbDrAOMYOxaoVeUPu7WB9g-1
Received: by mail-ej1-f71.google.com with SMTP id ho13-20020a1709070e8d00b00730a655e173so838277ejc.8
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 10:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=KNtDntk3ILRkVsRUqlZtymDlMNGzf32/o/DGAYxJZSM=;
        b=O4P9mKppDaBFS3P82FxLNSuwFajz3haDGUEFxjtXDM/Fz6yGGIYl8KzA/7w2/ATLtp
         E8Z9DrIlUOqAAFF9XiWTB4OyJ8GU1QDuVTb8ZIFbQOYjIu6MfThqlC03UUIYzZnIZp1h
         ylCxscCdkPD3EbVSFekaUWdp21u5usbN6qJwDBegRh+t3wzmL+Z6bHk732hBcLdZmPqf
         8URjdQowv3Am7LEYlXytqEkR609Sq6BHsI69cQtPqeklpTqHxAcsb05ejAGPOGOQUFPm
         QSEnxnn9kbhns7GzByjOOJiM+wkkpiPU6lStDNNZn6SDsQvjrNJunCX51hARH4KvLrn1
         Qp/g==
X-Gm-Message-State: ACgBeo15Ph/j+JCIEQ+PnntY0HAJweJ3jC/56+vH/6RHbQ6nXksc6Ij/
        ArA0stgW+rSNQ7ZnNHc0JvjOXKs7gY+xBXHJkmjg/mln6cpkbsBcdzvtW/0tZjRDBFTkGCdYQNX
        FupcS9sqQNA5C
X-Received: by 2002:a17:907:72d0:b0:734:b451:c8d9 with SMTP id du16-20020a17090772d000b00734b451c8d9mr6040596ejc.272.1661534357186;
        Fri, 26 Aug 2022 10:19:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7egS8XZ/9y1jzO+KrFQa9stkpRp4RqjeAJ5xBRkiEAMOcQc2cFjSnuogHsEtpidkiVaGUeZQ==
X-Received: by 2002:a17:907:72d0:b0:734:b451:c8d9 with SMTP id du16-20020a17090772d000b00734b451c8d9mr6040586ejc.272.1661534356929;
        Fri, 26 Aug 2022 10:19:16 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bt21-20020a170906b15500b0073dbc35a0desm1123212ejb.100.2022.08.26.10.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 10:19:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v6 00/36] KVM: x86: eVMCS rework
In-Reply-To: <Ywe/j3fqfj9qJgEV@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <87fshkw5zo.fsf@redhat.com> <Ywe/j3fqfj9qJgEV@google.com>
Date:   Fri, 26 Aug 2022 19:19:15 +0200
Message-ID: <87v8qevs6k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 25, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > This is what I ended up with as a way to dig ourselves out of the eVMCS
>> > conundrum.  Not well tested, though KUT and selftests pass.  The enforcement
>> > added by "KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses"
>> > is not tested at all (and lacks a changelog).
>> 
>> Trying to enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 in its new shape in
>> QEMU so I can test it and I immediately stumble upon
>> 
>> ~/qemu/build/qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -cpu host,hv-evmcs-2022,hv-evmcs,hv-vpindex,hv-vapic 
>> qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016
>> qemu-system-x86_64: ../target/i386/kvm/kvm.c:3107: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
>> 
>> Turns out, at least with "-cpu host" QEMU reads VMX feature MSRs first
>> and enables eVMCS after.
>
> Heh, of course there had to be a corner case.
>

Unfortunatelly, it's not a corner case, named CPU models in QEMU behave
exactly the same (I've just forgotten to add '+vmx' yesterday). In fact,
it seems QEMU uses system-wide KVM_GET_MSRS (which results in
vmx_get_msr_feature() for our case) which gives unfiltered values. As it
is system wide it just can't filter anything. This happens even before
KVM_CREATE_VCPU is called so switching to per-vCPU ioctl is not an
option. What's worse is that all the discovered features (including VMX
features) are passed to upper layers of the virtualization stack,
starting with libvirt and upper layers may want to enable some of the
"available" features explicitly. Teaching everyone what's available with
eVMCS and what's not seems to be a hard task.

This use-case can probably be solved by making eVMCS enablement a per-VM
thing (already did locally) and creating a per-VM version of
KVM_GET_MSRS which will give us filtered VMX MSRs when eVMCS was
enabled.

Note: silently filtering out features when vCPUs are created is bad as
the list of such features will change over time. This is guaranteed to
break migrations.

Honestly I'm starting to think the 'evmcs revisions' idea (to keep
the exact list of features in KVM and update them every couple years
when new Hyper-V releases) is easier. It's just a list, it doesn't
require much. The main downside, as was already named, is that userspace
VMM doesn't see which VMX features are actually passed to the guest
unless it is also taught about these "evmcs revisions" (more than what's
the latest number available). This, to certain extent, can probably be
solved by VMM itself by doing KVM_GET_MSRS after vCPU is created (this
won't help much with feature discovery by upper layers, tough). This,
however, is a new use-case, unsupported with the current
KVM_CAP_HYPERV_ENLIGHTENED_VMCS implementation.

eVMCS seems to be special in a way that a) it evolves over time b) it is
mutually exclusive with *some* other features but the list changes. We
don't seem to have anything like that in KVM/QEMU, thus all the
confusion.

-- 
Vitaly

