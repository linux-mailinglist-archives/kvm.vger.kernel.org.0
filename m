Return-Path: <kvm+bounces-17244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF648C2ED3
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 04:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 700A81F22FA6
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 02:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACEC134C6;
	Sat, 11 May 2024 02:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iLvnf4MO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE45E17C73
	for <kvm@vger.kernel.org>; Sat, 11 May 2024 02:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715393333; cv=none; b=O2chXI3m0x6xMJPXS+v5X8cEDnMu1nNusle0mtYlNz27NOHKOy+cJ8267bLPTOQOiavuDyQzO/D6fo6jM92r6ewYcAqH8dHgb2fjdwEzBOv14Ek0qB0KpjZ+ILeW87MPLtZM53dyfoDAAeUX04HjIEZj4N3AhWDJr2p7LUytC/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715393333; c=relaxed/simple;
	bh=np0Z1fuiBcflwNQFi+xKet4c5omvJy3ca0Kw0l8fvlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ClcljcKXGBfbPhwo3yfHBlmFWHTpeOoN0p2WPktD8xek7M6uxgWDCA5Qa8oQoGf2GijiUX6Ovn9NuaupIUBvXQHn4534UZz3Jv/fDQhtAPhGDO1B8HsOLOYzS61K844MXCV25VRW2rIBXxDGvQDeQp7DOW4UvowieynCjY7g+pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iLvnf4MO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715393330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldWbGd4nBvOALfC8J/j4qgg0tc9VFEznhv729dVOtjs=;
	b=iLvnf4MO6RkKT6cspnqRYD4w4M62OTeHmxJjVY4VdPQQClvb2P8BdH456TshOe6knone+c
	lhzy0JwKwQbVWzaxsrKDEgGQrTUvuwVml753LOzKMPOoBaTmDFMEaFULDOJnRG5FnXVAMS
	gWeVtoza4OTaZvOdHhY9M7n04muu+zI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-5-5xop19NCWMpqo4Mu72rA-1; Fri, 10 May 2024 22:08:48 -0400
X-MC-Unique: 5-5xop19NCWMpqo4Mu72rA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6a2369a22a6so9148776d6.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 19:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715393328; x=1715998128;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldWbGd4nBvOALfC8J/j4qgg0tc9VFEznhv729dVOtjs=;
        b=EEw49guSOBrW6j4FCdRBQ+aZYksjJ0W7QELezP5klH99tkJxpcFNGkwPc6gs9TAtT0
         dRdWkUmi1h0yZn9w5wdyIITNMnopFErYGQrLFU/90gjROh0QJM9Ls2o5w6ChByhYXeFI
         TBAu7Aj38JqxyfXcEoVID6jLXSIg4oEgwQlcKZokgX6rnVmWOrN2T4OiJFvqi16ksgBf
         26F2sB3a1vqjv51GeNm2ercFARv1KLGuSmknodlLqtYO2K0B4roL6sjES3bG8mxYE0Nz
         9mrnCavDIkeRkmfDpK+f4yjbZqgmNNzN95Os+OaNVOYfsd0fNL+rQFegKnHBehbc49PG
         cxKw==
X-Forwarded-Encrypted: i=1; AJvYcCXy03kOOdILbcsV/mnD4Fa4a2ixYt2ICRHTCHjgRdAq3wpNxGd/QkMh9QVqgyG/FW/AaYP5XRepMuuwWD3xvSua/+2b
X-Gm-Message-State: AOJu0Yym6Izr96k0P6aD1NBH3sUOoz8ClDanANRVUdiIb9BK3YAmf9FW
	6FltNhLhtwfJjrHq4SSeA+8a5AalDFkI9AE0ag9SfkGUF1X0KWiy2XPWhLmKb5d7zOpiNNzJJ/4
	lBAFacbhXTJ0Pl5jdpfMubSRbQv5PpTUd7s6HjNxy3ErDyM/lfQ==
X-Received: by 2002:a05:6214:419b:b0:6a0:cc6b:1945 with SMTP id 6a1803df08f44-6a16817941dmr47893196d6.9.1715393327999;
        Fri, 10 May 2024 19:08:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjcdgcF/HEKP3kOg3iydqWDJeFoqiukAnH2Rm7lQcejSc9bFnEqxca28/Unv2eur6eVSuRzA==
X-Received: by 2002:a05:6214:419b:b0:6a0:cc6b:1945 with SMTP id 6a1803df08f44-6a16817941dmr47892996d6.9.1715393327577;
        Fri, 10 May 2024 19:08:47 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:8d87:eac1:dae4:8dd4:fe50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf27584asm236681785a.10.2024.05.10.19.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 19:08:46 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Date: Fri, 10 May 2024 23:08:42 -0300
Message-ID: <Zj7TKg9tHTwgWOIQ@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <ZjuFuZHKUy7n6-sG@google.com>
References: <ZjprKm5jG3JYsgGB@google.com> <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop> <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop> <Zjq9okodmvkywz82@google.com> <ZjrClk4Lqw_cLO5A@google.com> <Zjroo8OsYcVJLsYO@LeoBras> <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop> <ZjsZVUdmDXZOn10l@LeoBras> <ZjuFuZHKUy7n6-sG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, May 08, 2024 at 07:01:29AM -0700, Sean Christopherson wrote:
> On Wed, May 08, 2024, Leonardo Bras wrote:
> > Something just hit me, and maybe I need to propose something more generic.
> 
> Yes.  This is what I was trying to get across with my complaints about keying off
> of the last VM-Exit time.  It's effectively a broad stroke "this task will likely
> be quiescent soon" and so the core concept/functionality belongs in common code,
> not KVM.
> 

Hello Sean,

Paul implemented the RCU patience cmdline option, that will help avoiding 
rcuc waking up if the grace period is younger than X miliseconds, which 
means the last quiescent state needs to be at least X miliseconds old.

With that I just have to add a quiescent state in guest_exit(), and we will 
be able to get the same effect of last_guest_exit patch. 

I sent this RFC patch doing that:
https://lore.kernel.org/all/20240511020557.1198200-1-leobras@redhat.com/

Please take a look.

Thanks!
Leo


