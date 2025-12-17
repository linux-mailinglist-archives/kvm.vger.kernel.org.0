Return-Path: <kvm+bounces-66161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41BF8CC7627
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21EBD306EF4F
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B928F33F396;
	Wed, 17 Dec 2025 11:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+S8XTh3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C643376AA
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 11:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765971118; cv=none; b=r8vRDqazos4geAarrgoRhFr8A3iERLbajhfJ4H1aSgpo6VL9/2GMu1mbVueXAIdaZA4GWk2kzhUwaJiDhjo+D+69pQRUmvdZa3Sk/DEIAHbEc5q6VbVHTc0ReC6NgPB1BMH2rxtKXuB+vxAQ1ZY0/t0MFVREL0OYr3bjh7FXOdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765971118; c=relaxed/simple;
	bh=WWR9gWmfzJJUm/8qZ/R9mO6JAgdvbtUGwd6KxTufjTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y06k9qLAgs2m3YaCIkI9hFIqKIhpK3kB7eEwY3hlDlB0PW5a9xH/MP68e6dYUOt8kvRJMBV7UeFY7JxbHPI4KyvQWoJ8F6D0gjRMAaS8A9ijNnhYt8ubDrBrIfFInBeiFQBnic3grnRnkinsEV+Wy82V3tqfUxxluYjMWqwY2AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z+S8XTh3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765971112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=utlboXMWFbKjJ4Ja62RPro+KLr0GKtroK9EXHjy18B4=;
	b=Z+S8XTh3cxhyklXfrp5RsRzHrt4EvhIxPGVzOTCmemdXUb2VNzAo2E+lMP31gSEu4r30a1
	ZeaPMgsp/FWFy8IML0O6Qebv43thMmrkG4T2Wqh+/qfU4lFicjjbrsutaXPTp8hEGffZo9
	153S81JiL2wDstigrbfliUK1tobkjtk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-19-TBiTx8LmO3C6ritlfnkt5g-1; Wed,
 17 Dec 2025 06:31:49 -0500
X-MC-Unique: TBiTx8LmO3C6ritlfnkt5g-1
X-Mimecast-MFC-AGG-ID: TBiTx8LmO3C6ritlfnkt5g_1765971108
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0291E1800654;
	Wed, 17 Dec 2025 11:31:48 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD43330001A2;
	Wed, 17 Dec 2025 11:31:47 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 4C5A31800869; Wed, 17 Dec 2025 12:31:45 +0100 (CET)
Date: Wed, 17 Dec 2025 12:31:45 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 10/28] accel/kvm: Add notifier to inform that the KVM
 VM file fd is about to be changed
Message-ID: <5x475itwwdwvhclkebegp65gaqxx6lsezi3xhpg7zkwjogcyxa@zuqq6e2ar2ji>
References: <20251212150359.548787-1-anisinha@redhat.com>
 <20251212150359.548787-11-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212150359.548787-11-anisinha@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Dec 12, 2025 at 08:33:38PM +0530, Ani Sinha wrote:
> Various subsystems might need to take some steps before the KVM file descriptor
> for a virtual machine is changed. So a new notifier is added to inform them that
> kvm VM file descriptor is about to change.
> 
> Subsequent patches will add callback implementations for specific components
> that need this notification.
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c    | 25 +++++++++++++++++++++++++
>  accel/stubs/kvm-stub.c |  8 ++++++++
>  include/system/kvm.h   | 15 +++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 679cf04375..5b854c9866 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -127,6 +127,9 @@ static NotifierList kvm_irqchip_change_notifiers =
>  static NotifierWithReturnList register_vmfd_changed_notifiers =
>      NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
>  
> +static NotifierWithReturnList register_vmfd_pre_change_notifiers =
> +    NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_pre_change_notifiers);

I'm wondering whenever it is better to have only one vmfd change
notifier list and pass the callback type (pre/post) as argument?

Less boilerplate.  Also I suspect there is significant overlap between
the users which must do some pre-change cleanups and post-change
re-initialization.

take care,
  Gerd


