Return-Path: <kvm+bounces-52189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA030B0230D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 19:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 719831CC2DEE
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7049E2F1FC8;
	Fri, 11 Jul 2025 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcKZxRnl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EE2F1991
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752255915; cv=none; b=ham02OLvPBny21CAKQPji6QlSGqciR0q7jN+7RIsyhG2+JA2cruhttDqfPsAahveXzTYeZCiM+jBZKjiFw9+79/zHd8FFLae4P/moeUl2/ZG4DcgipcOREIa4V3n5hNRRRyuRNl81Ozvl0U0FElZM6abFm+nNUQmqZ0anXqVbJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752255915; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHMVzWtEBVwIos2fkmxONZkoeWvDhoPz4oxAhEw9blmmBAsaW1UYZsKkEK+qTyZEmvEj92QhC/PqmNiAU9ZSWvFR8QIKa7d7CUJkLicA8x7XgNXXKRICbsJ0ikOGl9ABwujkqCkiKQaomhhw7S8XVlas1Ac84xTOF8Xl3QAN9Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcKZxRnl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752255912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=NcKZxRnlgCaNWHB9e8AWLrRhGxD/+CtFgule6tqOsOXrcV8SU17f+MUNqI5d2KwBf1Lfat
	5WCVVvYgSVQDrVPPwX+CbMfMQKwb6YxnyFJNFKyTKc9uOkOZd5zNzgHYVdweAD89qFp7cO
	O6f/mmKo+Hy4CZ5cCgR0Awj9ctfiTcU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-J6yt-ZN9OYiiO1q1jQzZmw-1; Fri, 11 Jul 2025 13:45:11 -0400
X-MC-Unique: J6yt-ZN9OYiiO1q1jQzZmw-1
X-Mimecast-MFC-AGG-ID: J6yt-ZN9OYiiO1q1jQzZmw_1752255910
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b4a0013c0dso1089206f8f.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752255910; x=1752860710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=PLy7dE4hyYbBekRJiczz5W5IGgk6cm9iq7P39VU+0ydr5F5Qh1YRfxPysEDUuV1qRd
         MUfTpsQNkMyf05Dg+d6JSraD9LtqD8HbMkFbSBqw2llntmHjngmhm+vAr+AGHg2tNzi4
         v6WU1tSeg1j74r1iR7PDMebQWAfNHSDA0wqFv9vXNhyK7WNfive9AvRx+VWfB77YJYju
         ZdvMEVqqCEtdeukRQJmLiuyvtrY3UthYAuRhNSuTVLbSSADB7wwoUQfJIQLSZcEx1Mi0
         NFnjQATrayJV117eNRJMJeQfNTlZ1eCno+ctbQUGfe36wx+IypL5/Oj7Z+PCN9PyPgmw
         22ow==
X-Forwarded-Encrypted: i=1; AJvYcCWk1DhUgAQZe+kbYd8fbZqwnn+VDuiRzQ6JrrO/U37xS1qvCj5nXI7KBH0ouNpPrIgaI4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYpSosI9DEzOPfe7Rx75IRH7ISHwtec7x07vOv+yy2zfE78pAf
	DMUCofNyQTxruUFOZexlc8KPZPG0HcRNbuR7IDO2+roPGerGSqyltbOjE7SDx9Hbc8C1h4ZsbLm
	pqMcdt5wi51jr4pKuUE4G4O3aeq4NSGdQc7seZnZS/QheLYMk2nA8Cw==
X-Gm-Gg: ASbGncv1HQ0yaewvW4knk6r4l6R71AksIfUatz8sPQCmphE6qlMYTuMa4ioAWin5mUY
	CRI/t/QYI1NfM+MG9p3RD1N+UEqHpfuoDA9uSt6EfG/z7MM0+Y6Y2iVy0xw66oh+UNLrM9ctQlN
	o5phrLUFm+X1H1eaXr19xIIy/DjCijev2A7nqQNdyNxXPyJyCCF4dU7PuzYrh0mmRbUiJRJovcs
	SuRu6+A3BWtfHLPa0KOgDsRMyJAqH0EHSPdtwCTGPmkDtgXuh6tRlWJ7MQLFAaZ0UCdrr6joqxs
	AkYbf8znhIdhAAeOCiHUC1dj0/WktCaTfnb88qUC1Ce8
X-Received: by 2002:a05:6000:270b:b0:3a5:3b93:be4b with SMTP id ffacd0b85a97d-3b5f189621cmr3260107f8f.25.1752255910065;
        Fri, 11 Jul 2025 10:45:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7XEYiNnEPmDUdHWfrTeF156IWz7jW19TXB6zmpEx6SVH0RJtIpu/xYWruOw73kE/VGK1D2A==
X-Received: by 2002:a05:6000:270b:b0:3a5:3b93:be4b with SMTP id ffacd0b85a97d-3b5f189621cmr3260086f8f.25.1752255909592;
        Fri, 11 Jul 2025 10:45:09 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.202.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e14e82sm5065771f8f.71.2025.07.11.10.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 10:45:08 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 00/18] i386/cpu: Unify the cache model in X86CPUState
Date: Fri, 11 Jul 2025 19:45:06 +0200
Message-ID: <20250711174506.508152-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.

Paolo


