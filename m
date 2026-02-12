Return-Path: <kvm+bounces-70948-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DhKFvOwjWmz5wAAu9opvQ
	(envelope-from <kvm+bounces-70948-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:52:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C649512CB69
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:52:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E8A1230088AF
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AFB318BB2;
	Thu, 12 Feb 2026 10:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iG6VOS++";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9OPWJ6+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63A43164D9
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893539; cv=none; b=EFqlE2x4Tr+j90gsWhKmmOj/tju3ydHB7KYoOBTlR6i/Vg9t/ZmJ+uI3dlPQIwMSed+GxmCOsAtWXZCChOxpRLeZFDFWzw4/H0/cOtHWrDUf4ZOLwZcd/dVZzxByPx/N3kA5XiTDUbk1f57DPfKDWAN+oHVd66zarbU3dZQ5+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893539; c=relaxed/simple;
	bh=6uikcJfeqUGYyMJi7umYk2HPcxxaMWDrtdf37OotDFA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=DI4KXUodI8Gcr+XXOT4lovDfrXVCiOaKIJFgjhkvuyxtCAy4/iFYRNIAYnIoa3SY4JX3flK/W0ryYCp7VsF2x7JVMBI3W/SAuUUrSjCzD3xKE4VLBX+fujO4ANobbJQHubCSounr1oAvyE7QEMi/3MqBcOYk9DmAIm00VSJy4qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iG6VOS++; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9OPWJ6+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770893536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rSPnKRmG0j++c2xmDrAE4eut3cAgZi1Fs3m52TxdCaA=;
	b=iG6VOS++NnmhFSi4FXVgxBomRz4I3oEXzsOWjeX1Ml6COgVxodF+AeDmtSzZ+pKq4Ce6Bh
	3U0IgpCnlAQ1T4xnxwR/Ov397ikqWSO1Ltchv6qVZJW4sSxFi9cLhndJ5yf8cQsv2pxWNN
	6CjR47bjbfT4++mb8m0uxmAO2yMnCBw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-H2USfiPwOKe5ELIXqkn1bA-1; Thu, 12 Feb 2026 05:52:14 -0500
X-MC-Unique: H2USfiPwOKe5ELIXqkn1bA-1
X-Mimecast-MFC-AGG-ID: H2USfiPwOKe5ELIXqkn1bA_1770893534
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435a2de6ec0so3809647f8f.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 02:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770893533; x=1771498333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rSPnKRmG0j++c2xmDrAE4eut3cAgZi1Fs3m52TxdCaA=;
        b=a9OPWJ6+EduyMixbGb2ls8AdE6fjIW34H2cI9QuXxnc+rgRA/injKl8wpnkqmehtZ4
         VL1uSmP1NlIgE+dlPJoTcJ1H7dsK4hK3rRZd7mXX54rpF7mSHs9kDCE0EwAKHO+6UDZy
         IaISpPCY3IF/dHpHxQ5jvbG9UBNOOU0dlBWwQP4VCyhFxwVQVILpOzSQqcyh78PYoQvm
         aYZTiuvGfHR//CeyWEPJStz+ogNLJsfPA52mhy0LiUoBlps2Eieyl7xjuH6Lw5cDWWQp
         Ra1AxCdiNnJK1J+vk1yW92eg8a6jr1YsbOY04RSBIUUB+vr75rKsLZs3+4hbFonvHtib
         dlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770893533; x=1771498333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rSPnKRmG0j++c2xmDrAE4eut3cAgZi1Fs3m52TxdCaA=;
        b=luobkWS2ePRdEkB+2PseydJ4ZrfOMyy39MqFjsCzsRsQmIG7AlBzNrpPyquhfBCLB6
         ysk+xwzpGVZKTBYGPKm1V4GtX76WCb09gyJr2S+gh609vj/A7URB0Q9naqkhfEUX7D8Y
         p9VUxtjUBl0pCfI7+beQkbyxRSG9e7CrcVcEJ4ZaM6mpx8UJdE5ztkdh5xPxUocI/rKq
         C5I+hZKYoan1S0QxsPa8Yh1Serysbdj6rrEL5rO2Lj98/3HDOGNlSfV04S6dr5fiRK2+
         F8Iuk6odTuXQm16gE5EtQYkcE1oPREGyRvzebC3wrkQl0jAfcj+6DekU2vlklgfJoYOY
         Z7vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVghlbRbrwl9T041u6Rl+AhF/7IMISEIN2+d2ubYbkdaHsgzakqo06uV+370T2qkN5QMvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSfDGWiN2y6tzT3EJry8WtAdqdjK0Shl9EdXfp78HdsfhZd00a
	MYII6HIoNh3P55FHHsWk0XhwnIK+zSOVyfDaCeyX0oYd5nxtV8exp2vOY8h9mgEUpH86kZPibcq
	2ClVoKyb6rOc3bnDNKzAXJUUCfwjod0zYQavUwGXyp/am1ON4A6OvcKtGS+gSjQ==
X-Gm-Gg: AZuq6aKvoAAaSX1Mdal+pUG7KkeTT/AYI2Opi2a8fU5+gplIq/ahLez0xY6WFxPOPNI
	QIKEXYGjwqQCXTolehNx0TNves6o8B6X0ORaFhzPDrYnGla9i7xHIv91RH2LDP+N/tgx2TjMJ9n
	qz+5nw9JwSwg0R96TnZLDjYAOUbW9phtsAhVDY76Kxy+oXVeTl0tlyjB5oiTIkL+t21Bq3/Wihi
	n13QLzQGCNDQGR4L3iaSq+cKYNoUbcBP10uMOkegh61qWJcafD9i4hPipsu7wDFz3Th+3oYMPc3
	sJb4Kv2mjFfmYEZGrAqIX1KIdk8CkxA1zwd7hGnhRAW/g8u1LkpGKHLWtpHl6Q6pxPSOW71WKim
	Hi5IkTuls+mKPuX+o6ArviX+1YvpNRWQUrf7Ec/2IE7RL1/GR1qwjVVYYieAc89B7Wfo1Qmtuw7
	/qeUelNuUabW9+U/1VKbz6g23+yEclgGIYTHtA96z+hho0FepAf4Y=
X-Received: by 2002:a05:6000:4007:b0:430:fd60:940f with SMTP id ffacd0b85a97d-4378acb14a9mr3575728f8f.14.1770893533196;
        Thu, 12 Feb 2026 02:52:13 -0800 (PST)
X-Received: by 2002:a05:6000:4007:b0:430:fd60:940f with SMTP id ffacd0b85a97d-4378acb14a9mr3575691f8f.14.1770893532783;
        Thu, 12 Feb 2026 02:52:12 -0800 (PST)
Received: from [192.168.122.1] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d30db4sm10838008f8f.4.2026.02.12.02.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 02:52:12 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: require generic MMU notifier implementation
Date: Thu, 12 Feb 2026 11:52:09 +0100
Message-ID: <20260212105211.1555876-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70948-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C649512CB69
X-Rspamd-Action: no action

With s390's switch to MMU notifier, all architectures select
CONFIG_KVM_GENERIC_MMU_NOTIFIER and define KVM_CAP_SYNC_MMU,
so remove the possibility to _not_ have them.

The only intricate Kconfig-ery is powerpc's, but there is
a nice pre-existing BUILD_BUG_ON to tell us that it *does*
in fact require CONFIG_KVM_GENERIC_MMU_NOTIFIER.

Paolo


Paolo Bonzini (2):
  KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
  KVM: always define KVM_CAP_SYNC_MMU

 Documentation/virt/kvm/api.rst | 10 ++++------
 arch/arm64/kvm/Kconfig         |  1 -
 arch/arm64/kvm/arm.c           |  1 -
 arch/loongarch/kvm/Kconfig     |  1 -
 arch/loongarch/kvm/vm.c        |  1 -
 arch/mips/kvm/Kconfig          |  1 -
 arch/mips/kvm/mips.c           |  1 -
 arch/powerpc/kvm/Kconfig       |  4 ----
 arch/powerpc/kvm/powerpc.c     |  6 ------
 arch/riscv/kvm/Kconfig         |  1 -
 arch/riscv/kvm/vm.c            |  1 -
 arch/s390/kvm/Kconfig          |  1 -
 arch/s390/kvm/kvm-s390.c       |  1 -
 arch/x86/kvm/Kconfig           |  1 -
 arch/x86/kvm/x86.c             |  1 -
 include/linux/kvm_host.h       |  7 +------
 virt/kvm/Kconfig               |  8 --------
 virt/kvm/kvm_main.c            | 17 +----------------
 18 files changed, 6 insertions(+), 58 deletions(-)

-- 
2.52.0


