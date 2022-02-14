Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C364B5567
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 16:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355999AbiBNPzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 10:55:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356039AbiBNPza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 10:55:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FAE65FF0B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 07:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644854119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUa0hl6k/nbpuVXlvGywiBDBTIXScMw6WCDwSAsa580=;
        b=UPHNe6aBag95QExqlX26GjrQkCa3HW/SQ42aULq0XYpF2nDL5qHBT4xMNPvbdi5fBKYKc8
        S/oBHGtTOB/n24F1BigcZ1Pud/xyJPbUBVXTsw9z44Xr43Jmp2jxOYacSmjOv6IqFkFyfG
        8XQkTAwNNO64ns9vLu91Egt2Rzp0jDs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-kmhLIwovNhCfJkVKurhBPg-1; Mon, 14 Feb 2022 10:55:18 -0500
X-MC-Unique: kmhLIwovNhCfJkVKurhBPg-1
Received: by mail-ej1-f69.google.com with SMTP id ga31-20020a1709070c1f00b006cec400422fso1056904ejc.22
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 07:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUa0hl6k/nbpuVXlvGywiBDBTIXScMw6WCDwSAsa580=;
        b=SThgl13Ay7Ge9PEe1ErI28ETg/51gon9VsRQKTkkp2ggoKHvqIw7vUFg9WbgFYkVS3
         YuHLmChALsFGyMpUEgcPU2A4sfiPkmLf9YmcXQkZu+KBN2W9LOuvYP7XkpSR+aWIjjuN
         YeJz/6SKPen+e3SDTnIIW7HLs32KRNkGwD/B14wcu6agxbjovVh6tx51FtM7yRVTRf0v
         y0tOm7aB79PXY7xnV4qKvojCb1AyEGXtPgCZoHpApQtdujMdBQZZutphP/Ad7QG9Keq6
         x1L98DNXerqrIXcrYHsh0TkSE9Ybqaxz4Bd4TnsY/EJBFeN3RHJsoOeWe/GOQEgNutQ1
         AT1w==
X-Gm-Message-State: AOAM531UgJuNMgpsLBf7/G7G4r6HBj64Hz5BQVzCziuQIvmH+rJ88jgm
        GCIse24oobep9AKHqc/4UoT54RSI14uxJwKN3jwteNuManB3//7OTZg97qz8ijNjNlYO8ysjs9y
        uMQJKaWsQNOrH
X-Received: by 2002:a17:906:c144:: with SMTP id dp4mr167076ejc.89.1644854116913;
        Mon, 14 Feb 2022 07:55:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzh9lZQgMTWnpjEY/A1H9jKYIbUL7r5CNEvJS6H+WSrt91ekSKdyjpvbKBNvlHTq1cZDz1kwA==
X-Received: by 2002:a17:906:c144:: with SMTP id dp4mr167055ejc.89.1644854116647;
        Mon, 14 Feb 2022 07:55:16 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k7sm10746112eje.162.2022.02.14.07.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 07:55:16 -0800 (PST)
Date:   Mon, 14 Feb 2022 16:55:15 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Ani Sinha <ani@anisinha.ca>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: 9 TiB vm memory creation
Message-ID: <20220214165515.226a1955@redhat.com>
In-Reply-To: <b9771171-8d28-b46b-4474-687a8fed0abd@redhat.com>
References: <alpine.DEB.2.22.394.2202141048390.13781@anisinha-lenovo>
        <20220214133634.248d7de0@redhat.com>
        <b9771171-8d28-b46b-4474-687a8fed0abd@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Feb 2022 15:37:53 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 14.02.22 13:36, Igor Mammedov wrote:
> > On Mon, 14 Feb 2022 10:54:22 +0530 (IST)
> > Ani Sinha <ani@anisinha.ca> wrote:
> >   
> >> Hi Igor:
> >>
> >> I failed to spawn a 9 Tib VM. The max I could do was a 2 TiB vm on my
> >> system with the following commandline before either the system
> >> destabilized or the OOM killed killed qemu
> >>
> >> -m 2T,maxmem=9T,slots=1 \
> >> -object memory-backend-file,id=mem0,size=2T,mem-path=/data/temp/memfile,prealloc=off \
> >> -machine memory-backend=mem0 \
> >> -chardev file,path=/tmp/debugcon2.txt,id=debugcon \
> >> -device isa-debugcon,iobase=0x402,chardev=debugcon \
> >>
> >> I have attached the debugcon output from 2 TiB vm.
> >> Is there any other commandline parameters or options I should try?
> >>
> >> thanks
> >> ani  
> > 
> > $ truncate -s 9T 9tb_sparse_disk.img
> > $ qemu-system-x86_64 -m 9T \
> >   -object memory-backend-file,id=mem0,size=9T,mem-path=9tb_sparse_disk.img,prealloc=off,share=on \
> >   -machine memory-backend=mem0
> > 
> > works for me till GRUB menu, with sufficient guest kernel
> > persuasion (i.e. CLI limit ram size to something reasonable) you can boot linux
> > guest on it and inspect SMBIOS tables comfortably.
> > 
> > 
> > With KVM enabled it bails out with:
> >    qemu-system-x86_64: kvm_set_user_memory_region: KVM_SET_USER_MEMORY_REGION failed, slot=1, start=0x100000000, size=0x8ff40000000: Invalid argument
> > 
> > all of that on a host with 32G of RAM/no swap.
> >
> >   
> 
> #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
> 
> ~8 TiB (7,999999)

so essentially that's the our max for initial RAM
(ignoring initial RAM slots before 4Gb)

Are you aware of any attempts to make it larger?

But can we use extra pc-dimm devices for additional memory (with 8TiB limit)
as that will use another memslot?


> 
> In QEMU, we have
> 
> static hwaddr kvm_max_slot_size = ~0;
> 
> And only s390x sets
> 
> kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
> 
> with
> 
> #define KVM_SLOT_MAX_BYTES (4UL * TiB)
in QEMU default value is:
  static hwaddr kvm_max_slot_size = ~0
it is kernel side that's failing






