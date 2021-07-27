Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4403D7CFE
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhG0SBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229903AbhG0SBW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 14:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627408881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3ve2LBl56pycpmfaPjVOw8bmB5e513L10q/E/QV624=;
        b=Vc/UF1nSeFL//6GK81EkcNS4osTZsobWIS7dRKcZY5JF7bBXBdqvIIp78SplYIz2I6qN0r
        shn8MusvDE28/IAUxt228oRIVd55JHX8cb5QZx2styRApSEX7WerdgiaxwZ47PDb4zoEPj
        9WA6c/2pdOyazTuwjlceOVVmt8P2j/Q=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-wX0vUad_NV6NAipQc3SvEw-1; Tue, 27 Jul 2021 14:01:20 -0400
X-MC-Unique: wX0vUad_NV6NAipQc3SvEw-1
Received: by mail-ot1-f70.google.com with SMTP id m19-20020a9d6ad30000b02904b7c1fa2d7cso7733517otq.16
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l3ve2LBl56pycpmfaPjVOw8bmB5e513L10q/E/QV624=;
        b=I7i6pQvZJalKvSFTzasUh48BH+CHQ7cNe2JM0zFdooibSUIydCdr6D8y2eZLeNWgTr
         wGCKSlL417O7H8UGzRu4wfLDyJoTqHbVuj3I9IrdeX0pPQdyQ31NKedrvMkbtJdtlZeF
         Rsi79Jkd917QnQviJUNRkTa9rURi4HbelMHAR0zLM/nHHEg4D5TefxOb2CWoFHbbPtqJ
         xF8elC/pdBqv2aONgcshVnOejF+Kjvouiquvtqv/7hobTiruAsfQ4QlzEXar2puNk/2N
         A+JkNnVgIyg/+al3dt96AvvZG6HwP9WbL0yRC69bVtSLwmtaueYVMQEyRUj9wpH1qBNl
         3nnQ==
X-Gm-Message-State: AOAM531ZyDYtNCjcgvZHtOYMWlM6+olSPJqLJ1PtVPYs6rmFRuDBUh/I
        L8pUu9LaPiNDf4pxcB0ehgNSHFH/BzwHfm+wX5Zw6CHdN03ZUTPleXJ1xt9tzjQLmzXxdSG4Vcn
        Erc3XVRpMqHkA
X-Received: by 2002:a05:6830:1290:: with SMTP id z16mr16147241otp.28.1627408879834;
        Tue, 27 Jul 2021 11:01:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxceHuuEWZyk5OIY/tJfuObz6ctGzXsZrPVW7DXIyY1hsrLGqacGF+MYgp+dgviBsUHRwmow==
X-Received: by 2002:a05:6830:1290:: with SMTP id z16mr16147135otp.28.1627408878209;
        Tue, 27 Jul 2021 11:01:18 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id y76sm664344oie.55.2021.07.27.11.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:01:17 -0700 (PDT)
Date:   Tue, 27 Jul 2021 12:01:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Cai Huoqing <caihuoqing@baidu.com>, jgg@ziepe.ca,
        eric.auger@redhat.com, kevin.tian@intel.com,
        giovanni.cabiddu@intel.com, mgurtovoy@nvidia.com, jannh@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Add "#ifdef CONFIG_MMU" for vma operations
Message-ID: <20210727120116.61ba8e25.alex.williamson@redhat.com>
In-Reply-To: <877dhb4svx.fsf@redhat.com>
References: <20210727034000.547-1-caihuoqing@baidu.com>
        <877dhb4svx.fsf@redhat.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Jul 2021 18:35:14 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, Jul 27 2021, Cai Huoqing <caihuoqing@baidu.com> wrote:
> 
> > Add "#ifdef CONFIG_MMU",
> > because vma mmap and vm_operations_struct depend on MMU  
> 
> vfio_pci already depends on MMU -- what problems are you trying to fix?

Exactly my question, we silenced the randconfig builds without
CONFIG_MMU in commit 2a55ca373501 ("vfio/pci: zap_vma_ptes() needs
MMU").  Surely there are prototypes for vma_area_struct regardless of
CONFIG_MMU and vfio-core having an mmap callback has no dependency on
vm_operations_struct.  Thanks,

Alex

