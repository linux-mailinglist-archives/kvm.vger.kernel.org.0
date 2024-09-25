Return-Path: <kvm+bounces-27514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 895289869F1
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 463FE283919
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145441A3BD4;
	Wed, 25 Sep 2024 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tZ47c1lM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30D14AD24
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 23:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727308305; cv=none; b=aQtvp6GT0/nUNnyc3J4F7808AD4zaoRhmU7w4AQopNHdjbh9DDuGy+fKrSD5x9UtkO1hcGQnnfXBKSnUUXuDW8dU2t8q7Q7RKLL1Gav5gaF/icNnMdmBlzvJ59kHhU1kQZ6kDN7XOV1JU3IdVuyP+2IZ8g76uLCpkHxk/C6aIFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727308305; c=relaxed/simple;
	bh=1xkkLn1+bdfXFRs664y6k0DNdEOzPnQum3zjPar+uQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cz9nIBhUKPmt336HfsRtlznTsgMziOh8k/MEJSjOvwDKS56CWUeTNKG0PbuwpQK4/V9xArbjZEDBswTJH8B1LKC+lzFYjF2oD8NEcSphXWqSlJtL9l/IZevLsqH+OuaQLFq4r34JMySFqJ0VJv1aG7mDP9v5nX/jrBkTyB5sOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tZ47c1lM; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-207115e3056so2663755ad.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 16:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727308303; x=1727913103; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xkkLn1+bdfXFRs664y6k0DNdEOzPnQum3zjPar+uQA=;
        b=tZ47c1lMIM2vNTCd5AeVsggWSTiNgVqTZOa+RPB4s+PzdTJUCtbTvDSvuTNwCHdbSy
         QMZQqYz0VDhwiZ9tPgfdsGZYTClos4POsILPRReey2zJDGffFBP/0aJkzXAnzS+9D3Lk
         t/hINlK6C1OUT9OxgRq84126Jd9yjyirZhaTzemcC7+IavO4cFsHR3ZStwBgEgEJBn6S
         Ei8unKxXWTYgfxEK/N4u2elBfbtRBde/OhtND6dTbSIW7mwteLJSQ3KBW7ibvOfST1HK
         0wog0XE/h5LdBCZnzQ8gqRaC4/Ec2qhuDv/dRxxOSS3Qz5YVl7CmDs1gsXjHmuA/WiE7
         Tzww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727308303; x=1727913103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xkkLn1+bdfXFRs664y6k0DNdEOzPnQum3zjPar+uQA=;
        b=D2o6iCcPxIaUnZ80tz3iTPl/9nCIVgYOCoBAcQKKSHZQiOR+AqRJjLdpXDRtUzyD5M
         SCYVBLqBjkv1dqOFnFGXxyBTmCPCO4vKaOR37hI0kbd30Mrix09TZWcIbx0Gy55qfRuv
         8Sfd8zh9nq3rY3UAu8D/BGwXStbm6LIlXtlIowy1jDokFfpYWZ3DoZMB0/lHUo7giupn
         y3GUq0qGNZrYyxAKlqbgp63u2jk5uN/xhWDJY+fvK+tTqgsfs5TbIMxx/2hfe/Xc2QJx
         t/PRVZzg+Y+ec5PWh56dmw8QoWCSc0DknhSUR6ClBOkm1Urmy0hIEPGAso/Ot6FzxBBD
         NXsA==
X-Forwarded-Encrypted: i=1; AJvYcCXYsO+Ibc+dfoIYe97GC9GkdVsYUcpZMnHkwbHRfeLIAM9csz3rSlBx4Firy9UlklmRPqw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqe5BQEJnhCDsyB+XW8eNm9A/btV0uemz+CTo1RdnA1NJcC3B0
	P7GvWxWSoQ6koitlWT/BPPU95Juf9wg/cA7XVUOznrL4BvFO45UU4ST7jhuHFA==
X-Google-Smtp-Source: AGHT+IE9Ra0Mr6+7MR0bMwuFLB9nweUy/yTnEXljqqFwo2FmQ7UofXMIzpM4C6eTw6mWhjDcDiRJEg==
X-Received: by 2002:a17:902:daca:b0:202:3432:2324 with SMTP id d9443c01a7336-20afc6458d0mr59978055ad.54.1727308302921;
        Wed, 25 Sep 2024 16:51:42 -0700 (PDT)
Received: from google.com (46.242.125.34.bc.googleusercontent.com. [34.125.242.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af16e064bsm28782395ad.17.2024.09.25.16.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 16:51:42 -0700 (PDT)
Date: Wed, 25 Sep 2024 16:51:37 -0700
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, zhi.wang.linux@gmail.com,
	weijiang.yang@intel.com, mizhang@google.com,
	liangchen.linux@gmail.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Repurpose MMU shrinker into page cache
 shrinker
Message-ID: <ZvSiCYZv5Gban0VW@google.com>
References: <20240913214316.1945951-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913214316.1945951-1-vipinsh@google.com>

On 2024-09-13 02:43 PM, Vipin Sharma wrote:
> This series is extracted out from the NUMA aware page table series[1].
> MMU shrinker changes were in patches 1 to 9 in the old series.

I'm curious how you tested this series. Would it be posisble to write a
selftest to exercise KVM's shrinker interactions? I don't think it needs
to be anything fancy to be useful (e.g. just run a VM, trigger lots of
shrinking, and make sure nothing blows up).

There appears to be a debugfs interface which could be used to trigger
shrinking from a selftest.

https://docs.kernel.org/admin-guide/mm/shrinker_debugfs.html

