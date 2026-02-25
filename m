Return-Path: <kvm+bounces-71766-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHIXNSdynml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71766-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:53:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 540251915D1
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3D125310A611
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6061F21420B;
	Wed, 25 Feb 2026 03:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OOIo8U3G";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jAZlx9RB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8401BD035
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991501; cv=none; b=U4gjTnuQ1iepdetj0q8PS0c92KvMG+XTlQlQpuAYzAciDYRwpLFllmXPVb+yUwgf01K4GecKThVwhz+PwdvK6nZp9iFq+Gk1XvOOt7nA4TUXulcfSD+8PpYNWa59oGHQkZg/xVGKeyPme+rT//Sz9OpDfqRxGvuhVYhtTz0GlEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991501; c=relaxed/simple;
	bh=L5P6YVm0yFvVEcJwumeEIft9LTWFtuU1GGj5itvoUlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TylgsWsKw4/yw/UxIi+MbhuYSXsBogzy4naJDMW+TRavS8huxhcErFI6OFRwS8cQ91p/819QDvlZaWTjyK7B4QVOX4ucUi6zAvIH/QvCylkfRHeVOfvnF1ftoL+CFW4MKj4ykh2wG9W206wXhz+q0JG8KEeroL0p3lcqHfL5uMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OOIo8U3G; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jAZlx9RB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1p5ZbFdSM+FDKoKqpM0RbDlLtsFLRzSauSxJ1myhHy4=;
	b=OOIo8U3GPpVAGelrG+hnFxz8bYhQ3UradUnzOZ7d7hCZpkaVu4WKeWHnNkJPENg5VTKpgC
	qgvKa7BNlDQy7KlEdLkt+yKJ4vtdp+w7NYgLskL6ROF4ZUWn2p+92BiT22LWPBE7egyjN7
	MmtIf3Z19hAdnTVT1HuvQOxqIpbzD5s=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-agipCyHoPa2jJ2kgcRlxhQ-1; Tue, 24 Feb 2026 22:51:37 -0500
X-MC-Unique: agipCyHoPa2jJ2kgcRlxhQ-1
X-Mimecast-MFC-AGG-ID: agipCyHoPa2jJ2kgcRlxhQ_1771991497
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35464d7c539so6093205a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991497; x=1772596297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p5ZbFdSM+FDKoKqpM0RbDlLtsFLRzSauSxJ1myhHy4=;
        b=jAZlx9RBKWFHihmLOHXQAbH0wZgwa+U1+QRRYHH9eB6jmRLmrCniDMhv3ctcupmWeY
         642+tb0PEAEF/ahmI+KtcysBRss87FDhTuXJAOlznD2wLjA2ilHXH/fzKPETbX9EXlsD
         AF60LRuWMunPoMl2VC6vShPGCjbdqh0vUgraKAHQ7ueFegsKV2X+2x8YNkKLA6WvLZ0a
         Ql5/YFgqk3yhGhuvhrJJqj6HF3yP8juu6eJM8wFFKCpOSghH50n5bDPdJZ7eTzHOyv8f
         8Uv4radvlbjECf+OP/XlbBLdwQGHqeujM1XBOXDqfdekYvEF3RVG0PFvBHGZ1TX5ozCW
         Zv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991497; x=1772596297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1p5ZbFdSM+FDKoKqpM0RbDlLtsFLRzSauSxJ1myhHy4=;
        b=lUKU6eqOLOGZhqckYqObHSJGgeFIuWXboRXM0VwJDnch0X6uW/Mfol1Pi3L/JfR/gY
         mtIj0y2U1iBWyHFuIpYU75IMdTw9Ms9utfCTaHo3ydsTWv3x03UZYsKnjTjWknQ6vK5v
         OPhhkniC4HI0xGgOU+Zc6UKjujZOhqDKCutqeER7zjvRuhEYvGAddR0M107lKBk5WGyT
         hP/1s0BwWufSnRhvtBqIX9ztqEmkEnROfADtUo5PE02YDad1i820UD0iZnqeORlT1IoO
         GV2QyLhqIMOKOOWpGKc3yP8L73+lFb7EcyQtz1VUW3IeNMj0TXWP9wRbM/EdPwYaX+Z7
         +kYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL+7B2oIAY6Zu1hN0twxPFWGyQ9MpZNkvTCDVAgO7KzIyRsR+sKWNPt6KV/xkCOyaFH5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNcF8yfNBITjIVqGYdUC94g8yv/zSwf/7ALQ3b35y82HZMALTH
	ueEa/JYYjoR+Gaio4RlPrimFwk5jVksBupSXVow0YJn8wOnahCXkQ7B8jmnSPfw9soCIL2HW5Dc
	+1lEinB2J9xqrCy1HSU9WSBynmHnGfPP48cInmKXB4FmHbni9f76ekQ==
X-Gm-Gg: ATEYQzzO/DM8k0f7B6opIzsJm19ORA7PbrxReF52aNwB9k141RzpNH1XzqmEhUzUXwE
	AzgcUycRHk549m1Shw8Wzvicws+egFxBbzR8S65i+rcLglplW0G1HU3MT80xe0oTYlogeMpyXlg
	BbhUdOOQ3DCxLi9LV27Sk6vahNuzfqShGkYcGVql016i0FFCEDKyDQkSUVqwQebR36NpWbvQbAh
	upyA05rL+KEjEnd44vF+FWF7i+cABkZ1rv4zGDJDWzDlfNx5h4EQr5xVPPnuuC/0j+E8NzxiuYn
	4B13WhgqyndAbZN5HxiaMJCRRexeKSNLZjkScsnOLKmGhm3tDG/L37UWbLYHh3GBXJelJL6moqe
	fF3CZfIrZnWZrHerFp+ghBNjR/enhzw0+ak5s861scT8p9uxvWlvkPMc=
X-Received: by 2002:a17:90b:51cd:b0:341:8491:472a with SMTP id 98e67ed59e1d1-3590f045d72mr867112a91.4.1771991496848;
        Tue, 24 Feb 2026 19:51:36 -0800 (PST)
X-Received: by 2002:a17:90b:51cd:b0:341:8491:472a with SMTP id 98e67ed59e1d1-3590f045d72mr867090a91.4.1771991496448;
        Tue, 24 Feb 2026 19:51:36 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:36 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 26/35] kvm/hyperv: add synic feature to CPU only if its not enabled
Date: Wed, 25 Feb 2026 09:19:31 +0530
Message-ID: <20260225035000.385950-27-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71766-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 540251915D1
X-Rspamd-Action: no action

We need to make sure that synic CPU feature is not already enabled. If it is,
trying to enable it again will result in the following assertion:

Unexpected error in object_property_try_add() at ../qom/object.c:1268:
qemu-system-x86_64: attempt to add duplicate property 'synic' to object (type 'host-x86_64-cpu')

So enable synic only if its not enabled already.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5c8ec77212..ff5dc5b02a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1761,7 +1761,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
             return ret;
         }
 
-        if (!cpu->hyperv_synic_kvm_only) {
+        if (!cpu->hyperv_synic_kvm_only && !hyperv_is_synic_enabled()) {
             ret = hyperv_x86_synic_add(cpu);
             if (ret < 0) {
                 error_report("failed to create HyperV SynIC: %s",
-- 
2.42.0


