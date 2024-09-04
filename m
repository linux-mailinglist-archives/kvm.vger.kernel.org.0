Return-Path: <kvm+bounces-25876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921D196BBDE
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D592286777
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A2C1D88AC;
	Wed,  4 Sep 2024 12:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WXREKwDb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E6F1D799E
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 12:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725452314; cv=none; b=UrLNwMqCbGzVscTrXTsdmY0GA2jx5r4GflOTGDlUgfMQcjRzwBLTyZvjy3CosH9iOIIexd8UWbfvLa+FOERorcIG+oNh0GXHPIrbCJkSJjFA8xAgLmnQKMpmQ9TbGAH9wohJ9bIYmkEif+ni/IzgJfPzbXmH9+lvxX7UopCmEOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725452314; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjVVHYC9nF3G/Sddwv0v2NjeUtf0U59fYm6HUw07X5kc5ez9n2Oy8E282BGZpz4/eHoeak058pdMq9+mH72iJcvFrqiLMoHLfjllAT5dIPIMwWlcKJQcHMHIcrmF2xBY/W+8Zet/ARn0rXCOQJJXcXj8uj2+ASBLozu2fdeBCYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WXREKwDb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725452311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=WXREKwDb+1z2B8PQ8qaHrre6k2WPwCofVBPKBjPTk0iNjCMozPx6y1kV78MNSHKzZuprHo
	N3cyiRmBML5CZ9whthAkDfPGNKpYzz+jFLRGcPanUO+MiVOi11q5e2tYIcyKfKAxnGYCzf
	B/PHD2IwBKlPmsBCZK0c+X+Mp/y51tw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-Bina7-zEP6K1zImvx77ESg-1; Wed, 04 Sep 2024 08:18:30 -0400
X-MC-Unique: Bina7-zEP6K1zImvx77ESg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5c244732fe0so3899600a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 05:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725452308; x=1726057108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=nVy++tVFpyrsuY6uXbbrnKrRlZB+jBKGcU9M0yl7TsuaGfASKetkRIUpkVkqfsg8ur
         ndTIzjlPU6W35pQpYk61GlDXjmNEYoPD6lQdetnrB9SYPDMvlMWgpkOfcjXaj+mrtn3y
         YlspeJDgpX5Ez02wDdlZOo4jxT8vqUBEwLB1YmKrJuWV243o98uiKzv+WTWaW+rP0LXz
         ijRajcnMGxzprswXWqApayYO3DeyoOYN/DJ4nnCNJxntMAVvZTFKy2gZJiP2eFiLCKfx
         XY75XSaEW1ZP9fLmQ5xEdnv4O+aoNQQmDG9mGmFXxl9QkM13qJxIA4QE1EWlH9Jmn0Je
         lTgA==
X-Forwarded-Encrypted: i=1; AJvYcCWuDcG3220sWzp16tFRKOxg/kkVAbfiD6rD+bFSlKH2IHKQf9b5XCmc60IpJLTcQsDl7iY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsQQSq9PoxK2oWOp+VgeCWb/EjlxwZwLT0JDIFDXoiwi1UEuVa
	0tY0qfXUADBDhIq+qOF7VQ5JQj2REPjgRT/rGq00jpGDnxs82yBMSaZE/3SK7a0hZ8sBIKLp7GE
	qgJYX63dkNxPZhtGh4YpdIUZYcv66w9rh1HDSA+gKFtOhGC1nDA==
X-Received: by 2002:a05:6402:5109:b0:5c2:6bcd:f6af with SMTP id 4fb4d7f45d1cf-5c2757cefccmr2755815a12.1.1725452307776;
        Wed, 04 Sep 2024 05:18:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxvZGZ+CXLF+BO8Fb3vGxvEvg/Sz+txqAK/+ZP+dLSRUU5wDK3OwAq0iF4xr71oELwsYlksA==
X-Received: by 2002:a05:6402:5109:b0:5c2:6bcd:f6af with SMTP id 4fb4d7f45d1cf-5c2757cefccmr2755796a12.1.1725452307247;
        Wed, 04 Sep 2024 05:18:27 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226cd18a3sm7480202a12.66.2024.09.04.05.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 05:18:26 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v3] kvm/i386: make kvm_filter_msr() and related definitions private to kvm module
Date: Wed,  4 Sep 2024 14:18:23 +0200
Message-ID: <20240904121823.279720-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240903140045.41167-1-anisinha@redhat.com>
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


