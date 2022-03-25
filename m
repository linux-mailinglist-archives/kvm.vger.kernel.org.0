Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0314E7166
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 11:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358919AbiCYKkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 06:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353897AbiCYKkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 06:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C93FF66AE7
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 03:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648204705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k8Ww1TQL/x1udfrBe7ulqa+UDnc+QUOwf2wvM/b+uX8=;
        b=VOYIqzgibAQoa7cn6YEyNMjko28wnZo9bPkI/vQlBYwGunGbB2BrmaIbqSbzgC6rHDqLxA
        0eiBmaKxEuvJ66OwkgUlJHOTtHCUBcOSkqg8GiP7PXOzPMhaBFBRAhBlwqGWd47h2qZFq4
        XdYf55mZSwSJi8Vp+dw/DOsOIDpi+0k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-dxwKqbqHMoiZP4gPCm3hjw-1; Fri, 25 Mar 2022 06:38:24 -0400
X-MC-Unique: dxwKqbqHMoiZP4gPCm3hjw-1
Received: by mail-wm1-f70.google.com with SMTP id q6-20020a1cf306000000b0038c5726365aso2560903wmq.3
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 03:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k8Ww1TQL/x1udfrBe7ulqa+UDnc+QUOwf2wvM/b+uX8=;
        b=DBJxezAGgvVGbXNTmrAbEopyJkDWK3NeNgpsguNQfGesIf1QGEQYflN/F1DSVoOU3f
         QIO+H+/RvGqUJD3rIGZ1X+VHiF2g2PSEzT9dyZ9/XuY5vOHGCP1XDR8s6/CoRCFEf/5K
         byNA4f1Qyi7+YM1EAFVT9YCkap+7BesnHX1aWMicO6b59hIKLHjcZMASH6kX3FF15Igy
         hIkqs6dBTAfhJM5QeGfkvGgexHO/49EjyD8MCgUUpSfKX6uEzJPqnE1byy+pdb1rl/+t
         i0FaA/fN1SKapeovASOfIEaFGDde1ENzD313JcCM0X5PqIxfLo7QncU+WPCzlHNcyksH
         4kVA==
X-Gm-Message-State: AOAM530yWQUaX50rNiwKD5HKcMHzum/u+YxEmRgr4MhF1rveb5FcVonz
        ZbyqnIkytCRxZR7mQm12bBRNXjqUiMchvriYNRK+c1NWyhxvXfJ38jXayX8KLnustJw8l6QNn++
        hcnR8o1bxhi+k
X-Received: by 2002:a1c:ed01:0:b0:38b:5a39:220c with SMTP id l1-20020a1ced01000000b0038b5a39220cmr18244094wmh.167.1648204703466;
        Fri, 25 Mar 2022 03:38:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMj734PZyhmluPDLs9xmQ6pJD2H5U4RSrOcVOm06J/lWrAktgKtttWoMVSaRs+Ejoq5YeU5A==
X-Received: by 2002:a1c:ed01:0:b0:38b:5a39:220c with SMTP id l1-20020a1ced01000000b0038b5a39220cmr18244075wmh.167.1648204703249;
        Fri, 25 Mar 2022 03:38:23 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q11-20020adfcd8b000000b001e320028660sm4551557wrj.92.2022.03.25.03.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 03:38:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [FYI PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()"
In-Reply-To: <Yj0FYSC2sT4k/ELl@google.com>
References: <20220318164833.2745138-1-pbonzini@redhat.com>
 <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
 <Yj0FYSC2sT4k/ELl@google.com>
Date:   Fri, 25 Mar 2022 11:38:21 +0100
Message-ID: <87tubmnwpu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 21, 2022, Paolo Bonzini wrote:
>> On 3/18/22 17:48, Paolo Bonzini wrote:
>> > This reverts commit cf3e26427c08ad9015956293ab389004ac6a338e.
>> > 
>> > Multi-vCPU Hyper-V guests started crashing randomly on boot with the
>> > latest kvm/queue and the problem can be bisected the problem to this
>> > particular patch.

...

>
> Vitaly, can you provide repro instructions?  A nearly-complete QEMU command line
> would be wonderful :-)  

The issue was observed with genuine Hyper-V guests, with or without any
Hyper-V enlightenments (not with Linux using Hyper-V enlightenments)
The QEMU command line is nothing special, e.g.

~/qemu/build/qemu-system-x86_64 -machine
q35,accel=kvm,kernel-irqchip=split -name guest=win2019 -cpu host -smp 16
-m 16384 -drive
file=/home/VMs/ws2019_gen1.qcow2,format=qcow2,if=none,id=drive-ide0-0-0
-device
ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1
-vnc :0 -rtc base=localtime,driftfix=slew --no-hpet -monitor stdio
--no-reboot

I'm also pretty sure I saw this on both AMD and Intel hosts, I can try
reproducing if needed.

-- 
Vitaly

