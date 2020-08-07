Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACAB23E94C
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgHGIkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:40:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51394 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726382AbgHGIkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596789599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLsimUENgNb67dJ1BSePNKQb18HkvtcGc8WNRYHR/BI=;
        b=MZaFLJp5IywEqjHjEv1uKJtAvfPy6e8gIKR7ghEqCZH0kfIidPCvMR9cXR/OELNYPQ03AD
        PDvbeaOVzWj3VvhBBLmUk/YSmIWqh8SlaMFKK6WRbeppxE2SzDfm5L3thHpMB5e0ApetDg
        2/8bk0rRLJI6ORXLCt/KqvAFo2uOWbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-T2YarCzVPo-0UtI9C0swcg-1; Fri, 07 Aug 2020 04:39:56 -0400
X-MC-Unique: T2YarCzVPo-0UtI9C0swcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FE6C80046C;
        Fri,  7 Aug 2020 08:39:54 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C6F75C1D2;
        Fri,  7 Aug 2020 08:39:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] KVM: x86: hyper-v: Mention SynDBG CPUID leaves in api.rst
Date:   Fri,  7 Aug 2020 10:39:40 +0200
Message-Id: <20200807083946.377654-2-vkuznets@redhat.com>
In-Reply-To: <20200807083946.377654-1-vkuznets@redhat.com>
References: <20200807083946.377654-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We forgot to update KVM_GET_SUPPORTED_HV_CPUID's documentation in api.rst
when SynDBG leaves were added.

While on it, fix 'KVM_GET_SUPPORTED_CPUID' copy-paste error.

Fixes: f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interface")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 644e5326aa50..c0ccad0def5a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4494,11 +4494,14 @@ Currently, the following list of CPUID leaves are returned:
  - HYPERV_CPUID_ENLIGHTMENT_INFO
  - HYPERV_CPUID_IMPLEMENT_LIMITS
  - HYPERV_CPUID_NESTED_FEATURES
+ - HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS
+ - HYPERV_CPUID_SYNDBG_INTERFACE
+ - HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 
 HYPERV_CPUID_NESTED_FEATURES leaf is only exposed when Enlightened VMCS was
 enabled on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
 
-Userspace invokes KVM_GET_SUPPORTED_CPUID by passing a kvm_cpuid2 structure
+Userspace invokes KVM_GET_SUPPORTED_HV_CPUID by passing a kvm_cpuid2 structure
 with the 'nent' field indicating the number of entries in the variable-size
 array 'entries'.  If the number of entries is too low to describe all Hyper-V
 feature leaves, an error (E2BIG) is returned. If the number is more or equal
-- 
2.25.4

