Return-Path: <kvm+bounces-10618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BCD86DF1D
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E05141C20DD2
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DD46BB2D;
	Fri,  1 Mar 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FlFi8aYF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254736A8D4
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709288241; cv=none; b=DmMO1LnbjlbJzb+FhthdELDeGoPbcMVEqoQ9dorFRTXaCe9V4iviEZiHy1xbnJAvNuFdpaWPBg0/Lh2xPuJWSw78GTGi7pURfKn4cccTmL4CjXWa+zqnp0KUzR680dC9iNq+l8wIZLGsv1YwJCxOnTX0gCriPDlfXsMrBpIutkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709288241; c=relaxed/simple;
	bh=7JA6PfkuK1mc2d5VkJ9n0JNeSeCRZrkU0Jl1tTJEoG8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lMS1J5AycTgzraNArsSMUXL06icdQoJ5HfURSVBVop+myb9bPcLAJZyB7/mnfh0LV6/aeZcpgEp4NgILBv8Tq1g4g81C0ZuPeM0RlUXAxv63y5WDw/2qEIeO1E13BPwJcdYVTkgwar5spUuNzg+OmoaknoIdv/J+AUWNJk6S7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FlFi8aYF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709288239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4J6rEqJBkCC60PIxRAp1B56NSk+P6kQFPzL/uAnbbpk=;
	b=FlFi8aYFObJejLOiqgFAVyL6hEV3PFggMQVAz/Xuu66zM1XtqsX/+iTbt+GtW1Uguj7gtU
	a5cDKhcFH7p7cLaXVtHOxlltsTW9OsSzA6phaosGi74wPDq+SjXKgZ1EUKLMLmhBwdztVy
	SM60grtjMRs6Pci/92pn4O8IpLA+nvk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-EH-v6C7EOWKSe5ArRQepjQ-1; Fri,
 01 Mar 2024 05:17:15 -0500
X-MC-Unique: EH-v6C7EOWKSe5ArRQepjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D7A728EC110;
	Fri,  1 Mar 2024 10:17:15 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.121])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2C252166B31;
	Fri,  1 Mar 2024 10:17:14 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id EA21E1800DFF; Fri,  1 Mar 2024 11:17:13 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 0/1] kvm: add support for guest physical bits
Date: Fri,  1 Mar 2024 11:17:12 +0100
Message-ID: <20240301101713.356759-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

The matching kernel bits are here:
https://lore.kernel.org/kvm/20240301101410.356007-1-kraxel@redhat.com/T/

Gerd Hoffmann (1):
  kvm: add support for guest physical bits

 target/i386/cpu.h     | 1 +
 target/i386/cpu.c     | 1 +
 target/i386/kvm/kvm.c | 8 ++++++++
 3 files changed, 10 insertions(+)

-- 
2.44.0


