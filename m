Return-Path: <kvm+bounces-18610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 710818D7E7D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94C341C21240
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4717F47B;
	Mon,  3 Jun 2024 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FiIUFw8m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2A4757E0
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 09:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717406882; cv=none; b=sy0Xh9Tmpd2lJMy+Bx/eZWOAbr2hmMYRWvVfohzX61fN0n5LjDMNdZhdppYK45mp/ag97hL0zuv/1/Tx5QqrnR0II6Lomj6PrvZFsdN1qh3zOGidM8pq/qQcXDLlSQhbJZnAagoIRFZoHqcT/q2hJKQTpKJ7KFOSuZZQbEjO10E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717406882; c=relaxed/simple;
	bh=JdG2ql7L+lKOq/HGfEDt+hvGxOVH5Du2VgJsw4C/dXY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HFRXEkKdKk26PMaasr3hozvdiMiOFim/K5wkzznGuNcSjzFBLIdMZ+kk786tcMwBrBgKbsmJ99qawRpxzOzn9zogqDj5w68oUyhCPqSAGaSiEY2ajGA7Jqb1x+zvtpp36XACmogF4q6vHviAToqhVAt+yCljKk2GHHOmKvcYagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FiIUFw8m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717406880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wusgo9pAYrXWTDQL+RvA6+6mleDlm5ATljKrqaDYi4c=;
	b=FiIUFw8myGxzTeVn/o36pPXhc5xq90xMiHXUwmPuBSjBcFkkeFZg7Ffpe/gIK8Jhpw3zqj
	t8WNcSMg+1d4Ee7glFK6A5qN1xWOjZS8LLzkDt6qOmycfwBuMtimjTeCuTpjSHzv2QVR8d
	hWta3eW9kJR8MEROLi2LOqq2i9rV0uQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-vst1n6KCOZ6_-zc6RsSeHA-1; Mon, 03 Jun 2024 05:27:55 -0400
X-MC-Unique: vst1n6KCOZ6_-zc6RsSeHA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-57a50752cd2so1183670a12.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 02:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717406874; x=1718011674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wusgo9pAYrXWTDQL+RvA6+6mleDlm5ATljKrqaDYi4c=;
        b=GJr661CA8lvL8YOeEEKhUmXz6VTGA1c27RjN3Nr4hqHuNnZ7NCSmQA/Y/3ujF/Tswq
         6H5dC+z+81ljcFGM10hr0AiILxahfCVDnX3lIuzefYAfWCIOBm/4PVUWqVlhur2As9oX
         CQG0+gutN5HzAZ+dQzjdW6Cn1vKbnT+KjtsboZq1NqzIod6hRtITFHc+tnt4fXwAzKGd
         tg39SXMHgsTOyvJrpk504Q/DbChhX4RcsD+LZ7ilZQqwJZeB5dXoPHFysEsXRrX2Yecx
         lsoLR43ZLu+gO7ccPgTjuxs92yG+sAKsaVXWViuW3nDRlFXjYmPqLDpEYs5OKQtfZw+j
         S8VA==
X-Gm-Message-State: AOJu0Yzrtcprn09Ux9Dm/fUG5E8Kq7aMwKRF3JF/z9n04FW13K2UZeX9
	rNUNLJFWX3VoMuvCJNPhobqY8C4E+JNPclh1gGavMLhfm2RxjGEPSl+sBkHfKsw/ah/G9/J8bCB
	8tRsNP9iM044RHp4nuOHiIzJ4aARNi3QzROpprcTTvqV2YADcBNSgRA15AvAm4ipgKF7n2a6Yjx
	HN38v2kydkuv3hSZ2nS7WCB7DO8ib3wfiTHQ==
X-Received: by 2002:a50:f691:0:b0:574:ec3d:262a with SMTP id 4fb4d7f45d1cf-57a3637622amr7593864a12.5.1717406874207;
        Mon, 03 Jun 2024 02:27:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0uWb9AMpAxQM+Dmvsi/0HZOiI/RHv3lebESZK5r6IQFeF01CRE4LlqTjDrJfNswWOvmBDig==
X-Received: by 2002:a50:f691:0:b0:574:ec3d:262a with SMTP id 4fb4d7f45d1cf-57a3637622amr7593845a12.5.1717406873574;
        Mon, 03 Jun 2024 02:27:53 -0700 (PDT)
Received: from avogadro.local ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31b98de7sm4937802a12.10.2024.06.03.02.27.53
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 02:27:53 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] gitlab-ci: store artifacts even on failure
Date: Mon,  3 Jun 2024 11:27:51 +0200
Message-ID: <20240603092751.608357-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Test logs are especially useful when there are failures!  Allow
inspecting them to ease debugging of CI issues.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .gitlab-ci.yml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 23bb69e2..204e05ec 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -7,12 +7,14 @@ before_script:
 .intree_template:
  artifacts:
   expire_in: 2 days
+  when: always
   paths:
    - logs
 
 .outoftree_template:
  artifacts:
   expire_in: 2 days
+  when: always
   paths:
    - build/logs
 
-- 
2.45.1


