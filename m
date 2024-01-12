Return-Path: <kvm+bounces-6160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8F582C645
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 21:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A407928A3EB
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 20:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B81216426;
	Fri, 12 Jan 2024 20:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxcqXYQe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D20C15AFD
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 20:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d3f3ee00a2so36255085ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 12:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705090394; x=1705695194; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nGDHMJYfkL4nju2+is+kww5uk6KkuyZpMB47n2TaaUU=;
        b=mxcqXYQeOB9ITBNboNB5nhd7iiaUvAfmskFdpFeG3zrxMqD7G337xqU0/N25dV0B+P
         iYnBIViI/2OJA3y1wMLbc6EMVnmNYX7SFipujOklV0tVyFYW+o0Ugxu40QRUuKeyLBKO
         6rsE39ABwOlX2pJnDXC6WsguBamC7cdSyQhabF1cnKkzAGyo6TgdSz4bSvhFBSM3E/el
         LG7vfFWc/Pg4q5ebUg4WNbpdwM5S2VCnbicKFO84nzmsTzIvprEjSwIr14agr4WsCh9r
         UiVuLyjAAjPF5rlDYOVx0V9mVhNE2gUGJTdIcFW+6VtPyUbuQ5aOh+freZDdq4W11CEI
         aIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705090394; x=1705695194;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGDHMJYfkL4nju2+is+kww5uk6KkuyZpMB47n2TaaUU=;
        b=Urj1DBrYZ37PagCbbdDxRPHUlfcroqAaGEE5Yy1hIWCE+CXn61dvwwZmqWfWVdLSnH
         GOJ1yD7UY/SFVO+sUrjvGn9urG3vyWkVK7F934U+Glk2KCyWs3VwjFA3m6AjXunx4H74
         EQMH+HeYout/ExRRIJBNX+4Ps8uuStpwoKSn6a8Opa/ZMLUZeAmi3PSskywZ3gTnjnp+
         5GaSk4R+NiXUva5DqeHBSwbzSiLxwndnM8ZeiU0BG9NecMmGntmR6yZIZDldj8UJHnhm
         vktAB+cZJkXC+0Kw3FQ9tFtN+bZKrqHJDE4lQy/sPXV5JH2w4wr2c/qxid+rP3rMSAoE
         hx2Q==
X-Gm-Message-State: AOJu0Yw5E8Zto+GzE0SvO5FLsOn2acCiIyM7ejNJEJuSf13lf6e1ohO2
	v0Diq+5asiitCpGVXwTg8CWDujvlx4M=
X-Google-Smtp-Source: AGHT+IEtngkUzoEND038XmH9RZI1gcFq6kqKS0vkQph2KQaCA2yYkvEy0unEKKOcrUBcMqrR0mgxtQ==
X-Received: by 2002:a17:902:ee15:b0:1d4:8db0:ab0d with SMTP id z21-20020a170902ee1500b001d48db0ab0dmr1330229plb.48.1705090394174;
        Fri, 12 Jan 2024 12:13:14 -0800 (PST)
Received: from smtpclient.apple ([47.156.165.72])
        by smtp.gmail.com with ESMTPSA id qd5-20020a17090b3cc500b0028ca92ab09asm4578788pjb.56.2024.01.12.12.13.13
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jan 2024 12:13:13 -0800 (PST)
From: Adrian Zankich <adzankich@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: 
Message-Id: <0DA23D59-EA65-438E-BD6D-C85AD3206580@gmail.com>
Date: Fri, 12 Jan 2024 12:12:42 -0800
To: kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3774.300.61.1.2)

Unsubscribe 

