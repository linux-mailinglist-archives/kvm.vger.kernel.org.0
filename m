Return-Path: <kvm+bounces-22180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F1E93B5FF
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1349D2856A5
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76B71607AB;
	Wed, 24 Jul 2024 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkOs1deB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804A7200DE
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842272; cv=none; b=a+4QB97KSMkAu7zQmunyq6UmZDMGjiIoi/Tc8wZVTNfqdoPqb8qTugEzzPB3zQJdGuZK43V9ivnN/GRLhDzRsT3jV9nmH1Ddn9f2T7T5tqM5tpxEbYveKV1tNnP7lswZI7xCDnHl9XHhae+b77fnwAK7CX1GbIY1yRi5p/XP4Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842272; c=relaxed/simple;
	bh=mpsntgB8LddYsgcArz514xiTpy2Sb4zRTiU8FN+RTeU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qMIMOYDyeaYTngQ+UJLn3N7Wr+vMRYzdofC6WhNa9Dm6AgXySpv+j3eiJfRLnW/WmriUJMh6qw8ZGBXnZ2gPCJEoNYKa0COoolfS/4oOTSsP7QB9BXt4EuWRqHoskSDhQV4KkS1Abigw0VDgnUjmpeKT6Sy+IUlX/1j6ONlPYGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hkOs1deB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721842270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kC8UQWRh97IyD5JGa7YOfOZScr4gTwU3R43Eo0fD34A=;
	b=hkOs1deB0dJCZqs0rPSXs2DHAWJK9ZZLpOd5tuHm/ELAMK4UszSH2JyyYyJKCswva4rwVt
	G0jqPdt1jWkWyxEmHfd1lWRPjgicBo8AM+ZqL9+sLmDu4dWahxP0JQkmESMLBZzPFqzj+b
	tSOsWIpDGEzMrOAaFAGRee79XpwBa0c=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-l-fVswheOMWXkhU5iMypcg-1; Wed, 24 Jul 2024 13:31:08 -0400
X-MC-Unique: l-fVswheOMWXkhU5iMypcg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-447e7239ea5so274021cf.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721842268; x=1722447068;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kC8UQWRh97IyD5JGa7YOfOZScr4gTwU3R43Eo0fD34A=;
        b=lxQKiMJvor5Jq4CrYdChuPCbQaASGDOtxgjG8xKDN38MBy1GfUxOsC591ocgkiexZc
         TMkXY+5L2+wNrwvUUb+5QqBpK8brBuE5i+MgonwFlPTxd8qIKTM37Z5Z8DAzmNjGGRN1
         zmxrhVxbZ0nDaiFK3JL8eQDh+np6aXouRUFCskganVHrI0UIunuq3RPMc6fTcFx47UJG
         K8HYbC/dpXL4tByXso9facDZ2O4x4gYt/3Rz0eauYujRDAHg7KOlgw4PwT1456y8tixI
         p05n+bq3IeWAVp3sAzzR5UI0jExFDRcybwtIS75TJcQ3LcurFG2g3wwH7KrJ/8A9zAa7
         O0dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS2vz+5zRNhK+nTqzxsuVWOEXWaA29ICDVTJPdQJVq3ElWWHCEgQArNHRLCfQKqto2MnWi0vlyFfi5NlL+gAij9/je
X-Gm-Message-State: AOJu0YwXym4nSQ3n3n+xQl9HZhY44fqbW7xs41X6usxX8rMs+CDFOHpE
	2xB6VFSZSxUKI/Yd/7Ph0V6WZ2na8DGRXyOZZ/udOYkVQYb0IxStP6OWCFxjUzlWa/zHLUa+lOU
	oVS5gh7sUyU9auTdWI980jnAKTeAY6apVr0wfKTbT7OJESU1sLA==
X-Received: by 2002:a05:6214:124e:b0:6b5:9439:f048 with SMTP id 6a1803df08f44-6bb3c9e18b6mr4147306d6.19.1721842268411;
        Wed, 24 Jul 2024 10:31:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+CTFF1dcJgxOzaL+UHgEN1b5oHLlWnYL5mpea++gifRuH4tZsqextQloB8b501afv5ky36g==
X-Received: by 2002:a05:6214:124e:b0:6b5:9439:f048 with SMTP id 6a1803df08f44-6bb3c9e18b6mr4147026d6.19.1721842268119;
        Wed, 24 Jul 2024 10:31:08 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7b29a0364sm57156046d6.119.2024.07.24.10.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:31:07 -0700 (PDT)
Message-ID: <203755ada291a1366df78c75c57585aff06f30c6.camel@redhat.com>
Subject: Re: [PATCH v2 11/49] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS
 after vCPU creation
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:31:06 -0400
In-Reply-To: <ZoxBV6Ihub8eaVAy@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-12-seanjc@google.com>
	 <dc19d74e25b9e7e42c693a13b6f98565fb799734.camel@redhat.com>
	 <ZoxBV6Ihub8eaVAy@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 19:43 +0000, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > Reject KVM_CAP_X86_DISABLE_EXITS if vCPUs have been created, as disabling
> > > PAUSE/MWAIT/HLT exits after vCPUs have been created is broken and useless,
> > > e.g. except for PAUSE on SVM, the relevant intercepts aren't updated after
> > > vCPU creation.  vCPUs may also end up with an inconsistent configuration
> > > if exits are disabled between creation of multiple vCPUs.
> > 
> > Hi,
> > 
> > I am not sure that PAUSE intercepts are updated either, I wasn't able to find a code
> > that does this.
> > 
> > I agree with this change, but note that there was some talk on the mailing
> > list to allow to selectively disable VM exits (e.g PAUSE, MWAIT, ...) only on
> > some vCPUs, based on the claim that some vCPUs might run RT tasks, while some
> > might be housekeeping.  I haven't followed those discussions closely.
> 
> This change is actually pulled from that series[*].  IIRC, v1 of that series
> didn't close the VM-scoped hole, and the overall code was much more complex as
> a result.
> 
> [*] https://lore.kernel.org/all/20230121020738.2973-2-kechenl@nvidia.com
> 

Hi,
Thanks for the pointer, I searched for this patch series in many places but I couldn't find it.
Any idea what happened with this patch series btw?

Best regards,
	Maxim Levitsky


