Return-Path: <kvm+bounces-45960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41551AAFF91
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B90A94E27FC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BE414D29B;
	Thu,  8 May 2025 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JrNUSED4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE0F198A2F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719475; cv=none; b=gU9yM1emDplXHDl3zynURkiKjEfWRKHwJwi2EbV84kgCgJzMnKGZSnTQpipmQD/u697aQqYZpgeK1FLw8XWTLEWPtDtHVpzRQ0kUQf5rWw4ZTvcD65PnJO8oEnao4wR0Hn1hbpoUpTaYAnmtOxwVYWSKWn+zPiLE6SdVzgSBvSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719475; c=relaxed/simple;
	bh=J/6or8ofJgemWvG3DQDAX11ffWRhdCTsJgfp/vjGj/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGAWG4o6T7Y82ljK80x3lsIYay2MMpuIIT1Vu20J8VsR3bpPBkNt9o1iUYLZNmx0rXBLY88Iu1fNmDkLfARAzKs4XPDMoXAXUtZfWEuiHdYaNZMYSI45hNeqPF5oYFmYXy5KCvPSmLiGUsltDiMMVC8E66TXHOg+QZzHv7lfzmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JrNUSED4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746719472;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eLbqO2QHhyIzTM9jdAkYzAdp9jCpj1hHf89BSXzft/E=;
	b=JrNUSED4KG2xjFc8AlYfZ7eIko+gIzdqn6FyZmsMWOUQYs/JyLU1lct13/lcfB6RIG8MIG
	YuryVKihgzdfoQ6S09WcubkeER9q7fl9B65bV8tTvf2t9oM3sLsOhYs1kLKrQDBEwFqzS0
	IBVu8y8KlwX4oVQ4EzcawRbBKzGWeek=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-H4MXQHguPJ2kHh5Q-c7lag-1; Thu,
 08 May 2025 11:51:08 -0400
X-MC-Unique: H4MXQHguPJ2kHh5Q-c7lag-1
X-Mimecast-MFC-AGG-ID: H4MXQHguPJ2kHh5Q-c7lag_1746719466
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B203318009B6;
	Thu,  8 May 2025 15:51:05 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.138])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79EFB195605C;
	Thu,  8 May 2025 15:51:01 +0000 (UTC)
Date: Thu, 8 May 2025 16:50:57 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v9 12/55] i386/tdx: Validate TD attributes
Message-ID: <aBzS4WVfrQNMMTXQ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
 <20250508150002.689633-13-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508150002.689633-13-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, May 08, 2025 at 10:59:18AM -0400, Xiaoyao Li wrote:
> Validate TD attributes with tdx_caps that only supported bits are
> allowed by KVM.
> 
> Besides, sanity check the attribute bits that have not been supported by
> QEMU yet. e.g., debug bit, it will be allowed in the future when debug
> TD support lands in QEMU.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


