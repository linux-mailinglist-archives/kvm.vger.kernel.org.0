Return-Path: <kvm+bounces-43107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED08AA84F2F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A34C9A7F3F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 21:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D192C293478;
	Thu, 10 Apr 2025 21:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D7bUe9P+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B820D4EA
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 21:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744320537; cv=none; b=ePuMA6wuVSIEIRqTWbMdR0V6+4oYWyjjxV8Z0fkPpYe8Bt1yU4/qIJRosu00wmPR4eCWZl/9uVNIUEpRdr5Tm0mL+wCbhaEyf45B8o/er+YnbtaqXd9c3HXw0EAhFmtRZCYrwh/8wH/NB2iBoA6rs7z86wgGdAmX/n9bidRCZuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744320537; c=relaxed/simple;
	bh=PQyLMk4yD/KMsB1XsXeHfOQCgylwKZk+b6OaxBJWI7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZzoZuswvPQdxVSeBfIa/GUaI6VuNmjhDOV6KKfMPnXMecPU94r++kURyHrNb7+TilmLeRuFRrbVSOEtIZDc+7n19UureRnvdZ3BDGytxoytbKCMQ2HOmEAMxdK6AhdwCE3Er+LjhBAJk9fhkZNC9nWbu/unNkTU388f0/i6isk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D7bUe9P+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744320534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7wUygALbmEVMFAt4v+g0d0hTcs9oRhp7Sgk/twG05FU=;
	b=D7bUe9P+uuUCgkLxwrATaynkYI5/P8/yiHNHAko2bw3hpNsT7mPtu6SPDan+7ID8mYoeFO
	zYrLSjGYJV+9uxUi3s6IjxoWsOwjwCsWi6JvHEKTcyjm+0LSCkRggc2VE6wyOTp+Puh3bn
	qXB6ua7QrkBwNrLja8VVWPwGl/gUXuQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-7iq9anw1MKSoY--77lrzjw-1; Thu, 10 Apr 2025 17:28:52 -0400
X-MC-Unique: 7iq9anw1MKSoY--77lrzjw-1
X-Mimecast-MFC-AGG-ID: 7iq9anw1MKSoY--77lrzjw_1744320532
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b3e93e052so13876239f.3
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 14:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744320532; x=1744925332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7wUygALbmEVMFAt4v+g0d0hTcs9oRhp7Sgk/twG05FU=;
        b=JqzqK5vb7hGtPQ9BFzS1f/C4wjydl59bP2z2ZPyVN4coR+alSis/2pwmGPvzg//lS1
         SVz9XFEDXwwQovcXAdz6VbxTQiPmww2UdZ3EobdQwK8GC09VrzZukAzV42PEM9b+rE0Z
         JeXl5qO2P7K9uOMj1c9kSVC5fSJS9QFx0hOH1zoq+E2IWhSFwcW1XQ4o6RbYOCOcnWQr
         8E/kAcRuTL+zJwdejekyFTN5ZhBtRP8yUOSFyI9s2Cz5h6lzF2lytbweGJ5n+kIHv0mf
         1D7i7jHQsHxCCxcXU5Zibeil19hNIWNUn43B8qH1kMbMhlbr+W81rvDl+A0AMhedNWHH
         yVRA==
X-Forwarded-Encrypted: i=1; AJvYcCWG1GME1Jc/EJQF2SohCBerBGKH++g8EAeN4UsYyplG4Nat2lyXl660hDiRyvUgPF57CWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4kJFXHFqvkR70OepPLSJOdLJ9pTkK2gkYRBcAiiWJnSEvERDj
	T5A/1zF38pX5PRDcZUxGk8H5u3CE/ZeMBqrBs3FRfeDNf3fXo7Lc4gA2tHG3m7GHS6rRV4x7ht5
	SFCIgsUTY9lPUF7O6aOknTG+PwszUcITSsCWXGmtf5/miY+7chA==
X-Gm-Gg: ASbGncu15t4FPdhZ9eINPj3yCK/pITlhylTN58+mnh3ZsgY/1wJWPhD6UgpNHR0fE6V
	e19B8QCG/h/oJbbgrM5lVWRH3uQXqrGYObGvchzPhRDs+VqwST7LVzI06YRWlMjGsmF6aAkPuj4
	BrjdvMI588YTBck/STurz8KaJ7tM5f5k5gn/6GGHvOsIA7/x59a+pifvK8J5A2VHXWYxqJ7qqX/
	bJSSjbTcgQRkeYpdEEdGu1WiLczEjRaZsmRM4ulvwigg5b6xYkEkD+FntItv6UE8As25AZyq2fp
	7Pu6qBjJmHJ1qUo=
X-Received: by 2002:a05:6602:6019:b0:85e:5cbc:115 with SMTP id ca18e2360f4ac-8617cb5482dmr14195339f.1.1744320532152;
        Thu, 10 Apr 2025 14:28:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGObbSU7MqLRum1IP35oPdq16S0/HCvuDlUPSjApwT5xtjRxU2hDxipatt8y3sRp60U+ll1fA==
X-Received: by 2002:a05:6602:6019:b0:85e:5cbc:115 with SMTP id ca18e2360f4ac-8617cb5482dmr14194539f.1.1744320531830;
        Thu, 10 Apr 2025 14:28:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505d1873bsm923375173.48.2025.04.10.14.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 14:28:49 -0700 (PDT)
Date: Thu, 10 Apr 2025 15:28:46 -0600
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
Message-ID: <20250410152846.184e174f.alex.williamson@redhat.com>
In-Reply-To: <20250404211449.1443336-4-seanjc@google.com>
References: <20250404211449.1443336-1-seanjc@google.com>
	<20250404211449.1443336-4-seanjc@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Apr 2025 14:14:45 -0700
Sean Christopherson <seanjc@google.com> wrote:
> diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
> index 9bdb2a781841..379725b9a003 100644
> --- a/include/linux/irqbypass.h
> +++ b/include/linux/irqbypass.h
> @@ -10,6 +10,7 @@
>  
>  #include <linux/list.h>
>  
> +struct eventfd_ctx;
>  struct irq_bypass_consumer;
>  
>  /*
> @@ -18,20 +19,20 @@ struct irq_bypass_consumer;
>   * The IRQ bypass manager is a simple set of lists and callbacks that allows
>   * IRQ producers (ex. physical interrupt sources) to be matched to IRQ
>   * consumers (ex. virtualization hardware that allows IRQ bypass or offload)
> - * via a shared token (ex. eventfd_ctx).  Producers and consumers register
> - * independently.  When a token match is found, the optional @stop callback
> - * will be called for each participant.  The pair will then be connected via
> - * the @add_* callbacks, and finally the optional @start callback will allow
> - * any final coordination.  When either participant is unregistered, the
> - * process is repeated using the @del_* callbacks in place of the @add_*
> - * callbacks.  Match tokens must be unique per producer/consumer, 1:N pairings
> - * are not supported.
> + * via a shared eventfd_ctx).  Producers and consumers register independently.
> + * When a producer and consumer are paired, i.e. a token match is found, the
> + * optional @stop callback will be called for each participant.  The pair will
> + * then be connected via the @add_* callbacks, and finally the optional @start
> + * callback will allow any final coordination.  When either participant is
> + * unregistered, the process is repeated using the @del_* callbacks in place of
> + * the @add_* callbacks.  Match tokens must be unique per producer/consumer,
> + * 1:N pairings are not supported.
>   */
>  
>  /**
>   * struct irq_bypass_producer - IRQ bypass producer definition
>   * @node: IRQ bypass manager private list management
> - * @token: opaque token to match between producer and consumer (non-NULL)
> + * @token: IRQ bypass manage private token to match producers and consumers

The "token" terminology seems a little out of place after all is said
and done in this series.  Should it just be an "index" in anticipation
of the usage with xarray and changed to an unsigned long?  Or at least
s/token/eventfd/ and changed to an eventfd_ctx pointer?  Thanks,

Alex


