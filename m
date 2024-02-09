Return-Path: <kvm+bounces-8392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A970984F082
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:02:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 611A4287FCF
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8AA657B1;
	Fri,  9 Feb 2024 07:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNmx02Cf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E19A657B0;
	Fri,  9 Feb 2024 07:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462125; cv=none; b=krcyWccXP9wdu64WEj++O1KgBu3pjQuVsTSjlOhmiQZ+8CbGf3gn+ctj6gcMySPUSTuwqi/TOw2AvmBbAg7fse6poKSDiuPF3dhfbiqpKB1bm9hQc1Tv8onxGoO8gsLjMkhTTSfHwuyo20hRv6kabng05+UJJUpUbUbP3CE6h4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462125; c=relaxed/simple;
	bh=UVP1Wum4p+fkBQmbGH46gx3YuxcNQtb06PxYoUjG2iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU4gHi6O7qTtPdffQ341lIydhBK08+mZhtqKeqqnaBql8X59wkNr/TNe35obAe1gtbfQK/vw5VZ3XY7PaC3njqxv7ImQUmWnM0oAN4V2uF5Bss+7ej8mw8s75Y8AsKd23y4lBKWAqC/FTsKco52Suo6vCuLxrwsi6MVVen0Re8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bNmx02Cf; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d934c8f8f7so5021145ad.2;
        Thu, 08 Feb 2024 23:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462123; x=1708066923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eL749GGZxcw+dNDSidA1ZYGeUwGyyiY2EeTAJqo21lY=;
        b=bNmx02CfRJNlitkHs2t9G92FHSVbAjNtXR971xxiCwKbBrmKPBYWxdDx8u2PYpl9yI
         WoY1R40CQnwleahHn9vLZS7rxBb/suXujXryjYFF1QQIZkaHoWwp26graGbBgAu+7Uiv
         rrgcxiRN1PpPonW7a3CUAe986ABH0AuQb+jntriyc4kTyRyMOoZqCq9HDD6R4jhwQseM
         781e8DNCaopsOSk3HoArrzpOZnfVFil2vUKaifb/K/7vsyY1fkep58ljC4fSJiL/fHmt
         aYK8hO1cNfFthelyMDcQcreGEeymOvxxyfV5JE3JUEwHEM95uFzQPwo+5VDTJRHuwsbN
         qqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462123; x=1708066923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eL749GGZxcw+dNDSidA1ZYGeUwGyyiY2EeTAJqo21lY=;
        b=X5uQCSaduanfAwatFXOvqIE0zIJLg36n85prOmihoMeGZxVEbANQfoTQC9Fd75JIe4
         q6haimu6JY/iWdnzAGsGv9F86MrO0PpR7a9scxKWqOkKJZdKTP2R2H9xyWSZWCoIo7ht
         Uv6VxSxFtj5ksijop0GGIHJGF4knJmPIwPm1bJIsx3hU0DzU97V0Y1yY+sOpCNwZwT+v
         3JHxNEdjNJp+TyDAuc+cM8wA5fv5ZoYfK+FN14i4E8p1ATKn92AxIXAHvh2UgQkVRL/e
         kY5nWA7ueMUJDfwrJOzADkdxd9YB6kFFTzrcMcO6jF3kDbc05rLCdPPqGLcG1q5x6n0J
         sZLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMViDzGauYhyRjQ/3KG614IPVwcWm/PDb5qYpjNHGSxBP6H3KvRtBmXHuLEiiLaGJWXIorVX/7TMEVZofuTTyJG4hmIJHdcr17DwaYRNilpzsQ7y9OsmXhnxZ7dYKqyw==
X-Gm-Message-State: AOJu0YyMj6lFzezSWwcOwtJhwlPzcfJbZ/ApULPUND8XavVvacK0U06i
	9gao5z1ni3Yg/VdUp4H+8o0FIY29dhzO2c7zCBeuV9qRhsuySP8X
X-Google-Smtp-Source: AGHT+IEdJEZPg4RmRriNJvZ9ahIM21K97ubmmeCO1CKYdbqQsQThckXb2cLmncRYSvscNc6GGM/MAQ==
X-Received: by 2002:a17:90b:18b:b0:28d:1e1b:d73b with SMTP id t11-20020a17090b018b00b0028d1e1bd73bmr549771pjs.19.1707462123256;
        Thu, 08 Feb 2024 23:02:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAx3a693s2l69Ut2KmKGU4vE2ZC23IXFwaBq60nxdhXQH/wHqINSDRVEggFL83Uw2MwTD9HerALBagZpD8L1eLx4n8TkjqzJ1EGYIMSlHivyd5ypAco80tPfYCz8Hhg34bjv7ya4IYE/HbC0AqAGovAva0WfT4DoOWsO6umPQ+WPMNMsSVVAV6YrXzPXUNjf46OwTbAN+E3I9XhudqgT3G42OFW05p0f0ADTIl6+x+6xpc+BkKnDEuLGaBB/BqUB2jz51hr6LLF3YkHFzD8NghbacfpFpqTB42Io0ldUdysrN7sPlP4VBANUXFnYvnXnoZsg3HXxn21bbqXtbw8r/hLfPNYHjcYLXHdwKUrha44NHYGWm9DIneZWOA5u1atuzSBY0CETd4h9+sxh1mG7owCB0o0+ZXnqlFbAOozjeWyXn9jMGm+jqBMUF7S5W4yc/bzY/sAz8xGDJrLGWUVSy2CPWb1PfsKmTPZNmUM95l6OTokRvOeYdBLQBzEFZzMCIypPS85Ja35rox/gu4ZJdSZ7xbfoYZk4+nYnsWLWrlcarZSyzAyZ9l
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:02 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v3 1/8] arch-run: Fix TRAP handler recursion to remove temporary files properly
Date: Fri,  9 Feb 2024 17:01:34 +1000
Message-ID: <20240209070141.421569-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migration files were not being removed when the QEMU process is
interrupted (e.g., with ^C). This is becaus the SIGINT propagates to the
bash TRAP handler, which recursively TRAPs due to the 'kill 0' in the
handler. This eventually crashes bash.

This can be observed by interrupting a long-running test program that is
run with MIGRATION=yes, /tmp/mig-helper-* files remain afterwards.

Removing TRAP recursion solves this problem and allows the EXIT handler
to run and clean up the files.

This also moves the trap handler before temp file creation, and expands
the name variables at trap-time rather than install-time, which closes
the small race between creation trap handler install.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..11d47a85 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,6 +129,9 @@ run_migration ()
 		return 77
 	fi
 
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
+	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
@@ -137,9 +140,6 @@ run_migration ()
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -209,11 +209,11 @@ run_panic ()
 		return 77
 	fi
 
-	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
-
-	trap 'kill 0; exit 2' INT TERM
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${qmp}' RETURN EXIT
 
+	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
+
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
 		-mon chardev=mon1,mode=control -S &
-- 
2.42.0


