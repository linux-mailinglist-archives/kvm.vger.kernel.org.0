Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8C204346
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgFVWFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:05:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54996 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730953AbgFVWE6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 18:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592863497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxNoiIotuSOUgYrJS6aM7fTSWzfHgwqTuPAKOewitTU=;
        b=P50e5eBIj12HLw7wUXbG7LQnnT3BMU7ZyFnHcOjDTQ7sUxkRKoJc/styvh4yDtnV9ypYb1
        d1rD0N5sMrrhLKHwPUoJypmMrc/J8lLp0QOwpA4M/eZFI+HmwbUmGSY4mU0ufVytnDZfkC
        XGggJX+na+QpzpLRFSepC9TbMoVf4ps=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-YW8e34X7OvypcDuCkILQ5Q-1; Mon, 22 Jun 2020 18:04:55 -0400
X-MC-Unique: YW8e34X7OvypcDuCkILQ5Q-1
Received: by mail-qt1-f200.google.com with SMTP id b1so8338148qti.4
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kxNoiIotuSOUgYrJS6aM7fTSWzfHgwqTuPAKOewitTU=;
        b=aGTVA5ws9QHWGAc4kweFbBqRwo5CCIZLbRTtAK7PazKbE9XENv3M7TvR6mdsKqiHxg
         HcnwIej/84hocyti1T5HBOe0/ByGP8Cu5Q9vQUo8xkJ25dQohzpmG7ciLpd16graTD6Z
         GOCbJoMJZRO8xf8mVDCYyiRxU+Ty8BxbT/9Q5yYjC3mvEgYyLMgvl75RYxPWE2KFPlXj
         PPA26sWLKGdCOCdb/Hfl8kld4407zh11+E4CAacNWmE33TmyxzfUcofUsp2JIhZRiDGE
         g3yYTxZfUwdgey4+ITdoS8I7Fq7GDW25fgn1HSmf/pvb5Dbb70C+7F9NwGWjun8E8Vnq
         vxaA==
X-Gm-Message-State: AOAM533K2ilSTXeOVrRhQnECITqEWfH5JMCEtbBhDa9yRRDeO/nYl3a+
        nnp3yrSOryk+52SL16qtiu/BRz7ZwniEOLEqQwYlrSsLkXRm82pWhBwm/DrRyJhKsANXh+GvnU6
        EuiCA9gUiEv0h
X-Received: by 2002:a37:5c7:: with SMTP id 190mr5161774qkf.479.1592863494606;
        Mon, 22 Jun 2020 15:04:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/+HmfLMWSdX8VJlG/0qF7L1Bbp0eFUoOqz+i/oWxlSly1ie82Fn50R5C+EgZSYNrMiebaGQ==
X-Received: by 2002:a37:5c7:: with SMTP id 190mr5161745qkf.479.1592863494278;
        Mon, 22 Jun 2020 15:04:54 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h6sm3506810qtu.2.2020.06.22.15.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:04:53 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 2/2] KVM: X86: Do the same ignore_msrs check for feature msrs
Date:   Mon, 22 Jun 2020 18:04:42 -0400
Message-Id: <20200622220442.21998-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622220442.21998-1-peterx@redhat.com>
References: <20200622220442.21998-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Logically the ignore_msrs and report_ignored_msrs should also apply to feature
MSRs.  Add them in.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 10 ++++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a862c768fd54..8fae61d71d6b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2346,7 +2346,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
 		break;
 	default:
-		return 1;
+		return KVM_MSR_RET_INVALID;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 89c766fad889..42dbb3d0a2bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1772,7 +1772,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
 	default:
-		return 1;
+		return KVM_MSR_RET_INVALID;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b49eaf8a2ce5..1af37794377e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1392,8 +1392,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
 	default:
-		if (kvm_x86_ops.get_msr_feature(msr))
-			return 1;
+		return kvm_x86_ops.get_msr_feature(msr);
 	}
 	return 0;
 }
@@ -1405,6 +1404,13 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
+
+	if (r == KVM_MSR_RET_INVALID) {
+		/* Unconditionally clear the output for simplicity */
+		*data = 0;
+		r = kvm_msr_ignored_check(vcpu, index, 0, false);
+	}
+
 	if (r)
 		return r;
 
-- 
2.26.2

