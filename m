Return-Path: <kvm+bounces-69607-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oPtxM3TQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69607-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:26:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 708B1B49C3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C746302BEBF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C4C35C1A0;
	Thu, 29 Jan 2026 21:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YgClsBSQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5D635C1A9
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721941; cv=none; b=Spf/aUhEAMHLx3m1S8EaGF2rrIGdRNMiDFGn0VGHqji4pwKEGr7a++GGKUWHo5X8A6f4YOFCLxjAD7q6mFRlW80j4Qn8XW2taEW97w37hq59wng0YbKSe8JGIeH6t7plw9oHmaZ6NjF2bAYQqIKQ5vrC8c3tMpMNEIZ8+NzwvV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721941; c=relaxed/simple;
	bh=pGh11QoBfatNNPcD3UbRdXhxdT0MMITx2WqEtn8eFss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ex8vHOG4KAEYjx7/D3QJ6QtYSALkdVpwytE/SC5HgXFg8KocQDswG8oyzkbBHkTkgpOc/+tZRoBWS4RoI4n72nrVDLpL8K+emiGAKmYlrgu3hSI7s4JxEq0X4gCynIIfleND2U0hLi0CXlKuJWN7XHhABY1xxaImxD17JzeeP1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YgClsBSQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352ec74a925so2554702a91.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721939; x=1770326739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iXsfpp7fYjSPi1nIw2ScrDnrjqTlWGi7ZArDWIRjDgk=;
        b=YgClsBSQkemOJVm7JMV99ev6GYocZTi+wpSdSxrIQAl42Bql7Vr4oGTqoEtm0Hz9vX
         24FOanK/YWsgGM16o/756RCi/TOKqOzj6j+/XBtzZ6F5BPmRulnQtrHlb2JCAgnW64xI
         wNDMI/jZXzuZhvw5/SCsFa8VhoGxUbJKTZNI+6kQ30ZrMLTCUyccCV5JxCzWHXbKh3JW
         Q2FnBxQj9+z5NNXKrQFB9QPKJiGtxr5vgr5VXI9hJjIvAQXV7wmRW9xO9nrwSm3foyaO
         u23daigvanFsWEXNf1FeMaLkRRSNf4xQ68YAVvzmWfN9o6GimsOztC2hSdEGDi2TCgLu
         3L6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721939; x=1770326739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXsfpp7fYjSPi1nIw2ScrDnrjqTlWGi7ZArDWIRjDgk=;
        b=G385k/YjiJHp3WbvDr4GnLDnC17ulqo/uHAF2qpfZwhQ/0FJKCmZF5kGk/Nym62TJK
         coUhyeW2WygFMwi8pXClzjEyXKpob/lG62mpfsIMx/2zOfRSl8+Is+T01ZBzBWcHQFLA
         +7ktwjrdfZ+lIaO5GdfpuRVvvPcVhFgcrEh7q69Q3Iiwc/z2vREx3Uec43gD+Y/BT0A5
         gBGyiCb51IjbJYfB7u9gABa8ICPkoljqZ0yOESPEJ4MikUVLDMZqdnUkHsK48x7uV1gj
         YSmdrXsPxzKIrwJu56sTPWrOkIFhq+TJPvSHD//AI9XdjDbukoWOfd7jJUmZA1srAdoA
         flLg==
X-Forwarded-Encrypted: i=1; AJvYcCXUmkHASRbknauO5DMDzENixjxPf4poTcqIc4tp+Uw605+wg6okXanazKvvrDK7TPFhGlc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCYa9C1T3am8kUUZMl+k0NZMty1BB+dbOufv0XryIq4CdPRpyq
	d3i4OR+gqtZ7xCjIKanfFjSXj8F7O7NxRftE/TPd98qNTk5q40580NZ2y8deqCDOu36c6c+0cDw
	6koj8th7Jxpw6Gw==
X-Received: from pjyu17.prod.google.com ([2002:a17:90a:e011:b0:353:454:939c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:17c9:b0:353:356c:6840 with SMTP id 98e67ed59e1d1-3543b31688fmr768863a91.14.1769721939368;
 Thu, 29 Jan 2026 13:25:39 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:48 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-2-dmatlack@google.com>
Subject: [PATCH v2 01/22] liveupdate: Export symbols needed by modules
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69607-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 708B1B49C3
X-Rspamd-Action: no action

Export liveupdate_enabled(), liveupdate_register_file_handler(), and
liveupdate_unregister_file_handler(). All of these will be used by
vfio-pci in a subsequent commit, which can be built as a module.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 kernel/liveupdate/luo_core.c | 1 +
 kernel/liveupdate/luo_file.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421..59d7793d9444 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -255,6 +255,7 @@ bool liveupdate_enabled(void)
 {
 	return luo_global.enabled;
 }
+EXPORT_SYMBOL_GPL(liveupdate_enabled);
 
 /**
  * DOC: LUO ioctl Interface
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 35d2a8b1a0df..32759e846bc9 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -872,6 +872,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	luo_session_resume();
 	return err;
 }
+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
 
 /**
  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
@@ -917,3 +918,4 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	liveupdate_test_register(fh);
 	return err;
 }
+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
-- 
2.53.0.rc1.225.gd81095ad13-goog


