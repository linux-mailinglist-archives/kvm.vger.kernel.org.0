Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FAEB7BB1
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 16:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390269AbfISOIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 10:08:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388068AbfISOIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 10:08:30 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41A6D69084
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 14:08:30 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id h6so1884295wmb.2
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 07:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sWppofEf+0Xf9T8YVPh73Hir/CIu5+9mJNluOrUbKEk=;
        b=MMhixo8c8Qrys2edgUWuwvInS6KE7wSfF5FHJ4e8ZShOtSs0yQz5tLY+oiq27D4Ull
         SyNSyriKYwsi3+0egX+2eouLciExUAHzXkz0FyX9mDU6I+tI1tfKrV4+7gJwrY6RuPmo
         Ih3T7xutR6GQ8UxSyYJwmWXF4TDWIP2PWgkAbpUtGCV4aGUyNGclR0UkgjojqzF0lKGt
         txDgICjZNO7OJ35oToZHskVFR9Rw48kgHRoCJYRaeIMVvX9BD4LoT+k3AWvJWVoUIQMs
         nghojqcnyVTpgbZF34juH8ww6+/0x6PY1nOm5sF0O1Vk0govX0VRi+R4mSxp2UkdcVVB
         Orjw==
X-Gm-Message-State: APjAAAXPJT0bwGtt1ZAhDUD8DwKPJ9RhR6r5FIbhJ7/IL8mowfIHXf7Y
        +5lXoyUJUj6gLtJNFR8HxfB99smqOjXLy1YQxMKDORvpdQtNzeIyOIFlSOSI8z0dPgVAVuHZD3b
        Yl5wp8pvikdi/
X-Received: by 2002:adf:fa10:: with SMTP id m16mr7390704wrr.322.1568902108698;
        Thu, 19 Sep 2019 07:08:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzw3791bLrEM3sxJKp4ms/EYqTYy5eVpuSG5XRNNjAOswIC+XU11cpVl6WFDUloWFkVtH8H8w==
X-Received: by 2002:adf:fa10:: with SMTP id m16mr7390693wrr.322.1568902108499;
        Thu, 19 Sep 2019 07:08:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t203sm8441156wmf.42.2019.09.19.07.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 07:08:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in various CPU VMX states
In-Reply-To: <20190919125211.18152-1-liran.alon@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
Date:   Thu, 19 Sep 2019 16:08:27 +0200
Message-ID: <87a7b09y5g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> Hi,
>
> This patch series aims to add a vmx test to verify the functionality
> introduced by KVM commit:
> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
>
> The test verifies the following functionality:
> 1) An INIT signal received when CPU is in VMX operation
>   is latched until it exits VMX operation.
> 2) If there is an INIT signal pending when CPU is in
>   VMX non-root mode, it result in VMExit with (reason == 3).
> 3) Exit from VMX non-root mode on VMExit do not clear
>   pending INIT signal in LAPIC.
> 4) When CPU exits VMX operation, pending INIT signal in
>   LAPIC is processed.
>
> In order to write such a complex test, the vmx tests framework was
> enhanced to support using VMX in non BSP CPUs. This enhancement is
> implemented in patches 1-7. The test itself is implemented at patch 8.
> This enhancement to the vmx tests framework is a bit hackish, but
> I believe it's OK because this functionality is rarely required by
> other VMX tests.
>

Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly
