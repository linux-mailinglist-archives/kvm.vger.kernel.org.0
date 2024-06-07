Return-Path: <kvm+bounces-19062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C2018FFE7C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 10:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EF381F2A1FA
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0980947A6B;
	Fri,  7 Jun 2024 08:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBOg4rvU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF48015B14A
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 08:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717750628; cv=none; b=NKU20Ko8dXPlGlUPhgJNKNhddMJwoNxi45Tl0Ar5t6nvRwDHrljTfdAlSYK4M3nZHDRDqOEb8e1qfhZlleeCpsK8KgjrOA9E05BS0Sz2x7LJq80ii8sCc6e6eq1rS8EbMWcHZ674n3KAeipz+2GxLNcXzaQszDIMeDRjifkLel0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717750628; c=relaxed/simple;
	bh=dnJ3s6hfgwAk/vZaYwvVpkpmujlzIZfHfB+ANFAuFhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EX3nHEDiUavnMTemmAx8yVfJly+iNNRVhf9spavptJtg+zp3OXjTij1lrpuQvGxeQZXIshvArnfpD2Yj+dhfOlQ4pDX89Tet3pC87Jhh803WWkOVKNpwgiQMew8+Ozl3s7/ivNN03eCAPSpDKlqJCfM+NiBTYoBwkSM5ts+YR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cBOg4rvU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717750625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SRedVtxtM4aYweUIs3ZIlYgY2brCcQem2JU3eiYIqac=;
	b=cBOg4rvUkekL8WLE5y+AxWnRunHBrJkJ2Bgyt9v9MHC5liejWJDIYjqBPX63ajjNbDXOiG
	Xp8rzWG1gT6+kkzPZLD1fdMIB9zsi+/HMKGVBNKLmqoL3Od6Tdi+lu+nMuRrVNwZoaW+GD
	zE+wGiA7QHSb2r41Xj5UCywXED3AW7M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-pTBKiL00PBm0jEWOg1sd5g-1; Fri, 07 Jun 2024 04:56:59 -0400
X-MC-Unique: pTBKiL00PBm0jEWOg1sd5g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-357766bb14fso1251049f8f.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 01:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717750618; x=1718355418;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SRedVtxtM4aYweUIs3ZIlYgY2brCcQem2JU3eiYIqac=;
        b=LD+dignhiThbiuSw05fQCz9t/Q2mKp7ZiGOETkQVIW0OZV73nvupYOPceJeEAdmZpv
         SxP2oDzmSQY8tNNIJoohQiHWoPBooZ1LLhegCBiXPTG/Rtg6FHUcc21VvJDS+Q+zeIMc
         miyX8D7VcLBy3MV6AdTu6Edoi1hmLdMuJVxOKJyqTmSseW8rgSe2wL+/nfMz5GUACM8V
         qs5kWmkcD0vTig3h2mvuaPLThECnfvyrTV8pq0vjlawqXHNIS5CFpxm5y2F1vhBvqBe4
         a1XlMMv8B3h7GEMDCS0xzesoP8owmeN8pWCXCKEWZXvq4TB8uYxhWA+8zPpyX9U013HJ
         tPnA==
X-Forwarded-Encrypted: i=1; AJvYcCUwVIyzvpgRtH2quNHLx2kyTW1Mp9tYnEoesI3ULW6ldVo8tWLmoNfPG1DTQ67khYygcY0kdn0+9iBCQAJegUeg2Uor
X-Gm-Message-State: AOJu0Yxz1mAzP1dsY/9o5KE7yKFKN17BJXKvlH5iofIYCBZhTcEwU1AL
	SiUNx+GEoIr1eFzWUl5/5BMe4Lqyg+WbvAGIO37kRatBj3SKfPyG4N5gsNXWccEtD0uziLS+UlR
	6/FStFeRZwMZ/po42eym2g0ioIUcXbrYodi4dKtQaPYCMqnP86pbktsmI0rraeK87VwUkxk/nDQ
	bHUPKn5Vwgv0S0rKvBRkrf4TmP
X-Received: by 2002:a05:6000:512:b0:35f:44c:b3ef with SMTP id ffacd0b85a97d-35f044cb688mr757446f8f.52.1717750618805;
        Fri, 07 Jun 2024 01:56:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnz+ujg3mXfUbzxVa9i6qFBledYwxNORWM+iQLuJuwcvJcvhbpMAHnqmH0KMu9Nvg4zZXmGJI1VYpV7yRvujk=
X-Received: by 2002:a05:6000:512:b0:35f:44c:b3ef with SMTP id
 ffacd0b85a97d-35f044cb688mr757429f8f.52.1717750618470; Fri, 07 Jun 2024
 01:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-14-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-14-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 10:56:46 +0200
Message-ID: <CABgObfanTZADEEsWwvc5vNHxHSqjazh33DBr2tgu1ywAS6c1Sw@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks to
 check kvm_process
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Subject: propagate enum kvm_process to MMU notifier callbacks

But again, the naming... I don't like kvm_process - in an OS process
is a word with a clear meaning. Yes, that is a noun and this is a
verb, but then naming an enum with a verb is also awkward.

Perhaps kvm_gfn_range_filter and range->attr_filter? A bit wordy but very clear:

enum kvm_tdp_mmu_root_types types =
    kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter)

I think I like it.

This patch also should be earlier in the series; please move it after
patch 9, i.e. right after kvm_process_to_root_types is introduced.

Paolo


