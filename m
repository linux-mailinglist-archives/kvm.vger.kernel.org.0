Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C44F3A5DE1
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 09:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhFNHuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 03:50:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232509AbhFNHuG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 03:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623656883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVVQDAqE2mNu93zrjVnb7Wt06L1/09jtCkVYdV1XAfc=;
        b=YkWQLAGs4500hMYddsrdqMOqX2wgsZO1Qbz7DTWm7u7/0mrEdXZ7NKBrFzhdX3isi5JD7r
        uA1TKyZSpVPbfl66vUu8xMvW51gpYiLdI2xwpWC2leibv5I+oRUkZcvyPRaqbC089mnVlR
        5dYYkepuyC1YAnLj9rRvXXsJAcGZJfo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-0aOA1ysLOBey_51RwqJP9A-1; Mon, 14 Jun 2021 03:48:02 -0400
X-MC-Unique: 0aOA1ysLOBey_51RwqJP9A-1
Received: by mail-ej1-f69.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso2678339ejn.10
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 00:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uVVQDAqE2mNu93zrjVnb7Wt06L1/09jtCkVYdV1XAfc=;
        b=PCsBHN/WVsp148Gu/HlOooPkOr5IadI6Vdxwt2t2f+BUQZjlK7fFxrogppSKYAzgue
         70VG+8Fz5jA+z3ZyVMlzZJNL0aqnsb/xp3lcNGxf66n7Gx/18tvHTRp/XLgvQTGwSm6N
         8875oY+IvRgbDHpFg54YuKzO7ej+EOuN8fSYe76I41xXSmCVSOqnOmyuFbZowW9DxO3V
         6NcO66E32X00PRwlUbNsExUUyKOEsuw7eE0ErGrrwKDeSv7YKtfheWX9FiG7yivlwkrX
         Mbg5cAPqNs5yIFhzDac+wXEYffvgtvBruRXI6I2TdmtqfrXDkrg3M6b0Hc9TQdpG/yji
         7Efw==
X-Gm-Message-State: AOAM533r2S8qfgaLRjTBF/L+7Y4PI5lEyRv/zrJsMYG9Tgv81r/UaO5K
        /LGNv1T2Ur2njs17f3zOLEUhayE0WbHmz7WB5ITqNo1CYasYZH4Z1vXF9cj+1Inj5C+5haq1n3v
        wb7tp1EyXy3hy
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr15927089edt.194.1623656881435;
        Mon, 14 Jun 2021 00:48:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR5ViPXNZ/W1P6S7MeGqL1karb6GMvkiVX7a6Cj3XRWtU7Ght+0fiIaUQS7VaSMZPx0qyfEA==
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr15927063edt.194.1623656881266;
        Mon, 14 Jun 2021 00:48:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h8sm6839060ejj.22.2021.06.14.00.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:48:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v5 0/7] Hyper-V nested virt enlightenments for SVM
In-Reply-To: <50dea657-ef03-4bde-b9c7-75d9e18157ea@redhat.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <5af1ccce-a07d-5a13-107b-fc4c4553dd4d@redhat.com>
 <683fa50765b29f203cb4b0953542dc43226a7a2f.camel@redhat.com>
 <878s3gybuk.fsf@vitty.brq.redhat.com>
 <50dea657-ef03-4bde-b9c7-75d9e18157ea@redhat.com>
Date:   Mon, 14 Jun 2021 09:47:59 +0200
Message-ID: <87wnqwx4y8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> CONFIG_HYPERV=m is possible.

We've stubmled upon this multiple times already. Initially, the whole
Hyper-V support code was a module (what's now in drivers/hv/) but then
some core functionallity was moved out to arch/x86/ but we didn't add a
new config back then. Still suffering :-)

Ideally, we would want to have 

CONFIG_HYPERV_GUEST=y/n for what's in arch/x86/ (just like CONFIG_KVM_GUEST)
CONFIG_HYPERV_VMBUS=y/n/m for what's in drivers/hv

-- 
Vitaly

