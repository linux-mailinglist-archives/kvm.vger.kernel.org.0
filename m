Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6A02591CE
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 16:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgIAOz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 10:55:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727815AbgIAOzy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 10:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598972153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ha8ceeJV++XLnGMTI8EAI1v8M0o9ZVG9VPLjJ2EiJh8=;
        b=iX43OtAU/iUosFM7/B7qME8EXS75TzkBOb9yP56tckfOP3waXo9yvHD4tCycYc/UOgfzyL
        w2e2sff1mt2wRvBBYQ4+81UcB6T62MYX5sgWzd+Fm1bOi/HfgHMzDD9dvUn0wnxNG5inG6
        EMa5SeG8A4sjI/Ct+vog8n4HSkxtXPc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-NvGlQINnMA-G-FFjG4YOgQ-1; Tue, 01 Sep 2020 10:55:51 -0400
X-MC-Unique: NvGlQINnMA-G-FFjG4YOgQ-1
Received: by mail-wr1-f70.google.com with SMTP id c17so682718wrt.12
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 07:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ha8ceeJV++XLnGMTI8EAI1v8M0o9ZVG9VPLjJ2EiJh8=;
        b=F0XeJ9evLCDgnb+rR0xKns4WlNzPkQeJlV5/FM3Z+b84vz8rX6V0Hu+7Hbo888EytO
         SQQF7iuAwwKhwrh822yeMoi7eovZTUjeeJ3SlEyu0wCPBWqlaaY10a+1g5qm0YTU+Xf/
         4fb6EPjVHdNZ0OGv+v4agQlOfPqJ6ajQm05AZvDRi1BHoLLLCrTqlNLBNcc776avY0Zw
         +ojJyP4TeMLniw0ZhbQ2IZG4jA1FAEHkoF5tn7qfRS6QBzHNRy/piQEZS94L/iJuhXzj
         4tkuDelvdMeRFRyR/H6SRalYzhRmB/cL9bRh63Ny2aJHNweI0adKB3Q94CcH+yTn4sqk
         gBvg==
X-Gm-Message-State: AOAM5332xHl/nAw2mJHkHW1C2ANsXoP0f7eA3nRqke7z1T92/CKIivN+
        r1xAlv1voVVuGhrSxMYRzYSalkL2oIl6KVHM3+bXTReaIhMcTibuFj0RfD8ap5UY/FM9zHJLNIB
        6Ppuj3Zp9hQKT
X-Received: by 2002:a5d:5261:: with SMTP id l1mr2303740wrc.193.1598972150673;
        Tue, 01 Sep 2020 07:55:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0/d8/Yxd2dCD06xdpMy8cay26xVfJk8tZTMxMCzO6R2TkC1wQy0bxfE6FRVZFbEmTC91rOw==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr2303723wrc.193.1598972150439;
        Tue, 01 Sep 2020 07:55:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l15sm2777902wrt.81.2020.09.01.07.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:55:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/7] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID more useful
In-Reply-To: <20200807083946.377654-1-vkuznets@redhat.com>
References: <20200807083946.377654-1-vkuznets@redhat.com>
Date:   Tue, 01 Sep 2020 16:55:48 +0200
Message-ID: <87blipwnpn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> KVM_GET_SUPPORTED_HV_CPUID was initially implemented as a vCPU ioctl but
> this is not very useful when VMM is just trying to query which Hyper-V
> features are supported by the host prior to creating VM/vCPUs. The data
> in KVM_GET_SUPPORTED_HV_CPUID is mostly static with a few exceptions but
> it seems we can change this. Add support for KVM_GET_SUPPORTED_HV_CPUID as
> a system ioctl as well.
>
> QEMU specific description:
> In some cases QEMU needs to collect the information about which Hyper-V
> features are supported by KVM and pass it up the stack. For non-hyper-v
> features this is done with system-wide KVM_GET_SUPPORTED_CPUID/
> KVM_GET_MSRS ioctls but Hyper-V specific features don't get in the output
> (as Hyper-V CPUIDs intersect with KVM's). In QEMU, CPU feature expansion
> happens before any KVM vcpus are created so KVM_GET_SUPPORTED_HV_CPUID
> can't be used in its current shape.
>

Ping ;-)

I know Hyper-V emulation in KVM is a very specific topic so it's not
very easy to find reviewers but I'd be very happy if someone could
provide any feedback on the idea (above) in general.

-- 
Vitaly

