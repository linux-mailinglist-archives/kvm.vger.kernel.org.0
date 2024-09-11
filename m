Return-Path: <kvm+bounces-26510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF1897545B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D8D71F269F0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F6E19E980;
	Wed, 11 Sep 2024 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwgnRavr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C7E1A704B
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062055; cv=none; b=sKFYWXLTmoaVQ2zzoHaLvWreJ/LGCPeymOT4YaKfjgemvbEO9SqXEdmnKDkGq2gzFr3eMpu3lG/ZHGlQ3MgLxhdkwXtMF62giPP3z4TL4CHkHRnCjCLHeSemvv2ZoMFZVVyAGnLXd+0KLF7mV0+bFSLE/XyNxoS7OF37X/fDmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062055; c=relaxed/simple;
	bh=yvPIK3dJ8RsWPzerUzVgZiq/JOY6U2/kNH5HEGIlabg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHyutuMOeF+zwiVcszIAlNvs/q0RrGXNZZhom7vTDdQPMyjfIiXuSf/Yrr3mczolP6/6oo4Jql2HTR2l7gs12X1i1BXNbrJikJS1+7xaKdghLfPoXY0W+xFfCYh0EjiqvjNQ95Q3E+TucnpD+OUEtcHCk7T0znsmBKj/fQqsSQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwgnRavr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726062053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4cGYuzEcsU+H11W5DX5/hXv+/XV9V+6iflAKbWezCQ=;
	b=PwgnRavrCSkBydV8h7ly1eFoCBI8fAJOXIzwXKyfLlUFPS+ztiv/hoMjmMye1/ZYu29UuF
	xyY3eNxMoyAPDhltXDP8KJ56UNguaFu4TYk8TEb161NP19+Fd1ZKGLD+wIO3i2K/OxNPdR
	TvLsEGA8lKpOXqdEdieB44E39LSFSaE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-WYKnV5kBN6yNOQclWCp1xw-1; Wed, 11 Sep 2024 09:40:52 -0400
X-MC-Unique: WYKnV5kBN6yNOQclWCp1xw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4582790fc3cso70234061cf.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726062052; x=1726666852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4cGYuzEcsU+H11W5DX5/hXv+/XV9V+6iflAKbWezCQ=;
        b=HlTR3OWqniwxXbj+/THc10cqW0r0XlvUMJV3Cote1JF0M67oobSbZFmFXPLsHwQef/
         3Rk4UpsxUJUF8KdsNopFLxwedHlpL1+O75bYVz4RDtEIi0gIQt0oJ6hCp91u6JVBlJCm
         5MPQg3TRPq1Zk+vpGzy/1tc+5GkV77yEsPERAv4FuIxcAP53hbh78A2zO6JDQzD3KxLj
         pzCxaEYMn7Xo4o1C7BVvNjcLUGCmzcqdDlnhYeM5vFQFlpM6EckOJefr/L8syraYidax
         hVARnb5iIA+B3sWuysDiY+b0oo9uyRY3umjlPcd0r5tt0NSWgYex41IX9gMWhGTrC1Br
         2A9g==
X-Forwarded-Encrypted: i=1; AJvYcCUbAL8t2BiRB9XC081ioXlQf1QgkrAcOW7Q6gJb25aA+4xJM6k6xE6IMfKpwYqdsEmQZ6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRdjBzwlSe+MXqkA7d5JpUacUZ2mE1GYalCPVAsNBCr7dVpbSR
	ylgwEb/JnXd2hmurBPq3l79f9sopBIwquitnByouIbm76dm3g05+5WjDFKuLMYkRUeo9SBysFJ2
	gL5JIhKjpnvae1z9FZg5NxWP86c7TgeZVhVol6465kEyDkf8Smg==
X-Received: by 2002:ac8:57c4:0:b0:458:59e3:2b52 with SMTP id d75a77b69052e-45859e332abmr16950081cf.55.1726062051415;
        Wed, 11 Sep 2024 06:40:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9OJUDpC/dDLPTaAj7vE1LX91DjdMwKKxOTbejPT9DFiRR1lsGsySzd/YLuGZUG3kBLFK7Vw==
X-Received: by 2002:ac8:57c4:0:b0:458:59e3:2b52 with SMTP id d75a77b69052e-45859e332abmr16948861cf.55.1726062049492;
        Wed, 11 Sep 2024 06:40:49 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45822e60974sm41358491cf.8.2024.09.11.06.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 06:40:48 -0700 (PDT)
Date: Wed, 11 Sep 2024 09:40:45 -0400
From: Peter Xu <peterx@redhat.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>, qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>, Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>, Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>, Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 21/39] migration: replace assert(false) with
 g_assert_not_reached()
Message-ID: <ZuGd3bcawih4bN9Z@x1n>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-22-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240910221606.1817478-22-pierrick.bouvier@linaro.org>

On Tue, Sep 10, 2024 at 03:15:48PM -0700, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


