Return-Path: <kvm+bounces-48098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B696AC8D05
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 13:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 009351C01407
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 11:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B65226863;
	Fri, 30 May 2025 11:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IKPLte22"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4508C1D47B4
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748604948; cv=none; b=mCsyN42pcz3A8q9dzn+r2c5k1mOolSoIbJ+db//1Iu96UYlbgKnKj4r/aeNaLeVP24idjWJOd5Dcb9+WVPuCdDH5bt7YjWPs5ybGsw3b7k2vY/olRhUzCO3KLuLIUQvh4lk1XK2EcuIOl/2vbnqk5+pyTWDDx8CDpfSgCSj/dh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748604948; c=relaxed/simple;
	bh=gkPB2JXcf/REB1n6rNxjG3Nmd2uXI152jyLmRY3Uk+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pG5V4FB/ZVwuUSM+NY5ISnmYhp4+XD5zJOlq38M0/Q7kp8enRr426Q4yoKAPE2ZSepVXkh6v0h6lnmy0wY9DRE0Y1A6ktaFOiDUH3OljU1L/C13mXEGBfaPnD5qpwNER1iLbkHCx0xDceWO/eTYWoi9kCFNrN0wgUR31ieDkxSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IKPLte22; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748604946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmjtuBgro1iLL+lQ7PfSG+YZIWnOMKtg8axX21EwLnc=;
	b=IKPLte22/jDaZTNU80JviScGwXA7JRhQBJNl+N2uiPmgrUBrsGYQRLJDk8y4ZRAUv4WTcv
	gvHoTKo+ij/BS0akmEoKE0tI1MjiiLZ3Be/eTyJjClQ+sTdF5nCioGQSLL6lCnkqLDmjpA
	R7Mi7AGkzGjG9XzHgn5WW4qrDzgHS+o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-FusCVeXBN1GNPjYGn-qzCw-1; Fri, 30 May 2025 07:35:44 -0400
X-MC-Unique: FusCVeXBN1GNPjYGn-qzCw-1
X-Mimecast-MFC-AGG-ID: FusCVeXBN1GNPjYGn-qzCw_1748604944
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d8cee684so2416115e9.1
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 04:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748604944; x=1749209744;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmjtuBgro1iLL+lQ7PfSG+YZIWnOMKtg8axX21EwLnc=;
        b=LNpND6ZNC1N6U5xsn0GecRCq7svf3xyjDhNT6UZVgyO+bYvynlYtkvNm0KvvxdDb8e
         pxotPfpt+IaWs2rgvTKpDbHLiWk/7gKHYkbcoiZmsSWF+awy4/XpzRB1aWHaV3JF9PcZ
         2cTlXTAwqyaI7dAJSWDtS5210j7O/YTHon9oTA7SShjgHmmb8kWTHlgumZf1uam+fDv4
         RQMWobzgKk6p/1lqniERorkq5hJlOo0Es4muMGVFVsQJPeBZvIc3dwSOpaPE0rXoNcrz
         wel8wi1MJLLxSl083sgIpeuVXJosTnBsR8l+dddDbxg9dYa/2Dk9xmHqXKW6o9z7e0mI
         qxGA==
X-Forwarded-Encrypted: i=1; AJvYcCU4SXG9GJCD1Bjb8angfjX3zO6px/Z5Br3PqKuCYOVNdVg83mISLA54RpOoI8tI0tE1eT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/db9s4arllHkPFIAIA2oziQkGg+L2C0b0/G4m7OH6QqqvhZix
	CrZR2Brei0dHE75PyNoUF9+M0RJvg4JZ8VWKdrUblwzvGMYZE9uet9DJAQMIIHOZl9xpvrQLJMA
	KDMRSD5VbQOBH/NOL4nMiuX4tZ/Wc16QQ36IGHFk8wOfVuUV9BbYW4w==
X-Gm-Gg: ASbGncsgIl4KQX/7fgfqyAKcZiSAgekPZnhuxVjzlSWDwU3bVtf5HfUcrllenJfHJM1
	1AJCuvcBHbo1vCZMuO2TJlO94348QxzWBHJDMAPlTEVTE2EJcsdLnvURslqlqbI3Goc7qhid6wA
	5TPQpd8vJBqZelk61P9p9fIYO1eJEfvMTlbcL2Ec9+ge+qkI4j/GvCOeE7ozc7IpNJaHwTr52/N
	V2bXUydrZoam3QLxQfIg6qWaGK0S0TbwTe7la6yYFoEMzDMWTsW63z0+1yND9EMdvl3PS+0Hw1g
	2Uh+ww==
X-Received: by 2002:a05:600c:4fc3:b0:43d:174:2668 with SMTP id 5b1f17b1804b1-450ce684b14mr56796875e9.0.1748604943675;
        Fri, 30 May 2025 04:35:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVAiHCays6owmIaqzT9s1ZDbqz8dccPcgBZRtaLkp6VX/ZpZKxJ2dWzQChS1U7mqSqt3zPTA==
X-Received: by 2002:a05:600c:4fc3:b0:43d:174:2668 with SMTP id 5b1f17b1804b1-450ce684b14mr56796445e9.0.1748604943253;
        Fri, 30 May 2025 04:35:43 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fc1b60sm15903185e9.34.2025.05.30.04.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 04:35:42 -0700 (PDT)
Date: Fri, 30 May 2025 07:35:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>, devel@lists.libvirt.org
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <20250530073524-mutt-send-email-mst@kernel.org>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250513132338.4089736b@imammedo.users.ipa.redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250513132338.4089736b@imammedo.users.ipa.redhat.com>

On Tue, May 13, 2025 at 01:23:38PM +0200, Igor Mammedov wrote:
> On Thu,  8 May 2025 15:35:23 +0200
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
> > Since v3:
> > - Addressed Thomas and Zhao review comments
> > - Rename fw_cfg_init_mem_[no]dma() helpers
> > - Remove unused CPU properties
> > - Remove {multi,linux}boot.bin
> > - Added R-b tags
> > 
> > Since v2:
> > - Addressed Mark review comments and added his R-b tags
> > 
> > The versioned 'pc' and 'q35' machines up to 2.12 been marked
> > as deprecated two releases ago, and are older than 6 years,
> > so according to our support policy we can remove them.
> > 
> > This series only includes the 2.6 and 2.7 machines removal,
> > as it is a big enough number of LoC removed. Rest will
> > follow.
> 
> CCing libvirt folks
> 
> series removes some properties that has been used as compat
> knobs with 2.6/2.7 machine types that are being removed.
> 
> However libvirt might still use them,
> please check if being removed properties are safe to remove
> as is | should be deprecated 1st | should be left alone
> from an immediate user perspective.

Anyone on libvirt side can confirm please?

> > 
> > Based-on: <20250506143905.4961-1-philmd@linaro.org>
> > 
> [...]


