Return-Path: <kvm+bounces-25523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 348B69661FB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E636D285991
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFFC19ABC2;
	Fri, 30 Aug 2024 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Tkqa/SAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D3D16D32D
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725022044; cv=none; b=cnAn5K/S2UZdv3MMS6TUCgK7uTs3hXJSK6lxmth1rkzbAb0DViBNH4j1FxdPqeLZ++J4SNOtz78gBulSpnwBhB7nehx8i+Pbr5ieZ/FFoTWgVdVc1b8vCB6bHOnXibCuHCPdk4xAF79xF2zz8his5NJ/GB0v1cXdyWmc9MMFIic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725022044; c=relaxed/simple;
	bh=lWiucSN6zXhG3X717OejSkyo1yUhj7w0KySk1SkYMIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCUpOxy17cbKCne/axpShm+KM4f6YjKaRYrSVwEktsJ5+bWMmd5gjVFiTUwh4JrouA+GYdLI/LrInEcJSmzDJa4+Zt1aRt17TTGopsU619I9ceJJyJ00sMR/ycRpiGTqsB19Obk0+MTC53912d+adfOA2UpoL5u84+2kRTyLxws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Tkqa/SAx; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6c35427935eso211306d6.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 05:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1725022042; x=1725626842; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WmShJpOz/GOmUnd0xKeTBcV3P2NCGM0BHpjZiSl8WN0=;
        b=Tkqa/SAxC6hDf3jk2/+3faExVIsJ7T72464ofmlt/iDcnuqn04YWh5DDrhJ2OGQb2K
         T/hsSz5znhzr84aWUSfbd8ajZp6+rv9X7rHnDxTUr5NVwYzTWwYhp/1Eu1jG4GX5M4zB
         xe6Nxhatfhwz72HqYUIh/Bm9dQNLFWyUE4H9mGIx9nOdEnbIvAakkYxFHlI8m+uwknV2
         U2XETOsxLAhmD5BopdFPH5LK3KCpgw7yYKvNXpnrmidNndddltHr3NhyQdz6ite1d/m1
         QamqiVX/DX55ys+9+fwwOCc4KSb5TNeUd8GxXu3zi3u6ttSwDNVhtNEXAaWJSEYcIuHM
         u56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725022042; x=1725626842;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmShJpOz/GOmUnd0xKeTBcV3P2NCGM0BHpjZiSl8WN0=;
        b=egXN49b/hh7JdBadLZVA0gOL09OJRwkdRruJLTgerH1RlFtWKwywPMwIAFGkaNNROY
         JB3XPAwW4eNQzqBH2flWu9SUt0VPMMCCV1Du/42atrsc40j/vGtVBI46iTFXp224J1EN
         asnHLvFX9iLjsftgPnudH6BcQznzfGpHsZxZS90/dIrhr9cgzqU8qZ74yvfewDaUGF5j
         IdzzStrhWdoUCNNaWG8SEM+QB5O/QT5v593UBrVk4gnXR+qCJY/01R8f+LUrU1FDE2ys
         cVBixgIYm2zAqvL63wl4gBW6ThJJ5ew6eJ+pERbUY5DmExaiLpmPAx1WXuKuAW8oY44H
         t6+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVWCqt60EVFnI79FtnyLBRYezQugw7WO7cRG9Rl9CHfCEcc9aj2DjDBYY/1YQb/XGL/cGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwlLzcq02GwUFomxTtxIYTVdio4QPX8RKIHR2jbjQRD4oB+ugT
	QMWDGtw+V6NNMNrzGNmQqFPG7MS18TGKMHTH6BhscdlMJ+Zs/1wamt2ARt7nbAk=
X-Google-Smtp-Source: AGHT+IF1zgT2NlSjbSBC4mUiCoFIEUsoyt95nAEze677a3G7gSdAzBNVY6enBBsIy8xyElYIQbGvzA==
X-Received: by 2002:a05:6214:3c8b:b0:6c1:70c8:ead6 with SMTP id 6a1803df08f44-6c33e69695bmr78641056d6.50.1725022041738;
        Fri, 30 Aug 2024 05:47:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c34c04f512sm3869726d6.37.2024.08.30.05.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 05:47:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sk128-00DlJD-Gs;
	Fri, 30 Aug 2024 09:47:20 -0300
Date: Fri, 30 Aug 2024 09:47:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <20240830124720.GX3468552@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com>
 <Zr_3Vohvzt0KmFiN@google.com>
 <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
 <ZtFA79zreVt4GBri@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtFA79zreVt4GBri@google.com>

On Thu, Aug 29, 2024 at 08:47:59PM -0700, Sean Christopherson wrote:
> On Thu, Aug 29, 2024, James Houghton wrote:
> > On Fri, Aug 16, 2024 at 6:05 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > > > +             struct kvm *kvm,
> > > > +             struct kvm_gfn_range *range,
> > > > +             tdp_handler_t handler)
> > >
> > > Please burn all the Google3 from your brain, and code ;-)
> > 
> > I indented this way to avoid going past the 80 character limit. I've
> > adjusted it to be more like the other functions in this file.
> > 
> > Perhaps I should put `static __always_inline bool` on its own line?
> 
> Noooo. Do not wrap before the function name.  Linus has a nice explanation/rant
> on this[1].

IMHO, run clang-format on your stuff and just be happy with 99% of
what it spits out. Saves *so much time* and usually arguing..

clang-format will occasionally decide to wrap in the GNU way, if it
can put the arguments all on one line. People will never agree on
small details of style, but it would be really nice if we can at least
agree not to nitpick clang-format's decisions :) :)

Jason

