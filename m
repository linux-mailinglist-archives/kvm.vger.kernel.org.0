Return-Path: <kvm+bounces-66162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 394DFCC7762
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 13:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2B01A301C52D
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF7634FF4E;
	Wed, 17 Dec 2025 11:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gw/tROH0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DB834EF1E
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765971391; cv=none; b=lJ9taDUUZ5ARJTwqxVF7EuZAU/4rd8cZVWgiGEO5DQCwCc1PMqELUiGo/x9EWKjEhePAjPSaSYJsEQ5Qe/5JY/ge9jRmzvbBvDoQpWog2Neqvzrb+DmrBGxhne8wnpfcVCKfnTFAib8McxO9oeul2RkeOSYkUxM2LfERupBWg9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765971391; c=relaxed/simple;
	bh=zwEeikvBjry7TtJ8iKORq2A59/dOtCdfOa2q93Qn8rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRYeHHg11dHLQPfCrcMHLmiLe7w/SpWKsKYM+Qemmw5c7p0wqz3pvUadwBi+CIeXvihvEqM+9d/2I39q2Cc0WOEmwYEFQitCNJeYgRtjKVg0E5SvgxjA2yotgDVC/Dd6pEQQnyEbeovweVXgkU+4EvtKzQ6+RWOt7Npf10/CAlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gw/tROH0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765971388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6qIZ34esG1c6ZVBCQVE14sm24RyVINchDFCkdTTRXKY=;
	b=Gw/tROH0MKy9WiFKTsPVTekY3s+Yq0vFrYM3dhZ2l5VRgPxc2lgwGWFE4aMx/TiSuMxJwj
	WFNJzu4aDiml3ieXJK/aEMwsOklp0wNDCRnsnZF5FPXVwRtlzdavPwHdZC6S8eHGMYL0Rb
	ymzrpMlveAg5Uob39vQIoxAp7u4Z3es=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-Mfhed5YQNtSX-Yw_i8PhqQ-1; Wed,
 17 Dec 2025 06:36:25 -0500
X-MC-Unique: Mfhed5YQNtSX-Yw_i8PhqQ-1
X-Mimecast-MFC-AGG-ID: Mfhed5YQNtSX-Yw_i8PhqQ_1765971384
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93D2918005B0;
	Wed, 17 Dec 2025 11:36:24 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.156])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32D0B1800576;
	Wed, 17 Dec 2025 11:36:24 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id BD75A1800869; Wed, 17 Dec 2025 12:36:21 +0100 (CET)
Date: Wed, 17 Dec 2025 12:36:21 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, vkuznets@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 13/28] i386/tdx: finalize TDX guest state upon reset
Message-ID: <ubmc2igckwxxpgw3zq7lmrhztygazibobjq3ruuhr3kbuzhfpr@odnoz7izs4hn>
References: <20251212150359.548787-1-anisinha@redhat.com>
 <20251212150359.548787-14-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212150359.548787-14-anisinha@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Dec 12, 2025 at 08:33:41PM +0530, Ani Sinha wrote:
> When the confidential virtual machine KVM file descriptor changes due to the
> guest reset, some TDX specific setup steps needs to be done again. This
> includes finalizing the inital guest launch state again. This change
> re-executes some parts of the TDX setup during the device reset phaze using a
> resettable interface. This finalizes the guest launch state again and locks
> it in. Also care has been taken so that notifiers are installed only once.

> +    if (!notifier_added) {
> +        qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
> +        notifier_added = true;
> +    }

Is this notifier needed still if you finalize the initial guest state in
the reset handler?

take care,
  Gerd


