Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF0D44446F
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 16:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhKCPQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 11:16:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231211AbhKCPQB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 11:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635952404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EcjS/U0esOcZt9aUj7QJ/b283I90hVCo2RapOPx/5rA=;
        b=Ltmf8ABWzCBvg0QM2Fdt0Q54MjllwWtbtv0FgWi4as1xoDVKuWl7WKcSoLpNnVxlGIkclq
        EfniUsgvW6E/KtNVDnKRxlXVHXfygacp1QIIXL+/IaFjOn/HnWvoP47b7lJxGplswHFaeu
        qb6S+1lNz9Q74n/74ndiPv1tNrjs4oA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-o2pNEwa1NSSJHItDcklF9g-1; Wed, 03 Nov 2021 11:13:23 -0400
X-MC-Unique: o2pNEwa1NSSJHItDcklF9g-1
Received: by mail-wr1-f72.google.com with SMTP id q17-20020adfcd91000000b0017bcb12ad4fso497216wrj.12
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 08:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EcjS/U0esOcZt9aUj7QJ/b283I90hVCo2RapOPx/5rA=;
        b=ombfLZdlfSjPn/HVPl4eH54oZJvsWRAlEOcGrUwz+dlg96AOYPVj7AK00E6aatk9s5
         bqpYB/Lz1dFOzj/XLJFabvGDNYP3kZOCqYmCCcw+t84RpL36GVYDflrFv1m/A7UfMmSN
         CR+g+Iwoo9ItcO/nAx0zP/R0Dq6xtoB1wRh7cLNyRtWY5qzfDnfyFIZXYZp/LTGITcHb
         TZ0oUeKSh2NA+6w3l3beKH193AfA401DLX8tKf6IdYzWQRq0A2HM6J0zZtMkO42JTk+n
         LvWvumoqkE/sBfZBCv9Ctl/4BaW8nOKcPoYFHQ0jTnRdiV9dA21ppGrK2DV5HfO/0ln5
         b71Q==
X-Gm-Message-State: AOAM532rh4JaV01tamlqMYMoRkq9DykDjOyaAmLBZlOymCUnAJHyCj9N
        PlEx86Ehc1Tja7qFhj7Elx4DoMbosmkGgpEAVa6cBqmIIJ6vhZqw/zx5NFEj4xG3UUYRTN4Ky+0
        6bQgtteNUOkgJ
X-Received: by 2002:a05:600c:198d:: with SMTP id t13mr16116857wmq.21.1635952402184;
        Wed, 03 Nov 2021 08:13:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywJOfU5ytKMlivfLi6bw4DBBApAa9fqr7O37GSjz4t8SwMadSRVC41M824DZivE+K+jo0kcg==
X-Received: by 2002:a05:600c:198d:: with SMTP id t13mr16116832wmq.21.1635952402009;
        Wed, 03 Nov 2021 08:13:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w1sm5574500wmc.19.2021.11.03.08.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:13:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: nVMX: Enlightened MSR Bitmap feature for
 Hyper-V on KVM
In-Reply-To: <20211013142258.1738415-1-vkuznets@redhat.com>
References: <20211013142258.1738415-1-vkuznets@redhat.com>
Date:   Wed, 03 Nov 2021 16:13:18 +0100
Message-ID: <87r1bxmfw1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v2:
> - Renamed 'msr_bitmap_changed' to 'msr_bitmap_force_recalc' [Paolo] and
>   expanded the comment near its definition explaining its limited 
>   usefulness [Sean].
>
> Original description:
>
> Updating MSR bitmap for L2 is not cheap and rearly needed. TLFS for Hyper-V
> offers 'Enlightened MSR Bitmap' feature which allows L1 hypervisor to
> inform L0 when it changes MSR bitmap, this eliminates the need to examine
> L1's MSR bitmap for L2 every time when 'real' MSR bitmap for L2 gets
> constructed.
>
> When the feature is enabled for Win10+WSL2, it shaves off around 700 CPU
> cycles from a nested vmexit cost (tight cpuid loop test).
>
> First patch of the series is unrelated to the newly implemented feature,
> it fixes a bug in Enlightened MSR Bitmap usage when KVM runs as a nested
> hypervisor on top of Hyper-V.
>

Ping?

-- 
Vitaly

