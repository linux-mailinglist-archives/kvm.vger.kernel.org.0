Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C9910F167
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfLBUN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:13:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728099AbfLBUNV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 15:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575317600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1fy9n7dcmvJgMCcJNV0TpfIBPUc+H1bj0IMdTlJT67Y=;
        b=TqtI2P+Fa1oxnOT/+wionTMWgXLs0df7qaJX9auauAp+SZ2jtrOMRpUixWEiVv5Jjm1PW4
        oNKGgd0m2nyYMTu65/hXtw0zpIIZrLMlZNI4oH9q4zEStCy7Epmy9gWdKJM2AAKDWOUwbL
        +imrhyakofO/2vUyxzCTCOtzvOPYui4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-LNhikmsIO3yBFeFmnZLXVw-1; Mon, 02 Dec 2019 15:13:18 -0500
Received: by mail-qt1-f200.google.com with SMTP id k27so689414qtu.12
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:13:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G46phdLsdELb62aYURKq9FYQ6hJlvcecU9Mkr0WukfA=;
        b=IUzhoBEwQm9Hh27iedzaGWxAt/e2DpfMmelFj3xpzz078YWZyXLjPP03NSsVocMZ+V
         j4ofBMEZ88ZH5FeG5mSXKsJThafooLnfqtWVUSyI2Q+Pk62pl5iv3f73xjuSxgRBlFhH
         qVDnxRv0hx45TMJUBKMkdJ9qCkZ2/G5KFMPfODp+6IQmuPuNvfgo9TDt0qJTvPPZciNB
         /VTpmT//8KZQYTSrTnNMGnSb2aqoYstX5yB+RYXcK37LNv+CMZzZtT0cJ6tuWfP5nXMi
         XLJci5QlygeimEov5wt/sU/KYtXoPkJps+QwgPt4Jiq5jw9CHJaef7gpbMxP/ktliQZY
         /3lg==
X-Gm-Message-State: APjAAAW8EnIeuW60sWoCHka4wZx+OQhVwfk/rJHV8orcimxPr9+hbk0l
        emUIymv4Aj7ZYftiTaj9MfM7myEj3mln536thiod3Qm7t+u8hK89NsoIZ901ipVR6sZ2UJpzTTt
        NYD4m7FKe529x
X-Received: by 2002:a37:8fc7:: with SMTP id r190mr802090qkd.57.1575317598022;
        Mon, 02 Dec 2019 12:13:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqyyXV9FRZwo488kcpWWx8NKtpTc+Mn5z7ZJGiXXUVERX6ZlH3itwmcb06sFXIkKThyWsyuWdw==
X-Received: by 2002:a37:8fc7:: with SMTP id r190mr802057qkd.57.1575317597756;
        Mon, 02 Dec 2019 12:13:17 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b6sm342410qtp.5.2019.12.02.12.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 12:13:16 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 1/5] KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
Date:   Mon,  2 Dec 2019 15:13:10 -0500
Message-Id: <20191202201314.543-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191202201314.543-1-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: LNhikmsIO3yBFeFmnZLXVw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 3rd parameter of kvm_apic_match_dest() is the irq shorthand,
rather than the irq delivery mode.

Fixes: 7ee30bc132c683d06a6d9e360e39e483e3990708
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf9177b4a07f..1eabe58bb6d5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1151,7 +1151,7 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct=
 kvm_lapic_irq *irq,
 =09=09=09if (!kvm_apic_present(vcpu))
 =09=09=09=09continue;
 =09=09=09if (!kvm_apic_match_dest(vcpu, NULL,
-=09=09=09=09=09=09 irq->delivery_mode,
+=09=09=09=09=09=09 irq->shorthand,
 =09=09=09=09=09=09 irq->dest_id,
 =09=09=09=09=09=09 irq->dest_mode))
 =09=09=09=09continue;
--=20
2.21.0

