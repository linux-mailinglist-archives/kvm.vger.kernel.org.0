Return-Path: <kvm+bounces-33755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0489F138E
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 18:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC1841889065
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B841E47B6;
	Fri, 13 Dec 2024 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCWWL7OD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BB51422D4
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110746; cv=none; b=EtJrPhpD76lT8P/oajieFYWZqT36wyiKeZkI2qaawduTcwiexgjM8D8kt4GyyTaOmMT/CgSpr2FHv2t8WMAqkLRygwNRp3iG0RAvJSy9OXyTinPes9TsedrR80BLGoDBvHhOmkzOxPwD+yCiN9NKhwV7WXrVRRTYJG1G/INX36I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110746; c=relaxed/simple;
	bh=PWttNZ/d2C6Snr5/4Cz41U4gL1QXQzu2vXDcGKnOo5Q=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IHeSNSHnF+aENdWBdHrJeMnyJ5ATQKssNOv4G075VfIZhSYh//gG+ru8PhLx/A0fE+i9ViGdIgl26TIw2aF2w5nm24DkFNufDzaYfn/USDKibPOSwBOJgEwF8qtpJ0POHeYLIvmPUZzaH5swws6uYo3Izaxw1ev1rLLL5XO83SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KCWWL7OD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734110743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/iqb7BLqOjQui+Ht/4wnRt9n4S1PzZdmo3CY2XCaw4=;
	b=KCWWL7ODvFqzLqB58Ic8SikGBbRtT9RnTB5yDWo4Dc+yfs2asZ+5JNMTLGJMLFIbMmb5HN
	/HywTUa1A+0APKkUNi83q1MsnlzHvgwUQjiWcPBsUPQMklGhCL7L6h+x3aoeud7iWUXyEX
	ENdFXZwcwIem41a26aatGHQVPEin2Zs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-h4ZOEHOsNXamFHzgwZX4nw-1; Fri, 13 Dec 2024 12:25:42 -0500
X-MC-Unique: h4ZOEHOsNXamFHzgwZX4nw-1
X-Mimecast-MFC-AGG-ID: h4ZOEHOsNXamFHzgwZX4nw
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a9c9b37244so38015185ab.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 09:25:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734110742; x=1734715542;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T/iqb7BLqOjQui+Ht/4wnRt9n4S1PzZdmo3CY2XCaw4=;
        b=WMS6F513Egz55tl1dxIe87ws9jQRo7Gcf/PTxrBKjEmjhHQo+Kd05fmDvmjRuvT/YG
         S6uCGTWUaPkVABpOzUWBkdPRPSf1MBRrfreaROiIGcZ3FzZWJlNrJn09uG7jmVqB1kIT
         YQE20gUBQ448dK9fZtRkuuFI9qGaBR08kYqWrPIMRsGfuCeExLvymUeNWcM25DnB6Wea
         yR6GFb/qGSaM/UzaSWsSblGXXicG/ikHClGZQpxcMTKOfd4nbJk+it2EtOoBSunHc+m0
         k3uAtOMZ7bQzuwFVPO6IbcTn2fE7sv2htXXJYSWeCIfQDXYzo3A/rkB40KpOYo4juEIy
         3kpw==
X-Forwarded-Encrypted: i=1; AJvYcCUJceuxkLMKVLvj8ytWI52leM1wIDo9Ty9Q3WRCWmJJnfRKZ4nwyyAoXBLJL4NgoMWdGQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfknOiMLvWCl/REkBdXwzC6Y97YSEBst6hqXVx/XePNePXEZ3x
	LYXlOQTjbSP2X1JNJPSV/22EF+kKz3a9ntvvZ7jFuOUX/OsHtfu7bfjBmo0eSEUxFyLpHEfGLDf
	kPhEKqoJvQNpHxePvANKd6a57xfm+kLMg42GrQIQT9/EqUdTbOQ==
X-Gm-Gg: ASbGncsjwFcUFdytophy0ZWJMS9PJOSlbkEmij6KywpksbBMEUu191pVIXwMYUr3BA+
	1NBjIQOWrJwYzUlx4qveiFGnqM4SrmxodNYZ7dZ5OWc5bS0f6yxm02dm/VxYgzxHrp10BxDf9vy
	uwuWUMvx6NFigZUeqAsaIjJ9iN8cQ1eWsOhX1l23uKD1jH+YBH1jBwkuU2ZTsZCkurSUS/wI+tO
	xuNtJhzi+uBlHglTxVxrg4BKJJFRv7vXvkNlLcOtMWJU8WLIab03q3k
X-Received: by 2002:a05:6e02:1561:b0:3a7:6e72:fbb3 with SMTP id e9e14a558f8ab-3afeda2e98emr40139185ab.4.1734110741846;
        Fri, 13 Dec 2024 09:25:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoi9whpO5/SpOzr34w6A/LEMEUcex8O+4ksGXKcQI4nqX0/HXOsNWAAxYOW8UDS6IZA3xhSA==
X-Received: by 2002:a05:6e02:1561:b0:3a7:6e72:fbb3 with SMTP id e9e14a558f8ab-3afeda2e98emr40138925ab.4.1734110741582;
        Fri, 13 Dec 2024 09:25:41 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2ae992f0fsm3129548173.39.2024.12.13.09.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 09:25:40 -0800 (PST)
Message-ID: <1b4c0ac0c01ce86e727022650630d3d94ad516db.camel@redhat.com>
Subject: Re: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple
 Windows VMs hang
From: Maxim Levitsky <mlevitsk@redhat.com>
To: bugzilla-daemon@kernel.org, kvm@vger.kernel.org
Date: Fri, 13 Dec 2024 12:25:40 -0500
In-Reply-To: <bug-218267-28872-wmTSPzaVQh@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
	 <bug-218267-28872-wmTSPzaVQh@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-04-08 at 17:22 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218267
> 
> --- Comment #4 from Sean Christopherson (seanjc@google.com) ---
> On Mon, Apr 08, 2024, bugzilla-daemon@kernel.org wrote:
> > This is not considered a Linux/KVM issue.
> 
> Can you elaborate?  E.g. if this an SPR ucode/CPU bug, it would be nice to know
> what's going wrong, so that at the very least we can more easily triage issues.
> 

Hi!

Any update on this? We seem to hit this bug as well but so far I don't have new details on what is going on.


Best regards,
	Maxim Levitsky


