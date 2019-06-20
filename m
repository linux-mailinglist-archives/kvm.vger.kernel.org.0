Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4194CDD2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfFTMiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:38:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41094 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFTMiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:38:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so2853601wrm.8
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 05:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PBe9hQeFMayLD/0ZRDInVi5N4QsHohL3ze/iPL3VAN0=;
        b=W/02szwKDeaZZYNBot3BzAgDp7M9sQr5ck77vndybF1i09lcfd/MHWtUWvi9bKjGdt
         PaKApIEKG9NPErErDRJlgXgLcVpXP4SA9tZk4LGrds2D3RzbCw7KwSBxEg7TBR1Dpinc
         r1nf8FMx9OLFXa07tCym6Z3FuKZZV+9X9huTony3zQRoX0kNOI3l3KK3eCurX7PNkp2k
         UaN4X+N3N3pe5AP9LmZyjqECsZfnrMpkwOPTNCQ0hgfdMIXYSv8dcQ8zrpqeTAuS41MB
         030gXhcmR/Bx39WFpETwmjq4H/U5XuvUyIoDuLE+uAvy9U9J/+AyiKJGfEwvvaFb1ygo
         +hAw==
X-Gm-Message-State: APjAAAWtV0LdCzjbn9kP3vAo01Xv3hTDvVy1uQ+Khy/UTwJ9jWOWwqJF
        +hADhiLO4dPLzwXYxKoNmDRkjQ==
X-Google-Smtp-Source: APXvYqy1Jw/TS72GgFtDeH8i1rM2d4XdyxY4oOs6mdaUyGtOWtneGJJdreyqFL2pxbg4xntCGufPBA==
X-Received: by 2002:a5d:620f:: with SMTP id y15mr13438905wru.262.1561034287746;
        Thu, 20 Jun 2019 05:38:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id c17sm15734547wrv.82.2019.06.20.05.38.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:38:07 -0700 (PDT)
Subject: Re: [Qemu-devel] [QEMU PATCH v4 0/10]: target/i386: kvm: Add support
 for save and restore of nested state
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, maran.wilson@oracle.com,
        mtosatti@redhat.com, dgilbert@redhat.com, rth@twiddle.net,
        jmattson@google.com
References: <20190619162140.133674-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bcb617b1-7d20-d2ff-81c5-9f165eae5683@redhat.com>
Date:   Thu, 20 Jun 2019 14:38:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190619162140.133674-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/19 18:21, Liran Alon wrote:
> Hi,
> 
> This series aims to add support for QEMU to be able to migrate VMs that
> are running nested hypervisors. In order to do so, it utilizes the new
> IOCTLs introduced in KVM commit 8fcc4b5923af ("kvm: nVMX: Introduce
> KVM_CAP_NESTED_STATE") which was created for this purpose.

Applied with just three minor changes that should be uncontroversial:

> 6rd patch updates linux-headers to have updated struct kvm_nested_state.
> The updated struct now have explicit fields for the data portion.

Changed patch title to "linux-headers: sync with latest KVM headers from
Linux 5.2"

> 7rd patch add vmstate support for saving/restoring kernel integer types (e.g. __u16).
> 
> 8th patch adds support for saving and restoring nested state in order to migrate
> guests which run a nested hypervisor.

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index e924663f32..f3cf6e1b27 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1671,10 +1671,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
             struct kvm_vmx_nested_state_hdr *vmx_hdr =
                 &env->nested_state->hdr.vmx;

+            env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
             vmx_hdr->vmxon_pa = -1ull;
             vmx_hdr->vmcs12_pa = -1ull;
         }
-
     }

     cpu->kvm_msr_buf = g_malloc0(MSR_BUF_SIZE);

which is a no-op since KVM_STATE_NESTED_FORMAT_VMX is zero, but it's tidy.

> 9th patch add support for KVM_CAP_EXCEPTION_PAYLOAD. This new KVM capability
> allows userspace to properly distingiush between pending and injecting exceptions.
> 
> 10th patch changes the nested virtualization migration blocker to only
> be added when kernel lack support for one of the capabilities required
> for correct nested migration. i.e. Either KVM_CAP_NESTED_STATE or
> KVM_CAP_EXCEPTION_PAYLOAD.

Had to disable this for SVM unfortunately.
