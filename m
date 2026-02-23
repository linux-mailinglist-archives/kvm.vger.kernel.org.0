Return-Path: <kvm+bounces-71540-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIr2HwzXnGkJLAQAu9opvQ
	(envelope-from <kvm+bounces-71540-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:39:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F75017E72D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 258B9303138F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3611D37BE7D;
	Mon, 23 Feb 2026 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwpHRBg7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B9037B40C
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771886335; cv=none; b=tPecuqSzDM3A2UJwdQ5GJZrB6gJc2RTjyfhaWwS43ymsAl7AjOF6uoBHr/w++WL3Af0Llp9rnV2QeCtQ3tMnXY5yfgRIwkhmyIT1y2clac/4Fc/fQ+KnWvZKaYlDsWdLFYsN2rMhPUYUeldFYOjG7PII6bLQ42X+YWGKupxcgq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771886335; c=relaxed/simple;
	bh=/bIC/WtvmzO2UMatiyKUHoqyh6+HwZ1czcMSAuZhOrg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=k4xfAJ/x4zWb9C5NWLLYtixQVhIl11lMeWdQ+uBx9vsI8XC2AMrtlTeemLaF/6HacdbxuoZhGMbq5aLPRDd+HFJiKcSdKoRDewJVVQtmACxMF/ePQc4rFdy3ynYfRvQ7DXJMBEj570Z8tHHDU8WQZ0WojWmqGcq0IfYCCMI7j3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwpHRBg7; arc=none smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64ad2a2851cso4038526d50.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 14:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886333; x=1772491133; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t9UtgbHB88uVfe270ruZfCUS90+GzEIoaTA2r5lSx94=;
        b=lwpHRBg7DQuSqJKhz6IZpOGx8oT+9wcRywxUZH2yJU/zJoZ0v6xydpOdmDHbl8ZzMs
         qPR+fPmhkjIpTVVWEQ8cJ+k6dEIhAOEpxSq2HQsuKGymu0Tx3x0MQqm8St58/siWItwN
         Mv0gwF14b/3ZfJcd0e03iorXyH1LStmVRKEeeV8QPyWJfG0cl5WK7qrhowfhudEFP3et
         f8ynJ/BspwfcDsbJgJ+Gvq9MJvWTli/GCgIr2oR31x4ej8PDenv7fT6DwILKmrkr0RGK
         LK0QBgB6HiSgAcetRk1aoodeegow+nOkY8n4zYHc5elaLvEaFQTv89kdcRZkDt8sqJmh
         h7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886333; x=1772491133;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9UtgbHB88uVfe270ruZfCUS90+GzEIoaTA2r5lSx94=;
        b=qO/7BA90gfJufuYd9LarG0oRDv+AxYNtzSEJ3Id4zUY/hcyxiMB30XQB9Ua2LJ3oYt
         dyLk7z9NgR8qvK4F7q/hOWtmcjjXrynR7FOGia5sAN5b/nSsPKYCOiPEQ+s/EpP5O7jR
         8d3fUpJ5xU02Ar1gw0fcjqijj3o45BmhjXvLDbxcN9+6dggJFVBAcl3S2HMtOwf9KfCB
         D1d17OcHAv9uhwaU1mFaACzkiRR5n5XzV8ZMtrHJCYdlS5dFRbtxnz89fvuVsesT6AvM
         e45KKhOsdyIhcKPVmwGbmQ8duMS4OGylWqxtLqcBW4K5Kn9dCrthxFRpNiKBziJiEUqh
         vqhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyrQPQKQCgh2LAvQ+lSLuEYWdHlMuhUrPUeILuiIu82kaCNjNKX15oIfICpBp3oL+EgFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKZEd+8QtbxDJvHAyF0/kBUqhafP+IWgviDQrixyUk8+UFDdWo
	ypyjvWSNGwetP79jWoAOqm3Zo+XJ13WToFh/AaAJZNK2Djbs1QlCGWCt
X-Gm-Gg: ATEYQzyCYI+DTllrqiX/FTtgDCagMHCPkDrCzE0VTPYWq1Pz9+lc9eLfvWFQl7x+7iV
	Phz02SP3gPIw1WkPOdobYrRm953IUeQmj4/aL5og+hOP9ZYNMGGoCk08/cnsT2Bqsr8v00IJhLS
	hh4oCrozrRGhxFyxvVY0QZhtveN+U02CHcqTtpTwZzA5lL70SLhVzJ23xED3fmStHlbzj/ZJBnt
	W3XdWtNxYM1L65P5jVVXTDCbKBTNsAvUkh7+ztTFUQpLRc0U2UvaNL4Hsh7oAe9mefYgHugxUSC
	vz765x8OIS2VRG6bPe7d4B0Gi6ouP0YDAmX0+mgCJahxYAp6hCmsURm9TLNV332KqE6u6y371TO
	JIQECKgo2lD5DTHxh7NPzhOUaB/JS/boJCRFkK3xJbogw6tG8hBXNqFuy+5XwjlkpUMhoHFAewD
	R7JNCmDah0mgRmWUykU6eFQw==
X-Received: by 2002:a05:690e:408:b0:64a:db34:8509 with SMTP id 956f58d0204a3-64c78f6f039mr6063230d50.66.1771886332926;
        Mon, 23 Feb 2026 14:38:52 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:44::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64c7a39bdecsm3726462d50.22.2026.02.23.14.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:52 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH net v3 0/3] vsock: add write-once semantics to
 child_ns_mode
Date: Mon, 23 Feb 2026 14:38:31 -0800
Message-Id: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOjWnGkC/33NTQ7CIBBA4auQWXcM0B+hK+9hXCCdWmIEAwQ1T
 e9uwqoL4/ol31shUXSUYGQrRCouueBhZG3DwC7G3wjdBCMDyeXApThiScHe0Sd8RZcJg7eESrX
 dNKiOuJHQMHhGmt27qmfwlOHSMFhcyiF+6qmImv6iRaBAI+Zry2eptNGnB2VzsOFRuSL3hPpNS
 OQoNHW251PPtdkR27Z9AQT30fz9AAAA
X-Change-ID: 20260217-vsock-ns-write-once-8834d684e0a2
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Bobby Eshleman <bobbyeshleman@meta.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 kuniyu@google.com, ncardwell@google.com, 
 Daan De Meyer <daan.j.demeyer@gmail.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71540-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,google.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vmtest.sh:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,meta.com:mid,meta.com:email]
X-Rspamd-Queue-Id: 4F75017E72D
X-Rspamd-Action: no action

Two administrator processes may race when setting child_ns_mode: one
sets it to "local" and creates a namespace, but another changes it to
"global" in between. The first process ends up with a namespace in the
wrong mode. Make child_ns_mode write-once so that a namespace manager
can set it once, check the value, and be guaranteed it won't change
before creating its namespaces. Writing a different value after the
first write returns -EBUSY.

One patch for the implementation, one for docs, and one for tests.

---
Changes in v3:
- Simplify code be reverting approach of using only a single variable to
  represent both lock state and child_ns_mode state. Instead, use
  child_ns_mode and child_ns_mode_locked.
- Update documentation to clarify the value-dependent behavior of
  child_ns_mode writes (that is, same value is ok, different value gets
  -EBUSY).
- fixed some line length > 80 checkpatch issues in vmtest.sh
- Link to v2: https://lore.kernel.org/r/20260218-vsock-ns-write-once-v2-0-19e4c50d509a@meta.com

Changes in v2:
- break docs, tests, and implementation into separate patches
- clarify commit message
- only use child_ns_mode, do not add additional child_ns_mode_locked
  variable
- add documentation to Documentation/
- Link to v1: https://lore.kernel.org/r/20260217-vsock-ns-write-once-v1-1-a1fb30f289a9@meta.com

---
Bobby Eshleman (3):
      selftests/vsock: change tests to respect write-once child ns mode
      vsock: lock down child_ns_mode as write-once
      vsock: document write-once behavior of the child_ns_mode sysctl

 Documentation/admin-guide/sysctl/net.rst |  3 +++
 include/net/af_vsock.h                   | 13 ++++++++--
 include/net/netns/vsock.h                |  3 +++
 net/vmw_vsock/af_vsock.c                 | 15 ++++++++----
 tools/testing/selftests/vsock/vmtest.sh  | 41 ++++++++++++++++----------------
 5 files changed, 48 insertions(+), 27 deletions(-)
---
base-commit: ccd8e87748ad083047d6c8544c5809b7f96cc8df
change-id: 20260217-vsock-ns-write-once-8834d684e0a2

Best regards,
-- 
Bobby Eshleman <bobbyeshleman@meta.com>


