Return-Path: <kvm+bounces-18741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F718FAE3E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75045B24DD5
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A836E142E76;
	Tue,  4 Jun 2024 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggM7905m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67223652
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 09:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717491808; cv=none; b=px+HLgZsNl9djza+CAnlkirXrU+OpxV346uDYoxsCLxpx6EW+Lq5sTKP3GksXoz2XxfAALMFT37Sbk44cetIkGkWXHCScPmC4qft2NedkrXf2y09L+DbFLex6b/u1TcklOB4bWh1tmkGr0TK7k+qQzndbVnPoay3/vKyNrblY40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717491808; c=relaxed/simple;
	bh=wGtnpxCl/x8Y+fCc0R+hEcfCheVS2NnOEDVgFgE3DZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eelxBabuvG+NknLjkpr8h55Q4cbABB8/EiUobl5Kmh1xT7dLyJza4L1KDht0Ff3VGCh/LPFQ3OiZqBvFWTcwKvIz0sA9xH6J54ytQeXuwOGzE13dYgy1ZbINGHXr677jo2tI55pfnkqFdV0+QH4RTBVrnpyr8xcMk4TNLA9w4pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ggM7905m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717491806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zTryAwAqFpVVeeFnolgKRJ1jpm4fqSOt2rryPRNNmtg=;
	b=ggM7905m/Q0JX7qYKD1+gZFISVBce+wNFLEtgoQ6qLexe69eOrOcO+0TsH/VWjW8DVSeOw
	xgsrvsb+Xm9dLU1dVN/7rRziBXpF8u0+iOZg6D5DtNFBlVV0fJ++NZp/S5rUfZyrOaXud0
	AKGgZOHKhSztTuz3Xorre+EnQsphSuc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-Zm8srSYdP5mU-GgZ412-5g-1; Tue, 04 Jun 2024 05:03:21 -0400
X-MC-Unique: Zm8srSYdP5mU-GgZ412-5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1810B101A521;
	Tue,  4 Jun 2024 09:03:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.217])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD4AB2028B56;
	Tue,  4 Jun 2024 09:03:20 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id ED737180098E; Tue,  4 Jun 2024 11:03:19 +0200 (CEST)
Date: Tue, 4 Jun 2024 11:03:19 +0200
From: "Hoffmann, Gerd" <kraxel@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org, brijesh.singh@amd.com, 
	dovmurik@linux.ibm.com, armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	anisinha@redhat.com, Oliver Steffen <osteffen@redhat.com>
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
Message-ID: <vcvfiqwhv7v3dhlmolz6ur4a62yfbyusihdzk5w7etyv676xmu@5xdmf7recsjz>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-30-pankaj.gupta@amd.com>
 <Zl2vP9hohrgaPMTs@redhat.com>
 <CABgObfapGXenv8MZv5wnMkESQMJveZvP-kqUj=EwMszTkg0EsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfapGXenv8MZv5wnMkESQMJveZvP-kqUj=EwMszTkg0EsA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, Jun 03, 2024 at 03:38:05PM GMT, Paolo Bonzini wrote:
> On Mon, Jun 3, 2024 at 1:55 PM Daniel P. Berrangé <berrange@redhat.com> wrote:
> > I really wish we didn't have to introduce this though - is there really
> > no way to make it possible to use pflash for both CODE & VARS with SNP,
> > as is done with traditional VMs, so we don't diverge in setup, needing
> > yet more changes up the mgmt stack ?
> 
> No, you cannot use pflash for CODE in either SNP or TDX. The hardware
> does not support it.
> 
> One possibility is to only support non-pflash-based variable store.
> This is not yet in QEMU, but it is how both AWS and Google implemented
> UEFI variables and I think Gerd was going to work on it for QEMU.

Yes, working on and off on it.  Progress is slower that I wish it would
be due to getting side tracked into other important edk2 things ...

But, yes, the longer-term plan is that edk2 wouldn't manage the variable
store itself.  It will be either qemu (non-confidential setups), or the
svsm (confidential setups).

Where we are going to store svsm state (vtpm, efi vars, ...) is not
fully clear yet.  pflash is one option, but we are also checking out
alternatives like virtio-blk (via virtio-mmio).

take care,
  Gerd


