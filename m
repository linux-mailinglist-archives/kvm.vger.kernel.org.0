Return-Path: <kvm+bounces-49914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C58DADF953
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 00:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB4921BC2E1E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A65627EFE2;
	Wed, 18 Jun 2025 22:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcv/xr+k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEEF21CFF7
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 22:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285339; cv=none; b=pwVkZ7yQF0IivtHKS2mMCvCKHyokex7GFdNnt65Pz4gLuG9MHr78Ab1KwaBV9wFRzbU1MMrU5GI/z4EpJbWxpAFrYidPML5ftqkensoTYMSju3IoTA9k6AcAunlomRK5PJjbnoAveb3/FKHqTguYk4dVJj8TG7cFsTXs82NWb4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285339; c=relaxed/simple;
	bh=nGyim/Xvt+UW87dgtJrHiJJN+OED1pdUQqSadl6Mv9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dT0jk6//Bzj01wUqs1K0EEKi0yBc4J0bdDTkf//R9W9r0zK7aNmK0IyRH8Zcv9zGOcymiW6OLHj/MV82WsnAiSa/QsP5MTjgMDJF/fTog64VIli4ICfPIIqk9tGzYW7A43nBSYnG5TScPl19+PVMgomYO7Kax9vXydX3NyTExq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcv/xr+k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750285336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kvdbqMvmqccHbDYi1u6MCaoXXJjQgBtiZn30PfS8Ulc=;
	b=dcv/xr+kLy8WLSeb/rMyBdoDBIeFZrSM4jwoX+77nPEkkwSYPFxAn7fgfOj9NA4nOmo49t
	VPg3t4IW/l4VMZh9+wProuZ52jZlQjxY2MdOXGuZy89CnLhFRHYtDSFFTDm7EjRRbWFhyT
	gI+ixElrqN/BsBThzyzrKsh8KRi3y0k=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685--Sd8Xt-ZPSGYSaOsem0nXg-1; Wed, 18 Jun 2025 18:22:15 -0400
X-MC-Unique: -Sd8Xt-ZPSGYSaOsem0nXg-1
X-Mimecast-MFC-AGG-ID: -Sd8Xt-ZPSGYSaOsem0nXg_1750285334
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b2fcbd76b61so222742a12.3
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 15:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750285334; x=1750890134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvdbqMvmqccHbDYi1u6MCaoXXJjQgBtiZn30PfS8Ulc=;
        b=TRVl2qAuMESXOinLZSTOyWtj+YTD34lzRpEHRxS6QG6YYMldhUt50TyrA/O6Co8GYw
         HrEcwKnxZ2qOJWeWUoTdXmFy+7y06/tuQLBM9fRPHrl9MT25tvMKVzXtiPQ/tUGAhbej
         8fDcn5TcY0uKQ0yEtZf2aXGlCaj40Wat76PWs3O8eQy/mky29nPbr1XLddr4hFZ7O+kr
         qcK27fZBIPGtOUgj6xhgVoAgxKa2398BzwhN4jBWpwb1IWf5EmJulA4z0tr1gIX56mLg
         sqJ9Q9CekiGIKABP+ZEUdp5I344nZhQIG3bAlDnhMYdBUq6IOdmMQefZ8EIX3QfBMtpu
         mPnw==
X-Forwarded-Encrypted: i=1; AJvYcCUD8rdp7sSvuYOLdAa1RgQCox8d3xYwHaiQxYIx2sR3deco/xgDnBLeG+H22vUBgWvngFw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt3e7mjIu27ODrzQzNjQBvrdajQVnrpaiMdUhLZS0P+XoEqsh5
	ySiIftzypRiQeLx8EFjbpBt4KITolwtXtGxCsZsYeUu/KuHhP9AVbry1tTBjLQtC90OWWLvax6g
	KMg7jXkVBmEPECR4/LWOcnayB/YExCK5f7T0z6qGylydm0ESVr0igbw==
X-Gm-Gg: ASbGnctxSgnW0W8TzAzF5+0CQTe+Fnk+UgQpv1KfxEswNsJEEk2cenXcY0gw9DrAZhb
	1HQKuXJV3uq3q3GBE+Tz/hyEd/Ji/S7o45jxK6Y8u5VYAkwAR4CURtp8Rt+jkS3bY6AkrLo0GFZ
	6znBCwUhexovmVn18ED66fB8ZWEIjsE5QNZ0J5/WeYCVtgOD3ahtuAxPliDzjqZEA4ASEH0d0m5
	zmeG4300IxMWwxow+3L2TC/D9vFC+5t1OfuZ2VDC4Iq4zsqzE0LdQCHdta9MrD2/9pog0DJnD+9
	Z8ws4nEnfzWD4g==
X-Received: by 2002:a05:6a20:3ca7:b0:1f5:9024:324f with SMTP id adf61e73a8af0-21fbd690f1fmr30913419637.31.1750285334403;
        Wed, 18 Jun 2025 15:22:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVnjorF2p/TsyHRfQO+O89iwaSTCUkL5cFkuUmViiWGO926kqlUR1fIZpNOQWV8GOC1c5Wrw==
X-Received: by 2002:a05:6a20:3ca7:b0:1f5:9024:324f with SMTP id adf61e73a8af0-21fbd690f1fmr30913389637.31.1750285334067;
        Wed, 18 Jun 2025 15:22:14 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1639eb8sm9832380a12.10.2025.06.18.15.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 15:22:13 -0700 (PDT)
Date: Wed, 18 Jun 2025 18:22:07 -0400
From: Peter Xu <peterx@redhat.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v7 0/5] Enable shared device assignment
Message-ID: <aFM8D7mE2PrVTcnl@x1.local>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612082747.51539-1-chenyi.qiang@intel.com>

On Thu, Jun 12, 2025 at 04:27:41PM +0800, Chenyi Qiang wrote:
> This is the v7 series of the shared device assignment support.

Building doc fails, see:

  https://gitlab.com/peterx/qemu/-/jobs/10396029551

You should be able to reproduce with --enable-docs.  I think you need to
follow the rest with kernel-doc format.

If you want, you can provide "git --fixup" appended to the reply (one fixup
for each patch that needs fixing) to avoid a full repost.

Thanks,

-- 
Peter Xu


