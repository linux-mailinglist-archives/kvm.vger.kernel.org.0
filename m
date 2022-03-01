Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6CC4C9270
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiCASBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiCASBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:01:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 244D83FD81
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646157662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aGuBN2sDkrG0QralsisRx+RjFPJcE9jpk8xjbOOsyfE=;
        b=bLarlxWr5aOHnE2a3jcKF0QH32F9qjdPd2i7SNHzEFti2GcEIhfVUHVC3krUHQ1aeIHnrJ
        2GytgmajvLon8UahXufV5R4lEGc12FggWF9t6G4uPV3s4Jf98Xf5uZwUOJve+bmFk67i8a
        XLHTJNuL/737tIoRQiVZOf4/ph2iiJA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-HqKPMXJcN8GRBv8q32qzoQ-1; Tue, 01 Mar 2022 13:01:01 -0500
X-MC-Unique: HqKPMXJcN8GRBv8q32qzoQ-1
Received: by mail-wr1-f70.google.com with SMTP id q12-20020adfbb8c000000b001ea938f79e9so3567588wrg.23
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 10:01:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aGuBN2sDkrG0QralsisRx+RjFPJcE9jpk8xjbOOsyfE=;
        b=E3uo8Z4Np4N/bQ+dy+aHaKRM0+y36Pgf9wMKx/YH5EzJCpzjkwGRWuSQ3L0C9Llvcq
         Smqd4k6exm3y8BRBFWpHxv079m+9S15JVAWC4xdUxOQpJTHlYEGTRmDb0hJlfOZHWn67
         OCXjJoWP/8COch9YStXgAXcx7o5eiY4jG7RjwHS2QS3zlO+iHZ2dZMs9gO3d4n1FQWyO
         4EizkqbHgBhHco6OqFS2x+A7IDBReB99RUsuIF7HwSeAVgBRVFG1hbxFHmDNmDXJPiua
         y1XgA/cBZF9dlkv0zXRUfThHJaCwiVb5PapVUygRiuZ6JZJvZDZmpWZMAXwT2Flp1004
         GRcw==
X-Gm-Message-State: AOAM533U49M4q49I5EKGaQOL5+JeC9yqCfmRlVUgbbQr+L3gEufLAl5y
        zouvS9ZNd57OP3M3gWFrlnr6WthwGzCXXabSqIiKGjzLvRKrGnLTOAhljykw9gQl5+CMQClE6Na
        vA5fxc3drv43F
X-Received: by 2002:a5d:678a:0:b0:1ef:8e97:363c with SMTP id v10-20020a5d678a000000b001ef8e97363cmr12384849wru.617.1646157659717;
        Tue, 01 Mar 2022 10:00:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlwO1iYWlkXlaIZYC8c3tEFCMQx8nu55QbUYSzt5j2PfbQbJH6+QV1RLoIm/tJ9HvBQgLvPQ==
X-Received: by 2002:a5d:678a:0:b0:1ef:8e97:363c with SMTP id v10-20020a5d678a000000b001ef8e97363cmr12384830wru.617.1646157659488;
        Tue, 01 Mar 2022 10:00:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p4-20020a05600c430400b0037bf8409eccsm4044638wme.23.2022.03.01.10.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 10:00:58 -0800 (PST)
Message-ID: <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
Date:   Tue, 1 Mar 2022 19:00:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301060351.442881-2-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 07:03, Oliver Upton wrote:
> +
> +	/*
> +	 * Ensure KVM fiddling with these MSRs is preserved after userspace
> +	 * write.
> +	 */
> +	if (msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
> +	    msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS)
> +		nested_vmx_entry_exit_ctls_update(&vmx->vcpu);
> +

I still don't understand this patch.  You say:

> Now, the BNDCFGS bits are only ever
> updated after a KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a
> subsequent MSR write from userspace will clobber these values.

but I don't understand what's wrong with that.  If you can (if so 
inclined) define a VM without LOAD_BNDCFGS or CLEAR_BNDCFGS even if MPX 
enabled, commit aedbaf4f6afd counts as a bugfix.

Paolo

