Return-Path: <kvm+bounces-26509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C163F975454
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47CDCB29D1D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412941AB50B;
	Wed, 11 Sep 2024 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVGGHDEP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E436F1A704B
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062026; cv=none; b=SIYZMG8rHBS3PLLeXid7bubFLcbqjQYlgvhVxoZFQBospKQUcT7ttM+6O/0JoyjR6g1pGgksMqCNk0SqxZwP3ZBHGEc51kdnh+6t2gJCxZRomNk6zCz4V9wE0/YBts1G0SMdR/Hj+4IdOMG/cczohz06Bfhd6YIfYhUCwDiflUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062026; c=relaxed/simple;
	bh=IflGPQtbT29hOYsmEmelqfK3S0m6oxtsvz7g0LGIE+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGJqp12Ti/5gcz3k9ksAa92Ma8J5mbk025O3/0S3K/DIolR+ygeTpmf7Nc/xVnnYLP8bPTHziePNuaWi+8G1n6JPe7tRE5S5uYgjZsfUru51JBptnQnJEBrCRXlUicxfR+LLhh4nkr3mPaEWvflIK6hafewOCr7xPSbiosjAM2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eVGGHDEP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726062024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ylLQ46RRK0r8akuM+MAjQ7YJk+TYPgJnv3CN/nu5zsE=;
	b=eVGGHDEPc5a8DkwGfmKE7+AG+yoLH+efvWH90X1hZTX1q8iK9/B1vXbQganP9CG+Q9LJOb
	NUyQpUtlNwat7BIBhqDgLySnRst5OwdEMUTGNTd+mIWa0OnEqn5rmi9OrkPvrImimqtvLK
	Kx3rsz6leWevoGfrenwep+Y/Z4KkCd8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-pwiYDgJ7Py6DaexC48KdWg-1; Wed, 11 Sep 2024 09:40:22 -0400
X-MC-Unique: pwiYDgJ7Py6DaexC48KdWg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a99ec76780so514228885a.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726062021; x=1726666821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylLQ46RRK0r8akuM+MAjQ7YJk+TYPgJnv3CN/nu5zsE=;
        b=HRUaLGKDMytZzsqQdbe4uAf3I0u1t/MsBKA+0J39OyEBSmHOIdNpRUMhD2MxuRwuAq
         1x4DTP6113LjfCZP4bGSazAPRya/PxDN0qgbSzYlPQjgPT+dLJH+uvvGiCiwieftf8ZT
         vzE8s5Ahd+z2gnJV50QkkYnuzQXWU0NuaI4maC3YI6aMpzgKYeSDTc2na1uJ+4zih5OS
         64ZyxCjRygsoMjSBRKgfbo3N7RIfCeq0rwLc91F5AHc4oIQWrOwyM8CWjLzZEXtqIbBJ
         oDOg/BwbZghRgF21GEVp74ALCK31pwfz2B2Bt0poSe/ZFuDqfoYkv2TlCv3vgxHS1qnD
         V4ig==
X-Forwarded-Encrypted: i=1; AJvYcCU/FjiUERC9Jzwg8zyBSmDH25Ri3GMUa+/gByOlPNuMf3qdBoD73mU0e3i66pHLizJRVA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoyQm1P6wB4ILbNr/Ny/+ctCg2FfjcCTOxuNZyT+KN01QKiinS
	W0YxuDMo3/uQpv905dagq4hrX1HWmX8qAaW+4t2tPnK4D4b5HUAV01r45pKo8Pihi+twWnW/tsI
	+E41PqdcxQWx1uJRGmWc1f9V9MQbwmnYyIMDUzcipHeke0zFPcA==
X-Received: by 2002:a05:620a:2454:b0:7a9:a6a7:dc2e with SMTP id af79cd13be357-7a9d3a7a33emr403696485a.26.1726062021425;
        Wed, 11 Sep 2024 06:40:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFe+qt8pwlXDK0mfZ+LtyxQgEnpZe0Z6LEhOSLBDwBTuJnhTlFofajkphGOvjHQEd/U2LJQ2A==
X-Received: by 2002:a05:620a:2454:b0:7a9:a6a7:dc2e with SMTP id af79cd13be357-7a9d3a7a33emr403689185a.26.1726062020970;
        Wed, 11 Sep 2024 06:40:20 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1a8d5sm421889085a.116.2024.09.11.06.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 06:40:20 -0700 (PDT)
Date: Wed, 11 Sep 2024 09:40:16 -0400
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
Subject: Re: [PATCH 08/39] migration: replace assert(0) with
 g_assert_not_reached()
Message-ID: <ZuGdwMYENxER2r6-@x1n>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-9-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240910221606.1817478-9-pierrick.bouvier@linaro.org>

On Tue, Sep 10, 2024 at 03:15:35PM -0700, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


