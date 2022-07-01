Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57373562D8A
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 10:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiGAIMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 04:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiGAIMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 04:12:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DE1C70AD2
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 01:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656663151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z/AmvOZyV6QrDA7wpE31jhK9NIwk6H7+U8kbekS2CX4=;
        b=iUnRAoNiE1KAFhHRNCnNfvZyABa3m+0Ahijql50R4Z6WNDv1n2BLeMQ+zCfl30BK+My5/s
        LWiBd9Ia7MLktE5wY7ybb+y0+FRgW2Jbk1t/EEDAYLf0toDeNTB4xacDXUkxJ17FeMe1lz
        GtCRPEFY3WTB2UUxb2XBDoOy3NEaOS8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-VQUtXSRGPqOax2Cq7Eko5Q-1; Fri, 01 Jul 2022 04:12:30 -0400
X-MC-Unique: VQUtXSRGPqOax2Cq7Eko5Q-1
Received: by mail-wr1-f71.google.com with SMTP id s1-20020a5d69c1000000b0021b9f3abfebso198644wrw.2
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 01:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Z/AmvOZyV6QrDA7wpE31jhK9NIwk6H7+U8kbekS2CX4=;
        b=3PDQuJ+HTsnEXr+DlUkIl99K/8qNyyb2A3HNlefW9F3k88Y0XiyHGkQQ3vEDBw0Qcd
         0TwkeEeRkCFIj+MKD0I1GbZTwtmFMq54MGoC6qcIa7JkYHBwT9/b0bGDaG+Sp2icxUOM
         jL912Jjv3BfILMUV6kYYYfDakRAV8XIcVd5+IZ4jCRT6uLJt+0PbMlIPCMkRJriT2P2g
         iekhXR4dJ82QG7FMMwXiuCvteFlVYbRqFTY5LIMzzCKzyY8nB+/iVxxWgRxHaJhcMffp
         YbJQS0+p8roAXSPofJJ9Qql4tCBwubMXhOJ5OOKRCsGYG0nsW/vAH+Ssq8GK/8xn2Slo
         ZccQ==
X-Gm-Message-State: AJIora/pD9DkC0zIQXWcjGgqgaiO6smoCTr0Imv9P9g3NlbQvY7RkIHW
        OSdTTfPvpekQaE1Y/99KEbr8CboApYZbGDA5wEUU9gohyYulPDOsobjJf6q+32LR7G/jHkvExti
        utHZp5YVgn29Z
X-Received: by 2002:a5d:48ce:0:b0:21b:9f34:f297 with SMTP id p14-20020a5d48ce000000b0021b9f34f297mr12409457wrs.351.1656663149014;
        Fri, 01 Jul 2022 01:12:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uPWo0xmhO7Sqt29ZDdDqBVBiI91YlLkKsb9zDgKgODfne6Ky2CuYV/YqnDSO9FRwIJuR4dlQ==
X-Received: by 2002:a5d:48ce:0:b0:21b:9f34:f297 with SMTP id p14-20020a5d48ce000000b0021b9f34f297mr12409431wrs.351.1656663148790;
        Fri, 01 Jul 2022 01:12:28 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l34-20020a05600c1d2200b003a03e63e428sm7220233wms.36.2022.07.01.01.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 01:12:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/28] KVM: VMX: Check
 CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
In-Reply-To: <CALMp9eSTv8e5=vwXRouhLubx8k6q9sH4X8z0CgFsKTv54VFdSA@mail.gmail.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-16-vkuznets@redhat.com>
 <CALMp9eSTv8e5=vwXRouhLubx8k6q9sH4X8z0CgFsKTv54VFdSA@mail.gmail.com>
Date:   Fri, 01 Jul 2022 10:12:27 +0200
Message-ID: <87edz5s13o.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
>> vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
>> but setup_vmcs_config() doesn't check their existence. Add the check and
>> filter the controls out in vmx_exec_control().
>>
>> No (real) functional change intended as all existing CPUs supporting
>> VMX are supposed to have these controls.
>
> I'm pretty sure vIrtual NMIs and NMI-window exiting are not available
> on Prescott or Yonah.
>

I seemed to have questioned their existence :-) But you're right, I
should've said something like "all CPUs supported by KVM" instead (as
pre-patch KVM toggles these controls unconditionally).

>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
>

Thanks!

-- 
Vitaly

