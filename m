Return-Path: <kvm+bounces-22152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 364CA93ABA1
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 05:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0AAF2842AB
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 03:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634EC225A2;
	Wed, 24 Jul 2024 03:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFbdkIDt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D2A1C2AD;
	Wed, 24 Jul 2024 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721792411; cv=none; b=AfwhAYVa4KTE+L+iL96MIyMAGFRcpCXvlq/0s0+06lGhWk4fKOCn6dL0oJ8UjxLIMROkiUEH9IeY7v/X+LjFNHQwmiigyFmagee0SCQaUnLqdI2vB+w/lT7wwq1gpbpJTKswxGOWEwgCAAUsw9m/UJVgS/c0Qh72+kFAArRyvL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721792411; c=relaxed/simple;
	bh=Y7Kt+TCvkANaF9S82vZn/5eyJEZ+ppgEjmPtazNpkmI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KJa6AXvGcnkObkHF8PO/T3wyZdsL9qxfVHnamDtseXe7UKSU3WszaCYXK3TI+mG/rIiV/BC0lySuNPFcwZ5akIwLdLkhbbE+J0pv18zmT745AwJe/EpDNtlWDEyz34QA2mTFmSiUL/+9R6c668flvmwwHy7R8TXqVcI6z6tNWtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFbdkIDt; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-70448cae1e0so3361526a34.3;
        Tue, 23 Jul 2024 20:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721792409; x=1722397209; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iWm0TInp0/fEQSxBgv3hB+Z5yl/AEMWPqZWhnxovh+Q=;
        b=CFbdkIDtbAzMPdnLD6ISkeAIcn4jAGJTAck1mEOMZK6xAKNKNcrHygqgvf2hxHwcW0
         7ynUvljZY5K45FNBQdVd6DatwsZaSboLlzRBElyrD5YJ5/oc06aQD3P31S1KGp5Z+T80
         zvDyyVND3qHhz1olsQaXQ++S/d2QMi5o0+x7MWq/cbDpefEsSPNJFruf1LNvSoHA5DUc
         koZV+WnvG3925BYTYCIT724BORuJebvnnp0GSlg3yXUmvtEWJqNqEI8CyvBIBPk31qJM
         9SpFGODskvfyHWx/Uip9r1NtkRzCDW14T+fJrAiwYMazsxlvFdtqR6VfnoryUR8cKNFB
         TObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721792409; x=1722397209;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iWm0TInp0/fEQSxBgv3hB+Z5yl/AEMWPqZWhnxovh+Q=;
        b=ZPksp83nw+Np5qT/eQM2g3I2Hstg+BSjnYHc04CIn57tUCj7BnQgcuT6PxnQU/iTdj
         HXX/ZDJnGD3LK+Y5HRMWgppNRyFawLmKWnJ1ArUfzYJe//MTF/b/za5vUapVeY7yanGM
         ddW87JgtyWbceVS3u5nheV5RQEGWo880cwpZWclFT1EO6ESsfbm3R83OAmbCIUFb6r84
         L4vD9D9DQ+/O9Vq2k7hCFrILceTNCEv6MvU4iAPAfmucZoxUw8kaS59/b0Xk8t77YVaw
         DRTkbBljg7cl9DhnVxZMggkVNJ2uO/D5wzb4MA5TD5RXkRIDjaFGAByGUcaplcf68T8N
         Z2Xw==
X-Forwarded-Encrypted: i=1; AJvYcCWl9MFeoF9M+Sk4QC4Z3VR9xlu8wzHS/ABH1aFpFGnMvsNgiztOdlrCZJH/2uxFPWnGFQfCInJDAwIJSwTao7mbZA+z4CgJusOIwSSB/q8aJC1h/IHYh7Td3lSEftkruzsAwzVOgBhue+P3pCbEGMSRDuGQ2kw7VkjZIQbp
X-Gm-Message-State: AOJu0Yy3MX9DobRBU7Lv41bz7cOpkYX37WhvDxMLfqMF7u/T21bxnCR0
	DbzMZwGj8HuitbWu5sxlbwHyhaXkIQjjVUL/2B7gMB0apLh3KZ5g18q5JtN+pBQ=
X-Google-Smtp-Source: AGHT+IGl8R9cRFmLWG82QkyJN4p4OFG0NW2QbWFiV0VYiiANQgoGe+0WIbCEWf0fVN1wRzJa6K5czA==
X-Received: by 2002:a05:6830:6f42:b0:704:49c0:65f0 with SMTP id 46e09a7af769-709008d04fcmr14870188a34.3.1721792409174;
        Tue, 23 Jul 2024 20:40:09 -0700 (PDT)
Received: from gmail.com ([24.130.68.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-79f0b429f28sm6001407a12.38.2024.07.23.20.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 20:40:08 -0700 (PDT)
Date: Tue, 23 Jul 2024 20:40:06 -0700
From: Chang Yu <marcus.yu.56@gmail.com>
To: pbonzini@redhat.com
Cc: corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	marcus.yu.56@gmail.com, chang.yu.56@protonmail.com
Subject: [PATCH v2] KVM: Documentation: Fix title underline too short warning
Message-ID: <ZqB3lofbzMQh5Q-5@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fix "WARNING: Title underline too short" by extending title line to the
proper length.

Signed-off-by: Chang Yu <marcus.yu.56@gmail.com>
---
Changes in v2:
 - Fix the format of the subject and the commit message.


 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fe722c5dada9..a510ce749c3c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6368,7 +6368,7 @@ a single guest_memfd file, but the bound ranges must not overlap).
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
-------------------------
+---------------------------
 
 :Capability: KVM_CAP_PRE_FAULT_MEMORY
 :Architectures: none
-- 
2.45.2


