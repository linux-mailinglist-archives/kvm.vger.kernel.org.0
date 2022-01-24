Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06FC49887C
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245125AbiAXSj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245263AbiAXSjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:39:52 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909FCC061744
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 10:39:49 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id b12-20020a9d754c000000b0059eb935359eso7169028otl.8
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 10:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TMOoJdMhUDORBefs00VmxKihwl9WgGcpvPDC2CZRhSE=;
        b=fpUF6j2KLrWB9hx0+tijEYKWSWYI0cPsUuVk3Pp3GVOo+r6BvABjrTCf2oUyAb8+nx
         VDSUEkGh2tBQJ9p3z/SCjs5i2UnF153Yjwcv2jG37as6e59lFXexl8CWXj+HQZK2Qgjl
         TZ+O11rI8F6E5xAXbLM9ASl8CAWADa9abFlsWf71Dj8FE7AwDiBWdPMHGS03gRmygofe
         W9OuT4glUqknX9mjR4IdKEnpvR9bJzKL9L+mFhFSWVh2d5SBwbXJ5O0h9qYpQSVkr2BN
         KwcB0KkxiJEyhOyeXb8ook+FcELUYotxmfX95+Yl6GqVjDRfzkUNUFKKvaGtHzwtRmFQ
         +7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TMOoJdMhUDORBefs00VmxKihwl9WgGcpvPDC2CZRhSE=;
        b=bqss76WW+WS9Oi9PCmVL7xN2HCo7pXOQZQMdtXM+6XdCHRkAXJsBGH4/QJ2Ccg/08F
         ic3NHfx6u6LeEJXgIAKHMJ7NWFD0pfBNzem/rlp5NZSUDQ3GpC0S1TYZGwmMKwbIYVXi
         U4cAZ4/fHOVKcDDD+MoexNaDxKvah422eN7uI3Q547EWq1+QHEfKgk0X7OERRmVKCZIT
         +2HrLR+SiPAYOgPdiJkaX2bUQ+sNKbyAoyag8FmKcQDAf5ziVdiUH1Rytli95Ifq9Nus
         AM1a46URsyKlwPIBDtTwVTdAzBwsNCXSHDBKAVPKf8iAcVbbQf81a5+EbhfzH18/I7Lp
         C8Tw==
X-Gm-Message-State: AOAM533ENSDIsv51ukDFuGpm9CT8lcysMFUp6O0QDb+gfgP9MR9t5De+
        c3h2vX/gHNLIl3dGYaN3scGpStCrfhtdnYkxVzmVEA==
X-Google-Smtp-Source: ABdhPJydfgi9Z9tFPiAcCC4Ol3hd5zgw17w1hN8WiVBGholCDwXgw+GyDtQs9stjzYD7DfoIoY67tNMlXZkfFFvcNQQ=
X-Received: by 2002:a05:6830:1e76:: with SMTP id m22mr7561621otr.75.1643049588705;
 Mon, 24 Jan 2022 10:39:48 -0800 (PST)
MIME-Version: 1.0
References: <20220123184541.993212-1-daviddunn@google.com> <20220123184541.993212-2-daviddunn@google.com>
In-Reply-To: <20220123184541.993212-2-daviddunn@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 Jan 2022 10:39:37 -0800
Message-ID: <CALMp9eSuavLEJ0_jwuOgmSX+Y8iJLsJT0xkGfMZg6B7kGyDmBQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
To:     David Dunn <daviddunn@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        cloudliang@tencent.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 23, 2022 at 10:45 AM David Dunn <daviddunn@google.com> wrote:
>
> KVM_CAP_PMU_DISABLE is used to disable PMU virtualization on individual
> x86 VMs.  PMU configuration must be done prior to creating VCPUs.
>
> To enable future extension, KVM_CAP_PMU_CAPABILITY reports available
> settings via bitmask when queried via check_extension.
>
> For VMs that have PMU virtualization disabled, usermode will need to
> clear CPUID leaf 0xA to notify guests.
>
> Signed-off-by: David Dunn <daviddunn@google.com>

Nit: The two references to CPUID leaf 0xA should be qualified as
applying only to Intel VMs.

Reviewed-by: Jim Mattson <jmattson@google.com>
