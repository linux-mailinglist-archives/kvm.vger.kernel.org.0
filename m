Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4A26D7FFA
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbjDEOtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbjDEOta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A003C22
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 07:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680706121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RCw9jxHLaTR3n66vuo19FqVdqa/TPq12sjoGedpZV/Y=;
        b=gtGHKZWdMUB3dcUXszOCe8UYEJnCGZLPUtz6IA2ymvOFI2CNKa9cESnXwzO9jKy/E9DZs9
        KqIA5y4PV4mNAR3wpDe54nF2C+/1krOLerJyY35vn9EIcqQkBipCiqwALMQawu/DH8wBcd
        K+mNuixdJy6a+V6OXCy2lHLxGeOMiek=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-4LU-bZtEPCWedHeFlfSEKQ-1; Wed, 05 Apr 2023 10:48:40 -0400
X-MC-Unique: 4LU-bZtEPCWedHeFlfSEKQ-1
Received: by mail-qt1-f198.google.com with SMTP id v10-20020a05622a130a00b003e4ee70e001so18313306qtk.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 07:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680706120;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCw9jxHLaTR3n66vuo19FqVdqa/TPq12sjoGedpZV/Y=;
        b=4wclwvPSowKr0MaXbhOxE9Q192nG7fcS9u4cixsxtwREHzJNCXMP9arzdw8I7wotTi
         bkkA82rvApKKvMWyLxzcAoMKv9qFBHaZ3p3jrshv4tJWD9kI381MensfxypVnzgyeOIH
         2+Wzd29zuI0WMahGqXHxtkqef278CeBUO4oKbaZKZJRa+ovnhzHE7T4O+AN9ljlHKGpm
         7b/ZKg77dmzERxZcjqgifNEnEMuPjH+WrcAhAojHWXwMnBTs7l6CKq4iO9OQpcd+dwQH
         UsQt8veqvVmErx9l+xrrosntrwOBgHLHopzFG50BHR8SAexnKV+btIY3ajG/BM9+DXrt
         EL1A==
X-Gm-Message-State: AAQBX9d82+VkMX8AEiOW/r/doo/kwOjoP1T970JNVN5jBf0XGgnKVTZw
        A4bC5xkbz+tAuvDqRBSyhEyfElJscQQghbPH2U+GpgaBqE25Az83wEdHwPBJKG5yhMyDlpiK39W
        bcxwYMMdOVPkL
X-Received: by 2002:a05:6214:f05:b0:5c2:d241:9c1d with SMTP id gw5-20020a0562140f0500b005c2d2419c1dmr10198277qvb.27.1680706120122;
        Wed, 05 Apr 2023 07:48:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350YdL4KA/7SlkiMECTM07KbfSyoovgQz5l0MYDi8ZHVnT0N4uJz7y2ZDFRrNG0RVpkI/RzdX3g==
X-Received: by 2002:a05:6214:f05:b0:5c2:d241:9c1d with SMTP id gw5-20020a0562140f0500b005c2d2419c1dmr10198253qvb.27.1680706119863;
        Wed, 05 Apr 2023 07:48:39 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id kr22-20020a0562142b9600b005e45f6cb74bsm1535061qvb.79.2023.04.05.07.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:48:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: More cleanups for Hyper-V range flushing
In-Reply-To: <20230405003133.419177-1-seanjc@google.com>
References: <20230405003133.419177-1-seanjc@google.com>
Date:   Wed, 05 Apr 2023 16:48:36 +0200
Message-ID: <87lej6gzaz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> More cleanups of the code related to Hyper-V's range-based TLB flushing.
> David's series got most of the names, but there are a few more that can
> be converted (patch 1).  On top of that, having Hyper-V fill its struct
> provides a decent improvement to code generation, and IMO yields a better
> API (patch 2).
>
> Sean Christopherson (2):
>   KVM: x86: Rename Hyper-V remote TLB hooks to match established scheme
>   KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V
>     code
>

For the series:
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

