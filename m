Return-Path: <kvm+bounces-50985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2CFAEB6B6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4EDD564031
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0372BEC32;
	Fri, 27 Jun 2025 11:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMVLX+DQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9160229E0E0;
	Fri, 27 Jun 2025 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751024562; cv=none; b=tixeSUO0ciuOaL6RBXzS8ubWgsy2jGKjDDEFQ3GM1qdhmK+aX4CnEKJLQrtuJglzTXr37cHjJVsURR+ImpJNQ7h6FEH4dpDnSNsgc4tcniQ0eP/vRK7lUSonXlKMKujZ1LzVRTdtSuxx9A9l2i/r+jXENtbN+F8KN8d2rBnGjvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751024562; c=relaxed/simple;
	bh=iVuGRVgsqGxyCMlQcTQPYJM2XPrRXIKXOv3tNp4GTIA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gf3mIO3Wd85yFZc6h5z702mZ3z0TNAI9edtPCqtILE5smBJejAhpkXheyRctFht7A0QMMcnCm8G8yy5QY7/JRVcPH+fn1E0tHGOk6/KrbLVJ9ehwHXbhztTpM617ZXAY9KWJzVKXvs1HEytYojEpwFDZtZFMsgPjYqQ/8Bnj2+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMVLX+DQ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-747ef5996edso1721526b3a.0;
        Fri, 27 Jun 2025 04:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751024561; x=1751629361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9YtTg1t58ZELtcEG/y0IgZZ/473yKqIjgodQWzu/94=;
        b=XMVLX+DQDs6QPOJ+qYp4+5dYavPvCuKFl/gZlt/Sbvie6yAnay8xTbvpa5aXMoBgYS
         CqX4VUWxqMngET0UukJYaQepWO3zkxMyWB5Vmf7P2BZajYH/HiashHrmp2WI0De3D4sx
         PpEGRTvCRkDAuvSqxHYmhfJPEyfc4W8spzVBa3JVUmKhovh4VezLOzMFkHQMFZ2Bf26w
         0Fmcle1qz5gghXLgJvi+hS5ofYSah9PeYJqjXFZFURplngTzsYTyintTkLJ3f2P1wS0l
         jQdnqsxACucPZl17mA4gYMle7W8nBmrhNgIAE3bWK0NMucCRl5Iws4ktW+lau6N+irZ8
         rb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751024561; x=1751629361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9YtTg1t58ZELtcEG/y0IgZZ/473yKqIjgodQWzu/94=;
        b=U5b9fg4e8hcaNAighQpZSLHWDLhzfIhCK0+MKmSBBQQ2FRSJ0HfsiNWn/jIeWti/+K
         0+t4iX3fqjCzRU7LD6fGs9EUk69WnJMwnEIwU9RBrkrPGxLaYIc22VklnCmbcKEVRKPb
         e7YkDLNMMkMzVbsgx6oXm1sKmSnHoGbBGBkLFlFOwQYAtbkNKyJZvPrg05Sh4HzPN3Kj
         1pT0zwPOhmCwXo8wmlNpR1xvekCYj1HRwrhBrn4v2VAoxKV+u5fYEC/C/SVcs4iIcf0Q
         7cd5mt9cInSdSD2tp4eOXj6QAMKQLevvUtH8wMLYFo17zhLgcgO+ev1lGM7/gR2NR5/L
         ZZ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUpHvgt4hxZos9T9oKKDOOqxx1ym4bUcTviUpeBlI6flTSIMA5xZhUBD4dsesd3MG03xYTPYNBb@vger.kernel.org, AJvYcCVMWGJftPHhqXeae5H2IfNl3whk2OBHRibTq+lmF02pZJRHDm5LMf8Mp5RPd0qLz7uDnAKdTImqK/3ZBlbA@vger.kernel.org, AJvYcCWUHgo8HrH7vpheR/5v/IXHDUJ7dRLoBnsah6grpe/cNu+T8sxlJxYdQEVXByMQZThTSYE=@vger.kernel.org, AJvYcCXLGVrZbT02qHNmrjnFhtOfOOgPdi55SzlWhphy/SWRhMNCpHxtkpypcEPIyXn+KVma7BjiCDMz7+FFWoew@vger.kernel.org
X-Gm-Message-State: AOJu0YztAvwl5RYow6Aq3eRt0aLW+tUCNmSp2kvUfTKCGwxLDLfXWvrE
	GP9LBqyMTAimw9JbAF74IHCLYISRx+ZR720SMYjBPGxq4rVpmD0LVtdx
X-Gm-Gg: ASbGncvkH5t1dv7meMNxogL+JXEq/vKHBXLDHs+OQkzy3z0RYGLuGVkIkmu15oZj7Zz
	rijYsQBlZs0HhVBA78McprJ7KsNy8pFhneciRnllauImddyWHv3oY3kMZ2AE1DuxO1N1wnS+Cn3
	ClyHrsreUXiKrrZyt7inH4wme/7US0SvAj19LXmkGC2nFpXyVI5dw6jRffkfgvSySKW4nz5G+wn
	45HBxvdSVgtGfJL50MdilIt5gb6AYweAbolOgNgjJqDEko91Wosr3244kZpV1nS/9grjtZRPHce
	8FPTemLfWcERV+2cv1vhyqEF4Sd2jI/DnQ4lG++O7F+mZHYJ3owzc6RnnP8IV7JJdCHCxVrWD8u
	75KGMRQe8
X-Google-Smtp-Source: AGHT+IG3MYN2lSqPm1Q2L10kPTc5dlCvyMRnUX5hH47bSaJ12kP6xa/9UdmlnUhiVnL19oXKhjcflg==
X-Received: by 2002:a05:6a20:748f:b0:215:f656:6632 with SMTP id adf61e73a8af0-220a180a309mr4517364637.29.1751024560724;
        Fri, 27 Jun 2025 04:42:40 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm2083067b3a.48.2025.06.27.04.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 04:42:40 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: decui@microsoft.com
Cc: davem@davemloft.net,
	fupan.lfp@antgroup.com,
	haiyangz@microsoft.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	kys@microsoft.com,
	leonardi@redhat.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	wei.liu@kernel.org,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v3 1/3] vsock: Add support for SIOCINQ ioctl
Date: Fri, 27 Jun 2025 19:42:29 +0800
Message-Id: <20250627114229.96566-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <BL1PR21MB3115D30477067C46F5AC86C3BF45A@BL1PR21MB3115.namprd21.prod.outlook.com>
References: <BL1PR21MB3115D30477067C46F5AC86C3BF45A@BL1PR21MB3115.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > From: Xuewei Niu <niuxuewei97@gmail.com>
> > Sent: Wednesday, June 25, 2025 10:02 PM
> > > ...
> > > Maybe when you have it tested, post it here as proper patch, and Xuewei
> > > can include it in the next version of this series (of course with you as
> > > author, etc.). In this way will be easy to test/merge, since they are
> > > related.
> > >
> > > @Xuewei @Dexuan Is it okay for you?
> > 
> > Yeah, sounds good to me!
> > 
> > Thanks,
> > Xuewei
> 
> Hi Xuewei, Stefano, I posted the patch here:
> https://lore.kernel.org/virtualization/1751013889-4951-1-git-send-email-decui@microsoft.com/T/#u
> 
> Xuewei, please help to re-post this patch with the next version of your patchset.
> Feel free to add your Signed-off-by, if you need. 

I'll update my patchset and send it out. Thanks for your work!

Thanks,
Xuewei

> Thanks,
> Dexuan

