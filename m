Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339254F3E03
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 22:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiDEOsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392302AbiDENtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 09:49:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A4F6111DC0
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 05:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iuSjdFs27sBmSFtBNQcfSgEVjf1hmX+hk7DMTekqxb8=;
        b=VlzU6C+sB/1eKhzYAZPNvLMGjwj29JMdvQQHeE56JAN1pidwUAfGSaRAGfjrJjc1N9WH5j
        E7mDuktAkpddDoqOZV/ddLA69sSwqYumIvCQpqCuBaaJPoLW6XO+sfwgubzCMEzbgdfGvu
        jvV9I7+5UID5dfHNYcwiHDNUl9oJf6E=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-FtTkoWc7Md2oCPWuNhwqKw-1; Tue, 05 Apr 2022 08:52:34 -0400
X-MC-Unique: FtTkoWc7Md2oCPWuNhwqKw-1
Received: by mail-qt1-f199.google.com with SMTP id k11-20020ac8604b000000b002e1a4109edeso8747073qtm.15
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 05:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iuSjdFs27sBmSFtBNQcfSgEVjf1hmX+hk7DMTekqxb8=;
        b=0QL22W1iHhCCiZWCdJB/+oNc8R6ij8RmlDLWCgU53Sp9ETKWuIQ5qkpnSA7Op7eMMj
         GH42swoJa46tmVptddmyBo9jCZC4trV0GXTe48NqhkzFvlinjhr9oECBYux7M5gtZLi/
         DqVXjq/Tv/7U2kk9A6gH2IJGtQQuMdH10gJiNXv/Hz+6mHV1hOZi02Wcy8NzM5zlqkxT
         nv92goZ1sj1VVGogS3FOxPF8gcp+HRTDHa9lvTyu0B8sgvU9YXkLQpgHCFksh4LOAtzf
         T6Sm66YJYzU+ByFcNgsVEgyyqOX3W6S8GxUhJsVqNCWqjDkOIr4iDW1gIaWth0Vu1yS3
         PA6Q==
X-Gm-Message-State: AOAM532czZZ6+RL9D5whnMIXnXv0U9t0VnVpuprVC64ENDQa2B0wumPv
        DWJ1YU6U1LnXzYzFXfXwEaDqctq/T64Pm2OM4RmKv2tzbFG5Q44/M9N2Avh9kU34HvyGqczfjwZ
        yZnrzOL/Y+3mI
X-Received: by 2002:ad4:5aa3:0:b0:443:9ba7:3f27 with SMTP id u3-20020ad45aa3000000b004439ba73f27mr2768351qvg.63.1649163153774;
        Tue, 05 Apr 2022 05:52:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+DHckKgCo4PomCz5tT74b9OII0g4hXHShOTcpaeQjClTAlXuwMZZykBkAFfOfWWQXnZb1aQ==
X-Received: by 2002:ad4:5aa3:0:b0:443:9ba7:3f27 with SMTP id u3-20020ad45aa3000000b004439ba73f27mr2768343qvg.63.1649163153551;
        Tue, 05 Apr 2022 05:52:33 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id 21-20020ac85715000000b002e1ce9605ffsm11295736qtw.65.2022.04.05.05.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:52:33 -0700 (PDT)
Message-ID: <586be87a-4f81-ea43-2078-a6004b4aba08@redhat.com>
Date:   Tue, 5 Apr 2022 14:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 026/104] KVM: TDX: x86: Add vm ioctl to get TDX
 systemwide parameters
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5ff08ce32be458581afe59caa05d813d0e4a1ef0.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5ff08ce32be458581afe59caa05d813d0e4a1ef0.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> Implement a VM-scoped subcomment to get system-wide parameters.  Although
> this is system-wide parameters not per-VM, this subcomand is VM-scoped
> because
> - Device model needs TDX system-wide parameters after creating KVM VM.
> - This subcommands requires to initialize TDX module.  For lazy
>    initialization of the TDX module, vm-scope ioctl is better.

Since there was agreement to install the TDX module on load, please 
place this ioctl on the /dev/kvm file descriptor.

At least for SEV, there were cases where the system-wide parameters are 
needed outside KVM, so it's better to avoid requiring a VM file descriptor.

Thanks,

Paolo

