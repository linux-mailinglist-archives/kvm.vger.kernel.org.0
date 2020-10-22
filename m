Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D620F295FF9
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 15:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899800AbgJVNZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 09:25:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895164AbgJVNZx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 09:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603373152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BxPfxPSNfbnVjf34ePIHdZQgNiJCJyxLs4IXArAnJmw=;
        b=ChZloRpmYo1wsevYhGItQmJK3iulJyb1NkdWOlsHsGeewypAYeSCCjlpgM30F3uCLN3xSc
        BoE8vS9sIGkj3oIDQsCk/DT5o4gS1CG53dV3X1phaLzrNGKNkhZlK6ZjLpj54+TjKgjxVS
        /yUgblaLhANLMhm6lK33a3SL3GKLLeE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-XVgcj754P82cd8YY1t3k9Q-1; Thu, 22 Oct 2020 09:25:50 -0400
X-MC-Unique: XVgcj754P82cd8YY1t3k9Q-1
Received: by mail-wm1-f70.google.com with SMTP id u5so429345wme.3
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 06:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BxPfxPSNfbnVjf34ePIHdZQgNiJCJyxLs4IXArAnJmw=;
        b=SQKB2i+EfPZ+gGjZ61zZsj8sLBFa96FTbyBSe9bBLEcOPEAWzL9SAb5acw1AfljL1s
         e09bTzy5/y9expfgPDt+S/N3Sv+IblxVFPRM8Fhr5fuk+VqwKiHSj/7U5Sg/dnzJ1Dru
         mEiObmyIsIqp1aCqdpcSOV3vDeB9BSztiG3q2GSOLjeSepEOFMk4S69qRxNYMZlaR9oo
         O7aGryo28eiCpKvRpKQ2dQvPKIwRLkdm3UGGIhR1QQmPiydRltOaMxUNYVoQShp28L2p
         xI/uXS035YuKz6Copd8QnuZqnjJHyZSZZ6ymY/7Sg1sZPMYJbx0ytth17YWiasAHA+0N
         7IuA==
X-Gm-Message-State: AOAM530QzaWD/R8ulM3uYjPtsjVmKkXBmtgxfHJTO0xgdYZnlm+iGRJQ
        k1/5HU4H9IDbEJT2zn0rBbXAUdQOvtdfWdhlXVk/TQ5OYTTCNszTjMlA7SqkqhUtbqqE2depUXe
        M/DHI3rSwTrp+
X-Received: by 2002:a7b:cb10:: with SMTP id u16mr2568583wmj.20.1603373149088;
        Thu, 22 Oct 2020 06:25:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2n8WajVbZY49NzRz8HTVBT9A01wzfAhU1/YFTB2zSdisHBFJ3+FJItC+mxqL674ywS9q03Q==
X-Received: by 2002:a7b:cb10:: with SMTP id u16mr2568565wmj.20.1603373148910;
        Thu, 22 Oct 2020 06:25:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k6sm3778509wmk.16.2020.10.22.06.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 06:25:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in KVM_GET_SUPPORTED_CPUID
In-Reply-To: <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com> <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
Date:   Thu, 22 Oct 2020 15:25:46 +0200
Message-ID: <871rhq4ckl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 22/10/20 03:34, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>> 
>> Per KVM_GET_SUPPORTED_CPUID ioctl documentation:
>> 
>> This ioctl returns x86 cpuid features which are supported by both the 
>> hardware and kvm in its default configuration.
>> 
>> A well-behaved userspace should not set the bit if it is not supported.
>> 
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> It's common for userspace to copy all supported CPUID bits to
> KVM_SET_CPUID2, I don't think this is the right behavior for
> KVM_HINTS_REALTIME.
>
> (But maybe this was discussed already; if so, please point me to the
> previous discussion).
>

Not for KVM_GET_SUPPORTED_CPUID but for KVM_GET_SUPPORTED_HV_CPUID: just
copying all the bits blindly is incorrect as e.g. SYNIC needs to be
enabled with KVM_CAP_HYPERV_SYNIC[2]. KVM PV features also have
pre-requisites, e.g. KVM_ASYNC_PF_DELIVERY_AS_INT requires an irqchip so
again copy/paste may not work.

-- 
Vitaly

