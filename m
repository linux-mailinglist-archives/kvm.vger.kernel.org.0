Return-Path: <kvm+bounces-65735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF78CB5061
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5797300B80B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834FB2D12F1;
	Thu, 11 Dec 2025 07:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OLgTWc1l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QoWg319d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0E6156661
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 07:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765439611; cv=none; b=Gy27/9ovaH4tPG7/98ZGllkUWDjFzjwU6eb65K8kmuYsFMLSC6CbLfPnFoiWoTdbTNGk8M27cfFw5M8j4+T1sOiS0qH+jMB4xY0M5igZXycdC6Qz5tRy4HmryTRmJqd7yf3sWZ5SUqKjnL5LB7HsbNSds+qg5XduCW7DvpDCPUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765439611; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiTbHU+35sDJnYuVjbfRjhArN/dcj9KmxCZuymP4FmBu3weNUs9DlFyMtJLC9sTERQtNYZjM4ujdW4kVuhUAzmYQpWv9I3xFPo9+Xz4fZ4+LwUsACZVHeD/H4N+x8IXZaNTqsny/WImjbwGXuBkd52Q8ngi3sDqrWMilx2xde80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OLgTWc1l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QoWg319d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765439609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=OLgTWc1l1LcZ/aYPGs9fRi7es+LfAOF+6gA7Q5kqwalbqhY8xgBnLyA8ByS0JD3RwcFRCQ
	uPyGywmNejUEJtJFTmzvs2M2XODsCdeo4eaAysAxtqY7r0eEtr02Z4mYbzaEgWWD3KJZrd
	SMMqfgn5ijSI434mr8gsgGS+JjRCT/E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-t14CklamMeyp2LskkPOvKQ-1; Thu, 11 Dec 2025 02:53:28 -0500
X-MC-Unique: t14CklamMeyp2LskkPOvKQ-1
X-Mimecast-MFC-AGG-ID: t14CklamMeyp2LskkPOvKQ_1765439607
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47918084ac1so4911555e9.2
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 23:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765439606; x=1766044406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=QoWg319d2aK/DEuE35QgKU7gIjFPjGV4jeBgtGlxmVup51DxKjsIW1qsjaPgqr5Z5M
         IQTvBIWuI7H/K+v67eA+UW6chxJRaQ9UQU5b76RI940VfMgkWk40KEqyc1g81t+BOBrV
         q3QwSfi+MUXIw0PE1tUxHSLevmDf4R71O5VrI/1dD7a+6iS54JB4pL9T4SZcaQT0f/ri
         j/49PSMbsIGpBaHRQAFf0BlLyrnreEzDrqsdU/eFtqLmy6Becum8bKdfepyKxrcMmZxQ
         XZaHFpbewpkRTJd23D9Y0fslnoQM4fPv6EyJH05ysnUB80obEnyFdmo5NhqHL5BNOTxd
         BitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765439606; x=1766044406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=nXSqFlu6X75vNWgeE3XNFrXmfsHABUr+fC3I8YyBOHzPtAtnnULvBs1wTrfi4IawpQ
         GIlk8WVzOGNukFMEe0OdTLtV0uohhxKXqy4zNXyxJ4S9jgVQ3cbigyzUmJBuo4ifHbF0
         FMoLVlICPNcrTNQx4rmF8xUbKRL3XFyw0k8sVKLrVsvZen+kefaJk70bMYuCLkWVGhmF
         osi/Ps1MezIz2Sl68KjikW2pjGS36XinpwfRsXOhfJtMs0W3iuzm/VsNMeVcBs8jI+cx
         TM7xFBSIZuM+gBFlqALcVITYnE3rqBzrkk10jhCN3oXWL65Lb5Vci2NAs9I6SauMfN90
         bcbA==
X-Forwarded-Encrypted: i=1; AJvYcCW4QUQN16CS7apK/dJ9sgdvjXWXUNm1xnf3X/73HJfYHhwKLwWFGa/FQeo4JstCS5XYPBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzibM08FLSYl6UZodLidBpaiUvR/9FuBNgB0zumsIGD6sNqsQi2
	DtYfZCxjUrKzGnK1QupB4tXh+5eMs64+slNY64/Edq4KYy0PNYT0yCKviLwIoPI/aQIZ1EWzAK8
	B8unhlFjWKnq+1/JbBfpOs60yhrGhkTjQ4QiyESjCLisfRLTmIrcEzmWi2Vl/3Q==
X-Gm-Gg: AY/fxX7yJ0ac8E+QNVLaJkbYJKsNN9w9qmzJCuwofuYFq/0hZOp70/FkKcXsy3wqvGK
	VmDvq6v3o7CB+zjTzX7hIi3uH8TGUdPyD6lV283QyLOpWXhbxDRzpfXDCBF8Za7XkXVdugZj0Qj
	x2f0xV/qna/Odip9wJp+cGmqbjymAtj25ojyYTrVcONfD5Iow/gNGYclYsGKYalN9kkmonozxL5
	ms49qqgISNb39aTDJzRObdDVgc1P0cmSKDCnPGsXb3di54a+JNfaGJZMW+CLBtDEKdt1Vksvj+p
	AATJkER6GgzNAFGt2SY+gU25YOB7Hqp/YghE+UutsKW3ruSszzgx59xTbKE9Z2+JhGvGm+BX/OS
	TYPsiackVNMniOxKGFntm4mgd4kCm615RLsEzlw8MgqJ3OFLkTv84v46blBI3WN7CUUp/KPFp8I
	VQHOG48CSxiigY8yg=
X-Received: by 2002:a05:600c:468a:b0:475:da13:2568 with SMTP id 5b1f17b1804b1-47a8384c5eamr53564405e9.25.1765439606460;
        Wed, 10 Dec 2025 23:53:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3SCZC1mg+lEyjtVvHdI3Txv3IsKlN1EU0AqxFFKZz2+WHKw7ArWibsxM6ZbnPQDmK4qhWMQ==
X-Received: by 2002:a05:600c:468a:b0:475:da13:2568 with SMTP id 5b1f17b1804b1-47a8384c5eamr53564035e9.25.1765439606027;
        Wed, 10 Dec 2025 23:53:26 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8a66797sm4129011f8f.2.2025.12.10.23.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 23:53:25 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v5 00/22] i386: Support CET for KVM
Date: Thu, 11 Dec 2025 08:53:21 +0100
Message-ID: <20251211075321.1029031-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
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


