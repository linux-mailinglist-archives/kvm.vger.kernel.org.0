Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33ECF177C54
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgCCQs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:48:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729377AbgCCQs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583254107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tVR3fLZLUNSfxeCmLw5WmmWD0RuodP2e89qJb7tyUbA=;
        b=Q7W9c2h23gi+SiOobHrzX2JpX7TtKFOgzTSOFQmpZ3GJfbXQoc1YySjb4ODpe09AEIuO9A
        vbkqcyJchHNcCY2TyCIPTVIXgCTliFB53180PbnK8sog4YUt6csH4nKqajmm+etpI1ty5j
        1gchLAR7Q7PwcqoFOK0dUOFHxdez++A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-7EtNdgziODmwDNnuyZJ9hA-1; Tue, 03 Mar 2020 11:48:26 -0500
X-MC-Unique: 7EtNdgziODmwDNnuyZJ9hA-1
Received: by mail-wm1-f69.google.com with SMTP id q20so899762wmg.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:48:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tVR3fLZLUNSfxeCmLw5WmmWD0RuodP2e89qJb7tyUbA=;
        b=b8hzvNY5Bs03+N9ys6x7VOHjNJHkwU7ns9/Jib1Y8vFwl0B5gHLky7lgjyzIFDyk3J
         FsKtS2BSVm9sQGBRQuizsERQw5+xAtm42DoZuB+nPabvClQ8GbvA5+2fAZ3uxXZJ/oT+
         Fcnb9HeJiepxEepD0fu4e3yTOaiO+D8OWYrSBCj9fq3BoKlYlMvNLAA7xl5MTsYYurPI
         iEKJI9uS6GFzX16U2kbsPPp7zdWlAP2tTLeVdRFFkbfeiQz0KX3wfHLj6g7XUe9QD2Y4
         DPDCNbe7P9S5jlg8rkHmNjdrEstle2avGYyKEBY4JqzgcLUFxQNzXInqqgpRDsK5Wl/i
         lnEQ==
X-Gm-Message-State: ANhLgQ383PQnUujD5hE5cBTOZYZMWXbKFTvzPGdZJjXbb0t9CotZ73W8
        P7LP9LH/ghGGHK+rYUMVLvENlj9/2ujsGd5zjSiYI4iHxxFZGWJe64etEEE/txJY63RQt69TaEZ
        PkE84me1AFzuB
X-Received: by 2002:a1c:c5:: with SMTP id 188mr5045452wma.89.1583254105142;
        Tue, 03 Mar 2020 08:48:25 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsGgm2F+r1bKNVwLZMv9knu4h001U/8h/7d1/cNm6RSBUOoIvQloC/Uy5Ldo1pOpceQ/SNfPQ==
X-Received: by 2002:a1c:c5:: with SMTP id 188mr5045438wma.89.1583254104859;
        Tue, 03 Mar 2020 08:48:24 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q125sm5312013wme.19.2020.03.03.08.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:48:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 00/66] KVM: x86: Introduce KVM cpu caps
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
Date:   Tue, 03 Mar 2020 17:48:23 +0100
Message-ID: <87wo81e65k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> All AMD patches are build-tested only.

I tried this on my AMD EPYC 7401P with QEMU and '-cpu host' and the only
difference in CPUIDs I see is:

# diff -u cpuid_with cpuid_without
--- cpuid_with	2020-03-03 11:38:34.786583429 -0500
+++ cpuid_without	2020-03-03 11:43:58.103484420 -0500
@@ -454,16 +454,16 @@
       SvmRev: SVM revision = 0x1 (1)
    SVM Secure Virtual Machine (0x8000000a/edx):
       nested paging                          = true
-      LBR virtualization                     = true
-      SVM lock                               = true
+      LBR virtualization                     = false
+      SVM lock                               = false
       NRIP save                              = true
-      MSR based TSC rate control             = true
-      VMCB clean bits support                = true
-      flush by ASID                          = true
-      decode assists                         = true
+      MSR based TSC rate control             = false
+      VMCB clean bits support                = false
+      flush by ASID                          = false
+      decode assists                         = false
       SSSE3/SSE5 opcode set disable          = false
-      pause intercept filter                 = true
-      pause filter threshold                 = true
+      pause intercept filter                 = false
+      pause filter threshold                 = false
       AVIC: AMD virtual interrupt controller = false
       virtualized VMLOAD/VMSAVE              = false
       virtualized GIF                        = false

These are all 0x8000000a.EDX and Paolo already highlighted the issue
(PATCH66).

-- 
Vitaly

