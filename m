Return-Path: <kvm+bounces-8834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D605E857201
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85B02285950
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016EF145FEF;
	Thu, 15 Feb 2024 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BaZpZnYq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC138145324
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041254; cv=none; b=aXQ4l8okCZr47v2vsHfGFDODVnW99HKau5VqrTnKva/YKg9dYgEWcL87xjXS8X7gTALi5wk7htPunfpLIk63rMXOyph/7O0JT07EM7C3TCFH5Die/pTdGzMnSfsvCuTFwe3qpQeWCsomNs7aVhL5aD3V8HF0M53BJSnjh7zbZ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041254; c=relaxed/simple;
	bh=2Gmh2RqGGbogR47nKktVVZKh+hADkkb1APEKMK2y+Ec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EAsZJzVegiMwrpiFN5iUrH7Z09CMQ53WfrQANpxZB1JfvFCpW9qCELz033RnjUaYl0ZWT6W713SuFhoSIZ/aZ6MCrEvzqonXF94aQKVIlYYgNBIojeZIv0qNgqu5Cay955v+9f5hyeAh+6cXXBm6rXlMAZlbBLdyLmmQK7vIBs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BaZpZnYq; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b2682870so2290139276.0
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041252; x=1708646052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpXI0W6SyqUsN8O3cq60fFq4dAgX1VPZevRlW+M4Y/M=;
        b=BaZpZnYqeQRvDiEaKaatwWbK9wL+S8SAiYu58Nhy1PP7oIlr2Xm5or6pEemMfT+/FM
         NoxuyLWk/yQZE0KkErzcKLWDjW5G+Hs22UT4ce/Zs06GpKANggW4wVpOuZQ3/YtWr090
         3xWkzhmpHMpyTbYuMz9WnTEkvE2k/DysusTfC7zwtb3wiU/gCjcWt3v1zHifYYFOqCJF
         WFAUZFZD+Ay7eL40547toej/9FSsv2Lxrh2RFXsf310qd6ZwmGZDXIVIwXdvfEbt2CNp
         fKe3fY1aY3OTntDYb3Qob1xSy4lMELNjVFygzcsMMPZJF/E6JZHA3tyRfBHa6rb03bSa
         tKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041252; x=1708646052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpXI0W6SyqUsN8O3cq60fFq4dAgX1VPZevRlW+M4Y/M=;
        b=gxZOfZ6znpGmrGTiyYYz3949i8HJNWkFXjIcKFRSQ5ItWrKzvvfSNbip9zkEXW9WJb
         RPtBBQfrzXyan+jMxaQdkkMyfGHZU9RJlazE5MXOcJ2K/SYG3af+2wpOM7YLje9e+b6u
         OxXLnZLZ6HnHsF8xMATmrx7mA8YWZBKEfhiN5Zf8XUwnlSKInOKY6dLN2nskZOC+LgeT
         kH+LVdUfd0vuECzM13TF6p5HsiQa3yh9uiliXUiWv901ekmKHrvYF97f3kMJabCaWMhy
         e0Qdwsm7r5nsqnclpXND4LLVU+LP10ouDnGnoInZr3l9XUovcEtEqBx6E3OuP+snR77N
         0M9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXtom+FJrMI/JU+mBaHMIf1xZ0ZFmq4GU81i4SemfPQvcXYk0pF0emMrEodoArZWTQewdf1wYdZFZN8X/7QsVgMx9Rj
X-Gm-Message-State: AOJu0Yz7S7Wq1EJsZ3D+xjdHvLr5v4/+//LapeEMvWLHN/VEvBxKuoJH
	0FGKDSoLTQlWz2dIIl5Dq21N6MLjfOMJXvBcrnijIesI4+3uxawi71BbTR0WClimuCpqrPhLuE9
	/jK0Z77hpgg==
X-Google-Smtp-Source: AGHT+IGZA9+3WHFiYMUlOOAp3pzMgy3+EL2Y42TvoL0DWMZvwKvmW9yoy8cs+q33yE2vXi275sun/QISAhlCzA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:728:b0:dc7:48ce:d17f with SMTP
 id l8-20020a056902072800b00dc748ced17fmr828768ybt.10.1708041251800; Thu, 15
 Feb 2024 15:54:11 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:52 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-2-amoorthy@google.com>
Subject: [PATCH v7 01/14] KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The current description can be read as "atomic -> allowed to sleep,"
when in fact the intended statement is "atomic -> NOT allowed to sleep."
Make that clearer in the docstring.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff588677beb7..46e7b8dbb3d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2959,7 +2959,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
-- 
2.44.0.rc0.258.g7320e95886-goog


