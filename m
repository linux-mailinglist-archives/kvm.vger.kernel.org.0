Return-Path: <kvm+bounces-8416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0F884F203
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29316B293C6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC41664DE;
	Fri,  9 Feb 2024 09:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+REB+hO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12375664CA;
	Fri,  9 Feb 2024 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469922; cv=none; b=JUsZqBhbC9f02rNgVNHfo04qr41uw2CPc38hB9l+ExkzjfGXCrZtgxPxCHudFzjwozKkkCXWu/pztWry/snsX6mDkoZ0UUxKPMBCrUqjrUeoMyupaTaS9P+in31Pp6rukTHm+/avdFcKrYwxLFrrKtciUadWHeP81+Ab48xotgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469922; c=relaxed/simple;
	bh=XkWbXJiup8BsE99nEBZlkdOg//43UMa/HAUJAsLv3zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1xXpLv39uWDHLrutKHXk7wTF5R/H7E2RO93uVRx4gUzRq6/wiIexzisYeurSw7k3gkiGnFRFuU/KI0qiZE3lvkGOJM1s7vfMwAovnWlROQu7FNZQ755GyEYWTo4v8cVl2gh1+EYpUd9W4sHqtrYepfsmLSrzzEdcXFDSZUpoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+REB+hO; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-363da712713so2073805ab.1;
        Fri, 09 Feb 2024 01:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469920; x=1708074720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yS+ul2b/NpaGNmT4nHQYQeP0IrroORjWUgFq1DiJtuk=;
        b=D+REB+hOXikjHTzrTPFQ2Y7RagnTD/8NxkUVR/KPVhERIi3DVpMku9eIbTrVuovZs2
         g8wl7yRt8DadYdnPPSNkqLhHLAp7CsEa4qh1MC72l5LHvwOLZHN6NjjCTuFPGnoVN5Mi
         Kk34TVtWsad/By/FqerKztAPDTFSBFAGnrG1peRYqb68mQL5TLcq6YOw8A+qNdjnYk5U
         oA431pxGYD1I14P4slq1IsFl/c5fpTpNP23vcUEa3q56i3YjppcjSOUjxiNHUed+Oz5u
         q08zqXj8QpVnhhAggGSEtgMQY5J77Lq0cTzJCZB/OJRV6UF9M0rzkkgWXTTli5PnyLw1
         1Psw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469920; x=1708074720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yS+ul2b/NpaGNmT4nHQYQeP0IrroORjWUgFq1DiJtuk=;
        b=poObnCu2GAp/yjCBR0cAikppl08lj4reALo4PXZmBMOvWQ6UY5ZRlcPWLJ3jfws/US
         bASfn0skru8ARVGAevbXARo9IekZeSgIqS49rGb99oUGPa6DQW2Wd0yDicMOTPm7Z49e
         FpFW45I7uLwDIUbfahNQuNbVqYey5/pHyUDYk6VZPOGflAyq0uIoFHHaDBpZ9p2rgLJI
         7KkQFYRjTRVI7Olafy+6eiuwx56MdT50/YcbM1DS9IJSvquv1ZYn1MLgLmaxX9fE+gI0
         QYvSY6mLhD+JlsYbPbqeECdEPtD9cFA1ISTpfa5798bbdtJe3knkUEfPFQIyUU6avJ+i
         NT+g==
X-Forwarded-Encrypted: i=1; AJvYcCXN0qurKvlw5jqVhMYH37X7omPhDVBfZr4pFoU7Rd/MU+3G7HLR3I8gMSS6sdsRbJx/euQfyMQEH5ToHKP8Sl15DTIUXtGP1HVFK/WkgQ/mqzhdC54pO6GfXYLb+Fgvhg==
X-Gm-Message-State: AOJu0YxTOUZMitP70BnX/0D/0O8vQi28F+xmZawRJitY7XK1SZNzm6Re
	esFGKHshJsDgWriM5mZL3jmtCjEn5j1QMYzfBB7Zf4PmV06dwyWK
X-Google-Smtp-Source: AGHT+IFRG49LrsMALjwaw/QQGV3P6t7iqzINaidenzf+7nkJ/oR5JUoQayo972KhNecT03FbRR4u3A==
X-Received: by 2002:a05:6e02:12a6:b0:363:c5c9:deb4 with SMTP id f6-20020a056e0212a600b00363c5c9deb4mr1134765ilr.14.1707469920181;
        Fri, 09 Feb 2024 01:12:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWDopPltMDOD/Zc+PObLBIP1nne3PAHsVM6zRZWO1HpORlibOckT/gTcQ19PG5LdBYjTnCRcjHTqOD87qjEXIJ1Cw7vJKBTxRxvlbtduv1eAO8QEC3zvdE/JG45h1/hySgdnu4sHEuXGV6jdeujTVLoH6eqLOSPODhCWZI/0SPP3ZkdBudUiSkYqEz1CH99b0O99Nhv5N9EuQELW/E6kWEb6PyvGtdAXrgaVAXE/TeAkLARmmyO0zgbKZglUUiiDGXR28i7Prujn5UHTgY96rYxQNCAhONw7ZbmBCGszMHcWZlZ2hqwhT/hzy/4gSW65TNy5kHI8BBZUl11FY31xxTtnsGu5DOcr/0dGsTqplINJ0f00gj+4/Qf/JWNCKfUWmeheIRgqAZM/KeBUcgdkSTFXIItBmlR7IQSTajuDXKUEEqzQJANuFk2VqKEAoJ+hJhIzPltXqVq2CgQBb28tG4SNO6NsoSINmz0faIh18GbVw52Y1je6CsC9xx/zd8vtsYtwnRkF9tDoHCe77ZgebF4irBc+bEu3Iq91jwtK3kjmKiFN6wxQBWX
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:11:59 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v4 2/8] arch-run: Clean up initrd cleanup
Date: Fri,  9 Feb 2024 19:11:28 +1000
Message-ID: <20240209091134.600228-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 11d47a85..c1dd67ab 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -269,10 +269,21 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	rm -f $KVM_UNIT_TESTS_ENV
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+	fi
+	unset KVM_UNIT_TESTS_ENV_OLD
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0


