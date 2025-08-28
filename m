Return-Path: <kvm+bounces-56024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EB7B3930D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 07:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 733906849CB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 05:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16641F9EC0;
	Thu, 28 Aug 2025 05:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8IqZHTE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AA642AA3
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 05:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359246; cv=none; b=jPAlULFvastzk6qSqQt1BaiOSq9cYYIslvtNW580FcaTqMBQdV+6Nj+//VxE2IfUEbvWJpYIieE/FQP+FRc0gsFsj464oK3tQWkXqn0of+0RwPM8q/9lZ7uoB7bYmXPKVJdo9b3y2831wQ/L7K0G8zrMAs8IHh2VtFf/DZjtiXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359246; c=relaxed/simple;
	bh=RR7lpuQqeYLcEVhj7QT0U8OTMzDeZHYXUk5wuOg+NIQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rYXIdBpN0lV3XTY9Yx+AMdJjN714IprPRtbmVQuelFkYFRkgiBQhhSARoh2fVrf6jUo5bdIRsvTUGqORDoIMpffjKtTjmid3YL8MwnVmRSZ4/BD2a30aq5xsR0EnLEyUabcaARTHvWRcNsOX5YxgdDoakvwZSauJLiS6q67hJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g8IqZHTE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756359244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RR7lpuQqeYLcEVhj7QT0U8OTMzDeZHYXUk5wuOg+NIQ=;
	b=g8IqZHTEDuuHCkQV4G64U4dcK5XDg/TqYxYIST1KVMErjK4g9UmSUw31NezZv38VCLdYOW
	ykamAyVme9fP6nxgweZLRr7gKMAtvwCMcQ0eeWVcqenujoYl2MagoLf5Ee+ibULbHpxfXc
	3dd5ZJ06d9k6j464ja39cPbWGwqytUM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-RU4w0cFTN2OYnoZwrNtSvQ-1; Thu,
 28 Aug 2025 01:34:00 -0400
X-MC-Unique: RU4w0cFTN2OYnoZwrNtSvQ-1
X-Mimecast-MFC-AGG-ID: RU4w0cFTN2OYnoZwrNtSvQ_1756359239
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15127195609F;
	Thu, 28 Aug 2025 05:33:59 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDC141800446;
	Thu, 28 Aug 2025 05:33:58 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 14EA421E6A27; Thu, 28 Aug 2025 07:33:56 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,  mtosatti@redhat.com,  kvm@vger.kernel.org,
  aharivel@redhat.com
Subject: Re: [PATCH 0/2] A fix and cleanup around
 qio_channel_socket_connect_sync()
In-Reply-To: <20250723133257.1497640-1-armbru@redhat.com> (Markus Armbruster's
	message of "Wed, 23 Jul 2025 15:32:55 +0200")
References: <20250723133257.1497640-1-armbru@redhat.com>
Date: Thu, 28 Aug 2025 07:33:56 +0200
Message-ID: <878qj4huwr.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Ping... your chance to review, silence will be met with a PR ;)


