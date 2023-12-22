Return-Path: <kvm+bounces-5149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 523EE81CAED
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F5E72876E7
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685C11A58E;
	Fri, 22 Dec 2023 13:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSvCu9dM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2841C2BE;
	Fri, 22 Dec 2023 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-28659348677so1356807a91.0;
        Fri, 22 Dec 2023 05:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253080; x=1703857880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeVnbjWEi5yI3wZCxJZ+3TFl6uPEJpXO65IAKcNUOWw=;
        b=DSvCu9dM/7Zikljf9zdX8VL+7zcUL8EBbVtG48qdW7gi04lPdJaT9IxIFAurQde5tr
         qKByXaLOdgbxCTeewXSWhm2jBbSbmM2/gt+kEIq1dQF3Q+p2kboIext6wmTODoj6uKNC
         B18Xhgr5Zy1UANJCIYepzJvgHHJxWkp6JvbueXk9DOfsdAOnJzNhqncDcJ3Doem+yka9
         JhoXRC+DFJ8mQnDsRfBuMVAMXbumX/I8TWUjibPokItNO6e6KlPLvvpqpaM5OAOsS4Dr
         vCve6zWE2xkRv1JqnP8tRO2CoLZiSy1bsgE/L2qTAV2iKrUYKs2Y6jeL78vM5JJu+EYU
         a7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253080; x=1703857880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeVnbjWEi5yI3wZCxJZ+3TFl6uPEJpXO65IAKcNUOWw=;
        b=s9XHhmbJDG0RhfocKK0JkbSP9T9R+mmwb8X+1VXcqOvf3WUZKMrM4+1B+LX4yGtNXI
         tWWUJ9CX/2F1+zGknOakFTq0iB6NyYAA0KiXBr3QUKB3C1bQUhyg2FE+duqvlducneWy
         +5kvLrAPyXfk9L4tnMzz5h3nXQA2APYwF9HQb2sDmsLOHef0xIcTos2fvr11iocnnN3H
         2CnTbERiKpirWAMHIm7PYGIzqYSpFmtV9317udBy4AUhMBW1MKbomT8cepHbp7hUyp8S
         XlZwun21+jx1Vr5b4xADmLb8fXHAmjNB9bjTQF7O8zELu4mCpk3iG3h36zVvGMgltokU
         BrRQ==
X-Gm-Message-State: AOJu0Yy0OGT5ZB6i48HLO2eZKYaZf/UKyvmLFxm/rO07Tbw1Rgk+uSuz
	7YAF2ryE9AWspsmBmq59M7Y=
X-Google-Smtp-Source: AGHT+IHqnb2JvkeLOq0Zyx6dkuBTdsnQ/G+82at1GcM1w/Cj+jE+jQEH5a3pKGr37WxpE4SIFDqkjg==
X-Received: by 2002:a17:90b:1945:b0:28c:191:132a with SMTP id nk5-20020a17090b194500b0028c0191132amr1657944pjb.7.1703253079864;
        Fri, 22 Dec 2023 05:51:19 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:19 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 2/9] arch-run: Clean up temporary files properly
Date: Fri, 22 Dec 2023 23:50:41 +1000
Message-ID: <20231222135048.1924672-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migration files weren't being removed when tests were interrupted.
This improves the situation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..f22ead6f 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -134,12 +134,14 @@ run_migration ()
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
+
+	# race here between file creation and trap
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -211,8 +213,8 @@ run_panic ()
 
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${qmp}' RETURN EXIT
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${qmp}" RETURN EXIT
 
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-- 
2.42.0


