Return-Path: <kvm+bounces-43112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B98AA84F9A
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCF7A4C13A4
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42BA20E717;
	Thu, 10 Apr 2025 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8SXmNSu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595C720DD63
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 22:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744323923; cv=none; b=PQq2v8iChdo7A0zzR+6hQlQnBdNPGVpngTgsmJ6fg0K9qrdP6RsEFbiEfnzKRnvFnVzSiHtkik8rFHm6SR9OeJFHdoxj82t0VCx6Lue7Tbgxe8QjGwAXIc+Ja/ou1h6lXQUdJlP/C9kiTm6w7F1RTHRuIyAPbHqkaCmwDtzlOUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744323923; c=relaxed/simple;
	bh=mfywADYqJ4ew9xI3CclYYcgrZFl/YoOSYDIBc9Dd5cU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmTGb0M1HSNp9O3XsSWZn2MjdLiqXCfcsJo//vwI3bLQDFru0BfBbCffmOA0KkxaJJsKuMSdhROyn2rueEAEXhpR88lhqFZaGSiDarqBXBZXvnG2m105+odugWcAE2hCl2aQum4/NPwAzQ5/LQFvvDYly+l3JzQhR9H09PjgIas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S8SXmNSu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744323921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WYR4fCas43gwQw++5uVITo+VmUSNg0r33Tx+gqd6wEw=;
	b=S8SXmNSuKNQTnB4Daq877bj2Et8qHThCNN/lQ2M/vwfXCo+DWR4PEC7hjLQOxnW7VNFmFJ
	2znL/TpaFdBPBgH+wJ9mNdDsOy0UrwP0nj2q+UGlOY/Lyz+sqBuyHhMAiHfaEBGeSrNvo2
	iwDn+c1l36p2Tc7TNWe5F9dw4Y0cytk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-5O-xJzIsN9C1G4WJf7b2cw-1; Thu, 10 Apr 2025 18:25:19 -0400
X-MC-Unique: 5O-xJzIsN9C1G4WJf7b2cw-1
X-Mimecast-MFC-AGG-ID: 5O-xJzIsN9C1G4WJf7b2cw_1744323919
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-85b45e94b08so13668039f.0
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 15:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744323919; x=1744928719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WYR4fCas43gwQw++5uVITo+VmUSNg0r33Tx+gqd6wEw=;
        b=i3LR815w/Indozr6hCV1pm5iAHdMPiGpyIHU5xr4DzB2Be1pu7HjTQJtFXWcbpDj9c
         a5MvL2Loxv+23yuUPfZTLkfhRy8cZ4sm6zaX+kZ6fThQN3xD4D22NeTOyct5/mG7kLu+
         23iWfTB6hJf6imOmiCCPDiGaTVY6K09qs/xd/c2Ktqf5TxstSMtjXwFXimHMGMVauirQ
         uI9wbduruuTyXsyIbFj7YVcoxL4Z+vxWChxrMupnZJDOnnamsF2zxqtdenfslHRJE4Wr
         nd5xjSDB81bfE1k7UhpLrjM4cJ9LpTuxJjCmVR1mVzgYtxCSFkXMMJG7fHH2tgVD4oBs
         Wd5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWEcvyMezcX3zD7vs9Y0dXuq8aZvkb/2Bu8EAXG/VYP88BA4Ew4dDUzWhDkTXazgfLmqeU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2CMI9Pm9pgJq6V0xwN1lO/GUoAjMZk1oAZmL5IG0m5V2KXpR5
	UlViCvg4qUn4ntKZpbOe5407mrxkfZjDvZaaAoqNF7S/4OyPP8jwkDELAlw4m5ol0QwkeBWJ3oF
	9h1Dv2oZ9tbxnvcZCff5PdACyKKypQkeKag8qqvCXq9Z2yf4JGQ==
X-Gm-Gg: ASbGnct+U5tGSeM7NCr1FbBJ53Kyg6Y7zEBxVIz5kP8itRFxLszdjlGYl8KXz6+e80e
	98XlNMnFu0SIJNu5Qw9fN5oO5ZfEpdnhto0S2GIOTmIzYmhoCHxZyCA1xNI0TkpHhNdvqV92iZ5
	MfL9u2SZa4M2wIAmDdDnRYTv8VJ4jYUTGWfCMrkc0V5bhE+LtbGOOmYzukSyWdwB0gZeb4IVLOv
	LeL6fE0AausuTTtiXPvea+tBMrIZaZTkW1dozV3pDVFXgzLdiFsFwW/arjl/rLjH54DLo1K+K0K
	JcKMdtx8BbCCv/I=
X-Received: by 2002:a05:6602:134b:b0:85e:7974:b0ff with SMTP id ca18e2360f4ac-8617cc2c796mr15150039f.3.1744323918874;
        Thu, 10 Apr 2025 15:25:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQkXdAZ+OEzU4A2DZsacWYyZwm7ExYFaPxcS4RRuyEG/aWoQJVBgD7p6QneavEDnZmQ4ZUXg==
X-Received: by 2002:a05:6602:134b:b0:85e:7974:b0ff with SMTP id ca18e2360f4ac-8617cc2c796mr15148639f.3.1744323918540;
        Thu, 10 Apr 2025 15:25:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2dce4sm941729173.110.2025.04.10.15.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 15:25:17 -0700 (PDT)
Date: Thu, 10 Apr 2025 16:25:16 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, David
 Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, Yong He
 <alexyonghe@tencent.com>
Subject: Re: [PATCH 3/7] irqbypass: Take ownership of producer/consumer
 token tracking
Message-ID: <20250410162516.6ebfa8ee.alex.williamson@redhat.com>
In-Reply-To: <Z_hAc3rfMhlyQ9zd@google.com>
References: <20250404211449.1443336-1-seanjc@google.com>
	<20250404211449.1443336-4-seanjc@google.com>
	<20250410152846.184e174f.alex.williamson@redhat.com>
	<Z_hAc3rfMhlyQ9zd@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Apr 2025 15:04:35 -0700
Sean Christopherson <seanjc@google.com> wrote:
> On Thu, Apr 10, 2025, Alex Williamson wrote:
> > The "token" terminology seems a little out of place after all is said
> > and done in this series.    
> 
> Ugh, yeah, good point.  I don't know why I left it as "token".
> 
> > Should it just be an "index" in anticipation of the usage with xarray and
> > changed to an unsigned long?  Or at least s/token/eventfd/ and changed to an
> > eventfd_ctx pointer?  
> 
> My strong vote is for "struct eventfd_ctx *eventfd;"

WFM, thanks,

Alex


