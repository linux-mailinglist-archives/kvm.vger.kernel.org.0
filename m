Return-Path: <kvm+bounces-24733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB013959FD2
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE2501C21998
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399441B2EDB;
	Wed, 21 Aug 2024 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dRyajogO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C21AD5F4
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250422; cv=none; b=jA8I8TGM/Pe9Q3bvZGyqFdbYhg5nEvShpCRrvj1xSsAWZPJHOmmn6kXLFRs1QYPCou4AbDJiZTvh4PwyQf2M3MxNkrwdk4ICgsyNgO2fKSpt62eWK1TvbzswcgHGX6XhRO6/vSzZLii0N4OESkYbtYm439d/lJm2pDSgdjdQh4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250422; c=relaxed/simple;
	bh=IONQ9K+ncgBQnOswyimKlfv7KszvEvtd3KO+g7AOqXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZCrk0srsn2qt4KrGMgQAyrvOoYJNXYx2v8UD/WGn+DwQmpSnxulqmtCLDfEXDk6UW4itBpLLcChGbH6tABnTyyPPFa3V6tYHvpEWgoen7X73IUMuFQQRTtighL9rkubNymAOe0mBO3YO63Yl60FQEfAKWdpj1M46+wQ3JyIR3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=dRyajogO; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3719753d365so3893658f8f.2
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1724250419; x=1724855219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5KqTGxW8AKVPvkiuwUCASJeIM7PQDb/Zh6a+fYZvgHw=;
        b=dRyajogOoxiecOQLLJvLbFzH4IVNO+VSsyvoag2qcWXx8YXa2DHkoPjms2QGsvlbfC
         gROBLTQqxR0e+6bK0GHWuFBYN5hg2uWUO6J/7qKgg8HJJzlhz4u7Y5uRmkNK3D7SJBjP
         gnx2+cc3EyUv7ibiITaDV6buJAiCb+yEPOg8PEOEHpsQGCc9Yh30TraOCaBbzBMQM/dZ
         IKSURhTsFzE41XNQ27eAkgK1MF2h8qqoXaglqeKvSy8GZE/ZDlRZ92peXP+U09GeH0aG
         QP9DezvhLL8/BST+oIIri0706kSm6JjFea1GspaW0r3OTAfmn8a3dZAvcZAttktkYX3k
         poYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250419; x=1724855219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5KqTGxW8AKVPvkiuwUCASJeIM7PQDb/Zh6a+fYZvgHw=;
        b=CnDkwr7y+Qz8culkdwzmJtEc6ufyeK54m2ZuMYzxVko31SJvFhpME+2HBkQnBCLzlO
         pyhmwaqYci/VqVjjgK8NSKIs1GPOhzyBIsA2PBLh+knUSa2XnxUMi4FGZzrKDthfpbez
         36RZ0F8F2GnIfPL/tF4T3LEq1Mh96GBrIf8+VHhTeqCcmgm81UD8zXNwL4NqliyfoM4D
         zmMEAT9/KF2OBXtTnhMUWMg6IMi1V2TJwh0RRKPMM+l2L7ojeGrjuSwRfLnTskOkK5Ug
         Wj/0/nCM8OLBcA+8gI5hY+7jqj0Axe/OVYU545YoqvOREApgwkW5YIo2XqXksR170IL+
         90YA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ3boP4AsQyx+yW1r6Ct6I9uRUEGQLmtapPs+W1p1+s/0cSR0GNL3lLfAgTLfv/j/Kob0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVIHp8cXorIhvf9pp68cCWTAlMOV0Nr3FF9tKyPiTpUP+UTJhs
	XvnATx/Zl/Mzs27VuuyKUTW8I0iksJKoNEp3V3Xr5EroYqVGnn0kHDZ8OtrpQJk=
X-Google-Smtp-Source: AGHT+IGafRGb247lD1GrwccfwBXd98zL9sW8f4ol63M7LSb6wWS+TrhwVQYhVrUkyGsLrvYd0XQeKw==
X-Received: by 2002:a5d:4c51:0:b0:368:2f01:307a with SMTP id ffacd0b85a97d-372fd70f4e4mr1778474f8f.46.1724250418743;
        Wed, 21 Aug 2024 07:26:58 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abebc34ddsm28646765e9.0.2024.08.21.07.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:26:58 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 4/4] riscv: Correct number of hart bits
Date: Wed, 21 Aug 2024 19:56:10 +0530
Message-Id: <20240821142610.3297483-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821142610.3297483-1-apatel@ventanamicro.com>
References: <20240821142610.3297483-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

The number of hart bits should be obtained from the highest hart ID,
not the number of harts. For example, if a guest has 2 harts, then
the number of bits should be fls(1) == 1.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/aia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/aia.c b/riscv/aia.c
index fe9399a..21d9704 100644
--- a/riscv/aia.c
+++ b/riscv/aia.c
@@ -164,7 +164,7 @@ static int aia__init(struct kvm *kvm)
 	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
 	if (ret)
 		return ret;
-	aia_hart_bits = fls_long(kvm->nrcpus);
+	aia_hart_bits = fls_long(kvm->nrcpus - 1);
 	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
 	if (ret)
 		return ret;
-- 
2.34.1


