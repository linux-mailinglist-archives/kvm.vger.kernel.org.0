Return-Path: <kvm+bounces-58030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F27DB85EB5
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52F0A581A08
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01389314B60;
	Thu, 18 Sep 2025 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OfdDamD7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981DE314D39
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758211701; cv=none; b=hHQOHI6f8y4PtlMee/YSh8YsLFKVuyzDEiM60J+GHExRd309luDsQ5vOHCP7EE3S6LOVzyGjrRo4INUjwPb35nvPU+XAtb8SzVvXDERZzpkUtIPNYtD6ely3QrRX4V3exTG4/XgDTUE6ceXFOJYp/tcA8hBIJHJ77wdzifQbUxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758211701; c=relaxed/simple;
	bh=JL/qBQ0n0kWZf+AaO8KDJFGjeMqMIUgMtsxBe3k+j+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xk0zeVPp8GVPtITj1GJcsvWpwKDMDP1m9rIyweLQRyKVi3gvERK/J3E2ZA5FAQRi1hINQ8ydSnjlzCmmfT7dHJ07JX7WZum12CgRCsMUt62Idt2EdXWIlUW60c7aFvMQERkhgFoijbQB0ZdZN1kgpdQtlw40oOC8fQ5rsij++jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OfdDamD7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758211698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3W1jIekrmUS7hGw0PvTqPX4tAe8HmRxhRJM5xSdG6I=;
	b=OfdDamD7CtXr8TpzCHWpP8QWZVjhi5Xrnff+c6wjcVUlAIU/SguYpfbJtwjeks3aGV4W6w
	XSpCyplTz6hXHitPMp9CbvxPmTtHrUCpSF/xUyjQW8lVXdRvJauKUNwKA6Vc/8FLx8OhJn
	wQ/WOf3l4Bp10kqvM5YxE4m71Mnhi2U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-hpR0zoz1PRGpEFIA9o818g-1; Thu, 18 Sep 2025 12:08:13 -0400
X-MC-Unique: hpR0zoz1PRGpEFIA9o818g-1
X-Mimecast-MFC-AGG-ID: hpR0zoz1PRGpEFIA9o818g_1758211692
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso746163f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758211692; x=1758816492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3W1jIekrmUS7hGw0PvTqPX4tAe8HmRxhRJM5xSdG6I=;
        b=Rj14y63DhdmOwxPdQ7Uxcp37wUE/Jmk0A1ssO/L+sEhG9qinUiI0G0LDAHmqhRyNTK
         RFOKoGgLPnW2nDfjWM/mysmwXGd8wW8NOd3HITyJ8tXQdqWnH8ovNEMkdpLHMhLnJIGx
         p2opA4H3g/Ii7rTr5OrVhWKop+6cJBC1zlmqYU/xv9ZbsywxlpqWAN0ojqxYCdqsHMR5
         LUDCoT4uszlAzY9ueuu35G3cQLIVqY1vBJcGY8+ldkMrkovkclUR8WGu2WnT3QWZwnMZ
         JZm5NWilkEYOk5ZCgXw5h8mMN4V4mVqkpaz7VzaY2KG8x/SkslcIFIeg9LlAZDnhdFcS
         vwBg==
X-Forwarded-Encrypted: i=1; AJvYcCUEuFVgpd5I2IzQ+E1MbCqkzyz4YQQbXUDUnYufRrdlHQoSi9i06P91nJKnTefIIMTAn5o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/hF5bTnVQZTwhS+DlzshidctIbjS+PgsPSgJPga55TZzLmvfz
	cWOpZL0QmwV70LP0i6MOjKEY1A6QsAbO2gNuTC1+0bbOpccjzV/ipIiLYZqHpeeTMHhrx0Wgx5I
	HqkKFHVygw1B0MEpviwZe7AlFV2+J00u4TvcTqQ4/guL0VZ1liF+3zg==
X-Gm-Gg: ASbGncvXGBp+VJy1Ogq9BjMgTQzL3gUcbJNYRcq6rgj1mGoHtvbgw3amvcuKEvF0IKL
	9zRi6dxkHyghdBS8VE2TYg4Ujj/9lOgYqBhZ0gNf9JyzMHZN7veuLm9NlpIOr7FIVvRfbN92f99
	ZB+OZu7xNHPCT1p8JuYbrsU5wlbwwyq1xi9KH9uvCre53vzrwhaogMVkhYt7nnbCo6LHNbS5Dxa
	D0CSZFfo2PqssHulSUPg0T5iWoQri1zMixo3ltx59NNmYqvCXkbxMrh9A6iI0MuOToQFltQQ0gb
	RTspeOnpGYXa86qaVQgiIgruArUTfmIXiUM=
X-Received: by 2002:a05:6000:200e:b0:3eb:f90a:f6cd with SMTP id ffacd0b85a97d-3ecdfa3ce7emr7085257f8f.60.1758211692366;
        Thu, 18 Sep 2025 09:08:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFONswKfp43OXLfg7nMNxh+zteAfi3TDzbvWnbk+eZ4aXLcjPUcMbF4AA2QkD6aFfodROyxZA==
X-Received: by 2002:a05:6000:200e:b0:3eb:f90a:f6cd with SMTP id ffacd0b85a97d-3ecdfa3ce7emr7085210f8f.60.1758211691864;
        Thu, 18 Sep 2025 09:08:11 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee106fd0edsm3919680f8f.53.2025.09.18.09.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 09:08:11 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:08:09 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250918120658-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
 <20250918154826.oUc0cW0Y@linutronix.de>
 <aMwtd40q44q5uqwr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMwtd40q44q5uqwr@google.com>

On Thu, Sep 18, 2025 at 09:04:07AM -0700, Sean Christopherson wrote:
> On Thu, Sep 18, 2025, Sebastian Andrzej Siewior wrote:
> > On 2025-09-18 11:09:05 [-0400], Michael S. Tsirkin wrote:
> > > So how about switching to this approach then?
> > > Instead of piling up fixes like we seem to do now ...
> 
> I don't have a strong preference for 6.17, beyond landing a fix of some kind.
> I think there are three options for 6.17, in order of "least like to break
> something":
> 
>  1. Sebastian's get_task_struct() fix


I am just a bit apprehensive that we don't create a situation
where we leak the task struct somehow, given the limited
testing time. Can you help me get convinced that risk is 0?

>  2. This series, without the KILLED sanity check in __vhost_task_wake()
>  3. This series, with my fixup (with which syzbot was happy)
> 
> Longer term, I'd still like to land everything though.

No problem with that.

> > > Sean?
> > 
> > Since I am in To: here. You want me to resent my diff as a proper patch?
> 
> Ya, I think it makes sense to harden against UAF even if we fix the KVM bug more
> directly.


