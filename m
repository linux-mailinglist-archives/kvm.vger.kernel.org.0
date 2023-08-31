Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49F078F20D
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345657AbjHaRlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245359AbjHaRlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:41:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB2ACFF
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693503612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mWjVWgT22xaxbcUT8HbavX6nUqEO1o9qk8ut6LM5v1I=;
        b=NC45eXwl5F140bxJ6SSUP9nVniJ2g0IGRvgdlBUg69cVPRBNHffjw5xegOlvJRHggnf24r
        WCdNs4mH60sOSeymgdceZggq+26jO0S0lPh1D3KppssOG6AGygcbhZ39nyCd+odgh5JCC6
        X4LBvqfOzdda1jm9JrQNlWGjBA+9GDs=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-YknapRaFMie8YiofM6zrxA-1; Thu, 31 Aug 2023 13:40:10 -0400
X-MC-Unique: YknapRaFMie8YiofM6zrxA-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-44d5f9dbb22so478884137.1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:40:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693503609; x=1694108409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWjVWgT22xaxbcUT8HbavX6nUqEO1o9qk8ut6LM5v1I=;
        b=NdsG1WTk6OVdYD9HeUqZN+Vlw+IOATXXbmasmKJC/VTOmFmzOhe33hHrpzMY0ia+bo
         3Wwcpj4r37AxKykysXNT4ddLPsbXRQ3pepc8BwrVJhXDNc7kRcOjgMU89PVJU1CJBFRf
         3w9ZCdspJh/JkzBSmzY7NxEOL8vL5q6T2AXCKReHSCJD79ji25n2L8ETyLdLV70lZuvr
         rrtKwSEiePXNZ3Fq+2Tx07InX0JTxno0nRO6qBkCSyr4dXnj+OwY7mok2Kav+8XLEl/N
         EkRn3r/fe5OSwjSzZxTd0XRpP2bFob/sDOR3aT2ukTE/Gg7zE2BdL8xwpa1cejeUcyio
         MkMA==
X-Gm-Message-State: AOJu0YwbEGHB+eL7cNLEh7W9cFA1FpQHzVqGE3ofNXzsYU/lmuqUZXFO
        z4jGuoToSdRZMdvgMrCCijBKOhfdyGvWjyxJ182/hDJkIZpRPuqZm+8WTtgCI7pF8TcGaA8JKUV
        RfJrsvEsIS24fw5GwwusBPmcIpMXNMR8/kN0o
X-Received: by 2002:a05:6102:34d7:b0:44d:4f13:7113 with SMTP id a23-20020a05610234d700b0044d4f137113mr336413vst.19.1693503609691;
        Thu, 31 Aug 2023 10:40:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELvfzW0IBTqMJ2j1WIJZrjn/6PvKmkj+V5Lu3/WvN+senqm7gKvDuGNUe5gOBVHKCzm5ODJvk7ZPs3tA0RhzM=
X-Received: by 2002:a05:6102:34d7:b0:44d:4f13:7113 with SMTP id
 a23-20020a05610234d700b0044d4f137113mr336403vst.19.1693503609489; Thu, 31 Aug
 2023 10:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-3-seanjc@google.com>
In-Reply-To: <20230830000633.3158416-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Aug 2023 19:39:58 +0200
Message-ID: <CABgObfay4FKV=foWLZzAWaC2kVHRnF1ib+6NC058QVZVFhGeyA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.6
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 2:06=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Sean Christopherson (44):
>       KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
>       KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"
>       KVM: x86: Retry APIC optimized map recalc if vCPU is added/enabled
>       x86/reboot: VMCLEAR active VMCSes before emergency reboot
>       x86/reboot: Harden virtualization hooks for emergency reboot
>       x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
>       x86/reboot: KVM: Disable SVM during reboot via virt/KVM reboot call=
back
>       x86/reboot: Assert that IRQs are disabled when turning off virtuali=
zation
>       x86/reboot: Hoist "disable virt" helpers above "emergency reboot" p=
ath
>       x86/reboot: Disable virtualization during reboot iff callback is re=
gistered
>       x86/reboot: Expose VMCS crash hooks if and only if KVM_{INTEL,AMD} =
is enabled
>       x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
>       x86/virt: KVM: Move VMXOFF helpers into KVM VMX
>       KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
>       x86/virt: Drop unnecessary check on extended CPUID level in cpu_has=
_svm()
>       x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
>       KVM: SVM: Check that the current CPU supports SVM in kvm_is_svm_sup=
ported()
>       KVM: VMX: Ensure CPU is stable when probing basic VMX support
>       x86/virt: KVM: Move "disable SVM" helper into KVM SVM
>       KVM: x86: Force kvm_rebooting=3Dtrue during emergency reboot/crash
>       KVM: SVM: Use "standard" stgi() helper when disabling SVM
>       KVM: VMX: Skip VMCLEAR logic during emergency reboots if CR4.VMXE=
=3D0
>       KVM: nSVM: Check instead of asserting on nested TSC scaling support
>       KVM: nSVM: Load L1's TSC multiplier based on L1 state, not L2 state
>       KVM: nSVM: Use the "outer" helper for writing multiplier to MSR_AMD=
64_TSC_RATIO
>       KVM: SVM: Clean up preemption toggling related to MSR_AMD64_TSC_RAT=
IO
>       KVM: x86: Always write vCPU's current TSC offset/ratio in vendor ho=
oks
>       KVM: nSVM: Skip writes to MSR_AMD64_TSC_RATIO if guest state isn't =
loaded
>       KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIA=
LIZED vCPU
>       KVM: x86: Add a framework for enabling KVM-governed x86 features
>       KVM: x86/mmu: Use KVM-governed feature framework to track "GBPAGES =
enabled"
>       KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
>       KVM: VMX: Check KVM CPU caps, not just VMX MSR support, for XSAVE e=
nabling
>       KVM: VMX: Rename XSAVES control to follow KVM's preferred "ENABLE_X=
YZ"
>       KVM: x86: Use KVM-governed feature framework to track "XSAVES enabl=
ed"
>       KVM: nVMX: Use KVM-governed feature framework to track "nested VMX =
enabled"
>       KVM: nSVM: Use KVM-governed feature framework to track "NRIPS enabl=
ed"
>       KVM: nSVM: Use KVM-governed feature framework to track "TSC scaling=
 enabled"
>       KVM: nSVM: Use KVM-governed feature framework to track "vVM{SAVE,LO=
AD} enabled"
>       KVM: nSVM: Use KVM-governed feature framework to track "LBRv enable=
d"
>       KVM: nSVM: Use KVM-governed feature framework to track "Pause Filte=
r enabled"
>       KVM: nSVM: Use KVM-governed feature framework to track "vGIF enable=
d"
>       KVM: nSVM: Use KVM-governed feature framework to track "vNMI enable=
d"
>       KVM: x86: Disallow guest CPUID lookups when IRQs are disabled

This is definitely stuff that I wish I took a look for earlier (and
this is also why I prefer small bits over the development period, as
it keeps me honest), I'll take a look but I've pulled it anyway.

BTW, not using filemap turned out to be much bigger, and to some
extent uglier, than I expected. I'll send a message to the private mem
thread, but I think we should not pursue that for now and do it in a
separate patch series (if at all) so that it's clearer what filemap_*
code is being replaced by custom code.



Paolo

