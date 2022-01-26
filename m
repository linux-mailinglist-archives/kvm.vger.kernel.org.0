Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8E949C4AF
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 08:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiAZHnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 02:43:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbiAZHnu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 02:43:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643183029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=99lDe6IkWn7gUyDg0qSREmrDeUHCrkfT6SeNO9U7qrs=;
        b=Myyjgj29zVx2BsE6OqkAQYJk9n5lHjCXqsN5LqkCPWjxWA03gOy/aVx+uLIJMp412Nn4e0
        dPcwxqNmqT4z2otTaC5XL/EWR+S1Yslk3Pq6ga+kgSeucgS2H3Iv+7EjpAXIWlY3W5H5Uu
        Ro10/FJvhAc+4H9DVjqPaR8K4GBweyU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-NKc_OnTDPL-Hoi-wlPaHSQ-1; Wed, 26 Jan 2022 02:43:47 -0500
X-MC-Unique: NKc_OnTDPL-Hoi-wlPaHSQ-1
Received: by mail-ej1-f72.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso4489262eje.20
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 23:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=99lDe6IkWn7gUyDg0qSREmrDeUHCrkfT6SeNO9U7qrs=;
        b=8NgNdj/5GXGnm90l7CkRorST7lvCFMGSxE+MiUG4nhKhGewDG5i5f0jGYhVwWFweOf
         cB7ORfSfZDCkJgSaibqND7Cqh11u1VT1rwgiFkrQqd6w8dWjVveeiYvXqkpqsp3mwe1n
         dfgyWr2aRFT8jjC+gUUJiBX3YETF4TQbAje9Vsgl/wFMGF5fZ+4JvfEE1JFUmc0B3xtg
         +vD6iZlHyf702MA/q3DalyLDO6W+h5NS4lF7InPtD3iL0bVV9nlIbEqiTCzagYm/HCPr
         kDrm2FhjWE4qXpfuF6NFx2oOCWiJ/Yny4tJ9B4XiZbiWjhhORs668Ju9JEHK0nt2V8NZ
         v/9w==
X-Gm-Message-State: AOAM532OQZI2JQmaPF7EOC/tu+RSPDpM6Cg5mkodwAZ1Y5yzoQFzfJhO
        MkkDcB6tmz2pZ1NSa5Mbu7hr/8/HP0MXW62mW2pIqKkPc1nXiEnfrDEha8jrD/AKALopHjAM+/W
        t6PFrFe15mjh8
X-Received: by 2002:a17:906:6082:: with SMTP id t2mr18606905ejj.710.1643183026726;
        Tue, 25 Jan 2022 23:43:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+DrubH0F+92i+OiORYto39YnyVe3nkzLFWDh6ksWTmhYplpgBkCrS7ppuBorxkf+GPBKTjQ==
X-Received: by 2002:a17:906:6082:: with SMTP id t2mr18606895ejj.710.1643183026512;
        Tue, 25 Jan 2022 23:43:46 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id d17sm9400365ede.88.2022.01.25.23.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:43:46 -0800 (PST)
Date:   Wed, 26 Jan 2022 08:43:44 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Use a prefix for the STANDALONE
 environment variable
Message-ID: <20220126074344.pgwqwgq5hsv7ykmu@gator>
References: <20220120182200.152835-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120182200.152835-1-thuth@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022 at 07:22:00PM +0100, Thomas Huth wrote:
> Seems like "STANDALONE" is too generic and causes a conflict in
> certain environments (see bug link below). Add a prefix here to
> decrease the possibility of a conflict here.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/3
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/run                 | 2 +-
>  powerpc/run             | 2 +-
>  s390x/run               | 2 +-
>  scripts/mkstandalone.sh | 2 +-
>  scripts/runtime.bash    | 4 ++--
>  x86/run                 | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)

Reviewed-by: Andrew Jones <drjones@redhat.com>

