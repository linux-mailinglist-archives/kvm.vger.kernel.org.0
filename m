Return-Path: <kvm+bounces-13794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 620E189AAB6
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDFEE282832
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277462D03D;
	Sat,  6 Apr 2024 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCjJC9LH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082E41EB48;
	Sat,  6 Apr 2024 12:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712406311; cv=none; b=Dn+V0gBprlpUNe3t+DYgRconvGp1VMEs/uUQP8UHpVGYvvgiCxW/CqmLj3uj4e8SJ/v3aSZ2JG5o0arYMQeFdOHag/0zGBDPhOXlfRTGUs7PiLHp2FnJVAPh23XcjYl3NDmJOAKLhQlYkdYGi4hc17zYI5XqomYgITgZMFV+oS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712406311; c=relaxed/simple;
	bh=IDmXIZcyO0A957XKh65344IcoJdpryBIYtyu4IJkgyc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nteH/fgn09UoRBEVtRi7gvagfjMSkxFQMX1J83Ebnu1X0G3nwHSRr6FzJ4DdxibHDaoyBzJG0rWhGrc6IBv4vWYHi7kFTFgNMVqaswl261PyWZza29NiJ6Gn3D3HMpCgYCixncXeFYsn5CwjgJ2ubl5zWuyMcG1Yd/SzQekgTsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCjJC9LH; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecf05fd12fso2391179b3a.2;
        Sat, 06 Apr 2024 05:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712406309; x=1713011109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qWyn2vaZVeMFNiiOqBBsHVr8OdDOl2CjMt+4CL3gofk=;
        b=TCjJC9LHLA485Pdt9pVcDJdZ/ukSFMdVjJR1/j5embbOnf9YqiUfMTj1MNvEO0KlfS
         mF+xxB83WbXzI/tEh7vPI7OOzst8kBdcOkgDeNBY87D9vBo6ElHwYKnYXeZBwbRkCTpJ
         09QYJ9LTiNqFfaizn2CfY7I+N0YZycw3lmtMktsZ0iEHr6PAZfyAbCLFJiYKHVlnpiw9
         kyvm05FUTxuUUKo8LpNXRKmi1P/LUf80Nn0SdwkhLmpYBV8LIWlLPsetUS8e8Yzkqody
         +R675KUisApBsNaQpody2h0shyDz4MuXu0OVLubOT4mrzvNkFegtfT34UXzF4Awt9gHI
         ft8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712406309; x=1713011109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qWyn2vaZVeMFNiiOqBBsHVr8OdDOl2CjMt+4CL3gofk=;
        b=wUse+VCc3nIzUkVvMrQ7x9Ma8T8PE3ABLVIuJRtd2XUwYUBaWYWMb1hCS2h5yP3s6b
         A1OSaIlBL0zyOcgxrfJbIcnKjXdm6SqEAjVcUvfMmNyrt6gITungoeqGvA9xjKRNVLvP
         hDDQ+K+bYolSsAMSO0NQe4CEFMtEphMfE2PG6qbOog2K1DunP5BsQwcYvzglN7u6SMMP
         SmGJQGJ3RikGxN7UtIJq6dwZgWXPduafNN6cTbXXEc6c/zcnqkKRQ1JIcfnn4CZ4GyM1
         ih0fd5eoQXGjwjDzM1/Eka0EXpGrN7G6E8C0gaZ38Bcq5ziQevSdkQ31vK9yB8SmxvOi
         CG/w==
X-Forwarded-Encrypted: i=1; AJvYcCWEl3vK4qX+9FkdVcyekplQAEHDh6DLDhXjM7vbJO5IsQ/0RgSpbdsVxOwWsv7vG7PQePo2rCZPL+N85a73AgbSgNW+23juHe0CGyrcftJ9AHwl7FDoHCIqh0xiuGZ65A==
X-Gm-Message-State: AOJu0YwLsFhn3rC+IAOe4oJklPOd/yzPO2zBnSe29MQSCboeC9MJaj/E
	imle+hLAAQKzrX3sHzEx8BkLMzjjbG7m6khgQ5FqccSkDSGfd8rU
X-Google-Smtp-Source: AGHT+IFE0ZSQ2hWuQWe2GeSD198dHu0SigK8UNBNyU/lYULFzCFq8R+Nv7h6ln6jYiNq12TkGNEa1A==
X-Received: by 2002:a05:6a00:1803:b0:6ec:ec1b:b7aa with SMTP id y3-20020a056a00180300b006ecec1bb7aamr4403342pfa.22.1712406309342;
        Sat, 06 Apr 2024 05:25:09 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id g14-20020aa7874e000000b006e69a142458sm3091392pfo.213.2024.04.06.05.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:25:08 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] s390x: run script fixes for PV tests
Date: Sat,  6 Apr 2024 22:24:52 +1000
Message-ID: <20240406122456.405139-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Shellcheck caught what looks like two bugs. May not have been too
noticable because one just seems like it allows TCG to run PV tests
which fails (and might be guarded out later anyway), and the other
might only affect running and individual .pv.bin test with s390x-run
and not unittests runs.

I don't know about running PV tests or have a system with KVM to try,
so these are not tested beyond gitlab CI. That might run some PV tests
with s390x-kvm, but I don't know so please test/review/ack/nack if
possible.

Thanks,
Nick

Nicholas Piggin (2):
  s390x: Fix misspelt variable name in func.bash
  s390x: Fix is_pv check in run script

 s390x/run               | 8 ++++----
 scripts/s390x/func.bash | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.43.0


