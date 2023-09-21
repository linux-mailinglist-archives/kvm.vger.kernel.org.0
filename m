Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894197A9ECE
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjIUUMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjIUUMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:12:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D5359178
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zqxjd7vzkCUrJrBDjFOpFx4UYTiSrfDdK9nV5ZYkB0s=;
        b=BYZfryT+vLbPv76BKjxtkymRom0xaHz4xsUtA4GTdiNXFbxZKMqNDhQvy+3PxACzCT9D2b
        dc/ayBN6n85jo2ICCisnWJoHIkRUHsLI3JiA2tyWUm+fPLDE+LPfkvhk0aMYXiKAptdRz+
        W/rVct8qQdL36dmKgJWgSGSqRpHz5GA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-iIhlZ2TlMQqVYbvHeuzjzg-1; Thu, 21 Sep 2023 04:51:38 -0400
X-MC-Unique: iIhlZ2TlMQqVYbvHeuzjzg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-503343a850aso933148e87.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 01:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695286297; x=1695891097;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zqxjd7vzkCUrJrBDjFOpFx4UYTiSrfDdK9nV5ZYkB0s=;
        b=NSUO6luofy7Tw7Dpcv8wE2p3HYHNKQ1AGjRAK6EfcM1OVQOyfkHhZ6NW8IempaGSEK
         ggr8afdjE4DOZqTjqKYja7RaJIrCwcOMT2hwUADutWzxdwx3aGdwNMUgspLE9kuJc4S8
         /sfz+zx4vc/hGsxOjE5V9Mg7e5jPmedZfbSAAGUawYih+8D+c3r/+vg3n/xWVVv+xS43
         o1DDb6SJUGWoPGGjeS8vQQd1eysq1U0U5iGiZAzpAIBIVQfEW22xTLEh217Y3koQqt5j
         sHpUWHwOZ7l0c7yne/cu6ObbSAOw7VH9zhG4EHEddnZI+GS8dwmNBJ57OGZowz5vp1la
         UlTw==
X-Gm-Message-State: AOJu0YzbqxcxvWbVkFZI0HrOogaHoAgKHpulWrMHL3ApQ+zD9RCE0Qms
        bdgqLzk0SiMI9IyvqOZmYi/cp7jAhVHassxeoTWxI7rPtZP1KTEvPaQWNJdRddIAQCpAjM35zGx
        NxMdZaiAYxnkz
X-Received: by 2002:a05:6512:3d1f:b0:501:c406:c296 with SMTP id d31-20020a0565123d1f00b00501c406c296mr5503282lfv.31.1695286297157;
        Thu, 21 Sep 2023 01:51:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+MmV39liaYeAhAK9D4LYF6Qc1Bqlbt7hlk2i4KRE4cT4ptZEZznYU2JOQtWzt30+nwS40dg==
X-Received: by 2002:a05:6512:3d1f:b0:501:c406:c296 with SMTP id d31-20020a0565123d1f00b00501c406c296mr5503251lfv.31.1695286296699;
        Thu, 21 Sep 2023 01:51:36 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id j9-20020a5d6189000000b003142ea7a661sm1145419wru.21.2023.09.21.01.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 01:51:36 -0700 (PDT)
Message-ID: <b5ebeeac-9f0f-eb57-b5e2-4c03698e5ee4@redhat.com>
Date:   Thu, 21 Sep 2023 10:51:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 07/21] i386/pc: Drop pc_machine_kvm_type()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-8-xiaoyao.li@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230914035117.3285885-8-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.23 05:51, Xiaoyao Li wrote:
> pc_machine_kvm_type() was introduced by commit e21be724eaf5 ("i386/xen:
> add pc_machine_kvm_type to initialize XEN_EMULATE mode") to do Xen
> specific initialization by utilizing kvm_type method.
> 
> commit eeedfe6c6316 ("hw/xen: Simplify emulated Xen platform init")
> moves the Xen specific initialization to pc_basic_device_init().
> 
> There is no need to keep the PC specific kvm_type() implementation
> anymore.

So we'll fallback to kvm_arch_get_default_type(), which simply returns 0.

> On the other hand, later patch will implement kvm_type()
> method for all x86/i386 machines to support KVM_X86_SW_PROTECTED_VM.
> 

^ I suggest dropping that and merging that patch ahead-of-time as a 
simple cleanup.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

