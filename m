Return-Path: <kvm+bounces-40055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5634DA4E7C6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FAB4425C11
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 16:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CED2C2CAA;
	Tue,  4 Mar 2025 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Tlz/rsNV"
X-Original-To: kvm@vger.kernel.org
Received: from beeline1.cc.itu.edu.tr (beeline1.cc.itu.edu.tr [160.75.25.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD83E2857CB
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=160.75.25.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741106221; cv=pass; b=nEy75j5QbsILZrXmjNhQLat4VHGvrQWIvIkNWz8HBGdDJclXjK58Pw95vjHwdCcH1IF0hJAf2OiuJ7/9xdvWHnWbU7ROgD6HaT7TRvTZPxatBms9P7oW+kFfxHwr3Pnr5QOP200zl6nst6IzPtVWXgyPphyJuTF8acbRETUSYIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741106221; c=relaxed/simple;
	bh=FCkDWt+wTwZDcGN6QqEl9yLvHrIbg1v2Mer2UItZCz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9rxfDYrqG/O1yku1MoQ7KBPe75Q6JH/tHExlYSCkapp0ya4/oaMq+ewcXbmP9ETk5T9h6pFzsyAUc0D0qpa6jojPnreYbvTlqgC3AWkZSIbfQCfZJmjEdoE1CjitiEDQjACaaaFBdkT35+kFYn3VJIZNbWmm2t/inqaG4ER1SU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=none smtp.mailfrom=cc.itu.edu.tr; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Tlz/rsNV; arc=none smtp.client-ip=65.109.113.108; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; arc=pass smtp.client-ip=160.75.25.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline1.cc.itu.edu.tr (Postfix) with ESMTPS id 57ACB40D974C
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:36:58 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6h8s6QHMzG3CQ
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:34:21 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id 3DD794272E; Tue,  4 Mar 2025 19:34:15 +0300 (+03)
Authentication-Results: lesva1.cc.itu.edu.tr;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Tlz/rsNV
X-Envelope-From: <linux-kernel+bounces-541865-bozkiru=itu.edu.tr@vger.kernel.org>
Authentication-Results: lesva2.cc.itu.edu.tr;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Tlz/rsNV
Received: from fgw1.itu.edu.tr (fgw1.itu.edu.tr [160.75.25.103])
	by le2 (Postfix) with ESMTP id DDE3F41ADC
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 16:59:59 +0300 (+03)
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by fgw1.itu.edu.tr (Postfix) with SMTP id 73E5F305F789
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 16:59:59 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F8413A67E1
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 13:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D81A2135CE;
	Mon,  3 Mar 2025 13:59:44 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15414212F9A;
	Mon,  3 Mar 2025 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010381; cv=none; b=tY8fWaVh4C5Uix08fDTQX9zRPM57WJ5Ew4mFEZdS9U0RB8Dqcpj37IFJRA6KJBJxri7dS6unocJbyvQiEe3QX6O+WJW7mx+9smqa5CzNkEY+qmv+qbLKSLIhu/wjHzBOEu+KLqNZnJKspAfeJZiBEdQ6vKJngnwKkR0r4mIS0XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010381; c=relaxed/simple;
	bh=FCkDWt+wTwZDcGN6QqEl9yLvHrIbg1v2Mer2UItZCz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QV6oyKPh3NBt0HKctwrPp5Ffhx6mVyVRWc0Lkhgjb8lLC5j+CwVqmNljo7UpV92TLNDn1wypkFNEN7ldiU+Xj47C4G5LvNXcWZDmbvdTQfujXM+JxdrSWr7ZmqIKEKIFJfw6hmS9OFMl9nQsT4oPWTe6qPkhdH4X/hj0V7VcguQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Tlz/rsNV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E334F40E0214;
	Mon,  3 Mar 2025 13:59:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z8186o3I-Gwu; Mon,  3 Mar 2025 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741010372; bh=6saylgDZEGaqn8IRfv0exuo1BIZF6zZsttHwQyJfS38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tlz/rsNVrKyIr14dnSWB4zmg0dJM7SK1/pWrPNA+x6S6VZyRhCpVhpA3LKjc54sSF
	 roVNBUrvjx90Iu/L/IzSk6OFSqBAoMxxOwDvYIA34Uv7IYYphjUiokA7wySM2vTN/b
	 E+AoBaFl2poYpiXqCHxLqVBgKTzDgsYgVCbcHdbvt508vfth8luuBePJv72q4ozWpp
	 K31dtZffWfGZibBUjj3Y+pzX9jfHpwucMgha2lxVb0U8p08C7Z8SW+J45KTIR8PPdJ
	 e7RgrHcmWwHthszwd+Wxb51mgAJkUapU2ZlPy3b3NP3HkKh/aH5pZSSydUWjH7DlZh
	 MbRFB29lTe85L9/ENVBqJbtQbWSg7DaaqguGXJVJIQLGTAHXyoLeNX9kWejRndqDM8
	 09XYxoNyDrS1WLHiMjnoP3P7IJPnGhQ0+oljim1sg3yF0+VQ+osfj8XZS0nniEbLk/
	 vIOKbf+ePrxwqsovZk8iFO8Q+IzZNXOjMLh53wbYSOl+9cch7J7v5D0aiNUFtrg2/+
	 pS0jv2k+xmSg4iDaa1iOrUpqzgv0mo8ueB7sRSEVsvCYgzaujUtV2Sz3YC9OWGXXKb
	 h2j9TYmEVA93yWuZAUX+Ogj8GYawnQylvFBtEqAKoAg/Fc2QI0Efy45Wr99YbZk2JZ
	 p17gSiiljxrmLiJ/xnemlWeE=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9653640E01AD;
	Mon,  3 Mar 2025 13:59:20 +0000 (UTC)
Date: Mon, 3 Mar 2025 14:59:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250303135914.GGZ8W1skZjxqhYiJa8@fat_crate.local>
References: <20250226184540.2250357-1-derkling@google.com>
 <Z79wrLx3kJCxweuy@google.com>
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z79wrLx3kJCxweuy@google.com>
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6h8s6QHMzG3CQ
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741710936.59294@zyYb55kA8cTY2MsMuYwMUQ
X-ITU-MailScanner-SpamCheck: not spam

On Wed, Feb 26, 2025 at 07:51:08PM +0000, Yosry Ahmed wrote:
> To add more details about this, we are using ASI as our main mitigation
> for SRSO. However, it's likely that bp-spec-reduce is cheaper, so we
> basically want to always use bp-spec-reduce if available, if not, we
> don't want the ibpb-on-vmexit or safe-ret as they are a lot more
> expensive than ASI.
> 
> So we want the cmdline option to basically say only use bp-spec-reduce
> if it's available, but don't fallback if it isn't.

Yap, that should also be a part of the commit message.

> On the other hand we are enlighting ASI to skip mitigating SRSO if
> X86_FEATURE_SRSO_BP_SPEC_REDUCE is enabled

Yap, makes sense.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


