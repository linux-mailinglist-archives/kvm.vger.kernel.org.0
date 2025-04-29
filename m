Return-Path: <kvm+bounces-44811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B5DAA127A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0C411BA3FC6
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E95F251798;
	Tue, 29 Apr 2025 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="biT+Ta/N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CD424A07B
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945558; cv=none; b=tzooDhgM8UQmvYaxcPWVn4x1NZXX6WEXAWigGrYbigLZfyFy2YSVVjaOq1/ZA6j0G0kbzD7sz7L4vMEgFFwwxY2yVn+jGBFQbiUV59V77LQPEOJppHm/3qlGqQGk7bWQaxY/jid6HSTjs5QyccgXzyehe2OR1q+Wr2lkNN9DSYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945558; c=relaxed/simple;
	bh=9/DyTaXRRRhmMtYj7n0VE2ZpY/dcBTLDTDYYO1pk/Ks=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Qkb0tNMdBOJ08rWRsVXF3+t79Egac4mEGwZqzXzUVuW/abFxbfEkkhi9CwuNAKkpo7EGBylg4FFbJNMTSdI+NeLsSiy+4ddKizmoFRDtgeaXq2g79rxE7TV+DLs2BXezoD5ENd8Q3Eh1219Hc1cPDmM8xSbkST45E4iyEhKg0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=biT+Ta/N; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22647ff3cf5so46503365ad.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 09:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745945556; x=1746550356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9/DyTaXRRRhmMtYj7n0VE2ZpY/dcBTLDTDYYO1pk/Ks=;
        b=biT+Ta/NIhhq59VVxrszBNMy57vHcDctJN8ACrHPcI5+krqhLahkm6SdKkA/jnHuQz
         zOHWWbhPOCXQQcHQ3NmHyxQSNjg/9wNaJmKROe7EPnUOfMaCAJWVCnfuFynCUNKleZo9
         ni0wl2GZmJFh4yslLJR5V//hZIkD/ytn9SfMIjxQ+JDm/IPOj6MHq2QX6AlAP2Shs2+2
         RYR7iilsQ7AksezOr4uyKbwLRpXyUP19q7+SEx9p4L64gN/7pDU6vrFIJJ7+Octr9Erp
         1nsN8qP79WHSIfZ+xxDO/Tcr9b1wfqGak3/ts9rHGLoNkVMzPkuDUaQwy/Jh+YrTCZNZ
         iqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745945556; x=1746550356;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/DyTaXRRRhmMtYj7n0VE2ZpY/dcBTLDTDYYO1pk/Ks=;
        b=uyWuXBozwfBBnA5BDMAIjCCvmp+dtEdK2hi1xbmOmTTLQs6CPmlsdl73kLqR++aKMl
         +AeiNzYflcjBojSM9m09aIO9k8t02M2L7S8FPecPlbx4jM3t7L/H3TuyyQqegGQoiitl
         uRgvpf57v6ENRIbTT92LPtopDyTM4WFBHPJLJbcymP5BsVfgFnQNKcj+4XXDwLvyWfXa
         nx9bEZOZkEvsv2boAS6wOuXpixDXeZgYSJHg8i7/6Hr5WpRu6D8PNwLCv6JN9ahQx9NZ
         tVQOfn2pYarNGGopNBqlarXG3RnVYVkUmAdQ8JofJX/4FyTAOJ4lbnGIK6NG5beo4ZQw
         ZDpA==
X-Gm-Message-State: AOJu0YzGU2RuJ/9Y6p4+ndlZ5AT7dfrEeVrdW49UcsRVijg40pAPNiFV
	/DHc9TFVauoxlSfK+vpY1IHwtAWla75E3lzSlnqq7VknXOZASo2346avcitcnOyFsyY6VxRvVAU
	ZWw==
X-Google-Smtp-Source: AGHT+IFEE6LO1G7pamWoVl2A8JQIOWisDuS/kml2oFH5sEgf3g81yBC6JuYkTpidKh/jeQ32pw+x5WUisOE=
X-Received: from pjbsy12.prod.google.com ([2002:a17:90b:2d0c:b0:2fc:1158:9fe5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568c:b0:2ee:d433:7c50
 with SMTP id 98e67ed59e1d1-30a23e262eamr3924343a91.23.1745945556371; Tue, 29
 Apr 2025 09:52:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Apr 2025 09:52:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.901.g37484f566f-goog
Message-ID: <20250429165227.153943-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.04.30 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, roypat@amazon.co.uk, kalyazin@amazon.com, 
	Fuad Tabba <tabba@google.com>, Vishal Annapurve <vannapurve@google.com>, david@redhat.com
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled this week, as I managed to pick up a conflict (at 6am...).

Future Schedule
May 7th - guest_memfd initiated private/shared conversions (tenative)

