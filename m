Return-Path: <kvm+bounces-11733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A93DA87A84D
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AF5A1F22645
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC224205F;
	Wed, 13 Mar 2024 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9bkdit/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0EE3F9E1
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336449; cv=none; b=U+flEPnMNZzc0S5eHG2Ufu5VZAXR38/j76FI7QaIqafshLFLYnvpxvwKoUphjfclaJff7TidgZv+s5DMmMjgp0pFXs1TQVm2rQtBMcx/789pCMeq8r+87hYV6HXEpwrR9pnSu1nbMJBYYcHTpw7BWQoi3HGV5Swtwn4QXBZdpQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336449; c=relaxed/simple;
	bh=X+FFda/HAzN+CXRfGlsRfJyLVOLXDmlzoA1UDN5zKgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=elV1aZNZU+iSzxj4+M0LWx0SNBxAy+44TP00Drugfu/8c+9kWpB4YSob8FAjzywmKCZT32eNMth+dcQ0i6bVLVvGRTnanhmRdVSbWO0GqRb3/tksyaiepOoIo8TqFEXQh7qCYocs00/WZJS2u3S8T7Kh2FyRYwYMpc3+qt0j8aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9bkdit/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710336445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i2FoqMaQzo/GdLSMIY49hQw5PLAPkceJeTzjFWHlnQE=;
	b=Y9bkdit/OnQ//KLh6rF99b/UEx8I46l5/yJ/aaAsGT+SjuG7y8XS87OlVaXqOz8Al18e4A
	JdTn+OogdvypvENp4KwUyeXvz6ndCQZ/WFz6PcDBu8AAFnQmLDi3IJp0lHdq/84HzlBTJ9
	i9YUNpJcWPTiIJIEtI47VjsXLDIIeZQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-LKxLcRygOjS1Ym_E__tHBw-1; Wed,
 13 Mar 2024 09:27:22 -0400
X-MC-Unique: LKxLcRygOjS1Ym_E__tHBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21388285F99E;
	Wed, 13 Mar 2024 13:27:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E77716A9C;
	Wed, 13 Mar 2024 13:27:20 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 6F06018009A3; Wed, 13 Mar 2024 14:27:19 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 0/3] kvm: add support for guest physical bits
Date: Wed, 13 Mar 2024 14:27:16 +0100
Message-ID: <20240313132719.939417-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

The matching kernel bits are here:
https://lore.kernel.org/kvm/20240313125844.912415-1-kraxel@redhat.com/T/

ovmf test patches are here:
https://github.com/kraxel/edk2/commits/devel/guest-phys-bits/

Gerd Hoffmann (3):
  [debug] log kvm supported cpuid
  kvm: add support for guest physical bits
  target/i386: add guest-phys-bits cpu property

 target/i386/cpu.h         |  1 +
 target/i386/cpu.c         | 14 ++++++++++++++
 target/i386/kvm/kvm-cpu.c | 32 +++++++++++++++++++++++++++++++-
 target/i386/kvm/kvm.c     | 14 ++++++++++++++
 4 files changed, 60 insertions(+), 1 deletion(-)

-- 
2.44.0


