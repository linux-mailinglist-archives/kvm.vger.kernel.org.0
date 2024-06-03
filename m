Return-Path: <kvm+bounces-18678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A293C8D879B
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 19:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41D9E1F22DCE
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 17:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C07136E28;
	Mon,  3 Jun 2024 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7lNhp7A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE52D1369B1
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717434356; cv=none; b=byidt1SGnYEqRCKxFr7FhSjSuppx33r24W1WjE+3l2T2mC6hgX5F6jL11o0dY6FOuVJ33rRQLjbz+eeKV9QRIJEGN/GxLAQrfB+e59L3BMOUoTtHqERAHp+zw+Qrt0IJjuKX7Np1H8KxJmsB3zBiA/Z7YAj22RGjrl2WTawvOyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717434356; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib01e76hp+AskHKlCYoWrggSixeJpn/Lh5+5jHckxNa029WqDYrV8napa5aH/ld/Djp/W0BAP3+bGlskBrY1aVLq8VyxVSCmVRZ0x/HseAyfRL3A/Np7b0D6GyFLqBjx1SuQk7mbBhflvd86ldFpIt5am9L3xsoI22vnhVtTrlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7lNhp7A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717434353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=Z7lNhp7AsMR1M/1iqWYKoE4K+5+x6vWbXNI7dm1XnOqp4v35emPgEL8dIO/wbIW/M2NYDB
	urkrI4ZR5ax6WeDOPkmVKz/0a0OgGLaUpQhktkHUY2JkATYjdZBgTYjlklPsw3AWxjeva8
	UrHXwXVC3U3XA2iDI/Kqevz5X2eIJmY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-uhUQv5t6NpGapgPUOR69Ow-1; Mon,
 03 Jun 2024 13:05:49 -0400
X-MC-Unique: uhUQv5t6NpGapgPUOR69Ow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4F133806701;
	Mon,  3 Jun 2024 17:05:48 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C4245624;
	Mon,  3 Jun 2024 17:05:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	nikunj.dadhania@amd.com,
	thomas.lendacky@amd.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	michael.roth@amd.com,
	pankaj.gupta@amd.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	santosh.shukla@amd.com
Subject: Re: [PATCH v4 0/3] KVM: SEV-ES: Fix KVM_{GET|SET}_MSRS and LBRV handling
Date: Mon,  3 Jun 2024 13:05:45 -0400
Message-ID: <20240603170545.11817-1-pbonzini@redhat.com>
In-Reply-To: <20240531044644.768-1-ravi.bangoria@amd.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Queued, thanks.

Paolo



