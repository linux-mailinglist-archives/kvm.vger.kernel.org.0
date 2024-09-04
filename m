Return-Path: <kvm+bounces-25879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD97396BBE6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79917288313
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977461D79B5;
	Wed,  4 Sep 2024 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AGi5zNeS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121F61D2F69
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 12:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725452404; cv=none; b=MHYKgtYQ9DQnmljV8gRWL46YAzhMoYSaRn6rLGqD68GM5TX3KSSPwr+QfNlyjRH8N2JJYb6QL1JMNDYjDj2WxaMjxGrZCxut6g3FTYySeSvbyAovdCMJtdai+JmF42tOfpJbjHAYgwP9mS/4eBasmw/M+yEZ7fo8hHtnYnpCpoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725452404; c=relaxed/simple;
	bh=KGc9QvgVjoaSl0dkn+SZMT3QL+bj6GOpB2lwOgIcp6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvrLtqyVNlhxysAiFAKVztMXjuC8ZUlbEBpzFrdW2zHXHEzi1ZUWjskfmrzbKgt8G8uXMyQG1I2lcbPNuhxyhNltSYyeN0N6MZDE59oinQHojFo2ZFlfUFj+/qZe6GaSnMTTBLzQNfeosKrad8FEPZzW7xt8V/NF36+IQZWe3xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AGi5zNeS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725452400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KGc9QvgVjoaSl0dkn+SZMT3QL+bj6GOpB2lwOgIcp6o=;
	b=AGi5zNeSjzUXIGkrpHsyK6E0CSvrivolxf7MFXIElhMnzDdeYAe3dxXslcMvrJer+jKTBK
	18spGGIjV0z60sNNO1ekCKzdAtt5Y19MyFR2qvmVomN8XhGNI4J2Mnd7lLl3G0QGF5P8Tt
	e4l0Gpu+OZX2WiVw7YQoj0jLwsaa0DM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-39bR4TWgOqa-UDkqvO4yGw-1; Wed, 04 Sep 2024 08:19:58 -0400
X-MC-Unique: 39bR4TWgOqa-UDkqvO4yGw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374c3a31ebcso2327860f8f.1
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 05:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725452397; x=1726057197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGc9QvgVjoaSl0dkn+SZMT3QL+bj6GOpB2lwOgIcp6o=;
        b=KuS2Q+b+GQYTISj9hWJIO8a1kFQcJcay51j5JjlQrEdbwIWvMKTZ7iJvqnZT33Zszu
         XBD5mbNIvmDBoOORCr7fR38w84FVUDDjZ/tL/FpKiJMNSOv0PXo1X69RRIdKQpha4TIr
         CD7wxQaLDPY2WmNhqDRRY1UtO1IsZ8TdeXn06tffoHBmLjg39FH0/brLJSXqqJ1Ou57q
         32X/Fx4XCuZuxPgNXlusgqukB/TG5DbaKTkkV5DEludnnIkgmuGcTZlillhj+OUqL1Yy
         BGM+wX4IWCRlODmb6HpZ9pbyPBhJsUthgX6p5WLWEOcpSTI5Q1jN1d56yFQEV/prt1H+
         UbaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGzObPC5hWszKcs0tDu/qIrGkBKEKpXo8HWNEl+SyNo3mlLGJqQktPngfEzFdtmwXouB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhcdCgLpzwT0AxU3+/5r32iDmOZaHAtQG4buYDFlSYs5l6kc9p
	4L2VPTmNMmF9klLJMvU3xIEUBr1YgpfAdSwha3vcb+BnE6hiDOA8TbEm4qxV+902sNKrQ+AyIXP
	dTks6nFJzL9X3jHS6u9N+LtLX2myMfIOHCSes0Q4jMERGEywm7w==
X-Received: by 2002:adf:a1cb:0:b0:374:c621:3d67 with SMTP id ffacd0b85a97d-376dd15b0a7mr2823662f8f.24.1725452396780;
        Wed, 04 Sep 2024 05:19:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHF/wW82ITfaCikjadIhPTRcqk1hrsgEFwumuQ0D3K+BIDsIED106IQiBx9UCgCO4pD5MjwgQ==
X-Received: by 2002:adf:a1cb:0:b0:374:c621:3d67 with SMTP id ffacd0b85a97d-376dd15b0a7mr2823640f8f.24.1725452396207;
        Wed, 04 Sep 2024 05:19:56 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c24ace8128sm5081591a12.30.2024.09.04.05.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 05:19:55 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm/i386: fix return values of is_host_cpu_intel()
Date: Wed,  4 Sep 2024 14:19:20 +0200
Message-ID: <20240904121919.280127-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240903080004.33746-1-anisinha@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks (reverting the bool->gboolean change; QEMU does not use
g* types and they are kinda deprecated in glib too).

Paolo


