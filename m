Return-Path: <kvm+bounces-42119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 509EAA7326E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 13:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 888AB189B5AC
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0FD2147F0;
	Thu, 27 Mar 2025 12:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5o3Trzf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730BD213E99
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079489; cv=none; b=lqorCisATM9mLfzyrN0P2KMe5rMGR2eVM6Am9fwTC1RR2PA4LZvsYF1dMOUbpk5Dd3OI2eno9J0uvUwS8hTXmZ/JkM+aA7akfwz1Rc/sTE/5ltE4FlOb4Pyhxh+6Qcen2u9zBEit/t+avl0DmRD15wPN7C76MwioA+nUV6sdd8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079489; c=relaxed/simple;
	bh=i5JQm9DqrSRQ96Mfvrlb1RwHHX8YBXcxQ9y8zq+dgJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OSV+o3u6CwVgRlfQgfwKlRjNzKEwAE3XJ95+qfEJB6YjRSTV/HLum5Ubf7W1heMx9zFRB20uy5an1WwE8IM6TBKtwj1q8RLv5ofgcetosOHYT0W/zefrWbdukCtFY1W7/8sxVAeNkfh4SNM199NAxcxRZ/z1Cs6ZRqJHJryJpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5o3Trzf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743079486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kfyheL9jEG9357hLbmic+IF7J8U9ykncYZ9iUVWBbFY=;
	b=Q5o3TrzfzgzscKq3hcqaB2MuUEMtIkT5EiT7ycJQs2Es6TJKOJ4vmg6ulW0p1Rv+j6LqMS
	BD5+NRZEig+FXZVKYJOLyqBf487bhCiDdP5wu2VDDRarMY21LJEKs0HUEjd7i1rH74NwBw
	ORF+2yZYiqFC9xqvFPx+fv4nKMTbOAg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-BjvcROl6O7uelDOO6J28Uw-1; Thu, 27 Mar 2025 08:44:45 -0400
X-MC-Unique: BjvcROl6O7uelDOO6J28Uw-1
X-Mimecast-MFC-AGG-ID: BjvcROl6O7uelDOO6J28Uw_1743079484
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3914608e90eso753538f8f.2
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 05:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743079484; x=1743684284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kfyheL9jEG9357hLbmic+IF7J8U9ykncYZ9iUVWBbFY=;
        b=RYrKQRlgltrCLSl30VrUCcQ4kbx0ACeEgc89TJ5VYiX5OMsi9g1I89BpHK720f0pat
         EaIIo8yaFNxQUb0los2jHCwowjP0wBndYOAcbvjkpp4o8Z4AEdV1RN1jkoA4/Wwg/pP8
         2lZneu/6Y3vPRj1G29Ibkuoc2uBC+F7mEjoLsEQQtRanRtiQI1ea5gkOhXsf3NcUJTY7
         sbuAWfsw4MddLEfFsJdk/nynHXhxLwkcskrcrO/tiQbBEJlUJB/jUuXNoWJPAsrH4JdI
         5asYahUExgpZtMT4Si7T51PcnsHnyNBMyl8R/8CpkTRljs3aMjYEohSOx0wVahCWViB5
         IjDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgZP4CGVeA6Mack+9pVIFxsDfaHofQ/ypZIg2+yyDPp8akRXeGAaAt156SMDI1fg2NFzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuSfcRivwYO1Yj+l7KpBMPZCqSVPTFz6OE8GQRFeOLYwAq1Z/k
	rPbJgx61n13pMl+AbQLDQYTNYb2xI5INS4lBoemjGsBmDJnRlxJEt6TS3v7poXFcwcRardDkjIS
	vb/fBBF/JLP+TgMS4AM391qwNSRdgjoENEvmW5ojlSJVlQp+RUg==
X-Gm-Gg: ASbGncsR/1iAh3/1pHrADDUCf75KNPaHuhgDGPSS8dNlpLqO292IxwL46csWYI60i95
	jPcesUitCrOeRgyy7cI0KjAKeM7bw9Fg8lMETnKWSZUiY6S/PCEEf+ba26zyeNDsWE0ircNu7MR
	GwrjjD0R9lqnGbkSE/AdJ1CQjjgwAcJogmlAyoz66lBNdC27GwDLuI+Id+IYK1tGhciPA1Kvv0u
	zy8CSU3Li8bV/UHXQxJe65iz+KOZdpAc2kvn3N052nd6uO2oeWq3MDVcu9SfR7MEdxv7/IW+AoK
	6VZ8UDdtLbmb8SWmcyThiGKGWPqnJN7F6alEET9mq0lOEc3ryUSsprsMejPf5Gtztg==
X-Received: by 2002:a5d:6c6c:0:b0:38c:2745:2df3 with SMTP id ffacd0b85a97d-39ad17845f7mr3077939f8f.37.1743079483834;
        Thu, 27 Mar 2025 05:44:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlm4s0EdoS5CN0bcv1wS4l/Yn0TLs2QyE9bGxPtaa+Rs3z5qIUN6VRMhNwAZdWNibUqtu8qg==
X-Received: by 2002:a5d:6c6c:0:b0:38c:2745:2df3 with SMTP id ffacd0b85a97d-39ad17845f7mr3077908f8f.37.1743079483197;
        Thu, 27 Mar 2025 05:44:43 -0700 (PDT)
Received: from stex1.redhat.com (host-87-12-25-55.business.telecomitalia.it. [87.12.25.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3f76sm19986612f8f.37.2025.03.27.05.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 05:44:42 -0700 (PDT)
From: Stefano Garzarella <sgarzare@redhat.com>
To: mst@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>,
	netdev@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	linux-kernel@vger.kernel.org,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH] vhost_task: fix vhost_task_create() documentation
Date: Thu, 27 Mar 2025 13:44:35 +0100
Message-ID: <20250327124435.142831-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefano Garzarella <sgarzare@redhat.com>

Commit cb380909ae3b ("vhost: return task creation error instead of NULL")
changed the return value of vhost_task_create(), but did not update the
documentation.

Reflect the change in the documentation: on an error, vhost_task_create()
returns an ERR_PTR() and no longer NULL.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 kernel/vhost_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 2ef2e1b80091..2f844c279a3e 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
  * @arg: data to be passed to fn and handled_kill
  * @name: the thread's name
  *
- * This returns a specialized task for use by the vhost layer or NULL on
+ * This returns a specialized task for use by the vhost layer or ERR_PTR() on
  * failure. The returned task is inactive, and the caller must fire it up
  * through vhost_task_start().
  */
-- 
2.49.0


