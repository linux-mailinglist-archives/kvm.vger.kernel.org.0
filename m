Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256ED4F499D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443189AbiDEWUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457412AbiDEQDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:03:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E28E96D388
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 08:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649173315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kz7Qu7KgcrxcF0aFFsFJtexkfcFJthGGVhC/3S+UJFw=;
        b=hpt9o4WcWsGiVNKw7djajsuOSpEt/210juiqPnM+XyK3lQscQfVDSdaVkedt1nI8Mguc/X
        kEmpHOPNSS2xQQy/pp9MfP1MXD4NBobVxFTSGvLK8GnGzq09n/XgZoDI2U4TnQRm9IMqBU
        qniaxgteKrOip44Em4NW1WJSmjtLkC4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-qQ_DzSUkODC8a9vr9gxn0A-1; Tue, 05 Apr 2022 11:41:54 -0400
X-MC-Unique: qQ_DzSUkODC8a9vr9gxn0A-1
Received: by mail-wm1-f70.google.com with SMTP id z16-20020a05600c0a1000b0038bebbd8548so1506824wmp.3
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 08:41:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kz7Qu7KgcrxcF0aFFsFJtexkfcFJthGGVhC/3S+UJFw=;
        b=WLYMAQZkIrJGkFkBpYR7ieRCMg7Upo+rWLdTaxldiHqldddZGkDGl+aZv8MnmorM4/
         eZWg4/nkMJO2pgs4ey3orEx8OD5UJN2UVSTti4YT9+EjYi6P7etSHRyRVt9uz3vA6fCc
         Nglk1HbHPXH4Mdtm+WFdzOZ6erBt9rH75QjESeeQ9gFUM9Z4cMWilbFpE10zHzdPvWKq
         CzsI7eRUeOJY9HrnjlYpfbHmkfJ1z1ElocJhm3Mp1ktc0b/Y7fkDDFDZF3zBX7ksJHdM
         mbXyCQZ24LDOeWP3dqkggNPIWo1i0nnHdwmbPwuN4JIPYzDeKpCJEj+3T58cMsOrkXZ2
         Cjkw==
X-Gm-Message-State: AOAM531fDNBaQoIK62AzwW0070yJYEsJgB6v0ZtezZlz9es4vba2Gfux
        lgioQBIW4jS4Hgs0ogyvCKhBrgfiY/7yinrO3tQRlnsUP79RhPlH8UjMPK0+3XPkrbhHHU12LVL
        /fb/ADYBNepr+
X-Received: by 2002:a7b:cb84:0:b0:382:a9b9:2339 with SMTP id m4-20020a7bcb84000000b00382a9b92339mr3769142wmi.91.1649173313475;
        Tue, 05 Apr 2022 08:41:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs/9UhNhcIf6N5vqV+SfAazRP5BqH0fcSVTFmUk2/ChvkzCq45kq8mMwxfAKLFDEC6dGX9yw==
X-Received: by 2002:a7b:cb84:0:b0:382:a9b9:2339 with SMTP id m4-20020a7bcb84000000b00382a9b92339mr3769132wmi.91.1649173313252;
        Tue, 05 Apr 2022 08:41:53 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id k6-20020a05600c1c8600b0038e7e07f476sm3338019wms.35.2022.04.05.08.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:41:52 -0700 (PDT)
Message-ID: <26ec85d5-dd44-2364-1f8c-064de262cf8f@redhat.com>
Date:   Tue, 5 Apr 2022 17:41:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 100/104] KVM: TDX: Silently discard SMI request
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b3976a6ed7b7e38f05a9e95eac5b0d735e52bb4d.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b3976a6ed7b7e38f05a9e95eac5b0d735e52bb4d.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX doesn't support system-management mode (SMM) and system-management
> interrupt (SMI) in guest TDs.  Because guest state (vcpu state, memory
> state) is protected, it must go through the TDX module APIs to change guest
> state, injecting SMI and changing vcpu mode into SMM.  The TDX module
> doesn't provide a way for VMM to inject SMI into guest TD and a way for VMM
> to switch guest vcpu mode into SMM.
> 
> We have two options in KVM when handling SMM or SMI in the guest TD or the
> device model (e.g. QEMU): 1) silently ignore the request or 2) return a
> meaningful error.
> 
> For simplicity, we implemented the option 1).

Please also:

1) return zero from vmx_has_emulated_msr(MSR_IA32_SMBASE) for TDX 
virtual machines.

2) do a check for static_call(kvm_x86_has_emulated_msr)(kvm, 
MSR_IA32_SMBASE) in kvm_vcpu_ioctl_smi and __apic_accept_irq.

3) WARN_ON_ONCE in tdx_smi_allowed and tdx_enable_smi_window.

Paolo

