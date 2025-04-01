Return-Path: <kvm+bounces-42419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B58A8A7855E
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 01:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C04437A34F5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 23:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C2D21B9F4;
	Tue,  1 Apr 2025 23:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="KBWz3dIa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED4B1FBCBD
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 23:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743551549; cv=none; b=Sj+gULD4opcAh+/BlkWPdfc/the0TuMrHx/E+r/YlWDlBtzjo5qb6ORypafaSvjJvePOq/5Isng4dzsUoAv+vCR8FXtehesSXE+6x63D9d5MoIfOtLKAkvDAmp6d72jJptk0zfm93W80hkigHi7ResutQlcEEgHd7Qt2liuYRUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743551549; c=relaxed/simple;
	bh=YYL2PomV7Wu38rtkFqtGhC5SoQ4c0BSU2ef03OWtv58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRFJM4RK4ubx1u1conS9GEb06Q0Tn66ugBZOWlFAOatnZzHd5+mhxB8O1zEFRMCRC/t4y4Ro45D390O20lkTf3ER6e8/F5U2+4LK71ZvTvYqR6UnPBjY4mKXnQmcj3k2GvPqbQIEKty199R9EieIUIWROvk5gFPYaxVXwUAu1Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=KBWz3dIa; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c5aecec8f3so956665985a.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 16:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1743551546; x=1744156346; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uyEGExp4aQ8ye3lQnl4hQA9KbHk9+lBhnfulegXkqOo=;
        b=KBWz3dIa2nCqcVFohXYGlA+K5gYapTEjnW/Wd/Q1U4hL9cFrb/thmOquVaJOTYO2sC
         EV1RmrTAqRxqaNklKCLonfasjbYV2e3+w3MhmnFtuGCjkUJK4zklYzsg6Q3fUbTkOzLs
         pr+OVNaQF7TDQqn1HG1B4I1BMO/byBGsRpxDf0qQJfsDvHqAcFqfXivlRHFIqKmhoXGW
         2j+N2GlqTYjF5OG4/7/p/dwqqB9ZBOFUlxIhQ5DWEcxIaWvGyDB7ZcfHLPZXelOqmi0N
         UfoxHK5T3VwgsLS/d6OEVlH/Wj8MSNmVKg/90pbhbgO80KVymQw74waCbjl7uStSzlJ3
         rn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743551546; x=1744156346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uyEGExp4aQ8ye3lQnl4hQA9KbHk9+lBhnfulegXkqOo=;
        b=l1kb4/LbB1fLwsC19PKOt4je7WETHCfbXTlVNVcIpf9UCu487mZz5LTqIozh3PMEVy
         9deG/CVc/M34IzAB4xgniX2NK0Ta1RLklhSBr7B5OFzHerJRNz1Gp3/FSU2pm/Oy06vp
         wbP8sGgpJGwSf9ynArEEzsl0kYTG0FxfIWnk7wvW8q87Vz4MaK/uQVR8yguQ15iZmgiQ
         NaaHVXT6AubMwZ4T1ydpjk99bAcb9KFnubyQ+Dt6o5b0OvXnB2jEEchdCGBe2yZ5kv8A
         fmLowUNwxr8YJiB+2VN2y0TBKQQQUKI/iIlmivwahk1pxHlqHbMY699XXVeziNl5cXHM
         VSVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5YwC7L66uqVFhY3tbYKsI7ujF62AoXiYHYu6qbNIJ+WziWcUr9aWHUScmcYE+2oHMbYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZzgKkLp1Q6G1RLpjlWiR6MMT8TI/00TIKwY3mJQaJZNGiCNiU
	HiqZvQFGH6ZTIBgKKCEwLT1C+zhcbC/V63JKCor72zhUuuW/ZYpUD0Uy6MAlTI90RgQATr8ERCY
	N
X-Gm-Gg: ASbGncs4tvkTfYxXETC4xlESgPSpVy3MGV1o5EvA9vMrXlN5hi8MELGmEyQoTVaAgqc
	XasQYzGrW7XcWjqG8eGcPKPRH8iX8Rv+9qfjvXUyOf9DfyM0DiSoUcB/I082SMWs8Wbe69Pc8Eu
	Cqc4NAISiYoLyfja+fASwLMkrajBivuKEMrHkZmQTbNg55Fuxev6Gf0lIn28sL+k6Vt+d5NT2PQ
	QnfCQHXPLLmhuSWjBdR/pjwQAKpV8pWBw52TumeXsk1/Ku1umYePGb/BmGufskrSwqJIrBVkwcq
	Kr2zpO3yOd/+tNunBlNmnaTanIMkGIF9MUUtAdoD5KPdF/ZGMokHym3EEV/dVC9lmxEcLBzhPUo
	Xxj63eLvqtFBnhpbdHXJxUSk=
X-Google-Smtp-Source: AGHT+IFJv2VKJVF3sJgYhhzA9FBYArmfZ7PXOj7cyhcrSMi7zm8et7dAkTfcteGLdGyLQRUjbmM7+w==
X-Received: by 2002:a05:620a:4452:b0:7c5:6140:734f with SMTP id af79cd13be357-7c69071a80dmr2026357485a.18.1743551546641;
        Tue, 01 Apr 2025 16:52:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5f777e02bsm720145285a.110.2025.04.01.16.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 16:52:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tzlP7-00000001SiZ-1Xz1;
	Tue, 01 Apr 2025 20:52:25 -0300
Date: Tue, 1 Apr 2025 20:52:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	nd <nd@arm.com>, Philipp Stanner <pstanner@redhat.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Dhruv Tripathi <Dhruv.Tripathi@arm.com>,
	Honnappa Nagarahalli <Honnappa.Nagarahalli@arm.com>,
	Jeremy Linton <Jeremy.Linton@arm.com>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250401235225.GA327284@ziepe.ca>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250401141138.GE186258@ziepe.ca>
 <PAWPR08MB8909781BE207255E830DE1589FAC2@PAWPR08MB8909.eurprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAWPR08MB8909781BE207255E830DE1589FAC2@PAWPR08MB8909.eurprd08.prod.outlook.com>

On Tue, Apr 01, 2025 at 11:38:01PM +0000, Wathsala Wathawana Vithanage wrote:

> > Really we can't block device specific mode anyhow because we can't even
> > discover it on the kernel side..
> 
> We cannot block users from writing a steering-tag to a device specific location, but
> can we use a capability to prevent users from enabling device specific mode on the device?

qemu could do that, but the vfio kernel side really shouldn't.. There
is no reason vfio userspace on bare metal couldn't use device specific
mode.

Jason 

