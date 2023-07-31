Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9510769F11
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 19:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjGaROm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 13:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbjGaRN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 13:13:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA7B2D77
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:10:44 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bba48b0bd2so29780985ad.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690823444; x=1691428244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cNU9dnqwA33bWSRJZJl5nat2xoj0PX9l4djIhWRICY0=;
        b=AExM9wKjRd/rozndMc8/4u2f60z+wSuwW8JYQ5+smlCcf0YHGMQPEQUruPl0XPdpzG
         2ANYb/cud4zqE7BmXkuxWogufbwwBUBW4jtUYheiJbLy347xk+Afw/1ceVgCHA0LHODj
         9spWt30S40RXAxlTtye35UhbLu9x8QoLFElUirVMrhuzUHclPpqo/nHiaJMAQDEtsVEs
         1COUGxlA09DFT+T/DCkbqufIfgkHZgD1zV9r0H2yLNFvLH5XUeopDRBtPT/iyugE04mc
         Q+YLmQpojd1DaUY60zBjo/GAzcFPW9Oz/7cwYv4OxIENQUV+MDaNWsOZb8yHrEv/QwOI
         fKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690823444; x=1691428244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNU9dnqwA33bWSRJZJl5nat2xoj0PX9l4djIhWRICY0=;
        b=GPmZaaYiAEWdao+HwQDvV30jmYEST/2NNyeUkLtVP2cmT3ofvEkLjE8vIqkeOsuvgB
         2/wq2IM+nNFVlYbUFTAQobS2cOhkwqO5h6KNr61G7mqlVd1rKIq3h6a06yMiLNiVhZ29
         hr4h+xsfW2j91aNq9ZpqwAvYMexX+nzM6hFgmcjF+lfovSPAm5IbEEuGVgN1kiRiD6Lf
         Lt0oOwEHtmdtIH9NX6HR7+q69fqiStvFT3ZoiDlFpRPCJItTw/JbFvFUnlyAyf0DOaLY
         Wz76zvUmQ0y9OF+ScrVobA5J/CYhqOpnIB1I02Stazntd8aCqIQSEibB4hPTEwO3Cz+y
         I0hg==
X-Gm-Message-State: ABy/qLY+fS8UJKVQBqTgzNFr9PYBqshmji9DpnQTkBi6cSLENWqpjnZc
        2/t3+4Hn7tCfV0VrQjlPROU=
X-Google-Smtp-Source: APBJJlFD9DjtwDzTWlKNlEtUB9FGJ9bPLRBijCv/B1JFsGrtf/eJQit+5cEu0lwMuIBS7GtAxPzEyQ==
X-Received: by 2002:a17:902:c411:b0:1b8:a67f:1c0f with SMTP id k17-20020a170902c41100b001b8a67f1c0fmr15203176plk.39.1690823443711;
        Mon, 31 Jul 2023 10:10:43 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id m24-20020a170902bb9800b001b87bedcc6fsm8829093pls.93.2023.07.31.10.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 10:10:43 -0700 (PDT)
Date:   Mon, 31 Jul 2023 10:10:41 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/19] QEMU gmem implemention
Message-ID: <20230731171041.GB1807130@ls.amr.corp.intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 12:21:42PM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> This is the first RFC version of enabling KVM gmem[1] as the backend for
> private memory of KVM_X86_PROTECTED_VM.
> 
> It adds the support to create a specific KVM_X86_PROTECTED_VM type VM,
> and introduces 'private' property for memory backend. When the vm type
> is KVM_X86_PROTECTED_VM and memory backend has private enabled as below,
> it will call KVM gmem ioctl to allocate private memory for the backend.
> 
>     $qemu -object memory-backend-ram,id=mem0,size=1G,private=on \
>           -machine q35,kvm-type=sw-protected-vm,memory-backend=mem0 \
> 	  ...
> 
> Unfortunately this patch series fails the boot of OVMF at very early
> stage due to triple fault because KVM doesn't support emulate string IO
> to private memory. We leave it as an open to be discussed.
> 
> There are following design opens that need to be discussed:
> 
> 1. how to determine the vm type?
> 
>    a. like this series, specify the vm type via machine property
>       'kvm-type'
>    b. check the memory backend, if any backend has 'private' property
>       set, the vm-type is set to KVM_X86_PROTECTED_VM.

Hi Xiaoyao.  Because qemu has already confidential guest support, we should
utilize it.  Say,
qemu  \
  -object sw-protected, id=swp0, <more options for KVM_X86_SW_PROTECTED_VM> \
  -machine confidential-guest-support=swp0



> 2. whether 'private' property is needed if we choose 1.b as design 
> 
>    with 1.b, QEMU can decide whether the memory region needs to be
>    private (allocates gmem fd for it) or not, on its own.


Memory region property (how to create KVM memory slot) should be independent
from underlying VM type.  Some (e.g. TDX) may require KVM private memory slot,
some may not.  Leave the decision to its vm type backend.  They can use qemu
memory listener.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
