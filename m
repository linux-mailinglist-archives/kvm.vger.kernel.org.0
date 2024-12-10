Return-Path: <kvm+bounces-33445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8C59EB946
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 19:24:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 850421889E9F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EF0214202;
	Tue, 10 Dec 2024 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQD1UpUL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75486357
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733855073; cv=none; b=ifsrEOwoIsfMyoG52JYkckIfnMhm6isf8WP4RkUFQd+9lPR5E+bFeDFmi2L/uOvTDsC9aRy2VzO05S8wqdgoiLarNH5Q7kDli4sPcjPs+Bwb9GSCFyOlhhfuY7fwKJvPoxxlTJ1nIUgEFlRmsDFAF22NDpuEDk2S/do+gl6uVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733855073; c=relaxed/simple;
	bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLmIFytev/RL9AiRF6zQ52rjb+1BJBn68+wWythPkk+sLBYLd06JrZkvWVylyxUVQUY2sbvusDBqrRiqs2bxmthw59gAK9O4M6ACYrE+tr9eG1q0A5O9uACKrga2jK5yLviIdizbQYfP7wFGhNckEuLMWx5Q6BRLDkH+7l9wfRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQD1UpUL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733855070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
	b=hQD1UpULTwfDyvi7xGmhSj8Wh2IM5Sm28LlxJncFNLWjX5Q97CIQ07SL05XY+mUUqWdbAf
	s9hZsxj5XYZohR58cUno9zTdW1lSIZ4wP9QCGyacEERTS1HywLpPtI5bIkMIk/CglHOx4c
	Rf1WM0PTS0JQFxbBx3tzfuk0UT21dX0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-aXBhC0dmPROaPbOTLTGUUA-1; Tue, 10 Dec 2024 13:24:29 -0500
X-MC-Unique: aXBhC0dmPROaPbOTLTGUUA-1
X-Mimecast-MFC-AGG-ID: aXBhC0dmPROaPbOTLTGUUA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434f7516bf2so12407455e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 10:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733855068; x=1734459868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
        b=LO1VUlaVeYwoBPZUm9emnFC/XIaCqWSJ+4eZnwT50YV4YgwIGStTYUXdB2WSTW5Uys
         +7Z93K8NlyMMg8+SAfjlCQPqTeSjYJIjaKfCaTQ/VBZzdSY61LTmc6ves6R4GmTjzco/
         vr5N3gR6uk0yY0fISAwFs0Ibkfhl+jVWKVVdjJlsptT7NKSW33B6ZKy/L7BKWZ62Qfod
         PrOGnfHHf+IDgal+j5LY28Dh9wia0fx3hg5Rdb6dQ/DCalBVkrIvq7qsr+bKEOozX/fp
         gmNHqJsDgzMkgJrCddI26dDvr5wzpdenOcLDmvTnd0XnVbKPiE7ohfAvmQnBq6Zme6oq
         6ztQ==
X-Forwarded-Encrypted: i=1; AJvYcCVduaPDu+82aSjJ301XzZPrgxtg/DuZAEId81q9je2RHIyj7xfHNL/TsBFC3iUdtzjD2OA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2ylbiOtUVOeubWOTk/OMLAGVv+ZhNe5RjN22/GCg28FnQ2YKa
	kcrbSlgRQQzI1zhQqIKSYP8raWuPC4zQ0gHJ6b9MIsHdML3OwafIAtZCeUxRtC9C0dqSEhNqO9S
	hP/lGA+e0ncZHCVzuBL9mX+WDnGuxhfVTplxtbUdWvbPNbWpibw==
X-Gm-Gg: ASbGncsw/+8gKhNQiN7faTyn6PcxRe2WYaNaExwTTCcsNmah22XrgLFIAtGFLjMrI5Q
	YeKck/mMGpzImWY3Qy8DJdGcWz2KTPo0xd+DvWSMs0BZhrl++nzxcwI6NNV7kbsy3Hdst7uX18Z
	yc0z5j6GBNOKAP8SjL/kXgtX4/40+nXPHdGyMu9Ym+PsbEtcc4mEVn4eYLGSGZhQ0tzka1cjaBF
	E7fPgEV3YZZFQm29AgqStV5t2EzPX8rROE231F6g/4+PUfeCnBElYPf
X-Received: by 2002:a05:6000:4022:b0:386:3672:73e4 with SMTP id ffacd0b85a97d-386469e981amr3473958f8f.26.1733855068208;
        Tue, 10 Dec 2024 10:24:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHx26Gp55ua37c5IiyimVcDcoJIraGmY0UGD9XeA5hsX3pXEMqbHtCokBGh2VOcCbGG9W5FA==
X-Received: by 2002:a05:6000:4022:b0:386:3672:73e4 with SMTP id ffacd0b85a97d-386469e981amr3473943f8f.26.1733855067885;
        Tue, 10 Dec 2024 10:24:27 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d526ac03sm241795075e9.4.2024.12.10.10.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 10:24:27 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: TDX: TDX hypercalls may exit to userspace
Date: Tue, 10 Dec 2024 19:24:19 +0100
Message-ID: <20241210182418.251991-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Applied to kvm-coco-queue, thanks.

Paolo


