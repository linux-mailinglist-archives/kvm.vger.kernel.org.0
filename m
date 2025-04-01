Return-Path: <kvm+bounces-42318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B10A77A6E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 14:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 316CE7A30D2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 12:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E81202C56;
	Tue,  1 Apr 2025 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="fisZ3jnz"
X-Original-To: kvm@vger.kernel.org
Received: from forward202d.mail.yandex.net (forward202d.mail.yandex.net [178.154.239.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209B01EFFB2;
	Tue,  1 Apr 2025 12:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743509614; cv=none; b=hHkruCeO2kpnKFSgUeo8JN0mf7H1daKJPB+LOSO5oYiEkg4C5/7VO4dZXfOIhw6JXV5IC0oVvOu7POnhPEE7quNdPXYHRFJh6PBbTKdw3+QrCBocE8O50+CovImcUNcAW3v89dLB4GdlFPoqX+Aa9zlbOT6S5Dvr9C1QoTUKtdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743509614; c=relaxed/simple;
	bh=gosLivFXhj046ky9eWUcHHw7kQlvB5J1NKr+Dn7bgac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrZ6yUjfuw3qT5OAJXipMxPRpZkELTuMUpx86NJ96529KvAjPpCEEVnsjXjm0pRjL6A5jRMym5FW7PtNCr8lN298a3oG41TEtoCskvCweyINh0Ke5DUCKekbeaFS5ho0R655f3jAPwGbFmF9W5GVnF7MoZjaRNeVtq9fjIKYPxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=fisZ3jnz; arc=none smtp.client-ip=178.154.239.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d101])
	by forward202d.mail.yandex.net (Yandex) with ESMTPS id BED7A646BB;
	Tue,  1 Apr 2025 15:05:19 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-95.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:3b21:0:640:4c47:0])
	by forward101d.mail.yandex.net (Yandex) with ESMTPS id 626EE609D6;
	Tue,  1 Apr 2025 15:05:12 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 95Viu91LimI0-6m501TPu;
	Tue, 01 Apr 2025 15:05:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1743509111; bh=NOvvSteE+IRlO1alOipjrY3OnJ73k91C4PJic3TK5qA=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=fisZ3jnzy+7lU47ulRg/MWbErp7pvcHvF376c13FH0vRG2GHukQSRis7h/njZoSZ8
	 1+TElSYkf4U4OndGZU0aKJEmN8ltxrH0rftCLzQOfOIXBXeMDQ5cbbcrYIvFuLfWZi
	 vKjwyeuVaxVu6E7zRkHJJUq5GMa+q2z5anjxszRc=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.iva.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: Sean Christopherson <seanjc@google.com>
Cc: Mikhail Lobanov <m.lobanov@rosa.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH] KVM: x86: forcibly leave SMM mode on vCPU reset
Date: Tue,  1 Apr 2025 15:05:05 +0300
Message-ID: <20250401120507.48218-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250324175707.19925-1-m.lobanov@rosa.ru>
References: <20250324175707.19925-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Gentle ping on this patch:  
https://lore.kernel.org/kvm/20250324175707.19925-1-m.lobanov@rosa.ru/

Sent on March 24, still waiting for feedback.  
Happy to update the patch if needed — let me know.

Thanks!

Best regards,  
Mikhail Lobanov

