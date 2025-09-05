Return-Path: <kvm+bounces-56896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C14DB460F2
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 19:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CB4D7B2480
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 17:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB8C372897;
	Fri,  5 Sep 2025 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbwekWp+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CEC3191DB;
	Fri,  5 Sep 2025 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757094468; cv=none; b=OeKDufHxyjZvun0v/wgjyyaFzLzKDSrAMcTAmRtezw7CMEzMiRTvSbH958a+P+owxStqisjf/uxOPNYeSqQwp9T+sJyFbcAac4Plz0KF3u4VPuiIjVXiLV8K8VCyALO0zFVWW6CmL67W+b9eWUT92f8YWxYa5hCSvf/RMG9n6Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757094468; c=relaxed/simple;
	bh=8+IcFoGRnR++LETo8qNriEg45mSVU48yABzZX0ErpGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JC/D/SRtM5rA8VHk/nGVmBhf47+xiKBcuRtKyceDBMjznCkmt3aXbEWrLqpfugJOdoDXM6+BIVB6vpAk4Z3Vd8UXGjdWvosK6iTnwfvh3p7k6/X1k1DOyEkHAyB/Oph6xiG7z4+VMTuuSXA+kthLBM6ij7SkY0dchXwefXSWYws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbwekWp+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24af8cd99ddso31044135ad.0;
        Fri, 05 Sep 2025 10:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757094466; x=1757699266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzeYsrA3usK5M9dOJfOGC+Kh4M1puYf0AR/8PeWCkKU=;
        b=GbwekWp+FOHxATZKBnS1gWCG3s6Dm/sNcRvvPfur2XwU8AeiL1Y3e3z3dplVFMNg8Z
         AQtqnX0umrskqUCgdTRtrekf9Zx55dgyIE2P2Ce9X6pixZuwtLUXs43zepWsQtXa9jr0
         YFe4ylZ1yZmSA0v2BtkYJzp9OBGH10OYTWG8T27KEwc+xg86Wwtn6Q8/w8VUk4yLeQEE
         2M3JAfQalrCyfRN7/vdD6chQ+hdq8Ev7zxOuI2t8PkIGxGXNATd5ZTTtKySMzYU/PXOm
         7Gm5QihzpjAAGM8uq0d8Ax2+GyI6ChKsVZwfQZtGK1RI3cWdkgNZXOb7PMuitsFZ+LjR
         CsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757094466; x=1757699266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzeYsrA3usK5M9dOJfOGC+Kh4M1puYf0AR/8PeWCkKU=;
        b=FHq83/9dk21MjTTpDE/t8qeSCBiRMXncaqqmYl3LSg+MSqdyDBSmSGW0lam1hfIQiN
         R1a1cN3mR77jLVfELhhL2ks/uKsPmK1WV607rNUalHRYBxJdpOACpsre38uHa7YGrYtx
         YpzBaDO1+2MulquJZcCognkwVfs0XH880jQCz44yb9IGTbKUlCzuorH4fpzdqoy4axsv
         C1hPnUBL6TMl9geMTYg9mDP8gtCNe3V6zFPXCU6QVL6s4q3n3DoTaPGCGD/xvGol8xbK
         GxknGYXO94uGgjh7grt2xoc/ZEeQiCYprEuhyJ9BSmoMyuDyssNlp/E6YCBp45nR/Cuk
         OZEA==
X-Forwarded-Encrypted: i=1; AJvYcCVeuDnL7wWdAkoIB4SThQBxkKIMsOhbGBKc2WvSAqE9HziKcEMp2dBiYcZc6hcDgFWOwYg=@vger.kernel.org, AJvYcCVuNLJwyTwVOcSK7VxwsD8mhAZcIBTuIW8+InXEM6rldcxl9jpGc3fBDpIhJ1Jyp42+ft/zNiLy5eZt@vger.kernel.org, AJvYcCWYemTym9zzO3DdQt15oKDTHZga0ndzqB8MyrcqPHRQt9ZmyP8AVZPlOnbJcC12Q8Gjc3zCumzbY1EdwJGs@vger.kernel.org
X-Gm-Message-State: AOJu0YzxJUXOpmvSAXgU03LMXqoVmvJ+zpeGBprZoRm+t8SQGoOwuCKa
	1PCupDZxMBpSOAweKJmSjIrOKQnaMTHb8+Kcwy9fw7ZU/xtTkhXQbih/
X-Gm-Gg: ASbGncvWin1Mezn1toTtxEH8DEq+/CqWu80hf9Upu/cBkRek617j1fX0Dqj/oE9DbeR
	pmReKnv2vvU74+sX9iw51Vu5w3OvtpFFg7A5IfJSeukugKql52VcNfVkoGhWQhbj1JOVsKM5qIH
	DU0TcE/+74akezZ4nZaMnN5gOo9DSLq1u7Phs4gOGMH8Rw3cQKE8UJGl0JGS8KNWDwLj2TbuY5E
	4PiZRbbYkKMSw8SjuIAgaSQm7esArv/ceyM7DKAGYqA7sYZTOXeeuMlMNXygD2mqmOLr+guMEdy
	eeOShgMUvoZ22vRXK2FS6dDZZ9P2GEr7ACiCBK/r+fX4/WrtOBGbDyTbxUp/EbuFP4j4Jz+UeAd
	2mX8pLCKwxWClMlC/WuD5GwZFO9bq41xfBA==
X-Google-Smtp-Source: AGHT+IGvzM6hfShqmrzfM+7I1bIAwS4FApulB2L51518SOYGWv8KHuncicMHqc/B9Wrx9jt7ejZ6Wg==
X-Received: by 2002:a17:902:f707:b0:24b:1d30:5b09 with SMTP id d9443c01a7336-24b1d3076f8mr154186075ad.13.1757094465610;
        Fri, 05 Sep 2025 10:47:45 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([115.25.44.221])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24ccfc56f60sm44482715ad.60.2025.09.05.10.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 10:47:45 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: rdunlap@infradead.org
Cc: corbet@lwn.net,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	r772577952@gmail.com,
	seanjc@google.com
Subject: [PATCH v2] Documentation: KVM: Add reference specs for PIT and LAPIC ioctls
Date: Sat,  6 Sep 2025 01:47:36 +0800
Message-Id: <20250905174736.260694-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <00378f4c-ac64-459d-a990-6246a29c0ced@infradead.org>
References: <00378f4c-ac64-459d-a990-6246a29c0ced@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Randy,

Thanks for your feedback! I have fixed the grammar and put the full URL on a single line.

Please let me know if any other changes are needed.

Thanks,
Jiaming Zhang

---

The behavior of KVM_SET_PIT2 and KVM_SET_LAPIC conforms to their
respective hardware specifications. Add references to the Intel 8254
PIT datasheet and the Software Developer's Manual (SDM)  to ensure
users can rely on the official datasheets for behavioral details.

Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
 Documentation/virt/kvm/api.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..f55e1b7562db 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2083,6 +2083,11 @@ The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
 regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
 See the note in KVM_GET_LAPIC.
 
+.. Tip::
+  ``KVM_SET_LAPIC`` ioctl strictly adheres to Intel® 64 and IA-32 Architectures
+  Software Developer's Manual (SDM). Refer to volume 3A of the `Intel SDM
+  <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html>`_.
+
 
 4.59 KVM_IOEVENTFD
 ------------------
@@ -3075,6 +3080,13 @@ This IOCTL replaces the obsolete KVM_GET_PIT.
 Sets the state of the in-kernel PIT model. Only valid after KVM_CREATE_PIT2.
 See KVM_GET_PIT2 for details on struct kvm_pit_state2.
 
+.. Tip::
+
+  ``KVM_SET_PIT2`` ioctl strictly adheres to the spec of Intel 8254 PIT.
+  For example, a ``count`` value of 0 in ``struct kvm_pit_channel_state`` is
+  interpreted as 65536, which is the maximum count value. Refer to `Intel 8254
+  programmable interval timer <https://www.scs.stanford.edu/10wi-cs140/pintos/specs/8254.pdf>`_.
+
 This IOCTL replaces the obsolete KVM_SET_PIT.
 
 
-- 
2.34.1


