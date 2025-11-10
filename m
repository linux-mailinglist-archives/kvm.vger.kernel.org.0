Return-Path: <kvm+bounces-62639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC4DC49B0F
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC3E43AB4BD
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8153F303A03;
	Mon, 10 Nov 2025 23:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hnFkdTkv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E58302158
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762815759; cv=none; b=m8JC0T4WZTA2YCkvIndKktlLHK2elPxHbbNyCKMzvpRXvLW9on5NSWBsCf5ZmBt4VYnqMcaPHmhwP+D3jSo3/g2Ucbke9oN80lhWTfh7UGYPTmfqJmYJ/W5id61F5N8k2mh2YTJta4iO38txqQPY86ZXCaN50sZdWZ0jql+SgtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762815759; c=relaxed/simple;
	bh=6TNXJq+rMH9dVRYVDgjIiVOlEcVoFw99/BJYAESuZUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBaVWFWqUgqqIdIavDsESX+vyaImo/WUMj8GSj4ATAIoIBrOPXem7vZD+tdFFmOSL7fs6852nXEJok94nGZnuPS41U8RvJovhg/xZTacQ+FsgBVr1fz1e9siF9eC8m2k/2aIxIIXIz3jwcVgExHOxbW7F5fJAskVJ6hi3DxLHXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hnFkdTkv; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so2923668b3a.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762815757; x=1763420557; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2oZbUXm17MlJJYs7nTRrwTniBYsG7HY04j7c8fnXzJ4=;
        b=hnFkdTkvMaN57K7ORUi3hT7ZDpAL5GOlbZezkvxGvKafYoDxqHe8SxYo2drgtwvplM
         soL4d9nV4nCfJIdv/patpxjbZZTyQVLsHuR0ogMGRJGVJsFlhb3GuyGYQerpeaX114+t
         NKYdqB3FgtdqL+TRlj4QY98izv38oSfKwUZiWbjS3cJ5HQ2xLCi5Eoja3ZToflzYLAgc
         2M/BsrPC+/opdV+72JzFctLFOPDIndU/lFnHIZo/Sv1ZHLcydOYeT5S4+Bs3DP726vAT
         t7vORiTQHeK25mTkkQ5G8PCVZH+C/J8wsn+Hlj8DkqymwJACag1ckbQRtgXmthwHX8Zn
         bKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762815757; x=1763420557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2oZbUXm17MlJJYs7nTRrwTniBYsG7HY04j7c8fnXzJ4=;
        b=u8rpxeWUsGarZUGCbHWM5OIF3t5YxCZ51s1Vy+XZtue9tG47WVOdWm/srShzkx3tu6
         AXiEHRGuAAQt9YkcpjqvOv3aenoMrxgm2keiJXOQsETFzvRlmnFV966cs3yQsPNGFfQu
         2g7zWomK6HAfiHEtPn3F41XgEX7hzwOW0GGo/z8A3UTuVCoXGsa/kJykEbSFpc0tGYOk
         sjYWARtQHrr2pliPm3Oc+cGUU6UgHzHieGBvto3ZCP5fNWCHe31ksGHOPuwotrAzgZUC
         ZAHeWtYMO8LhTaQxhBA9b0pd2FmxTHHednoX+/2kNZBS/oGi5ED10NgmshyoX1NUT4a+
         dqGA==
X-Forwarded-Encrypted: i=1; AJvYcCWkdIToCIpTkcRr0QafzETMuTlfoG3MkLs4fR83QL8Xrn6OGd1KwTEJ6Z5Ok332korxDWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW+u0YpHrQnEzWgbWZyvlI837rzq0vQsrdaIXMszQnDkYP1PZ7
	82e52olbl3Rht3khnQM7s/3ebQkeAqdLl5z+3dMZ2Jz7OK9D1ZJ9NVgGCx5lbvLeRg==
X-Gm-Gg: ASbGncvZolb7HHS/7OS7jV2c8I7CjJB77ODkfsUdBx1bwvhKeX6RLK7O/dymd8QRbum
	ciFqwlyUkRXJ11Hr1E/hiQ6utKBmO0n1eMlJtPf9JYwXYwza6uDYT5GjK0F0dlakWggPp5GPf2r
	jAIu6HjmOEFXRNU5FK7JTaiomhF6Jh2+Dm1sGlXmFB6LElXBialsawFJh5epowlJkKiWHg5PUcm
	xQJb9JEOhrX/RE94LJa2+T6MOljo2A+8aLZt7HGma9QDlcRYUM42fJiWn0cbAc+5tvhfLS0Exx6
	K9MuidJJLrvEYu0/JWjWbedEKo8lCJCV4W6/9mmByxuwsrU0sgRPfiq28wKwfa5XubvBWeRGw3I
	44CcGrklkHe/o3oSUe24JSsjF4JFdl8JWuOK+XMGUBiy3KoQswvS7s0Fh5w7OZUSwUUrUtGBuDm
	x+rE3Nb6udiGnPYYJI24hkjAEmfufUm5gcZsm3RT8eL5dlW86Xa/kA3LB+03+83Do=
X-Google-Smtp-Source: AGHT+IHoKo9/+Pwh3K40r/l8V5QU5Uk2a1RS5slNOQYfptjWO4tqmkHSZfI1hg8lgbKPM7wXJRriYg==
X-Received: by 2002:a17:902:d485:b0:295:7454:34fd with SMTP id d9443c01a7336-297e56adac0mr148711535ad.39.1762815757123;
        Mon, 10 Nov 2025 15:02:37 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c9c310sm159853455ad.87.2025.11.10.15.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 15:02:36 -0800 (PST)
Date: Mon, 10 Nov 2025 23:02:32 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/4] vfio: selftests: add iova range query helpers
Message-ID: <aRJvCK-4cG9zPN8k@google.com>
References: <20251110-iova-ranges-v1-0-4d441cf5bf6d@fb.com>
 <20251110-iova-ranges-v1-1-4d441cf5bf6d@fb.com>
 <aRJhSkj6S48G_pHI@google.com>
 <aRJn9Z8nho3GNOU/@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRJn9Z8nho3GNOU/@devgpu015.cco6.facebook.com>

On 2025-11-10 02:32 PM, Alex Mastro wrote:
> On Mon, Nov 10, 2025 at 10:03:54PM +0000, David Matlack wrote:
> > On 2025-11-10 01:10 PM, Alex Mastro wrote:
> > > +
> > > +	hdr = vfio_iommu_info_cap_hdr(buf, VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE);
> > > +	if (!hdr)
> > > +		goto free_buf;
> > 
> > Is this to account for running on old versions of VFIO? Or are there
> > some scenarios when VFIO can't report the list of IOVA ranges?
> 
> I wanted to avoid being overly assertive in this low-level helper function,
> mostly out of ignorance about where/in which system states this capability may
> not be reported.

Makes sense, but IIUC a failure here will eventually turn into an
assertion failure in all callers that exist today. So there's currently
no reason to plumb it up the stack.

For situations like this, I think we should err on asserting at the
lower level helpers, and only propagating errors up as needed. That
keeps all the happy-path callers simple, and those should be the
majority of callers (if not all callers).

