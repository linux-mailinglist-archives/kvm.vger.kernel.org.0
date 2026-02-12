Return-Path: <kvm+bounces-70918-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMZ7MMdyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70918-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5D412A9F2
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7EB8A30C96F5
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA50E298CC9;
	Thu, 12 Feb 2026 06:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTit2pnK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DkKhW6ic"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C1288513
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877629; cv=none; b=YFO/ZgJgM9Vixa0qO8lDB1er+86ppbKjnrMUUaUcvaDEMGJJjGWhDwlZaL5MSdRyAiQ4dRScgWFdhbjDICYW+wq/UuJHor0RNJZ9TF3wZGM9N8SfQyujUKndXIR0SbFKioIS+bMOi68JjvL9KitjhCuSrhLJ6DLtCVrpMYCpt1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877629; c=relaxed/simple;
	bh=vDxvjwJYvq4vbEX36upeTBKndUnEouC6VuUpCCd2OII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7ACEo+Xd8vUh0iMyt6q8ycwkVEu+0Y0piUB+b3GnktpSFodQxCwyzNggAzZExQgDcyAZtYHfvHMDxPmXbG/xaSh5HFqbo4YLopRq2DXZklnJgWLrsjVIiSuxHIdfGZUHDe9CHMm4Cn/2o/hQiF3aOJ0yDB5Z2IzT69tTu+LJ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTit2pnK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DkKhW6ic; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qFtSZXlJPHuHUflcek1m2W3gH++5/UpYdLyjc7W8PbM=;
	b=hTit2pnKVT/HDYRSd6InyKEW8a5/z70XAVmhe/jWDNVq/hREJyCVwhWD2PwDWj9Y+FXhcj
	zppA+hAcE56PEJ3/GiN2mqh46mM5E/F8lNvp1yS7gpRk/kaJc/KyvW3wAHs0j8qHTzhYU1
	87UiL54UfGEFmrWbv22v++96UsZkRL4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-7eOzcGH7MrGIHuH0IW0hKg-1; Thu, 12 Feb 2026 01:27:05 -0500
X-MC-Unique: 7eOzcGH7MrGIHuH0IW0hKg-1
X-Mimecast-MFC-AGG-ID: 7eOzcGH7MrGIHuH0IW0hKg_1770877625
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c52d37d346dso1746293a12.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877625; x=1771482425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFtSZXlJPHuHUflcek1m2W3gH++5/UpYdLyjc7W8PbM=;
        b=DkKhW6icVaAzsZ3AG1eiiFRsyyxswigOYiJZ01n9sPi9o6s9JeG0uytEomiqZD4S6F
         hnKUmFDHBf6+3Pn5LjWVAIwDG2r5RuntGkWdrWnE9hjELt8WGFaSe3bjhrJOKQ2tCYSE
         meipVLMrofhTJaJIk6bQReC7KVkFBlA+UzJHWf8rCFVlvhEHokVbsldU84bnHI8Gpniz
         Qc3LJXSgS/Ha/A6hgPB5+QnXdbX9FUQIZG6x6CvXXWX7U8B7aEDBiS2UHFhslRcvHmDu
         HJlzjbCUBvvIfkWGM8JGviukWRcIaKWGO9Z0/iWlrI//viis/UsmcCnFEtJqKIV7kaNk
         RAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877625; x=1771482425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qFtSZXlJPHuHUflcek1m2W3gH++5/UpYdLyjc7W8PbM=;
        b=do4aCSdNfgUpATFbQHO16fLr0YrfdKKn31PMx/V3MdPUWTnUsnu/qW+ixkQeTbUZc7
         FEoRsoTM9JFoqJ8XuQ440UQ+OwDs7fXF6tLXA++4pjS51qbfrfkt7ix987vduvfIhYCm
         1Hb7rQk2rd+AFKrlKcZ6YXpz9AzP+wnFXyGLQ+YmU56gvSiWhgxo6gkWMalp3QK1KM0c
         kY/JvRhM4T43ADoAwarcG9AnETWQIaDwB/oJvxzqrftIv5rH6HkIDFnejSzg4Rk9TTgh
         8S2X4seB02+Fos4r/rT9JAG2HnhqSD6HKDi87cd2QWFBUJPsOcm3e2mdKdNEKR1dQ5cV
         AngQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+RFNe+7NvZB4AVikvpCtoL4pU8cUcgeD+J5pZpWmgYyRD6tKmc47RdvffmoPp8uV4kLU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu7TbEj8+6JKBft/pWVYYLwuR2s9d1S5UdItG9hkSitCIuGmML
	nNj+1CWbwbvMTF//SB0yS8PERhPFlaQIJIpwwDbgyMp4DuHqCQk9mpXe6Zg45rMt1e6tDN2DUvv
	B5Dlgv5BMu1AVNw2PGnRokizO92FQhKvYPC0K+xb7fYnRNBvxmY03Pg==
X-Gm-Gg: AZuq6aLmD5xyRISn3qoeQlMc/Bscxqpaw38yp+CaPnMY93By/d2Kw+9E23FhkH+XKjX
	Uo/5OivXfs2Ie7+yE58GVBHZODjUjiFgZePmbPkBivgDThFLDUdSL+kktvEHDqMbtm392xSRF3j
	kCNgeTfz/5c30tXHvY4w0wNd7iWRrOnn1FPWoJ/HSCKeyUjoD3rzVSe4LdUeqkJimvk9Htxad/V
	H4yiPSfVzAN80PCf4pBWVIMZ2yNJy2ymNMpHvoUW7XWCpg74GOi14/OXW2J+YNXrUERReBby3FQ
	FiYG+PggGwn9GuBUhVJRQiDYZY9+2pxBx3KYs/HkSezgAfrfvSJH2vmqO9zaqjnuneicBu1Bbj9
	WVT4GLp349MQPmgwyb9zriNrrS16u99yzglqj2wkaQikdJna6icA7M7s=
X-Received: by 2002:a05:6a20:cf83:b0:38b:e750:bc27 with SMTP id adf61e73a8af0-3944cfb92abmr1329202637.58.1770877624792;
        Wed, 11 Feb 2026 22:27:04 -0800 (PST)
X-Received: by 2002:a05:6a20:cf83:b0:38b:e750:bc27 with SMTP id adf61e73a8af0-3944cfb92abmr1329185637.58.1770877624461;
        Wed, 11 Feb 2026 22:27:04 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:27:04 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 24/31] kvm/hyperv: add synic feature to CPU only if its not enabled
Date: Thu, 12 Feb 2026 11:55:08 +0530
Message-ID: <20260212062522.99565-25-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70918-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2C5D412A9F2
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
index eec2f27a0f..a6b773db34 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1752,7 +1752,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
             return ret;
         }
 
-        if (!cpu->hyperv_synic_kvm_only) {
+        if (!cpu->hyperv_synic_kvm_only && !hyperv_is_synic_enabled()) {
             ret = hyperv_x86_synic_add(cpu);
             if (ret < 0) {
                 error_report("failed to create HyperV SynIC: %s",
-- 
2.42.0


