Return-Path: <kvm+bounces-67832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A67D152E6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D2D83077676
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D86334685;
	Mon, 12 Jan 2026 20:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VyVYobsa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117D4239085
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 20:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768248921; cv=none; b=XSBsUI23XffbSMGznzEaX3M5dy8SA2DB2BVmXckK9cqHy1FL74l60htL333Eg82Z5le8pfLPfS/Qg4GVXXhlOyTv+oP6i+tvr/VNiDdxCoNKKjz+GctGpIn4yYAm68DuJoZ5mnsRQwj896/fjTvzr7ah3sF9cww0p5GE/QFctCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768248921; c=relaxed/simple;
	bh=gqMnmnhxtEDCxa/FRqSVyk4U1WsMIFSBgnvYIj7CUjg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVCDuQfFf/7t1uqII++/SNlaXoywgqpp9ai8R68kwqzv0COfZV1/L3kVcm4jtk8qfu1ghmoQdingfi+y1n3b+EvfTsJE6+MzV/fmPOqQaZZvGQ9xHfMhvjf/pkSuBxa/HS3UUATWhZUKBvWJgn2ju5go8WHx0LXS2rUWPxRBRrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VyVYobsa; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-55b0af02ddeso1040683e0c.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 12:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768248919; x=1768853719; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gqMnmnhxtEDCxa/FRqSVyk4U1WsMIFSBgnvYIj7CUjg=;
        b=VyVYobsaZbYXgdQY78sxZSgwzLJ13humgfAE+bjLXYlA9gu0yh1rwQT0HcxVQla4/2
         PEyXvgZ3xx6MqQ01DtEaftKiF2z5efRluSmWbaEH+uiDGKuk1skQqW0+aaAcZbs8gPWE
         7eP15vq04HPXcbiCwmwpyopQIj7ioG32u8i0GgTW5XubU5YB5Zy3zXVYqh3vEyyON7mb
         CzDkX8ymwgmMCRDSZruoiW2iRN4NErvX4+nrUKIl8V41ve4x39euTJEKwV9BTGqdQ8dE
         ekKwXkfmtW/Hj/1YuGAflGHOhLxRN4an+o8vp9ssHSyL4zI0K4jPaenZAXvRqOUdOqK/
         0DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768248919; x=1768853719;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqMnmnhxtEDCxa/FRqSVyk4U1WsMIFSBgnvYIj7CUjg=;
        b=WS96P0Mt52YP++eJ28xXPBCOgu5R9x6uoE9eyMnGc/E6ijaDvlQ9QNtv3HbUwQFa8g
         CajQvmR/HEQJnM0SxjKo0bsNxSCkEdsVwkiZlENGbmF1hKOyLXA+TkSOiCE/UENJx1zv
         retwRb/5uuw3eU90yq37/82hZPTS0t+OG8MN33maHtDJ3QdZRVGouRKlmuVM+CAeiJaW
         6aWj5+/jFqDAUe7j4dp0Qbk0O5CTmhVBv+PKg0qMPSt/B4kVKVl/j3kvZRpc59vWMRwy
         xx+6LHxrlqpewHJxZTdcQHwB4R004YW7NUwmhaHImSJ16ginZcftKC13QOeaFsOpOL8x
         7Lsw==
X-Forwarded-Encrypted: i=1; AJvYcCWPx+FeVLLYXdBr6oRKH0ix709NUqwGqtPDL8k2J2hxBwF8D261SVnPIJJ0f+A59QvHAAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWMU0TiNmL9Jrf5DLBPlEEmwXNuftKaZA+iqqXNauU0JqT9i6p
	ApNRS1VJbZ+rAoS3DzMCjj2MAZuWv8dh4br8EafDLLAvmH6VvKEaGPi9XWhrNt0c13hIapN0miW
	xiGYyulmyZYN2YafcI27PMEEs9hBotmStpO74tu2v
X-Gm-Gg: AY/fxX7Cab/GsXLHA5Wt5UV4ujdd1QNxsoBIremX73F4c/1qSuV3j1dPkCPXXDA7u2V
	jN+RiaVGBu7VqzvH3Z3ag3+/oUowsaYyiWPJMWp291Rux5i2v4yso2Trtm8wES5Q6oxkWZg4750
	56/rcBJgAGAZyJP0xnvpOXynjH6fIYhGOC6ZNMajPPDp15AK4Zr64X0OQJcVWIdXgtfpE+aAoUA
	b9lu26Uc7VwP1LBm1egD45Kge1bJFwPHMUoTL3TziryG03S34NzK3IU9jObY7qLO0zEhd9naYRp
	INO4M3iJ7IfjYM4suTGSR1q0Zg==
X-Google-Smtp-Source: AGHT+IGYbJEBCzmHQfEpiS1F/CO8GyqQckSXbcbXZhkXuw0ht1eYAyH24ZEVDv6f6NElvnw4Ktork8tIczf98iPnrHw=
X-Received: by 2002:a05:6102:3a06:b0:5ee:9fa4:19d7 with SMTP id
 ada2fe7eead31-5ee9fa41a9bmr5155096137.35.1768248918646; Mon, 12 Jan 2026
 12:15:18 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Jan 2026 12:15:17 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Jan 2026 12:15:17 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aV2eIalRLSEGozY0@google.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Jan 2026 12:15:17 -0800
X-Gm-Features: AZwV_Qh8vf9jjVofuTQSeSrAom70NDFZ0O8pMoyI1QMe5mu09cCjdrs9-Badgdc
Message-ID: <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> conceptually totally fine, i.e. I'm not totally opposed to adding support for
> mapping multiple guest_memfd folios with a single hugepage. As to whether we

Sean, I'd like to clarify this.

> do (a) nothing,

What does do nothing mean here?

In this patch series the TDX functions do sanity checks ensuring that
mapping size <= folio size. IIUC the checks at mapping time, like in
tdh_mem_page_aug() would be fine since at the time of mapping, the
mapping size <= folio size, but we'd be in trouble at the time of
zapping, since that's when mapping sizes > folio sizes get discovered.

The sanity checks are in principle in direct conflict with allowing
mapping of multiple guest_memfd folios at hugepage level.

> (b) change the refcounting, or

I think this is pretty hard unless something changes in core MM that
allows refcounting to be customizable by the FS. guest_memfd would love
to have that, but customizable refcounting is going to hurt refcounting
performance throughout the kernel.

> (c) add support for mapping multiple folios in one page,

Where would the changes need to be made, IIUC there aren't any checks
currently elsewhere in KVM to ensure that mapping size <= folio size,
other than the sanity checks in the TDX code proposed in this series.

Does any support need to be added, or is it about amending the
unenforced/unwritten rule from "mapping size <= folio size" to "mapping
size <= contiguous memory size"?

> probably comes down to which option provides "good
> enough" performance without incurring too much complexity.

