Return-Path: <kvm+bounces-71381-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EA1VOKWul2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71381-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:45:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A556163F70
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 093AA303BA7D
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C0429BDB5;
	Fri, 20 Feb 2026 00:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dRvlaZ23"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9065A2773C6
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548174; cv=none; b=R5tBEAyEeoqxcvrotSO5zP/bCmFampQhUs94Vve53Og8ZBNVC2kCUklVfW5ZFgtYCj148hk62BNdZIGKgCkJp2LNckWLyDNhz2xMknVtQgcb0FwYphLM/MSDANbnaYpb7S3xuiICxm4MkMGTbHdcjAzQ6/LLjJPbldnCvfOW844=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548174; c=relaxed/simple;
	bh=JTfAAOI5NFSnyVDX0VArNQcIEUpjnwvy4yTPQS3Whcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+55HxoELw+y0rzXIT7Ztc2UX6ljyLoA3DbusmY3FYbVFS0ks8CjKNA0Zjuw7Ciyv5gsJGp7kFKbrUHZGQd3c5ffXCmRaaylTWGiztE0wrpA5I9oB3rB1cPyaeq9SFsxD+E+LAdc8yQw/2SsFFPd57KQHIqEw1oOa8M9Isrfuzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dRvlaZ23; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7b7f04a11so91418605ad.3
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548170; x=1772152970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEeICHjtMij91JM5H//TSYr8sTPe1JzhDMQCFWqYwXE=;
        b=dRvlaZ23L/Xtn3C/W0HLpSFt70AmFdrC/+prYjHpPTOm11jonckqfGVdTWYemF0jvN
         CFU1eVFLgOADdXCtlAP+np+rlDjUnphA8LmUr/grrYob9wat4BzDylRbSFfScDShm0Mt
         P0KbjoQLXRS6JBVNEMdczNQuPwcCNbm9wg5UhOLoFcJ4JDJO9eymaGpeKkkSmv4KbUEG
         ARz/P3MM4cUWUnj54Oaw0G5A4De0TzRU+n65fe0ndAsY6V4R8L1DVvGjbTzgi0d74rJX
         kF+eWhduYtS5Gz1jnnjWveGOoqlBNVe91DBPZHpQ15to6uHt3rVngdOmjATZZaV/v+Xg
         i+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548170; x=1772152970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEeICHjtMij91JM5H//TSYr8sTPe1JzhDMQCFWqYwXE=;
        b=RY8OzG0D39ycKWvccOcsX6XoIK0GYdTnKqRlZ2wV1DnJllKjd8atKAhzZ0AmTdJtqf
         /ZVlDfz/UCWhdwafOCqdjYUn4jAZApNe52vcIlX0ASvjwNc1AooEd45O5E2HbkIKJ9T9
         1Ft/Y1Qg5toTaE1iDlCOXzF5HdKOzoTvvVm4npp9NuO4GIs4jySpocDn2iSLQr3+YAAc
         0hWLzKx2DZx/xuVt5+R/SeknYb8vugOxN/N07HAbY4H71IeMgGAnC9gLE7CMxJtQwFyp
         LnUIhYZrIdK0Et+zT3/qEf27y1Si0oO2fdZWq9uJJPc9zdWRXtAQiI0SPfcYPiwooW44
         UxjA==
X-Forwarded-Encrypted: i=1; AJvYcCUwBkI0mZdpSKjaPrVoQ6hSYDnoF4QkiJS/GACbdqFiAZ5LjwC/b0yjDG++Qfm8nCV64O0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBJnSbVL0+5bJ1/y69ZMzuoIw4hwByRtT9pk3mvfs+A1PB9nI3
	JhA+T4cueDF8ijGNVT3RxMC6GifL07qDBxEodMGnEUgAQ8xWrj28zlQN5WcpGDVQnKpSnf4uBLv
	Q5dZg8LPnnxX+dw==
X-Received: from pgja7.prod.google.com ([2002:a63:cd47:0:b0:c6e:28c3:dd4c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:493:b0:394:6208:6626 with SMTP id adf61e73a8af0-394fc2555e0mr6371053637.20.1771548169297;
 Thu, 19 Feb 2026 16:42:49 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:22 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-10-dmatlack@google.com>
Subject: [PATCH v2 09/10] KVM: selftests: Use s16 instead of int16_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71381-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,redhat.com,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,checkpatch.pl:url]
X-Rspamd-Queue-Id: 5A556163F70
X-Rspamd-Action: no action

Use s16 instead of int16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int16_t/s16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/guest_sprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index 8d60aa81e27e..2a3ab9c168f0 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -288,7 +288,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		else if (qualifier == 'h') {
 			num = (u16)va_arg(args, int);
 			if (flags & SIGN)
-				num = (int16_t)num;
+				num = (s16)num;
 		} else if (flags & SIGN)
 			num = va_arg(args, int);
 		else
-- 
2.53.0.414.gf7e9f6c205-goog


