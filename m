Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BD11ADAAC
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 12:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgDQKD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 06:03:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51553 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726753AbgDQKDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 06:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587117804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ElYTrTrSJKdE2tYQriD77Ds10y+cL36iV21AUMPYK8=;
        b=WJ6FedXCjSxzHXR2Ym+0z1zXq7vuDaHcx3/n7he8xfb+zNnFspb5y2Ezq/R54s252jDtIB
        4QMIlVOgXjSuh/U1rXOy0ukLCZOZ8iRp8GhEGFBd64jabGU9O4Iad01EGn9obxD2N5Bqbx
        zmJu60jCA71qdNa8m+k0pmhX3lmMZVI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-nuzsFCLjNm-UtaV4Lt-WjQ-1; Fri, 17 Apr 2020 06:03:22 -0400
X-MC-Unique: nuzsFCLjNm-UtaV4Lt-WjQ-1
Received: by mail-wm1-f70.google.com with SMTP id f81so623633wmf.2
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 03:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5ElYTrTrSJKdE2tYQriD77Ds10y+cL36iV21AUMPYK8=;
        b=aJ8hgDb8A71tPJkW2vG/zYf/eLXPZ0JCoqb3W34hQRnIKwXayHLLHBLSm9WoNr3zMF
         DhS40DmjroER/btiWhs5z/B1Y8s3gzkHyhFHXJsw8U6KwGBHGIzndu5QpMF/WxVSiLX4
         xjyE3YaBccTlYP4vzVxJJguYE3EcYiU0hwKPt0xA/HbX1nRUH09R3dV0MjeLxEKDN0ep
         th4CT2/lBJfvqAh0Ym136xW9Qh1TtKgKloqmN+gnQYutcmPOZmcK8rtgTKaQTSKFDvSc
         /2RZbrtCV8O8yFReMOaxOTPP5Gpt9N4UgzzqM8VKLDuT6VTW+/UUfctt5CJ4Zy9hdW5g
         ISGw==
X-Gm-Message-State: AGi0PuYidJfKD4k36gRt9jvNVwp/r2+N1Wr94p8oCKhdKb+HFiEiCIxD
        L7HNhqpsos6ZyZYAxu6WBzhfSlaWNkyaaWrLh0lTjzJrqJtervEoW+a+EuQzseg63hMq4SvaDRs
        EoSftCrbJsRjn
X-Received: by 2002:adf:97cc:: with SMTP id t12mr2964685wrb.261.1587117801270;
        Fri, 17 Apr 2020 03:03:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypKYH+JBn8/yn3IYbL7Qlc8+A7kS9lt5b8RYcDiZb5T6r+5ekluPE9YgLZGiyQIkvKPQZtVJZg==
X-Received: by 2002:adf:97cc:: with SMTP id t12mr2964656wrb.261.1587117801045;
        Fri, 17 Apr 2020 03:03:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s8sm1178080wru.38.2020.04.17.03.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 03:03:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     bp@alien8.de, haiyangz@microsoft.com, hpa@zytor.com,
        kys@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        sthemmin@microsoft.com, tglx@linutronix.de, x86@kernel.org,
        mikelley@microsoft.com, wei.liu@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/hyperv: Suspend/resume the VP assist page for hibernation
In-Reply-To: <1587104999-28927-1-git-send-email-decui@microsoft.com>
References: <1587104999-28927-1-git-send-email-decui@microsoft.com>
Date:   Fri, 17 Apr 2020 12:03:18 +0200
Message-ID: <87blnqv389.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> Unlike the other CPUs, CPU0 is never offlined during hibernation. So in the
> resume path, the "new" kernel's VP assist page is not suspended (i.e.
> disabled), and later when we jump to the "old" kernel, the page is not
> properly re-enabled for CPU0 with the allocated page from the old kernel.
>
> So far, the VP assist page is only used by hv_apic_eoi_write().

No, not only for that ('git grep hv_get_vp_assist_page')

KVM on Hyper-V also needs VP assist page to use Enlightened VMCS. In
particular, Enlightened VMPTR is written there.

This makes me wonder: how does hibernation work with KVM in case we use
Enlightened VMCS and we have VMs running? We need to make sure VP Assist
page content is preserved.

-- 
Vitaly

