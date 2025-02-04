Return-Path: <kvm+bounces-37244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DEDA27723
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A17221642FE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 16:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11142153EC;
	Tue,  4 Feb 2025 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYf7GfMo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4668F215170
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738686518; cv=none; b=u4K7o34aNOPQqJfzQ5Lz1N84xt4veyrrBwJNvWPVmVgH+n758NiP1KNoObSITmuzBF91IWfcAcp9wMvwV311gqWf7yMhWnOsPZabEoBXUuqTkd2lS8DL++x+yIoxnVOUG31JPpFv0jjTtye3f7cMTfEwvClgSqc92A8XyJ0dtNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738686518; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX3mhFDSiYAhSFeRNXRJBdjpIgWJJbh1hq3yYCf/QHB4b/g16bBfOg9NJ+GrKHUwK26aT5b2vdezePwgxhA/IPMZgJD4oP3gOj15NrgaYZhR8UbdWB7G5mEw/WFTLQfzFON0tVK+FHVxD9PEowl9w4yZU8NZUboh5bZ3STSnUH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PYf7GfMo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738686516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=PYf7GfMoNgGJXukG1Dd7xi1IvXOqDZW+Y3fQCxk0AtidZHnjwfFG7iXkw86hB8lejctpYU
	OqkxZJIqgDEIVl6QOKkKyea7JmRMgaXcpmomoh0UkQ+6MkQORKqA9F6ZueLLd8Cv9WJFzZ
	aAV/mf0j/G+CiHFKBw3EbHGPuFiGY+U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139-zmZ2R7rEPyiJPfSgrDE-UA-1; Tue,
 04 Feb 2025 11:28:33 -0500
X-MC-Unique: zmZ2R7rEPyiJPfSgrDE-UA-1
X-Mimecast-MFC-AGG-ID: zmZ2R7rEPyiJPfSgrDE-UA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51EEE1801F1C;
	Tue,  4 Feb 2025 16:28:32 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D959195608E;
	Tue,  4 Feb 2025 16:28:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is alive before waking
Date: Tue,  4 Feb 2025 11:28:29 -0500
Message-ID: <20250204162829.253475-1-pbonzini@redhat.com>
In-Reply-To: <20250124234623.3609069-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Queued, thanks.

Paolo



