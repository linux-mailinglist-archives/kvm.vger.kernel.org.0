Return-Path: <kvm+bounces-66643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC90CDAE3E
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:15:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 731D8309E859
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB521DEFE9;
	Wed, 24 Dec 2025 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5I8Lz06";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f842CBe8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93419F11B
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766535187; cv=none; b=Lk9/7TJsO1fKvW+tA9HlOPSeHRHXW5TKYy8Qik+ZdhrF3Ff0NEt0k6ktInSXwzJkSIQiR2Rh4DVsawQSLEXjxZQXPfmFNlx+Tmj1RPl6Y2GSCNZhQ6VcN2SOJM4LZkmk7p+/FThBnlucOBFVjM3UF6mI84Qrek64gNddqkpvh+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766535187; c=relaxed/simple;
	bh=SQq0xvlgLSlIPAWcmiIlljgsmEpAuxpfwdJTBKdBhbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfuJrfvhyx7AYmB9R7TiN18jPgAr9b9jU+IBqt0NkUhLdmpEsy+4F7LdlllwUwDdFDO0O2C/GuPpNQJMBhvRFw3CGKFJ11lDXr43ZlQfEjWene96s1UkrTHzRdXYW/6FtjwgY21Nqtg76DTZqqJiDbchiPwK1P7WIZCwVu+1ZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5I8Lz06; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f842CBe8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766535184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tbY7FjbkAYn7FXUAG1r0LIGkyPozJ/Pd3cYf6WyIfHY=;
	b=g5I8Lz06ogiq5B9J1XiF8cqoiO7FpscwULQV2ehOKjG/gsdxFbb8nnIkEN4CZ1uQ5rSgmi
	C6akOZOcpnEXovXacc6/hOKz1dkXQ6drvj+JQKrhV6x3LYqSwzh0rrsm6hIhPjNgg/L6wU
	LsoGDP3BygtrtKhulvR1jAXXa4hnTpM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-fMPXYF7OOAq_RhnrrR77IQ-1; Tue, 23 Dec 2025 19:13:03 -0500
X-MC-Unique: fMPXYF7OOAq_RhnrrR77IQ-1
X-Mimecast-MFC-AGG-ID: fMPXYF7OOAq_RhnrrR77IQ_1766535182
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477563e531cso36991945e9.1
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766535182; x=1767139982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbY7FjbkAYn7FXUAG1r0LIGkyPozJ/Pd3cYf6WyIfHY=;
        b=f842CBe8quZggRukNgdYJ7Z/b5mt+7+uJpX0QJZp0fnwBertEVX/x5ZHyGOk2EgJUL
         49x9APUX8uRDg46azXZ71QbTEH26fZwnubQcZHIqM8Av/8TdvttXelYpip9K0XFD/vkI
         U5C7S/QvGSNzigeNChKPjnIW31G4EKCOMoQW9Z4GsAmQYBkXvv4z1+g5mZspcWdkRpL2
         qepNoYZNB6bnEnCXymos2DMp50EJ4wd+bH+6Ge5rvaApoj4+ikgjLwclUk+GFsYQQA3Q
         +cOEf1WT/yOqGeTWCCcZZtKYaOyVDkDe5yCJCOO0v/Eh7ryzxmAYy3A7SnVOq/MRKW66
         cpLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535182; x=1767139982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tbY7FjbkAYn7FXUAG1r0LIGkyPozJ/Pd3cYf6WyIfHY=;
        b=YcbgHEpcFhJS2w/1LGznocI5HMU5yUHy7MMFuNvQ0gbGsdfxNch0pOOpvrU3Bo7EeB
         6T4iIjHbPskMbv7KF7RBgtkSC0Ai5BZqNNDuAQRTYnyl7yUv5g0570qWcRHyk3122hdR
         wx6rfY8gLaGWWWuSZ6Bd6E5MGuoigGn+ySQ7eA9KidER0PJvyzBGFfeNlXzXmK3bb8yd
         34nttRpviqEzEnYTZcsP3pNydESqTZrZgoctJXvhGPASKoTIizqYvI1tgIEaS5URwF45
         DPhrLGFjWD/NduMqF0ZUdTI10gOEWIHa5SjFmV12vbUOrN5hKZkOMg/IR68yZMki36Ah
         5yWA==
X-Forwarded-Encrypted: i=1; AJvYcCVqiYmhG5TPrfEhswiTxH/x/AXWiRmJgXp7sJ3yYXINiZuPAtMhEQ152rTO2nPfHeYvZW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6G4YZTt+qItyg7hjkZWWYTR2SxH4jqvb3usSR5oYspBsHyym5
	9hfgJqhDxxBS6Y4ib6i0hWJ+Ylu/ZTzRIsNHDVvuWlAGJ92d4/wMvTA09/i7wTEddDvnyXxzY6H
	UaNggy5xSshWePOqxdaV4uhRA5j1gs5h65GnzorPvoQDtgO6OdcZjwQ==
X-Gm-Gg: AY/fxX4eXujK6Ox94pFM7c/6y9IEcyddsX5hcJOY/1bU2T0VJfESrlstSOPT5KrKUSj
	ObehB3XfK6aRmzA2tXVcQ171HvNwAGXIafxu0DCkML9v2xqrhwhaBkwNB4nsKFOF2iHC+TEQgsQ
	xkawrHJPykKzBH+bXUwxG06skYq1EwfuZuUCLlrhS/toirk7aQzTOpHX4hhDZFuYwVOtmZYzK5l
	0z5C1VXkEAo3ATi453LjO770ncWgS0GoKcm+VUtSkzQ3HfMAfBQs3joWxNgGcThqN6vUESl9vPg
	H0OIYwJZ9TyDu/hLoMMUuriue8QZ6BXTYLfNGk7zEoYtyV2DOSVfyneJ8JFRch+y6MEOCANcbEx
	ubjxiDl5Z909ZxxFNgcCHvnwl+W00ozeFuZ/VOPMCFV69WAfNonZDRqQKXLLxzOMhJ9V9UgBQ/p
	MSA9oEkPWfPx/Jat8=
X-Received: by 2002:a05:600c:6096:b0:479:3a88:de5f with SMTP id 5b1f17b1804b1-47d1959d6eemr161813725e9.36.1766535181979;
        Tue, 23 Dec 2025 16:13:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFcVvVQCTcvc4gpZOC/BTSrK/9Og8bNsbt/fF1seFkODFGvEa5bqxZbDem6cTMnGnwjd+SYw==
X-Received: by 2002:a05:600c:6096:b0:479:3a88:de5f with SMTP id 5b1f17b1804b1-47d1959d6eemr161813625e9.36.1766535181572;
        Tue, 23 Dec 2025 16:13:01 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3aa8fd9sm123107605e9.10.2025.12.23.16.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:13:00 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org
Subject: [PATCH 4/5] selftests, kvm: try getting XFD and XSAVE state out of sync
Date: Wed, 24 Dec 2025 01:12:48 +0100
Message-ID: <20251224001249.1041934-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251224001249.1041934-1-pbonzini@redhat.com>
References: <20251224001249.1041934-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The host is allowed to set FPU state that includes a disabled
xstate component.  Check that this does not cause bad effects.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 25 +++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index dd980cdac5df..5222ec6f71d3 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -142,7 +142,16 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_SYNC(3);
 	/* Check save/restore when trap to userspace */
 	__tileloadd(tiledata);
+
 	GUEST_SYNC(4);
+	/* xfd=0x40000, disable amx tiledata */
+	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
+
+	GUEST_SYNC(5);
+	/* host tries setting tiledata while guest XFD is set */
+	GUEST_SYNC(6);
+
+	wrmsr(MSR_IA32_XFD, 0);
 	__tilerelease();
 	GUEST_SYNC(10);
 	/*
@@ -202,6 +211,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_x86_state *state;
+	struct kvm_x86_state *tile_state = NULL;
 	int xsave_restore_size;
 	vm_vaddr_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
@@ -259,6 +269,7 @@ int main(int argc, char *argv[])
 			case 1:
 			case 2:
 			case 3:
+			case 6:
 			case 10:
 			case 11:
 			case 12:
@@ -267,8 +278,7 @@ int main(int argc, char *argv[])
 				break;
 			case 4:
 			case 15:
-				fprintf(stderr,
-				"GUEST_SYNC(%ld), check save/restore status\n", uc.args[1]);
+				fprintf(stderr, "GUEST_SYNC(%ld), check save/restore status\n", uc.args[1]);
 
 				/* Compacted mode, get amx offset by xsave area
 				 * size subtract 8K amx size.
@@ -280,8 +290,17 @@ int main(int argc, char *argv[])
 				/* Only check TMM0 register, 1 tile */
 				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
 				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
-				kvm_x86_state_cleanup(state);
+				if (uc.args[1] == 4)
+					tile_state = state;
+				else
+					kvm_x86_state_cleanup(state);
 				break;
+			case 5:
+				fprintf(stderr, "GUEST_SYNC(%ld), before KVM_SET_XSAVE\n", uc.args[1]);
+				vcpu_xsave_set(vcpu, tile_state->xsave);
+				fprintf(stderr, "GUEST_SYNC(%ld), after KVM_SET_XSAVE\n", uc.args[1]);
+				/* do not restore full state */
+				continue;
 			case 14:
 				fprintf(stderr,
 				"GUEST_SYNC(%ld), #NM exception and enable amx\n", uc.args[1]);
-- 
2.52.0


