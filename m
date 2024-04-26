Return-Path: <kvm+bounces-16067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3BB08B3DA9
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FA0C1F2306E
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0134415CD51;
	Fri, 26 Apr 2024 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QqRYZuW0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB732159585
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151600; cv=none; b=geefBEkMswZI0U/uivraQq5FxMyhlTpeAv1YarHsM5eLRoklnmlGBXxkp+MQG8KODHCLNBrQRsmbceic+1XD/UT5tzubZG2nIaw3ZQ6ZmwS7emJ2r93gjz4rtSpwyJ//2Q4Mw3b4EGxG3YIIC3bnnGrJD63M5ux5YzdeXQXw6r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151600; c=relaxed/simple;
	bh=u3LNJIRVZPB3ckJD/7UCx9uJod+keupn/nmB8Mtdils=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BhOgP+uCazwwfsYUmRHoZz3u7GvnivABZiMAI3bwB8wSbPLwaJPAXExwfeDP7HW7fVyW1k4V5jA+pYkMCrCxzRINjEU/qpW2MRGYb0iQGMa2hKU95/94zA4OO4p+xEl3zL4fafjLtBsJFMfiFbNvHfNCIltXSOMk3BCghRIjrQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QqRYZuW0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b4ede655aso42263797b3.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 10:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714151598; x=1714756398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOrByw+hBEQiYoKJcZ35QP+UwdL6g3Dsbjr56jvVdP8=;
        b=QqRYZuW0CYZ2i4dMPtIER4VFYt7LBQPxs6PD9/lb2Pu6RIGCClxrRcYEE8i2sjxUBW
         QUn0ER0L0bnoYYVkxDSgocqswfMGABN/53XFcMItMarfaI6odZTLjhaq+kGQSk7rJsrW
         /dPCxY4UWYIG526c30U0mqLTQEa8odOhEkNASMVBnX76ussRCBb1f8SSgMf9RDJX/qDH
         Ij/BDRKqLiXipB8PHE+l+PNxp++87E0rKYracqz8bvoR7jIig9omnySMUvyQ1SyGWqSU
         KDRhW5euys/K70fonJ8vSj3GmMmlTxnEL9g4TR9qtFFPHvfg6N+iRAtLcgFYvpx0BCrN
         Vmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714151598; x=1714756398;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JOrByw+hBEQiYoKJcZ35QP+UwdL6g3Dsbjr56jvVdP8=;
        b=aFpC7yjW7F6GUfZPVJAHLAG9JB3co+D9bicYM9M6+ccHb/iR7Uaa5j9QnL37c/5iVt
         65yaBJUR94OBMKsc8UPY6qoUvoZlDR73ai7Gxs5IH8awwaBt2LUgoH0/QvfFSnNYrzTb
         3xNESPP8Zb4H3qKAQGQeLlhnM0OsWMkkZzlidxrTNbkBsIHbV/RmkBBbwPTDr7juLdoj
         7n3hu22UZKqal0mMuqYm/9X7a7mjvnC91rpa8VWL4zoW7kWhuvtd6zNk00l7MbKyXqwM
         TWzqnebeoI1WRDsWpqbLBrTZmi0W71drfTal0nn+LwBUAp3/71yrjJ4ugPjNbHS8JbeU
         jy2g==
X-Forwarded-Encrypted: i=1; AJvYcCWeibRQXupRKdNnPUnmTJrBjbEXbHeQaJnuC2mMVjY5DQRpo/nRJY4TGrnbrFy6wfPIwx0vKtEmv96ebeN9ICrcqqQW
X-Gm-Message-State: AOJu0Yy7XXnYU0XYiqnHzNQRN7geu1vavde9OHvpqWaRValaTyI1n+aM
	JwAd3TZlG+f8Xo/w53V218GLFnzKx5OJphXq3LWEe0TXP2mBhMHO7myClBQq8p3dyctxAg7qqvm
	XZQ==
X-Google-Smtp-Source: AGHT+IH2xf/fgnFq9yNc8AE4dgHf5oyfa5aYjhlU8zrvZIc+Jc1C23QgqB5iVOoMBPn7RX/OAAREbEHVHvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cc0a:0:b0:61a:bdb1:896e with SMTP id
 o10-20020a0dcc0a000000b0061abdb1896emr57616ywd.5.1714151597859; Fri, 26 Apr
 2024 10:13:17 -0700 (PDT)
Date: Fri, 26 Apr 2024 10:13:16 -0700
In-Reply-To: <dc90c8efaa4d4dd36dc945d40cd118afcc3a9105.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313171428.GK935089@ls.amr.corp.intel.com>
 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
 <20240319215015.GA1994522@ls.amr.corp.intel.com> <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
 <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
 <ZivIF9vjKcuGie3s@google.com> <21d284d23a7565beb9a0d032c97cc2a2d4e3988a.camel@intel.com>
 <ZivazWQw1oCU8VBC@google.com> <dc90c8efaa4d4dd36dc945d40cd118afcc3a9105.camel@intel.com>
Message-ID: <ZivgrMHxdVOa_U90@google.com>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "tabba@google.com" <tabba@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024, Rick P Edgecombe wrote:
> On Fri, 2024-04-26 at 09:49 -0700, Sean Christopherson wrote:
> >=20
> > Heh, where's your bitmask abuse spirit?=C2=A0 It's a little evil (and b=
y "evil"
> > I mean awesome), but the need to process different roots is another goo=
d
> > argument for an enum+bitmask.
>=20
> Haha. There seems to be some special love for bit math in KVM. I was just
> relaying my struggle to understand permission_fault() the other day.

LOL, you and everyone else that's ever looked at that code.  Just wait unti=
l you
run into one of Paolo's decimal-based bitmasks.

