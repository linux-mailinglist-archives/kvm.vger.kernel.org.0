Return-Path: <kvm+bounces-66317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F14BCCF8D8
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D9D493016ECD
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E1B30EF95;
	Fri, 19 Dec 2025 11:19:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from movementarian.org (ssh.movementarian.org [139.162.205.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AE62F6199
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.162.205.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766143143; cv=none; b=fkNm2Y5gFsfWDBTMz/erS74BoFRUlOLYbmEBPFGzjgsO5M1UEzAIOlOOZ4HCXRBkXY074YXS0wRPIMYTWQSpil/u9BUbccZxUYVUMRLht4sL/I+eZZ1sTav6lJLf0kOh/53kgUQr68qOvD/hhiQbbqWvt2/QIpRiYw8e8xpXts0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766143143; c=relaxed/simple;
	bh=H4A2zXrMlc8wNWYnhwCQMBkOYa5zrg7uPyoA3MGcdic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cebjDGMhgQrmAUspAfa17fn5/OtKAvGc8i0Xcu/sNxoK3dI/6kus129uIoaYbaOGefmeLVf7WT9xlIazRmOeUUGTaztHwa4NhQtsn6lutuR6BDjZ72V7CPDUsC8uo03vWmeYQ78DChZ4uS5GDuz+oGAgAkxkgMc/zwQJ9O0q5ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=movementarian.org; spf=pass smtp.mailfrom=movementarian.org; arc=none smtp.client-ip=139.162.205.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=movementarian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=movementarian.org
Received: from movement by movementarian.org with local (Exim 4.97)
	(envelope-from <movement@movementarian.org>)
	id 1vWXqr-00000003NGR-3ibE;
	Fri, 19 Dec 2025 10:36:49 +0000
Date: Fri, 19 Dec 2025 10:36:49 +0000
From: John Levon <levon@movementarian.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thanos Makatos <thanos.makatos@nutanix.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>,
	"dinechin@redhat.com" <dinechin@redhat.com>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>,
	"jag.raman@oracle.com" <jag.raman@oracle.com>,
	"eafanasova@gmail.com" <eafanasova@gmail.com>,
	"elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Message-ID: <aUUqwf4GXHHXYJ9w@movementarian.org>
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com>
 <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aS9uBw_w7NM_Vnw1@google.com>
 <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aUSobNVZ9VEaLN79@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUSobNVZ9VEaLN79@google.com>
X-Url: http://www.movementarian.org/

On Thu, Dec 18, 2025 at 05:20:44PM -0800, Sean Christopherson wrote:

> > Are you thinking for reusing/adapting the mechanism in this patch for that?
> 
> While I really like the mechanics of the idea, after sketching out the basic
> gist (see below), I'm not convinced the additional complexity is worth the gains.
> Unless reading from NVMe submission queues is a common operation

NVMe over PCIe, 3.1.2.1:

"...The host should not read the doorbell registers. If a doorbell register is
read, the value returned is vendor specific."

So, no, not common for NVMe at least.

regards
john

