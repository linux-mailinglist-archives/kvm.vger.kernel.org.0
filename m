Return-Path: <kvm+bounces-13685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8258998DA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB99E282C8F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0E1161332;
	Fri,  5 Apr 2024 09:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEi/763L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EDB15FD1E;
	Fri,  5 Apr 2024 09:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307738; cv=none; b=VnrPEwd4It4vjkhfkJhgEl2gRc4zBqSC6ir9TcjDQPWrY+mMZcdkuu0i8Rh8H2fzGJ0rmoWa8MHDl07iwGCQWgEOMm6YQlq1L/1STa6tADIYoOVWQz2kmArdJsd0Ovkt6IeSg83PLiPMusOLuepjjWB8i0z6Y+a8dg3yF3APXsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307738; c=relaxed/simple;
	bh=D2NZsjGRY1JDUL/nxvnSyIqqAbyckX5TCaIHUVo+eHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc21UDylOXzVpacQ2r0pG5GTMoyi9EGqzS6EXYDgCUdim52hkXhY9FHXbXD5Jy3FUyIN2Kv2LEftqXE4p5isjqumbQ7152nveNldLEqZSkFu5SloVOnagz8tjqrbf4z5fyFGd4WbUAlBAvqw5qU06huNKEt2W+w4LOsCkf/fwlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AEi/763L; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ecf541e19aso1026241b3a.1;
        Fri, 05 Apr 2024 02:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307736; x=1712912536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cohi3aKjv+1U6Puqidh80iZqRFzOJIsMybMNYjaL8SU=;
        b=AEi/763LF7UdJr7VCVGPcL/rEvVciAtlPbtGeTBQOtl1ULIXFRlB/8tzxWoxmD38Vh
         s27CUlnj8rd9ESh+Td0Ibxegqb6SVl6Br2uR54QLprY43Y7AaVAEPvjZjjFJvf6zj7Rp
         pMMJe9LO6e6wl/ChJbw0LXlgn6IIFOvfRhWIlX8lxG8IXq5Xy8uDX1ETHTy0JgqMjBnk
         sMf2LJp9L2pwvlmlSlPIh0BeG4JJIsbOe7qq4RVDpxlfUmVbP1tywi4ejvlLwBbC+sMp
         /mQxGeGAgX7LV4Yhu48R5PY+4j6/NK7d5IefGRa3MgE9OKg/y6y6RVmcTKw6MApLg436
         ZeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307736; x=1712912536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cohi3aKjv+1U6Puqidh80iZqRFzOJIsMybMNYjaL8SU=;
        b=oxCqpAtNKEvCcgFkpq9NmIBB+Wkv3W63SqKCZzhGcmM2YXRgUzEW8wqbwPgc6QuOw0
         eVH2F14gdOHwgQBkYsxXzwkWJD6wJ/lngfLwszYQfvJUejy2EmiTQa4pQ3sBD+Ei2TrD
         f9Hkuik0hTXx2OzcDv0jJtMuHtMvcEGvmt3DhIDvRTQ6g5YElrwT/R39mc+6FQpiWb9L
         NYJrfGbehbf5074RS0n/tvxkGOeNd3ga5EzEstljwuYffbanjYX+uNybAvqgl45FdASu
         3WYWMZMtRhqM+c87DJJVubchWRWqTiBIkWpSQoHYbOAQe4dMm63tkjxAUt5ngxU0Hq0f
         sFZg==
X-Forwarded-Encrypted: i=1; AJvYcCW/6zKq2ZracF8D1+5BpkSiSvKaF7CDAbe/u3ey6bUYN3h0MJR2biPdkfVI9P6OvCYexkhOce09DBRW+AHFuHvPSyhGmCPGDqJTEJQ/3cq4U9dL1Tm0LJlHCKxAA3duTQ==
X-Gm-Message-State: AOJu0YyzcJTeGfp2N6B0XbWD8pb1Hb7vpcI6J6yiAQ1HWvvNVl5Fo0cv
	xutkpznwiEs3A1sq9vtL05uP+L7ufDcMIHHicAK1o3Ax1WcuYwgy
X-Google-Smtp-Source: AGHT+IG9dVdT+vakcHxy2GC/HHhs+O8CS4HJBxtK610mZlct905ZAPsg+YVWeNrmXHHatzgeuDW9jQ==
X-Received: by 2002:a05:6a20:8d24:b0:1a3:c8db:97b7 with SMTP id q36-20020a056a208d2400b001a3c8db97b7mr713286pzi.47.1712307735963;
        Fri, 05 Apr 2024 02:02:15 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:15 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 08/17] shellcheck: Fix SC2119, SC2120
Date: Fri,  5 Apr 2024 19:00:40 +1000
Message-ID: <20240405090052.375599-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2119 (info): Use is_pv "$@" if function's $1 should mean script's
  $1.

  SC2120 (warning): is_pv references arguments, but none are ever
  passed.

Could be a bug?

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/run | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/s390x/run b/s390x/run
index e58fa4af9..34552c274 100755
--- a/s390x/run
+++ b/s390x/run
@@ -21,12 +21,12 @@ is_pv() {
 	return 1
 }
 
-if is_pv && [ "$ACCEL" = "tcg" ]; then
+if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then
 	echo "Protected Virtualization isn't supported under TCG"
 	exit 2
 fi
 
-if is_pv && [ "$MIGRATION" = "yes" ]; then
+if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
 	echo "Migration isn't supported under Protected Virtualization"
 	exit 2
 fi
@@ -34,12 +34,12 @@ fi
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL$ACCEL_PROPS"
 
-if is_pv; then
+if is_pv "$@"; then
 	M+=",confidential-guest-support=pv0"
 fi
 
 command="$qemu -nodefaults -nographic $M"
-if is_pv; then
+if is_pv "$@"; then
 	command+=" -object s390-pv-guest,id=pv0"
 fi
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
-- 
2.43.0


