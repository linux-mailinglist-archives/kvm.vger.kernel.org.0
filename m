Return-Path: <kvm+bounces-71634-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOVZHhbknWnpSQQAu9opvQ
	(envelope-from <kvm+bounces-71634-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:47:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E429418AB48
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 555B6304414D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A773939E195;
	Tue, 24 Feb 2026 17:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApY/6uMe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tTmnQ4Db"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ECA265621
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955212; cv=none; b=mVKhg6WndwhvE12wNqrYGRucv+fh9N7bnFSHgO+vbdRWLXZPAF1/COC4mI67Q+EEBh29BnzjZDbVG/h8IV0G4qpjFDtz/I6H47U+j3omtKZgiHFGR3Yv/bXI0Va8qnRFI9cZmBozOnhAsXMgoPwsuJMNjgZ+3ksAj7SS35SuiDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955212; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quhSGqrB1wOyxcEw+vNPboZl9UQh4LcVvWVFgwbyFvZGnt7uK0VZ6bBM0cOQuCQV9jFPi+Ok3WVwpHnQ3TlUJJHjXGxylJDEXipWQZNGa12N2rMbGHIp+NY0MHD18rFip2z5m7F4rKkL29s8l/yp/w9ye83O04+RgL7rSRZjr7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ApY/6uMe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tTmnQ4Db; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771955210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=ApY/6uMeidkF7cUvHDhK2M1qV+qmKfkVUv11eKqui5uIDUzezak4KSgNr0M36cOv8Fn94B
	9Iy8krvPXTuqf4J+zaw1fpvTxaHKjInyrJiUBhWxBuDOcn2f5dKh4EW8W2RtK0teB1+Mhy
	K0Wegu13t+U6XKLcU54iqXcx5ReBSaI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-gU7fRPaNOumGXsYDXid97A-1; Tue, 24 Feb 2026 12:46:49 -0500
X-MC-Unique: gU7fRPaNOumGXsYDXid97A-1
X-Mimecast-MFC-AGG-ID: gU7fRPaNOumGXsYDXid97A_1771955208
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-483a24db6ecso61301945e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771955208; x=1772560008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=tTmnQ4Dbyfmr6NnB5H8CPuPm3TslUuvElFAJ2Ff3neBS6OqfuzC8Qlvq/iBB2/RFUJ
         t1NF0FLH8j+BmK+Xp+O3cmCfBUKtxrOuWcGusQOEmeBKyHoHI2BoZUMe+SpxHDLNWG8/
         vQcWIKHUMFzb1sZ4HpwUlQSGwbjv2rSA8jnGKdfGm29xEpJCPE4obSP14F2OewQwxoPd
         BCi2MsJL0ncOM27nnhkSy7/w5i4q/Kh7QHCh/Sj+FGL2rVs59wMppByJ6+DKVTvVPlKB
         f7UytwWKvg48ypQuWkr+kN3qsVkKbKQAWCSwC5lC50NqKNY0CpYCdR171k6vdcZk20lT
         AzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771955208; x=1772560008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=bIJiC67WZZ8ID1/4Z8CVkeO4s3JqTIydnJEVK/ac/hcTaJ4k+gU3kB9i8EGEZ6f00I
         CzuNaBkwC34Bwa15eTfYxNX85qu4Vlb6mCdsd4hcvEbzfRlLIFv1JmZD3bhnBTNB3MWr
         rkUXrrRSHaYYkUsPtaBRQT2attKeX+cwQJwxjIau63xAX3+QSyhw1w7bFDT4/5IacfkU
         cKRoRcIEHGOXLQILsBHCfeBR0+lkXyxm6ID7V+ItJ/G7Ugc6DVjOHQASgwxMk36w8Yph
         WevTOcap/zaPuMXU+Cc3DqRQgpDu80MiU8ArmsFReEjvWiJ9ShOO21vfePr19e1mzEM2
         TdHg==
X-Forwarded-Encrypted: i=1; AJvYcCVUZm5p7YdiWsMJRi+YOibsSKFyJq8J82elTzvzpLkoAxQYkSKvtiqUPy2NJ8a4LR+GbwY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHXbb0o8dJf/FJ5ra+jeTkqduzXOVMng8yFImjL1ymckUvi40Y
	ki+UDp81hbdeKzPNsO4Pk/GCyRVf+XSyJPjMYAc3Lveqt4PJbS2ElBa37fcJilN4jbGlah9rqfb
	7kroCRUBCxSDtlEKEH+pzlRbhens6dfGxro0j5JoAI58PXX5aYD5vJw==
X-Gm-Gg: AZuq6aLuJMlchPoms3H1ZaCz/TR68uhjEEe30LfH7Wc+EoPrnARzcXoY4sjmGEWqrF9
	T363Uj1UA/c4J6dUVlo3TNd3BvPYasKDCBjq+DXFP6jXBfxA4NbwD5qrplnhrTBORXiQ4D1RDpW
	kLjvXm9MJLXBuQKRrDckf/gUfw/DmsZABW0kcIBF0Jl4I4z1D4oSi2bWnQxBFNjDeHJTwA6oM8O
	ZxCqVepbr9dHyEJjxgTMebr2D0OAvKrMzbwtfaQbzBcbCv+Am7CUWg2g+AqyvR7YKiq8OQ1Mh13
	qDtXbiNN7pQDYU9UOIQGzwvl8UU6jkFf4ybK5nq8rCZeem3MeDuiAQqAUefPvIqzz6d97+NYTi+
	0ZVdgjtIcv9+Ijjt/aFGIsAGRg4nEZxjesys/cNG/0yv8aUMtqtkZuVB+4c4456tVd2ZDRjEioq
	/+4y/2csvvMVeZMTKgmDd17YkueAg=
X-Received: by 2002:a05:600c:5020:b0:47e:e2ec:995b with SMTP id 5b1f17b1804b1-483a95fb29cmr250743895e9.9.1771955208029;
        Tue, 24 Feb 2026 09:46:48 -0800 (PST)
X-Received: by 2002:a05:600c:5020:b0:47e:e2ec:995b with SMTP id 5b1f17b1804b1-483a95fb29cmr250743555e9.9.1771955207645;
        Tue, 24 Feb 2026 09:46:47 -0800 (PST)
Received: from [192.168.10.48] ([151.95.144.138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483beb3878esm260775e9.18.2026.02.24.09.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 09:46:47 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] accel/kvm: Don't clear pending #SMI in kvm_get_vcpu_events
Date: Tue, 24 Feb 2026 18:46:26 +0100
Message-ID: <20260224174626.107781-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223221908.361456-1-mlevitsk@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71634-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	SINGLE_SHORT_PART(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E429418AB48
X-Rspamd-Action: no action

Queued, thanks.

Paolo


