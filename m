Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F8638C405
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhEUJ4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237262AbhEUJyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Q5Tae9tMPkIXAiCoXoro47U0oXxU6+R4OUPS9XUKeA=;
        b=NUVCBJ9r8jY5AzDxTHdgW5WkJnwUZpOHSyGszUyE0IzsqqCSJjzRLjRY/8T/NbXzblFhWw
        iFG46hj6kmfrZEkdVvBwO+Q1mjyn+glDwDRt38GjvAinBVpun7Uhgy/qlfBQIZjbiUHKSe
        INlm5em8AOIzTiMmePmpS+N5zBBukpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-C0AjuppRO-W-g8eaqEj8Iw-1; Fri, 21 May 2021 05:53:24 -0400
X-MC-Unique: C0AjuppRO-W-g8eaqEj8Iw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED0B5343A5;
        Fri, 21 May 2021 09:53:22 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB2B56A047;
        Fri, 21 May 2021 09:53:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 23/30] KVM: x86: hyper-v: Honor HV_SIGNAL_EVENTS privilege bit
Date:   Fri, 21 May 2021 11:51:57 +0200
Message-Id: <20210521095204.2161214-24-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_SIGNAL_EVENTS' privilege to issue
HVCALL_SIGNAL_EVENT hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ff86c00d1396..523f63287636 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2033,6 +2033,8 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 			hv_vcpu->cpuid_cache.enlightenments_ebx != U32_MAX;
 	case HVCALL_POST_MESSAGE:
 		return hv_vcpu->cpuid_cache.features_ebx & HV_POST_MESSAGES;
+	case HVCALL_SIGNAL_EVENT:
+		return hv_vcpu->cpuid_cache.features_ebx & HV_SIGNAL_EVENTS;
 	default:
 		break;
 	}
-- 
2.31.1

