Return-Path: <kvm+bounces-71755-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHrHJbtxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71755-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF68191518
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1171030DE28F
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F391BD035;
	Wed, 25 Feb 2026 03:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V9WhlSRs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oP7Caovp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297F21DE894
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991449; cv=none; b=BE0AN6BP+0lHnOd5cKSFz8I27k+pHMaLpeOvJU/I8kWBBSk0rjvdZ0zKbwOUjxI/M+C2pV7VRCCs62+WJ/3KI8T00KPS0D11VQfS6Ez6/mRkRZxRQ1pKlWGuEMHXs8RgigO5iZFDYVCqcMVCG8z7yesVMI3rvs6hIeRFW1fRn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991449; c=relaxed/simple;
	bh=/PuBF3v7rt56A5A9Yjsfwt+p2CZx5M5G9E9m4MAs3VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCuCNXcHTkDjHP5Ua5aL3zaF7A0vC4omMYDMH+vAim83EaQhjFQedvLXzsWEBaEsk1HBgKh/JqxazXe+zTruLefDhMTKeFUvGihZ2PHw4YT2IRbFa7wERoU2M7lv4cY7mjLM7/eXWN+cTYCIdoRCNXm4o7BK+vKsniwRh9pyERE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V9WhlSRs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oP7Caovp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPmsaquE3JdAXLnO3ruw5k4aSto0QbPW72QvF6hvRt4=;
	b=V9WhlSRsRwOhqPK5si7fgIVXoG8H9bOT3H5suOlLjILXpd9PR+15BDZYPhTzcHRycfSkAY
	jtF0/UtEdyBIeaFuP5E9R7O6zPN20wVcg21VD0Q7lZ4gRPmz4O1mNhzUZZZq/6lJRsUZVJ
	OWvdtCR4DmEWRdjr54dcUjB4XV+HGLg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-KLMUFdOxOduLpLV0-H4vTA-1; Tue, 24 Feb 2026 22:50:46 -0500
X-MC-Unique: KLMUFdOxOduLpLV0-H4vTA-1
X-Mimecast-MFC-AGG-ID: KLMUFdOxOduLpLV0-H4vTA_1771991445
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-358e5e33ddcso1220229a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991445; x=1772596245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPmsaquE3JdAXLnO3ruw5k4aSto0QbPW72QvF6hvRt4=;
        b=oP7CaovpnNZCewD5QzCLto6cXS/4U/a85KJJR0MNh9BVRCns5eOnns4ieY2s/iY+54
         5W5Xy4C6ORPsbhrZLz8wyW6AY3EDNJP9W6ZnELbvK92vdqO6pPKjZfu5RiLo2uYjLUm1
         rcgkyBqFF8+YKiPp6qkbhX7cM4pnOHETOprmJBVCQ9Yh4/3fOCJoxxrD86CCKuNa3X58
         oWvIbBRU/XCZbs157gVNiwQTE/2bog39tNEh/l8Cv5VLHTmBO+AIsh8+c4S0oC7gZwo5
         REAHDy+E6EQ0JvqZxnedJmhEWHjxHKdFOdrFy2zJyU4zxVtP1pmNmadhIzl3ZD3Ha0mT
         iOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991445; x=1772596245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oPmsaquE3JdAXLnO3ruw5k4aSto0QbPW72QvF6hvRt4=;
        b=rd1cbyJln3tD8EUHXTr12ogrK1HDwxjIgKr1BRFfhEEyOySwJb0bwqnz73RmWGmmyu
         sayQEDFALc7ClCIuugs81rjrVuQaOfgga6FZk2RuvneISEsNdfb7ip0OLwHFBuHoXdSH
         KZJKQOzoAmF/ynuJBW2UXd93NXPNSmgv+D5F0+InOuJJBP0HiDg+pfHzEPrmtXwUyxal
         y62ZWk9t0oZw2wyTPzPwpGoswkMh3MOQmToX+UjEM3C3hqZq0qsVTOLND50BqkcyuSkG
         97vHsPAIM1wjApGOd2b62ngzTwyzF1j9prRQu5zJuWgwl/ovD8g9lMkWYSYJ1Y7Z12A6
         jr0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVJl90hYNORnWVlAfKVZBmu/rEsxQ9GbX9fmrYw5d12sYiMQkKnxkGiC27iVJ0FasS7nPI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9RSBl6GNE64BqiWttdXiQXKv6LblU99eIcbmHVTXRt18Ya8KA
	/8IPxAckdtxexbKiBMbclOKb2FK0miUJLgWvqaVt6khd9+hsaCwc0iQF/fv86jwnU3RrwnQE9Gf
	tNi+YlQybV4BFfS+NcRpdrMTVAZZjzkggN8DB5+AopGbhWeKGASMzxQ==
X-Gm-Gg: ATEYQzy0ziIYMOSHC7bXIusIKnAWaEyEQYQAH/uiVk8x0ormgr1krQNA6cM8LgSHfR5
	DJS9kTygeWL5HZP4ZJ5eF4EOziR7Bpgpsr6aS4iALWR+5pEppWM0HaM3AZEl6mNQMm4mF38kxoa
	jXRWSl8FFvPB4JBzE+RWzXfE8+z3/D9kARIknAntK6EWsrULmReTt4RQ2P0X+iteKRqeOroCR9w
	+3TUxpck/KxRgE502PDA4IQeAr8rvPyzTOzu+X3LK7DXAPQQlmC5Ic3k6HaDgzSKzQmVqQHvwcN
	vtydWcRhNZwmofgSdprcnyEvY/SMhcEvjcl6/BLqj+LfHU5i+x53i1yyRCJuSkhWOZuMYy6bXe0
	6j1l78JdPoX1ft7SI5x0zdvvUk6yM98SPc4PwzmFXMs365vPSfzmM/9c=
X-Received: by 2002:a17:90b:5747:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-358ae8c6c31mr13176618a91.23.1771991444899;
        Tue, 24 Feb 2026 19:50:44 -0800 (PST)
X-Received: by 2002:a17:90b:5747:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-358ae8c6c31mr13176593a91.23.1771991444503;
        Tue, 24 Feb 2026 19:50:44 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:44 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 11/35] i386/kvm: refactor xen init into a new function
Date: Wed, 25 Feb 2026 09:19:16 +0530
Message-ID: <20260225035000.385950-12-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71755-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3DF68191518
X-Rspamd-Action: no action

Cosmetic - no new functionality added. Xen initialisation code is refactored
into its own function.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8679e7d3fa..feb3f3cf3c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3433,6 +3433,24 @@ bool kvm_arch_supports_vmfd_change(void)
     return true;
 }
 
+static int xen_init(MachineState *ms, KVMState *s)
+{
+#ifdef CONFIG_XEN_EMU
+    int ret = 0;
+    if (!object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE)) {
+        error_report("kvm: Xen support only available in PC machine");
+        return -ENOTSUP;
+    }
+    /* hyperv_enabled() doesn't work yet. */
+    uint32_t msr = XEN_HYPERCALL_MSR;
+    ret = kvm_xen_init(s, msr);
+    return ret;
+#else
+    error_report("kvm: Xen support not enabled in qemu");
+    return -ENOTSUP;
+#endif
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
@@ -3467,21 +3485,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (s->xen_version) {
-#ifdef CONFIG_XEN_EMU
-        if (!object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE)) {
-            error_report("kvm: Xen support only available in PC machine");
-            return -ENOTSUP;
-        }
-        /* hyperv_enabled() doesn't work yet. */
-        uint32_t msr = XEN_HYPERCALL_MSR;
-        ret = kvm_xen_init(s, msr);
+        ret = xen_init(ms, s);
         if (ret < 0) {
             return ret;
         }
-#else
-        error_report("kvm: Xen support not enabled in qemu");
-        return -ENOTSUP;
-#endif
     }
 
     ret = kvm_get_supported_msrs(s);
-- 
2.42.0


