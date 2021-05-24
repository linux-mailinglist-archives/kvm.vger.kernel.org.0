Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6938E3BC
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 12:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhEXKPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 06:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232318AbhEXKPY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 06:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621851235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+c38WjvMpDN+6Rjwf4EFNWt4n/mNwo36EdfxuRYJpdw=;
        b=gIF5n0ZuZn5Urh+nKz1fkECbVLe9lWcFP5SrWKTOsbsQ88h4z2wjKRIQ3USeCiuomzAb8f
        U216PwmJpwrYE+po8DG4G5FZ0/ikWwxVNNO3JZnvsvPHDFSkCo/+WvjOlO13R+RDmzuZ5X
        lDNYr3vMMvdQfTZ39xYxJE69fe3ITvs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-aMhoPQjeO1mZYRbbTrtEbQ-1; Mon, 24 May 2021 06:13:54 -0400
X-MC-Unique: aMhoPQjeO1mZYRbbTrtEbQ-1
Received: by mail-wr1-f71.google.com with SMTP id d12-20020adfc3cc0000b029011166e2f1a7so11843086wrg.19
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 03:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+c38WjvMpDN+6Rjwf4EFNWt4n/mNwo36EdfxuRYJpdw=;
        b=lEYS7XpAPgBsPT3VVLGmSd2XEtB0b2BRuP/Gn3BPpN9wLsXQTB80OX8ecTBhhEG8dU
         mGLroiQOmqDrJ1XMaLasJZ8wKOumIi+TEbWToKGDwKoSzGOvAE/udPBVF48pQIJk85sC
         5yvMJILuDVGt59StHtB4KAyUqLIa3gn1wEw13P0R2FdPfbO9ui+QH8JGdirrxO3XXNiK
         KOEBJbqUPnoYSaJUoG6mNqXnwPq/s+yVW13pb0KvNRiXqqWoCALSD1sLhpN4uhwe7oY2
         3Jilyc90fiKh06L4N1y6DRR4Qjbz+tbGy89s/3WP5g29e+a7nNLSW5D2YaKHbcobBtu7
         SqUA==
X-Gm-Message-State: AOAM532SYc7mYzZZc43ml5MDPYlPoIjuRcyWanV94IQgHasl7iQLz+AZ
        0j+cbFT7cLhGff6EniFCnRthiT/O2yn3cM/SX9Ox7qdOFRTRAE/H5wVSAAG8NO2CJQFOwgPz8aO
        3/jNpJvmULhqT
X-Received: by 2002:a5d:40cd:: with SMTP id b13mr21584131wrq.356.1621851232905;
        Mon, 24 May 2021 03:13:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDyf+CK8zWNAHLPiY6kH+SY2jdygi8F4n8y9ufi3OpQ3QICMbepp/m72wZeVSVxyHBgevgMA==
X-Received: by 2002:a5d:40cd:: with SMTP id b13mr21584104wrq.356.1621851232665;
        Mon, 24 May 2021 03:13:52 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id r11sm11824173wrp.46.2021.05.24.03.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 03:13:52 -0700 (PDT)
Date:   Mon, 24 May 2021 06:13:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: Windows fails to boot after rebase to QEMU master
Message-ID: <20210524055322-mutt-send-email-mst@kernel.org>
References: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 11:17:19AM +0200, Siddharth Chandrasekaran wrote:
> After a rebase to QEMU master, I am having trouble booting windows VMs.
> Git bisect indicates commit f5cc5a5c1686 ("i386: split cpu accelerators
> from cpu.c, using AccelCPUClass") to have introduced the issue. I spent
> some time looking at into it yesterday without much luck.
> 
> Steps to reproduce:
> 
>     $ ./configure --enable-kvm --disable-xen --target-list=x86_64-softmmu --enable-debug
>     $ make -j `nproc`
>     $ ./build/x86_64-softmmu/qemu-system-x86_64 \
>         -cpu host,hv_synic,hv_vpindex,hv_time,hv_runtime,hv_stimer,hv_crash \
>         -enable-kvm \
>         -name test,debug-threads=on \
>         -smp 1,threads=1,cores=1,sockets=1 \
>         -m 4G \
>         -net nic -net user \
>         -boot d,menu=on \
>         -usbdevice tablet \
>         -vnc :3 \
>         -machine q35,smm=on \
>         -drive if=pflash,format=raw,readonly=on,unit=0,file="../OVMF_CODE.secboot.fd" \
>         -drive if=pflash,format=raw,unit=1,file="../OVMF_VARS.secboot.fd" \
>         -global ICH9-LPC.disable_s3=1 \
>         -global driver=cfi.pflash01,property=secure,value=on \
>         -cdrom "../Windows_Server_2016_14393.ISO" \
>         -drive file="../win_server_2016.qcow2",format=qcow2,if=none,id=rootfs_drive \
>         -device ahci,id=ahci \
>         -device ide-hd,drive=rootfs_drive,bus=ahci.0
> 
> If the issue is not obvious, I'd like some pointers on how to go about
> fixing this issue.
> 
> ~ Sid.
> 

At a guess this commit inadvertently changed something in the CPU ID.
I'd start by using a linux guest to dump cpuid before and after the
change.


> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

