Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC30513D62A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 09:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgAPIvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 03:51:53 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21465 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729064AbgAPIvw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 03:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579164711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tcKo4JN558IIRrVZSCK2Yu8wbmlLLtuVxtX8dWupKHE=;
        b=Vu/MfqH5JB6C5dQOa82AvSrJnKrBjULuEztg7XvAteKWXR1zcB7P1Pc/oVnWHO0cLraYe7
        H3r3MxgqPk8nc4ucTPGzF1gXuXRQxeNaWFk6E0BYLRBciiZlK96smn9ArpAoxlWSs6bElT
        HwFSYr1JjWpgRf3yzxeRUsbT09C8ZAw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-x4-FIE5cMkSbpZoocHWq8w-1; Thu, 16 Jan 2020 03:51:50 -0500
X-MC-Unique: x4-FIE5cMkSbpZoocHWq8w-1
Received: by mail-wm1-f71.google.com with SMTP id f25so942884wmb.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 00:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tcKo4JN558IIRrVZSCK2Yu8wbmlLLtuVxtX8dWupKHE=;
        b=hr+X7ZbsBsbSSFAVn2DV1DfHK7aOinwKF59t0r0zXoqRmFr+4yPK3BtieJ2kQ/YY+l
         CvAE3Yr+O+694YWgR0NwTl+TAeHZJX/Io5dYOTLNoAqCkUnbbOQtDjite8i2E2Pf5CSC
         2ztehss2XatKIPuO0oyKu9w1goDQwwG2KKx6pMRgiqqOx+tsZA9rztuj/I33D1z2i/dP
         s6r47sorInuunKVKggdkq0r16JwA2D0t8QfE7HAo8Fm3hXd0uoSQ8sdM4FkgYpnzFWV6
         FRWdxJNl277NL8WuFBXGzCKo5gslG7EmGobDmbxL3q9rSJVcxUz4AIo7IrXAJzg1c3RL
         nODQ==
X-Gm-Message-State: APjAAAUhHrCES1Jiy4K2PEVC4sif9DVaO0Z/r9szBECwVvSmgv8+FAUh
        NCt1NbQR+KsB3k62+UFSnsIHhArCFUHHv2Wm1d4vSSzVb9oYo5ImRJ87hs7C1C8I0nnA1yckcc6
        8DJrqVQ9cK/XE
X-Received: by 2002:a5d:4983:: with SMTP id r3mr2097021wrq.134.1579164709154;
        Thu, 16 Jan 2020 00:51:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqz+FIo6m3s+4uZkSWR4hOLQFm0Wq420S+sUlfd/qMhhcLzGOztTOn+gv9OW3x8fU0i0Nu6QhA==
X-Received: by 2002:a5d:4983:: with SMTP id r3mr2097004wrq.134.1579164708920;
        Thu, 16 Jan 2020 00:51:48 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v8sm27190979wrw.2.2020.01.16.00.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:51:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <20200115232738.GB18268@linux.intel.com> <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com>
Date:   Thu, 16 Jan 2020 09:51:47 +0100
Message-ID: <877e1riy1o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 16 Jan 2020, at 1:27, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>> 
>> On Wed, Jan 15, 2020 at 06:10:13PM +0100, Vitaly Kuznetsov wrote:
>>> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
>>> with default (matching CPU model) values and in case eVMCS is also enabled,
>>> fails.
>> 
>> As in, Qemu is blindly throwing values at KVM and complains on failure?
>> That seems like a Qemu bug, especially since Qemu needs to explicitly do
>> KVM_CAP_HYPERV_ENLIGHTENED_VMCS to enable eVMCS.
>
> See: https://patchwork.kernel.org/patch/11316021/
> For more context.

Ya,

while it would certainly be possible to require that userspace takes
into account KVM_CAP_HYPERV_ENLIGHTENED_VMCS (which is an opt-in) when
doing KVM_SET_MSRS there doesn't seem to be an existing (easy) way to
figure out which VMX controls were filtered out after enabling
KVM_CAP_HYPERV_ENLIGHTENED_VMCS: KVM_GET_MSRS returns global
&vmcs_config.nested values for VMX MSRs (vmx_get_msr_feature()).

-- 
Vitaly

