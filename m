Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBAA6292A1
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 08:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiKOHpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 02:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiKOHpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 02:45:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E2E20994
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 23:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668498252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUayK19F7GRbk/JZ4FyjQnfJe7VwSKFvtpsxXEbqiTc=;
        b=hIklWenUwQZH4Qjax5OaQiksMNZOmEdrB3pJnRu4yLVLNsr1P/4kqac27gnpAiUN7Z+LET
        yyWADUrBGUZJEjUFOedMvtulVJ9+RPCbQ/Zh2+k+p9dfku4tm+0Amtdfey6Vj0sBD3aBMb
        zfUq3jK+wZDLgCSZ5SXl2VDXMrYVdDo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-8NGLcJaeNY6mfKUM2lOTrw-1; Tue, 15 Nov 2022 02:44:10 -0500
X-MC-Unique: 8NGLcJaeNY6mfKUM2lOTrw-1
Received: by mail-qv1-f69.google.com with SMTP id c6-20020ad44306000000b004bb8352cb4cso10179628qvs.14
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 23:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUayK19F7GRbk/JZ4FyjQnfJe7VwSKFvtpsxXEbqiTc=;
        b=A/UQVu5cxLp95cpYLg3Q1+VWCBtKJppGOhzB4wGlEa4ekFBMjH5AzGAR1kT4VXpDXt
         T8zNHW/8kIgV/uC0OHUaUcAQuZhNI+XvBEML5aZcCc8NFXMvYGaF5C5Pz1sCWH23nFE0
         PeHA4R41Wkaf43PNC0XvMV0o9EWlmpBmaTODgNVLiVvsgjMFkC8nNZkSSBa3esYwovr9
         28zDQcUU9MOh4rjJVvKo1n8PRQf7RQRanJXUMwCJbBw6qWV/evA0cHJQCs7t62956DD0
         46uTIiU2SFaoygnNR33IefjCY+9Jcu2DSdyGGNpVQbHO8ezf40XEinb35znOR3J+qKKj
         IPew==
X-Gm-Message-State: ANoB5plMOeop+IadsK+5ugxUCLjIhOSPD68NQt+IrqnDSUmpCm3zUJ1R
        BcWiLAJh3TXc0tMfLba8Oa5rfAxPaaPExH0QNS5qrd2zesGzvb9WhoNCFi6wfiEnG1sB+F2LLkJ
        eRzW6ReLiuYG0
X-Received: by 2002:a37:aa92:0:b0:6fb:85ad:7019 with SMTP id t140-20020a37aa92000000b006fb85ad7019mr5820516qke.661.1668498250108;
        Mon, 14 Nov 2022 23:44:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7kErvpCffa7Nn31R1lnhLhMzbFCN0g9nTo1KI6D603WbA+Z+vQubaHT4BSd51OcggDejT0nw==
X-Received: by 2002:a37:aa92:0:b0:6fb:85ad:7019 with SMTP id t140-20020a37aa92000000b006fb85ad7019mr5820507qke.661.1668498249872;
        Mon, 14 Nov 2022 23:44:09 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-149.web.vodafone.de. [109.43.177.149])
        by smtp.gmail.com with ESMTPSA id z12-20020ac8454c000000b003a4f435e381sm6804248qtn.18.2022.11.14.23.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 23:44:09 -0800 (PST)
Message-ID: <13a59cf1-cb58-4a79-2182-64c53ac41a3f@redhat.com>
Date:   Tue, 15 Nov 2022 08:44:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [qemu-devel]
Content-Language: en-US
To:     Pawel Polawski <ppolawsk@redhat.com>, qemu-devel@nongnu.org
References: <CABchEG2dNgOPnm9K6AJsiWb8z=dOaKe0yjrvxqyU3gdWygQaNw@mail.gmail.com>
Cc:     KVM <kvm@vger.kernel.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <CABchEG2dNgOPnm9K6AJsiWb8z=dOaKe0yjrvxqyU3gdWygQaNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/2022 23.58, Pawel Polawski wrote:
> Hi Everyone,
> 
> I am trying to check qemu virtual cpu boundaries when running a custom
> edk2 based firmware build. For that purpose I want to run qemu with more 
> than 1024 vCPU:
> $QEMU
> -accel kvm
> -m 4G
> -M q35,kernel-irqchip=on,smm=on
> -smp cpus=1025,maxcpus=1025 -global mch.extended-tseg-mbytes=128
> -drive if=pflash,format=raw,file=${CODE},readonly=on
> -drive if=pflash,format=raw,file=${VARS}
> -chardev stdio,id=fwlog
> -device isa-debugcon,iobase=0x402,chardev=fwlog "$@"
> 
> The result is as follows:
> QEMU emulator version 7.0.50 (v7.0.0-1651-g9cc1bf1ebc-dirty)
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> qemu-system-x86_64: -accel kvm: warning: Number of SMP cpus requested (1025) 
> exceeds the recommended cpus supported by KVM (8)
> Number of SMP cpus requested (1025) exceeds the maximum cpus supported by 
> KVM (1024)
> 
> It is not clear to me if I am hitting qemu limitation or KVM limitation here.
> I have changed hardcoded 1024 limits in hw/i386/* files but the limitation 
> is still presented.
> 
> Can someone advise what I should debug next looking for those vCPU limits?

Well, the error message says it: There is a limitation in KVM, i.e. in the 
kernel code, too. I think it is KVM_MAX_VCPUS in the file 
arch/x86/include/asm/kvm_host.h of the Linux kernel sources... so if you're 
brave, you might want to increase that value there and rebuild your own 
kernel. Not sure whether that works, though.

  Thomas

