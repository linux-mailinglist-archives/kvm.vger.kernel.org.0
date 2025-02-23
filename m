Return-Path: <kvm+bounces-38968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D119A40D02
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2025 07:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 652E3189CB9D
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2025 06:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC891DB122;
	Sun, 23 Feb 2025 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYA6fXFK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43FDDDC
	for <kvm@vger.kernel.org>; Sun, 23 Feb 2025 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740292929; cv=none; b=sPpY5GlojRuCzU1+Iq7VXP0sSQbZMpBruVlSA8Qooy/SWfUX2plc4+EuaG1NhP2j9xnlh90SQykhTy8LvtA/faJKKgworHCGzh6DIphKtAqXl0y5++m3r4c69FW0cZXLgz7ol8GYbzpHCFpVHKJwoxxLereo0H/QBjloODuVYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740292929; c=relaxed/simple;
	bh=evK1eCc0v1ctO0+60eOEHU54/BssEl2+DAaOaGXXyYs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=sskRaQQ04kFCyJ4YKwGOmyUsbQp5ICG3xC6gQ71/rv4phdI74d1/CRMeo7KrUgishWmmhq556DisdJnBnNfzu5UtYT60jUqZKEXxw0ZEc3TVpbm/LWm7fReycsTXcvjSdOvi99GOos4p88G0ZV/TIq/Dc8GdXaYDblXtNFhiOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYA6fXFK; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e5dab3f372aso3034013276.1
        for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 22:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740292926; x=1740897726; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=evK1eCc0v1ctO0+60eOEHU54/BssEl2+DAaOaGXXyYs=;
        b=VYA6fXFKRestOymYfXDvNKE3ogvzBhZqSwxM/sBhCA/jXCCCxAY2388qx+t4R3T7Bl
         zFwt3eGQG5fTDis3MhsHUP4w9bZQUFuV2BH2x7QkegEp0Ae1ZBg4ksf7Prt246PdcAA8
         AKcaU1pTPDXG1SzNjkBaBvN8MQkvRkQe1dITO9Z7qVCN4gHWHfwWUU22lfFakY5byjDG
         B/PlqIS19Q0BDGml5C1+uBrCU/Op0sGDRfUB3fXWS31a1ilQUyvBgH1xYqp1ZZ9B92qp
         13qnG7nRhwUongasBB7baxD+Ff6P5P9FIeN28M6fhzo86RvbkbsURWDJIcoZuT2apfU2
         7b3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740292926; x=1740897726;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=evK1eCc0v1ctO0+60eOEHU54/BssEl2+DAaOaGXXyYs=;
        b=DXhXMlXujMRjBYLQLcxGWQmI7hbwBxAR4eFhnJScNTGQg6iQP0cn8bkNJTCs/VBR6O
         yMjbwxhiLv8VDa10wj4M2YIX/59D2UXZ9yBd3gwMRu+siPiedd2rsKZip0F+3197qnGH
         NEB5+ZbEoDBu3KsVHhrSZYnNHg7r2mQhoKVh66eznmM0BkSw2GKS7kfdksN7uo+728xo
         DXA9m7FtgPR6seseChQbjvRDuUjrTijtbNHCJsX6yhARiBEtoSzWj6P4ja74pLFNFTc7
         9Rb9j5uzmbZPSmblb+AL/jOpwbN13toyjJVQibKt2cErzUoZf1ibYzJ6MKZ0S5vVMtp4
         H2zw==
X-Gm-Message-State: AOJu0YyJxOKQTSTFLDfW9QoDjamR+di1USgMLmNSb5tr7AODxfWq8dJK
	xCKmx8RNl2DUD31LTHVVcqEkpl90txO0weYCcfFNe26+j69a0J1AR1qcAFOemwaIEPJCmfIFGX3
	FHO2iDrU6llhiRbkW7TfagQEBa9oTyPHGNT0=
X-Gm-Gg: ASbGncuLzJFgXLxOSk+bZTjJc9VpCii6hqLmPX1CqosxqsSC2PeCJgN01SKga/pDaZe
	1lSQBJkcBm0dkqm/NGEzZUqNOzd2lsemEeSSOGIS9HhcYNHpYtL7NIhyl8p6ua+T8cAFZIDurQV
	CAjm+Ucm8EU46yywqZhrHypUqfS/zMDB0vTPmBnP40
X-Google-Smtp-Source: AGHT+IHdky3zTVeaQD0nyGXWWNuxh77R3cG8bVkq+0qJezGBzkIGYGd2biMKdI57BK05HXT9jGnzSZq3ZEzjsCvPxMs=
X-Received: by 2002:a05:6902:220a:b0:e5b:32f5:e38c with SMTP id
 3f1490d57ef6-e5e1918edffmr10521389276.8.1740292926550; Sat, 22 Feb 2025
 22:42:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: kinshuk <kinshukkataria4@gmail.com>
Date: Sun, 23 Feb 2025 06:41:55 +0000
X-Gm-Features: AWEUYZlBC4mPhGmg2yAwWmBjBtMMuY4eonK7LQedQcLTPNZOhaJlZ0yvAF2K1T4
Message-ID: <CAODyg8K+L0wNPwCqU=Me6WGAD7K5ufzaD1y7mOb8Tbr7sN967A@mail.gmail.com>
Subject: [RFC]: Zeroing out mem immediately when the vm closes
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I have been reading kvm related code and what I found was that pages
don't zero out immediately when the vm closes but rather marks it as
free for other processes to use and override.

While that is great, memory can be zeroed out by utilizing the free
threads unallocated by the vm and using memset upon vm exit and
depending on how much mem is in need to be zeroed out it can takes
milliseconds to a few seconds which mainly comes with a memory
bandwidth cost which isn't a huge deal unless the machine is doing
memory intensive tasks which can be solved by adding a flag to disable
automatic zeroing mem?

And using something like intel tdx might not be viable since they are
mainly for datacenter cpus and most likely not available in consumer
cpus

