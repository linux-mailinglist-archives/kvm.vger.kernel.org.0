Return-Path: <kvm+bounces-10668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3EB86E7C3
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71FA728A21F
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438DE18AE4;
	Fri,  1 Mar 2024 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="U1ZZq8x3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D4F27473;
	Fri,  1 Mar 2024 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315527; cv=none; b=aJXrE7upA3IaSTVlJ73T56VF9kIB8MCW4eSEpW//MmgaxWNptrYf/iyLavsmxoHTnn+c2u7abDtll13T83CD4Pb3HhZFeP5oTfFz9PKlKsIRiBlIJthMCVy0ktyb6yEi8zDEGhTET/nEg3/Bx5cWWFzVre2XG3afZLkY/a47Uro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315527; c=relaxed/simple;
	bh=NiAx/QvlJO7pIdC4+zgX43GTCq9USKyUoLo6CdgdvCw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=S3sq6cL0SdqHIqsNq5Qpn6ZpnnOMKoTFGuxJS3YyE3okS7R8lhkFjNJvDv2f9ZG3z6CLqd4Wra2zrgNUFdTuLYFtMV/SaZitxiXon/InwyRiv6umeb7xJkkVKjm9Lw1w1+y4QKGeo9bK0JjD4xLK54RooUJ1ln1szQ5e5wq4FQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=U1ZZq8x3; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e56d594b31so1345223b3a.1;
        Fri, 01 Mar 2024 09:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709315525; x=1709920325;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:dkim-signature:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d0OyJ3Jrpe+bUzJYVY/u6n3nULkDQFm5xA1VV9gBF+0=;
        b=l1aEnaXrme1wPghUF18ZaNFcZZOHQMH/3rCA9S5NKv0YBIl6Sekg2htW/IR6RhqE0w
         vBopOyOpsorQAnOa/heYnEjHYxuM9konFVIIqJclasq/t0TJB8+8V94cW5j4Bx0rd/HJ
         IATNLoC/Wxu86IbeFdTgCWEOYiHEUKEVOdFhLkGMY4WWWTxnfNOC59TtDcIvMjwZ4m3F
         TXTEsdK4uBn8jxMb+/4FWrmdVw1jQlcHX0RqpXOEBgKiqJ3dSSkDPMpUSN+N96W0mqCA
         3FqlBKMwb3lqbLxWYfSCKRDpCgDvxoRCZxnByjwmU4+0EwN2RtURiWUV3F97806+pZ4o
         7gvw==
X-Forwarded-Encrypted: i=1; AJvYcCVtnWY4oJoMHi4H5wDmrwh4IhdThXHEnHOq52RautrQtGUEia0Rh1JOw/o0zm7pAkYNCZFtLXx8RSczDwnOf+XW83j1ZKfe5WGZ1JpH
X-Gm-Message-State: AOJu0Yx0CdPO6Ty/++nDcru+yTOhBr0WYjrnMUNbhy0olYeUZUhJRego
	qiKjA2QmHNFWb8T1mKDGZ32ZOy+jF1j+Zv1R4JQn5PnLPBHR5q6C
X-Google-Smtp-Source: AGHT+IGP1vQ1F8EZ+qHBE2bsYet8PIjbn4EVHVxXE7pebYzvzWSzuXQkOMbfwU6LlrMz1FQP2LrHTQ==
X-Received: by 2002:aa7:88d4:0:b0:6e4:f753:1e12 with SMTP id k20-20020aa788d4000000b006e4f7531e12mr2876127pff.28.1709315524936;
        Fri, 01 Mar 2024 09:52:04 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b006e5092fb3efsm3215106pfn.159.2024.03.01.09.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:52:04 -0800 (PST)
From: "Ricardo B. Marliere" <ricardo@marliere.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1709315522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d0OyJ3Jrpe+bUzJYVY/u6n3nULkDQFm5xA1VV9gBF+0=;
	b=U1ZZq8x3cXMZx6/hMHIx6NqNb61evwa+puOVQ+rAUdsI1fNjfgvUsoY4O66x9gPZ35eriO
	CHCkFV8bs0uguES6jcnTblMohxzZmmPzT4cPC54QNblmTLsNIYrTeLO419THdf5P9k/Jjq
	PleviLbPBLOrCwXEmvm9LFa3jufxRqFv/2AVlkFZ+uQ3aPgH8iy9Qbdpt8WWQYSBC0dKZu
	FBMeW2aw7qqU+6n/ECGqXDebK3bbzbhMLV2cD+HagPTr73MmILGL9ihEj4uAEeSV8iylNu
	WSgfhrQ7E+FwXDbthvHgEWV69nPzkKkevMdDbSEMgagl0L6SivHAR22Dqnu0Fg==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
Subject: [PATCH 0/2] vfio: constify struct class usage
Date: Fri, 01 Mar 2024 14:51:46 -0300
Message-Id: <20240301-class_cleanup-vfio-v1-0-9236d69083f5@marliere.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALIV4mUC/x3MQQqAIBBA0avErBNMk6CrRITZWAOi4VAE0t2Tl
 m/xfwHGTMgwNgUy3sSUYkXXNuAOG3cUtFWDkqqXWnbCBcu8uIA2Xqe4PSWhnfGDUlqu1kANz4y
 enn86ze/7Aa6FX4RkAAAA
To: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Ricardo B. Marliere" <ricardo@marliere.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=913; i=ricardo@marliere.net;
 h=from:subject:message-id; bh=NiAx/QvlJO7pIdC4+zgX43GTCq9USKyUoLo6CdgdvCw=;
 b=owEBbQKS/ZANAwAKAckLinxjhlimAcsmYgBl4hXBExbbgC15PORdVb4bq5jNva+fXo1qCo4C8
 70A5s6SveyJAjMEAAEKAB0WIQQDCo6eQk7jwGVXh+HJC4p8Y4ZYpgUCZeIVwQAKCRDJC4p8Y4ZY
 pvhrD/9px9hwoYXCVEOROp/zsw1GuYz9YNuokQFWn6hBf0mIHUBDI6dmiQZWSZUYGbID9KquxI8
 34C278Y4h8nqXERp8kaouVafS5SBwPoY2TWQ6MM69TG+jbvz/Xr+ZfgFNsILkzfxCtdv61uztxk
 TeLCrwjj0uIFUUUAKkaTHAxgW/6lUph+bt1L7uz9QApgj2+Kby3FYtyMvf8xRLLl86lLuUpBagq
 muml/OJMuPLXyyq5d52EaiiJHYayQo1Y1NwifaIjC2zRLiFgr7NhWMS+M9vFUuwWeBspZ3XEQzs
 g2z3nhyBYjehhluFC8fugS0xhhPE9VDF++wjyw5+I73u0/nDo+xKfpJLvwy4DWN+BjTwZZRvI7I
 bxSoTRHNL/F+0DUw5o5KgdPk6cgGMcYPEkUHf3Ffdc7+CpaAgvPMgWp0XvRQWPVx9FNCEMjAOZr
 V/XoDPc6x5TR3dMI6soOqIxlFhMfKSYuTZpZn50p6PPMLwtCRQxrFn3hy/5aBWwONug9FR9b6fj
 fyQeEt2iAvbq7bg/IIAnkR03kZJ9v/nc32xcRXmUorBxy2ORQGwXjQyYJSgmsiRNT9HQODTARQV
 kuTNa/wkX/H7jJVARDcJF5mHW1yevb6+lvi7hQLjt6+XAdt9NzO4cis0R7S1U+JkgGQMx/bR0l5
 t+SZxOpCSJ0j2vg==
X-Developer-Key: i=ricardo@marliere.net; a=openpgp;
 fpr=030A8E9E424EE3C0655787E1C90B8A7C638658A6

This is a simple and straight forward cleanup series that aims to make the
class structures in vfio constant. This has been possible since 2023 [1].

---
[1]: https://lore.kernel.org/all/2023040248-customary-release-4aec@gregkh/

To: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>

---
Ricardo B. Marliere (2):
      vfio/mdpy: make mdpy_class constant
      vfio/mbochs: make mbochs_class constant

 samples/vfio-mdev/mbochs.c | 18 ++++++++----------
 samples/vfio-mdev/mdpy.c   | 18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)
---
base-commit: 87adedeba51a822533649b143232418b9e26d08b
change-id: 20240301-class_cleanup-vfio-3c5f72230ba5

Best regards,
-- 
Ricardo B. Marliere <ricardo@marliere.net>


