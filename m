Return-Path: <kvm+bounces-33807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFE09F1BCA
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F1787A03F3
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263351AF0CB;
	Sat, 14 Dec 2024 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bij5tzJK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810AC19FA7C
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138473; cv=none; b=NzkH+ipqf6M91L6z1w3TriBElwyC1Rw6THKGqr22a1GT6ojBCfBXBq7UhjzxmXmBkCLtbMvj0xGcRMlfv7GIf4huUlOY+3CK5K4UFwEiXfb/Jwz36v4lxa6AAmm2M3uteQxTjfNRlVP2xZzds+7ok+Gzn6eBfy8PRNHTmmMaPsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138473; c=relaxed/simple;
	bh=9MuurmYA9iq2LDQ2mxAkARGTen0azUhe64tjUM5enDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TzfwqcP67Jr6d1rBno/ewV1YFZmWaLnI9mQPWU/uitxYd82792lQcZHIprvZtC7CFiW1/CQCYx9+aYa9tlxTh5OT5mSEYVTxVXzHzWOSmiYI7MsJlbx/gbZgqpcyjm4bvvOqbIpgRh68/VEZ0JPVSUhs8ivvsopPqhkRe0EVuRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bij5tzJK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7f8b37ede6bso2553123a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138470; x=1734743270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aODg1HUrgqSkB9GJzL0iLaYYCcyPgozuZpHxFrW0940=;
        b=bij5tzJKP93JCUpE4eH2M7jy00dkTbHT5R/1v1wRhqrGSIfDDzBJXkLFuG4P/rjvya
         lZRn35KdNUK5dIQg1YlE2Ibegg+07TWeNOdT7z2FgnCr7nF4YPg6TMDMIk3pbBBGRqeo
         mhEZr/0qhEmktZy52Rx0PDnJ03kGkWfebvhNbpVzTZazO7wXjjKybheDVu/zGx8xjQgX
         hC3Hix2hPXRnfvdj3yNuhMqMjH4y6sdckgCQYwiqKb1+VDPzFp4U3SNnurczT9JGgW5B
         vBqe3Hx8Z+c9dv3VPBCp7gkWDZdUCIwJprLEJ5rnmbkddgLKACQRzgt6k08fhPuqIA44
         A++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138470; x=1734743270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aODg1HUrgqSkB9GJzL0iLaYYCcyPgozuZpHxFrW0940=;
        b=CtNB0UlFxrv3OXjXYqv+8Q7zrrY/7saY0XtJdKROX2v00LhmFkVuvk6s3MpAFYIatY
         1AZSnmNMuGzQ+E1957PxvyMCvYomTlV8ZT3fi552UP8/6X79fkFW1L24TixYDlXfRRjC
         BP0XXWC3jfYMzICOFbnxU9sPSDIM305jj+Z+nCkuKaC7WLEf/19KYnwlhlAxjh657B4r
         REhY0rJZ2soYeXDVKaMtcWtMHg5j2mj8T7Ji3Md0Gai7JBCv/ynyZl8MAdt512YLkbpO
         J3DC4r3BbOYeEEjih1Jcv2EPp21EsifbjYkI64vPuUUxlkwQ70PNYnaubdkNIALFhfB0
         HNEg==
X-Gm-Message-State: AOJu0YxJvJccngWSIcVs2Bb8dwk8wntVW9ud1/v7GQPJ9R7tvF6sCzxr
	OWvMKWimBt7GqjCWHIoAbT6TBGsDHowzwsU2CHElvP5MvlN83xsHO3CwTnvIe59BYSASQiFgu+n
	2lg==
X-Google-Smtp-Source: AGHT+IEVD/Y7FXciDQf4D6/qqct1VpWHqA1Sl9Mi4Dpk2L8jDoPr27DKPwgTnmxBz1qbfJxMcCuqPjOJvVg=
X-Received: from pjbsy3.prod.google.com ([2002:a17:90b:2d03:b0:2ef:8d43:14d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d44d:b0:2ee:7870:8835
 with SMTP id 98e67ed59e1d1-2f2901b548dmr7699775a91.33.1734138470050; Fri, 13
 Dec 2024 17:07:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:16 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-16-seanjc@google.com>
Subject: [PATCH 15/20] KVM: sefltests: Verify value of dirty_log_test last
 page isn't bogus
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a sanity check that a completely garbage value wasn't written to
the last dirty page in the ring, e.g. that it doesn't contain the *next*
iteration's value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3a4e411353d7..500257b712e3 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -514,8 +514,9 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 				 * last page's iteration), as the value to be
 				 * written may be cached in a CPU register.
 				 */
-				if (page == dirty_ring_last_page ||
-				    page == dirty_ring_prev_iteration_last_page)
+				if ((page == dirty_ring_last_page ||
+				     page == dirty_ring_prev_iteration_last_page) &&
+				    val < iteration)
 					continue;
 			} else if (!val && iteration == 1 && bmap0_dirty) {
 				/*
-- 
2.47.1.613.gc27f4b7a9f-goog


