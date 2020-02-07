Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58473156144
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 23:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgBGWfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 17:35:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20554 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727379AbgBGWfa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 17:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581114928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8BwOjosBD3aan9vZqA1/XtTiViONk3Y9UUF8NI7mgRo=;
        b=TqgeDWsVl6jBUndQDpLwvSh19aWpr8HKcV3F+Sn5DF/18m/fbM1e8u7PR/0Z9U5CwOlEzn
        AzQCxtFJTyYB7DTa3+UmYkhrtwlU4zn3QiTXnDxidZxhOcVhEMiXDCDYa7Mymzm2UHRCCT
        RVC4ary7WfhAqsUIX5OkvCICezOS8Wo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-jJu1sl6qPiOuGnj6dnw_PA-1; Fri, 07 Feb 2020 17:35:25 -0500
X-MC-Unique: jJu1sl6qPiOuGnj6dnw_PA-1
Received: by mail-qv1-f70.google.com with SMTP id l1so485508qvu.13
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 14:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8BwOjosBD3aan9vZqA1/XtTiViONk3Y9UUF8NI7mgRo=;
        b=eCopripMFszuJcljTne+EoyIOjHfiYemh9T7mJ7Z4zTSdvtGtNeCe039K1sfJXiVSP
         o7Qn/L0m+wQWAChwdYpsaCwbGbr9JI4ji7YOWxa8dM0I3dWya3JwVCV6fkcI71gXP3yt
         F6d0TjHnlxvF4eK7WoY3iyaIfK244qwY/l/PGkOvszj4l51irG6fic+K4taqYvX967uD
         0CXqarHWIbssEY0It4zIqaQKgcNv7FqkDAOpiMop29NDud7gns6pwC38Cvz66u+bnfde
         JpT6ugceC92FL48GkHsxy+FyGdD4LP52IWjShvDpJ2RDOrUauOPFDYZ6wK1FM8zreatt
         6h8Q==
X-Gm-Message-State: APjAAAXrCsY3ausQOqxnwfeKpZuTxS9kBYs1brSmTdGBlOBCtRie/Hsm
        hscfhqbOvkPXt8PSOFpHq+v/A4kmkCTPDwwhL8sKkGB1Co9m6irlokRbswTx6sfQ9o89iIhBPvg
        9c/MOpEy3+412
X-Received: by 2002:aed:3e13:: with SMTP id l19mr560576qtf.103.1581114925266;
        Fri, 07 Feb 2020 14:35:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVTvI4slEe315nMe8hBROEAYdieeZun635Z6BLpraphf59wQM9cy4oqH/UIWzzvIngWXEG9g==
X-Received: by 2002:aed:3e13:: with SMTP id l19mr560554qtf.103.1581114925041;
        Fri, 07 Feb 2020 14:35:25 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id u12sm2178736qtj.84.2020.02.07.14.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 14:35:24 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 1/4] KVM: Provide kvm_flush_remote_tlbs_common()
Date:   Fri,  7 Feb 2020 17:35:17 -0500
Message-Id: <20200207223520.735523-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207223520.735523-1-peterx@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's exactly kvm_flush_remote_tlbs() now but a internal wrapper of the
common code path.  With this, an arch can then optionally select
CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL=y and will be able to use the
common flushing code.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d5331b0d937..915df64125f9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -798,6 +798,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_common(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eb3709d55139..9c7b39b7bb21 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -302,8 +302,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	return called;
 }
 
-#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+void kvm_flush_remote_tlbs_common(struct kvm *kvm)
 {
 	/*
 	 * Read tlbs_dirty before setting KVM_REQ_TLB_FLUSH in
@@ -327,6 +326,13 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.remote_tlb_flush;
 	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
+EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs_common);
+
+#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
+void kvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	kvm_flush_remote_tlbs_common(kvm);
+}
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
 
-- 
2.24.1

