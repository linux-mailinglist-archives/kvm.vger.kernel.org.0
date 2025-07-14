Return-Path: <kvm+bounces-52259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50265B03499
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 04:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A67C6173ED9
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 02:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459051DE4F3;
	Mon, 14 Jul 2025 02:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QJPqD/lS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B967E7262A
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752461083; cv=none; b=RVI6pJyL2Kox7pb531HMwkYtlQvg7G8FVdtMPLdwwQ1gpmkAgzotGSErmMVnOsMw14VikAsYpZF+rE3J7G+rOvh0q8nBuvi8P5gqiBwps8uBs2zsD13BCg/9iTFFJi0OdznjrfCU0TPQFeXKEXC8WjzBXjozcxTdHpSMb/4SOM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752461083; c=relaxed/simple;
	bh=woqpO3NRbjhHBU4xUE1MFG1XPmmi0HP0qmLRNxoUwpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiIkhNKwuSlYlL5svijKawCsTYn9cXb7Tk4SIXEY6oJXlRx8K1kpMZ0sZSGbj68KBTH65IzJmIH33NEljiR0lXPBrFb8qd1JxRtUxG/9LWoEj0gp3oqG5LEtl6LyrYjENtLjCd75yGO2XLrg37qknTlE+Fq2f9LTweP6b8Xz1MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QJPqD/lS; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23602481460so35325605ad.0
        for <kvm@vger.kernel.org>; Sun, 13 Jul 2025 19:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752461081; x=1753065881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGnDLyzoK1hk6QcZEHX4yplSrEzwZbOUE/lD+OVxxOo=;
        b=QJPqD/lSzuaCQxFW6bVir/fstzj/7y39TTmNX7Zkh03BiE2mUquJDD3ZEOMb+uuNBU
         HnRlSzDiTiBudOPZdP4Nn2ke8f1sSeYT296S28EzeodATLrlDcjc/MncsQSEcr0oJwvH
         f8Lkqih7H37AUaYwPFuTwnmLKx5kavXJqcDnmClb5ex6msiHzPOkzFBKBffrYnkafB93
         0odF8UXAXvYw7IBfxSFBx1I5jAaIoDvKaUMG5d3VMwh0fZ3G4SJwg3BSY9LagKsn6eCa
         ct6UCvXfrRkoyQNcmgPf/yezWj7W/sUD/2Wk63+l7KH+nVAzR63Am0QbJX/MRdAfZBUA
         P8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752461081; x=1753065881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGnDLyzoK1hk6QcZEHX4yplSrEzwZbOUE/lD+OVxxOo=;
        b=eOYMD4q5XtAlnMzuQXf/hB/No9ys9A3p2ocwXp0Kge+Z/Gr+b93mP9+U9FIPeQDnMm
         +nx21Co16U/U7v8yu9wP00wzZmWg81BUepy4gb9N7JErMBRwhbl7GBnUjozhiBZSJZLv
         zw2w1cXa4638WGWytTPaflwtkGu72ezjzCF7LTw80VSRkOTt91ocRqFbaLQfZDrhZaao
         oRuFmvBBvC17CHyizSKfLHxLIL2AImJWXBDd+dumbegI4Nzdr7jzazKjYJxXyMTKRuI2
         14olyBA9G4Yn3vrGTJWVlu3yoOuuQJsMDrnSguEU8PzPKQrYsgrZcD5IJF3Zsv544YOk
         MdOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6Ql9PyuVyWealQCff3WKHqetu+/dM9/QbCcW+O8Jq0zL46EfbaIK6UpyD7mPXTe3aC/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOOqcp9Kf+HK2XDZgu3+W+EikDa197Ijhjh4ej1rF/PYFGGJqH
	679EChbwqSBJLo8gTjk85Dh4hu6p7/psg27lMO78cVPczXquHGwSK2ESeO1YVCLb9WQ=
X-Gm-Gg: ASbGncuKw992PD1Q/+UbqqYqGSNkXvc0JXH48Tsu+AuQrX5jS0XRCkjtP935yYjw3P3
	2Eoxb4pRIFQtozGTNG81rDi3xfWoxMaObaQISXaLDF4zOPvfP1xtVRWDxMIECVjrIsvJk5Zo48W
	d3KPWnGKAfWsrCz9LvQ8G4zmmOi4+DUMC+K0RL9SQIndVERhlLG4nzV8WQsRNg6TDx9m747CWtj
	oiBsUWW01MHvQTDJWkANzfmfLpjHUH2Kb2w14aIsVBN+v6XCouHvC3SlzrGpbdHNH8N9mbbsZOZ
	6uf0/oQlWkAWGrNXV05SH59OWXLG5EMMGvS7v42GHH4TFqKceMhiDs6qXZUtwiVpg117cPhGtfO
	Z6M98R/NXS5cqUBMld5gTGDoyEBrPnfVnSKuFF9qo4izk2V1XYg==
X-Google-Smtp-Source: AGHT+IG2a3ZcNn/X49Q30mvFsGR46F/NachCN13vl0w9s5ICMWR61xTnTwucl1IEoa++sqdOjScs+w==
X-Received: by 2002:a17:902:f70d:b0:234:a139:1206 with SMTP id d9443c01a7336-23df093ca68mr146385185ad.40.1752461080974;
        Sun, 13 Jul 2025 19:44:40 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4323daesm82683445ad.139.2025.07.13.19.44.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Jul 2025 19:44:40 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Mon, 14 Jul 2025 10:44:33 +0800
Message-ID: <20250714024433.14441-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250711153523.42d68ec0.alex.williamson@redhat.com>
References: <20250711153523.42d68ec0.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 11 Jul 2025 15:35:23 -0600, alex.williamson@redhat.com wrote:
 
> > +			if (acct_pages) {
> >  				if (!dma->lock_cap &&
> > -				    mm->locked_vm + lock_acct + 1 > limit) {
> > +				     mm->locked_vm + lock_acct + acct_pages > limit) {
> 
> Don't resend, I'll fix on commit, but there's still a gratuitous
> difference in leading white space from the original. Otherwise the
> series looks good to me

The leading-white-space indentation was adjusted in accordance with
David's suggestion[1]. It seems to me that either approach is acceptable.

Thank you for your review.

Thanks,
Zhe

[1]: https://lore.kernel.org/all/9d74e93d-5a5f-4ffa-91fa-eb2061080f94@redhat.com/

