Return-Path: <kvm+bounces-19415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F70904C84
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D1D7284EDA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999EF16C426;
	Wed, 12 Jun 2024 07:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5ndPZpB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4CE45948
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718176555; cv=none; b=ATgNhxIU6ymT/n/nNDXo193+XO8X1lqSxbDfJ88VG0eFkav7xLGM/nh0JB3BrssF2XpxCVzbKLrjj43QWiy1Rfg/Soarw/zD+dofq6XH/uezte6mN8P+gZ1OaUs2htK4FF0MiH74h1/ntD8va9zTqAxWsasWSrjOPCUWRPs/ZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718176555; c=relaxed/simple;
	bh=+ykbfSP9QE6LjsxeHl6HZt6oWo4XQ54KD3PrDqCfUic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPkwZsoI4h05M2bTVBl2Y8LaujPaASDZyDFa7ytS8UqGbfSG1jYsiiImaQJw8YEQQsGQ1HG+LSfWBLEFs1ZKdHTDkYXIiYmODu6+A2WqCvmG59teOf5rSUXuWkg4PJQ+tLumpeMOAUJh1aOYqUjfXlJRM3gr81Lrm/nnag3hauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B5ndPZpB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718176553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kRPQpXge3I0Vcd7b2iojqZfH1RINuN+3D+5eFcM1E+A=;
	b=B5ndPZpB1frYSlPmOsziG2EtG1EufaCCAS3WcRaMoRKGMszlZYJ4tX3vySzT6neNlaC+98
	z9vM3EmCr/ls5Mfajx933wvQJJWEqEdFCxaaRyBypB5zHfJ5OhZ3j0lA0cUc/n2ToTSL38
	2CsQYW+e4W2pZKbUTACxQMtlSWRv0j0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-3IHbHBe7OAaFFy_mAhjtvQ-1; Wed, 12 Jun 2024 03:15:50 -0400
X-MC-Unique: 3IHbHBe7OAaFFy_mAhjtvQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4210d151c5bso47153965e9.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 00:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718176549; x=1718781349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRPQpXge3I0Vcd7b2iojqZfH1RINuN+3D+5eFcM1E+A=;
        b=p8+K5obCipgeC5PYQGORnRXKxaOh8U9sKWI8m2vD2dCIA0xsRSTKpUAFmelE0Ko+E0
         g8o6e6P4bKO//4bQGX45TsGoHjvwNyC707nB90dyibLTdyByD+546AXtG4rRhG76Klgm
         87E/1w1dmDJVkLy+luaOVbTrHCop9ZnNXFmpeCvvldslDACY8IOwaNirVM/WVo9ze55I
         92iG1IZjnpu0ZgML+gybDt+yGDzXaw3aUzndKuz5YARzAEcmJE0NMKqR4psCwnxsDj4d
         Tk1Sd3A2TZTLZGBCQXkn+0caqL/9r2src5x6WqtkWCfLoxWA2G5udeuNPSqPEsrPt9Kv
         sy3g==
X-Forwarded-Encrypted: i=1; AJvYcCVO1k5sVumkj135iH5D3orKOAMmZXvYW6AefIVAXpu9YfuFPB55jIvh8WdytOqZ63QMWvUtIC2VekrBvWp8MJL+lmPn
X-Gm-Message-State: AOJu0YxW7wskeRAX8t4euyUUGkr6ZsMsHBL9JBA0wyQ+lP6xpvoJ2cp5
	dT8yZcWsuSRIxvvYYmuDpfzYdyN08xV/y8cg0eTPpvScjOBKBYNK5JDzkLbIzmVnRSuq8iHx3XN
	PVloknK4Wan1XgCfWfXqNCKGxx8FeKYZdxL7YWwCogZpthEuZVw==
X-Received: by 2002:a5d:5288:0:b0:35f:18ad:bccb with SMTP id ffacd0b85a97d-35fe1bfda3fmr603603f8f.35.1718176548895;
        Wed, 12 Jun 2024 00:15:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYuQ+XjKBy6z8bjJ/5ejaRe3tBk9OjBlBGeQH9fUUBsA31Sgruib/67gZGeejF7RYzsndo1w==
X-Received: by 2002:a5d:5288:0:b0:35f:18ad:bccb with SMTP id ffacd0b85a97d-35fe1bfda3fmr603573f8f.35.1718176548189;
        Wed, 12 Jun 2024 00:15:48 -0700 (PDT)
Received: from redhat.com ([2a02:14f:178:39eb:4161:d39d:43e6:41f8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f23a651d4sm7641411f8f.50.2024.06.12.00.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 00:15:47 -0700 (PDT)
Date: Wed, 12 Jun 2024 03:15:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>, Cindy Lu <lulu@redhat.com>,
	dtatulea@nvidia.com, jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240612031356-mutt-send-email-mst@kernel.org>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org>
 <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmlAYcRHMqCgYBJD@nanopsycho.orion>

On Wed, Jun 12, 2024 at 08:29:53AM +0200, Jiri Pirko wrote:
> Wed, Jun 12, 2024 at 03:58:10AM CEST, kuba@kernel.org wrote:
> >On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
> >> Add new UAPI to support the mac address from vdpa tool
> >> Function vdpa_nl_cmd_dev_config_set_doit() will get the
> >> MAC address from the vdpa tool and then set it to the device.
> >> 
> >> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
> >
> >Why don't you use devlink?
> 
> Fair question. Why does vdpa-specific uapi even exist? To have
> driver-specific uapi Does not make any sense to me :/

I am not sure which uapi do you refer to? The one this patch proposes or
the existing one?



-- 
MST


